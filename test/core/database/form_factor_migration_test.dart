import 'dart:io';

import 'package:dendro_mobile/core/database/dendro_database.dart';
import 'package:dendro_mobile/core/forest/forest_volume_calculator.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('atualiza banco v7 preservando coeficientes e modelo padrao', () async {
    final directory = await Directory.systemTemp.createTemp('dendro_ff_test_');
    final file = File('${directory.path}/test.sqlite');
    var database = DendroDatabase(NativeDatabase(file));
    try {
      await database.select(database.formulas).get();
      const id = ForestVolumeCalculator.formFactorFormulaId;
      // Reproduce the v7 catalog. No table structure changed in v8.
      for (final table in [
        'species_formula_coefficients',
        'species_formulas',
        'formula_variables',
        'formula_coefficients',
      ]) {
        await database.customStatement(
          'DELETE FROM $table WHERE formula_id = ?',
          [id],
        );
      }
      await (database.delete(
        database.formulas,
      )..where((t) => t.id.equals(id))).go();
      await (database.update(database.formulaCoefficients)
            ..where((t) => t.id.equals('formula_spurr_a')))
          .write(const FormulaCoefficientsCompanion(value: Value(0.123)));
      await database.customStatement('PRAGMA user_version = 7');
      await database.close();
      database = DendroDatabase(NativeDatabase(file));

      final formulas = await database.select(database.formulas).get();
      expect(formulas.where((f) => f.id == id), hasLength(1));
      final coefficients = await database
          .select(database.formulaCoefficients)
          .get();
      expect(
        coefficients.singleWhere((c) => c.id == 'formula_spurr_a').value,
        0.123,
      );
      expect(coefficients.singleWhere((c) => c.formulaId == id).value, isNull);
      final links = await database.select(database.speciesFormulas).get();
      expect(links.where((l) => l.formulaId == id), hasLength(2));
      expect(
        links
            .where((l) => l.isDefault)
            .every((l) => l.formulaId == 'formula_spurr'),
        isTrue,
      );

      await (database.update(database.speciesFormulaCoefficients)..where(
            (t) => t.formulaId.equals(id) & t.speciesId.equals('species_pinus'),
          ))
          .write(const SpeciesFormulaCoefficientsCompanion(value: Value(0.42)));
      await database.close();
      database = DendroDatabase(NativeDatabase(file));
      final saved =
          await (database.select(database.speciesFormulaCoefficients)..where(
                (t) =>
                    t.formulaId.equals(id) &
                    t.speciesId.equals('species_pinus'),
              ))
              .getSingle();
      expect(saved.value, 0.42);

      // Simulate the v8 model already configured by the user.
      await (database.update(
        database.formulas,
      )..where((t) => t.id.equals(id))).write(
        const FormulasCompanion(
          name: Value('Calcular Volume - Fator de Fórmula'),
          expression: Value('pi * D^2 * H * ff'),
        ),
      );
      await (database.update(
        database.speciesFormulaCoefficients,
      )..where((t) => t.formulaId.equals(id))).write(
        const SpeciesFormulaCoefficientsCompanion(
          label: Value('Fator de fórmula'),
        ),
      );
      await database.customStatement('PRAGMA user_version = 8');
      await database.close();
      database = DendroDatabase(NativeDatabase(file));
      final updated = await (database.select(
        database.formulas,
      )..where((t) => t.id.equals(id))).getSingle();
      expect(updated.name, 'Fator de Forma');
      expect(updated.expression, 'pi * (D / 100)^2 * H * ff');
      final preserved =
          await (database.select(database.speciesFormulaCoefficients)..where(
                (t) =>
                    t.formulaId.equals(id) &
                    t.speciesId.equals('species_pinus'),
              ))
              .getSingle();
      expect(preserved.value, 0.42);
      expect(preserved.label, 'Fator de forma');
    } finally {
      await database.close();
      await directory.delete(recursive: true);
    }
  });
}
