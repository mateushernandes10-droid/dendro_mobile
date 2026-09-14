import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../aplicativo/tema/tema_dendro.dart';
import '../../../nucleo/banco/banco_dendro.dart';
import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../../exportacao_dados/apresentacao/tela_exportacao_dados.dart';
import '../../parcelas/apresentacao/tela_parcelas_talhao.dart';
import '../../talhoes/dados/repositorio_talhoes.dart';
import '../dados/selecao_modelo_levantamento.dart';
import '../dados/repositorio_levantamentos.dart';
import 'componentes/painel_selecao_modelo_levantamento.dart';

class TelaDetalheLevantamento extends ConsumerWidget {
  const TelaDetalheLevantamento({required this.levantamentoId, super.key});

  final int levantamentoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detalhe = ref.watch(provedorLevantamentoDetalhe(levantamentoId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Levantamento'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: MarcaDendro(tamanho: 32)),
          ),
        ],
      ),
      body: SafeArea(
        child: detalhe.when(
          data: (resumo) {
            if (resumo == null) {
              return const _AusenteLevantamento();
            }

            return _LevantamentoCorpo(
              resumo: resumo,
              aoConcluirLevantamento: () =>
                  _confirmarConcluirLevantamento(context, ref, resumo),
              aoExcluirLevantamento: () =>
                  _confirmarExcluirLevantamento(context, ref, resumo),
              aoExportacaoLevantamento: () => _abrirExportacao(context, resumo),
              aoEditarTalhao: (talhao) =>
                  _abrirTalhaoFormulario(context, talhao),
              aoRemoverTalhao: (talhao) =>
                  _confirmarRemoverTalhaoDeLevantamento(
                    context,
                    ref,
                    resumo,
                    talhao,
                  ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (erro, pilhaTrace) => _CarregarErro(
            aoTentarNovamente: () =>
                ref.invalidate(provedorLevantamentoDetalhe(levantamentoId)),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarConcluirLevantamento(
    BuildContext context,
    WidgetRef ref,
    LevantamentoResumo resumo,
  ) async {
    final possuiAbrirParcelas =
        resumo.abrirParcelaQuantidade > 0 || resumo.parcelaQuantidade == 0;
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          possuiAbrirParcelas
              ? Icons.warning_amber_rounded
              : Icons.check_circle_outline,
          color: possuiAbrirParcelas
              ? Colors.red.shade700
              : CoresDendro.principal,
        ),
        title: const Text('Encerrar levantamento'),
        content: Text(_concluirLevantamentoMensagem(resumo)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: possuiAbrirParcelas
                  ? Colors.red.shade700
                  : CoresDendro.principal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Encerrar'),
          ),
        ],
      ),
    );

    if (confirmado != true || !context.mounted) return;

    try {
      await ref
          .read(provedorRepositorioLevantamentos)
          .concluirLevantamento(resumo.levantamento.id);
      ref.invalidate(provedorLevantamentoDetalhe(resumo.levantamento.id));
      ref.invalidate(provedorAtivoLevantamentos);
      ref.invalidate(provedorAtivoLevantamento);

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Levantamento encerrado.')));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: const Text('Não foi possível encerrar o levantamento.'),
        ),
      );
    }
  }

  Future<void> _confirmarExcluirLevantamento(
    BuildContext context,
    WidgetRef ref,
    LevantamentoResumo resumo,
  ) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
        title: const Text('Excluir levantamento'),
        content: Text(_excluirLevantamentoMensagem(resumo)),
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
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmado != true || !context.mounted) return;

    final mensageiro = ScaffoldMessenger.of(context);
    final navegador = Navigator.of(context);

    try {
      await ref
          .read(provedorRepositorioLevantamentos)
          .excluirLevantamento(resumo.levantamento.id);
      ref.invalidate(provedorLevantamentoDetalhe(resumo.levantamento.id));
      ref.invalidate(provedorLevantamentos);
      ref.invalidate(provedorAtivoLevantamentos);
      ref.invalidate(provedorAtivoLevantamento);

      if (!context.mounted) return;
      navegador.pop();
      mensageiro.showSnackBar(
        SnackBar(
          content: Text('Levantamento de ${resumo.propriedade.nome} excluído.'),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      mensageiro.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: const Text('Não foi possível excluir o levantamento.'),
        ),
      );
    }
  }

  Future<void> _abrirTalhaoFormulario(
    BuildContext context,
    LevantamentoTalhaoResumo resumo,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _LevantamentoTalhaoFormularioPainel(
        levantamentoId: levantamentoId,
        resumo: resumo,
      ),
    );
  }

  Future<void> _abrirExportacao(
    BuildContext context,
    LevantamentoResumo resumo,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TelaExportacaoDados(
          levantamentoId: resumo.levantamento.id,
          propriedadeId: resumo.propriedade.id,
        ),
      ),
    );
  }

  Future<void> _confirmarRemoverTalhaoDeLevantamento(
    BuildContext context,
    WidgetRef ref,
    LevantamentoResumo levantamentoResumo,
    LevantamentoTalhaoResumo talhaoResumo,
  ) async {
    final possuiDados =
        talhaoResumo.parcelaQuantidade > 0 || talhaoResumo.arvoreQuantidade > 0;
    final mensagem = possuiDados
        ? 'O talhão ${talhaoResumo.talhao.identificacao} já possui ${talhaoResumo.parcelaQuantidade} ${_plural(talhaoResumo.parcelaQuantidade, 'parcela')} e ${talhaoResumo.arvoreQuantidade} ${_plural(talhaoResumo.arvoreQuantidade, 'árvore')} registrada${talhaoResumo.arvoreQuantidade == 1 ? '' : 's'} neste levantamento. Se confirmar, todos os dados desse talhão dentro do levantamento serão apagados permanentemente. O cadastro do talhão na propriedade será mantido. Deseja continuar?'
        : 'Deseja remover o talhão ${talhaoResumo.talhao.identificacao} deste levantamento? O cadastro do talhão na propriedade será mantido.';

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
        title: const Text('Remover talhão do levantamento'),
        content: Text(mensagem),
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
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmado != true || !context.mounted) return;

    try {
      await ref
          .read(provedorRepositorioLevantamentos)
          .removerTalhaoDeLevantamento(talhaoResumo.talhaoLevantamento.id);
      _invalidarAposTalhaoAlterar(ref, levantamentoResumo);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Talhão ${talhaoResumo.talhao.identificacao} removido do levantamento.',
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: const Text('Não foi possível remover o talhão.'),
        ),
      );
    }
  }

  void _invalidarAposTalhaoAlterar(
    WidgetRef ref,
    LevantamentoResumo levantamentoResumo,
  ) {
    ref.invalidate(
      provedorLevantamentoDetalhe(levantamentoResumo.levantamento.id),
    );
    ref.invalidate(provedorLevantamentos);
    ref.invalidate(provedorAtivoLevantamentos);
    ref.invalidate(provedorAtivoLevantamento);
    ref.invalidate(
      provedorPropriedadeTalhoes(levantamentoResumo.propriedade.id),
    );
    ref.invalidate(provedorLevantamentoIniciarOpcoes);
  }
}

