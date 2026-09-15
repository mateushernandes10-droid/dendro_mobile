import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../aplicativo/tema/tema_dendro.dart';
import '../../../nucleo/banco/banco_dendro.dart';
import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../../atividades/dados/repositorio_atividades.dart';
import '../../atividades/apresentacao/tela_historico_atividades.dart';
import '../../atividades/apresentacao/componentes_atividades.dart';
import '../../levantamentos/dados/selecao_modelo_levantamento.dart';
import '../../levantamentos/dados/repositorio_levantamentos.dart';
import '../../levantamentos/apresentacao/tela_detalhe_levantamento.dart';
import '../../levantamentos/apresentacao/tela_novo_levantamento.dart';
import '../../levantamentos/apresentacao/componentes/painel_selecao_modelo_levantamento.dart';
import '../../parcelas/dados/repositorio_parcelas.dart';
import '../../parcelas/apresentacao/tela_parcelas_talhao.dart';
import '../../propriedades/dados/repositorio_propriedades.dart';
import '../../talhoes/dados/repositorio_talhoes.dart';

class TelaInicio extends ConsumerStatefulWidget {
  const TelaInicio({super.key});

  @override
  ConsumerState<TelaInicio> createState() => _InicioTelaEstado();
}

class _InicioTelaEstado extends ConsumerState<TelaInicio> {
  late final PageController _ativoLevantamentoControlador;
  int _selecionadoAtivoLevantamentoIndex = 0;

  @override
  void initState() {
    super.initState();
    _ativoLevantamentoControlador = PageController();
  }

