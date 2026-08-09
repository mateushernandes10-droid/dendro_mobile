import 'package:flutter/material.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../shared/widgets/dendro_widgets.dart';

class PropertiesScreen extends StatelessWidget {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DendroScreen(
      title: 'Propriedades',
      icon: Icons.map,
      actions: [
        IconButton.filled(
          onPressed: () {},
          icon: const Icon(Icons.add_home_work),
          tooltip: 'Nova propriedade',
        ),
      ],
      children: const [
        _PropertyFilters(),
        SizedBox(height: 16),
        _PropertyItem(
          name: 'Fazenda Esperança',
          municipality: 'Vacaria-RS',
          area: '158,17 ha',
          stands: '5 talhões',
        ),
        _PropertyItem(
          name: 'Fazenda Boa Vista',
          municipality: 'Dois Irmãos-RS',
          area: '130,50 ha',
          stands: '6 talhões',
        ),
        _PropertyItem(
          name: 'Fazenda Santa Clara',
          municipality: 'Pinhal-RS',
          area: '63,00 ha',
          stands: '3 talhões',
        ),
      ],
    );
  }
}

class _PropertyFilters extends StatelessWidget {
  const _PropertyFilters();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar propriedade',
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton.outlined(
          onPressed: () {},
          icon: const Icon(Icons.tune),
          tooltip: 'Filtros',
          style: IconButton.styleFrom(
            minimumSize: const Size(52, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

class _PropertyItem extends StatelessWidget {
  const _PropertyItem({
    required this.name,
    required this.municipality,
    required this.area,
    required this.stands,
  });

  final String name;
  final String municipality;
  final String area;
  final String stands;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DendroCard(
        padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      _PropertyMeta(icon: Icons.place, label: municipality),
                      _PropertyMeta(icon: Icons.area_chart, label: area),
                      _PropertyMeta(icon: Icons.grid_view, label: stands),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
              tooltip: 'Ações',
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyMeta extends StatelessWidget {
  const _PropertyMeta({required this.icon, required this.label});

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
            color: DendroColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
