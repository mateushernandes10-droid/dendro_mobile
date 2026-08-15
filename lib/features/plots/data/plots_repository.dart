import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/providers/database_providers.dart';

final plotsRepositoryProvider = Provider<PlotsRepository>((ref) {
  return PlotsRepository(ref.watch(dendroDatabaseProvider));
});

final standPlotsProvider = StreamProvider.autoDispose
    .family<StandPlotsState, String>((ref, standId) {
      final repository = ref.watch(plotsRepositoryProvider);
      return repository.watchStandPlots(standId);
    });

final talhaoPlotsProvider = StreamProvider.autoDispose
    .family<StandPlotsState, String>((ref, talhaoLevantamentoId) {
      final repository = ref.watch(plotsRepositoryProvider);
      return repository.watchTalhaoPlots(talhaoLevantamentoId);
    });

class StandPlotsState {
  const StandPlotsState({
    required this.stand,
    required this.species,
    required this.plots,
    required this.nextPlotIdentification,
    this.activeTalhaoLevantamento,
  });

  final StandRecord stand;
  final SpeciesRecord species;
  final List<PlotSummary> plots;
  final String nextPlotIdentification;
  final TalhaoLevantamentoRecord? activeTalhaoLevantamento;

  int get totalPlots => plots.length;

  int get collectedPlots => plots
      .where((summary) => summary.plot.status == PlotStatus.collected)
      .length;

  int get plannedPlots => plots
      .where(
        (summary) => summary.inventoryRun.status == InventoryRunStatus.planning,
      )
      .length;

  double get measuredAreaHa => plots.fold<double>(
    0,
    (total, summary) => total + (summary.plot.areaHa ?? 0),
  );
}

class PlotSummary {
  const PlotSummary({
    required this.plot,
    required this.talhaoLevantamento,
    required this.inventoryRun,
    required this.treeCount,
    required this.geoPointCount,
    this.firstGeoPoint,
  });

  final PlotRecord plot;
  final TalhaoLevantamentoRecord talhaoLevantamento;
  final InventoryRunRecord inventoryRun;
  final int treeCount;
  final int geoPointCount;
  final PlotGeoPointRecord? firstGeoPoint;

  bool get hasCoordinates => firstGeoPoint != null;
}

class _StandContext {
  const _StandContext({required this.stand, required this.species});

  final StandRecord stand;
  final SpeciesRecord species;
}

class _TalhaoContext {
  const _TalhaoContext({
    required this.talhaoLevantamento,
    required this.stand,
    required this.species,
  });

  final TalhaoLevantamentoRecord talhaoLevantamento;
  final StandRecord stand;
  final SpeciesRecord species;
}

class ActiveInventoryForStandException implements Exception {
  const ActiveInventoryForStandException(this.existing);

  final TalhaoLevantamentoRecord existing;
}

class PlotsRepository {
  PlotsRepository(this._database);

  final DendroDatabase _database;
  final _uuid = const Uuid();

  Stream<StandPlotsState> watchStandPlots(String standId) async* {
    final context = await _readStandContext(standId);

    final query =
        _database.select(_database.plots).join([
            innerJoin(
              _database.talhaoLevantamentos,
              _database.talhaoLevantamentos.id.equalsExp(
                _database.plots.talhaoLevantamentoId,
              ),
            ),
            innerJoin(
              _database.inventoryRuns,
              _database.inventoryRuns.id.equalsExp(
                _database.talhaoLevantamentos.inventoryRunId,
              ),
            ),
          ])
          ..where(_database.talhaoLevantamentos.standId.equals(standId))
          ..orderBy([
            OrderingTerm.desc(_database.inventoryRuns.startedAt),
            OrderingTerm.asc(_database.plots.identification),
          ]);

    yield* query.watch().asyncMap((rows) async {
      final summaries = <PlotSummary>[];

      for (final row in rows) {
        final plot = row.readTable(_database.plots);
        final talhaoLevantamento = row.readTable(_database.talhaoLevantamentos);
        summaries.add(
          PlotSummary(
            plot: plot,
            talhaoLevantamento: talhaoLevantamento,
            inventoryRun: row.readTable(_database.inventoryRuns),
            treeCount: await _countTrees(plot.id),
            geoPointCount: await _countGeoPoints(plot.id),
            firstGeoPoint: await _firstGeoPoint(plot.id),
          ),
        );
      }

      return StandPlotsState(
        stand: context.stand,
        species: context.species,
        plots: summaries,
        nextPlotIdentification: await _nextPlotIdentificationForStand(standId),
        activeTalhaoLevantamento: await _findTalhaoLevantamentoByStatus(
          standId,
          InventoryRunStatus.inProgress,
        ),
      );
    });
  }