  @override
  void dispose() {
    _ativoLevantamentoControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ativoLevantamentos = ref.watch(provedorLevantamentosAtivos);
    final selecionadoColeta = _selecionadoColeta(
      _ativoColetaItens(ativoLevantamentos.asData?.value ?? []),
    );
    final selecionadoLevantamentoResumo = selecionadoColeta?.levantamentoResumo;
    final recenteAtividades = ref.watch(provedorAtividadesRecentes);
    final agora = DateTime.now();

    return TelaDendro(
      titulo: 'Início',
      icone: Icons.home,
      filhos: [
        ElevatedButton.icon(
          onPressed: () => _abrirNovoLevantamentoPainel(context),
          icon: const Icon(Icons.add),
          label: const Text('Novo Levantamento'),
        ),
        const SizedBox(height: 14),
        ativoLevantamentos.when(
          data: (resumos) {
            final coletas = _ativoColetaItens(resumos);
            return _PaginadorColetasAtivas(
              controlador: _ativoLevantamentoControlador,
              coletas: coletas,
              selecionadoIndex: _selecionadoAtivoLevantamentoIndex,
              aoPaginaAlterado: (indice) =>
                  setState(() => _selecionadoAtivoLevantamentoIndex = indice),
              aoContinuar: (coleta) => _abrirAtivoColeta(context, coleta),
            );
          },
          loading: () => const _CartaoCarregamentoColetasAtivas(),
          error: (erro, pilhaTrace) => _CartaoErroColetasAtivas(
            aoTentarNovamente: () =>
                ref.invalidate(provedorLevantamentosAtivos),
          ),
        ),
        const SizedBox(height: 20),
        const TituloSecao(titulo: 'Resumo do levantamento'),
        Row(
          children: [
            Expanded(
              child: BlocoIndicador(
                rotulo: 'Árvores medidas',
                valor: (selecionadoLevantamentoResumo?.arvoreQuantidade ?? 0)
                    .toString(),
                icone: Icons.park_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BlocoIndicador(
                rotulo: 'Área medida',
                valor: _formatoArea(
                  selecionadoLevantamentoResumo?.medidaAreaHa ?? 0,
                ),
                icone: Icons.area_chart_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TituloSecao(
          titulo: 'Atividades recentes',
          complemento: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const TelaHistoricoAtividades(),
              ),
            ),
            child: const Text('Ver todas'),
          ),
        ),
        recenteAtividades.when(
          data: (itens) {
            if (itens.isEmpty) {
              return const CartaoDendro(
                fundoCor: Color(0xFFF3F4F3),
                filho: Text(
                  'Nenhuma atividade registrada ainda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              );
            }

            return Column(
              children: [
                for (final atividade in itens)
                  ItemRegistroAtividade(
                    atividade: atividade,
                    exibicaoHora: formatoRegistroAtividadeData(
                      atividade.ocorridoEm,
                      agora,
                    ),
                  ),
              ],
            );
          },
          loading: () => const CartaoDendro(filho: LinearProgressIndicator()),
          error: (erro, pilhaTrace) => CartaoDendro(
            filho: Column(
              children: [
                const Text(
                  'Nao foi possivel carregar as atividades recentes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => ref.invalidate(provedorAtividadesRecentes),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _abrirNovoLevantamentoPainel(BuildContext context) async {
    final levantamentoId = await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(
        builder: (context) => const TelaNovoLevantamento(),
      ),
    );

    if (levantamentoId == null || !context.mounted) return;
    _abrirLevantamento(context, levantamentoId);
  }

  void _abrirLevantamento(BuildContext context, int levantamentoId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            TelaDetalheLevantamento(levantamentoId: levantamentoId),
      ),
    );
  }

  void _abrirAtivoColeta(BuildContext context, _ItemColetaAtiva coleta) {
    final talhaoResumo = coleta.talhaoResumo;
    if (talhaoResumo == null) {
      _abrirLevantamento(context, coleta.levantamentoResumo.levantamento.id);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TelaParcelasTalhao(
          talhaoId: talhaoResumo.talhao.id,
          talhaoLevantamentoId: talhaoResumo.talhaoLevantamento.id,
          mostrarIniciarLevantamentoAcao: false,
          habilitarColetaArvores: true,
        ),
      ),
    );
  }

  _ItemColetaAtiva? _selecionadoColeta(List<_ItemColetaAtiva> coletas) {
    if (coletas.isEmpty) return null;
    if (_selecionadoAtivoLevantamentoIndex >= coletas.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(
            () => _selecionadoAtivoLevantamentoIndex = coletas.length - 1,
          );
        }
      });
      return coletas.last;
    }
    return coletas[_selecionadoAtivoLevantamentoIndex];
  }
}

class _ItemColetaAtiva {
  const _ItemColetaAtiva({
    required this.levantamentoResumo,
    required this.talhaoResumo,
  });

  final LevantamentoResumo levantamentoResumo;
  final LevantamentoTalhaoResumo? talhaoResumo;
}

List<_ItemColetaAtiva> _ativoColetaItens(List<LevantamentoResumo> resumos) {
  return [
    for (final resumo in resumos)
      if (resumo.talhoes.isEmpty)
        _ItemColetaAtiva(levantamentoResumo: resumo, talhaoResumo: null)
      else
        for (final talhaoResumo in resumo.talhoes)
          _ItemColetaAtiva(
            levantamentoResumo: resumo,
            talhaoResumo: talhaoResumo,
          ),
  ];
}

class _PaginadorColetasAtivas extends StatelessWidget {
  const _PaginadorColetasAtivas({
    required this.controlador,
    required this.coletas,
    required this.selecionadoIndex,
    required this.aoPaginaAlterado,
    required this.aoContinuar,
  });

  final PageController controlador;
  final List<_ItemColetaAtiva> coletas;
  final int selecionadoIndex;
  final ValueChanged<int> aoPaginaAlterado;
  final ValueChanged<_ItemColetaAtiva> aoContinuar;

  @override
  Widget build(BuildContext context) {
    if (coletas.isEmpty) {
      return const _CartaoColetaAtiva(coleta: null, aoContinuar: null);
    }

    final seguroIndex = selecionadoIndex >= coletas.length
        ? coletas.length - 1
        : selecionadoIndex;
    final textoEscala = MediaQuery.textScalerOf(context).scale(1);
    final extraAltura = ((textoEscala - 1) * 84).clamp(0.0, 84.0).toDouble();
    final paginadorAltura = 324.0 + extraAltura;

    return Column(
      children: [
        SizedBox(
          height: paginadorAltura,
          child: PageView.builder(
            controller: controlador,
            itemCount: coletas.length,
            onPageChanged: aoPaginaAlterado,
            itemBuilder: (context, indice) {
              final coleta = coletas[indice];
              return _CartaoColetaAtiva(
                coleta: coleta,
                aoContinuar: () => aoContinuar(coleta),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        _IndicadorPaginasColetasAtivas(
          quantidade: coletas.length,
          selecionadoIndex: seguroIndex,
        ),
      ],
    );
  }
}

class _IndicadorPaginasColetasAtivas extends StatelessWidget {
  const _IndicadorPaginasColetasAtivas({
    required this.quantidade,
    required this.selecionadoIndex,
  });

  final int quantidade;
  final int selecionadoIndex;

  @override
  Widget build(BuildContext context) {
    final pontoCor = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).colorScheme.primary
        : CoresDendro.principal;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var indice = 0; indice < quantidade; indice++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 9,
            height: 9,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: indice == selecionadoIndex ? pontoCor : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: pontoCor, width: 1.5),
            ),
          ),
      ],
    );
  }
}

class _CartaoColetaAtiva extends StatelessWidget {
  const _CartaoColetaAtiva({required this.coleta, required this.aoContinuar});

  final _ItemColetaAtiva? coleta;
  final VoidCallback? aoContinuar;

  @override
  Widget build(BuildContext context) {
    final ativoColeta = coleta;

    if (ativoColeta == null) {
      return const CartaoDendro(
        fundoCor: Color(0xFFF3F4F3),
        filho: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IndicadorSituacao(rotulo: 'Sem coleta aberta'),
            SizedBox(height: 12),
            Text(
              'Nenhum levantamento em andamento',
              style: TextStyle(
                color: CoresDendro.texto,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Crie um novo levantamento para começar a coleta de campo.',
              style: TextStyle(
                color: CoresDendro.textoDiscreto,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    final levantamentoResumo = ativoColeta.levantamentoResumo;
    final talhaoResumo = ativoColeta.talhaoResumo;
    final titulo =
        talhaoResumo?.talhao.identificacao ?? levantamentoResumo.talhaoRotulo;
    final subtituloPrefixo = talhaoResumo?.especie.nome;
    final propriedadeRotulo =
        '${levantamentoResumo.propriedade.nome} - ${levantamentoResumo.propriedade.municipio}-${levantamentoResumo.propriedade.estado}';
    final subtitulo = subtituloPrefixo == null
        ? propriedadeRotulo
        : '$subtituloPrefixo • $propriedadeRotulo';
    final arvoreQuantidade =
        talhaoResumo?.arvoreQuantidade ?? levantamentoResumo.arvoreQuantidade;
    final medidaAreaHa =
        talhaoResumo?.medidaAreaHa ?? levantamentoResumo.medidaAreaHa;

    return CartaoDendro(
      fundoCor: const Color(0xFFE0F2E8),
      bordaCor: const Color(0xFFA4D1B4),
      filho: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              IndicadorSituacao(rotulo: 'Em andamento'),
              Spacer(),
              Icon(Icons.play_arrow_rounded, color: CoresDendro.principal),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CoresDendro.principal,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            style: const TextStyle(
              color: CoresDendro.textoDiscreto,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: _IndicadorEmLinha(
                  rotulo: 'Árvores medidas',
                  valor: arvoreQuantidade.toString(),
                ),
              ),
              Expanded(
                child: _IndicadorEmLinha(
                  rotulo: 'Área medida',
                  valor: _formatoArea(medidaAreaHa),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: aoContinuar,
              icon: const Icon(Icons.forest, size: 18),
              label: const Text('Continuar Coleta'),
              style: FilledButton.styleFrom(
                backgroundColor: CoresDendro.principal,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartaoCarregamentoColetasAtivas extends StatelessWidget {
  const _CartaoCarregamentoColetasAtivas();

  @override
  Widget build(BuildContext context) {
    return const CartaoDendro(
      fundoCor: Color(0xFFF3F4F3),
      filho: LinearProgressIndicator(),
    );
  }
}

class _CartaoErroColetasAtivas extends StatelessWidget {
  const _CartaoErroColetasAtivas({required this.aoTentarNovamente});

  final VoidCallback aoTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      fundoCor: const Color(0xFFF3F4F3),
      filho: Column(
        children: [
          const Text(
            'Não foi possível carregar os levantamentos em andamento.',
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

class _NovoLevantamentoPainel extends ConsumerStatefulWidget {
  const _NovoLevantamentoPainel();

  @override
  ConsumerState<_NovoLevantamentoPainel> createState() =>
      _NovoLevantamentoPainelEstado();
}

class _NovoLevantamentoPainelEstado
    extends ConsumerState<_NovoLevantamentoPainel> {
  static const _novoTalhaoOpcaoValor = -1;

  int? _propriedadeId;
  int? _talhaoId;
  int? _pendenteCriadoTalhaoId;
  String? _iniciarErroMensagem;
  final Map<int, SelecaoModeloLevantamento> _selecoesModeloPorTalhaoId = {};
  bool _salvando = false;

  @override
  Widget build(BuildContext context) {
    final propriedades = ref.watch(provedorResumosPropriedades);
    final inferiorRecuo = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: inferiorRecuo),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: propriedades.when(
          data: (itens) {
            _sincronizarPropriedadeSelecao(itens);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PainelCabecalho(salvando: _salvando),
                const SizedBox(height: 16),
                if (itens.isEmpty)
                  const _VazioIniciarCartao(
                    icone: Icons.map_outlined,
                    titulo: 'Nenhuma propriedade cadastrada',
                    mensagem:
                        'Cadastre uma propriedade e seus talhões antes de iniciar a coleta.',
                  )
                else ...[
                  DropdownButtonFormField<int>(
                    key: ValueKey('property-$_propriedadeId'),
                    initialValue: _propriedadeId,
                    decoration: const InputDecoration(
                      labelText: 'Propriedade',
                      prefixIcon: Icon(Icons.map_outlined),
                    ),
                    items: [
                      for (final item in itens)
                        DropdownMenuItem(
                          value: item.propriedade.id,
                          child: Text(item.propriedade.nome),
                        ),
                    ],
                    onChanged: _salvando
                        ? null
                        : (valor) => setState(() {
                            _propriedadeId = valor;
                            _talhaoId = null;
                            _pendenteCriadoTalhaoId = null;
                            _iniciarErroMensagem = null;
                          }),
                  ),
                  const SizedBox(height: 12),
                  if (_propriedadeId != null)
                    _talhaoSeletor(propriedadeId: _propriedadeId!),
                ],
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.only(bottom: 18),
            child: LinearProgressIndicator(),
          ),
          error: (erro, pilhaTrace) => _VazioIniciarCartao(
            icone: Icons.error_outline,
            titulo: 'Não foi possível carregar',
            mensagem: 'Tente novamente para selecionar propriedade e talhão.',
            acao: OutlinedButton.icon(
              onPressed: () => ref.invalidate(provedorResumosPropriedades),
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _talhaoSeletor({required int propriedadeId}) {
    final talhoes = ref.watch(provedorTalhoesDaPropriedade(propriedadeId));

    return talhoes.when(
      data: (itens) {
        _sincronizarTalhaoSelecao(itens);

        if (itens.isEmpty) {
          return _VazioIniciarCartao(
            icone: Icons.forest_outlined,
            titulo: 'Nenhum talhão cadastrado',
            mensagem:
                'Cadastre ao menos um talhão nessa propriedade antes de iniciar o levantamento.',
            acao: OutlinedButton.icon(
              onPressed: _salvando
                  ? null
                  : () => _abrirNovoTalhaoPainel(propriedadeId),
              icon: const Icon(Icons.add),
              label: const Text('Novo talhão'),
            ),
          );
        }

        final selecionadoTalhao = _selecionadoTalhao(itens);
        final visivelErro =
            _iniciarErroMensagem ??
            (selecionadoTalhao?.possuiAtivoLevantamento == true
                ? 'Esse talhão já possui uma coleta em andamento. Não é possível iniciar outro levantamento para o mesmo talhão.'
                : null);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (visivelErro != null) ...[
              _PainelErroMensagem(mensagem: visivelErro),
              const SizedBox(height: 12),
            ],
            DropdownButtonFormField<int>(
              key: ValueKey('stand-$propriedadeId-$_talhaoId'),
              initialValue: _talhaoId,
              decoration: const InputDecoration(
                labelText: 'Talhão',
                prefixIcon: Icon(Icons.forest_outlined),
              ),
              items: [
                const DropdownMenuItem(
                  value: _novoTalhaoOpcaoValor,
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 18, color: CoresDendro.principal),
                      SizedBox(width: 8),
                      Text('Novo talhão'),
                    ],
                  ),
                ),
                for (final item in itens)
                  DropdownMenuItem(
                    value: item.talhao.id,
                    child: Text(
                      item.possuiAtivoLevantamento
                          ? '${item.talhao.identificacao} • Em coleta'
                          : '${item.talhao.identificacao} • ${item.especie.nome}',
                    ),
                  ),
              ],
              onChanged: _salvando ? null : (valor) => _aoTalhaoAlterado(valor),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _salvando
                    ? null
                    : () => _abrirNovoTalhaoPainel(propriedadeId),
                icon: const Icon(Icons.add),
                label: const Text('Novo talhão'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _salvando || _talhaoId == null ? null : _iniciar,
                icon: _salvando
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: Text(
                  _salvando ? 'Iniciando...' : 'Iniciar levantamento',
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const CartaoDendro(filho: LinearProgressIndicator()),
      error: (erro, pilhaTrace) => _VazioIniciarCartao(
        icone: Icons.error_outline,
        titulo: 'Não foi possível carregar os talhões',
        mensagem: 'Tente novamente para escolher o talhão do levantamento.',
        acao: OutlinedButton.icon(
          onPressed: () =>
              ref.invalidate(provedorTalhoesDaPropriedade(propriedadeId)),
          icon: const Icon(Icons.refresh),
          label: const Text('Tentar novamente'),
        ),
      ),
    );
  }

  Future<void> _iniciar() async {
    final talhaoId = _talhaoId;
    if (talhaoId == null) return;

    setState(() => _salvando = true);

    try {
      setState(() => _iniciarErroMensagem = null);
      final talhaoLevantamento = await ref
          .read(provedorRepositorioParcelas)
          .iniciarNovoLevantamentoParaTalhao(
            talhaoId,
            modeloMatematicoSelecao: _selecoesModeloPorTalhaoId[talhaoId],
          );

      ref.invalidate(provedorLevantamentosAtivos);
      ref.invalidate(provedorLevantamentoAtivo);
      ref.invalidate(provedorParcelasTalhao(talhaoId));

      if (!mounted) return;
      Navigator.of(context).pop(talhaoLevantamento.levantamentoId);
    } on ExcecaoLevantamentoAtivoNoTalhao {
      ref.invalidate(provedorLevantamentosAtivos);
      ref.invalidate(provedorLevantamentoAtivo);

      if (!mounted) return;
      setState(() {
        _iniciarErroMensagem =
            'Esse talhão já possui uma coleta em andamento. Não é possível iniciar outro levantamento para o mesmo talhão.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _iniciarErroMensagem = 'Não foi possível iniciar o levantamento.';
      });
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  void _aoTalhaoAlterado(int? valor) {
    if (valor == _novoTalhaoOpcaoValor) {
      final propriedadeId = _propriedadeId;
      if (propriedadeId != null) {
        unawaited(_abrirNovoTalhaoPainel(propriedadeId));
      }
      return;
    }

    setState(() {
      _talhaoId = valor;
      _iniciarErroMensagem = null;
    });
  }

  Future<void> _abrirNovoTalhaoPainel(int propriedadeId) async {
    final criacao = await showModalBottomSheet<_ResultadoCadastroRapidoTalhao>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) =>
          _PainelCadastroRapidoTalhao(propriedadeId: propriedadeId),
    );

    if (criacao == null || !mounted) return;

    setState(() {
      _pendenteCriadoTalhaoId = criacao.talhaoId;
      _iniciarErroMensagem = null;
      if (criacao.modeloMatematicoSelecao == null) {
        _selecoesModeloPorTalhaoId.remove(criacao.talhaoId);
      } else {
        _selecoesModeloPorTalhaoId[criacao.talhaoId] =
            criacao.modeloMatematicoSelecao!;
      }
    });
    ref.invalidate(provedorTalhoesDaPropriedade(propriedadeId));
    ref.invalidate(provedorResumosPropriedades);
  }

  void _sincronizarPropriedadeSelecao(List<PropriedadeResumo> propriedades) {
    if (propriedades.isEmpty) {
      _propriedadeId = null;
      _talhaoId = null;
      _pendenteCriadoTalhaoId = null;
      return;
    }

    final selecionadoAindaExiste = propriedades.any(
      (resumo) => resumo.propriedade.id == _propriedadeId,
    );
    if (_propriedadeId == null || !selecionadoAindaExiste) {
      _propriedadeId = propriedades.first.propriedade.id;
      _talhaoId = null;
    }
  }

  void _sincronizarTalhaoSelecao(List<TalhaoResumo> talhoes) {
    if (talhoes.isEmpty) {
      _talhaoId = null;
      return;
    }

    final pendenteTalhaoId = _pendenteCriadoTalhaoId;
    if (pendenteTalhaoId != null &&
        talhoes.any((resumo) => resumo.talhao.id == pendenteTalhaoId)) {
      _talhaoId = pendenteTalhaoId;
      _pendenteCriadoTalhaoId = null;
      return;
    }

    final selecionadoAindaExiste = talhoes.any(
      (resumo) => resumo.talhao.id == _talhaoId,
    );
    if (_talhaoId == null || !selecionadoAindaExiste) {
      _talhaoId = talhoes.first.talhao.id;
    }
  }

  TalhaoResumo? _selecionadoTalhao(List<TalhaoResumo> talhoes) {
    for (final resumo in talhoes) {
      if (resumo.talhao.id == _talhaoId) return resumo;
    }
    return null;
  }
}

class _PainelErroMensagem extends StatelessWidget {
  const _PainelErroMensagem({required this.mensagem});

  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.red.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                mensagem,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PainelCadastroRapidoTalhao extends ConsumerStatefulWidget {
  const _PainelCadastroRapidoTalhao({required this.propriedadeId});

  final int propriedadeId;

  @override
  ConsumerState<_PainelCadastroRapidoTalhao> createState() =>
      _EstadoPainelCadastroRapidoTalhao();
}

class _EstadoPainelCadastroRapidoTalhao
    extends ConsumerState<_PainelCadastroRapidoTalhao> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _identificacaoControlador = TextEditingController();
  final _areaControlador = TextEditingController();
  final _plantioAnoControlador = TextEditingController();
  final _espacamentoControlador = TextEditingController();
  final _manejoRegimeControlador = TextEditingController();
  final _parcelaLarguraControlador = TextEditingController();
  final _parcelaComprimentoControlador = TextEditingController();
  final _observacoesControlador = TextEditingController();
  SelecaoModeloLevantamento? _modeloMatematicoSelecao;
  int? _especieId;
  bool _salvando = false;

  @override
  void dispose() {
    _identificacaoControlador.dispose();
    _areaControlador.dispose();
    _plantioAnoControlador.dispose();
    _espacamentoControlador.dispose();
    _manejoRegimeControlador.dispose();
    _parcelaLarguraControlador.dispose();
    _parcelaComprimentoControlador.dispose();
    _observacoesControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final especies = ref.watch(provedorEspeciesAtivas);
    final inferiorRecuo = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: inferiorRecuo),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: Form(
          key: _chaveFormulario,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Novo talhão',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _salvando
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: 'Fechar',
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _identificacaoControlador,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Identificação',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                validator: _validarCampoObrigatorio,
              ),
              const SizedBox(height: 12),
              especies.when(
                data: (itens) {
                  _sincronizarEspecieSelecao(itens);
                  return DropdownButtonFormField<int>(
                    key: ValueKey('quick-species-$_especieId'),
                    initialValue: _especieId,
                    decoration: const InputDecoration(
                      labelText: 'Espécie',
                      prefixIcon: Icon(Icons.eco_outlined),
                    ),
                    items: [
                      for (final item in itens)
                        DropdownMenuItem(
                          value: item.id,
                          child: Text(item.nome),
                        ),
                    ],
                    onChanged: _salvando
                        ? null
                        : (valor) => setState(() {
                            _especieId = valor;
                            _modeloMatematicoSelecao = null;
                          }),
                    validator: (valor) =>
                        valor == null ? 'Selecione uma espécie' : null,
                  );
                },
                loading: () =>
                    const CartaoDendro(filho: LinearProgressIndicator()),
                error: (erro, pilhaTrace) => const CartaoDendro(
                  filho: Text('Não foi possível carregar as espécies.'),
                ),
              ),
              const SizedBox(height: 12),
              _ModeloMatematicoAjusteCartao(
                selecao: _modeloMatematicoSelecao,
                aoPressionado: _especieId == null || _salvando
                    ? null
                    : _ajustarModeloMatematico,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _areaControlador,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Área (ha)',
                        prefixIcon: Icon(Icons.area_chart_outlined),
                      ),
                      validator: _validarArea,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 126,
                    child: TextFormField(
                      controller: _plantioAnoControlador,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: const InputDecoration(labelText: 'Ano'),
                      validator: _validarAnoPlantio,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _espacamentoControlador,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Espaçamento (opcional)',
                  prefixIcon: Icon(Icons.grid_4x4_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _manejoRegimeControlador,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Regime de manejo (opcional)',
                  prefixIcon: Icon(Icons.agriculture_outlined),
                ),
              ),
              const SizedBox(height: 12),
              EntradaDimensoesParcela(
                larguraControlador: _parcelaLarguraControlador,
                comprimentoControlador: _parcelaComprimentoControlador,
                validadorLargura: (valor) => _validarDimensaoParcela(
                  valor,
                  _parcelaComprimentoControlador.text,
                  'primeira medida',
                ),
                validadorComprimento: (valor) => _validarDimensaoParcela(
                  valor,
                  _parcelaLarguraControlador.text,
                  'segunda medida',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _observacoesControlador,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Observação (opcional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvando ? null : _salvar,
                  icon: _salvando
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_salvando ? 'Salvando...' : 'Cadastrar talhão'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _salvar() async {
    if (!_chaveFormulario.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      final talhaoId = await ref
          .read(provedorRepositorioTalhoes)
          .criar(
            propriedadeId: widget.propriedadeId,
            identificacao: _identificacaoControlador.text,
            especieId: _especieId!,
            areaHa: _interpretarArea(_areaControlador.text)!,
            anoPlantio: _interpretarOpcionalInteiro(
              _plantioAnoControlador.text,
            ),
            espacamento: _espacamentoControlador.text,
            regimeManejo: _manejoRegimeControlador.text,
            larguraParcelaM: _interpretarOpcionalArea(
              _parcelaLarguraControlador.text,
            ),
            comprimentoParcelaM: _interpretarOpcionalArea(
              _parcelaComprimentoControlador.text,
            ),
            observacoes: _observacoesControlador.text,
          );

      ref.invalidate(provedorTalhoesDaPropriedade(widget.propriedadeId));
      ref.invalidate(provedorResumosPropriedades);

      if (!mounted) return;
      Navigator.of(context).pop(
        _ResultadoCadastroRapidoTalhao(
          talhaoId: talhaoId,
          modeloMatematicoSelecao: _modeloMatematicoSelecao,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: const Text('Não foi possível cadastrar o talhão.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  void _sincronizarEspecieSelecao(List<Especie> especies) {
    if (especies.isEmpty) {
      _especieId = null;
      return;
    }

    final selecionadoAindaExiste = especies.any(
      (item) => item.id == _especieId,
    );
    if (_especieId == null || !selecionadoAindaExiste) {
      _especieId = especies.first.id;
      _modeloMatematicoSelecao = null;
    }
  }

  Future<void> _ajustarModeloMatematico() async {
    final especieId = _especieId;
    if (especieId == null) return;

    final selecao = await mostrarLevantamentoModeloMatematicoSelecaoPainel(
      context: context,
      especieId: especieId,
      inicialSelecao: _modeloMatematicoSelecao,
    );

    if (selecao == null || !mounted) return;

    setState(() => _modeloMatematicoSelecao = selecao);
  }

  String? _validarCampoObrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String? _validarArea(String? valor) {
    final area = _interpretarArea(valor ?? '');
    if (area == null) return 'Informe uma área válida';
    if (area < 0) return 'Área não pode ser negativa';
    return null;
  }

  String? _validarAnoPlantio(String? valor) {
    if (valor == null || valor.trim().isEmpty) return null;

    final ano = int.tryParse(valor.trim());
    if (ano == null) return 'Ano inválido';
    if (ano < 1900 || ano > DateTime.now().year + 1) {
      return 'Confira o ano';
    }
    return null;
  }

  String? _validarDimensaoParcela(
    String? valor,
    String pareadoValor,
    String rotulo,
  ) {
    final possuiValor = valor != null && valor.trim().isNotEmpty;
    final possuiPar = pareadoValor.trim().isNotEmpty;
    if (!possuiValor && !possuiPar) return null;
    if (!possuiValor) return 'Informe a $rotulo';

    final interpretado = _interpretarOpcionalArea(valor);
    if (interpretado == null || interpretado <= 0) return 'Valor inválido';
    return null;
  }
}

class _ResultadoCadastroRapidoTalhao {
  const _ResultadoCadastroRapidoTalhao({
    required this.talhaoId,
    required this.modeloMatematicoSelecao,
  });

  final int talhaoId;
  final SelecaoModeloLevantamento? modeloMatematicoSelecao;
}

class _ModeloMatematicoAjusteCartao extends StatelessWidget {
  const _ModeloMatematicoAjusteCartao({
    required this.selecao,
    required this.aoPressionado,
  });

  final SelecaoModeloLevantamento? selecao;
  final VoidCallback? aoPressionado;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      fundoCor: const Color(0xFFEAF7EF),
      bordaCor: const Color(0xFFA4D1B4),
      filho: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Modelo matemático',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            selecao == null
                ? 'Será usado o modelo padrão da espécie selecionada.'
                : selecao!.modeloMatematicoNome ?? 'Modelo personalizado',
            style: const TextStyle(
              color: CoresDendro.textoDiscreto,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: aoPressionado,
              icon: const Icon(Icons.functions),
              style: OutlinedButton.styleFrom(
                foregroundColor: CoresDendro.principal,
                disabledForegroundColor: CoresDendro.textoDiscreto,
                side: BorderSide(
                  color: aoPressionado == null
                      ? CoresDendro.contorno
                      : CoresDendro.principal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              label: const Text('Ajustar modelo matemático'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PainelCabecalho extends StatelessWidget {
  const _PainelCabecalho({required this.salvando});

  final bool salvando;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Novo levantamento',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
        ),
        IconButton(
          onPressed: salvando ? null : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          tooltip: 'Fechar',
        ),
      ],
    );
  }
}

class _VazioIniciarCartao extends StatelessWidget {
  const _VazioIniciarCartao({
    required this.icone,
    required this.titulo,
    required this.mensagem,
    this.acao,
  });

  final IconData icone;
  final String titulo;
  final String mensagem;
  final Widget? acao;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      fundoCor: const Color(0xFFF3F4F3),
      filho: Column(
        children: [
          Icon(icone, size: 42, color: CoresDendro.secundario),
          const SizedBox(height: 12),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            mensagem,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CoresDendro.textoDiscreto,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (acao != null) ...[const SizedBox(height: 14), acao!],
        ],
      ),
    );
  }
}

class _IndicadorEmLinha extends StatelessWidget {
  const _IndicadorEmLinha({required this.rotulo, required this.valor});

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rotulo,
          style: const TextStyle(
            color: CoresDendro.textoDiscreto,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          valor,
          style: const TextStyle(
            color: CoresDendro.principal,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

String _formatoArea(double valor) {
  return '${valor.toStringAsFixed(2).replaceAll('.', ',')} ha';
}

double? _interpretarArea(String valor) {
  return double.tryParse(valor.trim().replaceAll(',', '.'));
}

double? _interpretarOpcionalArea(String valor) {
  final aparado = valor.trim();
  if (aparado.isEmpty) return null;
  return _interpretarArea(aparado);
}

int? _interpretarOpcionalInteiro(String valor) {
  final aparado = valor.trim();
  if (aparado.isEmpty) return null;
  return int.tryParse(aparado);
}
