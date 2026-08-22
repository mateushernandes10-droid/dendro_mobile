import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../core/database/dendro_database.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import '../../inventory_runs/data/inventory_runs_repository.dart';
import '../../inventory_runs/presentation/inventory_run_detail_screen.dart';
import '../../inventory_runs/presentation/new_inventory_screen.dart';
import '../../plots/data/plots_repository.dart';
import '../../plots/presentation/stand_plots_screen.dart';
import '../../properties/data/properties_repository.dart';
import '../../stands/data/stands_repository.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final PageController _activeRunController;
  int _selectedActiveRunIndex = 0;

  @override
  void initState() {
    super.initState();
    _activeRunController = PageController();
  }

  @override
  void dispose() {
    _activeRunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeRuns = ref.watch(activeInventoryRunsProvider);
    final selectedCollection = _selectedCollection(
      _activeCollectionItems(activeRuns.asData?.value ?? []),
    );
    final selectedRunSummary = selectedCollection?.runSummary;
    final now = DateTime.now();
    final recentActivities = _recentActivities(now);

    return DendroScreen(
      title: 'Início',
      icon: Icons.home,
      children: [
        ElevatedButton.icon(
          onPressed: () => _openNewInventorySheet(context),
          icon: const Icon(Icons.add),
          label: const Text('Novo Levantamento'),
        ),
        const SizedBox(height: 14),
        activeRuns.when(
          data: (summaries) {
            final collections = _activeCollectionItems(summaries);
            return _ActiveCollectionsPager(
              controller: _activeRunController,
              collections: collections,
              selectedIndex: _selectedActiveRunIndex,
              onPageChanged: (index) =>
                  setState(() => _selectedActiveRunIndex = index),
              onContinue: (collection) =>
                  _openActiveCollection(context, collection),
            );
          },
          loading: () => const _ActiveCollectionLoadingCard(),
          error: (error, stackTrace) => _ActiveCollectionErrorCard(
            onRetry: () => ref.invalidate(activeInventoryRunsProvider),
          ),
        ),
        const SizedBox(height: 20),
        const SectionTitle(title: 'Resumo do levantamento'),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Árvores medidas',
                value: (selectedRunSummary?.treeCount ?? 0).toString(),
                icon: Icons.park_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricTile(
                label: 'Área medida',
                value: _formatArea(selectedRunSummary?.measuredAreaHa ?? 0),
                icon: Icons.area_chart_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SectionTitle(
          title: 'Atividades recentes',
          trailing: TextButton(
            onPressed: () {},
            child: const Text('Ver todas'),
          ),
        ),
        for (final activity in recentActivities)
          _ActivityItem(
            activity: activity,
            displayTime: _formatActivityDate(activity.occurredAt, now),
          ),
      ],
    );
  }

  Future<void> _openNewInventorySheet(BuildContext context) async {
    final runId = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (context) => const NewInventoryScreen(),
      ),
    );

    if (runId == null || !context.mounted) return;
    _openInventoryRun(context, runId);
  }

  void _openInventoryRun(BuildContext context, String runId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => InventoryRunDetailScreen(runId: runId),
      ),
    );
  }

  void _openActiveCollection(
    BuildContext context,
    _ActiveCollectionItem collection,
  ) {
    final standSummary = collection.standSummary;
    if (standSummary == null) {
      _openInventoryRun(context, collection.runSummary.run.id);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => StandPlotsScreen(
          standId: standSummary.stand.id,
          talhaoLevantamentoId: standSummary.talhaoLevantamento.id,
          showStartInventoryAction: false,
          enableTreeCollection: true,
        ),
      ),
    );
  }

  _ActiveCollectionItem? _selectedCollection(
    List<_ActiveCollectionItem> collections,
  ) {
    if (collections.isEmpty) return null;
    if (_selectedActiveRunIndex >= collections.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _selectedActiveRunIndex = collections.length - 1);
        }
      });
      return collections.last;
    }
    return collections[_selectedActiveRunIndex];
  }
}

class _ActiveCollectionItem {
  const _ActiveCollectionItem({
    required this.runSummary,
    required this.standSummary,
  });

  final InventoryRunSummary runSummary;
  final InventoryStandSummary? standSummary;
}

List<_ActiveCollectionItem> _activeCollectionItems(
  List<InventoryRunSummary> summaries,
) {
  return [
    for (final summary in summaries)
      if (summary.stands.isEmpty)
        _ActiveCollectionItem(runSummary: summary, standSummary: null)
      else
        for (final standSummary in summary.stands)
          _ActiveCollectionItem(
            runSummary: summary,
            standSummary: standSummary,
          ),
  ];
}

class _ActiveCollectionsPager extends StatelessWidget {
  const _ActiveCollectionsPager({
    required this.controller,
    required this.collections,
    required this.selectedIndex,
    required this.onPageChanged,
    required this.onContinue,
  });

