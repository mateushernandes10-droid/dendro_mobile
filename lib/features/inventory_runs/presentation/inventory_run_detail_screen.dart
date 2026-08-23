import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../core/database/dendro_database.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import '../../data_export/presentation/data_export_screen.dart';
import '../../plots/presentation/stand_plots_screen.dart';
import '../../stands/data/stands_repository.dart';
import '../data/inventory_formula_selection.dart';
import '../data/inventory_runs_repository.dart';
import 'widgets/inventory_formula_selection_sheet.dart';

class InventoryRunDetailScreen extends ConsumerWidget {
  const InventoryRunDetailScreen({required this.runId, super.key});

  final String runId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(inventoryRunDetailProvider(runId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Levantamento'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: DendroLogoMark(size: 32)),
          ),
        ],
      ),
      body: SafeArea(
        child: detail.when(
          data: (summary) {
            if (summary == null) {
              return const _MissingRun();
            }

            return _InventoryRunBody(
              summary: summary,
              onCompleteRun: () => _confirmCompleteRun(context, ref, summary),
              onDeleteRun: () => _confirmDeleteRun(context, ref, summary),
              onExportRun: () => _openExport(context, summary),
              onEditStand: (stand) => _openStandForm(context, stand),
              onRemoveStand: (stand) =>
                  _confirmRemoveStandFromRun(context, ref, summary, stand),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _LoadError(
            onRetry: () => ref.invalidate(inventoryRunDetailProvider(runId)),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmCompleteRun(
    BuildContext context,
    WidgetRef ref,
    InventoryRunSummary summary,
  ) async {
    final hasOpenPlots = summary.openPlotCount > 0 || summary.plotCount == 0;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          hasOpenPlots
              ? Icons.warning_amber_rounded
              : Icons.check_circle_outline,
          color: hasOpenPlots ? Colors.red.shade700 : DendroColors.primary,
        ),
        title: const Text('Encerrar levantamento'),
        content: Text(_completeRunMessage(summary)),
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
      await ref
          .read(inventoryRunsRepositoryProvider)
          .completeRun(summary.run.id);
      ref.invalidate(inventoryRunDetailProvider(summary.run.id));
      ref.invalidate(activeInventoryRunsProvider);
      ref.invalidate(activeInventoryRunProvider);

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Levantamento encerrado.')));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: const Text('Não foi possível encerrar o levantamento.'),
        ),
      );
    }
  }

  Future<void> _confirmDeleteRun(
    BuildContext context,
    WidgetRef ref,
    InventoryRunSummary summary,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
        title: const Text('Excluir levantamento'),
        content: Text(_deleteRunMessage(summary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await ref.read(inventoryRunsRepositoryProvider).deleteRun(summary.run.id);
      ref.invalidate(inventoryRunDetailProvider(summary.run.id));
      ref.invalidate(inventoryRunsProvider);
      ref.invalidate(activeInventoryRunsProvider);
      ref.invalidate(activeInventoryRunProvider);

      if (!context.mounted) return;
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text('Levantamento de ${summary.property.name} excluído.'),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: const Text('Não foi possível excluir o levantamento.'),
        ),
      );
    }
  }

  Future<void> _openStandForm(
    BuildContext context,
    InventoryStandSummary summary,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          _InventoryStandFormSheet(runId: runId, summary: summary),
    );
  }

  Future<void> _openExport(BuildContext context, InventoryRunSummary summary) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => DataExportScreen(
          inventoryRunId: summary.run.id,
          propertyId: summary.property.id,
        ),
      ),
    );
  }

  Future<void> _confirmRemoveStandFromRun(
    BuildContext context,
    WidgetRef ref,
    InventoryRunSummary runSummary,
    InventoryStandSummary standSummary,
  ) async {
    final hasData = standSummary.plotCount > 0 || standSummary.treeCount > 0;
    final message = hasData
        ? 'O talhão ${standSummary.stand.identification} já possui ${standSummary.plotCount} ${_plural(standSummary.plotCount, 'parcela')} e ${standSummary.treeCount} ${_plural(standSummary.treeCount, 'árvore')} registrada${standSummary.treeCount == 1 ? '' : 's'} neste levantamento. Se confirmar, todos os dados desse talhão dentro do levantamento serão apagados permanentemente. O cadastro do talhão na propriedade será mantido. Deseja continuar?'
        : 'Deseja remover o talhão ${standSummary.stand.identification} deste levantamento? O cadastro do talhão na propriedade será mantido.';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
        title: const Text('Remover talhão do levantamento'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref
          .read(inventoryRunsRepositoryProvider)
          .removeStandFromRun(standSummary.talhaoLevantamento.id);
      _invalidateAfterStandChange(ref, runSummary);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Talhão ${standSummary.stand.identification} removido do levantamento.',
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: const Text('Não foi possível remover o talhão.'),
        ),
      );
    }
  }

  void _invalidateAfterStandChange(
    WidgetRef ref,
    InventoryRunSummary runSummary,
  ) {
    ref.invalidate(inventoryRunDetailProvider(runSummary.run.id));
    ref.invalidate(inventoryRunsProvider);
    ref.invalidate(activeInventoryRunsProvider);
    ref.invalidate(activeInventoryRunProvider);
    ref.invalidate(propertyStandsProvider(runSummary.property.id));
    ref.invalidate(inventoryStartOptionsProvider);
  }
}

