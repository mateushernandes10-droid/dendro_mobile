import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import '../data/results_repository.dart';

const _allFilterValue = '__all__';
const _darkFilterCardColor = Color(0xFFA9CBB4);
const _darkFilterFieldColor = Color(0xFFDDEBDD);
const _darkFilterBorderColor = Color(0xFF73957C);

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(resultsFilterOptionsProvider);
    final dashboard = ref.watch(resultsDashboardProvider);

    return DendroScreen(
      title: 'Resultados',
      icon: Icons.bar_chart,
      floatingActionButton: FloatingActionButton(
        heroTag: 'results_export',
        onPressed: () {},
        tooltip: 'Exportar',
        child: const Icon(Icons.ios_share),
      ),
      children: [
        options.when(
          data: (data) => _FilterCard(options: data),
          loading: () => const DendroCard(child: LinearProgressIndicator()),
          error: (error, stackTrace) => _LoadErrorCard(
            message: 'Não foi possível carregar os filtros.',
            onRetry: () => ref.invalidate(resultsFilterOptionsProvider),
          ),
        ),
        const SizedBox(height: 14),
        dashboard.when(
          data: (data) => _ResultsDashboardView(dashboard: data),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => _LoadErrorCard(
            message: 'Não foi possível carregar os resultados.',
            onRetry: () => ref.invalidate(resultsDashboardProvider),
          ),
        ),
      ],
    );
  }
}

class _FilterCard extends ConsumerWidget {
  const _FilterCard({required this.options});

  final ResultsFilterOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final fieldColor = isDarkMode ? _darkFilterFieldColor : Colors.white;
    final propertyId = ref.watch(resultsPropertyFilterProvider);
    final speciesId = ref.watch(resultsSpeciesFilterProvider);
    final selectedStands = ref.watch(resultsStandFilterProvider);
    final visibleStands = options.visibleStands(
      propertyId: propertyId,
      speciesId: speciesId,
    );

