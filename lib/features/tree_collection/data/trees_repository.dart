import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/providers/database_providers.dart';

final treesRepositoryProvider = Provider<TreesRepository>((ref) {
  return TreesRepository(ref.watch(dendroDatabaseProvider));
});

final treeCollectionProvider = StreamProvider.autoDispose
    .family<TreeCollectionState, String>((ref, plotId) {
      return ref.watch(treesRepositoryProvider).watchCollection(plotId);
    });

class TreeCollectionState {
  const TreeCollectionState({
    required this.plot,
    required this.talhaoLevantamento,
    required this.inventoryRun,
    required this.stand,
    required this.species,
    required this.trees,
    required this.geoPoints,
  });

  final PlotRecord plot;
  final TalhaoLevantamentoRecord talhaoLevantamento;
  final InventoryRunRecord inventoryRun;
  final StandRecord stand;
  final SpeciesRecord species;
  final List<TreeRecord> trees;
  final List<PlotGeoPointRecord> geoPoints;

  int get treeCount => trees.length;

  int get nextTreeNumber {
    if (trees.isEmpty) return 1;
    return trees.map((tree) => tree.number).reduce((a, b) => a > b ? a : b) + 1;
  }

  Set<PlotReferencePosition> get capturedReferencePositions => {
    for (final tree in trees)
      if (tree.latitude != null &&
          tree.longitude != null &&
          tree.plotReferencePosition != null)
        tree.plotReferencePosition!,
  };
}

class TreeDraft {
  const TreeDraft({
    required this.dapCm,
    required this.heightM,
    required this.hasTortuousStem,
    this.latitude,
    this.longitude,
    this.accuracyMeters,
    this.locationCapturedAt,
    this.plotReferencePosition,
  });

  final double dapCm;
  final double heightM;
  final bool hasTortuousStem;
  final double? latitude;
  final double? longitude;
  final double? accuracyMeters;
  final DateTime? locationCapturedAt;
  final PlotReferencePosition? plotReferencePosition;
}

class TreesRepository {
  TreesRepository(this._database);

  final DendroDatabase _database;
  final _uuid = const Uuid();

  Stream<TreeCollectionState> watchCollection(String plotId) {
    final treesQuery = _database.select(_database.trees)
      ..where((table) => table.plotId.equals(plotId))
      ..orderBy([(table) => OrderingTerm.asc(table.number)]);

    return treesQuery.watch().asyncMap((trees) async {
      final context = await _readCollectionContext(plotId);
      final geoPoints =
          await (_database.select(_database.plotGeoPoints)
                ..where((table) => table.plotId.equals(plotId))
                ..orderBy([(table) => OrderingTerm.asc(table.pointOrder)]))
              .get();

      return TreeCollectionState(
        plot: context.plot,
        talhaoLevantamento: context.talhaoLevantamento,
        inventoryRun: context.inventoryRun,
        stand: context.stand,
        species: context.species,
        trees: trees,
        geoPoints: geoPoints,
      );
    });
  }

