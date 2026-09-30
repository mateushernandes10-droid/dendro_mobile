import 'package:dendro_mobile/nucleo/floresta/calculadora_volume_florestal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fator de forma usa area basal com DAP convertido para metros', () {
    expect(
      CalculadoraVolumeFlorestal.volumeArvoreM3(
        dapCm: 20,
        alturaM: 10,
        coeficientes: const {'ff': 0.5},
        modeloMatematicoCodigo:
            CalculadoraVolumeFlorestal.codigoModeloFatorForma,
      ),
      closeTo(0.15707963267948966, 1e-12),
    );
    expect(
      CalculadoraVolumeFlorestal.volumeArvoreM3(
        dapCm: 20,
        alturaM: 10,
        coeficientes: const {'ff': 0.25},
        modeloMatematicoCodigo: 'custom_factor',
        modeloMatematicoExpressao: '(pi / 4) * (dap / 100)^2 * h * ff',
      ),
      closeTo(0.07853981633974483, 1e-12),
    );
  });

  test('fator ausente ou invalido nao usa Spurr nem um fator padrao', () {
    for (final ff in [null, 0.0, -1.0, double.nan, double.infinity]) {
      expect(
        CalculadoraVolumeFlorestal.volumeArvoreM3(
          dapCm: 20,
          alturaM: 10,
          coeficientes: {'ff': ff},
          modeloMatematicoCodigo:
              CalculadoraVolumeFlorestal.codigoModeloFatorForma,
        ),
        0,
      );
    }
  });

  test('calcula o volume de Spurr conforme inventario de referencia', () {
    const linhas = [
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

    final total = linhas.fold<double>(
      0,
      (soma, linha) =>
          soma +
          CalculadoraVolumeFlorestal.volumeArvoreM3(
            dapCm: linha.dapCm,
            alturaM: linha.heightM,
            coeficientes: const {
              'a': CalculadoraVolumeFlorestal.padraoSpurrA,
              'b': CalculadoraVolumeFlorestal.padraoSpurrB,
            },
            modeloMatematicoCodigo: 'formula_spurr',
            modeloMatematicoExpressao: 'a + b * (D^2 * H)',
          ),
    );

    expect(total, closeTo(7.38424, 0.00001));
  });

  test('usa as conversoes do inventario para Pinus e Eucalyptus', () {
    expect(
      CalculadoraVolumeFlorestal.conversaoParaEspecie('Pinus').converter(10),
      closeTo(9.367, 0.00001),
    );
    expect(
      CalculadoraVolumeFlorestal.conversaoParaEspecie(
        'Eucalyptus',
      ).converter(10),
      closeTo(14, 0.00001),
    );
  });

  test('calcula Schumacher-Hall com os coeficientes ajustados do teste', () {
    const linhas = [
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

    final total = linhas.fold<double>(
      0,
      (soma, linha) =>
          soma +
          CalculadoraVolumeFlorestal.volumeArvoreM3(
            dapCm: linha.dapCm,
            alturaM: linha.heightM,
            coeficientes: const {},
            modeloMatematicoCodigo: 'formula_schumacher_hall',
            modeloMatematicoExpressao: 'exp(a + b * ln(D) + c * ln(H))',
          ),
    );

    expect(total, closeTo(7.34090, 0.00001));
  });
}
