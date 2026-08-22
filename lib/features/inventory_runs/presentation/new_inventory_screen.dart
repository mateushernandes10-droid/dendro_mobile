import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../core/database/dendro_database.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import '../data/inventory_formula_selection.dart';
import '../data/inventory_runs_repository.dart';
import 'widgets/inventory_formula_selection_sheet.dart';
import '../../plots/data/plots_repository.dart';
import '../../stands/data/stands_repository.dart';

class NewInventoryScreen extends ConsumerStatefulWidget {
  const NewInventoryScreen({super.key});

  @override
  ConsumerState<NewInventoryScreen> createState() => _NewInventoryScreenState();
}

class _NewInventoryScreenState extends ConsumerState<NewInventoryScreen> {
  static const _allFilterValue = '__all__';

  final _searchController = TextEditingController();
  String? _cityFilter;
  String? _speciesIdFilter;
  String? _savingStandId;
  String? _errorMessage;
  final Map<String, InventoryFormulaSelection> _formulaSelectionsByStandId = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final options = ref.watch(inventoryStartOptionsProvider);
    final species = ref.watch(activeSpeciesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo levantamento'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: DendroLogoMark(size: 32),
          ),
        ],
      ),
      body: SafeArea(
        child: options.when(
          data: (items) {
            final visibleOptions = _visibleOptions(items);
            final cityOptions = _cityOptions(items);

            return ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                _InventoryStartFilters(
                  searchController: _searchController,
                  cityOptions: cityOptions,
                  selectedCity: _cityFilter,
                  selectedSpeciesId: _speciesIdFilter,
                  species: species,
                  onCityChanged: (value) => setState(() {
                    _cityFilter = value == _allFilterValue ? null : value;
                    _errorMessage = null;
                  }),
                  onSpeciesChanged: (value) => setState(() {
                    _speciesIdFilter = value == _allFilterValue ? null : value;
                    _errorMessage = null;
                  }),
                  onClear: _hasFilters ? _clearFilters : null,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  _StartErrorBanner(message: _errorMessage!),
                ],
                const SizedBox(height: 18),
                SectionTitle(
                  title: 'Propriedades',
                  trailing: StatusPill(
                    label: '${visibleOptions.length} resultado(s)',
                  ),
                ),
                if (items.isEmpty)
                  const _EmptyStartCard(
                    icon: Icons.map_outlined,
                    title: 'Nenhuma propriedade cadastrada',
                    message:
                        'Cadastre uma propriedade e seus talhões antes de iniciar a coleta.',
                  )
                else if (visibleOptions.isEmpty)
                  _EmptyStartCard(
                    icon: Icons.search_off,
                    title: 'Nada encontrado',
                    message:
                        'Ajuste a busca ou os filtros para encontrar a propriedade desejada.',
                    action: OutlinedButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.filter_alt_off),
                      label: const Text('Limpar filtros'),
                    ),
                  )
                else
                  for (final option in visibleOptions) ...[
                    _InventoryStartPropertyGroup(
                      option: option,
                      savingStandId: _savingStandId,
                      onCreateStand: () =>
                          _openNewStandSheet(propertyId: option.property.id),
                      onStart: _startStand,
                      formulaSelectionForStand: (standId) =>
                          _formulaSelectionsByStandId[standId],
                      onAdjustFormula: _adjustFormula,
                    ),
                    const SizedBox(height: 18),
                  ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _LoadStartOptionsError(
            onRetry: () => ref.invalidate(inventoryStartOptionsProvider),
          ),
        ),
      ),
    );
  }

  bool get _hasFilters =>
      _searchController.text.trim().isNotEmpty ||
      _cityFilter != null ||
      _speciesIdFilter != null;

  void _onSearchChanged() {
    setState(() => _errorMessage = null);
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _cityFilter = null;
      _speciesIdFilter = null;
      _errorMessage = null;
    });
  }

  List<InventoryStartPropertyOption> _visibleOptions(
    List<InventoryStartPropertyOption> options,
  ) {
    final query = _searchController.text.trim().toLowerCase();

    final visibleOptions = <InventoryStartPropertyOption>[];
    for (final option in options) {
      final property = option.property;
      final matchesSearch =
          query.isEmpty || property.name.toLowerCase().contains(query);
      final matchesCity =
          _cityFilter == null || _cityLabel(property) == _cityFilter;

      if (!matchesSearch || !matchesCity) continue;

      final stands = _speciesIdFilter == null
          ? option.stands
          : option.stands
                .where((summary) => summary.species.id == _speciesIdFilter)
                .toList();

      if (_speciesIdFilter != null && stands.isEmpty) continue;
      visibleOptions.add(option.copyWith(stands: stands));
    }

    return visibleOptions;
  }

  List<String> _cityOptions(List<InventoryStartPropertyOption> options) {
    final cities = {
      for (final option in options) _cityLabel(option.property),
    }.toList()..sort();

    return cities;
  }

  Future<void> _startStand(StandSummary summary) async {
    if (_savingStandId != null) return;

    setState(() {
      _savingStandId = summary.stand.id;
      _errorMessage = null;
    });

    try {
      final talhaoLevantamento = await ref
          .read(plotsRepositoryProvider)
          .startNewInventoryForStand(
            summary.stand.id,
            formulaSelection: _formulaSelectionsByStandId[summary.stand.id],
          );

      _invalidateStartProviders(summary.stand.id);

      if (!mounted) return;
      Navigator.of(context).pop(talhaoLevantamento.inventoryRunId);
    } on ActiveInventoryForStandException catch (error) {
      _invalidateStartProviders(summary.stand.id);

      if (!mounted) return;
      Navigator.of(context).pop(error.existing.inventoryRunId);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Não foi possível iniciar o levantamento.';
      });
    } finally {
      if (mounted) setState(() => _savingStandId = null);
    }
  }

  Future<void> _adjustFormula(StandSummary summary) async {
    final selection = await showInventoryFormulaSelectionSheet(
      context: context,
      speciesId: summary.species.id,
      initialSelection: _formulaSelectionsByStandId[summary.stand.id],
    );

    if (selection == null || !mounted) return;

    setState(() {
      _formulaSelectionsByStandId[summary.stand.id] = selection;
      _errorMessage = null;
    });
  }

  Future<void> _openNewStandSheet({required String propertyId}) async {
    final creation = await showModalBottomSheet<_QuickStandCreation>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _QuickStandFormSheet(propertyId: propertyId),
    );

    if (creation == null || !mounted) return;

    ref.invalidate(inventoryStartOptionsProvider);
    ref.invalidate(propertyStandsProvider(propertyId));
    if (creation.formulaSelection == null) {
      _formulaSelectionsByStandId.remove(creation.standId);
    } else {
      _formulaSelectionsByStandId[creation.standId] =
          creation.formulaSelection!;
    }

    final summary = await ref
        .read(standsRepositoryProvider)
        .getSummary(creation.standId);
    if (summary == null || !mounted) return;

    await _startStand(summary);
  }

  void _invalidateStartProviders(String standId) {
    ref.invalidate(inventoryStartOptionsProvider);
    ref.invalidate(activeInventoryRunsProvider);
    ref.invalidate(activeInventoryRunProvider);
    ref.invalidate(standPlotsProvider(standId));
  }
}