class _InventoryRunBody extends StatelessWidget {
  const _InventoryRunBody({
    required this.summary,
    required this.onCompleteRun,
    required this.onDeleteRun,
    required this.onExportRun,
    required this.onEditStand,
    required this.onRemoveStand,
  });

  final InventoryRunSummary summary;
  final VoidCallback onCompleteRun;
  final VoidCallback onDeleteRun;
  final VoidCallback onExportRun;
  final ValueChanged<InventoryStandSummary> onEditStand;
  final ValueChanged<InventoryStandSummary> onRemoveStand;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _RunSummaryCard(summary: summary),
        if (summary.run.status == InventoryRunStatus.inProgress) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onCompleteRun,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Encerrar levantamento'),
            ),
          ),
        ],
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onExportRun,
            icon: const Icon(Icons.ios_share),
            label: const Text('Exportar dados'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onDeleteRun,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Excluir levantamento'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              side: BorderSide(color: Colors.red.shade700),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Árvores medidas',
                value: summary.treeCount.toString(),
                icon: Icons.park_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricTile(
                label: 'Área medida',
                value: _formatArea(summary.measuredAreaHa),
                icon: Icons.area_chart_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: 'Talhões do levantamento',
          trailing: StatusPill(label: '${summary.stands.length} total'),
        ),
        if (summary.stands.isEmpty)
          const DendroCard(
            child: Text(
              'Nenhum talhão vinculado a este levantamento.',
              style: TextStyle(
                color: DendroColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          for (final stand in summary.stands)
            _InventoryStandCard(
              summary: stand,
              onEdit: () => onEditStand(stand),
              onRemove: () => onRemoveStand(stand),
              onOpen: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => StandPlotsScreen(
                    standId: stand.stand.id,
                    talhaoLevantamentoId: stand.talhaoLevantamento.id,
                    showStartInventoryAction: false,
                    enableTreeCollection: true,
                  ),
                ),
              ),
            ),
      ],
    );
  }
}

class _RunSummaryCard extends StatelessWidget {
  const _RunSummaryCard({required this.summary});

