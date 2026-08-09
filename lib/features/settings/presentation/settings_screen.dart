import 'package:flutter/material.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../shared/widgets/dendro_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DendroScreen(
      title: 'Ajustes',
      icon: Icons.settings,
      children: const [
        SectionTitle(title: 'Cadastros'),
        _SettingsTile(
          icon: Icons.eco,
          title: 'Espécies',
          subtitle: 'Pinus, Eucalyptus e associações de fórmulas',
        ),
        _SettingsTile(
          icon: Icons.functions,
          title: 'Fórmulas e modelos',
          subtitle: 'Spurr, Schumacher-Hall e fórmulas personalizadas',
        ),
        SizedBox(height: 18),
        SectionTitle(title: 'Modelos matemáticos'),
        _FormulaPreview(
          title: 'Modelo de Spurr',
          expression: 'V = a + b * (DAP^2 * H)',
          coefficients: ['a = -0,0152', 'b = 0,0003'],
        ),
        SizedBox(height: 10),
        _FormulaPreview(
          title: 'Schumacher-Hall',
          expression: 'Ln(V) = a + b*Ln(DAP) + c*Ln(H)',
          coefficients: ['a = -9,8732', 'b = 1,9542', 'c = 0,8711'],
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DendroCard(
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: DendroColors.primarySoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: DendroColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: DendroColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Abrir',
            ),
          ],
        ),
      ),
    );
  }
}

class _FormulaPreview extends StatelessWidget {
  const _FormulaPreview({
    required this.title,
    required this.expression,
    required this.coefficients,
  });

  final String title;
  final String expression;
  final List<String> coefficients;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        shape: const RoundedRectangleBorder(),
        collapsedShape: const RoundedRectangleBorder(),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(
          expression,
          style: const TextStyle(
            color: DendroColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
          tooltip: 'Ações',
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final coefficient in coefficients)
                  StatusPill(
                    label: coefficient,
                    color: const Color(0xFFF3F4F3),
                    textColor: DendroColors.text,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text('Salvar alterações'),
            ),
          ),
        ],
      ),
    );
  }
}
