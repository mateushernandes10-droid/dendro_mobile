import 'package:flutter/material.dart';

import '../../../../aplicativo/tema/tema_dendro.dart';
import '../../dados/repositorio_levantamentos.dart';

Future<bool> confirmarEncerramentoLevantamento({
  required BuildContext context,
  required RepositorioLevantamentos repositorio,
  required LevantamentoResumo resumo,
}) async {
  final possuiParcelasAbertas = resumo.abrirParcelaQuantidade > 0;
  final semParcelas = resumo.parcelaQuantidade == 0;

  if (possuiParcelasAbertas || semParcelas) {
    final continuar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
        title: const Text('Parcelas não encerradas'),
        content: Text(_mensagemParcelasAbertas(resumo)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    if (continuar != true || !context.mounted) return false;
  }

  final avaliacoes = await repositorio.avaliarSuficienciaAmostral(resumo);
  if (!context.mounted) return false;
  final possuiInsuficiente = avaliacoes.any(
    (avaliacao) => !avaliacao.resultado.suficiente,
  );

  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(
            possuiInsuficiente
                ? Icons.warning_amber_rounded
                : Icons.check_circle_outline,
            color: possuiInsuficiente
                ? Colors.red.shade700
                : CoresDendro.principal,
          ),
          title: const Text('Suficiência amostral'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (
                    var indice = 0;
                    indice < avaliacoes.length;
                    indice++
                  ) ...[
                    if (indice > 0) const Divider(height: 28),
                    _AvaliacaoTalhaoCartao(avaliacao: avaliacoes[indice]),
                  ],
                  if (avaliacoes.isEmpty)
                    const Text(
                      'Não há talhões vinculados para calcular a suficiência amostral.',
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deseja finalizar o levantamento agora?',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: possuiInsuficiente
                    ? Colors.red.shade700
                    : CoresDendro.principal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Finalizar'),
            ),
          ],
        ),
      ) ??
      false;
}

String _mensagemParcelasAbertas(LevantamentoResumo resumo) {
  if (resumo.parcelaQuantidade == 0) {
    return 'Esse levantamento ainda não possui parcelas cadastradas. '
        'Sem parcelas finalizadas, não será possível calcular a suficiência amostral. '
        'Deseja continuar?';
  }
  return 'Existem ${resumo.abrirParcelaQuantidade} ${_plural(resumo.abrirParcelaQuantidade, 'parcela')} '
      'ainda não ${_plural(resumo.abrirParcelaQuantidade, 'encerrada')}. '
      'Parcelas não encerradas serão preservadas, mas não serão utilizadas nos cálculos dos resultados nem da suficiência amostral. '
      'Deseja continuar?';
}

class _AvaliacaoTalhaoCartao extends StatelessWidget {
  const _AvaliacaoTalhaoCartao({required this.avaliacao});

  final AvaliacaoSuficienciaTalhao avaliacao;

  @override
  Widget build(BuildContext context) {
    final resultado = avaliacao.resultado;
    final situacao = resultado.suficiente
        ? 'Amostragem suficiente'
        : 'Amostragem insuficiente';
    final cor = resultado.suficiente
        ? CoresDendro.principal
        : Colors.red.shade700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Talhão ${avaliacao.talhaoIdentificacao}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        _linha(
          'Parcelas registradas',
          avaliacao.parcelasRegistradas.toString(),
        ),
        _linha(
          'Parcelas finalizadas utilizadas',
          resultado.parcelasUtilizadas.toString(),
        ),
        _linha(
          'Erro amostral atual',
          _percentualOuIndisponivel(resultado.erroAmostralAtualPercentual),
        ),
        _linha(
          'Erro máximo desejado',
          _percentualOuIndisponivel(resultado.erroMaximoPercentual),
        ),
        _linha('Nível de confiança', '95,0%'),
        _linha(
          'Parcelas estimadas',
          resultado.parcelasEstimadas?.toString() ?? 'Não calculável',
        ),
        _linha(
          'Parcelas adicionais recomendadas',
          resultado.parcelasAdicionais?.toString() ?? 'Não calculável',
        ),
        if (avaliacao.parcelasSemArea > 0)
          Text(
            avaliacao.parcelasSemArea == 1
                ? '1 parcela finalizada sem área foi desconsiderada.'
                : '${avaliacao.parcelasSemArea} parcelas finalizadas sem área foram desconsideradas.',
            style: TextStyle(color: Colors.red.shade700, fontSize: 12),
          ),
        if (!resultado.calculavel)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              'São necessárias pelo menos duas parcelas finalizadas, com área válida e média maior que zero.',
              style: TextStyle(color: CoresDendro.textoDiscreto, fontSize: 12),
            ),
          ),
        const SizedBox(height: 8),
        Text(
          'Situação: $situacao',
          style: TextStyle(color: cor, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _linha(String rotulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text('$rotulo:')),
          const SizedBox(width: 12),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

String _percentualOuIndisponivel(double? valor) {
  if (valor == null || !valor.isFinite) return 'Não calculável';
  return '${valor.toStringAsFixed(1).replaceAll('.', ',')}%';
}

String _plural(int quantidade, String singular) {
  if (quantidade == 1) return singular;
  return '${singular}s';
}
