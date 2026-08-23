import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/forest/forest_volume_calculator.dart';
import '../../../core/providers/database_providers.dart';
import '../../activity_log/data/activity_log_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(dendroDatabaseProvider));
});

final settingsSpeciesProvider = StreamProvider.autoDispose<List<SpeciesRecord>>(
  (ref) {
    return ref.watch(settingsRepositoryProvider).watchSpecies();
  },
);

final settingsFormulasProvider =
    StreamProvider.autoDispose<List<FormulaSummary>>((ref) {
      return ref.watch(settingsRepositoryProvider).watchFormulas();
    });

final settingsSpeciesFormulasProvider =
    StreamProvider.autoDispose<List<SpeciesFormulaRecord>>((ref) {
      return ref.watch(settingsRepositoryProvider).watchSpeciesFormulas();
    });

final settingsSpeciesFormulaCoefficientsProvider =
    StreamProvider.autoDispose<List<SpeciesFormulaCoefficientRecord>>((ref) {
      return ref
          .watch(settingsRepositoryProvider)
          .watchSpeciesFormulaCoefficients();
    });

class FormulaSummary {
  const FormulaSummary({
    required this.formula,
    required this.variables,
    required this.coefficients,
  });

  final FormulaRecord formula;
  final List<FormulaVariableRecord> variables;
  final List<FormulaCoefficientRecord> coefficients;
}

class FormulaVariableDraft {
  const FormulaVariableDraft({
    required this.symbol,
    required this.label,
    required this.unit,
    required this.valueSource,
    required this.variableKey,
  });

  final String symbol;
  final String label;
  final String unit;
  final String valueSource;
  final FormulaVariableKey variableKey;
}

class SettingsRepository {
  SettingsRepository(this._database);

  final DendroDatabase _database;
  final _uuid = const Uuid();
  late final ActivityLogRepository _activityLog = ActivityLogRepository(
    _database,
  );

  Stream<List<SpeciesRecord>> watchSpecies() {
    return (_database.select(
      _database.species,
    )..orderBy([(table) => OrderingTerm.asc(table.name)])).watch();
  }

  Stream<List<SpeciesFormulaRecord>> watchSpeciesFormulas() {
    return _database.select(_database.speciesFormulas).watch();
  }

  Stream<List<SpeciesFormulaCoefficientRecord>>
  watchSpeciesFormulaCoefficients() {
    return (_database.select(_database.speciesFormulaCoefficients)..orderBy([
          (table) => OrderingTerm.asc(table.speciesId),
          (table) => OrderingTerm.asc(table.formulaId),
          (table) => OrderingTerm.asc(table.symbol),
        ]))
        .watch();
  }

  Stream<List<FormulaSummary>> watchFormulas() {
    final query = _database.select(_database.formulas)
      ..orderBy([(table) => OrderingTerm.asc(table.name)]);

    return query.watch().asyncMap((formulas) async {
      final summaries = <FormulaSummary>[];

      for (final formula in formulas) {
        summaries.add(
          FormulaSummary(
            formula: formula,
            variables: await _variablesForFormula(formula.id),
            coefficients: await _coefficientsForFormula(formula.id),
          ),
        );
      }

      return summaries;
    });
  }

