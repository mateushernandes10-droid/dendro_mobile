import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../core/database/dendro_database.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import '../../inventory_runs/data/inventory_runs_repository.dart';
import '../../plots/data/plots_repository.dart';
import '../data/trees_repository.dart';

class TreeCollectionScreen extends ConsumerStatefulWidget {
  const TreeCollectionScreen({required this.plotId, super.key});

  final String plotId;

  @override
  ConsumerState<TreeCollectionScreen> createState() =>
      _TreeCollectionScreenState();
}

class _TreeCollectionScreenState extends ConsumerState<TreeCollectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dapController = TextEditingController();
  final _heightController = TextEditingController();

  bool _formOpen = false;
  bool _saving = false;
  bool _capturingLocation = false;
  bool _hasTortuousStem = false;
  int _treeNumber = 1;
  TreeRecord? _editingTree;
  PlotReferencePosition? _referencePosition;
  double? _latitude;
  double? _longitude;
  double? _accuracyMeters;
  DateTime? _locationCapturedAt;

  @override
  void dispose() {
    _dapController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collection = ref.watch(treeCollectionProvider(widget.plotId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coleta da parcela'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: DendroLogoMark(size: 32)),
          ),
        ],
      ),
      body: SafeArea(
        child: collection.when(
          data: (state) => _body(state),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _LoadError(
            onRetry: () =>
                ref.invalidate(treeCollectionProvider(widget.plotId)),
          ),
        ),
      ),
    );
  }

  Widget _body(TreeCollectionState state) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _ParcelHeader(
          state: state,
          onFinish: _saving ? null : () => _finishPlot(state),
        ),
        const SizedBox(height: 14),
        if (!_formOpen)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saving ? null : () => _openNewTreeForm(state),
              icon: const Icon(Icons.add),
              label: const Text('Nova árvore'),
            ),
          )
        else
          _TreeFormCard(
            formKey: _formKey,
            treeNumber: _treeNumber,
            isEditing: _editingTree != null,
            dapController: _dapController,
            heightController: _heightController,
            hasTortuousStem: _hasTortuousStem,
            latitude: _latitude,
            longitude: _longitude,
            accuracyMeters: _accuracyMeters,
            referencePosition: _referencePosition,
            saving: _saving,
            capturingLocation: _capturingLocation,
            onClose: _saving ? null : _closeForm,
            onTortuousChanged: (value) =>
                setState(() => _hasTortuousStem = value),
            onCaptureLocation: () => _captureLocation(state),
            onClearLocation: _clearLocation,
            onSave: () => _saveTree(state, keepOpen: false),
            onNext: () => _saveTree(state, keepOpen: true),
          ),
        const SizedBox(height: 20),
        SectionTitle(
          title: 'Árvores registradas',
          trailing: StatusPill(label: '${state.treeCount} total'),
        ),
        if (state.trees.isEmpty)
          const _EmptyTreesCard()
        else
          for (final tree in state.trees.reversed)
            _TreeItem(
              tree: tree,
              onEdit: () => _openEditTreeForm(tree),
              onDelete: () => _confirmDeleteTree(tree, state),
            ),
      ],
    );
  }

  void _openNewTreeForm(TreeCollectionState state) {
    setState(() {
      _editingTree = null;
      _treeNumber = state.nextTreeNumber;
      _dapController.clear();
      _heightController.clear();
      _hasTortuousStem = false;
      _referencePosition = null;
      _latitude = null;
      _longitude = null;
      _accuracyMeters = null;
      _locationCapturedAt = null;
      _formOpen = true;
    });
  }

  void _openEditTreeForm(TreeRecord tree) {
    setState(() {
      _editingTree = tree;
      _treeNumber = tree.number;
      _dapController.text = _formatMeasure(tree.dapCm);
      _heightController.text = _formatMeasure(tree.heightM);
      _hasTortuousStem = tree.hasTortuousStem;
      _referencePosition = tree.plotReferencePosition;
      _latitude = tree.latitude;
      _longitude = tree.longitude;
      _accuracyMeters = tree.accuracyMeters;
      _locationCapturedAt = tree.locationCapturedAt;
      _formOpen = true;
    });
  }

  void _closeForm() {
    setState(() {
      _formOpen = false;
      _editingTree = null;
    });
  }

  void _clearLocation() {
    setState(() {
      _latitude = null;
      _longitude = null;
      _accuracyMeters = null;
      _locationCapturedAt = null;
      _referencePosition = null;
    });
  }

  Future<void> _captureLocation(TreeCollectionState state) async {
    final reference = await _selectReferencePosition(state);
    if (reference == null || !mounted) return;

    final existingTree = _treeUsingReference(state, reference);
    if (existingTree != null) {
      final shouldReplace = await _confirmReferenceReplacement(
        reference: reference,
        existingTree: existingTree,
      );
      if (!shouldReplace || !mounted) return;
    }

    setState(() => _capturingLocation = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack('Ative a localização do aparelho para capturar o ponto.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showSnack('Permissão de localização negada.');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnack('Libere a localização nas configurações do Android.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _accuracyMeters = position.accuracy;
        _locationCapturedAt = DateTime.now();
        _referencePosition = reference;
      });
    } catch (_) {
      _showSnack('Não foi possível capturar a localização agora.');
    } finally {
      if (mounted) setState(() => _capturingLocation = false);
    }
  }

  TreeRecord? _treeUsingReference(
    TreeCollectionState state,
    PlotReferencePosition reference,
  ) {
    final editingTreeId = _editingTree?.id;
    for (final tree in state.trees) {
      if (tree.id != editingTreeId && tree.plotReferencePosition == reference) {
        return tree;
      }
    }

    return null;
  }

  Future<bool> _confirmReferenceReplacement({
    required PlotReferencePosition reference,
    required TreeRecord existingTree,
  }) async {
    final label = _referenceLabel(reference);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
        title: Text('Ponto $label já capturado'),
        content: Text(
          'O ponto $label já está vinculado à árvore ${existingTree.number}. '
          'Deseja substituir pela coordenada atual?',
        ),
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
            child: const Text('Substituir'),
          ),
        ],
      ),
    );

    return confirmed == true;
  }

  Future<void> _saveTree(
    TreeCollectionState state, {
    required bool keepOpen,
  }) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final repository = ref.read(treesRepositoryProvider);
    final draft = TreeDraft(
      dapCm: _parseMeasure(_dapController.text)!,
      heightM: _parseMeasure(_heightController.text)!,
      hasTortuousStem: _hasTortuousStem,
      latitude: _latitude,
      longitude: _longitude,
      accuracyMeters: _accuracyMeters,
      locationCapturedAt: _locationCapturedAt,
      plotReferencePosition: _latitude == null || _longitude == null
          ? null
          : _referencePosition,
    );

    try {
      final editingTree = _editingTree;
      if (editingTree == null) {
        await repository.createTree(plotId: widget.plotId, draft: draft);
      } else {
        await repository.updateTree(treeId: editingTree.id, draft: draft);
      }

      _invalidateRelatedProviders(state);

      if (!mounted) return;
      if (keepOpen) {
        final nextNumber = await repository.nextTreeNumber(widget.plotId);
        setState(() {
          _editingTree = null;
          _treeNumber = nextNumber;
          _dapController.clear();
          _heightController.clear();
          _hasTortuousStem = false;
          _referencePosition = null;
          _latitude = null;
          _longitude = null;
          _accuracyMeters = null;
          _locationCapturedAt = null;
        });
      } else {
        _closeForm();
      }
    } catch (_) {
      if (!mounted) return;
      _showSnack('Não foi possível salvar a árvore.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDeleteTree(
    TreeRecord tree,
    TreeCollectionState state,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir árvore ${tree.number}?'),
        content: const Text('Essa ação apaga as medidas salvas da árvore.'),
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

    if (confirmed != true) return;

    await ref.read(treesRepositoryProvider).deleteTree(tree.id);
    _invalidateRelatedProviders(state);

    if (!mounted) return;
    _showSnack('Árvore ${tree.number} excluída.');
  }

  Future<void> _finishPlot(TreeCollectionState state) async {
    final message = state.trees.isEmpty
        ? 'A parcela não possui árvores registradas. Deseja encerrar mesmo assim?'
        : 'Encerrar a parcela ${state.plot.identification} como coletada?';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Encerrar parcela'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Encerrar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(treesRepositoryProvider).markPlotCollected(widget.plotId);
    _invalidateRelatedProviders(state);

    if (!mounted) return;
    _showSnack('Parcela ${state.plot.identification} encerrada.');
    Navigator.of(context).pop();
  }

  void _invalidateRelatedProviders(TreeCollectionState state) {
    ref.invalidate(treeCollectionProvider(widget.plotId));
    ref.invalidate(talhaoPlotsProvider(state.talhaoLevantamento.id));
    ref.invalidate(standPlotsProvider(state.stand.id));
    ref.invalidate(activeInventoryRunsProvider);
    ref.invalidate(activeInventoryRunProvider);
    ref.invalidate(inventoryRunDetailProvider(state.inventoryRun.id));
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<PlotReferencePosition?> _selectReferencePosition(
    TreeCollectionState state,
  ) {
    return showModalBottomSheet<PlotReferencePosition>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _ReferencePickerSheet(
        initialPosition: _referencePosition,
        capturedPositions: state.capturedReferencePositions,
      ),
    );
  }
}

