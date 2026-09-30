import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../aplicativo/tema/tema_dendro.dart';
import '../../../nucleo/banco/banco_dendro.dart';
import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../dados/selecao_modelo_levantamento.dart';
import '../dados/repositorio_levantamentos.dart';
import 'componentes/painel_selecao_modelo_levantamento.dart';
import '../../parcelas/dados/repositorio_parcelas.dart';
import '../../propriedades/apresentacao/tela_propriedades.dart';
import '../../talhoes/dados/repositorio_talhoes.dart';

class TelaNovoLevantamento extends ConsumerStatefulWidget {
  const TelaNovoLevantamento({super.key});

  @override
  ConsumerState<TelaNovoLevantamento> createState() =>
      _NovoLevantamentoTelaEstado();
}

class _NovoLevantamentoTelaEstado extends ConsumerState<TelaNovoLevantamento> {
  static const _todosFiltroValor = '__all__';
  static const _todasEspeciesValor = -1;

  final _buscaControlador = TextEditingController();
  String? _municipioFiltro;
  int? _especieIdFiltro;
  int? _salvandoTalhaoId;
  String? _erroMensagem;
  final Map<int, SelecaoModeloLevantamento> _selecoesModeloPorTalhaoId = {};
  final Map<int, double> _errosAmostraisPorTalhaoId = {};

  @override
  void initState() {
    super.initState();
    _buscaControlador.addListener(_aoBuscaAlterado);
  }