  final PageController controller;
  final List<_ActiveCollectionItem> collections;
  final int selectedIndex;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<_ActiveCollectionItem> onContinue;

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) {
      return const _ActiveCollectionCard(collection: null, onContinue: null);
    }

    final safeIndex = selectedIndex >= collections.length
        ? collections.length - 1
        : selectedIndex;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final extraHeight = ((textScale - 1) * 84).clamp(0.0, 84.0).toDouble();
    final pagerHeight = 324.0 + extraHeight;

    return Column(
      children: [
        SizedBox(
          height: pagerHeight,
          child: PageView.builder(
            controller: controller,
            itemCount: collections.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final collection = collections[index];
              return _ActiveCollectionCard(
                collection: collection,
                onContinue: () => onContinue(collection),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        _ActiveCollectionDots(
          count: collections.length,
          selectedIndex: safeIndex,
        ),
      ],
    );
  }
}

class _ActiveCollectionDots extends StatelessWidget {
  const _ActiveCollectionDots({
    required this.count,
    required this.selectedIndex,
  });

  final int count;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var index = 0; index < count; index++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 9,
            height: 9,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: index == selectedIndex
                  ? DendroColors.primary
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: DendroColors.primary, width: 1.5),
            ),
          ),
      ],
    );
  }
}

class _ActiveCollectionCard extends StatelessWidget {
  const _ActiveCollectionCard({
    required this.collection,
    required this.onContinue,
  });

  final _ActiveCollectionItem? collection;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final activeCollection = collection;

