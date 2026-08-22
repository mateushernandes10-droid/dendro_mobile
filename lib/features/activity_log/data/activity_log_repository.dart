import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/providers/database_providers.dart';

final activityLogRepositoryProvider = Provider<ActivityLogRepository>((ref) {
  return ActivityLogRepository(ref.watch(dendroDatabaseProvider));
});

final recentActivityLogsProvider =
    StreamProvider.autoDispose<List<ActivityLogEntry>>((ref) {
      return ref.watch(activityLogRepositoryProvider).watchRecent(limit: 4);
    });

final activityHistoryProvider =
    StreamProvider.autoDispose<List<ActivityLogEntry>>((ref) {
      return ref.watch(activityLogRepositoryProvider).watchRecent(limit: 100);
    });

enum ActivityLogType {
  propertyCreated,
  propertyUpdated,
  propertyDeleted,
  standCreated,
  standUpdated,
  standDeleted,
  plotCreated,
  plotUpdated,
  plotDeleted,
  plotCollected,
  speciesCreated,
  speciesUpdated,
  speciesDeleted,
  speciesFormulaLinked,
  speciesFormulaUnlinked,
  speciesDefaultFormulaChanged,
  formulaCreated,
  formulaUpdated,
  formulaDeleted,
  formulaCoefficientsUpdated,
  inventoryRunStarted,
  inventoryRunCompleted,
  inventoryRunDeleted,
  inventoryRunStandAdded,
  inventoryRunStandUpdated,
  inventoryRunStandRemoved,
  standCompleted,
  exportCreated,
}

enum ActivityEntityType {
  property,
  stand,
  plot,
  species,
  formula,
  inventoryRun,
  export,
}

class ActivityLogEntry {
  const ActivityLogEntry({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.occurredAt,
    this.entityType,
    this.entityId,
  });

  final String id;
  final ActivityLogType type;
  final String title;
  final String subtitle;
  final DateTime occurredAt;
  final ActivityEntityType? entityType;
  final String? entityId;
}

class ActivityLogRepository {
  ActivityLogRepository(this._database);

  final DendroDatabase _database;
  final _uuid = const Uuid();

  static final _changes = StreamController<void>.broadcast();

  Stream<List<ActivityLogEntry>> watchRecent({int limit = 4}) async* {
    yield await recent(limit: limit);
    yield* _changes.stream.asyncMap((_) => recent(limit: limit));
  }

  Future<List<ActivityLogEntry>> recent({int limit = 4}) async {
    final rows = await _database
        .customSelect(
          '''
SELECT id, type, title, subtitle, entity_type, entity_id, occurred_at
FROM activity_logs
ORDER BY occurred_at DESC
LIMIT ?
''',
          variables: [Variable<int>(limit)],
        )
        .get();

    return [for (final row in rows) _entryFromRow(row)];
  }

  Future<void> record({
    required ActivityLogType type,
    required String title,
    String subtitle = '',
    ActivityEntityType? entityType,
    String? entityId,
    DateTime? occurredAt,
  }) async {
    final moment = occurredAt ?? DateTime.now();

    await _database.customStatement(
      '''
INSERT INTO activity_logs
  (id, type, title, subtitle, entity_type, entity_id, occurred_at)
VALUES (?, ?, ?, ?, ?, ?, ?)
''',
      [
        _uuid.v4(),
        type.name,
        title.trim(),
        subtitle.trim(),
        entityType?.name,
        entityId,
        moment.millisecondsSinceEpoch,
      ],
    );
    _changes.add(null);
  }

  Future<void> recordExport({
    required String format,
    required String propertyName,
    String? entityId,
  }) {
    return record(
      type: ActivityLogType.exportCreated,
      title: 'Exportacao realizada',
      subtitle: '$format - $propertyName',
      entityType: ActivityEntityType.export,
      entityId: entityId,
    );
  }

  ActivityLogEntry _entryFromRow(QueryRow row) {
    return ActivityLogEntry(
      id: row.read<String>('id'),
      type: _parseType(row.read<String>('type')),
      title: row.read<String>('title'),
      subtitle: row.read<String>('subtitle'),
      entityType: _parseEntityType(row.readNullable<String>('entity_type')),
      entityId: row.readNullable<String>('entity_id'),
      occurredAt: DateTime.fromMillisecondsSinceEpoch(
        row.read<int>('occurred_at'),
      ),
    );
  }
}

ActivityLogType _parseType(String value) {
  for (final type in ActivityLogType.values) {
    if (type.name == value) return type;
  }
  return ActivityLogType.propertyUpdated;
}

ActivityEntityType? _parseEntityType(String? value) {
  if (value == null) return null;
  for (final type in ActivityEntityType.values) {
    if (type.name == value) return type;
  }
  return null;
}
