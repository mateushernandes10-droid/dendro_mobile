import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../core/database/dendro_database.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import '../data/data_export_repository.dart';

class DataExportScreen extends ConsumerStatefulWidget {
  const DataExportScreen({
    this.propertyId,
    this.inventoryRunId,
    this.speciesId,
    this.initialStandIds = const {},
    super.key,
  });

  final String? propertyId;
  final String? inventoryRunId;
  final String? speciesId;
  final Set<String> initialStandIds;

  @override
  ConsumerState<DataExportScreen> createState() => _DataExportScreenState();
}

class _DataExportScreenState extends ConsumerState<DataExportScreen> {
  String? _propertyId;
  DataExportFormat _format = DataExportFormat.pdf;
  Set<String>? _selectedTalhaoIds;
  String? _selectionSyncKey;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _propertyId = widget.propertyId;
  }

  @override
  Widget build(BuildContext context) {
    final request = DataExportRequest(
      propertyId: _propertyId,
      inventoryRunId: widget.inventoryRunId,
      speciesId: widget.speciesId,
    );
    final data = ref.watch(dataExportProvider(request));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportar'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: DendroLogoMark(size: 32)),
          ),
        ],
      ),
      body: SafeArea(
        child: data.when(
          data: (state) {
            _syncPropertySelection(state);
            _syncStandSelection(state);

            final selectedTalhaoIds = _selectedTalhaoIds ?? const <String>{};
            final selectedStandCount = selectedTalhaoIds.length;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              children: [
                _ExportIntroCard(
                  property: state.property,
                  inventoryRun: state.inventoryRun,
                ),
                const SizedBox(height: 14),
                if (widget.inventoryRunId == null)
                  _PropertySelector(
                    properties: state.properties,
                    selectedPropertyId: _propertyId,
                    onChanged: _changeProperty,
                  ),
                if (widget.inventoryRunId == null) const SizedBox(height: 14),
                const SectionTitle(title: 'Formato do arquivo'),
                for (final format in DataExportFormat.values) ...[
                  _ExportFormatTile(
                    format: format,
                    selected: format == _format,
                    onTap: () => setState(() => _format = format),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 12),
                SectionTitle(
                  title: 'Seleção de dados',
                  trailing: state.stands.isEmpty
                      ? null
                      : TextButton(
                          onPressed: () => _toggleAllStands(state.stands),
                          child: Text(
                            selectedStandCount == state.stands.length
                                ? 'Desmarcar todos'
                                : 'Selecionar todos',
                          ),
                        ),
                ),
                if (state.property == null)
                  const _EmptyExportCard(
                    icon: Icons.map_outlined,
                    title: 'Selecione uma propriedade',
                    message:
                        'Escolha a propriedade para listar os talhões disponíveis para exportação.',
                  )
                else if (state.stands.isEmpty)
                  const _EmptyExportCard(
                    icon: Icons.inventory_2_outlined,
                    title: 'Nenhum dado para exportar',
                    message:
                        'Essa propriedade ainda não possui talhões com levantamento registrado.',
                  )
                else
                  for (final stand in state.stands)
                    _ExportStandTile(
                      option: stand,
                      selected: selectedTalhaoIds.contains(
                        stand.talhaoLevantamento.id,
                      ),
                      onChanged: (selected) =>
                          _toggleStand(stand.talhaoLevantamento.id, selected),
                    ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed:
                        _exporting ||
                            state.property == null ||
                            selectedTalhaoIds.isEmpty
                        ? null
                        : () => _prepareExport(state),
                    icon: _exporting
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.ios_share),
                    label: Text(
                      _exporting ? 'Preparando...' : 'Compartilhar relatório',
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _ExportLoadError(
            onRetry: () => ref.invalidate(dataExportProvider(request)),
          ),
        ),
      ),
    );
  }

  void _syncPropertySelection(DataExportState state) {
    if (widget.inventoryRunId != null || _propertyId != null) return;
    if (state.properties.length != 1) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _propertyId != null) return;
      setState(() => _propertyId = state.properties.single.id);
    });
  }

  void _syncStandSelection(DataExportState state) {
    final key =
        '${state.property?.id ?? 'none'}-${state.inventoryRun?.id ?? 'latest'}-${state.stands.map((item) => item.talhaoLevantamento.id).join('|')}';
    if (_selectionSyncKey == key) return;

    final availableIds = {
      for (final option in state.stands) option.talhaoLevantamento.id,
    };
    final initial = widget.initialStandIds;
    final selected = initial.isEmpty
        ? availableIds
        : {
            for (final option in state.stands)
              if (initial.contains(option.stand.id) ||
                  initial.contains(option.talhaoLevantamento.id))
                option.talhaoLevantamento.id,
          };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _selectionSyncKey == key) return;
      setState(() {
        _selectionSyncKey = key;
        _selectedTalhaoIds = selected.isEmpty ? availableIds : selected;
      });
    });
  }

  void _changeProperty(String? propertyId) {
    setState(() {
      _propertyId = propertyId;
      _selectedTalhaoIds = null;
      _selectionSyncKey = null;
    });
  }

  void _toggleAllStands(List<DataExportStandOption> stands) {
    final allIds = {for (final stand in stands) stand.talhaoLevantamento.id};
    final selected = _selectedTalhaoIds ?? const <String>{};

    setState(() {
      _selectedTalhaoIds = selected.length == allIds.length
          ? <String>{}
          : allIds;
    });
  }

  void _toggleStand(String talhaoLevantamentoId, bool selected) {
    final next = {...?_selectedTalhaoIds};
    if (selected) {
      next.add(talhaoLevantamentoId);
    } else {
      next.remove(talhaoLevantamentoId);
    }
    setState(() => _selectedTalhaoIds = next);
  }

  Future<void> _prepareExport(DataExportState state) async {
    final property = state.property;
    final selectedTalhaoIds = _selectedTalhaoIds ?? const <String>{};
    if (property == null || selectedTalhaoIds.isEmpty) return;

    setState(() => _exporting = true);

    try {
      await ref
          .read(dataExportRepositoryProvider)
          .recordExport(
            formats: [_format.label],
            property: property,
            standCount: selectedTalhaoIds.length,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Exportação ${_format.label} registrada para ${property.name}.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: const Text('Não foi possível preparar a exportação.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

enum DataExportFormat {
  pdf(
    label: 'PDF',
    title: 'Relatório PDF',
    description: 'Resumo formatado para impressão e entrega.',
    icon: Icons.picture_as_pdf_outlined,
  ),
  csv(
    label: 'CSV',
    title: 'Dados brutos (CSV)',
    description: 'Tabelas simples para análise em outros softwares.',
    icon: Icons.table_rows_outlined,
  ),
  xls(
    label: 'XLS',
    title: 'Planilha (Excel)',
    description: 'Dados organizados para conferência e cálculos.',
    icon: Icons.grid_on_outlined,
  ),
  googleEarth(
    label: 'KML',
    title: 'Coordenadas (Google Earth)',
    description: 'Arquivo com pontos GPS para abrir no Google Earth.',
    icon: Icons.public,
  );

  const DataExportFormat({
    required this.label,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String label;
  final String title;
  final String description;
  final IconData icon;
}

class _ExportIntroCard extends StatelessWidget {
  const _ExportIntroCard({required this.property, required this.inventoryRun});

  final PropertyRecord? property;
  final InventoryRunRecord? inventoryRun;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFE0F2E8),
      borderColor: const Color(0xFFA4D1B4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exportar dados',
            style: TextStyle(
              color: DendroColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            property == null
                ? 'Selecione uma propriedade e o formato desejado.'
                : '${property!.name} - ${property!.municipality}-${property!.state}',
            style: const TextStyle(
              color: DendroColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (inventoryRun != null) ...[
            const SizedBox(height: 8),
            StatusPill(
              label: 'Levantamento ${_formatDate(inventoryRun!.startedAt)}',
            ),
          ],
        ],
      ),
    );
  }
}

class _PropertySelector extends StatelessWidget {
  const _PropertySelector({
    required this.properties,
    required this.selectedPropertyId,
    required this.onChanged,
  });

  final List<PropertyRecord> properties;
  final String? selectedPropertyId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      child: DropdownButtonFormField<String>(
        key: ValueKey(selectedPropertyId),
        isExpanded: true,
        initialValue: selectedPropertyId,
        decoration: const InputDecoration(
          labelText: 'Propriedade',
          prefixIcon: Icon(Icons.map_outlined),
        ),
        items: [
          for (final property in properties)
            DropdownMenuItem(
              value: property.id,
              child: Text(property.name, overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _ExportFormatTile extends StatelessWidget {
  const _ExportFormatTile({
    required this.format,
    required this.selected,
    required this.onTap,
  });

  final DataExportFormat format;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: DendroCard(
        backgroundColor: selected
            ? const Color(0xFFE0F2E8)
            : const Color(0xFFF3F4F3),
        borderColor: selected ? DendroColors.primary : DendroColors.outline,
        padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? DendroColors.primary
                    : DendroColors.primarySoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                format.icon,
                color: selected ? Colors.white : DendroColors.primary,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    format.title,
                    style: const TextStyle(
                      color: DendroColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    format.description,
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
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? DendroColors.primary : DendroColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportStandTile extends StatelessWidget {
  const _ExportStandTile({
    required this.option,
    required this.selected,
    required this.onChanged,
  });

  final DataExportStandOption option;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DendroCard(
        backgroundColor: selected
            ? const Color(0xFFE0F2E8)
            : const Color(0xFFF3F4F3),
        borderColor: selected ? DendroColors.primary : DendroColors.outline,
        padding: const EdgeInsets.fromLTRB(4, 8, 10, 8),
        child: Row(
          children: [
            Checkbox(
              value: selected,
              activeColor: DendroColors.primary,
              checkColor: Colors.white,
              onChanged: (value) => onChanged(value ?? false),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${option.stand.identification} • ${option.species.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: DendroColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      _StandMeta('${option.plotCount} parcelas'),
                      _StandMeta('${option.treeCount} árvores'),
                      _StandMeta('${_formatArea(option.measuredAreaHa)} ha'),
                      if (option.geoPointCount > 0)
                        _StandMeta('${option.geoPointCount} GPS'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusPill(
              label:
                  '${option.collectedPlotCount}/${option.plotCount == 0 ? '-' : option.plotCount}',
            ),
          ],
        ),
      ),
    );
  }
}

class _StandMeta extends StatelessWidget {
  const _StandMeta(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: DendroColors.textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _EmptyExportCard extends StatelessWidget {
  const _EmptyExportCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFF3F4F3),
      child: Column(
        children: [
          Icon(icon, size: 42, color: DendroColors.secondary),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: DendroColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportLoadError extends StatelessWidget {
  const _ExportLoadError({required this.onRetry});

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
                'Não foi possível carregar os dados de exportação.',
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

String _formatArea(double value) {
  return value.toStringAsFixed(2).replaceAll('.', ',');
}

String _formatDate(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final year = value.year.toString();
  return '$day/$month/$year';
}