    return DendroCard(
      backgroundColor: isDarkMode
          ? _darkFilterCardColor
          : const Color(0xFFF3F4F3),
      borderColor: isDarkMode ? _darkFilterBorderColor : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtros',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('property_$propertyId'),
            initialValue: propertyId ?? _allFilterValue,
            style: const TextStyle(
              color: DendroColors.text,
              fontWeight: FontWeight.w700,
            ),
            dropdownColor: fieldColor,
            iconEnabledColor: DendroColors.primary,
            iconDisabledColor: DendroColors.textMuted,
            decoration: InputDecoration(
              labelText: 'Propriedade',
              labelStyle: const TextStyle(
                color: DendroColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
              floatingLabelStyle: const TextStyle(
                color: DendroColors.primary,
                fontWeight: FontWeight.w800,
              ),
              prefixIcon: const Icon(
                Icons.map_outlined,
                color: DendroColors.primary,
              ),
              fillColor: fieldColor,
            ),
            items: [
              const DropdownMenuItem(
                value: _allFilterValue,
                child: Text('Todas as propriedades'),
              ),
              for (final property in options.properties)
                DropdownMenuItem(
                  value: property.id,
                  child: Text(property.name),
                ),
            ],
            onChanged: (value) {
              ref.read(resultsPropertyFilterProvider.notifier).state =
                  value == _allFilterValue ? null : value;
              ref.read(resultsStandFilterProvider.notifier).state = <String>{};
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('species_$speciesId'),
            initialValue: speciesId ?? _allFilterValue,
            style: const TextStyle(
              color: DendroColors.text,
              fontWeight: FontWeight.w700,
            ),
            dropdownColor: fieldColor,
            iconEnabledColor: DendroColors.primary,
            iconDisabledColor: DendroColors.textMuted,
            decoration: InputDecoration(
              labelText: 'Espécie',
              labelStyle: const TextStyle(
                color: DendroColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
              floatingLabelStyle: const TextStyle(
                color: DendroColors.primary,
                fontWeight: FontWeight.w800,
              ),
              prefixIcon: const Icon(
                Icons.eco_outlined,
                color: DendroColors.primary,
              ),
              fillColor: fieldColor,
            ),
            items: [
              const DropdownMenuItem(
                value: _allFilterValue,
                child: Text('Todas as espécies'),
              ),
              for (final species in options.species)
                DropdownMenuItem(value: species.id, child: Text(species.name)),
            ],
            onChanged: (value) {
              ref.read(resultsSpeciesFilterProvider.notifier).state =
                  value == _allFilterValue ? null : value;
              ref.read(resultsStandFilterProvider.notifier).state = <String>{};
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Talhões',
                  style: TextStyle(
                    color: DendroColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (_hasActiveFilters(propertyId, speciesId, selectedStands))
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: DendroColors.primary,
                    textStyle: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  onPressed: () {
                    ref.read(resultsPropertyFilterProvider.notifier).state =
                        null;
                    ref.read(resultsSpeciesFilterProvider.notifier).state =
                        null;
                    ref.read(resultsStandFilterProvider.notifier).state =
                        <String>{};
                  },
                  child: const Text('Limpar'),
                ),
            ],
          ),
          if (visibleStands.isEmpty)
            const Text(
              'Nenhum talhão disponível para os filtros selecionados.',
              style: TextStyle(
                color: DendroColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final option in visibleStands)
                  FilterChip(
                    backgroundColor: isDarkMode
                        ? const Color(0xFFCFE3D4)
                        : Colors.white,
                    selectedColor: DendroColors.primary,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: selectedStands.contains(option.stand.id)
                          ? DendroColors.primary
                          : _darkFilterBorderColor,
                    ),
                    labelStyle: TextStyle(
                      color: selectedStands.contains(option.stand.id)
                          ? Colors.white
                          : DendroColors.text,
                      fontWeight: FontWeight.w800,
                    ),
                    label: Text(
                      '${option.stand.identification} • ${option.species.name}',
                    ),
                    selected: selectedStands.contains(option.stand.id),
                    onSelected: (selected) {
                      final next = {...selectedStands};
                      if (selected) {
                        next.add(option.stand.id);
                      } else {
                        next.remove(option.stand.id);
                      }
                      ref.read(resultsStandFilterProvider.notifier).state =
                          next;
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ResultsDashboardView extends StatelessWidget {
  const _ResultsDashboardView({required this.dashboard});

  final ResultsDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _VolumePendingCard(hasMeasurements: dashboard.hasMeasurements),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Árvores amostradas',
                value: dashboard.treeCount.toString(),
                icon: Icons.forest,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricTile(
                label: 'Área medida',
                value: '${_formatArea(dashboard.measuredAreaHa)} ha',
                icon: Icons.area_chart,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'DAP médio',
                value: _formatNullableMeasure(dashboard.averageDapCm, 'cm'),
                icon: Icons.straighten,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricTile(
                label: 'Altura média',
                value: _formatNullableMeasure(dashboard.averageHeightM, 'm'),
                icon: Icons.height,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Parcelas coletadas',
                value: '${dashboard.collectedPlotCount}/${dashboard.plotCount}',
                icon: Icons.grid_view,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricTile(
                label: 'Parcelas medidas',
                value: dashboard.measuredPlotCount.toString(),
                icon: Icons.check_circle_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const SectionTitle(title: 'Distribuição diamétrica'),
        _DiameterDistributionCard(classes: dashboard.diameterClasses),
        const SizedBox(height: 20),
        const SectionTitle(title: 'Resumo por talhão'),
        if (dashboard.stands.isEmpty)
          const _EmptyResultsCard()
        else
          for (final stand in dashboard.stands) _StandResultRow(summary: stand),
      ],
    );
  }
}

class _VolumePendingCard extends StatelessWidget {
  const _VolumePendingCard({required this.hasMeasurements});

  final bool hasMeasurements;

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
          Text(
            hasMeasurements ? 'A calcular' : 'Sem dados',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasMeasurements
                ? 'Depende do motor de fórmulas e coeficientes validados.'
                : 'Registre árvores para alimentar os resultados.',
            textAlign: TextAlign.center,
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

class _DiameterDistributionCard extends StatelessWidget {
  const _DiameterDistributionCard({required this.classes});

  final List<DiameterClassSummary> classes;

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return const DendroCard(
        child: Text(
          'Sem árvores medidas para montar a distribuição.',
          style: TextStyle(
            color: DendroColors.textMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    final maxCount = classes
        .map((item) => item.count)
        .reduce((a, b) => a > b ? a : b);

    return DendroCard(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
      child: SizedBox(
        height: 190,
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final item in classes)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              item.count.toString(),
                              style: const TextStyle(
                                color: DendroColors.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FractionallySizedBox(
                                  heightFactor: item.count / maxCount,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: DendroColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const SizedBox(width: 24),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (final item in classes)
                  Expanded(
                    child: Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: DendroColors.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
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

class _StandResultRow extends StatelessWidget {
  const _StandResultRow({required this.summary});

  final ResultsStandSummary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DendroCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    summary.stand.identification,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                StatusPill(label: summary.species.name),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _InlineMetric('${summary.treeCount} árvores'),
                _InlineMetric('${_formatArea(summary.measuredAreaHa)} ha'),
                _InlineMetric(
                  '${summary.collectedPlotCount}/${summary.plotCount} parcelas',
                ),
                _InlineMetric(
                  'DAP ${_formatNullableMeasure(summary.averageDapCm, 'cm')}',
                ),
                _InlineMetric(
                  'Alt. ${_formatNullableMeasure(summary.averageHeightM, 'm')}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineMetric extends StatelessWidget {
  const _InlineMetric(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: DendroColors.primary,
        fontSize: 12,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _EmptyResultsCard extends StatelessWidget {
  const _EmptyResultsCard();

  @override
  Widget build(BuildContext context) {
    return const DendroCard(
      backgroundColor: Color(0xFFF3F4F3),
      child: Text(
        'Nenhum dado de parcela encontrado para os filtros selecionados.',
        style: TextStyle(
          color: DendroColors.textMuted,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LoadErrorCard extends StatelessWidget {
  const _LoadErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800),
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

bool _hasActiveFilters(
  String? propertyId,
  String? speciesId,
  Set<String> standIds,
) {
  return propertyId != null || speciesId != null || standIds.isNotEmpty;
}

String _formatArea(double value) {
  return value.toStringAsFixed(2).replaceAll('.', ',');
}

String _formatNullableMeasure(double? value, String unit) {
  if (value == null) return '-';
  return '${value.toStringAsFixed(1).replaceAll('.', ',')} $unit';
}