class _ParcelHeader extends StatelessWidget {
  const _ParcelHeader({required this.state, required this.onFinish});

  final TreeCollectionState state;
  final VoidCallback? onFinish;

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
              Expanded(
                child: Text(
                  state.plot.identification,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: DendroColors.primary,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatusPill(label: _plotStatusLabel(state.plot.status)),
              const SizedBox(width: 6),
              IconButton.filledTonal(
                onPressed: onFinish,
                icon: const Icon(Icons.check_circle_outline),
                tooltip: 'Encerrar parcela',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '${state.stand.identification} • ${state.species.name}',
            style: const TextStyle(
              color: DendroColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _HeaderMetric(
                  icon: Icons.forest,
                  label: 'Árvores',
                  value: state.treeCount.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeaderMetric(
                  icon: Icons.add_location_alt,
                  label: 'Pontos GPS',
                  value: state.geoPoints.length.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? DendroColors.darkReadableField
        : Colors.white.withValues(alpha: 0.78);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon, size: 18, color: DendroColors.primary),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: DendroColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: DendroColors.primary,
                    fontSize: 18,
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

class _TreeFormCard extends StatelessWidget {
  const _TreeFormCard({
    required this.formKey,
    required this.treeNumber,
    required this.isEditing,
    required this.dapController,
    required this.heightController,
    required this.hasTortuousStem,
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.referencePosition,
    required this.saving,
    required this.capturingLocation,
    required this.onClose,
    required this.onTortuousChanged,
    required this.onCaptureLocation,
    required this.onClearLocation,
    required this.onSave,
    required this.onNext,
  });

  final GlobalKey<FormState> formKey;
  final int treeNumber;
  final bool isEditing;
  final TextEditingController dapController;
  final TextEditingController heightController;
  final bool hasTortuousStem;
  final double? latitude;
  final double? longitude;
  final double? accuracyMeters;
  final PlotReferencePosition? referencePosition;
  final bool saving;
  final bool capturingLocation;
  final VoidCallback? onClose;
  final ValueChanged<bool> onTortuousChanged;
  final VoidCallback onCaptureLocation;
  final VoidCallback onClearLocation;
  final VoidCallback onSave;
  final VoidCallback onNext;

  bool get hasLocation => latitude != null && longitude != null;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFF8FAF8),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Árvore $treeNumber',
                    style: const TextStyle(
                      color: DendroColors.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: capturingLocation ? null : onCaptureLocation,
                  tooltip: 'Capturar coordenada',
                  style: IconButton.styleFrom(
                    backgroundColor: DendroColors.primarySoft,
                    foregroundColor: DendroColors.primary,
                    disabledBackgroundColor: DendroColors.darkReadableField,
                    disabledForegroundColor: DendroColors.textMuted,
                  ),
                  icon: capturingLocation
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                ),
                IconButton(
                  onPressed: onClose,
                  tooltip: 'Recolher',
                  icon: const Icon(Icons.keyboard_arrow_up),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _MeasureField(
              controller: dapController,
              label: 'DAP (cm)',
              helper: 'Diâmetro a 1,30 m',
              validator: (value) => _measureValidator(value, 'DAP'),
            ),
            const SizedBox(height: 12),
            _MeasureField(
              controller: heightController,
              label: 'Altura (m)',
              helper: 'Medida ou estimada',
              validator: (value) => _measureValidator(value, 'altura'),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: hasTortuousStem,
              onChanged: saving ? null : onTortuousChanged,
              title: const Text(
                'Tronco torto?',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 4),
            if (hasLocation)
              _CapturedLocationCard(
                latitude: latitude!,
                longitude: longitude!,
                accuracyMeters: accuracyMeters,
                referencePosition: referencePosition,
                onClear: saving ? null : onClearLocation,
              )
            else
              const Text(
                'A coordenada é opcional. Use o botão de localização quando esta árvore representar uma quina da parcela.',
                style: TextStyle(
                  color: DendroColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: saving ? null : onSave,
                    icon: const Icon(Icons.save_outlined),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: DendroColors.primary,
                      disabledForegroundColor: DendroColors.textMuted,
                      side: BorderSide(
                        color: saving
                            ? DendroColors.outline
                            : DendroColors.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    label: const Text('Salvar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: saving ? null : onNext,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Próxima'),
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

class _MeasureField extends StatelessWidget {
  const _MeasureField({
    required this.controller,
    required this.label,
    required this.helper,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String helper;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton.filledTonal(
          onPressed: () => _step(-0.1),
          style: IconButton.styleFrom(
            backgroundColor: DendroColors.primarySoft,
            foregroundColor: DendroColors.primary,
          ),
          icon: const Icon(Icons.remove),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: controller,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: DendroColors.text,
              fontWeight: FontWeight.w800,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
            ],
            decoration: InputDecoration(
              labelText: label,
              helperText: helper,
              labelStyle: const TextStyle(
                color: DendroColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
              helperStyle: const TextStyle(
                color: DendroColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
              fillColor: DendroColors.darkReadableField,
            ),
            validator: validator,
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: () => _step(0.1),
          style: IconButton.styleFrom(
            backgroundColor: DendroColors.primarySoft,
            foregroundColor: DendroColors.primary,
          ),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  void _step(double delta) {
    final current = _parseMeasure(controller.text) ?? 0;
    final updated = (current + delta).clamp(0, double.infinity);
    controller.text = _formatMeasure(updated.toDouble());
  }
}

class _ReferencePickerSheet extends StatefulWidget {
  const _ReferencePickerSheet({
    required this.initialPosition,
    required this.capturedPositions,
  });

  final PlotReferencePosition? initialPosition;
  final Set<PlotReferencePosition> capturedPositions;

  @override
  State<_ReferencePickerSheet> createState() => _ReferencePickerSheetState();
}

class _ReferencePickerSheetState extends State<_ReferencePickerSheet> {
  late PlotReferencePosition _selected;

  @override
  void initState() {
    super.initState();
    _selected =
        widget.initialPosition ??
        _nextReferencePosition(widget.capturedPositions);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Qual ponta da parcela?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Selecione o ponto de referência antes de capturar o GPS. Pontos em verde já possuem coordenada salva.',
            style: TextStyle(
              color: DendroColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          _ReferenceSelector(
            selected: _selected,
            capturedPositions: widget.capturedPositions,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selected = value);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(_selected),
                  icon: const Icon(Icons.my_location),
                  label: const Text('Capturar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReferenceSelector extends StatelessWidget {
  const _ReferenceSelector({
    required this.selected,
    required this.capturedPositions,
    required this.onChanged,
  });

  final PlotReferencePosition? selected;
  final Set<PlotReferencePosition> capturedPositions;
  final ValueChanged<PlotReferencePosition?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final position in PlotReferencePosition.values)
          ChoiceChip(
            label: Text(_referenceLabel(position)),
            selected: selected == position,
            onSelected: onChanged == null
                ? null
                : (selected) => onChanged!(selected ? position : null),
            backgroundColor: capturedPositions.contains(position)
                ? const Color(0xFFD7F0DF)
                : const Color(0xFFF0F2F0),
            selectedColor: DendroColors.primary,
            labelStyle: TextStyle(
              color: selected == position
                  ? Colors.white
                  : capturedPositions.contains(position)
                  ? DendroColors.primary
                  : DendroColors.textMuted,
              fontWeight: FontWeight.w900,
            ),
          ),
      ],
    );
  }
}

class _CapturedLocationCard extends StatelessWidget {
  const _CapturedLocationCard({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.referencePosition,
    required this.onClear,
  });

  final double latitude;
  final double longitude;
  final double? accuracyMeters;
  final PlotReferencePosition? referencePosition;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFEAF7EF),
      borderColor: const Color(0xFFA4D1B4),
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      child: Row(
        children: [
          const Icon(Icons.add_location_alt, color: DendroColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${referencePosition == null ? 'Ponto GPS' : _referenceLabel(referencePosition!)} • '
              '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}'
              '${accuracyMeters == null ? '' : ' • ±${accuracyMeters!.toStringAsFixed(1)} m'}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
          IconButton(
            onPressed: onClear,
            tooltip: 'Remover coordenada',
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class _TreeItem extends StatelessWidget {
  const _TreeItem({
    required this.tree,
    required this.onEdit,
    required this.onDelete,
  });

  final TreeRecord tree;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final reference = tree.plotReferencePosition;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DendroCard(
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Árvore ${tree.number}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      if (reference != null)
                        StatusPill(label: _referenceLabel(reference)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'DAP: ${_formatMeasure(tree.dapCm)} cm • Alt.: ${_formatMeasure(tree.heightM)} m',
                    style: const TextStyle(
                      color: DendroColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (tree.latitude != null && tree.longitude != null)
                    Text(
                      '${tree.latitude!.toStringAsFixed(5)}, ${tree.longitude!.toStringAsFixed(5)}',
                      style: const TextStyle(
                        color: DendroColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
            PopupMenuButton<_TreeAction>(
              tooltip: 'Ações',
              icon: const Icon(Icons.more_vert),
              onSelected: (action) {
                switch (action) {
                  case _TreeAction.edit:
                    onEdit();
                  case _TreeAction.delete:
                    onDelete();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _TreeAction.edit,
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined),
                      SizedBox(width: 10),
                      Text('Editar'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: _TreeAction.delete,
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
    );
  }
}

class _EmptyTreesCard extends StatelessWidget {
  const _EmptyTreesCard();

  @override
  Widget build(BuildContext context) {
    return const DendroCard(
      backgroundColor: Color(0xFFF3F4F3),
      child: Column(
        children: [
          Icon(Icons.forest_outlined, size: 42, color: DendroColors.secondary),
          SizedBox(height: 12),
          Text(
            'Nenhuma árvore registrada',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 6),
          Text(
            'Use “Nova árvore” para iniciar a coleta desta parcela.',
            textAlign: TextAlign.center,
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
                'Não foi possível carregar a coleta.',
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

enum _TreeAction { edit, delete }

String? _measureValidator(String? value, String label) {
  final parsed = _parseMeasure(value ?? '');
  if (parsed == null) return 'Informe $label';
  if (parsed <= 0) return '$label deve ser maior que zero';
  return null;
}

double? _parseMeasure(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return double.tryParse(trimmed.replaceAll(',', '.'));
}

String _formatMeasure(double value) {
  return value.toStringAsFixed(1).replaceAll('.', ',');
}

String _plotStatusLabel(PlotStatus status) {
  switch (status) {
    case PlotStatus.pending:
      return 'Pendente';
    case PlotStatus.inProgress:
      return 'Em andamento';
    case PlotStatus.collected:
      return 'Coletada';
  }
}

String _referenceLabel(PlotReferencePosition position) {
  switch (position) {
    case PlotReferencePosition.p1:
      return 'P1';
    case PlotReferencePosition.p2:
      return 'P2';
    case PlotReferencePosition.p3:
      return 'P3';
    case PlotReferencePosition.p4:
      return 'P4';
  }
}

PlotReferencePosition _nextReferencePosition(
  Set<PlotReferencePosition> captured,
) {
  for (final position in PlotReferencePosition.values) {
    if (!captured.contains(position)) return position;
  }
  return PlotReferencePosition.p1;
}
