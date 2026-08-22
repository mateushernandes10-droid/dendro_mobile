import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/providers/database_providers.dart';

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

  Stream<List<SpeciesRecord>> watchSpecies() {
    return (_database.select(
      _database.species,
    )..orderBy([(table) => OrderingTerm.asc(table.name)])).watch();
  }

  Stream<List<SpeciesFormulaRecord>> watchSpeciesFormulas() {
    return _database.select(_database.speciesFormulas).watch();
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

    await _database
        .into(_database.species)
        .insert(
          SpeciesCompanion.insert(
            id: id,
            name: name.trim(),
            scientificName: Value(_blankToNull(scientificName)),
            description: Value(_blankToNull(description)),
            active: Value(active),
            createdAt: now,
            updatedAt: now,
          ),
        );

    return id;
  }

  Future<void> updateSpecies({
    required String id,
    required String name,
    String? scientificName,
    String? description,
    required bool active,
  }) {
    return (_database.update(
      _database.species,
    )..where((table) => table.id.equals(id))).write(
      SpeciesCompanion(
        name: Value(name.trim()),
        scientificName: Value(_blankToNull(scientificName)),
        description: Value(_blankToNull(description)),
        active: Value(active),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteSpecies(String id) {
    return (_database.delete(
      _database.species,
    )..where((table) => table.id.equals(id))).go();
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

    await _database.transaction(() async {
      await _database
          .into(_database.formulas)
          .insert(
            FormulasCompanion.insert(
              id: id,
              name: name.trim(),
              description: Value(_blankToNull(description)),
              expression: expression.trim(),
              active: Value(active),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await _replaceVariables(id, variables);
      await _replaceCoefficientDefinitions(id, coefficientSymbols);
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
      await (_database.update(
        _database.formulas,
      )..where((table) => table.id.equals(id))).write(
        FormulasCompanion(
          name: Value(name.trim()),
          description: Value(_blankToNull(description)),
          expression: Value(expression.trim()),
          active: Value(active),
          updatedAt: Value(now),
        ),
      );

      await _replaceVariables(id, variables);
      await _replaceCoefficientDefinitions(id, coefficientSymbols);
    });
  }

  Future<void> deleteFormula(String id) {
    return (_database.delete(
      _database.formulas,
    )..where((table) => table.id.equals(id))).go();
  }

  Future<void> updateCoefficientValues({
    required String formulaId,
    required Map<String, double?> valuesByCoefficientId,
  }) {
    return _database.transaction(() async {
      for (final entry in valuesByCoefficientId.entries) {
        await (_database.update(_database.formulaCoefficients)
              ..where((table) => table.id.equals(entry.key)))
            .write(FormulaCoefficientsCompanion(value: Value(entry.value)));
      }

      await _touchFormula(formulaId);
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
  }

  Future<void> _touchFormula(String formulaId) {
    return (_database.update(_database.formulas)
          ..where((table) => table.id.equals(formulaId)))
        .write(FormulasCompanion(updatedAt: Value(DateTime.now())));
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
