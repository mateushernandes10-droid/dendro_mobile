import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/forest/forest_volume_calculator.dart';
import '../../../core/providers/database_providers.dart';
import '../../activity_log/data/activity_log_repository.dart';
import '../../inventory_runs/data/inventory_formula_selection.dart';

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
    this.currentTalhaoLevantamento,
    this.currentInventoryRun,
  });

  final StandRecord stand;
  final SpeciesRecord species;
  final List<PlotSummary> plots;
  final String nextPlotIdentification;
  final TalhaoLevantamentoRecord? activeTalhaoLevantamento;
  final TalhaoLevantamentoRecord? currentTalhaoLevantamento;
  final InventoryRunRecord? currentInventoryRun;

  int get totalPlots => plots.length;

  int get collectedPlots => plots
      .where((summary) => summary.plot.status == PlotStatus.collected)
      .length;

  int get plannedPlots => plots
      .where(
        (summary) => summary.inventoryRun.status == InventoryRunStatus.planning,
      )
      .length;

  int get openPlots => totalPlots - collectedPlots;

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
    required this.inventoryRun,
    required this.stand,
    required this.species,
  });

  final TalhaoLevantamentoRecord talhaoLevantamento;
  final InventoryRunRecord inventoryRun;
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
  late final ActivityLogRepository _activityLog = ActivityLogRepository(
    _database,
  );

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
        currentTalhaoLevantamento: context.talhaoLevantamento,
        currentInventoryRun: context.inventoryRun,
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
    String standId, {
    InventoryFormulaSelection? formulaSelection,
  }) async {
    final active = await _findTalhaoLevantamentoByStatus(
      standId,
      InventoryRunStatus.inProgress,
    );
    if (active != null) {
      throw ActiveInventoryForStandException(active);
    }

    final context = await _readStandContext(standId);
    final reusableActiveRun = await _findLatestInventoryRunForPropertyByStatus(
      propertyId: context.stand.propertyId,
      status: InventoryRunStatus.inProgress,
    );

    final planning = await _findTalhaoLevantamentoByStatus(
      standId,
      InventoryRunStatus.planning,
    );
    if (planning != null && await _hasPlots(planning.id)) {
      if (reusableActiveRun != null) {
        final moved = await _moveTalhaoLevantamentoToRun(
          talhaoLevantamento: planning,
          inventoryRunId: reusableActiveRun.id,
        );
        if (formulaSelection != null) {
          await _applyFormulaSelection(
            talhaoLevantamentoId: moved.id,
            formulaSelection: formulaSelection,
          );
          final updated = await _talhaoLevantamentoById(moved.id);
          await _logInventoryStart(
            context: context,
            inventoryRunId: updated.inventoryRunId,
            createdRun: false,
          );
          return updated;
        }
        await _logInventoryStart(
          context: context,
          inventoryRunId: moved.inventoryRunId,
          createdRun: false,
        );
        return moved;
      }

      await _promoteInventoryRun(planning.inventoryRunId);
      if (formulaSelection != null) {
        await _applyFormulaSelection(
          talhaoLevantamentoId: planning.id,
          formulaSelection: formulaSelection,
        );
      }
      final promoted = await _talhaoLevantamentoById(planning.id);
      await _logInventoryStart(
        context: context,
        inventoryRunId: promoted.inventoryRunId,
        createdRun: true,
      );
      return promoted;
    }

    final createdRun = reusableActiveRun == null;
    final inventoryRunId =
        reusableActiveRun?.id ??
        await _createInventoryRun(
          propertyId: context.stand.propertyId,
          status: InventoryRunStatus.inProgress,
        );

    final talhaoLevantamento = await _createTalhaoLevantamento(
      stand: context.stand,
      species: context.species,
      inventoryRunId: inventoryRunId,
      formulaSelection: formulaSelection,
    );

    await _logInventoryStart(
      context: context,
      inventoryRunId: talhaoLevantamento.inventoryRunId,
      createdRun: createdRun,
    );

    return talhaoLevantamento;
  }

  Future<void> updatePlotArea({required String id, double? areaHa}) async {
    final plot = await (_database.select(
      _database.plots,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    final context = plot == null
        ? null
        : await _readTalhaoContext(plot.talhaoLevantamentoId);
    final now = DateTime.now();

    await _database.transaction(() async {
      await (_database.update(_database.plots)
            ..where((table) => table.id.equals(id)))
          .write(PlotsCompanion(areaHa: Value(areaHa), updatedAt: Value(now)));
      await touchFromPlot(id);

      if (plot == null || context == null) return;
      await _activityLog.record(
        type: ActivityLogType.plotUpdated,
        title: 'Parcela atualizada',
        subtitle: _plotActivitySubtitle(plot.identification, context),
        entityType: ActivityEntityType.plot,
        entityId: id,
        occurredAt: now,
      );
    });
  }

  Future<void> deletePlot(String id) async {
    final plot = await (_database.select(
      _database.plots,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    final context = plot == null
        ? null
        : await _readTalhaoContext(plot.talhaoLevantamentoId);

    await _database.transaction(() async {
      await (_database.delete(
        _database.plots,
      )..where((table) => table.id.equals(id))).go();

      if (plot != null) {
        await touchTalhaoLevantamento(plot.talhaoLevantamentoId);
      }

      if (plot == null || context == null) return;
      await _activityLog.record(
        type: ActivityLogType.plotDeleted,
        title: 'Parcela excluida',
        subtitle: _plotActivitySubtitle(plot.identification, context),
        entityType: ActivityEntityType.plot,
        entityId: id,
      );
    });
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
    final context = await _readTalhaoContext(talhaoLevantamentoId);
    final resolvedAreaHa = areaHa ?? _defaultPlotAreaHa(context.stand);

    await _database.transaction(() async {
      await _database
          .into(_database.plots)
          .insert(
            PlotsCompanion.insert(
              id: id,
              talhaoLevantamentoId: talhaoLevantamentoId,
              identification: identification,
              status: PlotStatus.pending,
              areaHa: Value(resolvedAreaHa),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await touchTalhaoLevantamento(talhaoLevantamentoId);
      await _activityLog.record(
        type: ActivityLogType.plotCreated,
        title: 'Parcela cadastrada',
        subtitle: _plotActivitySubtitle(identification, context),
        entityType: ActivityEntityType.plot,
        entityId: id,
        occurredAt: now,
      );
    });
    return id;
  }

  double? _defaultPlotAreaHa(StandRecord stand) {
    final width = stand.plotWidthM;
    final length = stand.plotLengthM;
    if (width == null || length == null || width <= 0 || length <= 0) {
      return null;
    }
    return width * length / 10000;
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
                _database.inventoryRuns,
                _database.inventoryRuns.id.equalsExp(
                  _database.talhaoLevantamentos.inventoryRunId,
                ),
              ),
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
      inventoryRun: row.readTable(_database.inventoryRuns),
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

  Future<InventoryRunRecord?> _findLatestInventoryRunForPropertyByStatus({
    required String propertyId,
    required InventoryRunStatus status,
  }) {
    return (_database.select(_database.inventoryRuns)
          ..where(
            (table) =>
                table.propertyId.equals(propertyId) &
                table.status.equalsValue(status),
          )
          ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
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
    InventoryFormulaSelection? formulaSelection,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final formulaId =
        formulaSelection?.formulaId ?? await _defaultFormulaId(species.id);

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

    await _replaceTalhaoFormulaCoefficients(
      talhaoLevantamentoId: id,
      speciesId: species.id,
      formulaId: formulaId,
      coefficientValuesBySymbol:
          formulaSelection?.coefficientValuesBySymbol ?? const {},
    );
    await _touchInventoryRun(inventoryRunId, now: now);
    return _talhaoLevantamentoById(id);
  }

  Future<void> _applyFormulaSelection({
    required String talhaoLevantamentoId,
    required InventoryFormulaSelection formulaSelection,
  }) async {
    final now = DateTime.now();
    final talhaoLevantamento = await _talhaoLevantamentoById(
      talhaoLevantamentoId,
    );

    await (_database.update(
      _database.talhaoLevantamentos,
    )..where((table) => table.id.equals(talhaoLevantamentoId))).write(
      TalhaoLevantamentosCompanion(
        formulaId: Value(formulaSelection.formulaId),
        updatedAt: Value(now),
      ),
    );

    await _replaceTalhaoFormulaCoefficients(
      talhaoLevantamentoId: talhaoLevantamentoId,
      speciesId: talhaoLevantamento.speciesId,
      formulaId: formulaSelection.formulaId,
      coefficientValuesBySymbol: formulaSelection.coefficientValuesBySymbol,
    );
    await _touchInventoryRun(talhaoLevantamento.inventoryRunId, now: now);
  }

  Future<void> _replaceTalhaoFormulaCoefficients({
    required String talhaoLevantamentoId,
    required String speciesId,
    required String formulaId,
    required Map<String, double?> coefficientValuesBySymbol,
  }) async {
    await _database.customStatement(
      'DELETE FROM talhao_formula_coefficients WHERE talhao_levantamento_id = ?',
      [talhaoLevantamentoId],
    );

    final coefficients =
        await (_database.select(_database.formulaCoefficients)
              ..where((table) => table.formulaId.equals(formulaId))
              ..orderBy([(table) => OrderingTerm.asc(table.symbol)]))
            .get();
    final speciesValues = await _speciesFormulaCoefficientValues(
      speciesId: speciesId,
      formulaId: formulaId,
    );

    for (final coefficient in coefficients) {
      await _database.customStatement(
        '''
INSERT INTO talhao_formula_coefficients
  (id, talhao_levantamento_id, symbol, label, value)
VALUES (?, ?, ?, ?, ?)
''',
        [
          _uuid.v4(),
          talhaoLevantamentoId,
          coefficient.symbol,
          coefficient.label,
          coefficientValuesBySymbol.containsKey(coefficient.symbol)
              ? coefficientValuesBySymbol[coefficient.symbol]
              : speciesValues[coefficient.symbol] ??
                    coefficient.value ??
                    ForestVolumeCalculator.defaultCoefficientValue(
                      formulaId: formulaId,
                      symbol: coefficient.symbol,
                    ),
        ],
      );
    }
  }

  Future<Map<String, double?>> _speciesFormulaCoefficientValues({
    required String speciesId,
    required String formulaId,
  }) async {
    final rows =
        await (_database.select(_database.speciesFormulaCoefficients)..where(
              (table) =>
                  table.speciesId.equals(speciesId) &
                  table.formulaId.equals(formulaId),
            ))
            .get();

    return {
      for (final coefficient in rows) coefficient.symbol: coefficient.value,
    };
  }

  Future<TalhaoLevantamentoRecord> _moveTalhaoLevantamentoToRun({
    required TalhaoLevantamentoRecord talhaoLevantamento,
    required String inventoryRunId,
  }) async {
    if (talhaoLevantamento.inventoryRunId == inventoryRunId) {
      return talhaoLevantamento;
    }

    final previousRunId = talhaoLevantamento.inventoryRunId;
    final now = DateTime.now();

    await (_database.update(
      _database.talhaoLevantamentos,
    )..where((table) => table.id.equals(talhaoLevantamento.id))).write(
      TalhaoLevantamentosCompanion(
        inventoryRunId: Value(inventoryRunId),
        updatedAt: Value(now),
      ),
    );

    await _touchInventoryRun(inventoryRunId, now: now);
    await _deleteInventoryRunIfEmpty(previousRunId);

    return _talhaoLevantamentoById(talhaoLevantamento.id);
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

  Future<void> _touchInventoryRun(String inventoryRunId, {DateTime? now}) {
    return (_database.update(_database.inventoryRuns)
          ..where((table) => table.id.equals(inventoryRunId)))
        .write(InventoryRunsCompanion(updatedAt: Value(now ?? DateTime.now())));
  }

  Future<void> _deleteInventoryRunIfEmpty(String inventoryRunId) async {
    final count = _database.talhaoLevantamentos.id.count();
    final row =
        await (_database.selectOnly(_database.talhaoLevantamentos)
              ..addColumns([count])
              ..where(
                _database.talhaoLevantamentos.inventoryRunId.equals(
                  inventoryRunId,
                ),
              ))
            .getSingle();

    if ((row.read(count) ?? 0) > 0) return;

    await (_database.delete(
      _database.inventoryRuns,
    )..where((table) => table.id.equals(inventoryRunId))).go();
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

  Future<void> _logInventoryStart({
    required _StandContext context,
    required String inventoryRunId,
    required bool createdRun,
  }) async {
    final property = await _propertyById(context.stand.propertyId);
    await _activityLog.record(
      type: createdRun
          ? ActivityLogType.inventoryRunStarted
          : ActivityLogType.inventoryRunStandAdded,
      title: createdRun
          ? 'Levantamento iniciado'
          : 'Talhao adicionado ao levantamento',
      subtitle: _standActivitySubtitle(context.stand, property),
      entityType: ActivityEntityType.inventoryRun,
      entityId: inventoryRunId,
    );
  }

  Future<PropertyRecord?> _propertyById(String id) {
    return (_database.select(
      _database.properties,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }
}

String _plotActivitySubtitle(String plotName, _TalhaoContext context) {
  return '$plotName - ${context.stand.identification}';
}

String _standActivitySubtitle(StandRecord stand, PropertyRecord? property) {
  if (property == null) return stand.identification;
  return '${stand.identification} - ${property.name}';
}