class _InventoryStartFilters extends StatelessWidget {
  const _InventoryStartFilters({
    required this.searchController,
    required this.cityOptions,
    required this.selectedCity,
    required this.selectedSpeciesId,
    required this.species,
    required this.onCityChanged,
    required this.onSpeciesChanged,
    required this.onClear,
  });

  final TextEditingController searchController;
  final List<String> cityOptions;
  final String? selectedCity;
  final String? selectedSpeciesId;
  final AsyncValue<List<SpeciesRecord>> species;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onSpeciesChanged;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fieldColor = isDark ? DendroColors.darkReadableField : Colors.white;

    return DendroCard(
      backgroundColor: const Color(0xFFEAF7EF),
      borderColor: const Color(0xFFA4D1B4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: searchController,
            textInputAction: TextInputAction.search,
            style: const TextStyle(
              color: DendroColors.text,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              labelText: 'Buscar propriedade',
              labelStyle: const TextStyle(
                color: DendroColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
              prefixIcon: const Icon(Icons.search, color: DendroColors.primary),
              fillColor: fieldColor,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey(
              'city-${selectedCity ?? _NewInventoryScreenState._allFilterValue}',
            ),
            isExpanded: true,
            initialValue:
                selectedCity ?? _NewInventoryScreenState._allFilterValue,
            style: const TextStyle(
              color: DendroColors.text,
              fontWeight: FontWeight.w700,
            ),
            dropdownColor: fieldColor,
            iconEnabledColor: DendroColors.primary,
            decoration: InputDecoration(
              labelText: 'Município',
              labelStyle: const TextStyle(
                color: DendroColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
              prefixIcon: const Icon(
                Icons.location_city_outlined,
                color: DendroColors.primary,
              ),
              fillColor: fieldColor,
            ),
            items: [
              const DropdownMenuItem(
                value: _NewInventoryScreenState._allFilterValue,
                child: Text('Todos os municípios'),
              ),
              for (final city in cityOptions)
                DropdownMenuItem(
                  value: city,
                  child: Text(city, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: onCityChanged,
          ),
          const SizedBox(height: 12),
          species.when(
            data: (items) => DropdownButtonFormField<String>(
              key: ValueKey(
                'species-${selectedSpeciesId ?? _NewInventoryScreenState._allFilterValue}',
              ),
              isExpanded: true,
              initialValue:
                  selectedSpeciesId ?? _NewInventoryScreenState._allFilterValue,
              style: const TextStyle(
                color: DendroColors.text,
                fontWeight: FontWeight.w700,
              ),
              dropdownColor: fieldColor,
              iconEnabledColor: DendroColors.primary,
              decoration: InputDecoration(
                labelText: 'Espécie',
                labelStyle: const TextStyle(
                  color: DendroColors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
                prefixIcon: const Icon(
                  Icons.eco_outlined,
                  color: DendroColors.primary,
                ),
                fillColor: fieldColor,
              ),
              items: [
                const DropdownMenuItem(
                  value: _NewInventoryScreenState._allFilterValue,
                  child: Text('Todas as espécies'),
                ),
                for (final item in items)
                  DropdownMenuItem(
                    value: item.id,
                    child: Text(item.name, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: onSpeciesChanged,
            ),
            loading: () => const LinearProgressIndicator(),
            error: (error, stackTrace) => const Text(
              'Não foi possível carregar as espécies.',
              style: TextStyle(
                color: DendroColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (onClear != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.filter_alt_off),
                label: const Text('Limpar filtros'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InventoryStartPropertyGroup extends StatelessWidget {
  const _InventoryStartPropertyGroup({
    required this.option,
    required this.savingStandId,
    required this.onCreateStand,
    required this.onStart,
    required this.formulaSelectionForStand,
    required this.onAdjustFormula,
  });

  final InventoryStartPropertyOption option;
  final String? savingStandId;
  final VoidCallback onCreateStand;
  final ValueChanged<StandSummary> onStart;
  final InventoryFormulaSelection? Function(String standId)
  formulaSelectionForStand;
  final ValueChanged<StandSummary> onAdjustFormula;

  @override
  Widget build(BuildContext context) {
    final property = option.property;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PropertyGroupHeader(
          property: property,
          standCount: option.stands.length,
        ),
        const SizedBox(height: 8),
        if (option.stands.isEmpty)
          _EmptyStartCard(
            icon: Icons.forest_outlined,
            title: 'Nenhum talhão cadastrado',
            message:
                'Cadastre um talhão nessa propriedade para iniciar o levantamento.',
            action: OutlinedButton.icon(
              onPressed: onCreateStand,
              icon: const Icon(Icons.add),
              label: const Text('Novo talhão'),
            ),
          )
        else ...[
          for (final summary in option.stands) ...[
            _StartStandCard(
              summary: summary,
              saving: savingStandId == summary.stand.id,
              disabled:
                  savingStandId != null && savingStandId != summary.stand.id,
              formulaSelection: formulaSelectionForStand(summary.stand.id),
              onAdjustFormula: () => onAdjustFormula(summary),
              onStart: () => onStart(summary),
            ),
            const SizedBox(height: 8),
          ],
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: savingStandId == null ? onCreateStand : null,
              icon: const Icon(Icons.add),
              label: const Text('Novo talhão'),
            ),
          ),
        ],
      ],
    );
  }
}

class _PropertyGroupHeader extends StatelessWidget {
  const _PropertyGroupHeader({
    required this.property,
    required this.standCount,
  });

  final PropertyRecord property;
  final int standCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: DendroColors.primarySoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.map_outlined, color: DendroColors.primary),
        ),
        const SizedBox(width: 10),
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
                ).copyWith(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 2),
              Text(
                _cityLabel(property),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.72),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        StatusPill(label: _standCountLabel(standCount)),
      ],
    );
  }
}

class _StartStandCard extends StatelessWidget {
  const _StartStandCard({
    required this.summary,
    required this.saving,
    required this.disabled,
    required this.formulaSelection,
    required this.onAdjustFormula,
    required this.onStart,
  });

  final StandSummary summary;
  final bool saving;
  final bool disabled;
  final InventoryFormulaSelection? formulaSelection;
  final VoidCallback onAdjustFormula;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final active = summary.hasActiveInventory;

    return DendroCard(
      backgroundColor: active ? const Color(0xFFE0F2E8) : Colors.white,
      borderColor: active ? const Color(0xFFA4D1B4) : DendroColors.outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  summary.stand.identification,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: DendroColors.primary,
                  ),
                ),
              ),
              if (active) const StatusPill(label: 'Em coleta'),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _StandMeta(icon: Icons.eco_outlined, label: summary.species.name),
              _StandMeta(
                icon: Icons.area_chart_outlined,
                label: _formatArea(summary.stand.areaHa),
              ),
              _StandMeta(
                icon: Icons.history,
                label: _historyLabel(summary.talhaoLevantamentoCount),
              ),
            ],
          ),
          if (!active) ...[
            const SizedBox(height: 12),
            _FormulaAdjustmentButton(
              selection: formulaSelection,
              onPressed: disabled || saving ? null : onAdjustFormula,
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: disabled || saving ? null : onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: DendroColors.darkAction,
                foregroundColor: Colors.white,
                disabledBackgroundColor: DendroColors.darkReadableField,
                disabledForegroundColor: DendroColors.textMuted,
              ),
              icon: saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(active ? Icons.forest : Icons.play_arrow_rounded),
              label: Text(
                saving
                    ? 'Abrindo...'
                    : active
                    ? 'Continuar coleta'
                    : 'Iniciar levantamento',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StandMeta extends StatelessWidget {
  const _StandMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: DendroColors.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: DendroColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _FormulaAdjustmentButton extends StatelessWidget {
  const _FormulaAdjustmentButton({
    required this.selection,
    required this.onPressed,
  });

  final InventoryFormulaSelection? selection;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(selection == null ? Icons.functions : Icons.tune),
      style: OutlinedButton.styleFrom(
        foregroundColor: DendroColors.primary,
        disabledForegroundColor: DendroColors.textMuted,
        side: BorderSide(
          color: onPressed == null
              ? DendroColors.outline
              : DendroColors.primary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      label: Text(
        selection == null
            ? 'Ajustar modelo matemático'
            : 'Modelo ajustado: ${selection!.formulaName ?? 'personalizado'}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _StartErrorBanner extends StatelessWidget {
  const _StartErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.red.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadStartOptionsError extends StatelessWidget {
  const _LoadStartOptionsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _EmptyStartCard(
          icon: Icons.error_outline,
          title: 'Não foi possível carregar',
          message: 'Tente novamente para escolher propriedade e talhão.',
          action: OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ),
      ),
    );
  }
}

class _EmptyStartCard extends StatelessWidget {
  const _EmptyStartCard({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

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
          if (action != null) ...[const SizedBox(height: 14), action!],
        ],
      ),
    );
  }
}

class _QuickStandFormSheet extends ConsumerStatefulWidget {
  const _QuickStandFormSheet({required this.propertyId});

  final String propertyId;

  @override
  ConsumerState<_QuickStandFormSheet> createState() =>
      _QuickStandFormSheetState();
}

class _QuickStandFormSheetState extends ConsumerState<_QuickStandFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _identificationController = TextEditingController();
  final _areaController = TextEditingController();
  final _plantingYearController = TextEditingController();
  final _spacingController = TextEditingController();
  final _managementRegimeController = TextEditingController();
  final _notesController = TextEditingController();
  InventoryFormulaSelection? _formulaSelection;
  String? _speciesId;
  bool _saving = false;

  @override
  void dispose() {
    _identificationController.dispose();
    _areaController.dispose();
    _plantingYearController.dispose();
    _spacingController.dispose();
    _managementRegimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final species = ref.watch(activeSpeciesProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Novo talhão',
                      style: TextStyle(
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
                controller: _identificationController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Identificação',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              species.when(
                data: (items) {
                  _syncSpeciesSelection(items);
                  return DropdownButtonFormField<String>(
                    key: ValueKey('quick-species-$_speciesId'),
                    isExpanded: true,
                    initialValue: _speciesId,
                    decoration: const InputDecoration(
                      labelText: 'Espécie',
                      prefixIcon: Icon(Icons.eco_outlined),
                    ),
                    items: [
                      for (final item in items)
                        DropdownMenuItem(
                          value: item.id,
                          child: Text(
                            item.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: _saving
                        ? null
                        : (value) => setState(() {
                            _speciesId = value;
                            _formulaSelection = null;
                          }),
                    validator: (value) =>
                        value == null ? 'Selecione uma espécie' : null,
                  );
                },
                loading: () =>
                    const DendroCard(child: LinearProgressIndicator()),
                error: (error, stackTrace) => const DendroCard(
                  child: Text('Não foi possível carregar as espécies.'),
                ),
              ),
              const SizedBox(height: 12),
              _FormulaAdjustmentCard(
                selection: _formulaSelection,
                onPressed: _speciesId == null || _saving
                    ? null
                    : _adjustFormula,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _areaController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Área (ha)',
                        prefixIcon: Icon(Icons.area_chart_outlined),
                      ),
                      validator: _areaValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 126,
                    child: TextFormField(
                      controller: _plantingYearController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: const InputDecoration(labelText: 'Ano'),
                      validator: _plantingYearValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _spacingController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Espaçamento (opcional)',
                  prefixIcon: Icon(Icons.grid_4x4_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _managementRegimeController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Regime de manejo (opcional)',
                  prefixIcon: Icon(Icons.agriculture_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Observação (opcional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
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
                  label: Text(_saving ? 'Salvando...' : 'Cadastrar talhão'),
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

    try {
      final standId = await ref
          .read(standsRepositoryProvider)
          .create(
            propertyId: widget.propertyId,
            identification: _identificationController.text,
            speciesId: _speciesId!,
            areaHa: _parseArea(_areaController.text)!,
            plantingYear: _parseOptionalInt(_plantingYearController.text),
            spacing: _spacingController.text,
            managementRegime: _managementRegimeController.text,
            notes: _notesController.text,
          );

      ref.invalidate(propertyStandsProvider(widget.propertyId));
      ref.invalidate(inventoryStartOptionsProvider);

      if (!mounted) return;
      Navigator.of(context).pop(
        _QuickStandCreation(
          standId: standId,
          formulaSelection: _formulaSelection,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: const Text('Não foi possível cadastrar o talhão.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _syncSpeciesSelection(List<SpeciesRecord> species) {
    if (species.isEmpty) {
      _speciesId = null;
      return;
    }

    final selectedStillExists = species.any((item) => item.id == _speciesId);
    if (_speciesId == null || !selectedStillExists) {
      _speciesId = species.first.id;
      _formulaSelection = null;
    }
  }

  Future<void> _adjustFormula() async {
    final speciesId = _speciesId;
    if (speciesId == null) return;

    final selection = await showInventoryFormulaSelectionSheet(
      context: context,
      speciesId: speciesId,
      initialSelection: _formulaSelection,
    );

    if (selection == null || !mounted) return;

    setState(() => _formulaSelection = selection);
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String? _areaValidator(String? value) {
    final area = _parseArea(value ?? '');
    if (area == null) return 'Informe uma área válida';
    if (area < 0) return 'Área não pode ser negativa';
    return null;
  }

  String? _plantingYearValidator(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final year = int.tryParse(value.trim());
    if (year == null) return 'Ano inválido';
    if (year < 1900 || year > DateTime.now().year + 1) {
      return 'Confira o ano';
    }
    return null;
  }
}

class _QuickStandCreation {
  const _QuickStandCreation({
    required this.standId,
    required this.formulaSelection,
  });

  final String standId;
  final InventoryFormulaSelection? formulaSelection;
}

class _FormulaAdjustmentCard extends StatelessWidget {
  const _FormulaAdjustmentCard({
    required this.selection,
    required this.onPressed,
  });

  final InventoryFormulaSelection? selection;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFEAF7EF),
      borderColor: const Color(0xFFA4D1B4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Modelo matemático',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            selection == null
                ? 'Será usado o modelo padrão da espécie selecionada.'
                : selection!.formulaName ?? 'Modelo personalizado',
            style: const TextStyle(
              color: DendroColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.functions),
              style: OutlinedButton.styleFrom(
                foregroundColor: DendroColors.primary,
                disabledForegroundColor: DendroColors.textMuted,
                side: BorderSide(
                  color: onPressed == null
                      ? DendroColors.outline
                      : DendroColors.primary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              label: const Text('Ajustar modelo matemático'),
            ),
          ),
        ],
      ),
    );
  }
}

String _cityLabel(PropertyRecord property) {
  return '${property.municipality}-${property.state}';
}

String _standCountLabel(int count) {
  if (count == 1) return '1 talhão';
  return '$count talhões';
}

String _historyLabel(int count) {
  if (count == 0) return 'Sem histórico';
  if (count == 1) return '1 levantamento';
  return '$count levantamentos';
}

String _formatArea(double value) {
  return '${value.toStringAsFixed(2).replaceAll('.', ',')} ha';
}

double? _parseArea(String value) {
  return double.tryParse(value.trim().replaceAll(',', '.'));
}

int? _parseOptionalInt(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return int.tryParse(trimmed);
}