  @override
  void dispose() {
    _buscaControlador
      ..removeListener(_aoBuscaAlterado)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opcoes = ref.watch(provedorOpcoesNovoLevantamento);
    final especies = ref.watch(provedorEspeciesAtivas);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'new_inventory_new_property',
        onPressed: _salvandoTalhaoId == null ? _criarPropriedade : null,
        tooltip: 'Nova propriedade',
        child: const Icon(Icons.add_home_work),
      ),
      appBar: AppBar(
        title: const Text('Novo levantamento'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: MarcaDendro(tamanho: 32),
          ),
        ],
      ),
      body: SafeArea(
        child: opcoes.when(
          data: (itens) {
            final visivelOpcoes = _visivelOpcoes(itens);
            final municipioOpcoes = _municipioOpcoes(itens);

            return ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              children: [
                _LevantamentoIniciarFiltros(
                  buscaControlador: _buscaControlador,
                  municipioOpcoes: municipioOpcoes,
                  selecionadoMunicipio: _municipioFiltro,
                  selecionadoEspecieId: _especieIdFiltro,
                  especies: especies,
                  aoMunicipioAlterado: (valor) => setState(() {
                    _municipioFiltro = valor == _todosFiltroValor
                        ? null
                        : valor;
                    _erroMensagem = null;
                  }),
                  aoEspecieAlterado: (valor) => setState(() {
                    _especieIdFiltro = valor == _todasEspeciesValor
                        ? null
                        : valor;
                    _erroMensagem = null;
                  }),
                  aoLimpar: _possuiFiltros ? _limparFiltros : null,
                ),
                if (_erroMensagem != null) ...[
                  const SizedBox(height: 12),
                  _IniciarErroAviso(mensagem: _erroMensagem!),
                ],
                const SizedBox(height: 18),
                TituloSecao(
                  titulo: 'Propriedades',
                  complemento: IndicadorSituacao(
                    rotulo: '${visivelOpcoes.length} resultado(s)',
                  ),
                ),
                if (itens.isEmpty)
                  const _VazioIniciarCartao(
                    icone: Icons.map_outlined,
                    titulo: 'Nenhuma propriedade cadastrada',
                    mensagem:
                        'Cadastre uma propriedade e seus talhões antes de iniciar a coleta.',
                  )
                else if (visivelOpcoes.isEmpty)
                  _VazioIniciarCartao(
                    icone: Icons.search_off,
                    titulo: 'Nada encontrado',
                    mensagem:
                        'Ajuste a busca ou os filtros para encontrar a propriedade desejada.',
                    acao: OutlinedButton.icon(
                      onPressed: _limparFiltros,
                      icon: const Icon(Icons.filter_alt_off),
                      label: const Text('Limpar filtros'),
                    ),
                  )
                else
                  for (final opcao in visivelOpcoes) ...[
                    _LevantamentoIniciarPropriedadeGrupo(
                      opcao: opcao,
                      salvandoTalhaoId: _salvandoTalhaoId,
                      aoCriarTalhao: () => _abrirNovoTalhaoPainel(
                        propriedadeId: opcao.propriedade.id,
                      ),
                      aoIniciar: _iniciarTalhao,
                      modeloMatematicoSelecaoParaTalhao: (talhaoId) =>
                          _selecoesModeloPorTalhaoId[talhaoId],
                      aoAjustarModeloMatematico: _ajustarModeloMatematico,
                      erroAmostralParaTalhao: (talhaoId) =>
                          _errosAmostraisPorTalhaoId[talhaoId] ?? 3.0,
                      aoAjustarErroAmostral: _ajustarErroAmostral,
                    ),
                    const SizedBox(height: 18),
                  ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (erro, pilhaTrace) => _CarregarIniciarOpcoesErro(
            aoTentarNovamente: () =>
                ref.invalidate(provedorOpcoesNovoLevantamento),
          ),
        ),
      ),
    );
  }

  bool get _possuiFiltros =>
      _buscaControlador.text.trim().isNotEmpty ||
      _municipioFiltro != null ||
      _especieIdFiltro != null;

  Future<void> _criarPropriedade() async {
    final salvo = await mostrarPropriedadeFormularioPainel(context);
    if (salvo != true || !mounted) return;
    _limparFiltros();
    ref.invalidate(provedorOpcoesNovoLevantamento);
  }

  void _aoBuscaAlterado() {
    setState(() => _erroMensagem = null);
  }

  void _limparFiltros() {
    setState(() {
      _buscaControlador.clear();
      _municipioFiltro = null;
      _especieIdFiltro = null;
      _erroMensagem = null;
    });
  }

  List<OpcaoPropriedadeNovoLevantamento> _visivelOpcoes(
    List<OpcaoPropriedadeNovoLevantamento> opcoes,
  ) {
    final consulta = _buscaControlador.text.trim().toLowerCase();

    final visivelOpcoes = <OpcaoPropriedadeNovoLevantamento>[];
    for (final opcao in opcoes) {
      final propriedade = opcao.propriedade;
      final correspondenciasBusca =
          consulta.isEmpty || propriedade.nome.toLowerCase().contains(consulta);
      final correspondenciasMunicipio =
          _municipioFiltro == null ||
          _municipioRotulo(propriedade) == _municipioFiltro;

      if (!correspondenciasBusca || !correspondenciasMunicipio) continue;

      final talhoes = _especieIdFiltro == null
          ? opcao.talhoes
          : opcao.talhoes
                .where((resumo) => resumo.especie.id == _especieIdFiltro)
                .toList();

      if (_especieIdFiltro != null && talhoes.isEmpty) continue;
      visivelOpcoes.add(opcao.copyWith(talhoes: talhoes));
    }

    return visivelOpcoes;
  }

  List<String> _municipioOpcoes(List<OpcaoPropriedadeNovoLevantamento> opcoes) {
    final municipios = {
      for (final opcao in opcoes) _municipioRotulo(opcao.propriedade),
    }.toList()..sort();

    return municipios;
  }

  Future<void> _iniciarTalhao(TalhaoResumo resumo) async {
    if (_salvandoTalhaoId != null) return;

    setState(() {
      _salvandoTalhaoId = resumo.talhao.id;
      _erroMensagem = null;
    });

    try {
      final talhaoLevantamento = await ref
          .read(provedorRepositorioParcelas)
          .iniciarNovoLevantamentoParaTalhao(
            resumo.talhao.id,
            modeloMatematicoSelecao:
                _selecoesModeloPorTalhaoId[resumo.talhao.id],
            erroAmostralMaximoPercentual:
                _errosAmostraisPorTalhaoId[resumo.talhao.id] ?? 3.0,
          );

      _invalidarIniciarProvedores(resumo.talhao.id);

      if (!mounted) return;
      Navigator.of(context).pop(talhaoLevantamento.levantamentoId);
    } on ExcecaoLevantamentoAtivoNoTalhao catch (erro) {
      _invalidarIniciarProvedores(resumo.talhao.id);

      if (!mounted) return;
      Navigator.of(context).pop(erro.existente.levantamentoId);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _erroMensagem = 'Não foi possível iniciar o levantamento.';
      });
    } finally {
      if (mounted) setState(() => _salvandoTalhaoId = null);
    }
  }

  Future<void> _ajustarModeloMatematico(TalhaoResumo resumo) async {
    final selecao = await mostrarLevantamentoModeloMatematicoSelecaoPainel(
      context: context,
      especieId: resumo.especie.id,
      inicialSelecao: _selecoesModeloPorTalhaoId[resumo.talhao.id],
    );

    if (selecao == null || !mounted) return;

    setState(() {
      _selecoesModeloPorTalhaoId[resumo.talhao.id] = selecao;
      _erroMensagem = null;
    });
  }

  Future<void> _ajustarErroAmostral(TalhaoResumo resumo) async {
    final valor = await _mostrarErroAmostralDialogo(
      context,
      inicial: _errosAmostraisPorTalhaoId[resumo.talhao.id] ?? 3.0,
    );
    if (valor == null || !mounted) return;
    setState(() {
      _errosAmostraisPorTalhaoId[resumo.talhao.id] = valor;
      _erroMensagem = null;
    });
  }

  Future<void> _abrirNovoTalhaoPainel({required int propriedadeId}) async {
    final criacao = await showModalBottomSheet<_ResultadoCadastroRapidoTalhao>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) =>
          _PainelCadastroRapidoTalhao(propriedadeId: propriedadeId),
    );

    if (criacao == null || !mounted) return;

    ref.invalidate(provedorOpcoesNovoLevantamento);
    ref.invalidate(provedorTalhoesDaPropriedade(propriedadeId));
    if (criacao.modeloMatematicoSelecao == null) {
      _selecoesModeloPorTalhaoId.remove(criacao.talhaoId);
    } else {
      _selecoesModeloPorTalhaoId[criacao.talhaoId] =
          criacao.modeloMatematicoSelecao!;
    }
    _errosAmostraisPorTalhaoId[criacao.talhaoId] =
        criacao.erroAmostralMaximoPercentual;

    final resumo = await ref
        .read(provedorRepositorioTalhoes)
        .obterResumo(criacao.talhaoId);
    if (resumo == null || !mounted) return;

    await _iniciarTalhao(resumo);
  }

  void _invalidarIniciarProvedores(int talhaoId) {
    ref.invalidate(provedorOpcoesNovoLevantamento);
    ref.invalidate(provedorLevantamentosAtivos);
    ref.invalidate(provedorLevantamentoAtivo);
    ref.invalidate(provedorParcelasTalhao(talhaoId));
  }
}

