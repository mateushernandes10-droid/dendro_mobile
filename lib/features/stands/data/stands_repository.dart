import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/providers/database_providers.dart';
import '../../activity_log/data/activity_log_repository.dart';

final standsRepositoryProvider = Provider<StandsRepository>((ref) {
  return StandsRepository(ref.watch(dendroDatabaseProvider));
});

final activeSpeciesProvider = StreamProvider.autoDispose<List<SpeciesRecord>>((
  ref,
) {
  return ref.watch(standsRepositoryProvider).watchActiveSpecies();
});

final propertyStandsProvider = StreamProvider.autoDispose
    .family<List<StandSummary>, String>((ref, propertyId) {
      return ref.watch(standsRepositoryProvider).watchByProperty(propertyId);
    });

final inventoryStartOptionsProvider =
    StreamProvider.autoDispose<List<InventoryStartPropertyOption>>((ref) {
      return ref.watch(standsRepositoryProvider).watchInventoryStartOptions();
    });

class InventoryStartPropertyOption {
  const InventoryStartPropertyOption({
    required this.property,
    required this.stands,
  });

  final PropertyRecord property;
  final List<StandSummary> stands;

  InventoryStartPropertyOption copyWith({List<StandSummary>? stands}) {
    return InventoryStartPropertyOption(
      property: property,
      stands: stands ?? this.stands,
    );
  }
}

class StandSummary {
  const StandSummary({
    required this.stand,
    required this.species,
    required this.talhaoLevantamentoCount,
    required this.hasActiveInventory,
  });

  final StandRecord stand;
  final SpeciesRecord species;
  final int talhaoLevantamentoCount;
  final bool hasActiveInventory;

  bool get hasChildren => talhaoLevantamentoCount > 0;
}

class _StandSummaryAccumulator {
  _StandSummaryAccumulator({required this.stand, required this.species});

  final StandRecord stand;
  final SpeciesRecord species;
  int talhaoLevantamentoCount = 0;
  bool hasActiveInventory = false;

  StandSummary toSummary() {
    return StandSummary(
      stand: stand,
      species: species,
      talhaoLevantamentoCount: talhaoLevantamentoCount,
      hasActiveInventory: hasActiveInventory,
    );
  }
}

class _InventoryStartPropertyAccumulator {
  _InventoryStartPropertyAccumulator(this.property);

  final PropertyRecord property;
  final Map<String, _StandSummaryAccumulator> standsById = {};

  InventoryStartPropertyOption toOption() {
    final stands =
        standsById.values.map((summary) => summary.toSummary()).toList()..sort(
          (a, b) => a.stand.identification.compareTo(b.stand.identification),
        );

    return InventoryStartPropertyOption(property: property, stands: stands);
  }
}

class StandsRepository {
  StandsRepository(this._database);

  final DendroDatabase _database;
  final _uuid = const Uuid();
  late final ActivityLogRepository _activityLog = ActivityLogRepository(
    _database,
  );

  Stream<List<SpeciesRecord>> watchActiveSpecies() {
    return (_database.select(_database.species)
          ..where((table) => table.active.equals(true))
          ..orderBy([(table) => OrderingTerm.asc(table.name)]))
        .watch();
  }

  Stream<List<StandSummary>> watchByProperty(String propertyId) {
    final query =
        _database.select(_database.stands).join([
            innerJoin(
              _database.species,
              _database.species.id.equalsExp(_database.stands.speciesId),
            ),
            leftOuterJoin(
              _database.talhaoLevantamentos,
              _database.talhaoLevantamentos.standId.equalsExp(
                _database.stands.id,
              ),
            ),
            leftOuterJoin(
              _database.inventoryRuns,
              _database.inventoryRuns.id.equalsExp(
                _database.talhaoLevantamentos.inventoryRunId,
              ),
            ),
          ])
          ..where(_database.stands.propertyId.equals(propertyId))
          ..orderBy([OrderingTerm.asc(_database.stands.identification)]);

    return query.watch().map((rows) {
      final summariesByStand = <String, _StandSummaryAccumulator>{};

      for (final row in rows) {
        final stand = row.readTable(_database.stands);
        final summary = summariesByStand.putIfAbsent(
          stand.id,
          () => _StandSummaryAccumulator(
            stand: stand,
            species: row.readTable(_database.species),
          ),
        );

        final talhaoLevantamento = row.readTableOrNull(
          _database.talhaoLevantamentos,
        );
        if (talhaoLevantamento == null) continue;

        summary.talhaoLevantamentoCount++;
        final inventoryRun = row.readTableOrNull(_database.inventoryRuns);
        if (inventoryRun?.status == InventoryRunStatus.inProgress) {
          summary.hasActiveInventory = true;
        }
      }

      return summariesByStand.values
          .map((summary) => summary.toSummary())
          .toList();
    });
  }