  Stream<StandPlotsState> watchTalhaoPlots(String talhaoLevantamentoId) async* {
    final context = await _readTalhaoContext(talhaoLevantamentoId);

    final query =
        _database.select(_database.plots).join([
            innerJoin(
              _database.talhaoLevantamentos,
              _database.talhaoLevantamentos.id.equalsExp(
                _database.plots.talhaoLevantamentoId,
              ),
            ),
            innerJoin(
              _database.inventoryRuns,
              _database.inventoryRuns.id.equalsExp(
                _database.talhaoLevantamentos.inventoryRunId,
              ),
            ),
          ])
          ..where(
            _database.plots.talhaoLevantamentoId.equals(talhaoLevantamentoId),
          )
          ..orderBy([OrderingTerm.asc(_database.plots.identification)]);

    yield* query.watch().asyncMap((rows) async {
      final summaries = <PlotSummary>[];

      for (final row in rows) {
        final plot = row.readTable(_database.plots);
        summaries.add(
          PlotSummary(
            plot: plot,
            talhaoLevantamento: row.readTable(_database.talhaoLevantamentos),
            inventoryRun: row.readTable(_database.inventoryRuns),
            treeCount: await _countTrees(plot.id),
            geoPointCount: await _countGeoPoints(plot.id),
            firstGeoPoint: await _firstGeoPoint(plot.id),
          ),
        );
      }

      return StandPlotsState(
        stand: context.stand,
        species: context.species,
        plots: summaries,
        nextPlotIdentification: await _nextPlotIdentificationForStand(
          context.stand.id,
        ),
        activeTalhaoLevantamento: await _findTalhaoLevantamentoByStatus(
          context.stand.id,
          InventoryRunStatus.inProgress,
        ),
      );
    });
  }

  Future<String> createPlannedPlot({
    required String standId,
    double? areaHa,
  }) async {
    final talhaoLevantamento = await _ensurePlanningTalhaoLevantamento(standId);
    return _createPlot(
      talhaoLevantamentoId: talhaoLevantamento.id,
      areaHa: areaHa,
    );
  }

  Future<String> createPlotForTalhaoLevantamento({
    required String talhaoLevantamentoId,
    double? areaHa,
  }) {
    return _createPlot(
      talhaoLevantamentoId: talhaoLevantamentoId,
      areaHa: areaHa,
    );
  }

  Future<TalhaoLevantamentoRecord> startNewInventoryForStand(
    String standId,
  ) async {
    final active = await _findTalhaoLevantamentoByStatus(
      standId,
      InventoryRunStatus.inProgress,
    );
    if (active != null) {
      throw ActiveInventoryForStandException(active);
    }

    final planning = await _findTalhaoLevantamentoByStatus(
      standId,
      InventoryRunStatus.planning,
    );
    if (planning != null && await _hasPlots(planning.id)) {
      await _promoteInventoryRun(planning.inventoryRunId);
      return _talhaoLevantamentoById(planning.id);
    }

    final context = await _readStandContext(standId);
    final inventoryRunId = await _createInventoryRun(
      propertyId: context.stand.propertyId,
      status: InventoryRunStatus.inProgress,
    );

    return _createTalhaoLevantamento(
      stand: context.stand,
      species: context.species,
      inventoryRunId: inventoryRunId,
    );
  }

  Future<void> updatePlotArea({required String id, double? areaHa}) async {
    await (_database.update(
      _database.plots,
    )..where((table) => table.id.equals(id))).write(
      PlotsCompanion(areaHa: Value(areaHa), updatedAt: Value(DateTime.now())),
    );
    await touchFromPlot(id);
  }

  Future<void> deletePlot(String id) async {
    final plot = await (_database.select(
      _database.plots,
    )..where((table) => table.id.equals(id))).getSingleOrNull();

    await (_database.delete(
      _database.plots,
    )..where((table) => table.id.equals(id))).go();

    if (plot != null) {
      await touchTalhaoLevantamento(plot.talhaoLevantamentoId);
    }
  }

  Future<List<TreeRecord>> treesForPlot(String plotId) {
    return (_database.select(_database.trees)
          ..where((table) => table.plotId.equals(plotId))
          ..orderBy([(table) => OrderingTerm.asc(table.number)]))
        .get();
  }

  Future<List<PlotGeoPointRecord>> geoPointsForPlot(String plotId) {
    return (_database.select(_database.plotGeoPoints)
          ..where((table) => table.plotId.equals(plotId))
          ..orderBy([(table) => OrderingTerm.asc(table.pointOrder)]))
        .get();
  }

