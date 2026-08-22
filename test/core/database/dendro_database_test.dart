import 'package:dendro_mobile/core/database/dendro_database.dart';
import 'package:dendro_mobile/features/inventory_runs/data/inventory_formula_selection.dart';
import 'package:dendro_mobile/features/inventory_runs/data/inventory_runs_repository.dart';
import 'package:dendro_mobile/features/plots/data/plots_repository.dart';
import 'package:dendro_mobile/features/properties/data/properties_repository.dart';
import 'package:dendro_mobile/features/results/data/results_repository.dart';
import 'package:dendro_mobile/features/settings/data/settings_repository.dart';
import 'package:dendro_mobile/features/stands/data/stands_repository.dart';
import 'package:dendro_mobile/features/tree_collection/data/trees_repository.dart';
import 'package:drift/drift.dart' as drift;
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

  test('repositorio de ajustes mantem especies formulas e vinculos', () async {
    final repository = SettingsRepository(database);

    final speciesId = await repository.createSpecies(
      name: 'Acacia',
      scientificName: 'Acacia mearnsii',
      description: 'Cadastro para testes',
    );
    final formulaId = await repository.createFormula(
      name: 'Modelo Regional',
      description: 'Modelo local',
      expression: 'a + b * D + c * H',
      variables: const [
        FormulaVariableDraft(
          symbol: 'D',
          label: 'DAP',
          unit: 'cm',
          valueSource: 'Medição da árvore',
          variableKey: FormulaVariableKey.dap,
        ),
        FormulaVariableDraft(
          symbol: 'H',
          label: 'Altura',
          unit: 'm',
          valueSource: 'Medição da árvore',
          variableKey: FormulaVariableKey.height,
        ),
      ],
      coefficientSymbols: const ['a', 'b', 'c'],
    );

    await repository.setSpeciesFormulaLinked(
      speciesId: speciesId,
      formulaId: formulaId,
      linked: true,
    );

    final links = await database.select(database.speciesFormulas).get();
    final customLink = links.singleWhere(
      (link) => link.speciesId == speciesId && link.formulaId == formulaId,
    );
    expect(customLink.isDefault, isTrue);

    final coefficients =
        (await database.select(database.formulaCoefficients).get())
            .where((item) => item.formulaId == formulaId)
            .toList();
    await repository.updateCoefficientValues(
      formulaId: formulaId,
      valuesByCoefficientId: {
        for (final coefficient in coefficients)
          coefficient.id: switch (coefficient.symbol) {
            'a' => -0.8732,
            'b' => 1.9542,
            _ => 0.8711,
          },
      },
    );

    final formulas = await repository.watchFormulas().first;
    final customFormula = formulas.singleWhere(
      (summary) => summary.formula.id == formulaId,
    );

    expect(customFormula.formula.name, 'Modelo Regional');
    expect(customFormula.variables.map((item) => item.symbol), ['D', 'H']);
    expect(customFormula.coefficients, hasLength(3));
    expect(
      customFormula.coefficients
          .singleWhere((item) => item.symbol == 'a')
          .value,
      closeTo(-0.8732, 0.00001),
    );
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
    expect(activeRuns, hasLength(1));
    expect(activeRuns.single.property.id, propertyId);
    expect(activeRuns.single.stands, hasLength(2));
    expect(
      activeRuns.single.stands.map((summary) => summary.stand.identification),
      containsAll(['T-01', 'T-02']),
    );

    final allRuns = await inventoryRunsRepository.watchAll().first;

    expect(allRuns, hasLength(2));
    expect(
      allRuns.where(
        (summary) => summary.run.status == InventoryRunStatus.inProgress,
      ),
      hasLength(1),
    );
    expect(
      allRuns.where(
        (summary) => summary.run.status == InventoryRunStatus.planning,
      ),
      hasLength(1),
    );
  });

  test(
    'levantamento salva modelo e coeficientes especificos do talhao',
    () async {
      final propertiesRepository = PropertiesRepository(database);
      final standsRepository = StandsRepository(database);
      final plotsRepository = PlotsRepository(database);
      final inventoryRunsRepository = InventoryRunsRepository(database);

      final propertyId = await propertiesRepository.create(
        name: 'Fazenda Modelo',
        municipality: 'Vacaria',
        totalAreaHa: 70,
      );
      final species = await standsRepository.watchActiveSpecies().first;
      final pinus = species.firstWhere((item) => item.name == 'Pinus');
      final standId = await standsRepository.create(
        propertyId: propertyId,
        identification: 'M-01',
        speciesId: pinus.id,
        areaHa: 15,
      );
      final schumacher = (await database.select(database.formulas).get())
          .singleWhere((formula) => formula.id == 'formula_schumacher_hall');

      final talhao = await plotsRepository.startNewInventoryForStand(
        standId,
        formulaSelection: const InventoryFormulaSelection(
          formulaId: 'formula_schumacher_hall',
          formulaName: 'Schumacher-Hall',
          coefficientValuesBySymbol: {'a': -9.87, 'b': 1.95, 'c': 0.87},
        ),
      );

      expect(talhao.formulaId, schumacher.id);

      final coefficients = await database
          .customSelect(
            '''
SELECT symbol, value
FROM talhao_formula_coefficients
WHERE talhao_levantamento_id = ?
ORDER BY symbol
''',
            variables: [drift.Variable<String>(talhao.id)],
          )
          .get();

      expect(coefficients, hasLength(3));
      expect(coefficients[0].read<String>('symbol'), 'a');
      expect(coefficients[0].read<double>('value'), closeTo(-9.87, 0.00001));
      expect(coefficients[1].read<String>('symbol'), 'b');
      expect(coefficients[1].read<double>('value'), closeTo(1.95, 0.00001));
      expect(coefficients[2].read<String>('symbol'), 'c');
      expect(coefficients[2].read<double>('value'), closeTo(0.87, 0.00001));

      final summary = await inventoryRunsRepository
          .watchById(talhao.inventoryRunId)
          .first;

      expect(summary, isNotNull);
      expect(summary!.stands.single.formula.name, 'Schumacher-Hall');
      expect(summary.stands.single.formulaCoefficients, hasLength(3));
      expect(
        summary.stands.single.formulaCoefficients
            .singleWhere((coefficient) => coefficient.symbol == 'a')
            .value,
        closeTo(-9.87, 0.00001),
      );
    },
  );

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

  test(
    'repositorio agrupa levantamentos ativos antigos da mesma propriedade',
    () async {
      final propertiesRepository = PropertiesRepository(database);
      final standsRepository = StandsRepository(database);
      final inventoryRunsRepository = InventoryRunsRepository(database);

      final propertyId = await propertiesRepository.create(
        name: 'Fazenda Agrupada',
        municipality: 'Vacaria',
        totalAreaHa: 80,
      );
      final species = await standsRepository.watchActiveSpecies().first;
      final pinus = species.firstWhere((item) => item.name == 'Pinus');
      final formula = (await database.select(database.formulas).get()).first;

      final firstStandId = await standsRepository.create(
        propertyId: propertyId,
        identification: 'A-01',
        speciesId: pinus.id,
        areaHa: 12,
      );
      final secondStandId = await standsRepository.create(
        propertyId: propertyId,
        identification: 'A-02',
        speciesId: pinus.id,
        areaHa: 8,
      );

      final startedAt = DateTime(2026, 8, 22, 8);
      await database
          .into(database.inventoryRuns)
          .insert(
            InventoryRunsCompanion.insert(
              id: 'legacy-run-1',
              propertyId: propertyId,
              status: InventoryRunStatus.inProgress,
              startedAt: startedAt,
              updatedAt: startedAt,
            ),
          );
      await database
          .into(database.inventoryRuns)
          .insert(
            InventoryRunsCompanion.insert(
              id: 'legacy-run-2',
              propertyId: propertyId,
              status: InventoryRunStatus.inProgress,
              startedAt: startedAt.add(const Duration(minutes: 5)),
              updatedAt: startedAt.add(const Duration(minutes: 5)),
            ),
          );

      await database
          .into(database.talhaoLevantamentos)
          .insert(
            TalhaoLevantamentosCompanion.insert(
              id: 'legacy-talhao-1',
              inventoryRunId: 'legacy-run-1',
              standId: firstStandId,
              speciesId: pinus.id,
              formulaId: formula.id,
              createdAt: startedAt,
              updatedAt: startedAt,
            ),
          );
      await database
          .into(database.talhaoLevantamentos)
          .insert(
            TalhaoLevantamentosCompanion.insert(
              id: 'legacy-talhao-2',
              inventoryRunId: 'legacy-run-2',
              standId: secondStandId,
              speciesId: pinus.id,
              formulaId: formula.id,
              createdAt: startedAt.add(const Duration(minutes: 5)),
              updatedAt: startedAt.add(const Duration(minutes: 5)),
            ),
          );

      final activeRuns = await inventoryRunsRepository.watchActive().first;

      expect(activeRuns, hasLength(1));
      expect(activeRuns.single.property.name, 'Fazenda Agrupada');
      expect(activeRuns.single.stands, hasLength(2));
      expect(
        activeRuns.single.stands.map((summary) => summary.stand.identification),
        containsAll(['A-01', 'A-02']),
      );

      final storedRuns = await database.select(database.inventoryRuns).get();
      expect(storedRuns, hasLength(1));
      expect(storedRuns.single.id, 'legacy-run-2');
    },
  );

  test('repositorio exclui levantamento e dados vinculados', () async {
    final propertiesRepository = PropertiesRepository(database);
    final standsRepository = StandsRepository(database);
    final plotsRepository = PlotsRepository(database);
    final treesRepository = TreesRepository(database);
    final inventoryRunsRepository = InventoryRunsRepository(database);

    final propertyId = await propertiesRepository.create(
      name: 'Fazenda Desistencia',
      municipality: 'Vacaria',
      totalAreaHa: 30,
    );
    final species = await standsRepository.watchActiveSpecies().first;
    final pinus = species.firstWhere((item) => item.name == 'Pinus');

    final standId = await standsRepository.create(
      propertyId: propertyId,
      identification: 'D-01',
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
    await treesRepository.createTree(
      plotId: plotId,
      draft: TreeDraft(
        dapCm: 24,
        heightM: 15,
        hasTortuousStem: false,
        latitude: -28.5,
        longitude: -50.9,
        accuracyMeters: 3,
        locationCapturedAt: DateTime(2026, 8, 22, 10),
        plotReferencePosition: PlotReferencePosition.p1,
      ),
    );

    expect(await database.select(database.inventoryRuns).get(), hasLength(1));
    expect(
      await database.select(database.talhaoLevantamentos).get(),
      hasLength(1),
    );
    expect(await database.select(database.plots).get(), hasLength(1));
    expect(await database.select(database.trees).get(), hasLength(1));
    expect(await database.select(database.plotGeoPoints).get(), hasLength(1));

    await inventoryRunsRepository.deleteRun(talhaoLevantamento.inventoryRunId);

    expect(await database.select(database.inventoryRuns).get(), isEmpty);
    expect(await database.select(database.talhaoLevantamentos).get(), isEmpty);
    expect(await database.select(database.plots).get(), isEmpty);
    expect(await database.select(database.trees).get(), isEmpty);
    expect(await database.select(database.plotGeoPoints).get(), isEmpty);
    expect(await database.select(database.properties).get(), hasLength(1));
    expect(await database.select(database.stands).get(), hasLength(1));
    expect(await inventoryRunsRepository.watchAll().first, isEmpty);
  });

  test('repositorio edita e remove talhao de um levantamento', () async {
    final propertiesRepository = PropertiesRepository(database);
    final standsRepository = StandsRepository(database);
    final plotsRepository = PlotsRepository(database);
    final treesRepository = TreesRepository(database);
    final inventoryRunsRepository = InventoryRunsRepository(database);

    final propertyId = await propertiesRepository.create(
      name: 'Fazenda Ajuste',
      municipality: 'Vacaria',
      totalAreaHa: 50,
    );
    final species = await standsRepository.watchActiveSpecies().first;
    final pinus = species.firstWhere((item) => item.name == 'Pinus');
    final eucalyptus = species.firstWhere((item) => item.name == 'Eucalyptus');

    final firstStandId = await standsRepository.create(
      propertyId: propertyId,
      identification: 'R-01',
      speciesId: pinus.id,
      areaHa: 10,
    );
    final secondStandId = await standsRepository.create(
      propertyId: propertyId,
      identification: 'R-02',
      speciesId: pinus.id,
      areaHa: 12,
    );

    final firstTalhao = await plotsRepository.startNewInventoryForStand(
      firstStandId,
    );
    final firstPlotId = await plotsRepository.createPlotForTalhaoLevantamento(
      talhaoLevantamentoId: firstTalhao.id,
      areaHa: 0.04,
    );
    await treesRepository.createTree(
      plotId: firstPlotId,
      draft: TreeDraft(
        dapCm: 21,
        heightM: 13,
        hasTortuousStem: false,
        latitude: -28.5,
        longitude: -50.9,
        locationCapturedAt: DateTime(2026, 8, 22, 11),
        plotReferencePosition: PlotReferencePosition.p1,
      ),
    );

    final secondTalhao = await plotsRepository.startNewInventoryForStand(
      secondStandId,
    );
    expect(firstTalhao.inventoryRunId, secondTalhao.inventoryRunId);

    await inventoryRunsRepository.updateStandInRun(
      talhaoLevantamentoId: secondTalhao.id,
      identification: 'R-02 ajustado',
      speciesId: eucalyptus.id,
      areaHa: 14,
      plantingYear: 2020,
      spacing: '3 x 2',
      managementRegime: 'Desbaste',
      notes: 'Ajustado no levantamento',
    );

    var summary = await inventoryRunsRepository
        .watchById(firstTalhao.inventoryRunId)
        .first;
    expect(summary, isNotNull);
    var adjustedStand = summary!.stands.firstWhere(
      (item) => item.talhaoLevantamento.id == secondTalhao.id,
    );
    expect(adjustedStand.stand.identification, 'R-02 ajustado');
    expect(adjustedStand.stand.areaHa, 14);
    expect(adjustedStand.stand.plantingYear, 2020);
    expect(adjustedStand.species.name, 'Eucalyptus');

    await inventoryRunsRepository.removeStandFromRun(firstTalhao.id);

    summary = await inventoryRunsRepository
        .watchById(firstTalhao.inventoryRunId)
        .first;
    expect(summary, isNotNull);
    expect(summary!.stands, hasLength(1));
    expect(summary.stands.single.talhaoLevantamento.id, secondTalhao.id);
    expect(await database.select(database.inventoryRuns).get(), hasLength(1));
    expect(
      await database.select(database.talhaoLevantamentos).get(),
      hasLength(1),
    );
    expect(await database.select(database.plots).get(), isEmpty);
    expect(await database.select(database.trees).get(), isEmpty);
    expect(await database.select(database.plotGeoPoints).get(), isEmpty);
    expect(await database.select(database.stands).get(), hasLength(2));
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
