import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/providers/database_providers.dart';
import 'inventory_formula_selection.dart';

final inventoryRunsRepositoryProvider = Provider<InventoryRunsRepository>((
  ref,
) {
  return InventoryRunsRepository(ref.watch(dendroDatabaseProvider));
});

final activeInventoryRunProvider =
    StreamProvider.autoDispose<InventoryRunSummary?>((ref) {
      return ref.watch(inventoryRunsRepositoryProvider).watchLatestActive();
    });

final activeInventoryRunsProvider =
    StreamProvider.autoDispose<List<InventoryRunSummary>>((ref) {
      return ref.watch(inventoryRunsRepositoryProvider).watchActive();
    });

final inventoryRunsProvider =
    StreamProvider.autoDispose<List<InventoryRunSummary>>((ref) {
      return ref.watch(inventoryRunsRepositoryProvider).watchAll();
    });

final inventoryRunDetailProvider = StreamProvider.autoDispose
    .family<InventoryRunSummary?, String>((ref, runId) {
      return ref.watch(inventoryRunsRepositoryProvider).watchById(runId);
    });

class InventoryRunSummary {
  const InventoryRunSummary({
    required this.run,
    required this.property,
    required this.stands,
  });

  final InventoryRunRecord run;
  final PropertyRecord property;
  final List<InventoryStandSummary> stands;

  int get treeCount =>
      stands.fold(0, (total, stand) => total + stand.treeCount);

  int get plotCount =>
      stands.fold(0, (total, stand) => total + stand.plotCount);

  int get collectedPlotCount =>
      stands.fold(0, (total, stand) => total + stand.collectedPlotCount);

  int get openPlotCount => plotCount - collectedPlotCount;

  double get measuredAreaHa =>
      stands.fold(0, (total, stand) => total + stand.measuredAreaHa);

  String get standLabel {
    if (stands.isEmpty) return 'Sem talhão vinculado';
    if (stands.length == 1) return stands.single.stand.identification;
    return '${stands.length} talhões';
  }
}

class InventoryStandSummary {
  const InventoryStandSummary({
    required this.talhaoLevantamento,
    required this.stand,
    required this.species,
    required this.formula,
    required this.formulaCoefficients,
    required this.plotCount,
    required this.collectedPlotCount,
    required this.treeCount,
    required this.measuredAreaHa,
  });

  final TalhaoLevantamentoRecord talhaoLevantamento;
  final StandRecord stand;
  final SpeciesRecord species;
  final FormulaRecord formula;
  final List<InventoryFormulaCoefficientValue> formulaCoefficients;
  final int plotCount;
  final int collectedPlotCount;
  final int treeCount;
  final double measuredAreaHa;
}

class InventoryRunsRepository {
  InventoryRunsRepository(this._database);

  final DendroDatabase _database;

  Stream<InventoryRunSummary?> watchLatestActive() {
    return watchActive().map((runs) => runs.firstOrNull);
  }

  Stream<List<InventoryRunSummary>> watchActive() {
    final query = _database.select(_database.inventoryRuns)
      ..where(
        (table) => table.status.equalsValue(InventoryRunStatus.inProgress),
      )
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);