class _LevantamentoCorpo extends StatelessWidget {
  const _LevantamentoCorpo({
    required this.resumo,
    required this.aoConcluirLevantamento,
    required this.aoExcluirLevantamento,
    required this.aoExportacaoLevantamento,
    required this.aoEditarTalhao,
    required this.aoRemoverTalhao,
  });

  final LevantamentoResumo resumo;
  final VoidCallback aoConcluirLevantamento;
  final VoidCallback aoExcluirLevantamento;
  final VoidCallback aoExportacaoLevantamento;
  final ValueChanged<LevantamentoTalhaoResumo> aoEditarTalhao;
  final ValueChanged<LevantamentoTalhaoResumo> aoRemoverTalhao;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _LevantamentoResumoCartao(resumo: resumo),
        if (resumo.levantamento.situacao ==
            SituacaoLevantamento.emAndamento) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: aoConcluirLevantamento,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Encerrar levantamento'),
            ),
          ),
        ],
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: aoExportacaoLevantamento,
            icon: const Icon(Icons.ios_share),
            label: const Text('Exportar dados'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: aoExcluirLevantamento,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Excluir levantamento'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              side: BorderSide(color: Colors.red.shade700),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: IndicadorBloco(
                rotulo: 'Árvores medidas',
                valor: resumo.arvoreQuantidade.toString(),
                icone: Icons.park_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: IndicadorBloco(
                rotulo: 'Área medida',
                valor: _formatoArea(resumo.medidaAreaHa),
                icone: Icons.area_chart_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SecaoTitulo(
          titulo: 'Talhões do levantamento',
          complemento: SituacaoIndicador(
            rotulo: '${resumo.talhoes.length} total',
          ),
        ),
        if (resumo.talhoes.isEmpty)
          const CartaoDendro(
            filho: Text(
              'Nenhum talhão vinculado a este levantamento.',
              style: TextStyle(
                color: CoresDendro.textoDiscreto,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          for (final talhao in resumo.talhoes)
            _LevantamentoTalhaoCartao(
              resumo: talhao,
              aoEditar: () => aoEditarTalhao(talhao),
              aoRemover: () => aoRemoverTalhao(talhao),
              aoAbrir: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => TelaParcelasTalhao(
                    talhaoId: talhao.talhao.id,
                    talhaoLevantamentoId: talhao.talhaoLevantamento.id,
                    mostrarIniciarLevantamentoAcao: false,
                    habilitarColetaArvores: true,
                  ),
                ),
              ),
            ),
      ],
    );
  }
}

