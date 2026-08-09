import 'package:flutter/material.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../shared/widgets/dendro_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DendroScreen(
      title: 'Início',
      icon: Icons.home,
      actions: const [DendroLogoMark()],
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Novo Levantamento'),
        ),
        const SizedBox(height: 14),
        const _ActiveCollectionCard(),
        const SizedBox(height: 20),
        const SectionTitle(title: 'Resumo atual'),
        const Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Árvores medidas',
                value: '1.248',
                icon: Icons.park_outlined,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: MetricTile(
                label: 'Área medida',
                value: '452 ha',
                icon: Icons.area_chart_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SectionTitle(
          title: 'Atividade recente',
          trailing: TextButton(
            onPressed: () {},
            child: const Text('Ver todas'),
          ),
        ),
        const _ActivityItem(
          icon: Icons.check_circle,
          title: 'Parcela P-12 coletada',
          subtitle: 'Talhão 42-B - Pinus taeda',
          time: '14:30',
        ),
        const _ActivityItem(
          icon: Icons.add_location_alt,
          title: 'Nova parcela iniciada',
          subtitle: 'P-13 com ponto P1 salvo',
          time: '13:48',
        ),
        const _ActivityItem(
          icon: Icons.ios_share,
          title: 'Exportação realizada',
          subtitle: 'Relatório PDF - Fazenda Esperança',
          time: 'Ontem',
        ),
        const _ActivityItem(
          icon: Icons.home_work,
          title: 'Propriedade cadastrada',
          subtitle: 'Fazenda Boa Vista',
          time: 'Ontem',
        ),
      ],
    );
  }
}

class _ActiveCollectionCard extends StatelessWidget {
  const _ActiveCollectionCard();

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFE0F2E8),
      borderColor: const Color(0xFFA4D1B4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              StatusPill(label: 'Em andamento'),
              Spacer(),
              Icon(Icons.play_arrow_rounded, color: DendroColors.primary),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Talhão 42-B',
            style: TextStyle(
              color: DendroColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Fazenda Esperança - Setor Norte',
            style: TextStyle(
              color: DendroColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Divider(height: 24),
          const Row(
            children: [
              Expanded(
                child: _InlineMetric(label: 'Árvores medidas', value: '65'),
              ),
              Expanded(
                child: _InlineMetric(label: 'Área medida', value: '1,2 ha'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.forest, size: 18),
              label: const Text('Continuar Coleta'),
              style: FilledButton.styleFrom(
                backgroundColor: DendroColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineMetric extends StatelessWidget {
  const _InlineMetric({required this.label, required this.value});

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
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

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
              child: Icon(icon, size: 18, color: DendroColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    subtitle,
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
              time,
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
