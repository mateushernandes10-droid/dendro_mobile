import 'package:dendro_mobile/core/forest/forest_volume_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
