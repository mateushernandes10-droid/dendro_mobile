import 'package:flutter/material.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../shared/widgets/dendro_widgets.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DendroScreen(
      title: 'Resultados',
      icon: Icons.bar_chart,
      floatingActionButton: FloatingActionButton(
        heroTag: 'results_export',
        onPressed: () {},
        tooltip: 'Exportar',
        child: const Icon(Icons.ios_share),
      ),
      children: const [
        _FilterCard(),
        SizedBox(height: 14),
        _TotalVolumeCard(),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Árvores amostradas',
                value: '432',
                icon: Icons.forest,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: MetricTile(
                label: 'DAP médio',
                value: '24,5 cm',
                icon: Icons.straighten,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        SectionTitle(title: 'Distribuição diamétrica'),
        _BarChartMock(),
        SizedBox(height: 20),
        SectionTitle(title: 'Resumo por talhão'),
        _ResultRow(label: 'Talhão 42-B', value: '7.728,46 m³'),
        _ResultRow(label: 'Talhão 43-A', value: '15.919,87 m³'),
        _ResultRow(label: 'Talhão 08', value: '6.506,94 m³'),
      ],
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard();

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFF3F4F3),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: const [
          StatusPill(label: 'Fazenda Esperança'),
          StatusPill(label: 'Talhões 42-B, 43-A'),
          StatusPill(label: 'Pinus taeda'),
        ],
      ),
    );
  }
}

class _TotalVolumeCard extends StatelessWidget {
  const _TotalVolumeCard();

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: DendroColors.primary,
      borderColor: DendroColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Column(
        children: [
          Text(
            'Volume estimado total'.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '1.245,6 m³',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Estimativa parcial com dados validados',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.74),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChartMock extends StatelessWidget {
  const _BarChartMock();

  static const _bars = [0.22, 0.46, 0.82, 0.55, 0.28, 0.12];

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
      child: SizedBox(
        height: 172,
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final height in _bars)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FractionallySizedBox(
                          heightFactor: height,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: height == 0.82
                                  ? DendroColors.primary
                                  : const Color(0xFFA4D1B4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Classes de DAP (cm)',
              style: TextStyle(
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

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DendroCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: DendroColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
