import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/providers/database_providers.dart';

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

class StandSummary {
  const StandSummary({
    required this.stand,
    required this.species,
    required this.talhaoLevantamentoCount,
  });

  final StandRecord stand;
  final SpeciesRecord species;
  final int talhaoLevantamentoCount;

  bool get hasChildren => talhaoLevantamentoCount > 0;
}

class StandsRepository {
  StandsRepository(this._database);

  final DendroDatabase _database;
  final _uuid = const Uuid();

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
          ])
          ..where(_database.stands.propertyId.equals(propertyId))
          ..orderBy([OrderingTerm.asc(_database.stands.identification)]);

    return query.watch().asyncMap((rows) async {
      final summaries = <StandSummary>[];

      for (final row in rows) {
        final stand = row.readTable(_database.stands);
        summaries.add(
          StandSummary(
            stand: stand,
            species: row.readTable(_database.species),
            talhaoLevantamentoCount: await _countTalhaoLevantamentos(stand.id),
          ),
        );
      }

      return summaries;
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

    await _database
        .into(_database.stands)
        .insert(
          StandsCompanion.insert(
            id: id,
            propertyId: propertyId,
            identification: identification.trim(),
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
  }) {
    return (_database.update(
      _database.stands,
    )..where((table) => table.id.equals(id))).write(
      StandsCompanion(
        identification: Value(identification.trim()),
        speciesId: Value(speciesId),
        areaHa: Value(areaHa),
        plantingYear: Value(plantingYear),
        spacing: Value(_blankToNull(spacing)),
        managementRegime: Value(_blankToNull(managementRegime)),
        notes: Value(_blankToNull(notes)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> delete(String id) {
    return (_database.delete(
      _database.stands,
    )..where((table) => table.id.equals(id))).go();
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
}

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}
