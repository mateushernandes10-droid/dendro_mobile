import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/providers/database_providers.dart';

final propertiesRepositoryProvider = Provider<PropertiesRepository>((ref) {
  return PropertiesRepository(ref.watch(dendroDatabaseProvider));
});

class PropertiesRepository {
  PropertiesRepository(this._database);

  final DendroDatabase _database;
  final _uuid = const Uuid();

  Stream<List<PropertyRecord>> watchAll() {
    return (_database.select(
      _database.properties,
    )..orderBy([(table) => OrderingTerm.asc(table.name)])).watch();
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

  Future<String> create({
    required String name,
    required String municipality,
    String state = 'RS',
    required double totalAreaHa,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    await _database
        .into(_database.properties)
        .insert(
          PropertiesCompanion.insert(
            id: id,
            name: name.trim(),
            municipality: municipality.trim(),
            state: Value(state.trim()),
            totalAreaHa: totalAreaHa,
            createdAt: now,
            updatedAt: now,
          ),
        );

    return id;
  }
}
