import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../core/database/dendro_database.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import '../../plots/presentation/stand_plots_screen.dart';
import '../data/inventory_runs_repository.dart';

class InventoryRunDetailScreen extends ConsumerWidget {
  const InventoryRunDetailScreen({required this.runId, super.key});

  final String runId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(inventoryRunDetailProvider(runId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Levantamento'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: DendroLogoMark(size: 32)),
          ),
        ],
      ),
      body: SafeArea(
        child: detail.when(
          data: (summary) {
            if (summary == null) {
              return const _MissingRun();
            }

            return _InventoryRunBody(summary: summary);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _LoadError(
            onRetry: () => ref.invalidate(inventoryRunDetailProvider(runId)),
          ),
        ),
      ),
    );
  }
}

class _InventoryRunBody extends StatelessWidget {
  const _InventoryRunBody({required this.summary});

  final InventoryRunSummary summary;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _RunSummaryCard(summary: summary),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Árvores medidas',
                value: summary.treeCount.toString(),
                icon: Icons.park_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricTile(
                label: 'Área medida',
                value: _formatArea(summary.measuredAreaHa),
                icon: Icons.area_chart_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: 'Talhões do levantamento',
          trailing: StatusPill(label: '${summary.stands.length} total'),
        ),
        if (summary.stands.isEmpty)
          const DendroCard(
            child: Text(
              'Nenhum talhão vinculado a este levantamento.',
              style: TextStyle(
                color: DendroColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          for (final stand in summary.stands)
            _InventoryStandCard(
              summary: stand,
              onOpen: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => StandPlotsScreen(
                    standId: stand.stand.id,
                    talhaoLevantamentoId: stand.talhaoLevantamento.id,
                    showStartInventoryAction: false,
                    enableTreeCollection: true,
                  ),
                ),
              ),
            ),
      ],
    );
  }
}

class _RunSummaryCard extends StatelessWidget {
  const _RunSummaryCard({required this.summary});

  final InventoryRunSummary summary;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFE0F2E8),
      borderColor: const Color(0xFFA4D1B4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusPill(label: _statusLabel(summary.run.status)),
              const Spacer(),
              const Icon(Icons.assignment, color: DendroColors.primary),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary.property.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: DendroColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${summary.property.municipality}-${summary.property.state} • ${summary.standLabel}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: DendroColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Iniciado em ${_formatDateTime(summary.run.startedAt)}',
            style: const TextStyle(
              color: DendroColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryStandCard extends StatelessWidget {
  const _InventoryStandCard({required this.summary, required this.onOpen});

  final InventoryStandSummary summary;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DendroCard(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DendroColors.primarySoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.forest, color: DendroColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summary.stand.identification,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        summary.species.name,
                        style: const TextStyle(
                          color: DendroColors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusPill(
                  label: '${summary.collectedPlotCount}/${summary.plotCount}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InlineInfo(
                    label: 'Árvores',
                    value: summary.treeCount.toString(),
                  ),
                ),
                Expanded(
                  child: _InlineInfo(
                    label: 'Área medida',
                    value: _formatArea(summary.measuredAreaHa),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onOpen,
                icon: const Icon(Icons.grid_view),
                label: const Text('Abrir parcelas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineInfo extends StatelessWidget {
  const _InlineInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: DendroColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: DendroColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _MissingRun extends StatelessWidget {
  const _MissingRun();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: DendroCard(
          child: Text(
            'Levantamento não encontrado.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DendroCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(height: 10),
              const Text(
                'Não foi possível carregar o levantamento.',
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
        ),
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

String _formatArea(double value) {
  return '${value.toStringAsFixed(2).replaceAll('.', ',')} ha';
}

String _formatDateTime(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final year = value.year.toString();
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');

  return '$day/$month/$year às $hour:$minute';
}