  Future<String> createTree({
    required String plotId,
    required TreeDraft draft,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final number = await nextTreeNumber(plotId);

    await _database.transaction(() async {
      if (draft.plotReferencePosition != null) {
        await _clearReferencePositionFromTrees(
          plotId: plotId,
          referencePosition: draft.plotReferencePosition!,
        );
      }

      await _database
          .into(_database.trees)
          .insert(
            TreesCompanion.insert(
              id: id,
              plotId: plotId,
              number: number,
              dapCm: draft.dapCm,
              heightM: draft.heightM,
              hasTortuousStem: Value(draft.hasTortuousStem),
              latitude: Value(draft.latitude),
              longitude: Value(draft.longitude),
              accuracyMeters: Value(draft.accuracyMeters),
              locationCapturedAt: Value(draft.locationCapturedAt),
              plotReferencePosition: Value(draft.plotReferencePosition),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await _touchPlot(plotId, status: PlotStatus.inProgress);
      await _rebuildPlotGeoPointsFromTrees(plotId);
    });

    return id;
  }

  Future<void> updateTree({
    required String treeId,
    required TreeDraft draft,
  }) async {
    final tree = await _treeById(treeId);

    await _database.transaction(() async {
      if (draft.plotReferencePosition != null) {
        await _clearReferencePositionFromTrees(
          plotId: tree.plotId,
          referencePosition: draft.plotReferencePosition!,
        );
      }

      await (_database.update(
        _database.trees,
      )..where((table) => table.id.equals(treeId))).write(
        TreesCompanion(
          dapCm: Value(draft.dapCm),
          heightM: Value(draft.heightM),
          hasTortuousStem: Value(draft.hasTortuousStem),
          latitude: Value(draft.latitude),
          longitude: Value(draft.longitude),
          accuracyMeters: Value(draft.accuracyMeters),
          locationCapturedAt: Value(draft.locationCapturedAt),
          plotReferencePosition: Value(draft.plotReferencePosition),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await _touchPlot(tree.plotId);
      await _rebuildPlotGeoPointsFromTrees(tree.plotId);
    });
  }

  Future<void> deleteTree(String treeId) async {
    final tree = await _treeById(treeId);

    await _database.transaction(() async {
      await (_database.delete(
        _database.trees,
      )..where((table) => table.id.equals(treeId))).go();

      final remaining = await _countTrees(tree.plotId);
      final plot = await _plotById(tree.plotId);
      final status = remaining == 0 && plot.status == PlotStatus.inProgress
          ? PlotStatus.pending
          : null;

      await _touchPlot(tree.plotId, status: status);
      await _rebuildPlotGeoPointsFromTrees(tree.plotId);
    });
  }

  Future<void> markPlotCollected(String plotId) {
    return _touchPlot(plotId, status: PlotStatus.collected);
  }

  Future<int> nextTreeNumber(String plotId) async {
    final trees = await (_database.select(
      _database.trees,
    )..where((table) => table.plotId.equals(plotId))).get();

    if (trees.isEmpty) return 1;
    return trees.map((tree) => tree.number).reduce((a, b) => a > b ? a : b) + 1;
  }

  Future<_CollectionContext> _readCollectionContext(String plotId) async {
    final query = _database.select(_database.plots).join([
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
      innerJoin(
        _database.stands,
        _database.stands.id.equalsExp(_database.talhaoLevantamentos.standId),
      ),
      innerJoin(
        _database.species,
        _database.species.id.equalsExp(_database.talhaoLevantamentos.speciesId),
      ),
    ])..where(_database.plots.id.equals(plotId));

    final row = await query.getSingle();
    return _CollectionContext(
      plot: row.readTable(_database.plots),
      talhaoLevantamento: row.readTable(_database.talhaoLevantamentos),
      inventoryRun: row.readTable(_database.inventoryRuns),
      stand: row.readTable(_database.stands),
      species: row.readTable(_database.species),
    );
  }

  Future<void> _touchPlot(String plotId, {PlotStatus? status}) async {
    final plot = await _plotById(plotId);
    final talhaoLevantamento =
        await (_database.select(_database.talhaoLevantamentos)
              ..where((table) => table.id.equals(plot.talhaoLevantamentoId)))
            .getSingle();
    final now = DateTime.now();

    await (_database.update(
      _database.plots,
    )..where((table) => table.id.equals(plotId))).write(
      PlotsCompanion(
        status: status == null ? const Value.absent() : Value(status),
        updatedAt: Value(now),
      ),
    );

    await (_database.update(_database.talhaoLevantamentos)
          ..where((table) => table.id.equals(talhaoLevantamento.id)))
        .write(TalhaoLevantamentosCompanion(updatedAt: Value(now)));

    await (_database.update(
          _database.inventoryRuns,
        )..where((table) => table.id.equals(talhaoLevantamento.inventoryRunId)))
        .write(InventoryRunsCompanion(updatedAt: Value(now)));
  }

  Future<void> _rebuildPlotGeoPointsFromTrees(String plotId) async {
    await (_database.delete(
      _database.plotGeoPoints,
    )..where((table) => table.plotId.equals(plotId))).go();

    final trees =
        await (_database.select(_database.trees)
              ..where((table) => table.plotId.equals(plotId))
              ..orderBy([(table) => OrderingTerm.asc(table.number)]))
            .get();

    final usedPositions = <PlotReferencePosition>{};
    for (final tree in trees) {
      final reference = tree.plotReferencePosition;
      if (reference == null ||
          tree.latitude == null ||
          tree.longitude == null ||
          usedPositions.contains(reference)) {
        continue;
      }

      usedPositions.add(reference);
      await _database
          .into(_database.plotGeoPoints)
          .insert(
            PlotGeoPointsCompanion.insert(
              id: _uuid.v4(),
              plotId: plotId,
              pointOrder: _pointOrder(reference),
              referencePosition: Value(reference),
              latitude: tree.latitude!,
              longitude: tree.longitude!,
              accuracyMeters: Value(tree.accuracyMeters),
              capturedAt: tree.locationCapturedAt ?? tree.updatedAt,
            ),
          );
    }
  }

  Future<TreeRecord> _treeById(String treeId) {
    return (_database.select(
      _database.trees,
    )..where((table) => table.id.equals(treeId))).getSingle();
  }

  Future<PlotRecord> _plotById(String plotId) {
    return (_database.select(
      _database.plots,
    )..where((table) => table.id.equals(plotId))).getSingle();
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

  Future<void> _clearReferencePositionFromTrees({
    required String plotId,
    required PlotReferencePosition referencePosition,
  }) {
    return (_database.update(_database.trees)..where(
          (table) =>
              table.plotId.equals(plotId) &
              table.plotReferencePosition.equalsValue(referencePosition),
        ))
        .write(
          TreesCompanion(
            plotReferencePosition: const Value<PlotReferencePosition?>(null),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }
}

class _CollectionContext {
  const _CollectionContext({
    required this.plot,
    required this.talhaoLevantamento,
    required this.inventoryRun,
    required this.stand,
    required this.species,
  });

  final PlotRecord plot;
  final TalhaoLevantamentoRecord talhaoLevantamento;
  final InventoryRunRecord inventoryRun;
  final StandRecord stand;
  final SpeciesRecord species;
}

int _pointOrder(PlotReferencePosition reference) {
  switch (reference) {
    case PlotReferencePosition.p1:
      return 1;
    case PlotReferencePosition.p2:
      return 2;
    case PlotReferencePosition.p3:
      return 3;
    case PlotReferencePosition.p4:
      return 4;
  }
}