  Stream<List<InventoryStartPropertyOption>> watchInventoryStartOptions() {
    final query =
        _database.select(_database.properties).join([
          leftOuterJoin(
            _database.stands,
            _database.stands.propertyId.equalsExp(_database.properties.id),
          ),
          leftOuterJoin(
            _database.species,
            _database.species.id.equalsExp(_database.stands.speciesId),
          ),
          leftOuterJoin(
            _database.talhaoLevantamentos,
            _database.talhaoLevantamentos.standId.equalsExp(
              _database.stands.id,
            ),
          ),
          leftOuterJoin(
            _database.inventoryRuns,
            _database.inventoryRuns.id.equalsExp(
              _database.talhaoLevantamentos.inventoryRunId,
            ),
          ),
        ])..orderBy([
          OrderingTerm.asc(_database.properties.name),
          OrderingTerm.asc(_database.stands.identification),
        ]);

    return query.watch().map((rows) {
      final propertiesById = <String, _InventoryStartPropertyAccumulator>{};

      for (final row in rows) {
        final property = row.readTable(_database.properties);
        final propertySummary = propertiesById.putIfAbsent(
          property.id,
          () => _InventoryStartPropertyAccumulator(property),
        );

        final stand = row.readTableOrNull(_database.stands);
        final species = row.readTableOrNull(_database.species);
        if (stand == null || species == null) continue;

        final standSummary = propertySummary.standsById.putIfAbsent(
          stand.id,
          () => _StandSummaryAccumulator(stand: stand, species: species),
        );

        final talhaoLevantamento = row.readTableOrNull(
          _database.talhaoLevantamentos,
        );
        if (talhaoLevantamento == null) continue;

        standSummary.talhaoLevantamentoCount++;
        final inventoryRun = row.readTableOrNull(_database.inventoryRuns);
        if (inventoryRun?.status == InventoryRunStatus.inProgress) {
          standSummary.hasActiveInventory = true;
        }
      }

      return propertiesById.values
          .map((summary) => summary.toOption())
          .toList();
    });
  }

  Future<String> create({
    required String propertyId,
    required String identification,
    required String speciesId,
    required double areaHa,
    int? plantingYear,
    String? spacing,
    String? managementRegime,
    String? notes,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final standName = identification.trim();
    final property = await _propertyById(propertyId);

    await _database.transaction(() async {
      await _database
          .into(_database.stands)
          .insert(
            StandsCompanion.insert(
              id: id,
              propertyId: propertyId,
              identification: standName,
              speciesId: speciesId,
              areaHa: areaHa,
              plantingYear: Value(plantingYear),
              spacing: Value(_blankToNull(spacing)),
              managementRegime: Value(_blankToNull(managementRegime)),
              notes: Value(_blankToNull(notes)),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await _activityLog.record(
        type: ActivityLogType.standCreated,
        title: 'Talhao cadastrado',
        subtitle: _standActivitySubtitle(standName, property),
        entityType: ActivityEntityType.stand,
        entityId: id,
        occurredAt: now,
      );
    });

    return id;
  }

  Future<void> update({
    required String id,
    required String identification,
    required String speciesId,
    required double areaHa,
    int? plantingYear,
    String? spacing,
    String? managementRegime,
    String? notes,
  }) async {
    final current = await _standById(id);
    final property = current == null
        ? null
        : await _propertyById(current.propertyId);
    final now = DateTime.now();
    final standName = identification.trim();

    await _database.transaction(() async {
      await (_database.update(
        _database.stands,
      )..where((table) => table.id.equals(id))).write(
        StandsCompanion(
          identification: Value(standName),
          speciesId: Value(speciesId),
          areaHa: Value(areaHa),
          plantingYear: Value(plantingYear),
          spacing: Value(_blankToNull(spacing)),
          managementRegime: Value(_blankToNull(managementRegime)),
          notes: Value(_blankToNull(notes)),
          updatedAt: Value(now),
        ),
      );

      await _activityLog.record(
        type: ActivityLogType.standUpdated,
        title: 'Talhao atualizado',
        subtitle: _standActivitySubtitle(standName, property),
        entityType: ActivityEntityType.stand,
        entityId: id,
        occurredAt: now,
      );
    });
  }

  Future<void> delete(String id) async {
    final stand = await _standById(id);
    final property = stand == null
        ? null
        : await _propertyById(stand.propertyId);

    await _database.transaction(() async {
      await (_database.delete(
        _database.stands,
      )..where((table) => table.id.equals(id))).go();

      if (stand == null) return;
      await _activityLog.record(
        type: ActivityLogType.standDeleted,
        title: 'Talhao excluido',
        subtitle: _standActivitySubtitle(stand.identification, property),
        entityType: ActivityEntityType.stand,
        entityId: id,
      );
    });
  }

  Future<StandSummary?> getSummary(String id) async {
    final query = _database.select(_database.stands).join([
      innerJoin(
        _database.species,
        _database.species.id.equalsExp(_database.stands.speciesId),
      ),
    ])..where(_database.stands.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final stand = row.readTable(_database.stands);
    return StandSummary(
      stand: stand,
      species: row.readTable(_database.species),
      talhaoLevantamentoCount: await _countTalhaoLevantamentos(stand.id),
      hasActiveInventory: await _hasActiveInventory(stand.id),
    );
  }

  Future<int> _countTalhaoLevantamentos(String standId) async {
    final count = _database.talhaoLevantamentos.id.count();

    final row =
        await (_database.selectOnly(_database.talhaoLevantamentos)
              ..addColumns([count])
              ..where(_database.talhaoLevantamentos.standId.equals(standId)))
            .getSingle();

    return row.read(count) ?? 0;
  }

  Future<bool> _hasActiveInventory(String standId) async {
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
                _database.inventoryRuns.status.equalsValue(
                  InventoryRunStatus.inProgress,
                ),
          )
          ..limit(1);

    return await query.getSingleOrNull() != null;
  }

  Future<StandRecord?> _standById(String id) {
    return (_database.select(
      _database.stands,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<PropertyRecord?> _propertyById(String id) {
    return (_database.select(
      _database.properties,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }
}

String _standActivitySubtitle(String standName, PropertyRecord? property) {
  if (property == null) return standName;
  return '$standName - ${property.name}';
}

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}
