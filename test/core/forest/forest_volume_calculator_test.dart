import 'package:dendro_mobile/core/forest/forest_volume_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fator de forma converte DAP de cm para m no calculo', () {
    expect(
      ForestVolumeCalculator.treeVolumeM3(
        dapCm: 20,
        heightM: 10,
        coefficients: const {'ff': 0.5},
        formulaId: ForestVolumeCalculator.formFactorFormulaId,
      ),
      closeTo(0.6283185307179586, 1e-12),
    );
    expect(
      ForestVolumeCalculator.treeVolumeM3(
        dapCm: 20,
        heightM: 10,
        coefficients: const {'ff': 0.25},
        formulaId: 'custom_factor',
        formulaExpression: 'pi * (dap / 100)^2 * h * ff',
      ),
      closeTo(0.3141592653589793, 1e-12),
    );
  });

  test('fator ausente ou invalido nao usa Spurr nem um fator padrao', () {
    for (final ff in [null, 0.0, -1.0, double.nan, double.infinity]) {
      expect(
        ForestVolumeCalculator.treeVolumeM3(
          dapCm: 20,
          heightM: 10,
          coefficients: {'ff': ff},
          formulaId: ForestVolumeCalculator.formFactorFormulaId,
        ),
        0,
      );
    }
  });

  test('calcula o volume de Spurr conforme inventario de referencia', () {
    const rows = [
      (dapCm: 28.0, heightM: 23.8),
      (dapCm: 25.0, heightM: 22.1),
      (dapCm: 23.0, heightM: 22.1),
      (dapCm: 32.0, heightM: 22.5),
      (dapCm: 33.0, heightM: 23.45),
      (dapCm: 41.0, heightM: 24.3),
      (dapCm: 22.0, heightM: 23.4),
      (dapCm: 15.0, heightM: 17.35),
      (dapCm: 22.0, heightM: 21.0),
      (dapCm: 23.5, heightM: 16.8),
      (dapCm: 26.0, heightM: 21.8),
      (dapCm: 21.0, heightM: 18.45),
      (dapCm: 33.5, heightM: 23.3),
    ];

    final total = rows.fold<double>(
      0,
      (sum, row) =>
          sum +
          ForestVolumeCalculator.treeVolumeM3(
            dapCm: row.dapCm,
            heightM: row.heightM,
            coefficients: const {
              'a': ForestVolumeCalculator.defaultSpurrA,
              'b': ForestVolumeCalculator.defaultSpurrB,
            },
            formulaId: 'formula_spurr',
            formulaExpression: 'a + b * (D^2 * H)',
          ),
    );

    expect(total, closeTo(7.38424, 0.00001));
  });

  test('usa as conversoes do inventario para Pinus e Eucalyptus', () {
    expect(
      ForestVolumeCalculator.conversionForSpecies('Pinus').convert(10),
      closeTo(9.367, 0.00001),
    );
    expect(
      ForestVolumeCalculator.conversionForSpecies('Eucalyptus').convert(10),
      closeTo(14, 0.00001),
    );
  });

  test('calcula Schumacher-Hall com os coeficientes ajustados do teste', () {
    const rows = [
      (dapCm: 28.0, heightM: 23.8),
      (dapCm: 25.0, heightM: 22.1),
      (dapCm: 23.0, heightM: 22.1),
      (dapCm: 32.0, heightM: 22.5),
      (dapCm: 33.0, heightM: 23.45),
      (dapCm: 41.0, heightM: 24.3),
      (dapCm: 22.0, heightM: 23.4),
      (dapCm: 15.0, heightM: 17.35),
      (dapCm: 22.0, heightM: 21.0),
      (dapCm: 23.5, heightM: 16.8),
      (dapCm: 26.0, heightM: 21.8),
      (dapCm: 21.0, heightM: 18.45),
      (dapCm: 33.5, heightM: 23.3),
    ];

    final total = rows.fold<double>(
      0,
      (sum, row) =>
          sum +
          ForestVolumeCalculator.treeVolumeM3(
            dapCm: row.dapCm,
            heightM: row.heightM,
            coefficients: const {},
            formulaId: 'formula_schumacher_hall',
            formulaExpression: 'exp(a + b * ln(D) + c * ln(H))',
          ),
    );

    expect(total, closeTo(7.34090, 0.00001));
  });
}