    return query.watch().asyncMap((runs) async {
      if (await _normalizeActiveRunsByProperty()) {
        runs = await query.get();
      }

      final summaries = <InventoryRunSummary>[];
      for (final run in runs) {
        summaries.add(await _summaryForRun(run));
      }
      return summaries;
    });
  }

  Stream<List<InventoryRunSummary>> watchAll() {
    final query = _database.select(_database.inventoryRuns)
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);

    return query.watch().asyncMap((runs) async {
      if (await _normalizeActiveRunsByProperty()) {
        runs = await query.get();
      }

      final summaries = <InventoryRunSummary>[];
      for (final run in runs) {
        summaries.add(await _summaryForRun(run));
      }

      summaries.sort((a, b) {
        final statusComparison = _statusPriority(
          a.run.status,
        ).compareTo(_statusPriority(b.run.status));
        if (statusComparison != 0) return statusComparison;
        return b.run.updatedAt.compareTo(a.run.updatedAt);
      });

      return summaries;
    });
  }

  Stream<InventoryRunSummary?> watchById(String runId) {
    final query = _database.select(_database.inventoryRuns)
      ..where((table) => table.id.equals(runId))
      ..limit(1);

    return query.watch().asyncMap((runs) async {
      if (runs.isEmpty) return null;
      return _summaryForRun(runs.single);
    });
  }

  Future<void> completeRun(String runId) async {
    final now = DateTime.now();

    await (_database.update(
      _database.inventoryRuns,
    )..where((table) => table.id.equals(runId))).write(
      InventoryRunsCompanion(
        status: const Value(InventoryRunStatus.completed),
        updatedAt: Value(now),
        completedAt: Value(now),
      ),
    );
  }

  Future<void> deleteRun(String runId) {
    return _database.transaction(() async {
      final talhoes = await (_database.select(
        _database.talhaoLevantamentos,
      )..where((table) => table.inventoryRunId.equals(runId))).get();
      final talhaoIds = talhoes.map((talhao) => talhao.id).toList();

      if (talhaoIds.isNotEmpty) {
        await _deleteTalhaoLevantamentoData(talhaoIds);
      }

      await (_database.delete(
        _database.inventoryRuns,
      )..where((table) => table.id.equals(runId))).go();
    });
  }

  Future<void> removeStandFromRun(String talhaoLevantamentoId) {
    return _database.transaction(() async {
      final talhao =
          await (_database.select(_database.talhaoLevantamentos)
                ..where((table) => table.id.equals(talhaoLevantamentoId))
                ..limit(1))
              .getSingleOrNull();

      if (talhao == null) return;

      await _deleteTalhaoLevantamentoData([talhao.id]);

      await (_database.update(_database.inventoryRuns)
            ..where((table) => table.id.equals(talhao.inventoryRunId)))
          .write(InventoryRunsCompanion(updatedAt: Value(DateTime.now())));
    });
  }

  Future<void> updateStandInRun({
    required String talhaoLevantamentoId,
    required String identification,
    required String speciesId,
    required double areaHa,
    int? plantingYear,
    String? spacing,
    String? managementRegime,
    String? notes,
    InventoryFormulaSelection? formulaSelection,
  }) {
    return _database.transaction(() async {
      final talhao =
          await (_database.select(_database.talhaoLevantamentos)
                ..where((table) => table.id.equals(talhaoLevantamentoId))
                ..limit(1))
              .getSingle();
      final now = DateTime.now();
      final formulaId =
          formulaSelection?.formulaId ?? await _defaultFormulaId(speciesId);

      await (_database.update(
        _database.stands,
      )..where((table) => table.id.equals(talhao.standId))).write(
        StandsCompanion(
          identification: Value(identification.trim()),
          speciesId: Value(speciesId),
          areaHa: Value(areaHa),
          plantingYear: Value(plantingYear),
          spacing: Value(_blankToNull(spacing)),
          managementRegime: Value(_blankToNull(managementRegime)),
          notes: Value(_blankToNull(notes)),
          updatedAt: Value(now),
        ),
      );

      await (_database.update(
        _database.talhaoLevantamentos,
      )..where((table) => table.id.equals(talhaoLevantamentoId))).write(
        TalhaoLevantamentosCompanion(
          speciesId: Value(speciesId),
          formulaId: Value(formulaId),
          updatedAt: Value(now),
        ),
      );

      await _replaceTalhaoFormulaCoefficients(
        talhaoLevantamentoId: talhaoLevantamentoId,
        formulaId: formulaId,
        coefficientValuesBySymbol:
            formulaSelection?.coefficientValuesBySymbol ?? const {},
      );

      await (_database.update(_database.inventoryRuns)
            ..where((table) => table.id.equals(talhao.inventoryRunId)))
          .write(InventoryRunsCompanion(updatedAt: Value(now)));
    });
  }

  Future<InventoryRunSummary> _summaryForRun(InventoryRunRecord run) async {
    final property = await (_database.select(
      _database.properties,
    )..where((table) => table.id.equals(run.propertyId))).getSingle();

    return InventoryRunSummary(
      run: run,
      property: property,
      stands: await _standSummaries(run.id),
    );
  }

  Future<List<InventoryStandSummary>> _standSummaries(String runId) async {
    final query =
        _database.select(_database.talhaoLevantamentos).join([
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
            innerJoin(
              _database.formulas,
              _database.formulas.id.equalsExp(
                _database.talhaoLevantamentos.formulaId,
              ),
            ),
          ])
          ..where(_database.talhaoLevantamentos.inventoryRunId.equals(runId))
          ..orderBy([OrderingTerm.asc(_database.stands.identification)]);

    final rows = await query.get();
    final summaries = <InventoryStandSummary>[];

    for (final row in rows) {
      final talhaoLevantamento = row.readTable(_database.talhaoLevantamentos);
      summaries.add(
        InventoryStandSummary(
          talhaoLevantamento: talhaoLevantamento,
          stand: row.readTable(_database.stands),
          species: row.readTable(_database.species),
          formula: row.readTable(_database.formulas),
          formulaCoefficients: await _formulaCoefficientsForTalhao(
            talhaoLevantamento,
          ),
          plotCount: await _countPlots(talhaoLevantamento.id),
          collectedPlotCount: await _countCollectedPlots(talhaoLevantamento.id),
          treeCount: await _countTrees(talhaoLevantamento.id),
          measuredAreaHa: await _sumMeasuredArea(talhaoLevantamento.id),
        ),
      );
    }

    return summaries;
  }

  Future<bool> _normalizeActiveRunsByProperty() async {
    final activeRuns =
        await (_database.select(_database.inventoryRuns)
              ..where(
                (table) =>
                    table.status.equalsValue(InventoryRunStatus.inProgress),
              )
              ..orderBy([
                (table) => OrderingTerm.asc(table.propertyId),
                (table) => OrderingTerm.desc(table.updatedAt),
              ]))
            .get();

    final runsByProperty = <String, List<InventoryRunRecord>>{};
    for (final run in activeRuns) {
      runsByProperty.putIfAbsent(run.propertyId, () => []).add(run);
    }

    final duplicateGroups = runsByProperty.values
        .where((runs) => runs.length > 1)
        .toList();
    if (duplicateGroups.isEmpty) return false;

    var changed = false;

    await _database.transaction(() async {
      for (final runs in duplicateGroups) {
        runs.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        final targetRun = runs.first;

        for (final sourceRun in runs.skip(1)) {
          final sourceTalhoes = await (_database.select(
            _database.talhaoLevantamentos,
          )..where((table) => table.inventoryRunId.equals(sourceRun.id))).get();

          final hasCollision = await _hasStandCollision(
            targetRunId: targetRun.id,
            sourceTalhoes: sourceTalhoes,
          );
          if (hasCollision) continue;

          final now = DateTime.now();
          for (final talhao in sourceTalhoes) {
            await (_database.update(
              _database.talhaoLevantamentos,
            )..where((table) => table.id.equals(talhao.id))).write(
              TalhaoLevantamentosCompanion(
                inventoryRunId: Value(targetRun.id),
                updatedAt: Value(now),
              ),
            );
          }

          await (_database.delete(
            _database.inventoryRuns,
          )..where((table) => table.id.equals(sourceRun.id))).go();

          await (_database.update(_database.inventoryRuns)
                ..where((table) => table.id.equals(targetRun.id)))
              .write(InventoryRunsCompanion(updatedAt: Value(now)));

          changed = true;
        }
      }
    });

    return changed;
  }

  Future<bool> _hasStandCollision({
    required String targetRunId,
    required List<TalhaoLevantamentoRecord> sourceTalhoes,
  }) async {
    for (final talhao in sourceTalhoes) {
      final duplicate =
          await (_database.select(_database.talhaoLevantamentos)
                ..where(
                  (table) =>
                      table.inventoryRunId.equals(targetRunId) &
                      table.standId.equals(talhao.standId),
                )
                ..limit(1))
              .getSingleOrNull();

      if (duplicate != null) return true;
    }

    return false;
  }

  Future<void> _deleteTalhaoLevantamentoData(List<String> talhaoIds) async {
    if (talhaoIds.isEmpty) return;

    final plots = await (_database.select(
      _database.plots,
    )..where((table) => table.talhaoLevantamentoId.isIn(talhaoIds))).get();
    final plotIds = plots.map((plot) => plot.id).toList();

    if (plotIds.isNotEmpty) {
      await (_database.delete(
        _database.plotGeoPoints,
      )..where((table) => table.plotId.isIn(plotIds))).go();
      await (_database.delete(
        _database.trees,
      )..where((table) => table.plotId.isIn(plotIds))).go();
      await (_database.delete(
        _database.plots,
      )..where((table) => table.id.isIn(plotIds))).go();
    }

    await (_database.delete(
      _database.talhaoFormulaCoefficients,
    )..where((table) => table.talhaoLevantamentoId.isIn(talhaoIds))).go();

    await (_database.delete(
      _database.talhaoLevantamentos,
    )..where((table) => table.id.isIn(talhaoIds))).go();
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

  Future<List<InventoryFormulaCoefficientValue>> _formulaCoefficientsForTalhao(
    TalhaoLevantamentoRecord talhaoLevantamento,
  ) async {
    final snapshot =
        await (_database.select(_database.talhaoFormulaCoefficients)
              ..where(
                (table) => table.talhaoLevantamentoId.equals(
                  talhaoLevantamento.id,
                ),
              )
              ..orderBy([(table) => OrderingTerm.asc(table.symbol)]))
            .get();

    if (snapshot.isNotEmpty) {
      return [
        for (final coefficient in snapshot)
          InventoryFormulaCoefficientValue(
            symbol: coefficient.symbol,
            label: coefficient.label,
            value: coefficient.value,
          ),
      ];
    }

    final global =
        await (_database.select(_database.formulaCoefficients)
              ..where(
                (table) => table.formulaId.equals(
                  talhaoLevantamento.formulaId,
                ),
              )
              ..orderBy([(table) => OrderingTerm.asc(table.symbol)]))
            .get();

    return [
      for (final coefficient in global)
        InventoryFormulaCoefficientValue(
          symbol: coefficient.symbol,
          label: coefficient.label,
          value: coefficient.value,
        ),
    ];
  }

  Future<void> _replaceTalhaoFormulaCoefficients({
    required String talhaoLevantamentoId,
    required String formulaId,
    required Map<String, double?> coefficientValuesBySymbol,
  }) async {
    await (_database.delete(_database.talhaoFormulaCoefficients)
          ..where(
            (table) => table.talhaoLevantamentoId.equals(
              talhaoLevantamentoId,
            ),
          ))
        .go();

    final coefficients =
        await (_database.select(_database.formulaCoefficients)
              ..where((table) => table.formulaId.equals(formulaId))
              ..orderBy([(table) => OrderingTerm.asc(table.symbol)]))
            .get();

    for (final coefficient in coefficients) {
      await _database.into(_database.talhaoFormulaCoefficients).insert(
            TalhaoFormulaCoefficientsCompanion.insert(
              id: '${talhaoLevantamentoId}_${coefficient.symbol}',
              talhaoLevantamentoId: talhaoLevantamentoId,
              symbol: coefficient.symbol,
              label: coefficient.label,
              value: Value(
                coefficientValuesBySymbol.containsKey(coefficient.symbol)
                    ? coefficientValuesBySymbol[coefficient.symbol]
                    : coefficient.value,
              ),
            ),
          );
    }
  }

  Future<int> _countPlots(String talhaoLevantamentoId) async {
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

    return row.read(count) ?? 0;
  }

  Future<int> _countCollectedPlots(String talhaoLevantamentoId) async {
    final count = _database.plots.id.count();
    final row =
        await (_database.selectOnly(_database.plots)
              ..addColumns([count])
              ..where(
                _database.plots.talhaoLevantamentoId.equals(
                      talhaoLevantamentoId,
                    ) &
                    _database.plots.status.equalsValue(PlotStatus.collected),
              ))
            .getSingle();

    return row.read(count) ?? 0;
  }

  Future<int> _countTrees(String talhaoLevantamentoId) async {
    final count = _database.trees.id.count();
    final row =
        await (_database.selectOnly(_database.trees).join([
                innerJoin(
                  _database.plots,
                  _database.plots.id.equalsExp(_database.trees.plotId),
                ),
              ])
              ..addColumns([count])
              ..where(
                _database.plots.talhaoLevantamentoId.equals(
                  talhaoLevantamentoId,
                ),
              ))
            .getSingle();

    return row.read(count) ?? 0;
  }

  Future<double> _sumMeasuredArea(String talhaoLevantamentoId) async {
    final area = _database.plots.areaHa.sum();
    final row =
        await (_database.selectOnly(_database.plots)
              ..addColumns([area])
              ..where(
                _database.plots.talhaoLevantamentoId.equals(
                  talhaoLevantamentoId,
                ),
              ))
            .getSingle();

    return row.read(area) ?? 0;
  }
}

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}

int _statusPriority(InventoryRunStatus status) {
  switch (status) {
    case InventoryRunStatus.inProgress:
      return 0;
    case InventoryRunStatus.completed:
      return 1;
    case InventoryRunStatus.planning:
      return 2;
  }
}
