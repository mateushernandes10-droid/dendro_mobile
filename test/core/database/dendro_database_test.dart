import 'package:dendro_mobile/core/database/dendro_database.dart';
import 'package:dendro_mobile/features/inventory_runs/data/inventory_runs_repository.dart';
import 'package:dendro_mobile/features/plots/data/plots_repository.dart';
import 'package:dendro_mobile/features/properties/data/properties_repository.dart';
import 'package:dendro_mobile/features/results/data/results_repository.dart';
import 'package:dendro_mobile/features/stands/data/stands_repository.dart';
import 'package:dendro_mobile/features/tree_collection/data/trees_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DendroDatabase database;

  setUp(() {
    database = DendroDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('cria catalogos iniciais de especies e formulas', () async {
    final species = await database.select(database.species).get();
    final formulas = await database.select(database.formulas).get();
    final variables = await database.select(database.formulaVariables).get();
    final coefficients = await database
        .select(database.formulaCoefficients)
        .get();

    expect(
      species.map((item) => item.name),
      containsAll(['Pinus', 'Eucalyptus']),
    );
    expect(
      formulas.map((item) => item.name),
      containsAll(['Modelo de Spurr', 'Schumacher-Hall']),
    );
    expect(variables, hasLength(4));
    expect(coefficients, hasLength(5));
  });

  test('repositorio cadastra e busca propriedade', () async {
    final repository = PropertiesRepository(database);

    final id = await repository.create(
      name: 'Fazenda Esperança',
      municipality: 'Vacaria',
      totalAreaHa: 158.17,
    );

    final results = await repository.searchByName('Esperança');

    expect(results, hasLength(1));
    expect(results.single.name, 'Fazenda Esperança');
    expect(results.single.state, 'RS');
    expect(results.single.totalAreaHa, 158.17);

    await repository.update(
      id: id,
      name: 'Fazenda Esperança Editada',
      municipality: 'Vacaria',
      state: 'RS',
      totalAreaHa: 160,
    );

    final updated = await repository.findById(id);
    expect(updated?.name, 'Fazenda Esperança Editada');
    expect(updated?.totalAreaHa, 160);

    await repository.delete(id);
    expect(await repository.searchByName('Esperança'), isEmpty);
  });

  test(
    'repositorio cadastra talhao vinculado a propriedade e especie',
    () async {
      final propertiesRepository = PropertiesRepository(database);
      final standsRepository = StandsRepository(database);

      final propertyId = await propertiesRepository.create(
        name: 'Fazenda Esperança',
        municipality: 'Vacaria',
        totalAreaHa: 158.17,
      );
      final species = await standsRepository.watchActiveSpecies().first;
      final pinus = species.firstWhere((item) => item.name == 'Pinus');

      await standsRepository.create(
        propertyId: propertyId,
        identification: 'Talhão 42-B',
        speciesId: pinus.id,
        areaHa: 45.2,
        plantingYear: 2012,
        spacing: '3 x 2 m',
      );

      final stands = await standsRepository.watchByProperty(propertyId).first;

      expect(stands, hasLength(1));
      expect(stands.single.stand.identification, 'Talhão 42-B');
      expect(stands.single.stand.areaHa, 45.2);
      expect(stands.single.stand.plantingYear, 2012);
      expect(stands.single.species.name, 'Pinus');
      expect(stands.single.hasActiveInventory, isFalse);
    },
  );

  test('repositorio cria parcela planejada e inicia levantamento', () async {
    final propertiesRepository = PropertiesRepository(database);
    final standsRepository = StandsRepository(database);
    final plotsRepository = PlotsRepository(database);
    final inventoryRunsRepository = InventoryRunsRepository(database);

    final propertyId = await propertiesRepository.create(
      name: 'Fazenda Teste',
      municipality: 'Vacaria',
      totalAreaHa: 80,
    );
    final species = await standsRepository.watchActiveSpecies().first;
    final pinus = species.firstWhere((item) => item.name == 'Pinus');

    final standId = await standsRepository.create(
      propertyId: propertyId,
      identification: 'T-01',
      speciesId: pinus.id,
      areaHa: 12.5,
    );

    final initialState = await plotsRepository.watchStandPlots(standId).first;
    expect(initialState.plots, isEmpty);
    expect(initialState.stand.identification, 'T-01');
    expect(await database.select(database.inventoryRuns).get(), isEmpty);

    await plotsRepository.createPlannedPlot(standId: standId, areaHa: 0.04);

    final updatedState = await plotsRepository
        .watchStandPlots(standId)
        .firstWhere((state) => state.plots.isNotEmpty);

    expect(updatedState.plots.single.plot.identification, 'P01');
    expect(updatedState.plots.single.plot.status, PlotStatus.pending);
    expect(updatedState.plots.single.plot.areaHa, 0.04);
    expect(
      updatedState.plots.single.inventoryRun.status,
      InventoryRunStatus.planning,
    );

    await plotsRepository.startNewInventoryForStand(standId);

    final runs = await database.select(database.inventoryRuns).get();
    final talhaoLevantamentos = await database
        .select(database.talhaoLevantamentos)
        .get();

    expect(runs, hasLength(1));
    expect(runs.single.status, InventoryRunStatus.inProgress);
    expect(talhaoLevantamentos, hasLength(1));

    final activeStandState = await plotsRepository
        .watchStandPlots(standId)
        .firstWhere((state) => state.activeTalhaoLevantamento != null);

    expect(
      activeStandState.activeTalhaoLevantamento!.inventoryRunId,
      runs.single.id,
    );

    final propertyStands = await standsRepository
        .watchByProperty(propertyId)
        .firstWhere((items) => items.any((item) => item.hasActiveInventory));

    expect(propertyStands.single.hasActiveInventory, isTrue);

    final activeRun = await inventoryRunsRepository.watchLatestActive().first;

    expect(activeRun, isNotNull);
    expect(activeRun!.property.name, 'Fazenda Teste');
    expect(activeRun.standLabel, 'T-01');
    expect(activeRun.plotCount, 1);
    expect(activeStandState.nextPlotIdentification, 'P02');

    expect(
      () => plotsRepository.startNewInventoryForStand(standId),
      throwsA(isA<ActiveInventoryForStandException>()),
    );

    await plotsRepository.createPlannedPlot(standId: standId, areaHa: 0.04);

    final stateWithNewPlannedPlot = await plotsRepository
        .watchStandPlots(standId)
        .firstWhere((state) => state.plots.length == 2);
    final identifications = stateWithNewPlannedPlot.plots
        .map((summary) => summary.plot.identification)
        .toSet();

    expect(identifications, containsAll(['P01', 'P02']));
    expect(stateWithNewPlannedPlot.nextPlotIdentification, 'P03');

    final secondStandId = await standsRepository.create(
      propertyId: propertyId,
      identification: 'T-02',
      speciesId: pinus.id,
      areaHa: 8,
    );
    await plotsRepository.startNewInventoryForStand(secondStandId);

    final secondStandState = await plotsRepository
        .watchStandPlots(secondStandId)
        .firstWhere((state) => state.activeTalhaoLevantamento != null);

    final activeRuns = await inventoryRunsRepository.watchActive().first;

    expect(secondStandState.plots, isEmpty);
    expect(activeRuns, hasLength(2));

    final allRuns = await inventoryRunsRepository.watchAll().first;

    expect(allRuns, hasLength(3));
    expect(
      allRuns.where(
        (summary) => summary.run.status == InventoryRunStatus.inProgress,
      ),
      hasLength(2),
    );
    expect(
      allRuns.where(
        (summary) => summary.run.status == InventoryRunStatus.planning,
      ),
      hasLength(1),
    );
  });

  test('repositorio coleta arvore e encerra parcela', () async {
    final propertiesRepository = PropertiesRepository(database);
    final standsRepository = StandsRepository(database);
    final plotsRepository = PlotsRepository(database);
    final treesRepository = TreesRepository(database);
    final inventoryRunsRepository = InventoryRunsRepository(database);

    final propertyId = await propertiesRepository.create(
      name: 'Fazenda Coleta',
      municipality: 'Vacaria',
      totalAreaHa: 80,
    );
    final species = await standsRepository.watchActiveSpecies().first;
    final pinus = species.firstWhere((item) => item.name == 'Pinus');

    final standId = await standsRepository.create(
      propertyId: propertyId,
      identification: 'T-02',
      speciesId: pinus.id,
      areaHa: 10,
    );

    final talhaoLevantamento = await plotsRepository.startNewInventoryForStand(
      standId,
    );
    final plotId = await plotsRepository.createPlotForTalhaoLevantamento(
      talhaoLevantamentoId: talhaoLevantamento.id,
      areaHa: 0.04,
    );

    final firstTreeId = await treesRepository.createTree(
      plotId: plotId,
      draft: TreeDraft(
        dapCm: 31.5,
        heightM: 22.7,
        hasTortuousStem: false,
        latitude: -28.5123,
        longitude: -50.9123,
        accuracyMeters: 4.5,
        locationCapturedAt: DateTime(2026, 8, 15, 10),
        plotReferencePosition: PlotReferencePosition.p1,
      ),
    );

    var state = await treesRepository.watchCollection(plotId).first;

    expect(state.trees, hasLength(1));
    expect(state.trees.single.number, 1);
    expect(state.trees.single.dapCm, 31.5);
    expect(state.plot.status, PlotStatus.inProgress);
    expect(state.geoPoints, hasLength(1));
    expect(state.geoPoints.single.referencePosition, PlotReferencePosition.p1);

    final replacementTreeId = await treesRepository.createTree(
      plotId: plotId,
      draft: TreeDraft(
        dapCm: 29.2,
        heightM: 21.1,
        hasTortuousStem: false,
        latitude: -28.6123,
        longitude: -50.8123,
        accuracyMeters: 3.8,
        locationCapturedAt: DateTime(2026, 8, 15, 11),
        plotReferencePosition: PlotReferencePosition.p1,
      ),
    );

    state = await treesRepository.watchCollection(plotId).first;
    final firstTree = state.trees.firstWhere((tree) => tree.id == firstTreeId);
    final replacementTree = state.trees.firstWhere(
      (tree) => tree.id == replacementTreeId,
    );

    expect(state.trees, hasLength(2));
    expect(firstTree.plotReferencePosition, isNull);
    expect(replacementTree.plotReferencePosition, PlotReferencePosition.p1);
    expect(state.geoPoints, hasLength(1));
    expect(state.geoPoints.single.latitude, closeTo(-28.6123, 0.00001));
    expect(state.geoPoints.single.longitude, closeTo(-50.8123, 0.00001));

    await treesRepository.markPlotCollected(plotId);
    state = await treesRepository.watchCollection(plotId).first;

    expect(state.plot.status, PlotStatus.collected);

    await inventoryRunsRepository.completeRun(
      talhaoLevantamento.inventoryRunId,
    );

    final completedRuns = await database.select(database.inventoryRuns).get();
    expect(completedRuns.single.status, InventoryRunStatus.completed);
    expect(completedRuns.single.completedAt, isNotNull);
    expect(await inventoryRunsRepository.watchActive().first, isEmpty);

    await plotsRepository.startNewInventoryForStand(standId);
    final runsAfterRestart = await database
        .select(database.inventoryRuns)
        .get();
    expect(runsAfterRestart, hasLength(2));
    expect(
      runsAfterRestart.where(
        (run) => run.status == InventoryRunStatus.inProgress,
      ),
      hasLength(1),
    );
  });

  test('repositorio de resultados calcula dashboard com filtros', () async {
    final propertiesRepository = PropertiesRepository(database);
    final standsRepository = StandsRepository(database);
    final plotsRepository = PlotsRepository(database);
    final treesRepository = TreesRepository(database);
    final resultsRepository = ResultsRepository(database);

    final propertyId = await propertiesRepository.create(
      name: 'Fazenda Resultado',
      municipality: 'Vacaria',
      totalAreaHa: 100,
    );
    final species = await standsRepository.watchActiveSpecies().first;
    final pinus = species.firstWhere((item) => item.name == 'Pinus');
    final eucalyptus = species.firstWhere((item) => item.name == 'Eucalyptus');

    final pinusStandId = await standsRepository.create(
      propertyId: propertyId,
      identification: 'P-01',
      speciesId: pinus.id,
      areaHa: 10,
    );
    final eucalyptusStandId = await standsRepository.create(
      propertyId: propertyId,
      identification: 'E-01',
      speciesId: eucalyptus.id,
      areaHa: 12,
    );

    final pinusTalhao = await plotsRepository.startNewInventoryForStand(
      pinusStandId,
    );
    final pinusPlotId = await plotsRepository.createPlotForTalhaoLevantamento(
      talhaoLevantamentoId: pinusTalhao.id,
      areaHa: 0.04,
    );
    await treesRepository.createTree(
      plotId: pinusPlotId,
      draft: const TreeDraft(dapCm: 20, heightM: 10, hasTortuousStem: false),
    );
    await treesRepository.createTree(
      plotId: pinusPlotId,
      draft: const TreeDraft(dapCm: 25, heightM: 14, hasTortuousStem: false),
    );
    await treesRepository.markPlotCollected(pinusPlotId);

    final eucalyptusTalhao = await plotsRepository.startNewInventoryForStand(
      eucalyptusStandId,
    );
    final eucalyptusPlotId = await plotsRepository
        .createPlotForTalhaoLevantamento(
          talhaoLevantamentoId: eucalyptusTalhao.id,
          areaHa: 0.05,
        );
    await treesRepository.createTree(
      plotId: eucalyptusPlotId,
      draft: const TreeDraft(dapCm: 30, heightM: 18, hasTortuousStem: false),
    );

    final options = await resultsRepository.watchFilterOptions().first;
    expect(options.properties.single.name, 'Fazenda Resultado');
    expect(options.stands, hasLength(2));
    expect(
      options.species.map((item) => item.name),
      containsAll(['Pinus', 'Eucalyptus']),
    );

    final dashboard = await resultsRepository
        .watchDashboard(
          ResultsFilters(
            propertyId: propertyId,
            standIds: const {},
            speciesId: null,
          ),
        )
        .first;

    expect(dashboard.treeCount, 3);
    expect(dashboard.plotCount, 2);
    expect(dashboard.collectedPlotCount, 1);
    expect(dashboard.measuredPlotCount, 2);
    expect(dashboard.measuredAreaHa, closeTo(0.09, 0.0001));
    expect(dashboard.averageDapCm, closeTo(25, 0.0001));
    expect(dashboard.averageHeightM, closeTo(14, 0.0001));
    expect(
      dashboard.diameterClasses.map((item) => item.label),
      containsAll(['20-24', '25-29', '30-34']),
    );

    final pinusOnly = await resultsRepository
        .watchDashboard(
          ResultsFilters(
            propertyId: propertyId,
            standIds: {pinusStandId},
            speciesId: null,
          ),
        )
        .first;

    expect(pinusOnly.treeCount, 2);
    expect(pinusOnly.stands.single.stand.identification, 'P-01');
    expect(pinusOnly.averageDapCm, closeTo(22.5, 0.0001));
  });
}
