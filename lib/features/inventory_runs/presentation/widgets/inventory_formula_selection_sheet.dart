import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/dendro_theme.dart';
import '../../../../core/database/dendro_database.dart';
import '../../../../core/forest/forest_volume_calculator.dart';
import '../../../../shared/widgets/dendro_widgets.dart';
import '../../../settings/data/settings_repository.dart';
import '../../data/inventory_formula_selection.dart';

Future<InventoryFormulaSelection?> showInventoryFormulaSelectionSheet({
  required BuildContext context,
  required String speciesId,
  InventoryFormulaSelection? initialSelection,
}) {
  return showModalBottomSheet<InventoryFormulaSelection>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => _InventoryFormulaSelectionSheet(
      speciesId: speciesId,
      initialSelection: initialSelection,
    ),
  );
}

class _InventoryFormulaSelectionSheet extends ConsumerStatefulWidget {
  const _InventoryFormulaSelectionSheet({
    required this.speciesId,
    required this.initialSelection,
  });

  final String speciesId;
  final InventoryFormulaSelection? initialSelection;

  @override
  ConsumerState<_InventoryFormulaSelectionSheet> createState() =>
      _InventoryFormulaSelectionSheetState();
}

class _InventoryFormulaSelectionSheetState
    extends ConsumerState<_InventoryFormulaSelectionSheet> {
  final Map<String, TextEditingController> _controllers = {};
  String? _selectedFormulaId;
  String? _lastPreparedFormulaId;

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formulasAsync = ref.watch(settingsFormulasProvider);
    final linksAsync = ref.watch(settingsSpeciesFormulasProvider);
    final speciesCoefficientsAsync = ref.watch(
      settingsSpeciesFormulaCoefficientsProvider,
    );
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: formulasAsync.when(
        data: (formulas) {
          if (linksAsync.isLoading && !linksAsync.hasValue) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (speciesCoefficientsAsync.isLoading &&
              !speciesCoefficientsAsync.hasValue) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (linksAsync.hasError || speciesCoefficientsAsync.hasError) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: _FormulaSelectionError(
                onRetry: () {
                  ref.invalidate(settingsSpeciesFormulasProvider);
                  ref.invalidate(settingsSpeciesFormulaCoefficientsProvider);
                },
              ),
            );
          }

          final links = linksAsync.value ?? const [];
          final speciesCoefficients =
              speciesCoefficientsAsync.value ??
              const <SpeciesFormulaCoefficientRecord>[];
          final linkedFormulaIds = links
              .where((link) => link.speciesId == widget.speciesId)
              .map((link) => link.formulaId)
              .toSet();
          final availableFormulas = formulas
              .where(
                (summary) =>
                    summary.formula.active &&
                    linkedFormulaIds.contains(summary.formula.id),
              )
              .toList();
          _ensureSelectedFormula(availableFormulas, links);

          final selectedFormula = _selectedFormula(availableFormulas);
          _prepareCoefficientControllers(selectedFormula, speciesCoefficients);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Ajustar modelo matemático',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      tooltip: 'Fechar',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (availableFormulas.isEmpty)
                  const _FormulaSelectionEmpty()
                else ...[
                  const Text(
                    'Modelo',
                    style: TextStyle(
                      color: DendroColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final formula in availableFormulas)
                    _FormulaChoiceTile(
                      summary: formula,
                      selected: formula.formula.id == _selectedFormulaId,
                      onTap: () {
                        setState(() {
                          _selectedFormulaId = formula.formula.id;
                          _lastPreparedFormulaId = null;
                        });
                      },
                    ),
                  const SizedBox(height: 12),
                  if (selectedFormula != null)
                    _CoefficientFields(
                      coefficients: selectedFormula.coefficients,
                      controllers: _controllers,
                    ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: selectedFormula == null
                          ? null
                          : () => _confirm(selectedFormula),
                      icon: const Icon(Icons.check),
                      label: const Text('Usar este modelo'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: _FormulaSelectionError(
            onRetry: () => ref.invalidate(settingsFormulasProvider),
          ),
        ),
      ),
    );
  }

  void _ensureSelectedFormula(
    List<FormulaSummary> formulas,
    List<SpeciesFormulaRecord> links,
  ) {
    if (formulas.isEmpty) {
      _selectedFormulaId = null;
      return;
    }

    final initialFormulaId = widget.initialSelection?.formulaId;
    final selectedStillExists = formulas.any(
      (summary) => summary.formula.id == _selectedFormulaId,
    );
    if (_selectedFormulaId != null && selectedStillExists) return;

    if (initialFormulaId != null &&
        formulas.any((summary) => summary.formula.id == initialFormulaId)) {
      _selectedFormulaId = initialFormulaId;
      return;
    }

    final defaultLink = links
        .where((link) => link.speciesId == widget.speciesId && link.isDefault)
        .firstOrNull;
    if (defaultLink != null &&
        formulas.any(
          (summary) => summary.formula.id == defaultLink.formulaId,
        )) {
      _selectedFormulaId = defaultLink.formulaId;
      return;
    }

    final firstLinked = links
        .where((link) => link.speciesId == widget.speciesId)
        .firstOrNull;
    if (firstLinked != null &&
        formulas.any(
          (summary) => summary.formula.id == firstLinked.formulaId,
        )) {
      _selectedFormulaId = firstLinked.formulaId;
      return;
    }

    _selectedFormulaId = formulas.first.formula.id;
  }

  FormulaSummary? _selectedFormula(List<FormulaSummary> formulas) {
    for (final formula in formulas) {
      if (formula.formula.id == _selectedFormulaId) return formula;
    }
    return null;
  }

  void _prepareCoefficientControllers(
    FormulaSummary? selectedFormula,
    List<SpeciesFormulaCoefficientRecord> speciesCoefficients,
  ) {
    if (selectedFormula == null) return;
    if (_lastPreparedFormulaId == selectedFormula.formula.id) return;

    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();

    final initialValues =
        selectedFormula.formula.id == widget.initialSelection?.formulaId
        ? widget.initialSelection!.coefficientValuesBySymbol
        : const <String, double?>{};
    final speciesValues = {
      for (final coefficient in speciesCoefficients)
        if (coefficient.speciesId == widget.speciesId &&
            coefficient.formulaId == selectedFormula.formula.id)
          coefficient.symbol: coefficient.value,
    };

    for (final coefficient in selectedFormula.coefficients) {
      final value = initialValues.containsKey(coefficient.symbol)
          ? initialValues[coefficient.symbol]
          : speciesValues[coefficient.symbol] ??
                coefficient.value ??
                ForestVolumeCalculator.defaultCoefficientValue(
                  formulaId: selectedFormula.formula.id,
                  symbol: coefficient.symbol,
                );

      _controllers[coefficient.symbol] = TextEditingController(
        text: value == null ? '' : _formatNumber(value),
      );
    }

    _lastPreparedFormulaId = selectedFormula.formula.id;
  }

  void _confirm(FormulaSummary selectedFormula) {
    final values = <String, double?>{};

    for (final coefficient in selectedFormula.coefficients) {
      final parsed = _parseOptionalDouble(
        _controllers[coefficient.symbol]?.text ?? '',
      );
      if (parsed == _invalidDouble) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade700,
            content: Text('Informe um valor válido para ${coefficient.label}.'),
          ),
        );
        return;
      }

      values[coefficient.symbol] = parsed as double?;
    }

    Navigator.of(context).pop(
      InventoryFormulaSelection(
        formulaId: selectedFormula.formula.id,
        formulaName: selectedFormula.formula.name,
        coefficientValuesBySymbol: values,
      ),
    );
  }
}

