import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/dendro_theme.dart';
import '../../../core/database/dendro_database.dart';
import '../../../core/preferences/theme_mode_controller.dart';
import '../../../shared/widgets/dendro_widgets.dart';
import '../data/settings_repository.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DendroScreen(
      title: 'Ajustes',
      icon: Icons.settings,
      children: [
        const SectionTitle(title: 'Preferências'),
        const _ThemeModeCard(),
        const SizedBox(height: 18),
        const SectionTitle(title: 'Cadastros'),
        _SettingsOptionTile(
          icon: Icons.eco_outlined,
          title: 'Cadastro de espécies',
          subtitle: 'Espécies, vínculos de fórmulas e modelo padrão.',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const _SpeciesSettingsScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        _SettingsOptionTile(
          icon: Icons.functions,
          title: 'Modelos matemáticos',
          subtitle: 'Fórmulas, variáveis e coeficientes de cálculo.',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const _FormulaSettingsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SpeciesSettingsScreen extends ConsumerWidget {
  const _SpeciesSettingsScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speciesAsync = ref.watch(settingsSpeciesProvider);
    final formulasAsync = ref.watch(settingsFormulasProvider);
    final speciesFormulasAsync = ref.watch(settingsSpeciesFormulasProvider);

    return DendroScreen(
      title: 'Cadastro de espécies',
      icon: Icons.eco,
      floatingActionButton: FloatingActionButton(
        heroTag: 'settings_new_species',
        onPressed: () => _openSpeciesForm(context),
        tooltip: 'Nova espécie',
        child: const Icon(Icons.add),
      ),
      children: [
        const SectionTitle(title: 'Espécies cadastradas'),
        _CatalogState(
          asyncValues: [speciesAsync, formulasAsync, speciesFormulasAsync],
          onRetry: () {
            ref.invalidate(settingsSpeciesProvider);
            ref.invalidate(settingsFormulasProvider);
            ref.invalidate(settingsSpeciesFormulasProvider);
          },
          builder: () {
            final species = speciesAsync.value ?? const <SpeciesRecord>[];
            final formulas = formulasAsync.value ?? const <FormulaSummary>[];
            final links =
                speciesFormulasAsync.value ?? const <SpeciesFormulaRecord>[];

            if (species.isEmpty) {
              return _EmptyCatalogCard(
                icon: Icons.eco_outlined,
                title: 'Nenhuma espécie cadastrada',
                message:
                    'Cadastre espécies para vincular os modelos matemáticos.',
                buttonLabel: 'Cadastrar espécie',
                onPressed: () => _openSpeciesForm(context),
              );
            }

            return Column(
              children: [
                for (final item in species)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _SpeciesCard(
                      species: item,
                      formulas: formulas,
                      links: links
                          .where((link) => link.speciesId == item.id)
                          .toList(),
                      onEdit: () => _openSpeciesForm(context, species: item),
                      onDelete: () => _confirmDeleteSpecies(context, ref, item),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FormulaSettingsScreen extends ConsumerWidget {
  const _FormulaSettingsScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formulasAsync = ref.watch(settingsFormulasProvider);

    return DendroScreen(
      title: 'Modelos matemáticos',
      icon: Icons.functions,
      floatingActionButton: FloatingActionButton(
        heroTag: 'settings_new_formula',
        onPressed: () => _openFormulaForm(context),
        tooltip: 'Nova fórmula',
        child: const Icon(Icons.add),
      ),
      children: [
        const SectionTitle(title: 'Fórmulas cadastradas'),
        formulasAsync.when(
          data: (formulas) {
            if (formulas.isEmpty) {
              return _EmptyCatalogCard(
                icon: Icons.functions,
                title: 'Nenhuma fórmula cadastrada',
                message:
                    'Cadastre os modelos que serão usados no cálculo de volume.',
                buttonLabel: 'Cadastrar fórmula',
                onPressed: () => _openFormulaForm(context),
              );
            }

            return Column(
              children: [
                for (final formula in formulas)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _FormulaCard(
                      key: ValueKey(formula.formula.id),
                      summary: formula,
                      onEdit: () => _openFormulaForm(context, summary: formula),
                      onDelete: () =>
                          _confirmDeleteFormula(context, ref, formula.formula),
                    ),
                  ),
              ],
            );
          },
          loading: () => const _LoadingCard(),
          error: (error, stackTrace) => _SettingsErrorCard(
            message: 'Não foi possível carregar as fórmulas.',
            onRetry: () => ref.invalidate(settingsFormulasProvider),
          ),
        ),
      ],
    );
  }
}

class _SettingsOptionTile extends StatelessWidget {
  const _SettingsOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: DendroCard(
        padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: DendroColors.primarySoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: DendroColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
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
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: DendroColors.textMuted),
          ],
        ),
      ),
    );
  }
}

Future<void> _openSpeciesForm(BuildContext context, {SpeciesRecord? species}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _SpeciesFormSheet(species: species),
  );
}

Future<void> _openFormulaForm(BuildContext context, {FormulaSummary? summary}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _FormulaFormSheet(summary: summary),
  );
}

Future<void> _confirmDeleteSpecies(
  BuildContext context,
  WidgetRef ref,
  SpeciesRecord species,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Excluir espécie'),
      content: Text(
        'Deseja excluir "${species.name}"? Se ela estiver vinculada a talhões, o app não permitirá a exclusão.',
      ),
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

  try {
    await ref.read(settingsRepositoryProvider).deleteSpecies(species.id);
    if (!context.mounted) return;
    _showSnack(context, '${species.name} excluída.');
  } catch (_) {
    if (!context.mounted) return;
    _showSnack(
      context,
      'Não foi possível excluir a espécie. Verifique se ela está em uso.',
      isError: true,
    );
  }
}

Future<void> _confirmDeleteFormula(
  BuildContext context,
  WidgetRef ref,
  FormulaRecord formula,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Excluir fórmula'),
      content: Text(
        'Deseja excluir "${formula.name}"? Se ela estiver em uso em algum levantamento, o app não permitirá a exclusão.',
      ),
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

  try {
    await ref.read(settingsRepositoryProvider).deleteFormula(formula.id);
    if (!context.mounted) return;
    _showSnack(context, '${formula.name} excluída.');
  } catch (_) {
    if (!context.mounted) return;
    _showSnack(
      context,
      'Não foi possível excluir a fórmula. Verifique se ela está em uso.',
      isError: true,
    );
  }
}

class _CatalogState extends StatelessWidget {
  const _CatalogState({
    required this.asyncValues,
    required this.builder,
    required this.onRetry,
  });

  final List<AsyncValue<Object?>> asyncValues;
  final Widget Function() builder;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (asyncValues.any((value) => value.hasError)) {
      return _SettingsErrorCard(
        message: 'Não foi possível carregar os cadastros.',
        onRetry: onRetry,
      );
    }

    if (asyncValues.any((value) => value.isLoading && !value.hasValue)) {
      return const _LoadingCard();
    }

    return builder();
  }
}

class _ThemeModeCard extends ConsumerWidget {
  const _ThemeModeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(appDarkModeProvider);

    return DendroCard(
      padding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
      child: Material(
        color: Colors.transparent,
        child: SwitchListTile(
          value: darkMode,
          onChanged: (enabled) async {
            try {
              await ref
                  .read(appThemeControllerProvider.notifier)
                  .setDarkMode(enabled);
              if (!context.mounted) return;
              _showSnack(
                context,
                enabled ? 'Modo escuro ativado.' : 'Modo claro ativado.',
              );
            } catch (_) {
              if (!context.mounted) return;
              _showSnack(
                context,
                'Não foi possível salvar a preferência de tema.',
                isError: true,
              );
            }
          },
          secondary: Icon(
            darkMode ? Icons.dark_mode : Icons.light_mode_outlined,
            color: DendroColors.primary,
          ),
          title: const Text(
            'Modo escuro',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          subtitle: const Text(
            'Aplica o tema escuro ao app e mantém essa escolha ao abrir novamente.',
          ),
          contentPadding: const EdgeInsets.only(left: 8),
          activeThumbColor: DendroColors.primary,
        ),
      ),
    );
  }
}

class _SpeciesCard extends ConsumerWidget {
  const _SpeciesCard({
    required this.species,
    required this.formulas,
    required this.links,
    required this.onEdit,
    required this.onDelete,
  });

  final SpeciesRecord species;
  final List<FormulaSummary> formulas;
  final List<SpeciesFormulaRecord> links;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DendroCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.fromLTRB(14, 8, 4, 8),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        shape: const RoundedRectangleBorder(),
        collapsedShape: const RoundedRectangleBorder(),
        title: Row(
          children: [
            Expanded(
              child: Text(
                species.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            StatusPill(
              label: species.active ? 'Ativa' : 'Inativa',
              color: species.active
                  ? DendroColors.primarySoft
                  : DendroColors.surfaceMuted,
              textColor: species.active
                  ? DendroColors.primary
                  : DendroColors.textMuted,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            _speciesSubtitle(species),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: DendroColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        trailing: PopupMenuButton<_SpeciesAction>(
          tooltip: 'Ações',
          icon: const Icon(Icons.more_vert),
          onSelected: (action) {
            switch (action) {
              case _SpeciesAction.edit:
                onEdit();
              case _SpeciesAction.delete:
                onDelete();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: _SpeciesAction.edit,
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 10),
                  Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: _SpeciesAction.delete,
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
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Modelos vinculados',
              style: TextStyle(
                color: DendroColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (formulas.isEmpty)
            const _MutedText('Cadastre uma fórmula para vincular à espécie.')
          else
            for (final formula in formulas)
              _SpeciesFormulaRow(
                formula: formula.formula,
                link: _linkForFormula(links, formula.formula.id),
                onLinkedChanged: (linked) async {
                  try {
                    await ref
                        .read(settingsRepositoryProvider)
                        .setSpeciesFormulaLinked(
                          speciesId: species.id,
                          formulaId: formula.formula.id,
                          linked: linked,
                        );
                  } catch (_) {
                    if (!context.mounted) return;
                    _showSnack(
                      context,
                      'Não foi possível alterar o vínculo da fórmula.',
                      isError: true,
                    );
                  }
                },
                onSetDefault: () async {
                  try {
                    await ref
                        .read(settingsRepositoryProvider)
                        .setDefaultFormulaForSpecies(
                          speciesId: species.id,
                          formulaId: formula.formula.id,
                        );
                  } catch (_) {
                    if (!context.mounted) return;
                    _showSnack(
                      context,
                      'Não foi possível definir a fórmula padrão.',
                      isError: true,
                    );
                  }
                },
              ),
        ],
      ),
    );
  }
}

class _SpeciesFormulaRow extends StatelessWidget {
  const _SpeciesFormulaRow({
    required this.formula,
    required this.link,
    required this.onLinkedChanged,
    required this.onSetDefault,
  });

  final FormulaRecord formula;
  final SpeciesFormulaRecord? link;
  final ValueChanged<bool> onLinkedChanged;
  final VoidCallback onSetDefault;

  bool get _linked => link != null;
  bool get _isDefault => link?.isDefault ?? false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = _isDefault
        ? (isDark
              ? DendroColors.darkReadableField
              : DendroColors.primarySoft.withValues(alpha: 0.55))
        : _linked
        ? (isDark ? const Color(0xFFD3E4D7) : const Color(0xFFF3F4F3))
        : (isDark ? const Color(0xFFC2D3C7) : const Color(0xFFF3F4F3));
    final borderColor = _isDefault
        ? DendroColors.primary
        : _linked
        ? (isDark ? const Color(0xFF7D9B86) : DendroColors.outline)
        : (isDark ? const Color(0xFF91A99A) : DendroColors.outline);
    final checkboxBorderColor = _linked
        ? DendroColors.primary
        : DendroColors.textMuted;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Checkbox(
              value: _linked,
              onChanged: (value) => onLinkedChanged(value ?? false),
              activeColor: DendroColors.primary,
              checkColor: Colors.white,
              side: BorderSide(color: checkboxBorderColor, width: 1.5),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formula.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: DendroColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formula.expression,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: DendroColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: onSetDefault,
              tooltip: _isDefault ? 'Fórmula padrão' : 'Definir como padrão',
              style: IconButton.styleFrom(
                foregroundColor: _isDefault
                    ? DendroColors.warning
                    : DendroColors.textMuted,
              ),
              icon: Icon(
                _isDefault ? Icons.star : Icons.star_border,
                color: _isDefault
                    ? DendroColors.warning
                    : DendroColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormulaCard extends ConsumerStatefulWidget {
  const _FormulaCard({
    required this.summary,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final FormulaSummary summary;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  ConsumerState<_FormulaCard> createState() => _FormulaCardState();
}

class _FormulaCardState extends ConsumerState<_FormulaCard> {
  final Map<String, TextEditingController> _coefficientControllers = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  @override
  void didUpdateWidget(covariant _FormulaCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncControllers();
  }

  @override
  void dispose() {
    for (final controller in _coefficientControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formula = widget.summary.formula;

    return DendroCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.fromLTRB(14, 8, 4, 8),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        shape: const RoundedRectangleBorder(),
        collapsedShape: const RoundedRectangleBorder(),
        title: Row(
          children: [
            Expanded(
              child: Text(
                formula.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            StatusPill(
              label: formula.active ? 'Ativo' : 'Inativo',
              color: formula.active
                  ? DendroColors.primarySoft
                  : DendroColors.surfaceMuted,
              textColor: formula.active
                  ? DendroColors.primary
                  : DendroColors.textMuted,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            formula.expression,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: DendroColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        trailing: PopupMenuButton<_FormulaAction>(
          tooltip: 'Ações',
          icon: const Icon(Icons.more_vert),
          onSelected: (action) {
            switch (action) {
              case _FormulaAction.edit:
                widget.onEdit();
              case _FormulaAction.delete:
                widget.onDelete();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: _FormulaAction.edit,
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 10),
                  Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: _FormulaAction.delete,
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
        children: [
          if (widget.summary.formula.description != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.summary.formula.description!,
                style: const TextStyle(
                  color: DendroColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          _FormulaVariables(variables: widget.summary.variables),
          const SizedBox(height: 12),
          _CoefficientEditor(
            coefficients: widget.summary.coefficients,
            controllers: _coefficientControllers,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saving || widget.summary.coefficients.isEmpty
                  ? null
                  : _saveCoefficients,
              icon: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: const Text('Salvar coeficientes'),
            ),
          ),
        ],
      ),
    );
  }

  void _syncControllers() {
    final currentIds = widget.summary.coefficients
        .map((item) => item.id)
        .toSet();

    for (final id in _coefficientControllers.keys.toList()) {
      if (!currentIds.contains(id)) {
        _coefficientControllers.remove(id)?.dispose();
      }
    }

    for (final coefficient in widget.summary.coefficients) {
      final text = coefficient.value == null
          ? ''
          : _formatNumber(coefficient.value!, decimals: 6);
      final controller = _coefficientControllers[coefficient.id];
      if (controller == null) {
        _coefficientControllers[coefficient.id] = TextEditingController(
          text: text,
        );
      } else if (controller.text != text) {
        controller.text = text;
      }
    }
  }

  Future<void> _saveCoefficients() async {
    final values = <String, double?>{};

    for (final coefficient in widget.summary.coefficients) {
      final parsed = _parseOptionalDouble(
        _coefficientControllers[coefficient.id]?.text ?? '',
      );
      if (parsed == _invalidDouble) {
        _showSnack(
          context,
          'Informe um valor válido para ${coefficient.label}.',
          isError: true,
        );
        return;
      }
      values[coefficient.id] = parsed as double?;
    }

    setState(() => _saving = true);

    try {
      await ref
          .read(settingsRepositoryProvider)
          .updateCoefficientValues(
            formulaId: widget.summary.formula.id,
            valuesByCoefficientId: values,
          );
      if (!mounted) return;
      _showSnack(context, 'Coeficientes salvos.');
    } catch (_) {
      if (!mounted) return;
      _showSnack(
        context,
        'Não foi possível salvar os coeficientes.',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _FormulaVariables extends StatelessWidget {
  const _FormulaVariables({required this.variables});

  final List<FormulaVariableRecord> variables;

  @override
  Widget build(BuildContext context) {
    if (variables.isEmpty) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: _MutedText('Nenhuma variável definida para este modelo.'),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final variable in variables)
            StatusPill(
              label:
                  '${variable.symbol} - ${variable.label} (${variable.unit})',
              color: const Color(0xFFF3F4F3),
              textColor: DendroColors.text,
            ),
        ],
      ),
    );
  }
}

class _CoefficientEditor extends StatelessWidget {
  const _CoefficientEditor({
    required this.coefficients,
    required this.controllers,
  });

  final List<FormulaCoefficientRecord> coefficients;
  final Map<String, TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
    if (coefficients.isEmpty) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: _MutedText('Nenhum coeficiente definido para este modelo.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Coeficientes atuais',
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
              controller: controllers[coefficient.id],
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

class _SpeciesFormSheet extends ConsumerStatefulWidget {
  const _SpeciesFormSheet({this.species});

  final SpeciesRecord? species;

  @override
  ConsumerState<_SpeciesFormSheet> createState() => _SpeciesFormSheetState();
}

class _SpeciesFormSheetState extends ConsumerState<_SpeciesFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _scientificNameController;
  late final TextEditingController _descriptionController;
  late bool _active;
  bool _saving = false;

  bool get _isEditing => widget.species != null;

  @override
  void initState() {
    super.initState();
    final species = widget.species;
    _nameController = TextEditingController(text: species?.name ?? '');
    _scientificNameController = TextEditingController(
      text: species?.scientificName ?? '',
    );
    _descriptionController = TextEditingController(
      text: species?.description ?? '',
    );
    _active = species?.active ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _scientificNameController.dispose();
    _descriptionController.dispose();
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
              _SheetHeader(
                title: _isEditing ? 'Editar espécie' : 'Nova espécie',
                saving: _saving,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome da espécie',
                  prefixIcon: Icon(Icons.eco_outlined),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _scientificNameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome científico (opcional)',
                  prefixIcon: Icon(Icons.local_florist_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Observação (opcional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                value: _active,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _active = value),
                title: const Text('Espécie ativa'),
                contentPadding: EdgeInsets.zero,
                activeThumbColor: DendroColors.primary,
              ),
              const SizedBox(height: 12),
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

    final repository = ref.read(settingsRepositoryProvider);

    try {
      if (_isEditing) {
        await repository.updateSpecies(
          id: widget.species!.id,
          name: _nameController.text,
          scientificName: _scientificNameController.text,
          description: _descriptionController.text,
          active: _active,
        );
      } else {
        await repository.createSpecies(
          name: _nameController.text,
          scientificName: _scientificNameController.text,
          description: _descriptionController.text,
          active: _active,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      _showSnack(
        context,
        _isEditing ? 'Espécie atualizada.' : 'Espécie cadastrada.',
      );
    } catch (_) {
      if (!mounted) return;
      _showSnack(
        context,
        'Não foi possível salvar a espécie. Verifique se o nome já existe.',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _FormulaFormSheet extends ConsumerStatefulWidget {
  const _FormulaFormSheet({this.summary});

  final FormulaSummary? summary;

  @override
  ConsumerState<_FormulaFormSheet> createState() => _FormulaFormSheetState();
}

class _FormulaFormSheetState extends ConsumerState<_FormulaFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _expressionController;
  late final TextEditingController _coefficientSymbolsController;
  late final Set<FormulaVariableKey> _selectedVariables;
  late bool _active;
  bool _saving = false;

  bool get _isEditing => widget.summary != null;

  @override
  void initState() {
    super.initState();
    final summary = widget.summary;
    _nameController = TextEditingController(text: summary?.formula.name ?? '');
    _descriptionController = TextEditingController(
      text: summary?.formula.description ?? '',
    );
    _expressionController = TextEditingController(
      text: summary?.formula.expression ?? '',
    );
    _coefficientSymbolsController = TextEditingController(
      text:
          summary?.coefficients.map((item) => item.symbol).join(', ') ?? 'a, b',
    );
    _selectedVariables = summary == null
        ? {FormulaVariableKey.dap, FormulaVariableKey.height}
        : summary.variables.map((item) => item.variableKey).toSet();
    _active = summary?.formula.active ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _expressionController.dispose();
    _coefficientSymbolsController.dispose();
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
              _SheetHeader(
                title: _isEditing ? 'Editar fórmula' : 'Nova fórmula',
                saving: _saving,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome do modelo',
                  prefixIcon: Icon(Icons.functions),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _expressionController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Fórmula',
                  hintText: 'Ex.: a + b * (D^2 * H)',
                  prefixIcon: Icon(Icons.calculate_outlined),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _coefficientSymbolsController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Coeficientes',
                  hintText: 'Ex.: a, b, c',
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (_parseSymbols(value ?? '').isEmpty) {
                    return 'Informe ao menos um coeficiente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Variáveis usadas',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              for (final definition in _variableDefinitions)
                CheckboxListTile(
                  value: _selectedVariables.contains(definition.key),
                  onChanged: _saving
                      ? null
                      : (value) {
                          setState(() {
                            if (value ?? false) {
                              _selectedVariables.add(definition.key);
                            } else {
                              _selectedVariables.remove(definition.key);
                            }
                          });
                        },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: DendroColors.primary,
                  title: Text(definition.label),
                  subtitle: Text('${definition.symbol} - ${definition.unit}'),
                ),
              SwitchListTile(
                value: _active,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _active = value),
                title: const Text('Fórmula ativa'),
                contentPadding: EdgeInsets.zero,
                activeThumbColor: DendroColors.primary,
              ),
              const SizedBox(height: 12),
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

    if (_selectedVariables.isEmpty) {
      _showSnack(
        context,
        'Selecione ao menos uma variável para a fórmula.',
        isError: true,
      );
      return;
    }

    setState(() => _saving = true);

    final repository = ref.read(settingsRepositoryProvider);
    final variables = _variableDefinitions
        .where((item) => _selectedVariables.contains(item.key))
        .map((item) => item.toDraft())
        .toList();
    final coefficients = _parseSymbols(_coefficientSymbolsController.text);

    try {
      if (_isEditing) {
        await repository.updateFormula(
          id: widget.summary!.formula.id,
          name: _nameController.text,
          description: _descriptionController.text,
          expression: _expressionController.text,
          variables: variables,
          coefficientSymbols: coefficients,
          active: _active,
        );
      } else {
        await repository.createFormula(
          name: _nameController.text,
          description: _descriptionController.text,
          expression: _expressionController.text,
          variables: variables,
          coefficientSymbols: coefficients,
          active: _active,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      _showSnack(
        context,
        _isEditing ? 'Fórmula atualizada.' : 'Fórmula cadastrada.',
      );
    } catch (_) {
      if (!mounted) return;
      _showSnack(
        context,
        'Não foi possível salvar a fórmula. Verifique se o nome já existe.',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title, required this.saving});

  final String title;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
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

class _EmptyCatalogCard extends StatelessWidget {
  const _EmptyCatalogCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

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
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.add),
              label: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const DendroCard(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _SettingsErrorCard extends StatelessWidget {
  const _SettingsErrorCard({required this.message, required this.onRetry});

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

class _MutedText extends StatelessWidget {
  const _MutedText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: DendroColors.textMuted,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _VariableDefinition {
  const _VariableDefinition({
    required this.key,
    required this.symbol,
    required this.label,
    required this.unit,
    required this.valueSource,
  });

  final FormulaVariableKey key;
  final String symbol;
  final String label;
  final String unit;
  final String valueSource;

  FormulaVariableDraft toDraft() {
    return FormulaVariableDraft(
      symbol: symbol,
      label: label,
      unit: unit,
      valueSource: valueSource,
      variableKey: key,
    );
  }
}

const _variableDefinitions = [
  _VariableDefinition(
    key: FormulaVariableKey.dap,
    symbol: 'D',
    label: 'DAP',
    unit: 'cm',
    valueSource: 'Medição da árvore',
  ),
  _VariableDefinition(
    key: FormulaVariableKey.height,
    symbol: 'H',
    label: 'Altura',
    unit: 'm',
    valueSource: 'Medição da árvore',
  ),
  _VariableDefinition(
    key: FormulaVariableKey.age,
    symbol: 'I',
    label: 'Idade',
    unit: 'anos',
    valueSource: 'Talhão',
  ),
  _VariableDefinition(
    key: FormulaVariableKey.basalArea,
    symbol: 'G',
    label: 'Área basal',
    unit: 'm2/ha',
    valueSource: 'Cálculo',
  ),
];

enum _SpeciesAction { edit, delete }

enum _FormulaAction { edit, delete }

SpeciesFormulaRecord? _linkForFormula(
  List<SpeciesFormulaRecord> links,
  String formulaId,
) {
  for (final link in links) {
    if (link.formulaId == formulaId) return link;
  }
  return null;
}

String _speciesSubtitle(SpeciesRecord species) {
  final scientificName = species.scientificName;
  final description = species.description;

  if (scientificName != null && description != null) {
    return '$scientificName - $description';
  }
  if (scientificName != null) return scientificName;
  if (description != null) return description;
  return 'Sem observação cadastrada';
}

String? _requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Campo obrigatório';
  }
  return null;
}

List<String> _parseSymbols(String value) {
  final symbols = <String>[];

  for (final item in value.split(',')) {
    final symbol = item.trim();
    if (symbol.isEmpty || symbols.contains(symbol)) continue;
    symbols.add(symbol);
  }

  return symbols;
}

Object? _parseOptionalDouble(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return double.tryParse(trimmed.replaceAll(',', '.')) ?? _invalidDouble;
}

const _invalidDouble = Object();

String _formatNumber(double value, {int decimals = 2}) {
  final fixed = value.toStringAsFixed(decimals);
  final normalized = fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  return normalized.replaceAll('.', ',');
}

void _showSnack(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red.shade700 : null,
    ),
  );
}
