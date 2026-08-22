import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../core/database/dendro_database.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import '../data/inventory_runs_repository.dart';
import 'inventory_run_detail_screen.dart';
import 'new_inventory_screen.dart';

class InventoryRunsScreen extends ConsumerWidget {
  const InventoryRunsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runs = ref.watch(inventoryRunsProvider);

    return DendroScreen(
      title: 'Levantamentos',
      icon: Icons.assignment,
      floatingActionButton: FloatingActionButton(
        heroTag: 'inventory_runs_new_inventory',
        onPressed: () => _openNewInventory(context, ref),
        tooltip: 'Novo levantamento',
        child: const Icon(Icons.add),
      ),
      children: [
        runs.when(
          data: (items) {
            if (items.isEmpty) {
              return _EmptyRunsCard(
                onCreate: () => _openNewInventory(context, ref),
              );
            }

            return Column(
              children: [
                for (final summary in items)
                  _RunCard(
                    summary: summary,
                    onOpen: () => _openRun(context, summary.run.id),
                  ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => _LoadErrorCard(
            onRetry: () => ref.invalidate(inventoryRunsProvider),
          ),
        ),
      ],
    );
  }

  Future<void> _openNewInventory(BuildContext context, WidgetRef ref) async {
    final runId = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (context) => const NewInventoryScreen(),
      ),
    );

    ref.invalidate(inventoryRunsProvider);
    ref.invalidate(activeInventoryRunsProvider);
    ref.invalidate(activeInventoryRunProvider);

    if (runId == null || !context.mounted) return;
    await _openRun(context, runId);
  }

  Future<void> _openRun(BuildContext context, String runId) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => InventoryRunDetailScreen(runId: runId),
      ),
    );
  }
}

class _RunCard extends StatelessWidget {
  const _RunCard({required this.summary, required this.onOpen});

  final InventoryRunSummary summary;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final status = summary.run.status;
    final highlighted = status == InventoryRunStatus.inProgress;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onOpen,
        child: DendroCard(
          backgroundColor: highlighted ? const Color(0xFFE0F2E8) : Colors.white,
          borderColor: highlighted
              ? const Color(0xFFA4D1B4)
              : DendroColors.outline,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: highlighted
                      ? DendroColors.primary
                      : DendroColors.primarySoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  highlighted ? Icons.play_arrow : Icons.check,
                  color: highlighted ? Colors.white : DendroColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: StatusPill(label: _statusLabel(status)),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      summary.property.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Início ${_formatDate(summary.run.startedAt)} • ${_standCountLabel(summary.stands.length)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: DendroColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _RunStandsList(stands: summary.stands),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        _RunDetail(
                          icon: Icons.forest,
                          label: '${summary.treeCount} árvores',
                        ),
                        _RunDetail(
                          icon: Icons.area_chart,
                          label: '${_formatArea(summary.measuredAreaHa)} ha',
                        ),
                        _RunDetail(
                          icon: Icons.grid_view,
                          label:
                              '${summary.collectedPlotCount}/${summary.plotCount} parcelas',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right, color: DendroColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _RunStandsList extends StatelessWidget {
  const _RunStandsList({required this.stands});

  final List<InventoryStandSummary> stands;

  @override
  Widget build(BuildContext context) {
    if (stands.isEmpty) {
      return const Text(
        'Sem talhão vinculado',
        style: TextStyle(
          color: DendroColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Column(
      children: [
        for (var index = 0; index < stands.length; index++) ...[
          if (index > 0)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: Divider(height: 1),
            ),
          _RunStandRow(summary: stands[index]),
        ],
      ],
    );
  }
}

class _RunStandRow extends StatelessWidget {
  const _RunStandRow({required this.summary});

  final InventoryStandSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.forest_outlined,
            size: 17,
            color: DendroColors.primary,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                summary.stand.identification,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: DendroColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${summary.species.name} • ${summary.treeCount} árvores • ${summary.collectedPlotCount}/${summary.plotCount} parcelas • ${_formatArea(summary.measuredAreaHa)} ha',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: DendroColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RunDetail extends StatelessWidget {
  const _RunDetail({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: DendroColors.secondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: DendroColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _EmptyRunsCard extends StatelessWidget {
  const _EmptyRunsCard({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFF3F4F3),
      child: Column(
        children: [
          const Icon(
            Icons.assignment_outlined,
            size: 42,
            color: DendroColors.secondary,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhum levantamento registrado',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Crie um levantamento para iniciar a coleta de campo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: DendroColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Novo levantamento'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadErrorCard extends StatelessWidget {
  const _LoadErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(height: 10),
          const Text(
            'Não foi possível carregar os levantamentos.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}

String _statusLabel(InventoryRunStatus status) {
  switch (status) {
    case InventoryRunStatus.planning:
      return 'Planejado';
    case InventoryRunStatus.inProgress:
      return 'Em andamento';
    case InventoryRunStatus.completed:
      return 'Concluído';
  }
}

String _formatDate(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final year = value.year.toString();
  return '$day/$month/$year';
}

String _standCountLabel(int count) {
  if (count == 0) return 'sem talhão';
  if (count == 1) return '1 talhão';
  return '$count talhões';
}

String _formatArea(double value) {
  return value.toStringAsFixed(2).replaceAll('.', ',');
}
