class LevantamentoModeloMatematicoSelecao {
  const LevantamentoModeloMatematicoSelecao({
    required this.modeloMatematicoId,
    required this.coeficienteValoresPorSimbolo,
    this.modeloMatematicoNome,
  });

  final int modeloMatematicoId;
  final Map<String, double?> coeficienteValoresPorSimbolo;
  final String? modeloMatematicoNome;
}

class LevantamentoModeloMatematicoCoeficienteValor {
  const LevantamentoModeloMatematicoCoeficienteValor({
    required this.simbolo,
    required this.rotulo,
    required this.valor,
  });

  final String simbolo;
  final String rotulo;
  final double? valor;
}
