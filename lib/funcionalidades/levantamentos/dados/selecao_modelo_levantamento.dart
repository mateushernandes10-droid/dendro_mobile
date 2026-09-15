class SelecaoModeloLevantamento {
  const SelecaoModeloLevantamento({
    required this.modeloMatematicoId,
    required this.coeficienteValoresPorSimbolo,
    this.modeloMatematicoNome,
  });

  final int modeloMatematicoId;
  final Map<String, double?> coeficienteValoresPorSimbolo;
  final String? modeloMatematicoNome;
}

class ValorCoeficienteModeloLevantamento {
  const ValorCoeficienteModeloLevantamento({
    required this.simbolo,
    required this.rotulo,
    required this.valor,
  });

  final String simbolo;
  final String rotulo;
  final double? valor;
}
