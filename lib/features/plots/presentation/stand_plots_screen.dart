import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../core/database/dendro_database.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import '../../inventory_runs/data/inventory_runs_repository.dart';
import '../../inventory_runs/presentation/inventory_run_detail_screen.dart';
import '../../tree_collection/presentation/tree_collection_screen.dart';
import '../data/plots_repository.dart';

class StandPlotsScreen extends ConsumerWidget {
  const StandPlotsScreen({
    required this.standId,
    this.talhaoLevantamentoId,
    this.showStartInventoryAction = true,
    this.enableTreeCollection = false,
    super.key,
  });

  final String standId;
  final String? talhaoLevantamentoId;
  final bool showStartInventoryAction;
  final bool enableTreeCollection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talhaoId = talhaoLevantamentoId;
    final state = talhaoId == null
        ? ref.watch(standPlotsProvider(standId))
        : ref.watch(talhaoPlotsProvider(talhaoId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parcelas'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: DendroLogoMark(size: 32)),
          ),
        ],
      ),
      floatingActionButton: state.maybeWhen(
        data: (data) => FloatingActionButton(
          heroTag: 'stand_plots_new_plot_${talhaoLevantamentoId ?? standId}',
          onPressed: () => _openPlotForm(context, ref, data),
          tooltip: 'Nova parcela',
          child: const Icon(Icons.add),
        ),
        orElse: () => null,
      ),
      body: SafeArea(
        child: state.when(
          data: (data) => _PlotsBody(
            state: data,
            showStartInventoryAction: showStartInventoryAction,
            onAdd: () => _openPlotForm(context, ref, data),
            onStartInventory: () => _startInventory(context, ref, data),
            onCompleteInventory: () =>
                _confirmCompleteInventory(context, ref, data),
            onOpenPlot: (summary) => _openPlot(context, ref, summary),
            onEditPlot: (summary) =>
                _openPlotForm(context, ref, data, summary: summary),
            onDeletePlot: (summary) =>
                _confirmDeletePlot(context, ref, data, summary),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              _LoadError(onRetry: () => _invalidatePlots(ref)),
        ),
      ),
    );
  }

  Future<void> _confirmCompleteInventory(
    BuildContext context,
    WidgetRef ref,
    StandPlotsState state,
  ) async {
    final run = state.currentInventoryRun;
    if (run == null || run.status != InventoryRunStatus.inProgress) return;

    final hasOpenPlots = state.openPlots > 0 || state.totalPlots == 0;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          hasOpenPlots
              ? Icons.warning_amber_rounded
              : Icons.check_circle_outline,
          color: hasOpenPlots ? Colors.red.shade700 : DendroColors.primary,
        ),
        title: const Text('Encerrar contagem'),
        content: Text(_completeInventoryMessage(state)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: hasOpenPlots
                  ? Colors.red.shade700
                  : DendroColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Encerrar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(inventoryRunsRepositoryProvider).completeRun(run.id);
      ref.invalidate(activeInventoryRunsProvider);
      ref.invalidate(activeInventoryRunProvider);
      ref.invalidate(inventoryRunDetailProvider(run.id));
      _invalidatePlots(ref);

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Contagem encerrada.')));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: const Text('Não foi possível encerrar a contagem.'),
        ),
      );
    }
  }

  Future<void> _startInventory(
    BuildContext context,
    WidgetRef ref,
    StandPlotsState state,
  ) async {
    final activeTalhao = state.activeTalhaoLevantamento;
    if (activeTalhao != null) {
      await _openInventoryRun(context, activeTalhao.inventoryRunId);
      _invalidatePlots(ref);
      return;
    }

    try {
      final talhaoLevantamento = await ref
          .read(plotsRepositoryProvider)
          .startNewInventoryForStand(standId);
      ref.invalidate(activeInventoryRunsProvider);
      ref.invalidate(activeInventoryRunProvider);
      _invalidatePlots(ref);
      if (!context.mounted) return;
      await _openInventoryRun(context, talhaoLevantamento.inventoryRunId);
      return;
    } on ActiveInventoryForStandException catch (error) {
      ref.invalidate(activeInventoryRunsProvider);
      ref.invalidate(activeInventoryRunProvider);

      if (!context.mounted) return;
      await _openInventoryRun(context, error.existing.inventoryRunId);
      return;
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível iniciar o levantamento.'),
        ),
      );
      return;
    }
  }

  Future<void> _openInventoryRun(BuildContext context, String runId) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => InventoryRunDetailScreen(runId: runId),
      ),
    );
  }

  Future<void> _openPlot(
    BuildContext context,
    WidgetRef ref,
    PlotSummary summary,
  ) async {
    if (enableTreeCollection &&
        summary.inventoryRun.status == InventoryRunStatus.inProgress) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => TreeCollectionScreen(plotId: summary.plot.id),
        ),
      );
      _invalidatePlots(ref);
      return;
    }

    await _openPlotDetails(context, ref, summary);
  }

  Future<void> _openPlotDetails(
    BuildContext context,
    WidgetRef ref,
    PlotSummary summary,
  ) async {
    final repository = ref.read(plotsRepositoryProvider);
    final trees = await repository.treesForPlot(summary.plot.id);
    final points = await repository.geoPointsForPlot(summary.plot.id);

    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) =>
          _PlotDetailsSheet(summary: summary, trees: trees, points: points),
    );
  }

  Future<void> _openPlotForm(
    BuildContext context,
    WidgetRef ref,
    StandPlotsState state, {
    PlotSummary? summary,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _PlotFormSheet(
        standId: standId,
        talhaoLevantamentoId: talhaoLevantamentoId,
        state: state,
        summary: summary,
      ),
    );
  }

  Future<void> _confirmDeletePlot(
    BuildContext context,
    WidgetRef ref,
    StandPlotsState state,
    PlotSummary summary,
  ) async {
    final plot = summary.plot;
    final hasChildren = summary.treeCount > 0 || summary.geoPointCount > 0;
    final message = hasChildren
        ? 'A parcela ${plot.identification} já contém dados armazenados. Se confirmar, árvores e coordenadas vinculadas serão apagadas. Deseja continuar?'
        : 'Deseja excluir a parcela ${plot.identification}?';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir parcela'),
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

    await ref.read(plotsRepositoryProvider).deletePlot(plot.id);
    _invalidatePlots(ref);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Parcela ${plot.identification} excluída.')),
    );
  }

  void _invalidatePlots(WidgetRef ref) {
    final talhaoId = talhaoLevantamentoId;
    if (talhaoId == null) {
      ref.invalidate(standPlotsProvider(standId));
    } else {
      ref.invalidate(talhaoPlotsProvider(talhaoId));
    }
  }
}