  final InventoryRunSummary summary;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFE0F2E8),
      borderColor: const Color(0xFFA4D1B4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusPill(label: _statusLabel(summary.run.status)),
              const Spacer(),
              const Icon(Icons.assignment, color: DendroColors.primary),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary.property.name,
            style: const TextStyle(
              color: DendroColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${summary.property.municipality}-${summary.property.state} • ${summary.standLabel}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: DendroColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Iniciado em ${_formatDateTime(summary.run.startedAt)}',
            style: const TextStyle(
              color: DendroColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryStandCard extends StatelessWidget {
  const _InventoryStandCard({
    required this.summary,
    required this.onOpen,
    required this.onEdit,
    required this.onRemove,
  });

  final InventoryStandSummary summary;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DendroCard(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DendroColors.primarySoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.forest, color: DendroColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summary.stand.identification,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        summary.species.name,
                        style: const TextStyle(
                          color: DendroColors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        summary.formula.name,
                        maxLines: 1,
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
                StatusPill(
                  label: '${summary.collectedPlotCount}/${summary.plotCount}',
                ),
                PopupMenuButton<_InventoryStandAction>(
                  tooltip: 'Ações',
                  icon: const Icon(Icons.more_vert),
                  onSelected: (action) {
                    switch (action) {
                      case _InventoryStandAction.edit:
                        onEdit();
                      case _InventoryStandAction.remove:
                        onRemove();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: _InventoryStandAction.edit,
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 10),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: _InventoryStandAction.remove,
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InlineInfo(
                    label: 'Árvores',
                    value: summary.treeCount.toString(),
                  ),
                ),
                Expanded(
                  child: _InlineInfo(
                    label: 'Área medida',
                    value: _formatArea(summary.measuredAreaHa),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onOpen,
                icon: const Icon(Icons.grid_view),
                style: OutlinedButton.styleFrom(
                  foregroundColor: DendroColors.primary,
                  side: const BorderSide(color: DendroColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                label: const Text('Abrir parcelas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _InventoryStandAction { edit, remove }

class _InventoryStandFormSheet extends ConsumerStatefulWidget {
  const _InventoryStandFormSheet({required this.runId, required this.summary});

  final String runId;
  final InventoryStandSummary summary;

  @override
  ConsumerState<_InventoryStandFormSheet> createState() =>
      _InventoryStandFormSheetState();
}

class _InventoryStandFormSheetState
    extends ConsumerState<_InventoryStandFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _identificationController;
  late final TextEditingController _areaController;
  late final TextEditingController _plantingYearController;
  late final TextEditingController _spacingController;
  late final TextEditingController _managementRegimeController;
  late final TextEditingController _plotWidthController;
  late final TextEditingController _plotLengthController;
  late final TextEditingController _notesController;
  InventoryFormulaSelection? _formulaSelection;
  String? _speciesId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final stand = widget.summary.stand;

    _identificationController = TextEditingController(
      text: stand.identification,
    );
    _areaController = TextEditingController(
      text: stand.areaHa.toStringAsFixed(2).replaceAll('.', ','),
    );
    _plantingYearController = TextEditingController(
      text: stand.plantingYear?.toString() ?? '',
    );
    _spacingController = TextEditingController(text: stand.spacing ?? '');
    _managementRegimeController = TextEditingController(
      text: stand.managementRegime ?? '',
    );
    _plotWidthController = TextEditingController(
      text: stand.plotWidthM == null
          ? ''
          : stand.plotWidthM!.toStringAsFixed(2).replaceAll('.', ','),
    );
    _plotLengthController = TextEditingController(
      text: stand.plotLengthM == null
          ? ''
          : stand.plotLengthM!.toStringAsFixed(2).replaceAll('.', ','),
    );
    _notesController = TextEditingController(text: stand.notes ?? '');
    _speciesId = widget.summary.talhaoLevantamento.speciesId;
    _formulaSelection = InventoryFormulaSelection(
      formulaId: widget.summary.talhaoLevantamento.formulaId,
      formulaName: widget.summary.formula.name,
      coefficientValuesBySymbol: {
        for (final coefficient in widget.summary.formulaCoefficients)
          coefficient.symbol: coefficient.value,
      },
    );
  }

  @override
  void dispose() {
    _identificationController.dispose();
    _areaController.dispose();
    _plantingYearController.dispose();
    _spacingController.dispose();
    _managementRegimeController.dispose();
    _plotWidthController.dispose();
    _plotLengthController.dispose();
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
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
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
                      'Editar talhão do levantamento',
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
                    key: ValueKey('inventory-stand-species-$_speciesId'),
                    initialValue: _speciesId,
                    isExpanded: true,
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
              _InventoryFormulaAdjustmentCard(
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
              PlotDimensionsInput(
                widthController: _plotWidthController,
                lengthController: _plotLengthController,
                widthValidator: (value) => _plotDimensionValidator(
                  value,
                  _plotLengthController.text,
                  'primeira medida',
                ),
                lengthValidator: (value) => _plotDimensionValidator(
                  value,
                  _plotWidthController.text,
                  'segunda medida',
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
                  label: Text(_saving ? 'Salvando...' : 'Salvar alterações'),
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
      await ref
          .read(inventoryRunsRepositoryProvider)
          .updateStandInRun(
            talhaoLevantamentoId: widget.summary.talhaoLevantamento.id,
            identification: _identificationController.text,
            speciesId: _speciesId!,
            areaHa: _parseArea(_areaController.text)!,
            plantingYear: _parseOptionalInt(_plantingYearController.text),
            spacing: _spacingController.text,
            managementRegime: _managementRegimeController.text,
            plotWidthM: _parseOptionalArea(_plotWidthController.text),
            plotLengthM: _parseOptionalArea(_plotLengthController.text),
            notes: _notesController.text,
            formulaSelection: _formulaSelection,
          );

      ref.invalidate(inventoryRunDetailProvider(widget.runId));
      ref.invalidate(inventoryRunsProvider);
      ref.invalidate(activeInventoryRunsProvider);
      ref.invalidate(activeInventoryRunProvider);
      ref.invalidate(propertyStandsProvider(widget.summary.stand.propertyId));
      ref.invalidate(inventoryStartOptionsProvider);

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Talhão atualizado.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: const Text('Não foi possível salvar o talhão.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _adjustFormula() async {
    final selection = await showInventoryFormulaSelectionSheet(
      context: context,
      speciesId: _speciesId!,
      initialSelection: _formulaSelection,
    );

    if (selection == null || !mounted) return;

    setState(() => _formulaSelection = selection);
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

  String? _plotDimensionValidator(
    String? value,
    String pairedValue,
    String label,
  ) {
    final hasValue = value != null && value.trim().isNotEmpty;
    final hasPair = pairedValue.trim().isNotEmpty;
    if (!hasValue && !hasPair) return null;
    if (!hasValue) return 'Informe a $label';

    final parsed = _parseOptionalArea(value);
    if (parsed == null || parsed <= 0) return 'Valor inválido';
    return null;
  }
}

class _InlineInfo extends StatelessWidget {
  const _InlineInfo({required this.label, required this.value});

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
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _InventoryFormulaAdjustmentCard extends StatelessWidget {
  const _InventoryFormulaAdjustmentCard({
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

class _MissingRun extends StatelessWidget {
  const _MissingRun();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: DendroCard(
          child: Text(
            'Levantamento não encontrado.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
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
                'Não foi possível carregar o levantamento.',
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

String _statusLabel(InventoryRunStatus status) {
  switch (status) {
    case InventoryRunStatus.planning:
      return 'Planejado';
    case InventoryRunStatus.inProgress:
      return 'Em andamento';
    case InventoryRunStatus.completed:
      return 'Concluído';
  }
}

String _completeRunMessage(InventoryRunSummary summary) {
  if (summary.plotCount == 0) {
    return 'Esse levantamento ainda não possui parcelas cadastradas. Deseja encerrar mesmo assim?';
  }

  if (summary.openPlotCount > 0) {
    return 'Existem ${summary.openPlotCount} ${_plural(summary.openPlotCount, 'parcela')} ainda não ${_plural(summary.openPlotCount, 'coletada')}. Se confirmar, o levantamento será encerrado e deixará de aparecer em andamento.';
  }

  return 'Encerrar o levantamento com ${summary.collectedPlotCount} ${_plural(summary.collectedPlotCount, 'parcela')} ${_plural(summary.collectedPlotCount, 'coletada')}?';
}

String _deleteRunMessage(InventoryRunSummary summary) {
  final standText = summary.stands.isEmpty
      ? 'nenhum talhão vinculado'
      : summary.stands.length == 1
      ? '1 talhão vinculado'
      : '${summary.stands.length} talhões vinculados';

  return 'Deseja realmente excluir este levantamento de ${summary.property.name}? '
      'Ele possui $standText, ${summary.plotCount} ${_plural(summary.plotCount, 'parcela')} e ${summary.treeCount} ${_plural(summary.treeCount, 'árvore')} registrada${summary.treeCount == 1 ? '' : 's'}. '
      'Todos os dados salvos nesse levantamento, incluindo parcelas, árvores e coordenadas, serão apagados permanentemente e não poderão ser recuperados.';
}

String _plural(int count, String singular) {
  if (count == 1) return singular;
  return '${singular}s';
}

String _formatArea(double value) {
  return '${value.toStringAsFixed(2).replaceAll('.', ',')} ha';
}

double? _parseArea(String value) {
  return double.tryParse(value.trim().replaceAll(',', '.'));
}

double? _parseOptionalArea(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return _parseArea(trimmed);
}

int? _parseOptionalInt(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return int.tryParse(trimmed);
}

String _formatDateTime(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final year = value.year.toString();
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');

  return '$day/$month/$year às $hour:$minute';
}
