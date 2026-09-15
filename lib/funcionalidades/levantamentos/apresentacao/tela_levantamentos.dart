import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../aplicativo/tema/tema_dendro.dart';
import '../../../nucleo/banco/banco_dendro.dart';
import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../dados/repositorio_levantamentos.dart';
import 'tela_detalhe_levantamento.dart';
import 'tela_novo_levantamento.dart';

class TelaLevantamentos extends ConsumerWidget {
  const TelaLevantamentos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levantamentos = ref.watch(provedorLevantamentos);

    return TelaDendro(
      titulo: 'Levantamentos',
      icone: Icons.assignment,
      flutuanteAcaoBotao: FloatingActionButton(
        heroTag: 'inventory_runs_new_inventory',
        onPressed: () => _abrirNovoLevantamento(context, ref),
        tooltip: 'Novo levantamento',
        child: const Icon(Icons.add),
      ),
      filhos: [
        levantamentos.when(
          data: (itens) {
            if (itens.isEmpty) {
              return _VazioLevantamentosCartao(
                aoCriar: () => _abrirNovoLevantamento(context, ref),
              );
            }

            return Column(
              children: [
                for (final resumo in itens)
                  _LevantamentoCartao(
                    resumo: resumo,
                    aoAbrir: () =>
                        _abrirLevantamento(context, resumo.levantamento.id),
                  ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (erro, pilhaTrace) => _CartaoErroCarregamento(
            aoTentarNovamente: () => ref.invalidate(provedorLevantamentos),
          ),
        ),
      ],
    );
  }

  Future<void> _abrirNovoLevantamento(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final levantamentoId = await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(
        builder: (context) => const TelaNovoLevantamento(),
      ),
    );

    ref.invalidate(provedorLevantamentos);
    ref.invalidate(provedorLevantamentosAtivos);
    ref.invalidate(provedorLevantamentoAtivo);

    if (levantamentoId == null || !context.mounted) return;
    await _abrirLevantamento(context, levantamentoId);
  }

  Future<void> _abrirLevantamento(BuildContext context, int levantamentoId) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            TelaDetalheLevantamento(levantamentoId: levantamentoId),
      ),
    );
  }
}

class _LevantamentoCartao extends StatelessWidget {
  const _LevantamentoCartao({required this.resumo, required this.aoAbrir});

  final LevantamentoResumo resumo;
  final VoidCallback aoAbrir;

  @override
  Widget build(BuildContext context) {
    final situacao = resumo.levantamento.situacao;
    final destacado = situacao == SituacaoLevantamento.emAndamento;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: aoAbrir,
        child: CartaoDendro(
          fundoCor: destacado ? const Color(0xFFE0F2E8) : Colors.white,
          bordaCor: destacado ? const Color(0xFFA4D1B4) : CoresDendro.contorno,
          filho: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: destacado
                      ? CoresDendro.principal
                      : CoresDendro.principalSuave,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  destacado ? Icons.play_arrow : Icons.check,
                  color: destacado ? Colors.white : CoresDendro.principal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IndicadorSituacao(
                        rotulo: _situacaoRotulo(situacao),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      resumo.propriedade.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Início ${_formatoData(resumo.levantamento.iniciadoEm)} • ${_talhaoQuantidadeRotulo(resumo.talhoes.length)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: CoresDendro.textoDiscreto,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _LevantamentoTalhoesLista(talhoes: resumo.talhoes),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        _LevantamentoDetalhe(
                          icone: Icons.forest,
                          rotulo: '${resumo.arvoreQuantidade} árvores',
                        ),
                        _LevantamentoDetalhe(
                          icone: Icons.area_chart,
                          rotulo: '${_formatoArea(resumo.medidaAreaHa)} ha',
                        ),
                        _LevantamentoDetalhe(
                          icone: Icons.grid_view,
                          rotulo:
                              '${resumo.coletadaParcelaQuantidade}/${resumo.parcelaQuantidade} parcelas',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right, color: CoresDendro.textoDiscreto),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevantamentoTalhoesLista extends StatelessWidget {
  const _LevantamentoTalhoesLista({required this.talhoes});

  final List<LevantamentoTalhaoResumo> talhoes;

  @override
  Widget build(BuildContext context) {
    if (talhoes.isEmpty) {
      return const Text(
        'Sem talhão vinculado',
        style: TextStyle(
          color: CoresDendro.textoDiscreto,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Column(
      children: [
        for (var indice = 0; indice < talhoes.length; indice++) ...[
          if (indice > 0)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: Divider(height: 1),
            ),
          _LevantamentoTalhaoLinha(resumo: talhoes[indice]),
        ],
      ],
    );
  }
}

class _LevantamentoTalhaoLinha extends StatelessWidget {
  const _LevantamentoTalhaoLinha({required this.resumo});

  final LevantamentoTalhaoResumo resumo;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.forest_outlined,
            size: 17,
            color: CoresDendro.principal,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resumo.talhao.identificacao,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: CoresDendro.principal,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${resumo.especie.nome} • ${resumo.arvoreQuantidade} árvores • ${resumo.coletadaParcelaQuantidade}/${resumo.parcelaQuantidade} parcelas • ${_formatoArea(resumo.medidaAreaHa)} ha',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: CoresDendro.textoDiscreto,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LevantamentoDetalhe extends StatelessWidget {
  const _LevantamentoDetalhe({required this.icone, required this.rotulo});

  final IconData icone;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icone, size: 14, color: CoresDendro.secundario),
        const SizedBox(width: 4),
        Text(
          rotulo,
          style: const TextStyle(
            color: CoresDendro.principal,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _VazioLevantamentosCartao extends StatelessWidget {
  const _VazioLevantamentosCartao({required this.aoCriar});

  final VoidCallback aoCriar;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      fundoCor: const Color(0xFFF3F4F3),
      filho: Column(
        children: [
          const Icon(
            Icons.assignment_outlined,
            size: 42,
            color: CoresDendro.secundario,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhum levantamento registrado',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Crie um levantamento para iniciar a coleta de campo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CoresDendro.textoDiscreto,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: aoCriar,
              icon: const Icon(Icons.add),
              label: const Text('Novo levantamento'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartaoErroCarregamento extends StatelessWidget {
  const _CartaoErroCarregamento({required this.aoTentarNovamente});

  final VoidCallback aoTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      filho: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(height: 10),
          const Text(
            'Não foi possível carregar os levantamentos.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: aoTentarNovamente,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}

String _situacaoRotulo(SituacaoLevantamento situacao) {
  switch (situacao) {
    case SituacaoLevantamento.planejamento:
      return 'Planejado';
    case SituacaoLevantamento.emAndamento:
      return 'Em andamento';
    case SituacaoLevantamento.concluido:
      return 'Concluído';
  }
}

String _formatoData(DateTime valor) {
  final dia = valor.day.toString().padLeft(2, '0');
  final mes = valor.month.toString().padLeft(2, '0');
  final ano = valor.year.toString();
  return '$dia/$mes/$ano';
}

String _talhaoQuantidadeRotulo(int quantidade) {
  if (quantidade == 0) return 'sem talhão';
  if (quantidade == 1) return '1 talhão';
  return '$quantidade talhões';
}

String _formatoArea(double valor) {
  return valor.toStringAsFixed(2).replaceAll('.', ',');
}