class _FormulaChoiceTile extends StatelessWidget {
  const _FormulaChoiceTile({
    required this.summary,
    required this.selected,
    required this.onTap,
  });

  final FormulaSummary summary;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DendroCard(
          backgroundColor: selected
              ? DendroColors.primarySoft
              : const Color(0xFFF3F4F3),
          borderColor: selected ? DendroColors.primary : DendroColors.outline,
          padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? DendroColors.primary : DendroColors.textMuted,
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
                            summary.formula.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const StatusPill(
                          label: 'Vinculado',
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      summary.formula.expression,
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
            ],
          ),
        ),
      ),
    );
  }
}

class _CoefficientFields extends StatelessWidget {
  const _CoefficientFields({
    required this.coefficients,
    required this.controllers,
  });

  final List<FormulaCoefficientRecord> coefficients;
  final Map<String, TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
    if (coefficients.isEmpty) {
      return const DendroCard(
        backgroundColor: Color(0xFFF3F4F3),
        child: Text(
          'Este modelo não possui coeficientes cadastrados.',
          style: TextStyle(
            color: DendroColors.textMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Coeficientes para este levantamento',
          style: TextStyle(
            color: DendroColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        for (final coefficient in coefficients)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              controller: controllers[coefficient.symbol],
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[-0-9,.]')),
              ],
              decoration: InputDecoration(
                labelText: '${coefficient.label} (${coefficient.symbol})',
                prefixIcon: const Icon(Icons.numbers),
              ),
            ),
          ),
      ],
    );
  }
}

class _FormulaSelectionEmpty extends StatelessWidget {
  const _FormulaSelectionEmpty();

  @override
  Widget build(BuildContext context) {
    return const DendroCard(
      backgroundColor: Color(0xFFF3F4F3),
      child: Text(
        'Nenhum modelo matemático vinculado à espécie selecionada.',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _FormulaSelectionError extends StatelessWidget {
  const _FormulaSelectionError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(height: 10),
          const Text(
            'Não foi possível carregar os modelos matemáticos.',
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

Object? _parseOptionalDouble(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return double.tryParse(trimmed.replaceAll(',', '.')) ?? _invalidDouble;
}

const _invalidDouble = Object();

String _formatNumber(double value) => value.toString().replaceAll('.', ',');
