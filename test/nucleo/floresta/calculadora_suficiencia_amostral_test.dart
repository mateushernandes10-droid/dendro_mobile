import 'package:dendro_mobile/nucleo/floresta/calculadora_suficiencia_amostral.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalculadoraSuficienciaAmostral', () {
    test('exige ao menos duas parcelas válidas', () {
      final resultado = CalculadoraSuficienciaAmostral.calcular(
        volumesPorHaM3: const [300],
        erroMaximoPercentual: 3,
      );

      expect(resultado.calculavel, isFalse);
      expect(resultado.suficiente, isFalse);
      expect(resultado.parcelasEstimadas, isNull);
    });

    test('calcula média, CV, erro atual e parcelas estimadas', () {
      final resultado = CalculadoraSuficienciaAmostral.calcular(
        volumesPorHaM3: const [90, 100, 110],
        erroMaximoPercentual: 10,
      );

      expect(resultado.mediaVolumePorHaM3, closeTo(100, 0.0001));
      expect(resultado.desvioPadraoVolumePorHaM3, closeTo(10, 0.0001));
      expect(resultado.coeficienteVariacaoPercentual, closeTo(10, 0.0001));
      expect(resultado.erroAmostralAtualPercentual, closeTo(24.843, 0.01));
      expect(resultado.parcelasEstimadas, 7);
      expect(resultado.parcelasAdicionais, 4);
      expect(resultado.suficiente, isFalse);
    });

    test('aplica correção para população finita', () {
      final infinita = CalculadoraSuficienciaAmostral.calcular(
        volumesPorHaM3: const [90, 100, 110],
        erroMaximoPercentual: 3,
      );
      final finita = CalculadoraSuficienciaAmostral.calcular(
        volumesPorHaM3: const [90, 100, 110],
        erroMaximoPercentual: 3,
        unidadesAmostraisPossiveis: 20,
      );

      expect(finita.parcelasEstimadas!, lessThan(infinita.parcelasEstimadas!));
      expect(finita.parcelasEstimadas, lessThanOrEqualTo(20));
    });

    test('considera suficiente uma amostra sem variação', () {
      final resultado = CalculadoraSuficienciaAmostral.calcular(
        volumesPorHaM3: const [100, 100],
        erroMaximoPercentual: 3,
      );

      expect(resultado.erroAmostralAtualPercentual, 0);
      expect(resultado.parcelasEstimadas, 2);
      expect(resultado.parcelasAdicionais, 0);
      expect(resultado.suficiente, isTrue);
    });
  });
}