    if (activeCollection == null) {
      return const DendroCard(
        backgroundColor: Color(0xFFF3F4F3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusPill(label: 'Sem coleta aberta'),
            SizedBox(height: 12),
            Text(
              'Nenhum levantamento em andamento',
              style: TextStyle(
                color: DendroColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Crie um novo levantamento para começar a coleta de campo.',
              style: TextStyle(
                color: DendroColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    final runSummary = activeCollection.runSummary;
    final standSummary = activeCollection.standSummary;
    final title = standSummary?.stand.identification ?? runSummary.standLabel;
    final subtitlePrefix = standSummary?.species.name;
    final propertyLabel =
        '${runSummary.property.name} - ${runSummary.property.municipality}-${runSummary.property.state}';
    final subtitle = subtitlePrefix == null
        ? propertyLabel
        : '$subtitlePrefix • $propertyLabel';
    final treeCount = standSummary?.treeCount ?? runSummary.treeCount;
    final measuredAreaHa =
        standSummary?.measuredAreaHa ?? runSummary.measuredAreaHa;

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
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: DendroColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: DendroColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: _InlineMetric(
                  label: 'Árvores medidas',
                  value: treeCount.toString(),
                ),
              ),
              Expanded(
                child: _InlineMetric(
                  label: 'Área medida',
                  value: _formatArea(measuredAreaHa),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onContinue,
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

class _ActiveCollectionLoadingCard extends StatelessWidget {
  const _ActiveCollectionLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const DendroCard(
      backgroundColor: Color(0xFFF3F4F3),
      child: LinearProgressIndicator(),
    );
  }
}

class _ActiveCollectionErrorCard extends StatelessWidget {
  const _ActiveCollectionErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFF3F4F3),
      child: Column(
        children: [
          const Text(
            'Não foi possível carregar os levantamentos em andamento.',
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
    );
  }
}

class _NewInventorySheet extends ConsumerStatefulWidget {
  const _NewInventorySheet();

  @override
  ConsumerState<_NewInventorySheet> createState() => _NewInventorySheetState();
}

class _NewInventorySheetState extends ConsumerState<_NewInventorySheet> {
  static const _newStandOptionValue = '__new_stand__';

  String? _propertyId;
  String? _standId;
  String? _pendingCreatedStandId;
  String? _startErrorMessage;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final properties = ref.watch(propertySummariesProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: properties.when(
          data: (items) {
            _syncPropertySelection(items);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SheetHeader(saving: _saving),
                const SizedBox(height: 16),
                if (items.isEmpty)
                  const _EmptyStartCard(
                    icon: Icons.map_outlined,
                    title: 'Nenhuma propriedade cadastrada',
                    message:
                        'Cadastre uma propriedade e seus talhões antes de iniciar a coleta.',
                  )
                else ...[
                  DropdownButtonFormField<String>(
                    key: ValueKey('property-$_propertyId'),
                    initialValue: _propertyId,
                    decoration: const InputDecoration(
                      labelText: 'Propriedade',
                      prefixIcon: Icon(Icons.map_outlined),
                    ),
                    items: [
                      for (final item in items)
                        DropdownMenuItem(
                          value: item.property.id,
                          child: Text(item.property.name),
                        ),
                    ],
                    onChanged: _saving
                        ? null
                        : (value) => setState(() {
                            _propertyId = value;
                            _standId = null;
                            _pendingCreatedStandId = null;
                            _startErrorMessage = null;
                          }),
                  ),
                  const SizedBox(height: 12),
                  if (_propertyId != null)
                    _standSelector(propertyId: _propertyId!),
                ],
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.only(bottom: 18),
            child: LinearProgressIndicator(),
          ),
          error: (error, stackTrace) => _EmptyStartCard(
            icon: Icons.error_outline,
            title: 'Não foi possível carregar',
            message: 'Tente novamente para selecionar propriedade e talhão.',
            action: OutlinedButton.icon(
              onPressed: () => ref.invalidate(propertySummariesProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _standSelector({required String propertyId}) {
    final stands = ref.watch(propertyStandsProvider(propertyId));

    return stands.when(
      data: (items) {
        _syncStandSelection(items);

        if (items.isEmpty) {
          return _EmptyStartCard(
            icon: Icons.forest_outlined,
            title: 'Nenhum talhão cadastrado',
            message:
                'Cadastre ao menos um talhão nessa propriedade antes de iniciar o levantamento.',
            action: OutlinedButton.icon(
              onPressed: _saving ? null : () => _openNewStandSheet(propertyId),
              icon: const Icon(Icons.add),
              label: const Text('Novo talhão'),
            ),
          );
        }

        final selectedStand = _selectedStand(items);
        final visibleError =
            _startErrorMessage ??
            (selectedStand?.hasActiveInventory == true
                ? 'Esse talhão já possui uma coleta em andamento. Não é possível iniciar outro levantamento para o mesmo talhão.'
                : null);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (visibleError != null) ...[
              _SheetErrorMessage(message: visibleError),
              const SizedBox(height: 12),
            ],
            DropdownButtonFormField<String>(
              key: ValueKey('stand-$propertyId-$_standId'),
              initialValue: _standId,
              decoration: const InputDecoration(
                labelText: 'Talhão',
                prefixIcon: Icon(Icons.forest_outlined),
              ),
              items: [
                const DropdownMenuItem(
                  value: _newStandOptionValue,
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 18, color: DendroColors.primary),
                      SizedBox(width: 8),
                      Text('Novo talhão'),
                    ],
                  ),
                ),
                for (final item in items)
                  DropdownMenuItem(
                    value: item.stand.id,
                    child: Text(
                      item.hasActiveInventory
                          ? '${item.stand.identification} • Em coleta'
                          : '${item.stand.identification} • ${item.species.name}',
                    ),
                  ),
              ],
              onChanged: _saving ? null : (value) => _onStandChanged(value),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _saving
                    ? null
                    : () => _openNewStandSheet(propertyId),
                icon: const Icon(Icons.add),
                label: const Text('Novo talhão'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saving || _standId == null ? null : _start,
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: Text(_saving ? 'Iniciando...' : 'Iniciar levantamento'),
              ),
            ),
          ],
        );
      },
      loading: () => const DendroCard(child: LinearProgressIndicator()),
      error: (error, stackTrace) => _EmptyStartCard(
        icon: Icons.error_outline,
        title: 'Não foi possível carregar os talhões',
        message: 'Tente novamente para escolher o talhão do levantamento.',
        action: OutlinedButton.icon(
          onPressed: () => ref.invalidate(propertyStandsProvider(propertyId)),
          icon: const Icon(Icons.refresh),
          label: const Text('Tentar novamente'),
        ),
      ),
    );
  }

  Future<void> _start() async {
    final standId = _standId;
    if (standId == null) return;

    setState(() => _saving = true);

    try {
      setState(() => _startErrorMessage = null);
      final talhaoLevantamento = await ref
          .read(plotsRepositoryProvider)
          .startNewInventoryForStand(standId);

      ref.invalidate(activeInventoryRunsProvider);
      ref.invalidate(activeInventoryRunProvider);
      ref.invalidate(standPlotsProvider(standId));

      if (!mounted) return;
      Navigator.of(context).pop(talhaoLevantamento.inventoryRunId);
    } on ActiveInventoryForStandException {
      ref.invalidate(activeInventoryRunsProvider);
      ref.invalidate(activeInventoryRunProvider);

      if (!mounted) return;
      setState(() {
        _startErrorMessage =
            'Esse talhão já possui uma coleta em andamento. Não é possível iniciar outro levantamento para o mesmo talhão.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _startErrorMessage = 'Não foi possível iniciar o levantamento.';
      });
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _onStandChanged(String? value) {
    if (value == _newStandOptionValue) {
      final propertyId = _propertyId;
      if (propertyId != null) {
        unawaited(_openNewStandSheet(propertyId));
      }
      return;
    }

    setState(() {
      _standId = value;
      _startErrorMessage = null;
    });
  }

  Future<void> _openNewStandSheet(String propertyId) async {
    final standId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _QuickStandFormSheet(propertyId: propertyId),
    );

    if (standId == null || !mounted) return;

    setState(() {
      _pendingCreatedStandId = standId;
      _startErrorMessage = null;
    });
    ref.invalidate(propertyStandsProvider(propertyId));
    ref.invalidate(propertySummariesProvider);
  }

  void _syncPropertySelection(List<PropertySummary> properties) {
    if (properties.isEmpty) {
      _propertyId = null;
      _standId = null;
      _pendingCreatedStandId = null;
      return;
    }

    final selectedStillExists = properties.any(
      (summary) => summary.property.id == _propertyId,
    );
    if (_propertyId == null || !selectedStillExists) {
      _propertyId = properties.first.property.id;
      _standId = null;
    }
  }

  void _syncStandSelection(List<StandSummary> stands) {
    if (stands.isEmpty) {
      _standId = null;
      return;
    }

    final pendingStandId = _pendingCreatedStandId;
    if (pendingStandId != null &&
        stands.any((summary) => summary.stand.id == pendingStandId)) {
      _standId = pendingStandId;
      _pendingCreatedStandId = null;
      return;
    }

    final selectedStillExists = stands.any(
      (summary) => summary.stand.id == _standId,
    );
    if (_standId == null || !selectedStillExists) {
      _standId = stands.first.stand.id;
    }
  }

  StandSummary? _selectedStand(List<StandSummary> stands) {
    for (final summary in stands) {
      if (summary.stand.id == _standId) return summary;
    }
    return null;
  }
}

class _SheetErrorMessage extends StatelessWidget {
  const _SheetErrorMessage({required this.message});

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
                    initialValue: _speciesId,
                    decoration: const InputDecoration(
                      labelText: 'Espécie',
                      prefixIcon: Icon(Icons.eco_outlined),
                    ),
                    items: [
                      for (final item in items)
                        DropdownMenuItem(
                          value: item.id,
                          child: Text(item.name),
                        ),
                    ],
                    onChanged: _saving
                        ? null
                        : (value) => setState(() => _speciesId = value),
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
      ref.invalidate(propertySummariesProvider);

      if (!mounted) return;
      Navigator.of(context).pop(standId);
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

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.saving});

  final bool saving;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Novo levantamento',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
        ),
        IconButton(
          onPressed: saving ? null : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          tooltip: 'Fechar',
        ),
      ],
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

class _RecentActivity {
  const _RecentActivity({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.occurredAt,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final DateTime occurredAt;
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.activity, required this.displayTime});

  final _RecentActivity activity;
  final String displayTime;

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
              child: Icon(activity.icon, size: 18, color: DendroColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    activity.subtitle,
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
              displayTime,
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

String _formatArea(double value) {
  return '${value.toStringAsFixed(2).replaceAll('.', ',')} ha';
}

List<_RecentActivity> _recentActivities(DateTime now) {
  final today = DateTime(now.year, now.month, now.day);

  return [
    _RecentActivity(
      icon: Icons.check_circle,
      title: 'Parcela P-12 coletada',
      subtitle: 'Talhão 42-B - Pinus taeda',
      occurredAt: today.add(const Duration(hours: 14, minutes: 30)),
    ),
    _RecentActivity(
      icon: Icons.add_location_alt,
      title: 'Nova parcela iniciada',
      subtitle: 'P-13 com ponto P1 salvo',
      occurredAt: today.add(const Duration(hours: 13, minutes: 48)),
    ),
    _RecentActivity(
      icon: Icons.ios_share,
      title: 'Exportação realizada',
      subtitle: 'Relatório PDF - Fazenda Esperança',
      occurredAt: today
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 9, minutes: 15)),
    ),
    _RecentActivity(
      icon: Icons.home_work,
      title: 'Propriedade cadastrada',
      subtitle: 'Fazenda Boa Vista',
      occurredAt: today
          .subtract(const Duration(days: 3))
          .add(const Duration(hours: 16, minutes: 45)),
    ),
  ];
}

String _formatActivityDate(DateTime occurredAt, DateTime now) {
  final eventDate = DateTime(occurredAt.year, occurredAt.month, occurredAt.day);
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  if (eventDate == today) {
    return '${_twoDigits(occurredAt.hour)}:${_twoDigits(occurredAt.minute)}';
  }

  if (eventDate == yesterday) return 'Ontem';

  return '${_twoDigits(occurredAt.day)}/${_twoDigits(occurredAt.month)}/${occurredAt.year}';
}

String _twoDigits(int value) {
  return value.toString().padLeft(2, '0');
}

double? _parseArea(String value) {
  return double.tryParse(value.trim().replaceAll(',', '.'));
}

int? _parseOptionalInt(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return int.tryParse(trimmed);
}