  Future<String> nextPlotIdentification(String talhaoLevantamentoId) async {
    final talhaoLevantamento = await _talhaoLevantamentoById(
      talhaoLevantamentoId,
    );
    return _nextPlotIdentificationForStand(talhaoLevantamento.standId);
  }

  Future<String> _nextPlotIdentificationForStand(String standId) async {
    final existing = await (_database.select(_database.plots).join([
      innerJoin(
        _database.talhaoLevantamentos,
        _database.talhaoLevantamentos.id.equalsExp(
          _database.plots.talhaoLevantamentoId,
        ),
      ),
    ])..where(_database.talhaoLevantamentos.standId.equals(standId))).get();
    var maxNumber = 0;
    for (final row in existing) {
      final plot = row.readTable(_database.plots);
      final match = RegExp(r'^P(\d+)$').firstMatch(plot.identification);
      final number = match == null ? null : int.tryParse(match.group(1)!);
      if (number != null && number > maxNumber) {
        maxNumber = number;
      }
    }

    return 'P${(maxNumber + 1).toString().padLeft(2, '0')}';
  }

  Future<void> touchFromPlot(String plotId) async {
    final plot = await (_database.select(
      _database.plots,
    )..where((table) => table.id.equals(plotId))).getSingleOrNull();

    if (plot == null) return;
    await touchTalhaoLevantamento(plot.talhaoLevantamentoId);
  }

  Future<void> touchTalhaoLevantamento(String talhaoLevantamentoId) async {
    final talhaoLevantamento = await _talhaoLevantamentoById(
      talhaoLevantamentoId,
    );
    final now = DateTime.now();

    await (_database.update(_database.talhaoLevantamentos)
          ..where((table) => table.id.equals(talhaoLevantamentoId)))
        .write(TalhaoLevantamentosCompanion(updatedAt: Value(now)));

    await (_database.update(
          _database.inventoryRuns,
        )..where((table) => table.id.equals(talhaoLevantamento.inventoryRunId)))
        .write(InventoryRunsCompanion(updatedAt: Value(now)));
  }