class _PlotsBody extends StatelessWidget {
  const _PlotsBody({
    required this.state,
    required this.showStartInventoryAction,
    required this.onAdd,
    required this.onStartInventory,
    required this.onCompleteInventory,
    required this.onOpenPlot,
    required this.onEditPlot,
    required this.onDeletePlot,
  });

  final StandPlotsState state;
  final bool showStartInventoryAction;
  final VoidCallback onAdd;
  final VoidCallback onStartInventory;
  final VoidCallback onCompleteInventory;
  final ValueChanged<PlotSummary> onOpenPlot;
  final ValueChanged<PlotSummary> onEditPlot;
  final ValueChanged<PlotSummary> onDeletePlot;

  @override
  Widget build(BuildContext context) {
    final hasActiveInventory = state.activeTalhaoLevantamento != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        _StandSummaryCard(
          state: state,
          onCompleteInventory:
              state.currentInventoryRun?.status == InventoryRunStatus.inProgress
              ? onCompleteInventory
              : null,
        ),
        if (showStartInventoryAction) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onStartInventory,
              icon: Icon(
                hasActiveInventory ? Icons.forest : Icons.play_arrow_rounded,
              ),
              label: Text(
                hasActiveInventory
                    ? 'Continuar Coleta'
                    : 'Iniciar levantamento',
              ),
            ),
          ),
        ],
        const SizedBox(height: 18),
        const SectionTitle(title: 'Parcelas'),
        if (state.plots.isEmpty)
          _EmptyPlotsCard(onAdd: onAdd)
        else
          for (final summary in state.plots)
            _PlotItem(
              summary: summary,
              onOpen: () => onOpenPlot(summary),
              onEdit: () => onEditPlot(summary),
              onDelete: () => onDeletePlot(summary),
            ),
      ],
    );
  }
}

class _StandSummaryCard extends StatelessWidget {
  const _StandSummaryCard({required this.state, this.onCompleteInventory});

  final StandPlotsState state;
  final VoidCallback? onCompleteInventory;

