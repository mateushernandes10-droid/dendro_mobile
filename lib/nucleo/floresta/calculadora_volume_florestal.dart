import 'dart:math' as math;

class CalculadoraVolumeFlorestal {
  const CalculadoraVolumeFlorestal._();

  static const modeloFatorFormaId = 'formula_form_factor';
  static const expressaoFatorForma = 'pi * (D / 100)^2 * H * ff';

  static const padraoAlturaIntercepto = 0.8203;
  static const padraoAlturaInclinacao = 6.4229;
  static const padraoSpurrA = 0.0175858265880592;
  static const padraoSpurrB = 0.0000329326161133665;
  static const padraoSchumacherHallA = -11.584059201173265;
  static const padraoSchumacherHallB = 1.8114471288118603;
  static const padraoSchumacherHallC = 1.6187968875426328;
  static const pinusTonPorM3 = 0.9367;
  static const eucalyptusMstPorM3 = 1.4;

  static double estimarAlturaM(double dapCm) {
    if (dapCm <= 0) return 0;
    return padraoAlturaInclinacao * math.log(dapCm) + padraoAlturaIntercepto;
  }

  static double volumeArvoreM3({
    required double dapCm,
    required double alturaM,
    required Map<String, double?> coeficientes,
    String? modeloMatematicoId,
    String? modeloMatematicoExpressao,
  }) {
    final resolvidoAlturaM = alturaM > 0 ? alturaM : estimarAlturaM(dapCm);
    if (dapCm <= 0 || resolvidoAlturaM <= 0) return 0;

    final normalizadoModeloMatematicoId = modeloMatematicoId?.toLowerCase() ?? '';
    final normalizadoExpressao = _normalizar(modeloMatematicoExpressao ?? '');

    if (normalizadoModeloMatematicoId == modeloFatorFormaId ||
        normalizadoExpressao.replaceAll('dap', 'd').replaceAll('π', 'pi') ==
            _normalizar(expressaoFatorForma)) {
      final ff = coeficientes['ff'] ?? coeficientes['FF'];
      if (ff == null || !ff.isFinite || ff <= 0) return 0;
      final dapM = dapCm / 100;
      final volume = math.pi * dapM * dapM * resolvidoAlturaM * ff;
      return volume.isFinite && volume >= 0 ? volume : 0;
    }

    final volume =
        normalizadoModeloMatematicoId.contains('schumacher') ||
            normalizadoExpressao.startsWith('exp(')
        ? _volumeSchumacherHall(
            dapCm: dapCm,
            alturaM: resolvidoAlturaM,
            coeficientes: coeficientes,
          )
        : _volumeSpurr(
            dapCm: dapCm,
            alturaM: resolvidoAlturaM,
            coeficientes: coeficientes,
          );

    if (volume.isNaN || volume.isInfinite || volume < 0) return 0;
    return volume;
  }

  static ConversaoVolumeMadeira conversaoParaEspecie(String especieNome) {
    final normalizado = _normalizar(especieNome);
    if (normalizado.contains('pinus') || normalizado.contains('pinnus')) {
      return const ConversaoVolumeMadeira(
        unidade: 'ton',
        fator: pinusTonPorM3,
        rotulo: 'toneladas',
      );
    }
    if (normalizado.contains('eucalyptus') || normalizado.contains('eucalipto')) {
      return const ConversaoVolumeMadeira(
        unidade: 'mst',
        fator: eucalyptusMstPorM3,
        rotulo: 'metros stereos',
      );
    }
    return const ConversaoVolumeMadeira(unidade: 'm3', fator: 1, rotulo: 'm3');
  }

  static double? valorPadraoCoeficiente({
    required String? modeloMatematicoId,
    required String simbolo,
  }) {
    final normalizadoModeloMatematicoId = modeloMatematicoId?.toLowerCase() ?? '';
    if (normalizadoModeloMatematicoId.contains('schumacher')) {
      return switch (simbolo.toLowerCase()) {
        'a' => padraoSchumacherHallA,
        'b' => padraoSchumacherHallB,
        'c' => padraoSchumacherHallC,
        _ => null,
      };
    }
    if (!normalizadoModeloMatematicoId.contains('spurr')) return null;

    return switch (simbolo.toLowerCase()) {
      'a' => padraoSpurrA,
      'b' => padraoSpurrB,
      _ => null,
    };
  }

  static double _volumeSpurr({
    required double dapCm,
    required double alturaM,
    required Map<String, double?> coeficientes,
  }) {
    final a = _coeficiente(coeficientes, 'a', padraoSpurrA);
    final b = _coeficiente(coeficientes, 'b', padraoSpurrB);
    return a + b * dapCm * dapCm * alturaM;
  }

  static double _volumeSchumacherHall({
    required double dapCm,
    required double alturaM,
    required Map<String, double?> coeficientes,
  }) {
    final a = _coeficiente(coeficientes, 'a', padraoSchumacherHallA);
    final b = _coeficiente(coeficientes, 'b', padraoSchumacherHallB);
    final c = _coeficiente(coeficientes, 'c', padraoSchumacherHallC);
    return math.exp(a + b * math.log(dapCm) + c * math.log(alturaM));
  }

  static double _coeficiente(
    Map<String, double?> coeficientes,
    String simbolo,
    double alternativo,
  ) {
    return coeficientes[simbolo] ??
        coeficientes[simbolo.toUpperCase()] ??
        alternativo;
  }

  static String _normalizar(String valor) {
    return valor
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'\s+'), '');
  }
}

class ConversaoVolumeMadeira {
  const ConversaoVolumeMadeira({
    required this.unidade,
    required this.fator,
    required this.rotulo,
  });

  final String unidade;
  final double fator;
  final String rotulo;

  double converter(double volumeM3) => volumeM3 * fator;
}
