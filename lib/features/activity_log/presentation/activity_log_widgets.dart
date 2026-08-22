import 'package:flutter/material.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import '../data/activity_log_repository.dart';

class ActivityLogItem extends StatelessWidget {
  const ActivityLogItem({
    required this.activity,
    required this.displayTime,
    super.key,
  });

  final ActivityLogEntry activity;
  final String displayTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DendroCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: DendroColors.primarySoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                activityIcon(activity.type),
                size: 18,
                color: DendroColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    activity.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: DendroColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              displayTime,
              style: const TextStyle(
                color: DendroColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData activityIcon(ActivityLogType type) {
  switch (type) {
    case ActivityLogType.propertyCreated:
    case ActivityLogType.propertyUpdated:
    case ActivityLogType.propertyDeleted:
      return Icons.home_work_outlined;
    case ActivityLogType.standCreated:
    case ActivityLogType.standUpdated:
    case ActivityLogType.standDeleted:
    case ActivityLogType.standCompleted:
    case ActivityLogType.inventoryRunStandAdded:
    case ActivityLogType.inventoryRunStandUpdated:
    case ActivityLogType.inventoryRunStandRemoved:
      return Icons.forest_outlined;
    case ActivityLogType.plotCreated:
    case ActivityLogType.plotUpdated:
    case ActivityLogType.plotDeleted:
      return Icons.grid_view_outlined;
    case ActivityLogType.plotCollected:
      return Icons.check_circle_outline;
    case ActivityLogType.speciesCreated:
    case ActivityLogType.speciesUpdated:
    case ActivityLogType.speciesDeleted:
    case ActivityLogType.speciesFormulaLinked:
    case ActivityLogType.speciesFormulaUnlinked:
    case ActivityLogType.speciesDefaultFormulaChanged:
      return Icons.eco_outlined;
    case ActivityLogType.formulaCreated:
    case ActivityLogType.formulaUpdated:
    case ActivityLogType.formulaDeleted:
    case ActivityLogType.formulaCoefficientsUpdated:
      return Icons.functions;
    case ActivityLogType.inventoryRunStarted:
    case ActivityLogType.inventoryRunCompleted:
    case ActivityLogType.inventoryRunDeleted:
      return Icons.assignment_outlined;
    case ActivityLogType.exportCreated:
      return Icons.ios_share;
  }
}

String formatActivityLogDate(DateTime occurredAt, DateTime now) {
  final eventDate = DateTime(occurredAt.year, occurredAt.month, occurredAt.day);
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  if (eventDate == today) {
    return '${_twoDigits(occurredAt.hour)}:${_twoDigits(occurredAt.minute)}';
  }

  if (eventDate == yesterday) return 'Ontem';

  return '${_twoDigits(occurredAt.day)}/${_twoDigits(occurredAt.month)}/${occurredAt.year}';
}

String _twoDigits(int value) {
  return value.toString().padLeft(2, '0');
}
