import 'dart:math' as math;

class ResultadoSuficienciaAmostral {
  const ResultadoSuficienciaAmostral({
    required this.parcelasUtilizadas,
    required this.erroMaximoPercentual,
    required this.mediaVolumePorHaM3,
    required this.desvioPadraoVolumePorHaM3,
    required this.coeficienteVariacaoPercentual,
    required this.erroAmostralAtualPercentual,
    required this.parcelasEstimadas,
  });

  final int parcelasUtilizadas;
  final double erroMaximoPercentual;
  final double? mediaVolumePorHaM3;
  final double? desvioPadraoVolumePorHaM3;
  final double? coeficienteVariacaoPercentual;
  final double? erroAmostralAtualPercentual;
  final int? parcelasEstimadas;

  bool get calculavel =>
      erroAmostralAtualPercentual != null && parcelasEstimadas != null;

  bool get suficiente => calculavel && parcelasUtilizadas >= parcelasEstimadas!;

  int? get parcelasAdicionais {
    final estimadas = parcelasEstimadas;
    if (estimadas == null) return null;
    return math.max(0, estimadas - parcelasUtilizadas);
  }
}

class CalculadoraSuficienciaAmostral {
  const CalculadoraSuficienciaAmostral._();

  static const nivelConfiancaPercentual = 95.0;

  static ResultadoSuficienciaAmostral calcular({
    required List<double> volumesPorHaM3,
    required double erroMaximoPercentual,
    double? unidadesAmostraisPossiveis,
  }) {
    final valores = volumesPorHaM3
        .where((valor) => valor.isFinite && valor >= 0)
        .toList(growable: false);
    final erro = erroMaximoPercentual.isFinite && erroMaximoPercentual > 0
        ? erroMaximoPercentual
        : 3.0;

    if (valores.length < 2) {
      return ResultadoSuficienciaAmostral(
        parcelasUtilizadas: valores.length,
        erroMaximoPercentual: erro,
        mediaVolumePorHaM3: valores.isEmpty ? null : valores.single,
        desvioPadraoVolumePorHaM3: null,
        coeficienteVariacaoPercentual: null,
        erroAmostralAtualPercentual: null,
        parcelasEstimadas: null,
      );
    }

    final media = valores.reduce((a, b) => a + b) / valores.length;
    final somaQuadrados = valores.fold<double>(
      0,
      (total, valor) => total + math.pow(valor - media, 2).toDouble(),
    );
    final variancia = somaQuadrados / (valores.length - 1);
    final desvioPadrao = math.sqrt(variancia);

    if (media <= 0) {
      return ResultadoSuficienciaAmostral(
        parcelasUtilizadas: valores.length,
        erroMaximoPercentual: erro,
        mediaVolumePorHaM3: media,
        desvioPadraoVolumePorHaM3: desvioPadrao,
        coeficienteVariacaoPercentual: null,
        erroAmostralAtualPercentual: null,
        parcelasEstimadas: null,
      );
    }

    final cv = desvioPadrao / media * 100;
    final populacao = _populacaoValida(unidadesAmostraisPossiveis);
    final correcaoAtual = _correcaoPopulacaoFinita(
      amostras: valores.length,
      populacao: populacao,
    );
    final tAtual = _tCritico95(valores.length - 1);
    final erroAtual = tAtual * cv / math.sqrt(valores.length) * correcaoAtual;
    final parcelasEstimadas = _estimarParcelas(
      coeficienteVariacaoPercentual: cv,
      erroMaximoPercentual: erro,
      populacao: populacao,
      quantidadeAtual: valores.length,
    );

    return ResultadoSuficienciaAmostral(
      parcelasUtilizadas: valores.length,
      erroMaximoPercentual: erro,
      mediaVolumePorHaM3: media,
      desvioPadraoVolumePorHaM3: desvioPadrao,
      coeficienteVariacaoPercentual: cv,
      erroAmostralAtualPercentual: erroAtual,
      parcelasEstimadas: parcelasEstimadas,
    );
  }

  static int _estimarParcelas({
    required double coeficienteVariacaoPercentual,
    required double erroMaximoPercentual,
    required double? populacao,
    required int quantidadeAtual,
  }) {
    if (coeficienteVariacaoPercentual == 0) return 2;

    var estimativa = math.max(2, quantidadeAtual);
    int? estimativaAnterior;
    for (var tentativa = 0; tentativa < 30; tentativa++) {
      final t = _tCritico95(math.max(1, estimativa - 1));
      final infinita =
          math.pow(t * coeficienteVariacaoPercentual, 2) /
          math.pow(erroMaximoPercentual, 2);
      final calculada = populacao == null
          ? infinita
          : (populacao * infinita) / (populacao + infinita - 1);
      final proxima = math.max(
        2,
        populacao == null
            ? calculada.ceil()
            : math.min(populacao.floor(), calculada.ceil()),
      );
      if (proxima == estimativa) return proxima;
      if (proxima == estimativaAnterior) {
        return math.max(proxima, estimativa);
      }
      estimativaAnterior = estimativa;
      estimativa = proxima;
    }
    return estimativa;
  }

  static double? _populacaoValida(double? populacao) {
    if (populacao == null || !populacao.isFinite || populacao < 2) return null;
    return populacao;
  }

  static double _correcaoPopulacaoFinita({
    required int amostras,
    required double? populacao,
  }) {
    if (populacao == null || amostras >= populacao) {
      return populacao == null ? 1 : 0;
    }
    return math.sqrt((populacao - amostras) / (populacao - 1));
  }

  // Valores bicaudais para 95% de confiança. Para graus de liberdade não
  // listados, usa-se o menor grau disponível, mantendo a estimativa conservadora.
  static double _tCritico95(int grausLiberdade) {
    const tabela = <int, double>{
      1: 12.706,
      2: 4.303,
      3: 3.182,
      4: 2.776,
      5: 2.571,
      6: 2.447,
      7: 2.365,
      8: 2.306,
      9: 2.262,
      10: 2.228,
      11: 2.201,
      12: 2.179,
      13: 2.160,
      14: 2.145,
      15: 2.131,
      16: 2.120,
      17: 2.110,
      18: 2.101,
      19: 2.093,
      20: 2.086,
      21: 2.080,
      22: 2.074,
      23: 2.069,
      24: 2.064,
      25: 2.060,
      26: 2.056,
      27: 2.052,
      28: 2.048,
      29: 2.045,
      30: 2.042,
      40: 2.021,
      60: 2.000,
      120: 1.980,
      200: 1.972,
      500: 1.965,
      1000: 1.962,
      1000000: 1.960,
    };
    if (grausLiberdade > 1000000) return 1.960;
    var critico = tabela.values.first;
    for (final entrada in tabela.entries) {
      if (entrada.key > grausLiberdade) break;
      critico = entrada.value;
    }
    return critico;
  }
}