class _LevantamentoResumoCartao extends StatelessWidget {
  const _LevantamentoResumoCartao({required this.resumo});

  final LevantamentoResumo resumo;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      fundoCor: const Color(0xFFE0F2E8),
      bordaCor: const Color(0xFFA4D1B4),
      filho: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SituacaoIndicador(
                rotulo: _situacaoRotulo(resumo.levantamento.situacao),
              ),
              const Spacer(),
              const Icon(Icons.assignment, color: CoresDendro.principal),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            resumo.propriedade.nome,
            style: const TextStyle(
              color: CoresDendro.principal,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${resumo.propriedade.municipio}-${resumo.propriedade.estado} • ${resumo.talhaoRotulo}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CoresDendro.textoDiscreto,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Iniciado em ${_formatoDataHora(resumo.levantamento.iniciadoEm)}',
            style: const TextStyle(
              color: CoresDendro.textoDiscreto,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevantamentoTalhaoCartao extends StatelessWidget {
  const _LevantamentoTalhaoCartao({
    required this.resumo,
    required this.aoAbrir,
    required this.aoEditar,
    required this.aoRemover,
  });

  final LevantamentoTalhaoResumo resumo;
  final VoidCallback aoAbrir;
  final VoidCallback aoEditar;
  final VoidCallback aoRemover;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CartaoDendro(
        espacamentoInterno: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        filho: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CoresDendro.principalSuave,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.forest, color: CoresDendro.principal),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resumo.talhao.identificacao,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        resumo.especie.nome,
                        style: const TextStyle(
                          color: CoresDendro.textoDiscreto,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        resumo.modeloMatematico.nome,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: CoresDendro.textoDiscreto,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SituacaoIndicador(
                  rotulo:
                      '${resumo.coletadaParcelaQuantidade}/${resumo.parcelaQuantidade}',
                ),
                PopupMenuButton<_LevantamentoTalhaoAcao>(
                  tooltip: 'Ações',
                  icon: const Icon(Icons.more_vert),
                  onSelected: (acao) {
                    switch (acao) {
                      case _LevantamentoTalhaoAcao.editar:
                        aoEditar();
                      case _LevantamentoTalhaoAcao.remover:
                        aoRemover();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: _LevantamentoTalhaoAcao.editar,
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 10),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: _LevantamentoTalhaoAcao.remover,
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline),
                          SizedBox(width: 10),
                          Text('Excluir'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _EmLinhaInformacao(
                    rotulo: 'Árvores',
                    valor: resumo.arvoreQuantidade.toString(),
                  ),
                ),
                Expanded(
                  child: _EmLinhaInformacao(
                    rotulo: 'Área medida',
                    valor: _formatoArea(resumo.medidaAreaHa),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: aoAbrir,
                icon: const Icon(Icons.grid_view),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CoresDendro.principal,
                  side: const BorderSide(color: CoresDendro.principal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                label: const Text('Abrir parcelas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _LevantamentoTalhaoAcao { editar, remover }

class _LevantamentoTalhaoFormularioPainel extends ConsumerStatefulWidget {
  const _LevantamentoTalhaoFormularioPainel({
    required this.levantamentoId,
    required this.resumo,
  });

  final int levantamentoId;
  final LevantamentoTalhaoResumo resumo;

  @override
  ConsumerState<_LevantamentoTalhaoFormularioPainel> createState() =>
      _LevantamentoTalhaoFormularioPainelEstado();
}

class _LevantamentoTalhaoFormularioPainelEstado
    extends ConsumerState<_LevantamentoTalhaoFormularioPainel> {
  final _chaveFormulario = GlobalKey<FormState>();
  late final TextEditingController _identificacaoControlador;
  late final TextEditingController _areaControlador;
  late final TextEditingController _plantioAnoControlador;
  late final TextEditingController _espacamentoControlador;
  late final TextEditingController _manejoRegimeControlador;
  late final TextEditingController _parcelaLarguraControlador;
  late final TextEditingController _parcelaComprimentoControlador;
  late final TextEditingController _observacoesControlador;
  LevantamentoModeloMatematicoSelecao? _modeloMatematicoSelecao;
  int? _especieId;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    final talhao = widget.resumo.talhao;

    _identificacaoControlador = TextEditingController(
      text: talhao.identificacao,
    );
    _areaControlador = TextEditingController(
      text: talhao.areaHa.toStringAsFixed(2).replaceAll('.', ','),
    );
    _plantioAnoControlador = TextEditingController(
      text: talhao.anoPlantio?.toString() ?? '',
    );
    _espacamentoControlador = TextEditingController(
      text: talhao.espacamento ?? '',
    );
    _manejoRegimeControlador = TextEditingController(
      text: talhao.regimeManejo ?? '',
    );
    _parcelaLarguraControlador = TextEditingController(
      text: talhao.larguraParcelaM == null
          ? ''
          : talhao.larguraParcelaM!.toStringAsFixed(2).replaceAll('.', ','),
    );
    _parcelaComprimentoControlador = TextEditingController(
      text: talhao.comprimentoParcelaM == null
          ? ''
          : talhao.comprimentoParcelaM!.toStringAsFixed(2).replaceAll('.', ','),
    );
    _observacoesControlador = TextEditingController(
      text: talhao.observacoes ?? '',
    );
    _especieId = widget.resumo.talhaoLevantamento.especieId;
    _modeloMatematicoSelecao = LevantamentoModeloMatematicoSelecao(
      modeloMatematicoId: widget.resumo.talhaoLevantamento.modeloMatematicoId,
      modeloMatematicoNome: widget.resumo.modeloMatematico.nome,
      coeficienteValoresPorSimbolo: {
        for (final coeficiente in widget.resumo.coeficientesModelo)
          coeficiente.simbolo: coeficiente.valor,
      },
    );
  }

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
    final especies = ref.watch(provedorAtivoEspecie);
    final inferiorRecuo = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: inferiorRecuo),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
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
                      'Editar talhão do levantamento',
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
                validator: _obrigatorioValidator,
              ),
              const SizedBox(height: 12),
              especies.when(
                data: (itens) {
                  _sincronizarEspecieSelecao(itens);
                  return DropdownButtonFormField<int>(
                    key: ValueKey('inventory-stand-species-$_especieId'),
                    initialValue: _especieId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Espécie',
                      prefixIcon: Icon(Icons.eco_outlined),
                    ),
                    items: [
                      for (final item in itens)
                        DropdownMenuItem(
                          value: item.id,
                          child: Text(
                            item.nome,
                            overflow: TextOverflow.ellipsis,
                          ),
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
              _LevantamentoModeloMatematicoAjusteCartao(
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
                      validator: _plantioAnoValidator,
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
              ParcelaDimensoesEntrada(
                larguraControlador: _parcelaLarguraControlador,
                comprimentoControlador: _parcelaComprimentoControlador,
                larguraValidator: (valor) => _parcelaDimensaoValidator(
                  valor,
                  _parcelaComprimentoControlador.text,
                  'primeira medida',
                ),
                comprimentoValidator: (valor) => _parcelaDimensaoValidator(
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
                  label: Text(_salvando ? 'Salvando...' : 'Salvar alterações'),
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
      await ref
          .read(provedorRepositorioLevantamentos)
          .atualizarTalhaoInLevantamento(
            talhaoLevantamentoId: widget.resumo.talhaoLevantamento.id,
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
            modeloMatematicoSelecao: _modeloMatematicoSelecao,
          );

      ref.invalidate(provedorLevantamentoDetalhe(widget.levantamentoId));
      ref.invalidate(provedorLevantamentos);
      ref.invalidate(provedorAtivoLevantamentos);
      ref.invalidate(provedorAtivoLevantamento);
      ref.invalidate(
        provedorPropriedadeTalhoes(widget.resumo.talhao.propriedadeId),
      );
      ref.invalidate(provedorLevantamentoIniciarOpcoes);

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Talhão atualizado.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: const Text('Não foi possível salvar o talhão.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _ajustarModeloMatematico() async {
    final selecao = await mostrarLevantamentoModeloMatematicoSelecaoPainel(
      context: context,
      especieId: _especieId!,
      inicialSelecao: _modeloMatematicoSelecao,
    );

    if (selecao == null || !mounted) return;

    setState(() => _modeloMatematicoSelecao = selecao);
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

  String? _obrigatorioValidator(String? valor) {
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

  String? _plantioAnoValidator(String? valor) {
    if (valor == null || valor.trim().isEmpty) return null;

    final ano = int.tryParse(valor.trim());
    if (ano == null) return 'Ano inválido';
    if (ano < 1900 || ano > DateTime.now().year + 1) {
      return 'Confira o ano';
    }
    return null;
  }

  String? _parcelaDimensaoValidator(
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

class _EmLinhaInformacao extends StatelessWidget {
  const _EmLinhaInformacao({required this.rotulo, required this.valor});

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
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _LevantamentoModeloMatematicoAjusteCartao extends StatelessWidget {
  const _LevantamentoModeloMatematicoAjusteCartao({
    required this.selecao,
    required this.aoPressionado,
  });

  final LevantamentoModeloMatematicoSelecao? selecao;
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

class _AusenteLevantamento extends StatelessWidget {
  const _AusenteLevantamento();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: CartaoDendro(
          filho: Text(
            'Levantamento não encontrado.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

class _CarregarErro extends StatelessWidget {
  const _CarregarErro({required this.aoTentarNovamente});

  final VoidCallback aoTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CartaoDendro(
          filho: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(height: 10),
              const Text(
                'Não foi possível carregar o levantamento.',
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
        ),
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

String _concluirLevantamentoMensagem(LevantamentoResumo resumo) {
  if (resumo.parcelaQuantidade == 0) {
    return 'Esse levantamento ainda não possui parcelas cadastradas. Deseja encerrar mesmo assim?';
  }

  if (resumo.abrirParcelaQuantidade > 0) {
    return 'Existem ${resumo.abrirParcelaQuantidade} ${_plural(resumo.abrirParcelaQuantidade, 'parcela')} ainda não ${_plural(resumo.abrirParcelaQuantidade, 'coletada')}. Se confirmar, o levantamento será encerrado e deixará de aparecer em andamento.';
  }

  return 'Encerrar o levantamento com ${resumo.coletadaParcelaQuantidade} ${_plural(resumo.coletadaParcelaQuantidade, 'parcela')} ${_plural(resumo.coletadaParcelaQuantidade, 'coletada')}?';
}

String _excluirLevantamentoMensagem(LevantamentoResumo resumo) {
  final talhaoTexto = resumo.talhoes.isEmpty
      ? 'nenhum talhão vinculado'
      : resumo.talhoes.length == 1
      ? '1 talhão vinculado'
      : '${resumo.talhoes.length} talhões vinculados';

  return 'Deseja realmente excluir este levantamento de ${resumo.propriedade.nome}? '
      'Ele possui $talhaoTexto, ${resumo.parcelaQuantidade} ${_plural(resumo.parcelaQuantidade, 'parcela')} e ${resumo.arvoreQuantidade} ${_plural(resumo.arvoreQuantidade, 'árvore')} registrada${resumo.arvoreQuantidade == 1 ? '' : 's'}. '
      'Todos os dados salvos nesse levantamento, incluindo parcelas, árvores e coordenadas, serão apagados permanentemente e não poderão ser recuperados.';
}

String _plural(int quantidade, String singular) {
  if (quantidade == 1) return singular;
  return '${singular}s';
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

String _formatoDataHora(DateTime valor) {
  final dia = valor.day.toString().padLeft(2, '0');
  final mes = valor.month.toString().padLeft(2, '0');
  final ano = valor.year.toString();
  final hora = valor.hour.toString().padLeft(2, '0');
  final minuto = valor.minute.toString().padLeft(2, '0');

  return '$dia/$mes/$ano às $hora:$minuto';
}
