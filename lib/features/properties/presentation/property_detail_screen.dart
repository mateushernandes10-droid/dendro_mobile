import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../core/database/dendro_database.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import '../data/properties_repository.dart';
import '../../stands/data/stands_repository.dart';
import '../../plots/presentation/stand_plots_screen.dart';

class PropertyDetailScreen extends ConsumerWidget {
  const PropertyDetailScreen({required this.property, super.key});

  final PropertyRecord property;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stands = ref.watch(propertyStandsProvider(property.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(property.name),
        actions: [
          IconButton(
            onPressed: () => _showComingSoon(context, 'Resultados'),
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Resultados',
          ),
          IconButton(
            onPressed: () => _showComingSoon(context, 'Exportação'),
            icon: const Icon(Icons.ios_share),
            tooltip: 'Exportar',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _PropertySummaryCard(property: property),
            const SizedBox(height: 18),
            SectionTitle(
              title: 'Talhões',
              trailing: FilledButton.icon(
                onPressed: () => _openStandForm(context, property.id),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Novo'),
              ),
            ),
            stands.when(
              data: (items) {
                if (items.isEmpty) {
                  return _EmptyStandsCard(
                    onCreate: () => _openStandForm(context, property.id),
                  );
                }

                return Column(
                  children: [
                    for (final item in items)
                      _StandItem(
                        summary: item,
                        onOpen: () => _openStandPlots(context, item),
                        onEdit: () =>
                            _openStandForm(context, property.id, summary: item),
                        onDelete: () => _confirmDeleteStand(context, ref, item),
                      ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => _LoadErrorCard(
                message: 'Não foi possível carregar os talhões.',
                onRetry: () =>
                    ref.invalidate(propertyStandsProvider(property.id)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openStandForm(
    BuildContext context,
    String propertyId, {
    StandSummary? summary,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          _StandFormSheet(propertyId: propertyId, summary: summary),
    );
  }

  Future<void> _openStandPlots(BuildContext context, StandSummary summary) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => StandPlotsScreen(standId: summary.stand.id),
      ),
    );
  }

  Future<void> _confirmDeleteStand(
    BuildContext context,
    WidgetRef ref,
    StandSummary summary,
  ) async {
    final stand = summary.stand;
    final message = summary.hasChildren
        ? 'O talhão já contém levantamentos vinculados. Se confirmar, todos os dados salvos relacionados serão apagados. Deseja continuar?'
        : 'Deseja excluir o talhão "${stand.identification}"?';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir talhão'),
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

    await ref.read(standsRepositoryProvider).delete(stand.id);
    ref.invalidate(propertyStandsProvider(property.id));
    ref.invalidate(propertySummariesProvider);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Talhão ${stand.identification} excluído.')),
    );
  }
}

class _PropertySummaryCard extends StatelessWidget {
  const _PropertySummaryCard({required this.property});

  final PropertyRecord property;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFE0F2E8),
      borderColor: const Color(0xFFA4D1B4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.name,
            style: const TextStyle(
              color: DendroColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _MetaPill(
                icon: Icons.place,
                label: '${property.municipality}-${property.state}',
              ),
              _MetaPill(
                icon: Icons.area_chart,
                label: '${_formatArea(property.totalAreaHa)} ha',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StandItem extends StatelessWidget {
  const _StandItem({
    required this.summary,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final StandSummary summary;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final stand = summary.stand;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onOpen,
        child: DendroCard(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            stand.identification,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (summary.hasActiveInventory) ...[
                          const SizedBox(width: 8),
                          const StatusPill(label: 'Em coleta'),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        _MetaText(icon: Icons.eco, label: summary.species.name),
                        _MetaText(
                          icon: Icons.area_chart,
                          label: '${_formatArea(stand.areaHa)} ha',
                        ),
                        if (stand.plantingYear != null)
                          _MetaText(
                            icon: Icons.calendar_month,
                            label: 'Plantio ${stand.plantingYear}',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_StandAction>(
                tooltip: 'Ações',
                icon: const Icon(Icons.more_vert),
                onSelected: (action) {
                  switch (action) {
                    case _StandAction.edit:
                      onEdit();
                    case _StandAction.delete:
                      onDelete();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _StandAction.edit,
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 10),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: _StandAction.delete,
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

class _StandFormSheet extends ConsumerStatefulWidget {
  const _StandFormSheet({required this.propertyId, this.summary});

  final String propertyId;
  final StandSummary? summary;

  @override
  ConsumerState<_StandFormSheet> createState() => _StandFormSheetState();
}

class _StandFormSheetState extends ConsumerState<_StandFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _identificationController;
  late final TextEditingController _areaController;
  late final TextEditingController _plantingYearController;
  late final TextEditingController _spacingController;
  late final TextEditingController _managementRegimeController;
  late final TextEditingController _notesController;
  String? _speciesId;
  bool _saving = false;

  bool get _isEditing => widget.summary != null;

  @override
  void initState() {
    super.initState();
    final stand = widget.summary?.stand;

    _identificationController = TextEditingController(
      text: stand?.identification ?? '',
    );
    _areaController = TextEditingController(
      text: stand == null ? '' : _formatArea(stand.areaHa),
    );
    _plantingYearController = TextEditingController(
      text: stand?.plantingYear?.toString() ?? '',
    );
    _spacingController = TextEditingController(text: stand?.spacing ?? '');
    _managementRegimeController = TextEditingController(
      text: stand?.managementRegime ?? '',
    );
    _notesController = TextEditingController(text: stand?.notes ?? '');
    _speciesId = stand?.speciesId;
  }

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
                      _isEditing ? 'Editar talhão' : 'Novo talhão',
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
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Identificação',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              species.when(
                data: (items) => DropdownButtonFormField<String>(
                  initialValue: _speciesId,
                  decoration: const InputDecoration(
                    labelText: 'Espécie',
                    prefixIcon: Icon(Icons.eco_outlined),
                  ),
                  items: [
                    for (final item in items)
                      DropdownMenuItem(value: item.id, child: Text(item.name)),
                  ],
                  onChanged: _saving
                      ? null
                      : (value) => setState(() => _speciesId = value),
                  validator: (value) =>
                      value == null ? 'Selecione uma espécie' : null,
                ),
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

    final repository = ref.read(standsRepositoryProvider);
    final area = _parseArea(_areaController.text)!;
    final plantingYear = _parseOptionalInt(_plantingYearController.text);

    try {
      if (_isEditing) {
        await repository.update(
          id: widget.summary!.stand.id,
          identification: _identificationController.text,
          speciesId: _speciesId!,
          areaHa: area,
          plantingYear: plantingYear,
          spacing: _spacingController.text,
          managementRegime: _managementRegimeController.text,
          notes: _notesController.text,
        );
      } else {
        await repository.create(
          propertyId: widget.propertyId,
          identification: _identificationController.text,
          speciesId: _speciesId!,
          areaHa: area,
          plantingYear: plantingYear,
          spacing: _spacingController.text,
          managementRegime: _managementRegimeController.text,
          notes: _notesController.text,
        );
      }

      if (!mounted) return;
      ref.invalidate(propertyStandsProvider(widget.propertyId));
      ref.invalidate(propertySummariesProvider);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Talhão atualizado.' : 'Talhão cadastrado.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar o talhão.')),
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

class _EmptyStandsCard extends StatelessWidget {
  const _EmptyStandsCard({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      backgroundColor: const Color(0xFFF3F4F3),
      child: Column(
        children: [
          const Icon(
            Icons.forest_outlined,
            size: 42,
            color: DendroColors.secondary,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhum talhão cadastrado',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Cadastre os talhões da propriedade para organizar os levantamentos.',
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
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Cadastrar talhão'),
            ),
          ),
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

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: DendroColors.primary),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                color: DendroColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.icon, required this.label});

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

enum _StandAction { edit, delete }

void _showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$feature entra em uma próxima etapa.')),
  );
}

String _formatArea(double value) {
  return value.toStringAsFixed(2).replaceAll('.', ',');
}

double? _parseArea(String value) {
  return double.tryParse(value.trim().replaceAll(',', '.'));
}

int? _parseOptionalInt(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return int.tryParse(trimmed);
}
