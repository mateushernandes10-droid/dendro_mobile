import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/providers/database_providers.dart';

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
    required this.plotCount,
    required this.collectedPlotCount,
    required this.treeCount,
    required this.measuredAreaHa,
  });

  final TalhaoLevantamentoRecord talhaoLevantamento;
  final StandRecord stand;
  final SpeciesRecord species;
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
      final summaries = <InventoryRunSummary>[];
      for (final run in runs) {
        summaries.add(await _summaryForRun(run));
      }
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
          plotCount: await _countPlots(talhaoLevantamento.id),
          collectedPlotCount: await _countCollectedPlots(talhaoLevantamento.id),
          treeCount: await _countTrees(talhaoLevantamento.id),
          measuredAreaHa: await _sumMeasuredArea(talhaoLevantamento.id),
        ),
      );
    }

    return summaries;
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
