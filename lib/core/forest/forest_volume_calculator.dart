import 'dart:math' as math;

class ForestVolumeCalculator {
  const ForestVolumeCalculator._();

  static const defaultHeightIntercept = 0.8203;
  static const defaultHeightSlope = 6.4229;
  static const defaultSpurrA = 0.0175858265880592;
  static const defaultSpurrB = 0.0000329326161133665;
  static const pinusTonPerM3 = 0.9367;
  static const eucalyptusMstPerM3 = 1.4;

  static double estimatedHeightM(double dapCm) {
    if (dapCm <= 0) return 0;
    return defaultHeightSlope * math.log(dapCm) + defaultHeightIntercept;
  }

  static double treeVolumeM3({
    required double dapCm,
    required double heightM,
    required Map<String, double?> coefficients,
    String? formulaId,
    String? formulaExpression,
  }) {
    final resolvedHeightM = heightM > 0 ? heightM : estimatedHeightM(dapCm);
    if (dapCm <= 0 || resolvedHeightM <= 0) return 0;

    final normalizedFormulaId = formulaId?.toLowerCase() ?? '';
    final normalizedExpression = _normalize(formulaExpression ?? '');

    final volume =
        normalizedFormulaId.contains('schumacher') ||
            normalizedExpression.startsWith('exp(')
        ? _schumacherHallVolume(
            dapCm: dapCm,
            heightM: resolvedHeightM,
            coefficients: coefficients,
          )
        : _spurrVolume(
            dapCm: dapCm,
            heightM: resolvedHeightM,
            coefficients: coefficients,
          );

    if (volume.isNaN || volume.isInfinite || volume < 0) return 0;
    return volume;
  }

  static WoodVolumeConversion conversionForSpecies(String speciesName) {
    final normalized = _normalize(speciesName);
    if (normalized.contains('pinus') || normalized.contains('pinnus')) {
      return const WoodVolumeConversion(
        unit: 'ton',
        factor: pinusTonPerM3,
        label: 'toneladas',
      );
    }
    if (normalized.contains('eucalyptus') || normalized.contains('eucalipto')) {
      return const WoodVolumeConversion(
        unit: 'mst',
        factor: eucalyptusMstPerM3,
        label: 'metros stereos',
      );
    }
    return const WoodVolumeConversion(unit: 'm3', factor: 1, label: 'm3');
  }

  static double? defaultCoefficientValue({
    required String? formulaId,
    required String symbol,
  }) {
    final normalizedFormulaId = formulaId?.toLowerCase() ?? '';
    if (!normalizedFormulaId.contains('spurr')) return null;

    return switch (symbol.toLowerCase()) {
      'a' => defaultSpurrA,
      'b' => defaultSpurrB,
      _ => null,
    };
  }

  static double _spurrVolume({
    required double dapCm,
    required double heightM,
    required Map<String, double?> coefficients,
  }) {
    final a = _coefficient(coefficients, 'a', defaultSpurrA);
    final b = _coefficient(coefficients, 'b', defaultSpurrB);
    return a + b * dapCm * dapCm * heightM;
  }

  static double _schumacherHallVolume({
    required double dapCm,
    required double heightM,
    required Map<String, double?> coefficients,
  }) {
    final a = _coefficient(coefficients, 'a', 0);
    final b = _coefficient(coefficients, 'b', 0);
    final c = _coefficient(coefficients, 'c', 0);
    return math.exp(a + b * math.log(dapCm) + c * math.log(heightM));
  }

  static double _coefficient(
    Map<String, double?> coefficients,
    String symbol,
    double fallback,
  ) {
    return coefficients[symbol] ??
        coefficients[symbol.toUpperCase()] ??
        fallback;
  }

  static String _normalize(String value) {
    return value
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

class WoodVolumeConversion {
  const WoodVolumeConversion({
    required this.unit,
    required this.factor,
    required this.label,
  });

  final String unit;
  final double factor;
  final String label;

  double convert(double volumeM3) => volumeM3 * factor;
}