  Future<String> createSpecies({
    required String name,
    String? scientificName,
    String? description,
    bool active = true,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final speciesName = name.trim();

    await _database.transaction(() async {
      await _database
          .into(_database.species)
          .insert(
            SpeciesCompanion.insert(
              id: id,
              name: speciesName,
              scientificName: Value(_blankToNull(scientificName)),
              description: Value(_blankToNull(description)),
              active: Value(active),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await _activityLog.record(
        type: ActivityLogType.speciesCreated,
        title: 'Especie cadastrada',
        subtitle: speciesName,
        entityType: ActivityEntityType.species,
        entityId: id,
        occurredAt: now,
      );
    });

    return id;
  }

  Future<void> updateSpecies({
    required String id,
    required String name,
    String? scientificName,
    String? description,
    required bool active,
  }) {
    final now = DateTime.now();
    final speciesName = name.trim();

    return _database.transaction(() async {
      await (_database.update(
        _database.species,
      )..where((table) => table.id.equals(id))).write(
        SpeciesCompanion(
          name: Value(speciesName),
          scientificName: Value(_blankToNull(scientificName)),
          description: Value(_blankToNull(description)),
          active: Value(active),
          updatedAt: Value(now),
        ),
      );

      await _activityLog.record(
        type: ActivityLogType.speciesUpdated,
        title: 'Especie atualizada',
        subtitle: speciesName,
        entityType: ActivityEntityType.species,
        entityId: id,
        occurredAt: now,
      );
    });
  }

  Future<void> deleteSpecies(String id) async {
    final species = await _speciesById(id);

    await _database.transaction(() async {
      await (_database.delete(
        _database.species,
      )..where((table) => table.id.equals(id))).go();

      if (species == null) return;
      await _activityLog.record(
        type: ActivityLogType.speciesDeleted,
        title: 'Especie excluida',
        subtitle: species.name,
        entityType: ActivityEntityType.species,
        entityId: id,
      );
    });
  }

  Future<String> createFormula({
    required String name,
    String? description,
    required String expression,
    required List<FormulaVariableDraft> variables,
    required List<String> coefficientSymbols,
    bool active = true,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final formulaName = name.trim();

    await _database.transaction(() async {
      await _database
          .into(_database.formulas)
          .insert(
            FormulasCompanion.insert(
              id: id,
              name: formulaName,
              description: Value(_blankToNull(description)),
              expression: expression.trim(),
              active: Value(active),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await _replaceVariables(id, variables);
      await _replaceCoefficientDefinitions(id, coefficientSymbols);

      await _activityLog.record(
        type: ActivityLogType.formulaCreated,
        title: 'Modelo matematico cadastrado',
        subtitle: formulaName,
        entityType: ActivityEntityType.formula,
        entityId: id,
        occurredAt: now,
      );
    });

    return id;
  }

  Future<void> updateFormula({
    required String id,
    required String name,
    String? description,
    required String expression,
    required List<FormulaVariableDraft> variables,
    required List<String> coefficientSymbols,
    required bool active,
  }) {
    return _database.transaction(() async {
      final now = DateTime.now();
      final formulaName = name.trim();
      await (_database.update(
        _database.formulas,
      )..where((table) => table.id.equals(id))).write(
        FormulasCompanion(
          name: Value(formulaName),
          description: Value(_blankToNull(description)),
          expression: Value(expression.trim()),
          active: Value(active),
          updatedAt: Value(now),
        ),
      );

      await _replaceVariables(id, variables);
      await _replaceCoefficientDefinitions(id, coefficientSymbols);

      await _activityLog.record(
        type: ActivityLogType.formulaUpdated,
        title: 'Modelo matematico atualizado',
        subtitle: formulaName,
        entityType: ActivityEntityType.formula,
        entityId: id,
        occurredAt: now,
      );
    });
  }

  Future<void> deleteFormula(String id) async {
    final formula = await _formulaById(id);

    await _database.transaction(() async {
      await (_database.delete(
        _database.formulas,
      )..where((table) => table.id.equals(id))).go();

      if (formula == null) return;
      await _activityLog.record(
        type: ActivityLogType.formulaDeleted,
        title: 'Modelo matematico excluido',
        subtitle: formula.name,
        entityType: ActivityEntityType.formula,
        entityId: id,
      );
    });
  }

  Future<void> updateCoefficientValues({
    required String formulaId,
    required Map<String, double?> valuesByCoefficientId,
  }) {
    return _database.transaction(() async {
      final formula = await _formulaById(formulaId);
      final now = DateTime.now();
      for (final entry in valuesByCoefficientId.entries) {
        await (_database.update(_database.formulaCoefficients)
              ..where((table) => table.id.equals(entry.key)))
            .write(FormulaCoefficientsCompanion(value: Value(entry.value)));
      }

      await _touchFormula(formulaId);

      await _activityLog.record(
        type: ActivityLogType.formulaCoefficientsUpdated,
        title: 'Coeficientes atualizados',
        subtitle: formula?.name ?? 'Modelo matematico',
        entityType: ActivityEntityType.formula,
        entityId: formulaId,
        occurredAt: now,
      );
    });
  }

  Future<void> updateSpeciesFormulaCoefficientValues({
    required String speciesId,
    required String formulaId,
    required Map<String, double?> valuesBySymbol,
  }) {
    return _database.transaction(() async {
      await _ensureSpeciesFormulaCoefficientRows(
        speciesId: speciesId,
        formulaId: formulaId,
      );

      final now = DateTime.now();
      final formula = await _formulaById(formulaId);

      for (final entry in valuesBySymbol.entries) {
        await (_database.update(_database.speciesFormulaCoefficients)..where(
              (table) =>
                  table.speciesId.equals(speciesId) &
                  table.formulaId.equals(formulaId) &
                  table.symbol.equals(entry.key),
            ))
            .write(
              SpeciesFormulaCoefficientsCompanion(
                value: Value(entry.value),
                updatedAt: Value(now),
              ),
            );
      }

      await _activityLog.record(
        type: ActivityLogType.formulaCoefficientsUpdated,
        title: 'Coeficientes da especie atualizados',
        subtitle: await _speciesFormulaSubtitle(speciesId, formulaId),
        entityType: ActivityEntityType.formula,
        entityId: formula?.id ?? formulaId,
        occurredAt: now,
      );
    });
  }

  Future<void> setSpeciesFormulaLinked({
    required String speciesId,
    required String formulaId,
    required bool linked,
  }) {
    return _database.transaction(() async {
      final existing = await _findSpeciesFormula(
        speciesId: speciesId,
        formulaId: formulaId,
      );

      if (linked) {
        await _ensureSpeciesFormulaLinked(
          speciesId: speciesId,
          formulaId: formulaId,
        );
        await _ensureSpeciesFormulaCoefficientRows(
          speciesId: speciesId,
          formulaId: formulaId,
        );
        if (existing == null) {
          await _activityLog.record(
            type: ActivityLogType.speciesFormulaLinked,
            title: 'Modelo vinculado a especie',
            subtitle: await _speciesFormulaSubtitle(speciesId, formulaId),
            entityType: ActivityEntityType.species,
            entityId: speciesId,
          );
        }
        return;
      }

      if (existing == null) return;

      await (_database.delete(_database.speciesFormulas)..where(
            (table) =>
                table.speciesId.equals(speciesId) &
                table.formulaId.equals(formulaId),
          ))
          .go();

      if (existing.isDefault) {
        await _ensureSpeciesHasDefaultFormula(speciesId);
      }

      await _activityLog.record(
        type: ActivityLogType.speciesFormulaUnlinked,
        title: 'Modelo removido da especie',
        subtitle: await _speciesFormulaSubtitle(speciesId, formulaId),
        entityType: ActivityEntityType.species,
        entityId: speciesId,
      );
    });
  }

  Future<void> setDefaultFormulaForSpecies({
    required String speciesId,
    required String formulaId,
  }) {
    return _database.transaction(() async {
      await _ensureSpeciesFormulaLinked(
        speciesId: speciesId,
        formulaId: formulaId,
      );

      await (_database.update(_database.speciesFormulas)
            ..where((table) => table.speciesId.equals(speciesId)))
          .write(const SpeciesFormulasCompanion(isDefault: Value(false)));

      await (_database.update(_database.speciesFormulas)..where(
            (table) =>
                table.speciesId.equals(speciesId) &
                table.formulaId.equals(formulaId),
          ))
          .write(const SpeciesFormulasCompanion(isDefault: Value(true)));

      await _activityLog.record(
        type: ActivityLogType.speciesDefaultFormulaChanged,
        title: 'Modelo padrao alterado',
        subtitle: await _speciesFormulaSubtitle(speciesId, formulaId),
        entityType: ActivityEntityType.species,
        entityId: speciesId,
      );
    });
  }

  Future<List<FormulaVariableRecord>> _variablesForFormula(String formulaId) {
    return (_database.select(_database.formulaVariables)
          ..where((table) => table.formulaId.equals(formulaId))
          ..orderBy([(table) => OrderingTerm.asc(table.symbol)]))
        .get();
  }

  Future<List<FormulaCoefficientRecord>> _coefficientsForFormula(
    String formulaId,
  ) {
    return (_database.select(_database.formulaCoefficients)
          ..where((table) => table.formulaId.equals(formulaId))
          ..orderBy([(table) => OrderingTerm.asc(table.symbol)]))
        .get();
  }

  Future<void> _replaceVariables(
    String formulaId,
    List<FormulaVariableDraft> variables,
  ) async {
    await (_database.delete(
      _database.formulaVariables,
    )..where((table) => table.formulaId.equals(formulaId))).go();

    for (final variable in variables) {
      await _database
          .into(_database.formulaVariables)
          .insert(
            FormulaVariablesCompanion.insert(
              id: _uuid.v4(),
              formulaId: formulaId,
              symbol: variable.symbol.trim(),
              label: variable.label.trim(),
              unit: variable.unit.trim(),
              valueSource: variable.valueSource.trim(),
              variableKey: variable.variableKey,
            ),
          );
    }
  }

  Future<void> _replaceCoefficientDefinitions(
    String formulaId,
    List<String> symbols,
  ) async {
    final normalizedSymbols = _normalizeSymbols(symbols);
    final existing = await _coefficientsForFormula(formulaId);
    final existingBySymbol = {
      for (final coefficient in existing) coefficient.symbol: coefficient,
    };

    for (final coefficient in existing) {
      if (!normalizedSymbols.contains(coefficient.symbol)) {
        await (_database.delete(
          _database.formulaCoefficients,
        )..where((table) => table.id.equals(coefficient.id))).go();
      }
    }

    for (final symbol in normalizedSymbols) {
      final existingCoefficient = existingBySymbol[symbol];
      if (existingCoefficient == null) {
        await _database
            .into(_database.formulaCoefficients)
            .insert(
              FormulaCoefficientsCompanion.insert(
                id: _uuid.v4(),
                formulaId: formulaId,
                symbol: symbol,
                label: 'Coeficiente $symbol',
              ),
            );
      } else {
        await (_database.update(
          _database.formulaCoefficients,
        )..where((table) => table.id.equals(existingCoefficient.id))).write(
          FormulaCoefficientsCompanion(label: Value('Coeficiente $symbol')),
        );
      }
    }

    await _syncSpeciesFormulaCoefficientsForFormula(formulaId);
  }

  Future<void> _touchFormula(String formulaId) {
    return (_database.update(_database.formulas)
          ..where((table) => table.id.equals(formulaId)))
        .write(FormulasCompanion(updatedAt: Value(DateTime.now())));
  }

  Future<SpeciesRecord?> _speciesById(String id) {
    return (_database.select(
      _database.species,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<FormulaRecord?> _formulaById(String id) {
    return (_database.select(
      _database.formulas,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<String> _speciesFormulaSubtitle(
    String speciesId,
    String formulaId,
  ) async {
    final species = await _speciesById(speciesId);
    final formula = await _formulaById(formulaId);

    return '${formula?.name ?? 'Modelo'} - ${species?.name ?? 'Especie'}';
  }

  Future<bool> _speciesHasDefaultFormula(String speciesId) async {
    final row =
        await (_database.select(_database.speciesFormulas)
              ..where(
                (table) =>
                    table.speciesId.equals(speciesId) &
                    table.isDefault.equals(true),
              )
              ..limit(1))
            .getSingleOrNull();

    return row != null;
  }

  Future<SpeciesFormulaRecord?> _findSpeciesFormula({
    required String speciesId,
    required String formulaId,
  }) {
    return (_database.select(_database.speciesFormulas)
          ..where(
            (table) =>
                table.speciesId.equals(speciesId) &
                table.formulaId.equals(formulaId),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> _ensureSpeciesFormulaLinked({
    required String speciesId,
    required String formulaId,
  }) async {
    final existing = await _findSpeciesFormula(
      speciesId: speciesId,
      formulaId: formulaId,
    );
    if (existing != null) return;

    final hasDefault = await _speciesHasDefaultFormula(speciesId);
    await _database
        .into(_database.speciesFormulas)
        .insert(
          SpeciesFormulasCompanion.insert(
            speciesId: speciesId,
            formulaId: formulaId,
            isDefault: Value(!hasDefault),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> _syncSpeciesFormulaCoefficientsForFormula(
    String formulaId,
  ) async {
    final definitions = await _coefficientsForFormula(formulaId);
    final definitionSymbols = definitions.map((item) => item.symbol).toSet();
    final existing = await (_database.select(
      _database.speciesFormulaCoefficients,
    )..where((table) => table.formulaId.equals(formulaId))).get();

    for (final coefficient in existing) {
      if (!definitionSymbols.contains(coefficient.symbol)) {
        await (_database.delete(
          _database.speciesFormulaCoefficients,
        )..where((table) => table.id.equals(coefficient.id))).go();
      }
    }

    final links = await (_database.select(
      _database.speciesFormulas,
    )..where((table) => table.formulaId.equals(formulaId))).get();

    for (final link in links) {
      await _ensureSpeciesFormulaCoefficientRows(
        speciesId: link.speciesId,
        formulaId: formulaId,
        definitions: definitions,
      );
    }
  }

  Future<void> _ensureSpeciesFormulaCoefficientRows({
    required String speciesId,
    required String formulaId,
    List<FormulaCoefficientRecord>? definitions,
  }) async {
    final coefficientDefinitions =
        definitions ?? await _coefficientsForFormula(formulaId);
    final existing =
        await (_database.select(_database.speciesFormulaCoefficients)..where(
              (table) =>
                  table.speciesId.equals(speciesId) &
                  table.formulaId.equals(formulaId),
            ))
            .get();
    final existingBySymbol = {
      for (final coefficient in existing) coefficient.symbol: coefficient,
    };
    final definitionSymbols = coefficientDefinitions
        .map((item) => item.symbol)
        .toSet();
    final now = DateTime.now();

    for (final coefficient in existing) {
      if (!definitionSymbols.contains(coefficient.symbol)) {
        await (_database.delete(
          _database.speciesFormulaCoefficients,
        )..where((table) => table.id.equals(coefficient.id))).go();
      }
    }

    for (final definition in coefficientDefinitions) {
      final existing = existingBySymbol[definition.symbol];
      final defaultValue =
          definition.value ??
          ForestVolumeCalculator.defaultCoefficientValue(
            formulaId: formulaId,
            symbol: definition.symbol,
          );

      if (existing == null) {
        await _database
            .into(_database.speciesFormulaCoefficients)
            .insert(
              SpeciesFormulaCoefficientsCompanion.insert(
                id: _speciesFormulaCoefficientId(
                  speciesId,
                  formulaId,
                  definition.symbol,
                ),
                speciesId: speciesId,
                formulaId: formulaId,
                symbol: definition.symbol,
                label: definition.label,
                value: Value(defaultValue),
                updatedAt: now,
              ),
            );
      } else {
        await (_database.update(
          _database.speciesFormulaCoefficients,
        )..where((table) => table.id.equals(existing.id))).write(
          SpeciesFormulaCoefficientsCompanion(
            label: Value(definition.label),
            value: existing.value == null
                ? Value(defaultValue)
                : const Value.absent(),
            updatedAt: Value(now),
          ),
        );
      }
    }
  }

  Future<void> _ensureSpeciesHasDefaultFormula(String speciesId) async {
    final formulas =
        await (_database.select(_database.speciesFormulas)
              ..where((table) => table.speciesId.equals(speciesId))
              ..limit(1))
            .get();

    if (formulas.isEmpty) return;

    await (_database.update(_database.speciesFormulas)..where(
          (table) =>
              table.speciesId.equals(speciesId) &
              table.formulaId.equals(formulas.first.formulaId),
        ))
        .write(const SpeciesFormulasCompanion(isDefault: Value(true)));
  }
}

String _speciesFormulaCoefficientId(
  String speciesId,
  String formulaId,
  String symbol,
) {
  return '${speciesId}_${formulaId}_$symbol';
}

List<String> _normalizeSymbols(List<String> symbols) {
  final normalized = <String>[];

  for (final symbol in symbols) {
    final trimmed = symbol.trim();
    if (trimmed.isEmpty || normalized.contains(trimmed)) continue;
    normalized.add(trimmed);
  }

  return normalized;
}

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}