  @override
  Widget build(BuildContext context) {
    final stand = state.stand;
    final plantingYear = stand.plantingYear;

    return DendroCard(
      backgroundColor: const Color(0xFFE0F2E8),
      borderColor: const Color(0xFFA4D1B4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  stand.identification,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: DendroColors.primary,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (onCompleteInventory != null) ...[
                const SizedBox(width: 10),
                Tooltip(
                  message: 'Encerrar contagem',
                  child: FilledButton.icon(
                    onPressed: onCompleteInventory,
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Encerrar'),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 36),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SummaryChip(
                icon: Icons.eco,
                label: state.species.name,
                value: 'Espécie',
              ),
              _SummaryChip(
                icon: Icons.area_chart,
                label: '${_formatArea(stand.areaHa)} ha',
                value: 'Área total',
              ),
              if (plantingYear != null)
                _SummaryChip(
                  icon: Icons.calendar_month,
                  label: plantingYear.toString(),
                  value: 'Plantio',
                ),
              _SummaryChip(
                icon: Icons.grid_view,
                label: '${state.collectedPlots}/${state.totalPlots}',
                value: 'Coletadas',
              ),
            ],
          ),
          if (state.measuredAreaHa > 0) ...[
            const SizedBox(height: 12),
            Text(
              'Área medida em parcelas: ${_formatArea(state.measuredAreaHa)} ha',
              style: const TextStyle(
                color: DendroColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: DendroColors.primary),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.toUpperCase(),
                  style: const TextStyle(
                    color: DendroColors.textMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: DendroColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlotItem extends StatelessWidget {
  const _PlotItem({
    required this.summary,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final PlotSummary summary;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final plot = summary.plot;
    final colors = _statusColors(plot.status, summary.inventoryRun.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onOpen,
        child: DendroCard(
          backgroundColor: colors.background,
          borderColor: colors.border,
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.iconBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(colors.icon, color: colors.iconColor, size: 18),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            plot.identification,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        _PlotStatusPill(
                          label: _statusLabel(
                            plot.status,
                            summary.inventoryRun.status,
                          ),
                          colors: colors,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _plotSubtitle(summary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.mutedText,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_PlotAction>(
                tooltip: 'Ações',
                icon: Icon(Icons.more_vert, color: colors.text),
                onSelected: (action) {
                  switch (action) {
                    case _PlotAction.edit:
                      onEdit();
                    case _PlotAction.delete:
                      onDelete();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _PlotAction.edit,
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 10),
                        Text('Editar área'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: _PlotAction.delete,
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

class _PlotStatusPill extends StatelessWidget {
  const _PlotStatusPill({required this.label, required this.colors});

  final String label;
  final _PlotStatusColors colors;

  @override
  Widget build(BuildContext context) {
    final isDark = colors.background == DendroColors.primary;

    return StatusPill(
      label: label,
      color: isDark
          ? Colors.white.withValues(alpha: 0.16)
          : colors.iconBackground,
      textColor: isDark ? Colors.white : colors.iconColor,
    );
  }
}

class _PlotStatusColors {
  const _PlotStatusColors({
    required this.background,
    required this.border,
    required this.iconBackground,
    required this.iconColor,
    required this.text,
    required this.mutedText,
    required this.icon,
  });

  final Color background;
  final Color border;
  final Color iconBackground;
  final Color iconColor;
  final Color text;
  final Color mutedText;
  final IconData icon;
}

class _EmptyPlotsCard extends StatelessWidget {
  const _EmptyPlotsCard({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFF3F4F3),
      child: Column(
        children: [
          const Icon(
            Icons.grid_view_outlined,
            size: 42,
            color: DendroColors.secondary,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhuma parcela cadastrada',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Crie as parcelas do talhão antes ou durante a coleta de campo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: DendroColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Cadastrar parcela'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlotFormSheet extends ConsumerStatefulWidget {
  const _PlotFormSheet({
    required this.standId,
    required this.talhaoLevantamentoId,
    required this.state,
    this.summary,
  });

  final String standId;
  final String? talhaoLevantamentoId;
  final StandPlotsState state;
  final PlotSummary? summary;

  @override
  ConsumerState<_PlotFormSheet> createState() => _PlotFormSheetState();
}

class _PlotFormSheetState extends ConsumerState<_PlotFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _identificationController;
  late final TextEditingController _areaController;
  bool _saving = false;

  bool get _isEditing => widget.summary != null;

  @override
  void initState() {
    super.initState();
    final plot = widget.summary?.plot;
    _identificationController = TextEditingController(
      text: plot?.identification ?? widget.state.nextPlotIdentification,
    );
    _areaController = TextEditingController(
      text: plot?.areaHa == null ? '' : _formatArea(plot!.areaHa!),
    );
  }

  @override
  void dispose() {
    _identificationController.dispose();
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
                      _isEditing ? 'Editar parcela' : 'Cadastrar parcela',
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
                controller: _identificationController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Identificação',
                  prefixIcon: Icon(Icons.label_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _areaController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Área da parcela (ha, opcional)',
                  prefixIcon: Icon(Icons.area_chart_outlined),
                ),
                validator: _areaValidator,
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
    final repository = ref.read(plotsRepositoryProvider);
    final areaHa = _parseOptionalArea(_areaController.text);

    try {
      if (_isEditing) {
        await repository.updatePlotArea(
          id: widget.summary!.plot.id,
          areaHa: areaHa,
        );
      } else if (widget.talhaoLevantamentoId != null) {
        await repository.createPlotForTalhaoLevantamento(
          talhaoLevantamentoId: widget.talhaoLevantamentoId!,
          areaHa: areaHa,
        );
      } else {
        await repository.createPlannedPlot(
          standId: widget.standId,
          areaHa: areaHa,
        );
      }

      if (!mounted) return;
      final talhaoId = widget.talhaoLevantamentoId;
      if (talhaoId == null) {
        ref.invalidate(standPlotsProvider(widget.standId));
      } else {
        ref.invalidate(talhaoPlotsProvider(talhaoId));
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Parcela atualizada.' : 'Parcela cadastrada.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar a parcela.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _areaValidator(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;

    final area = _parseOptionalArea(trimmed);
    if (area == null) return 'Informe uma área válida';
    if (area <= 0) return 'Área deve ser maior que zero';
    return null;
  }
}

class _PlotDetailsSheet extends StatelessWidget {
  const _PlotDetailsSheet({
    required this.summary,
    required this.trees,
    required this.points,
  });

  final PlotSummary summary;
  final List<TreeRecord> trees;
  final List<PlotGeoPointRecord> points;

  @override
  Widget build(BuildContext context) {
    final plot = summary.plot;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plot.identification,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              StatusPill(
                label: _statusLabel(plot.status, summary.inventoryRun.status),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MetricTile(
                  label: 'Árvores',
                  value: trees.length.toString(),
                  icon: Icons.forest,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MetricTile(
                  label: 'Pontos GPS',
                  value: points.length.toString(),
                  icon: Icons.add_location_alt,
                ),
              ),
            ],
          ),
          if (plot.areaHa != null) ...[
            const SizedBox(height: 10),
            DendroCard(
              child: Text(
                'Área da parcela: ${_formatArea(plot.areaHa!)} ha',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
          const SizedBox(height: 18),
          const SectionTitle(title: 'Árvores registradas'),
          if (trees.isEmpty)
            const DendroCard(
              child: Text(
                'Nenhuma árvore registrada nesta parcela.',
                style: TextStyle(
                  color: DendroColors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            for (final tree in trees) _TreeReadOnlyItem(tree: tree),
          const SizedBox(height: 18),
          const SectionTitle(title: 'Pontos GPS'),
          if (points.isEmpty)
            const DendroCard(
              child: Text(
                'Nenhum ponto GPS registrado nesta parcela.',
                style: TextStyle(
                  color: DendroColors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            for (final point in points) _GeoPointReadOnlyItem(point: point),
        ],
      ),
    );
  }
}

class _TreeReadOnlyItem extends StatelessWidget {
  const _TreeReadOnlyItem({required this.tree});

  final TreeRecord tree;

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
              child: const Icon(Icons.forest, color: DendroColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Árvore ${tree.number}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'DAP: ${_formatMeasure(tree.dapCm)} cm • Alt.: ${_formatMeasure(tree.heightM)} m',
                    style: const TextStyle(
                      color: DendroColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeoPointReadOnlyItem extends StatelessWidget {
  const _GeoPointReadOnlyItem({required this.point});

  final PlotGeoPointRecord point;

  @override
  Widget build(BuildContext context) {
    final reference = point.referencePosition?.name.toUpperCase();

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
              child: const Icon(
                Icons.add_location_alt,
                color: DendroColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reference == null
                        ? 'Ponto ${point.pointOrder}'
                        : '$reference • Ponto ${point.pointOrder}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    _formatCoordinate(point),
                    style: const TextStyle(
                      color: DendroColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

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
                'Não foi possível carregar as parcelas.',
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

enum _PlotAction { edit, delete }

_PlotStatusColors _statusColors(
  PlotStatus status,
  InventoryRunStatus inventoryStatus,
) {
  if (inventoryStatus == InventoryRunStatus.planning) {
    return const _PlotStatusColors(
      background: Color(0xFFEAF7EF),
      border: Color(0xFFA4D1B4),
      iconBackground: DendroColors.primarySoft,
      iconColor: DendroColors.primary,
      text: DendroColors.primary,
      mutedText: DendroColors.textMuted,
      icon: Icons.assignment_outlined,
    );
  }

  switch (status) {
    case PlotStatus.collected:
      return const _PlotStatusColors(
        background: Colors.white,
        border: DendroColors.outline,
        iconBackground: DendroColors.primarySoft,
        iconColor: DendroColors.primary,
        text: DendroColors.text,
        mutedText: DendroColors.textMuted,
        icon: Icons.check_circle,
      );
    case PlotStatus.inProgress:
      return _PlotStatusColors(
        background: DendroColors.primary,
        border: DendroColors.primary,
        iconBackground: Colors.white.withValues(alpha: 0.16),
        iconColor: Colors.white,
        text: Colors.white,
        mutedText: Colors.white.withValues(alpha: 0.78),
        icon: Icons.more_horiz,
      );
    case PlotStatus.pending:
      return const _PlotStatusColors(
        background: Colors.white,
        border: DendroColors.outline,
        iconBackground: Color(0xFFF0F2F0),
        iconColor: DendroColors.textMuted,
        text: DendroColors.textMuted,
        mutedText: DendroColors.textMuted,
        icon: Icons.radio_button_unchecked,
      );
  }
}

String _plotSubtitle(PlotSummary summary) {
  final plot = summary.plot;
  final area = plot.areaHa == null ? null : '${_formatArea(plot.areaHa!)} ha';

  switch (plot.status) {
    case PlotStatus.collected:
      final coordinate = summary.hasCoordinates
          ? _formatCoordinate(summary.firstGeoPoint!)
          : 'Sem coordenadas';
      return ['${summary.treeCount} árvores', coordinate, ?area].join(' • ');
    case PlotStatus.inProgress:
      return [
        'Em andamento',
        '${summary.treeCount} árvores',
        ?area,
      ].join(' • ');
    case PlotStatus.pending:
      final status = summary.inventoryRun.status == InventoryRunStatus.planning
          ? 'Planejada'
          : 'Pendente';
      return area == null ? status : '$status • $area';
  }
}

String _statusLabel(PlotStatus status, InventoryRunStatus inventoryStatus) {
  if (inventoryStatus == InventoryRunStatus.planning) return 'Planejada';

  switch (status) {
    case PlotStatus.collected:
      return 'Coletada';
    case PlotStatus.inProgress:
      return 'Em andamento';
    case PlotStatus.pending:
      return 'Pendente';
  }
}

String _completeInventoryMessage(StandPlotsState state) {
  if (state.totalPlots == 0) {
    return 'Essa contagem ainda não possui parcelas cadastradas. Deseja encerrar mesmo assim?';
  }

  if (state.openPlots > 0) {
    return 'Existem ${state.openPlots} ${_plural(state.openPlots, 'parcela')} ainda não ${_plural(state.openPlots, 'coletada')}. Se confirmar, a contagem será encerrada e deixará de aparecer em andamento.';
  }

  return 'Encerrar a contagem com ${state.collectedPlots} ${_plural(state.collectedPlots, 'parcela')} ${_plural(state.collectedPlots, 'coletada')}?';
}

String _plural(int count, String singular) {
  if (count == 1) return singular;
  return '${singular}s';
}

String _formatCoordinate(PlotGeoPointRecord point) {
  return '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';
}

String _formatArea(double value) {
  return value.toStringAsFixed(2).replaceAll('.', ',');
}

String _formatMeasure(double value) {
  return value.toStringAsFixed(1).replaceAll('.', ',');
}

double? _parseOptionalArea(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return double.tryParse(trimmed.replaceAll(',', '.'));
}
