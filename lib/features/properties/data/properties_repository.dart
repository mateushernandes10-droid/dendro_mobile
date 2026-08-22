import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/providers/database_providers.dart';
import '../../activity_log/data/activity_log_repository.dart';

final propertiesRepositoryProvider = Provider<PropertiesRepository>((ref) {
  return PropertiesRepository(ref.watch(dendroDatabaseProvider));
});

final propertySearchQueryProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

final propertySummariesProvider =
    StreamProvider.autoDispose<List<PropertySummary>>((ref) {
      final repository = ref.watch(propertiesRepositoryProvider);
      final searchQuery = ref.watch(propertySearchQueryProvider);

      return repository.watchSummaries(searchQuery: searchQuery);
    });

class PropertySummary {
  const PropertySummary({
    required this.property,
    required this.standCount,
    required this.inventoryRunCount,
  });

  final PropertyRecord property;
  final int standCount;
  final int inventoryRunCount;

  bool get hasChildren => standCount > 0 || inventoryRunCount > 0;
}

class PropertiesRepository {
  PropertiesRepository(this._database);

  final DendroDatabase _database;
  final _uuid = const Uuid();
  late final ActivityLogRepository _activityLog = ActivityLogRepository(
    _database,
  );

  Stream<List<PropertySummary>> watchSummaries({String searchQuery = ''}) {
    final normalizedQuery = searchQuery.trim();

    final statement = _database.select(_database.properties)
      ..orderBy([(table) => OrderingTerm.asc(table.name)]);

    if (normalizedQuery.isNotEmpty) {
      statement.where((table) => table.name.like('%$normalizedQuery%'));
    }

    return statement.watch().asyncMap((properties) async {
      final summaries = <PropertySummary>[];

      for (final property in properties) {
        summaries.add(
          PropertySummary(
            property: property,
            standCount: await _countStands(property.id),
            inventoryRunCount: await _countInventoryRuns(property.id),
          ),
        );
      }

      return summaries;
    });
  }

  Future<List<PropertyRecord>> searchByName(String query) {
    final normalizedQuery = query.trim();

    final statement = _database.select(_database.properties)
      ..orderBy([(table) => OrderingTerm.asc(table.name)]);

    if (normalizedQuery.isNotEmpty) {
      statement.where((table) => table.name.like('%$normalizedQuery%'));
    }

    return statement.get();
  }

  Future<PropertyRecord?> findById(String id) {
    return (_database.select(
      _database.properties,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<String> create({
    required String name,
    required String municipality,
    String state = 'RS',
    required double totalAreaHa,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    final propertyName = name.trim();
    final municipalityName = municipality.trim();
    final stateCode = state.trim();

    await _database.transaction(() async {
      await _database
          .into(_database.properties)
          .insert(
            PropertiesCompanion.insert(
              id: id,
              name: propertyName,
              municipality: municipalityName,
              state: Value(stateCode),
              totalAreaHa: totalAreaHa,
              createdAt: now,
              updatedAt: now,
            ),
          );

      await _activityLog.record(
        type: ActivityLogType.propertyCreated,
        title: 'Propriedade cadastrada',
        subtitle: '$propertyName - $municipalityName-$stateCode',
        entityType: ActivityEntityType.property,
        entityId: id,
        occurredAt: now,
      );
    });

    return id;
  }

  Future<void> update({
    required String id,
    required String name,
    required String municipality,
    required String state,
    required double totalAreaHa,
  }) async {
    final now = DateTime.now();
    final propertyName = name.trim();
    final municipalityName = municipality.trim();
    final stateCode = state.trim();

    await _database.transaction(() async {
      await (_database.update(
        _database.properties,
      )..where((table) => table.id.equals(id))).write(
        PropertiesCompanion(
          name: Value(propertyName),
          municipality: Value(municipalityName),
          state: Value(stateCode),
          totalAreaHa: Value(totalAreaHa),
          updatedAt: Value(now),
        ),
      );

      await _activityLog.record(
        type: ActivityLogType.propertyUpdated,
        title: 'Propriedade atualizada',
        subtitle: '$propertyName - $municipalityName-$stateCode',
        entityType: ActivityEntityType.property,
        entityId: id,
        occurredAt: now,
      );
    });
  }

  Future<void> delete(String id) async {
    final property = await findById(id);

    await _database.transaction(() async {
      await (_database.delete(
        _database.properties,
      )..where((table) => table.id.equals(id))).go();

      if (property == null) return;
      await _activityLog.record(
        type: ActivityLogType.propertyDeleted,
        title: 'Propriedade excluida',
        subtitle:
            '${property.name} - ${property.municipality}-${property.state}',
        entityType: ActivityEntityType.property,
        entityId: id,
      );
    });
  }

  Future<PropertySummary?> getSummary(String id) async {
    final property = await findById(id);
    if (property == null) return null;

    return PropertySummary(
      property: property,
      standCount: await _countStands(id),
      inventoryRunCount: await _countInventoryRuns(id),
    );
  }

  Future<int> _countStands(String propertyId) async {
    final count = _database.stands.id.count();

    final row =
        await (_database.selectOnly(_database.stands)
              ..addColumns([count])
              ..where(_database.stands.propertyId.equals(propertyId)))
            .getSingle();

    return row.read(count) ?? 0;
  }

  Future<int> _countInventoryRuns(String propertyId) async {
    final count = _database.inventoryRuns.id.count();

    final row =
        await (_database.selectOnly(_database.inventoryRuns)
              ..addColumns([count])
              ..where(_database.inventoryRuns.propertyId.equals(propertyId)))
            .getSingle();

    return row.read(count) ?? 0;
  }
}