  Future<String> _createPlot({
    required String talhaoLevantamentoId,
    double? areaHa,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final identification = await nextPlotIdentification(talhaoLevantamentoId);

    await _database
        .into(_database.plots)
        .insert(
          PlotsCompanion.insert(
            id: id,
            talhaoLevantamentoId: talhaoLevantamentoId,
            identification: identification,
            status: PlotStatus.pending,
            areaHa: Value(areaHa),
            createdAt: now,
            updatedAt: now,
          ),
        );

    await touchTalhaoLevantamento(talhaoLevantamentoId);
    return id;
  }

  Future<_StandContext> _readStandContext(String standId) async {
    final row = await (_database.select(_database.stands).join([
      innerJoin(
        _database.species,
        _database.species.id.equalsExp(_database.stands.speciesId),
      ),
    ])..where(_database.stands.id.equals(standId))).getSingle();

    return _StandContext(
      stand: row.readTable(_database.stands),
      species: row.readTable(_database.species),
    );
  }

  Future<_TalhaoContext> _readTalhaoContext(String talhaoLevantamentoId) async {
    final row =
        await (_database.select(_database.talhaoLevantamentos).join([
              innerJoin(
                _database.stands,
                _database.stands.id.equalsExp(
                  _database.talhaoLevantamentos.standId,
                ),
              ),
              innerJoin(
                _database.species,
                _database.species.id.equalsExp(
                  _database.talhaoLevantamentos.speciesId,
                ),
              ),
            ])..where(
              _database.talhaoLevantamentos.id.equals(talhaoLevantamentoId),
            ))
            .getSingle();

    return _TalhaoContext(
      talhaoLevantamento: row.readTable(_database.talhaoLevantamentos),
      stand: row.readTable(_database.stands),
      species: row.readTable(_database.species),
    );
  }

  Future<TalhaoLevantamentoRecord> _ensurePlanningTalhaoLevantamento(
    String standId,
  ) async {
    final existing = await _findTalhaoLevantamentoByStatus(
      standId,
      InventoryRunStatus.planning,
    );
    if (existing != null) return existing;

    final context = await _readStandContext(standId);
    final inventoryRunId = await _createInventoryRun(
      propertyId: context.stand.propertyId,
      status: InventoryRunStatus.planning,
    );

    return _createTalhaoLevantamento(
      stand: context.stand,
      species: context.species,
      inventoryRunId: inventoryRunId,
    );
  }

  Future<TalhaoLevantamentoRecord?> _findTalhaoLevantamentoByStatus(
    String standId,
    InventoryRunStatus status,
  ) async {
    final query =
        _database.select(_database.talhaoLevantamentos).join([
            innerJoin(
              _database.inventoryRuns,
              _database.inventoryRuns.id.equalsExp(
                _database.talhaoLevantamentos.inventoryRunId,
              ),
            ),
          ])
          ..where(
            _database.talhaoLevantamentos.standId.equals(standId) &
                _database.inventoryRuns.status.equalsValue(status),
          )
          ..orderBy([
            OrderingTerm.desc(_database.inventoryRuns.updatedAt),
            OrderingTerm.desc(_database.talhaoLevantamentos.updatedAt),
          ])
          ..limit(1);

    final row = await query.getSingleOrNull();
    return row?.readTable(_database.talhaoLevantamentos);
  }

  Future<String> _createInventoryRun({
    required String propertyId,
    required InventoryRunStatus status,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    await _database
        .into(_database.inventoryRuns)
        .insert(
          InventoryRunsCompanion.insert(
            id: id,
            propertyId: propertyId,
            status: status,
            startedAt: now,
            updatedAt: now,
          ),
        );

    return id;
  }

  Future<TalhaoLevantamentoRecord> _createTalhaoLevantamento({
    required StandRecord stand,
    required SpeciesRecord species,
    required String inventoryRunId,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final formulaId = await _defaultFormulaId(species.id);

    await _database
        .into(_database.talhaoLevantamentos)
        .insert(
          TalhaoLevantamentosCompanion.insert(
            id: id,
            inventoryRunId: inventoryRunId,
            standId: stand.id,
            speciesId: species.id,
            formulaId: formulaId,
            createdAt: now,
            updatedAt: now,
          ),
        );

    return _talhaoLevantamentoById(id);
  }

  Future<void> _promoteInventoryRun(String inventoryRunId) {
    final now = DateTime.now();
    return (_database.update(
      _database.inventoryRuns,
    )..where((table) => table.id.equals(inventoryRunId))).write(
      InventoryRunsCompanion(
        status: const Value(InventoryRunStatus.inProgress),
        startedAt: Value(now),
        updatedAt: Value(now),
        completedAt: const Value(null),
      ),
    );
  }

  Future<TalhaoLevantamentoRecord> _talhaoLevantamentoById(String id) {
    return (_database.select(
      _database.talhaoLevantamentos,
    )..where((table) => table.id.equals(id))).getSingle();
  }

  Future<bool> _hasPlots(String talhaoLevantamentoId) async {
    final count = _database.plots.id.count();
    final row =
        await (_database.selectOnly(_database.plots)
              ..addColumns([count])
              ..where(
                _database.plots.talhaoLevantamentoId.equals(
                  talhaoLevantamentoId,
                ),
              ))
            .getSingle();

    return (row.read(count) ?? 0) > 0;
  }

  Future<String> _defaultFormulaId(String speciesId) async {
    final formulas = await (_database.select(
      _database.speciesFormulas,
    )..where((table) => table.speciesId.equals(speciesId))).get();

    final defaultFormula = formulas
        .where((formula) => formula.isDefault)
        .cast<SpeciesFormulaRecord?>()
        .firstOrNull;

    if (defaultFormula != null) return defaultFormula.formulaId;
    if (formulas.isNotEmpty) return formulas.first.formulaId;

    final fallback = await (_database.select(
      _database.formulas,
    )..limit(1)).getSingle();
    return fallback.id;
  }

  Future<int> _countTrees(String plotId) async {
    final count = _database.trees.id.count();

    final row =
        await (_database.selectOnly(_database.trees)
              ..addColumns([count])
              ..where(_database.trees.plotId.equals(plotId)))
            .getSingle();

    return row.read(count) ?? 0;
  }

  Future<int> _countGeoPoints(String plotId) async {
    final count = _database.plotGeoPoints.id.count();

    final row =
        await (_database.selectOnly(_database.plotGeoPoints)
              ..addColumns([count])
              ..where(_database.plotGeoPoints.plotId.equals(plotId)))
            .getSingle();

    return row.read(count) ?? 0;
  }

  Future<PlotGeoPointRecord?> _firstGeoPoint(String plotId) {
    return (_database.select(_database.plotGeoPoints)
          ..where((table) => table.plotId.equals(plotId))
          ..orderBy([(table) => OrderingTerm.asc(table.pointOrder)])
          ..limit(1))
        .getSingleOrNull();
  }
}