class _LevantamentoIniciarFiltros extends StatelessWidget {
  const _LevantamentoIniciarFiltros({
    required this.buscaControlador,
    required this.municipioOpcoes,
    required this.selecionadoMunicipio,
    required this.selecionadoEspecieId,
    required this.especies,
    required this.aoMunicipioAlterado,
    required this.aoEspecieAlterado,
    required this.aoLimpar,
  });

  final TextEditingController buscaControlador;
  final List<String> municipioOpcoes;
  final String? selecionadoMunicipio;
  final int? selecionadoEspecieId;
  final AsyncValue<List<Especie>> especies;
  final ValueChanged<String?> aoMunicipioAlterado;
  final ValueChanged<int?> aoEspecieAlterado;
  final VoidCallback? aoLimpar;

  @override
  Widget build(BuildContext context) {
    final estaEscuro = Theme.of(context).brightness == Brightness.dark;
    final campoCor = estaEscuro ? CoresDendro.escuroLegivelCampo : Colors.white;

    return CartaoDendro(
      fundoCor: const Color(0xFFEAF7EF),
      bordaCor: const Color(0xFFA4D1B4),
      filho: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: buscaControlador,
            textInputAction: TextInputAction.search,
            style: const TextStyle(
              color: CoresDendro.texto,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              labelText: 'Buscar propriedade',
              labelStyle: const TextStyle(
                color: CoresDendro.textoDiscreto,
                fontWeight: FontWeight.w700,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: CoresDendro.principal,
              ),
              fillColor: campoCor,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey(
              'city-${selecionadoMunicipio ?? _NovoLevantamentoTelaEstado._todosFiltroValor}',
            ),
            isExpanded: true,
            initialValue:
                selecionadoMunicipio ??
                _NovoLevantamentoTelaEstado._todosFiltroValor,
            style: const TextStyle(
              color: CoresDendro.texto,
              fontWeight: FontWeight.w700,
            ),
            dropdownColor: campoCor,
            iconEnabledColor: CoresDendro.principal,
            decoration: InputDecoration(
              labelText: 'Município',
              labelStyle: const TextStyle(
                color: CoresDendro.textoDiscreto,
                fontWeight: FontWeight.w700,
              ),
              prefixIcon: const Icon(
                Icons.location_city_outlined,
                color: CoresDendro.principal,
              ),
              fillColor: campoCor,
            ),
            items: [
              const DropdownMenuItem(
                value: _NovoLevantamentoTelaEstado._todosFiltroValor,
                child: Text('Todos os municípios'),
              ),
              for (final municipio in municipioOpcoes)
                DropdownMenuItem(
                  value: municipio,
                  child: Text(municipio, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: aoMunicipioAlterado,
          ),
          const SizedBox(height: 12),
          especies.when(
            data: (itens) => DropdownButtonFormField<int>(
              key: ValueKey(
                'species-${selecionadoEspecieId ?? _NovoLevantamentoTelaEstado._todasEspeciesValor}',
              ),
              isExpanded: true,
              initialValue:
                  selecionadoEspecieId ??
                  _NovoLevantamentoTelaEstado._todasEspeciesValor,
              style: const TextStyle(
                color: CoresDendro.texto,
                fontWeight: FontWeight.w700,
              ),
              dropdownColor: campoCor,
              iconEnabledColor: CoresDendro.principal,
              decoration: InputDecoration(
                labelText: 'Espécie',
                labelStyle: const TextStyle(
                  color: CoresDendro.textoDiscreto,
                  fontWeight: FontWeight.w700,
                ),
                prefixIcon: const Icon(
                  Icons.eco_outlined,
                  color: CoresDendro.principal,
                ),
                fillColor: campoCor,
              ),
              items: [
                const DropdownMenuItem(
                  value: _NovoLevantamentoTelaEstado._todasEspeciesValor,
                  child: Text('Todas as espécies'),
                ),
                for (final item in itens)
                  DropdownMenuItem(
                    value: item.id,
                    child: Text(item.nome, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: aoEspecieAlterado,
            ),
            loading: () => const LinearProgressIndicator(),
            error: (erro, pilhaTrace) => const Text(
              'Não foi possível carregar as espécies.',
              style: TextStyle(
                color: CoresDendro.textoDiscreto,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (aoLimpar != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: aoLimpar,
                icon: const Icon(Icons.filter_alt_off),
                label: const Text('Limpar filtros'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LevantamentoIniciarPropriedadeGrupo extends StatelessWidget {
  const _LevantamentoIniciarPropriedadeGrupo({
    required this.opcao,
    required this.salvandoTalhaoId,
    required this.aoCriarTalhao,
    required this.aoIniciar,
    required this.modeloMatematicoSelecaoParaTalhao,
    required this.aoAjustarModeloMatematico,
    required this.erroAmostralParaTalhao,
    required this.aoAjustarErroAmostral,
  });

  final OpcaoPropriedadeNovoLevantamento opcao;
  final int? salvandoTalhaoId;
  final VoidCallback aoCriarTalhao;
  final ValueChanged<TalhaoResumo> aoIniciar;
  final SelecaoModeloLevantamento? Function(int talhaoId)
  modeloMatematicoSelecaoParaTalhao;
  final ValueChanged<TalhaoResumo> aoAjustarModeloMatematico;
  final double Function(int talhaoId) erroAmostralParaTalhao;
  final ValueChanged<TalhaoResumo> aoAjustarErroAmostral;

  @override
  Widget build(BuildContext context) {
    final propriedade = opcao.propriedade;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PropriedadeGrupoCabecalho(
          propriedade: propriedade,
          talhaoQuantidade: opcao.talhoes.length,
        ),
        const SizedBox(height: 8),
        if (opcao.talhoes.isEmpty)
          _VazioIniciarCartao(
            icone: Icons.forest_outlined,
            titulo: 'Nenhum talhão cadastrado',
            mensagem:
                'Cadastre um talhão nessa propriedade para iniciar o levantamento.',
            acao: OutlinedButton.icon(
              onPressed: aoCriarTalhao,
              icon: const Icon(Icons.add),
              label: const Text('Novo talhão'),
            ),
          )
        else ...[
          for (final resumo in opcao.talhoes) ...[
            _IniciarTalhaoCartao(
              resumo: resumo,
              salvando: salvandoTalhaoId == resumo.talhao.id,
              desabilitado:
                  salvandoTalhaoId != null &&
                  salvandoTalhaoId != resumo.talhao.id,
              modeloMatematicoSelecao: modeloMatematicoSelecaoParaTalhao(
                resumo.talhao.id,
              ),
              aoAjustarModeloMatematico: () =>
                  aoAjustarModeloMatematico(resumo),
              erroAmostralMaximoPercentual: erroAmostralParaTalhao(
                resumo.talhao.id,
              ),
              aoAjustarErroAmostral: () => aoAjustarErroAmostral(resumo),
              aoIniciar: () => aoIniciar(resumo),
            ),
            const SizedBox(height: 8),
          ],
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: salvandoTalhaoId == null ? aoCriarTalhao : null,
              icon: const Icon(Icons.add),
              label: const Text('Novo talhão'),
            ),
          ),
        ],
      ],
    );
  }
}

class _PropriedadeGrupoCabecalho extends StatelessWidget {
  const _PropriedadeGrupoCabecalho({
    required this.propriedade,
    required this.talhaoQuantidade,
  });

  final Propriedade propriedade;
  final int talhaoQuantidade;

  @override
  Widget build(BuildContext context) {
    final corEsquema = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: CoresDendro.principalSuave,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.map_outlined, color: CoresDendro.principal),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                propriedade.nome,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ).copyWith(color: corEsquema.onSurface),
              ),
              const SizedBox(height: 2),
              Text(
                _municipioRotulo(propriedade),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: corEsquema.onSurface.withValues(alpha: 0.72),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        IndicadorSituacao(rotulo: _talhaoQuantidadeRotulo(talhaoQuantidade)),
      ],
    );
  }
}

class _IniciarTalhaoCartao extends StatelessWidget {
  const _IniciarTalhaoCartao({
    required this.resumo,
    required this.salvando,
    required this.desabilitado,
    required this.modeloMatematicoSelecao,
    required this.aoAjustarModeloMatematico,
    required this.erroAmostralMaximoPercentual,
    required this.aoAjustarErroAmostral,
    required this.aoIniciar,
  });

  final TalhaoResumo resumo;
  final bool salvando;
  final bool desabilitado;
  final SelecaoModeloLevantamento? modeloMatematicoSelecao;
  final VoidCallback aoAjustarModeloMatematico;
  final double erroAmostralMaximoPercentual;
  final VoidCallback aoAjustarErroAmostral;
  final VoidCallback aoIniciar;

  @override
  Widget build(BuildContext context) {
    final ativo = resumo.possuiAtivoLevantamento;

    return CartaoDendro(
      fundoCor: ativo ? const Color(0xFFE0F2E8) : Colors.white,
      bordaCor: ativo ? const Color(0xFFA4D1B4) : CoresDendro.contorno,
      filho: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  resumo.talhao.identificacao,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: CoresDendro.principal,
                  ),
                ),
              ),
              if (ativo) const IndicadorSituacao(rotulo: 'Em coleta'),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _TalhaoMetadados(
                icone: Icons.eco_outlined,
                rotulo: resumo.especie.nome,
              ),
              _TalhaoMetadados(
                icone: Icons.area_chart_outlined,
                rotulo: _formatoArea(resumo.talhao.areaHa),
              ),
              _TalhaoMetadados(
                icone: Icons.history,
                rotulo: _historicoRotulo(resumo.talhaoLevantamentoQuantidade),
              ),
            ],
          ),
          if (!ativo) ...[
            const SizedBox(height: 12),
            _ModeloMatematicoAjusteBotao(
              selecao: modeloMatematicoSelecao,
              aoPressionado: desabilitado || salvando
                  ? null
                  : aoAjustarModeloMatematico,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: desabilitado || salvando
                  ? null
                  : aoAjustarErroAmostral,
              icon: const Icon(Icons.analytics_outlined),
              label: Text(
                'Erro amostral máximo: ${_formatarPercentual(erroAmostralMaximoPercentual)}',
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: desabilitado || salvando ? null : aoIniciar,
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresDendro.escuroAcao,
                foregroundColor: Colors.white,
                disabledBackgroundColor: CoresDendro.escuroLegivelCampo,
                disabledForegroundColor: CoresDendro.textoDiscreto,
              ),
              icon: salvando
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(ativo ? Icons.forest : Icons.play_arrow_rounded),
              label: Text(
                salvando
                    ? 'Abrindo...'
                    : ativo
                    ? 'Continuar coleta'
                    : 'Iniciar levantamento',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TalhaoMetadados extends StatelessWidget {
  const _TalhaoMetadados({required this.icone, required this.rotulo});

  final IconData icone;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icone, size: 15, color: CoresDendro.textoDiscreto),
        const SizedBox(width: 4),
        Text(
          rotulo,
          style: const TextStyle(
            color: CoresDendro.textoDiscreto,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ModeloMatematicoAjusteBotao extends StatelessWidget {
  const _ModeloMatematicoAjusteBotao({
    required this.selecao,
    required this.aoPressionado,
  });

  final SelecaoModeloLevantamento? selecao;
  final VoidCallback? aoPressionado;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: aoPressionado,
      icon: Icon(selecao == null ? Icons.functions : Icons.tune),
      style: OutlinedButton.styleFrom(
        foregroundColor: CoresDendro.principal,
        disabledForegroundColor: CoresDendro.textoDiscreto,
        side: BorderSide(
          color: aoPressionado == null
              ? CoresDendro.contorno
              : CoresDendro.principal,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      label: Text(
        selecao == null
            ? 'Ajustar modelo matemático'
            : 'Modelo ajustado: ${selecao!.modeloMatematicoNome ?? 'personalizado'}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _IniciarErroAviso extends StatelessWidget {
  const _IniciarErroAviso({required this.mensagem});

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

class _CarregarIniciarOpcoesErro extends StatelessWidget {
  const _CarregarIniciarOpcoesErro({required this.aoTentarNovamente});

  final VoidCallback aoTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _VazioIniciarCartao(
          icone: Icons.error_outline,
          titulo: 'Não foi possível carregar',
          mensagem: 'Tente novamente para escolher propriedade e talhão.',
          acao: OutlinedButton.icon(
            onPressed: aoTentarNovamente,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ),
      ),
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
  final _erroAmostralControlador = TextEditingController(text: '3,0');
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
    _erroAmostralControlador.dispose();
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
                    isExpanded: true,
                    initialValue: _especieId,
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
                controller: _erroAmostralControlador,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Erro amostral máximo (%)',
                  prefixIcon: Icon(Icons.analytics_outlined),
                  helperText: 'Valor inicial recomendado: 3%',
                ),
                validator: _validarErroAmostral,
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
      ref.invalidate(provedorOpcoesNovoLevantamento);

      if (!mounted) return;
      Navigator.of(context).pop(
        _ResultadoCadastroRapidoTalhao(
          talhaoId: talhaoId,
          modeloMatematicoSelecao: _modeloMatematicoSelecao,
          erroAmostralMaximoPercentual: _interpretarArea(
            _erroAmostralControlador.text,
          )!,
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

  String? _validarErroAmostral(String? valor) {
    final erro = _interpretarArea(valor ?? '');
    if (erro == null || erro <= 0 || erro >= 100) {
      return 'Informe um percentual entre 0 e 100';
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
    required this.erroAmostralMaximoPercentual,
  });

  final int talhaoId;
  final SelecaoModeloLevantamento? modeloMatematicoSelecao;
  final double erroAmostralMaximoPercentual;
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

String _municipioRotulo(Propriedade propriedade) {
  return '${propriedade.municipio}-${propriedade.estado}';
}

String _talhaoQuantidadeRotulo(int quantidade) {
  if (quantidade == 1) return '1 talhão';
  return '$quantidade talhões';
}

String _historicoRotulo(int quantidade) {
  if (quantidade == 0) return 'Sem histórico';
  if (quantidade == 1) return '1 levantamento';
  return '$quantidade levantamentos';
}

String _formatoArea(double valor) {
  return '${valor.toStringAsFixed(2).replaceAll('.', ',')} ha';
}

String _formatarPercentual(double valor) {
  return '${valor.toStringAsFixed(1).replaceAll('.', ',')}%';
}

Future<double?> _mostrarErroAmostralDialogo(
  BuildContext context, {
  required double inicial,
}) async {
  final controlador = TextEditingController(
    text: inicial.toStringAsFixed(1).replaceAll('.', ','),
  );
  String? erro;
  final resultado = await showDialog<double>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, definirEstado) => AlertDialog(
        title: const Text('Erro amostral máximo'),
        content: TextField(
          controller: controlador,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
          ],
          decoration: InputDecoration(
            labelText: 'Percentual',
            suffixText: '%',
            helperText: 'Valor inicial recomendado: 3%',
            errorText: erro,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final valor = _interpretarArea(controlador.text);
              if (valor == null || valor <= 0 || valor >= 100) {
                definirEstado(
                  () => erro = 'Informe um percentual entre 0 e 100',
                );
                return;
              }
              Navigator.of(context).pop(valor);
            },
            child: const Text('Aplicar'),
          ),
        ],
      ),
    ),
  );
  controlador.dispose();
  return resultado;
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
