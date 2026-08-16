import 'package:flutter/material.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import 'inventory_run_detail_screen.dart';
import 'new_inventory_screen.dart';

class InventoryRunsScreen extends StatelessWidget {
  const InventoryRunsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DendroScreen(
      title: 'Levantamentos',
      icon: Icons.assignment,
      floatingActionButton: FloatingActionButton(
        heroTag: 'inventory_runs_new_inventory',
        onPressed: () => _openNewInventory(context),
        tooltip: 'Novo levantamento',
        child: const Icon(Icons.add),
      ),
      children: const [
        _RunCard(
          date: '09/08/2026',
          property: 'Fazenda Esperança',
          stands: 'Talhões 42-B e 43-A',
          status: 'Em andamento',
          trees: '65 árvores',
          area: '1,2 ha medidos',
          highlighted: true,
        ),
        SizedBox(height: 10),
        _RunCard(
          date: '05/08/2026',
          property: 'Fazenda Boa Vista',
          stands: 'Talhão 08',
          status: 'Concluído',
          trees: '432 árvores',
          area: '8,4 ha medidos',
        ),
        SizedBox(height: 10),
        _RunCard(
          date: '31/07/2026',
          property: 'Fazenda Santa Clara',
          stands: 'Talhões P-01, P-02 e E-01',
          status: 'Concluído',
          trees: '816 árvores',
          area: '12,7 ha medidos',
        ),
      ],
    );
  }

  Future<void> _openNewInventory(BuildContext context) async {
    final runId = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (context) => const NewInventoryScreen(),
      ),
    );

    if (runId == null || !context.mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => InventoryRunDetailScreen(runId: runId),
      ),
    );
  }
}

class _RunCard extends StatelessWidget {
  const _RunCard({
    required this.date,
    required this.property,
    required this.stands,
    required this.status,
    required this.trees,
    required this.area,
    this.highlighted = false,
  });

  final String date;
  final String property;
  final String stands;
  final String status;
  final String trees;
  final String area;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: highlighted ? const Color(0xFFE0F2E8) : Colors.white,
      borderColor: highlighted ? const Color(0xFFA4D1B4) : DendroColors.outline,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        property,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    StatusPill(label: status),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '$date - $stands',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: DendroColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(trees, style: _detailStyle),
                    const SizedBox(width: 12),
                    Text(area, style: _detailStyle),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _detailStyle = TextStyle(
    color: DendroColors.primary,
    fontSize: 12,
    fontWeight: FontWeight.w900,
  );
}
