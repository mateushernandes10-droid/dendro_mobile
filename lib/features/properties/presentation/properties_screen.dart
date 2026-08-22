import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../core/database/dendro_database.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import '../data/properties_repository.dart';
import 'property_detail_screen.dart';

class PropertiesScreen extends ConsumerStatefulWidget {
  const PropertiesScreen({super.key});

  @override
  ConsumerState<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends ConsumerState<PropertiesScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summaries = ref.watch(propertySummariesProvider);
    final advancedFilters = ref.watch(propertyAdvancedFiltersProvider);

    return DendroScreen(
      title: 'Propriedades',
      icon: Icons.map,
      floatingActionButton: FloatingActionButton(
        heroTag: 'properties_new_property',
        onPressed: () => _openPropertyForm(context),
        tooltip: 'Nova propriedade',
        child: const Icon(Icons.add_home_work),
      ),
      children: [
        _PropertyFilters(
          controller: _searchController,
          filters: advancedFilters,
          onChanged: (value) {
            ref.read(propertySearchQueryProvider.notifier).state = value;
          },
          onOpenFilters: () => _openFilters(context, advancedFilters),
          onClearFilters: () {
            ref.read(propertyAdvancedFiltersProvider.notifier).state =
                const PropertyAdvancedFilters();
          },
        ),
        const SizedBox(height: 16),
        summaries.when(
          data: (items) {
            if (items.isEmpty) {
              return _EmptyPropertiesState(
                hasSearch:
                    _searchController.text.trim().isNotEmpty ||
                    advancedFilters.isActive,
                onCreate: () => _openPropertyForm(context),
              );
            }

            return Column(
              children: [
                for (final item in items)
                  _PropertyItem(
                    summary: item,
                    onOpen: () => _openPropertyDetail(context, item.property),
                    onEdit: () =>
                        _openPropertyForm(context, property: item.property),
                    onDelete: () => _confirmDelete(context, item),
                  ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => _LoadErrorCard(
            message: 'Não foi possível carregar as propriedades.',
            onRetry: () => ref.invalidate(propertySummariesProvider),
          ),
        ),
      ],
    );
  }

  Future<void> _openPropertyDetail(
    BuildContext context,
    PropertyRecord property,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PropertyDetailScreen(property: property),
      ),
    );
  }

  Future<void> _openPropertyForm(
    BuildContext context, {
    PropertyRecord? property,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _PropertyFormSheet(property: property),
    );
  }

  Future<void> _openFilters(
    BuildContext context,
    PropertyAdvancedFilters filters,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _PropertyAdvancedFiltersSheet(
        initialFilters: filters,
        onApply: (nextFilters) {
          ref.read(propertyAdvancedFiltersProvider.notifier).state =
              nextFilters;
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    PropertySummary summary,
  ) async {
    final property = summary.property;
    final message = summary.hasChildren
        ? 'A propriedade já contém talhões ou levantamentos. Se confirmar, todos os dados relacionados serão apagados. Deseja continuar?'
        : 'Deseja excluir a propriedade "${property.name}"?';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir propriedade'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(propertiesRepositoryProvider).delete(property.id);

    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${property.name} excluída.')));
  }
}

class _PropertyFilters extends StatelessWidget {
  const _PropertyFilters({
    required this.controller,
    required this.filters,
    required this.onChanged,
    required this.onOpenFilters,
    required this.onClearFilters,
  });

  final TextEditingController controller;
  final PropertyAdvancedFilters filters;
  final ValueChanged<String> onChanged;
  final VoidCallback onOpenFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final activeLabels = _activeFilterLabels(filters);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar propriedade',
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.outlined(
              onPressed: onOpenFilters,
              icon: Icon(filters.isActive ? Icons.filter_alt : Icons.tune),
              tooltip: 'Filtros',
              style: IconButton.styleFrom(
                minimumSize: const Size(52, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        if (activeLabels.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final label in activeLabels)
                ActionChip(
                  label: Text(label),
                  avatar: const Icon(Icons.filter_alt, size: 16),
                  onPressed: onOpenFilters,
                ),
              ActionChip(
                label: const Text('Limpar filtros'),
                avatar: const Icon(Icons.close, size: 16),
                onPressed: onClearFilters,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _PropertyAdvancedFiltersSheet extends StatefulWidget {
  const _PropertyAdvancedFiltersSheet({
    required this.initialFilters,
    required this.onApply,
  });

  final PropertyAdvancedFilters initialFilters;
  final ValueChanged<PropertyAdvancedFilters> onApply;

  @override
  State<_PropertyAdvancedFiltersSheet> createState() =>
      _PropertyAdvancedFiltersSheetState();
}

class _PropertyAdvancedFiltersSheetState
    extends State<_PropertyAdvancedFiltersSheet> {
  late final TextEditingController _municipalityController;
  late final TextEditingController _minAreaController;
  late final TextEditingController _maxAreaController;
  late final TextEditingController _minStandController;
  late final TextEditingController _maxStandController;

  @override
  void initState() {
    super.initState();
    final filters = widget.initialFilters;
    _municipalityController = TextEditingController(text: filters.municipality);
    _minAreaController = TextEditingController(
      text: filters.minAreaHa == null ? '' : _formatArea(filters.minAreaHa!),
    );
    _maxAreaController = TextEditingController(
      text: filters.maxAreaHa == null ? '' : _formatArea(filters.maxAreaHa!),
    );
    _minStandController = TextEditingController(
      text: filters.minStandCount?.toString() ?? '',
    );
    _maxStandController = TextEditingController(
      text: filters.maxStandCount?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _municipalityController.dispose();
    _minAreaController.dispose();
    _maxAreaController.dispose();
    _minStandController.dispose();
    _maxStandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Filtros de propriedades',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  tooltip: 'Fechar',
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _municipalityController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Município',
                prefixIcon: Icon(Icons.place_outlined),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minAreaController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Área mín. (ha)',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _maxAreaController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Área máx. (ha)',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minStandController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Talhões mín.',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _maxStandController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Talhões máx.',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clear,
                    icon: const Icon(Icons.cleaning_services_outlined),
                    label: const Text('Limpar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _apply,
                    icon: const Icon(Icons.check),
                    label: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _clear() {
    widget.onApply(const PropertyAdvancedFilters());
    Navigator.of(context).pop();
  }

  void _apply() {
    final minArea = _parseOptionalArea(_minAreaController.text);
    final maxArea = _parseOptionalArea(_maxAreaController.text);
    final minStand = _parseOptionalInt(_minStandController.text);
    final maxStand = _parseOptionalInt(_maxStandController.text);

    if (_invalidOptionalNumber(_minAreaController.text, minArea) ||
        _invalidOptionalNumber(_maxAreaController.text, maxArea) ||
        _invalidOptionalNumber(_minStandController.text, minStand) ||
        _invalidOptionalNumber(_maxStandController.text, maxStand)) {
      _showFilterError('Revise os valores informados.');
      return;
    }
    if (minArea != null && maxArea != null && minArea > maxArea) {
      _showFilterError('A área mínima não pode ser maior que a máxima.');
      return;
    }
    if (minStand != null && maxStand != null && minStand > maxStand) {
      _showFilterError(
        'A quantidade mínima de talhões não pode ser maior que a máxima.',
      );
      return;
    }

    widget.onApply(
      PropertyAdvancedFilters(
        municipality: _municipalityController.text.trim(),
        minAreaHa: minArea,
        maxAreaHa: maxArea,
        minStandCount: minStand,
        maxStandCount: maxStand,
      ),
    );
    Navigator.of(context).pop();
  }

  void _showFilterError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red.shade700, content: Text(message)),
    );
  }
}

class _PropertyItem extends StatelessWidget {
  const _PropertyItem({
    required this.summary,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final PropertySummary summary;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final property = summary.property;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onOpen,
        child: DendroCard(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.name,
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
                        _PropertyMeta(
                          icon: Icons.place,
                          label: '${property.municipality}-${property.state}',
                        ),
                        _PropertyMeta(
                          icon: Icons.area_chart,
                          label: '${_formatArea(property.totalAreaHa)} ha',
                        ),
                        _PropertyMeta(
                          icon: Icons.grid_view,
                          label: _formatStandCount(summary.standCount),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_PropertyAction>(
                tooltip: 'Ações',
                icon: const Icon(Icons.more_vert),
                onSelected: (action) {
                  switch (action) {
                    case _PropertyAction.edit:
                      onEdit();
                    case _PropertyAction.delete:
                      onDelete();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _PropertyAction.edit,
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 10),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: _PropertyAction.delete,
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline),
                        SizedBox(width: 10),
                        Text('Excluir'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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

class _PropertyFormSheet extends ConsumerStatefulWidget {
  const _PropertyFormSheet({this.property});

  final PropertyRecord? property;

  @override
  ConsumerState<_PropertyFormSheet> createState() => _PropertyFormSheetState();
}

class _PropertyFormSheetState extends ConsumerState<_PropertyFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _municipalityController;
  late final TextEditingController _stateController;
  late final TextEditingController _areaController;
  bool _saving = false;

  bool get _isEditing => widget.property != null;

  @override
  void initState() {
    super.initState();
    final property = widget.property;

    _nameController = TextEditingController(text: property?.name ?? '');
    _municipalityController = TextEditingController(
      text: property?.municipality ?? '',
    );
    _stateController = TextEditingController(text: property?.state ?? 'RS');
    _areaController = TextEditingController(
      text: property == null ? '' : _formatArea(property.totalAreaHa),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _municipalityController.dispose();
    _stateController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isEditing ? 'Editar propriedade' : 'Nova propriedade',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _saving
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: 'Fechar',
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome da propriedade',
                  prefixIcon: Icon(Icons.home_work_outlined),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _municipalityController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Município',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    width: 92,
                    child: TextFormField(
                      controller: _stateController,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(2),
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                      ],
                      decoration: const InputDecoration(labelText: 'UF'),
                      validator: _requiredValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _areaController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Área total (ha)',
                        prefixIcon: Icon(Icons.area_chart_outlined),
                      ),
                      validator: _areaValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_isEditing ? 'Salvar alterações' : 'Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final repository = ref.read(propertiesRepositoryProvider);
    final area = _parseArea(_areaController.text)!;
    final state = _stateController.text.trim().toUpperCase();

    try {
      if (_isEditing) {
        await repository.update(
          id: widget.property!.id,
          name: _nameController.text,
          municipality: _municipalityController.text,
          state: state,
          totalAreaHa: area,
        );
      } else {
        await repository.create(
          name: _nameController.text,
          municipality: _municipalityController.text,
          state: state,
          totalAreaHa: area,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Propriedade atualizada.' : 'Propriedade cadastrada.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar a propriedade.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String? _areaValidator(String? value) {
    final area = _parseArea(value ?? '');

    if (area == null) {
      return 'Informe uma área válida';
    }
    if (area < 0) {
      return 'Área não pode ser negativa';
    }
    return null;
  }
}

class _EmptyPropertiesState extends StatelessWidget {
  const _EmptyPropertiesState({
    required this.hasSearch,
    required this.onCreate,
  });

  final bool hasSearch;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFF3F4F3),
      borderColor: DendroColors.outline,
      child: Column(
        children: [
          Icon(
            hasSearch ? Icons.search_off : Icons.add_home_work_outlined,
            size: 42,
            color: DendroColors.secondary,
          ),
          const SizedBox(height: 12),
          Text(
            hasSearch
                ? 'Nenhuma propriedade encontrada'
                : 'Nenhuma propriedade cadastrada',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            hasSearch
                ? 'Tente buscar por outro nome.'
                : 'Cadastre a primeira propriedade para iniciar os levantamentos.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: DendroColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (!hasSearch) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add),
                label: const Text('Cadastrar propriedade'),
              ),
            ),
          ],
        ],
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

enum _PropertyAction { edit, delete }

List<String> _activeFilterLabels(PropertyAdvancedFilters filters) {
  final labels = <String>[];
  final municipality = filters.municipality.trim();

  if (municipality.isNotEmpty) {
    labels.add('Município: $municipality');
  }
  if (filters.minAreaHa != null || filters.maxAreaHa != null) {
    labels.add(
      'Área: ${_rangeLabel(filters.minAreaHa, filters.maxAreaHa, suffix: ' ha')}',
    );
  }
  if (filters.minStandCount != null || filters.maxStandCount != null) {
    labels.add(
      'Talhões: ${_rangeLabel(filters.minStandCount, filters.maxStandCount)}',
    );
  }

  return labels;
}

String _rangeLabel(num? min, num? max, {String suffix = ''}) {
  if (min != null && max != null) {
    return '${_formatNumber(min)}-${_formatNumber(max)}$suffix';
  }
  if (min != null) return 'acima de ${_formatNumber(min)}$suffix';
  return 'até ${_formatNumber(max!)}$suffix';
}

String _formatNumber(num value) {
  if (value is int || value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(2).replaceAll('.', ',');
}

String _formatArea(double value) {
  return value.toStringAsFixed(2).replaceAll('.', ',');
}

String _formatStandCount(int count) {
  return count == 1 ? '1 talhão' : '$count talhões';
}

double? _parseArea(String value) {
  return double.tryParse(value.trim().replaceAll(',', '.'));
}

double? _parseOptionalArea(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) return null;
  return _parseArea(normalized);
}

int? _parseOptionalInt(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) return null;
  return int.tryParse(normalized);
}

bool _invalidOptionalNumber(String raw, Object? parsed) {
  return raw.trim().isNotEmpty && parsed == null;
}
