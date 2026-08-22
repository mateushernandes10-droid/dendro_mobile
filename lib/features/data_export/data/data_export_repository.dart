import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/providers/database_providers.dart';
import '../../activity_log/data/activity_log_repository.dart';

final dataExportRepositoryProvider = Provider<DataExportRepository>((ref) {
  return DataExportRepository(ref.watch(dendroDatabaseProvider));
});

final dataExportProvider = FutureProvider.autoDispose
    .family<DataExportState, DataExportRequest>((ref, request) {
      return ref.watch(dataExportRepositoryProvider).load(request);
    });

class DataExportRequest {
  const DataExportRequest({
    this.propertyId,
    this.inventoryRunId,
    this.speciesId,
  });

  final String? propertyId;
  final String? inventoryRunId;
  final String? speciesId;

  @override
  bool operator ==(Object other) {
    return other is DataExportRequest &&
        other.propertyId == propertyId &&
        other.inventoryRunId == inventoryRunId &&
        other.speciesId == speciesId;
  }

  @override
  int get hashCode => Object.hash(propertyId, inventoryRunId, speciesId);
}

class DataExportState {
  const DataExportState({
    required this.properties,
    required this.property,
    required this.inventoryRun,
    required this.stands,
  });

  final List<PropertyRecord> properties;
  final PropertyRecord? property;
  final InventoryRunRecord? inventoryRun;
  final List<DataExportStandOption> stands;
}

class DataExportStandOption {
  const DataExportStandOption({
    required this.talhaoLevantamento,
    required this.stand,
    required this.species,
    required this.plotCount,
    required this.collectedPlotCount,
    required this.treeCount,
    required this.measuredAreaHa,
    required this.geoPointCount,
  });

  final TalhaoLevantamentoRecord talhaoLevantamento;
  final StandRecord stand;
  final SpeciesRecord species;
  final int plotCount;
  final int collectedPlotCount;
  final int treeCount;
  final double measuredAreaHa;
  final int geoPointCount;

  bool get hasData => plotCount > 0 || treeCount > 0 || geoPointCount > 0;
}

class DataExportRepository {
  DataExportRepository(this._database);

  final DendroDatabase _database;
  late final ActivityLogRepository _activityLog = ActivityLogRepository(
    _database,
  );

  Future<DataExportState> load(DataExportRequest request) async {
    final properties = await _properties();
    final run = request.inventoryRunId == null
        ? null
        : await _inventoryRunById(request.inventoryRunId!);
    final propertyId = run?.propertyId ?? request.propertyId;
    final property = propertyId == null
        ? null
        : await _propertyById(propertyId);
    final stands = run == null
        ? await _latestStandOptionsForProperty(
            propertyId: propertyId,
            speciesId: request.speciesId,
          )
        : await _standOptionsForRun(
            runId: run.id,
            speciesId: request.speciesId,
          );

    return DataExportState(
      properties: properties,
      property: property,
      inventoryRun: run,
      stands: stands,
    );
  }

  Future<void> recordExport({
    required List<String> formats,
    required PropertyRecord property,
    required int standCount,
  }) {
    final formatLabel = formats.join(', ');
    final standLabel = standCount == 1 ? '1 talhão' : '$standCount talhões';
    return _activityLog.recordExport(
      format: '$formatLabel - $standLabel',
      propertyName: property.name,
      entityId: property.id,
    );
  }

  Future<List<PropertyRecord>> _properties() {
    return (_database.select(
      _database.properties,
    )..orderBy([(table) => OrderingTerm.asc(table.name)])).get();
  }

  Future<PropertyRecord?> _propertyById(String id) {
    return (_database.select(
      _database.properties,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<InventoryRunRecord?> _inventoryRunById(String id) {
    return (_database.select(
      _database.inventoryRuns,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<List<DataExportStandOption>> _standOptionsForRun({
    required String runId,
    String? speciesId,
  }) async {
    final conditions = <Expression<bool>>[
      _database.talhaoLevantamentos.inventoryRunId.equals(runId),
    ];
    if (speciesId != null) {
      conditions.add(_database.talhaoLevantamentos.speciesId.equals(speciesId));
    }

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
          ..where(conditions.reduce((value, element) => value & element))
          ..orderBy([OrderingTerm.asc(_database.stands.identification)]);

    return _optionsFromRows(await query.get());
  }

  Future<List<DataExportStandOption>> _latestStandOptionsForProperty({
    required String? propertyId,
    String? speciesId,
  }) async {
    if (propertyId == null) return const [];

    final conditions = <Expression<bool>>[
      _database.stands.propertyId.equals(propertyId),
    ];
    if (speciesId != null) {
      conditions.add(_database.talhaoLevantamentos.speciesId.equals(speciesId));
    }

    final query =
        _database.select(_database.talhaoLevantamentos).join([
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
          ])
          ..where(conditions.reduce((value, element) => value & element))
          ..orderBy([
            OrderingTerm.asc(_database.stands.identification),
            OrderingTerm.desc(_database.talhaoLevantamentos.updatedAt),
          ]);

    final latestRowsByStandId = <String, TypedResult>{};
    for (final row in await query.get()) {
      final stand = row.readTable(_database.stands);
      latestRowsByStandId.putIfAbsent(stand.id, () => row);
    }

    return _optionsFromRows(latestRowsByStandId.values.toList());
  }

  Future<List<DataExportStandOption>> _optionsFromRows(
    List<TypedResult> rows,
  ) async {
    final options = <DataExportStandOption>[];

    for (final row in rows) {
      final talhao = row.readTable(_database.talhaoLevantamentos);
      options.add(
        DataExportStandOption(
          talhaoLevantamento: talhao,
          stand: row.readTable(_database.stands),
          species: row.readTable(_database.species),
          plotCount: await _countPlots(talhao.id),
          collectedPlotCount: await _countCollectedPlots(talhao.id),
          treeCount: await _countTrees(talhao.id),
          measuredAreaHa: await _sumMeasuredArea(talhao.id),
          geoPointCount: await _countGeoPoints(talhao.id),
        ),
      );
    }

    options.sort(
      (a, b) => a.stand.identification.compareTo(b.stand.identification),
    );
    return options;
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

  Future<int> _countGeoPoints(String talhaoLevantamentoId) async {
    final plotPointRows = await _database
        .customSelect(
          '''
SELECT COUNT(*) AS count
FROM plot_geo_points point
INNER JOIN plots plot ON plot.id = point.plot_id
WHERE plot.talhao_levantamento_id = ?
''',
          variables: [Variable<String>(talhaoLevantamentoId)],
        )
        .getSingle();
    final treePointRows = await _database
        .customSelect(
          '''
SELECT COUNT(*) AS count
FROM trees tree
INNER JOIN plots plot ON plot.id = tree.plot_id
WHERE plot.talhao_levantamento_id = ?
  AND tree.latitude IS NOT NULL
  AND tree.longitude IS NOT NULL
''',
          variables: [Variable<String>(talhaoLevantamentoId)],
        )
        .getSingle();

    return (plotPointRows.read<int>('count')) +
        (treePointRows.read<int>('count'));
  }
}
