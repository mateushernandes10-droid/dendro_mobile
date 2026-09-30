import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../aplicativo/tema/tema_dendro.dart';
import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../../../nucleo/banco/banco_dendro.dart';
import '../../exportacao_dados/apresentacao/tela_exportacao_dados.dart';
import '../dados/repositorio_resultados.dart';

const _todosFiltroValor = -1;

class TelaResultados extends ConsumerStatefulWidget {
  const TelaResultados({
    this.inicialPropriedadeId,
    this.inicialLevantamentoId,
    this.inicialTalhaoIds = const {},
    this.inicialEspecieId,
    super.key,
  });

  final int? inicialPropriedadeId;
  final int? inicialLevantamentoId;
  final Set<int> inicialTalhaoIds;
  final int? inicialEspecieId;

  @override
  ConsumerState<TelaResultados> createState() => _ResultadosTelaEstado();
}

class _ResultadosTelaEstado extends ConsumerState<TelaResultados> {
  bool _aplicadoInicialFiltros = false;
  bool _restaurarAnteriorFiltros = false;
  int? _anteriorPropriedadeId;
  int? _anteriorLevantamentoId;
  Set<int> _anteriorTalhaoIds = const {};
  int? _anteriorEspecieId;

  bool get _possuiInicialFiltros =>
      widget.inicialPropriedadeId != null ||
      widget.inicialLevantamentoId != null ||
      widget.inicialTalhaoIds.isNotEmpty ||
      widget.inicialEspecieId != null;

  @override
  void initState() {
    super.initState();
    _aplicarInicialFiltros();
  }

  @override
  void dispose() {
    if (_restaurarAnteriorFiltros) {
      ref.read(provedorFiltroPropriedadeResultados.notifier).state =
          _anteriorPropriedadeId;
      ref.read(provedorFiltroLevantamentoResultados.notifier).state =
          _anteriorLevantamentoId;
      ref.read(provedorFiltroTalhoesResultados.notifier).state =
          _anteriorTalhaoIds;
      ref.read(provedorFiltroEspecieResultados.notifier).state =
          _anteriorEspecieId;
    }
    super.dispose();
  }

  void _aplicarInicialFiltros() {
    if (_aplicadoInicialFiltros) return;
    _aplicadoInicialFiltros = true;

    if (!_possuiInicialFiltros) return;

    _restaurarAnteriorFiltros = true;
    _anteriorPropriedadeId = ref.read(provedorFiltroPropriedadeResultados);
    _anteriorLevantamentoId = ref.read(provedorFiltroLevantamentoResultados);
    _anteriorTalhaoIds = {...ref.read(provedorFiltroTalhoesResultados)};
    _anteriorEspecieId = ref.read(provedorFiltroEspecieResultados);

    ref.read(provedorFiltroPropriedadeResultados.notifier).state =
        widget.inicialPropriedadeId;
    ref.read(provedorFiltroLevantamentoResultados.notifier).state =
        widget.inicialLevantamentoId;
    ref.read(provedorFiltroTalhoesResultados.notifier).state = {
      ...widget.inicialTalhaoIds,
    };
    ref.read(provedorFiltroEspecieResultados.notifier).state =
        widget.inicialEspecieId;
  }

  @override
  Widget build(BuildContext context) {
    final propriedadeId = ref.watch(provedorFiltroPropriedadeResultados);
    final levantamentoId = ref.watch(provedorFiltroLevantamentoResultados);
    final especieId = ref.watch(provedorFiltroEspecieResultados);
    final talhaoIds = ref.watch(provedorFiltroTalhoesResultados);
    final possuiBaseFiltro = _possuiBaseFiltro(
      propriedadeId,
      levantamentoId,
      especieId,
      talhaoIds,
    );
    final opcoes = ref.watch(provedorOpcoesFiltrosResultados);
    final painel = ref.watch(provedorPainelResultados);

    return TelaDendro(
      titulo: 'Resultados',
      icone: Icons.bar_chart,
      flutuanteAcaoBotao: FloatingActionButton(
        heroTag: 'results_export',
        onPressed: () => _abrirExportacao(context, ref),
        tooltip: 'Exportar',
        child: const Icon(Icons.ios_share),
      ),
      filhos: [
        opcoes.when(
          data: (dados) => _FiltroCartao(opcoes: dados),
          loading: () => const CartaoDendro(filho: LinearProgressIndicator()),
          error: (erro, pilhaTrace) => _CartaoErroCarregamento(
            mensagem: 'Não foi possível carregar os filtros.',
            aoTentarNovamente: () =>
                ref.invalidate(provedorOpcoesFiltrosResultados),
          ),
        ),
        const SizedBox(height: 14),
        if (!possuiBaseFiltro)
          const _SemResultadosFiltroCartao()
        else
          painel.when(
            data: (dados) => _VistaPainelResultados(painel: dados),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (erro, pilhaTrace) => _CartaoErroCarregamento(
              mensagem: 'Não foi possível carregar os resultados.',
              aoTentarNovamente: () => ref.invalidate(provedorPainelResultados),
            ),
          ),
      ],
    );
  }

  void _abrirExportacao(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TelaExportacaoDados(
          propriedadeId: ref.read(provedorFiltroPropriedadeResultados),
          levantamentoId: ref.read(provedorFiltroLevantamentoResultados),
          inicialTalhaoIds: ref.read(provedorFiltroTalhoesResultados),
          especieId: ref.read(provedorFiltroEspecieResultados),
        ),
      ),
    );
  }
}

class _FiltroCartao extends ConsumerWidget {
  const _FiltroCartao({required this.opcoes});

  final OpcoesFiltrosResultados opcoes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estaEscuroModo = Theme.of(context).brightness == Brightness.dark;
    final campoCor = estaEscuroModo
        ? CoresDendro.escuroLegivelCampo
        : Colors.white;
    final propriedadeId = ref.watch(provedorFiltroPropriedadeResultados);
    final levantamentoId = ref.watch(provedorFiltroLevantamentoResultados);
    final especieId = ref.watch(provedorFiltroEspecieResultados);
    final selecionadoTalhoes = ref.watch(provedorFiltroTalhoesResultados);
    final possuiBaseFiltro = _possuiBaseFiltro(
      propriedadeId,
      levantamentoId,
      especieId,
      selecionadoTalhoes,
    );
    final levantamentosVisiveis = opcoes.levantamentosVisiveis(
      propriedadeId: propriedadeId,
    );
    final talhoesVisiveis = opcoes.talhoesVisiveis(
      propriedadeId: propriedadeId,
      levantamentoId: levantamentoId,
      especieId: especieId,
    );

    return CartaoDendro(
      fundoCor: estaEscuroModo
          ? CoresDendro.escuroLegivelCartao
          : const Color(0xFFF3F4F3),
      bordaCor: estaEscuroModo ? CoresDendro.escuroLegivelBorda : null,
      filho: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtros',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            key: ValueKey('property_$propriedadeId'),
            initialValue: propriedadeId ?? _todosFiltroValor,
            isExpanded: true,
            style: const TextStyle(
              color: CoresDendro.texto,
              fontWeight: FontWeight.w700,
            ),
            dropdownColor: campoCor,
            iconEnabledColor: CoresDendro.principal,
            iconDisabledColor: CoresDendro.textoDiscreto,
            decoration: InputDecoration(
              labelText: 'Propriedade',
              labelStyle: const TextStyle(
                color: CoresDendro.textoDiscreto,
                fontWeight: FontWeight.w700,
              ),
              floatingLabelStyle: const TextStyle(
                color: CoresDendro.principal,
                fontWeight: FontWeight.w800,
              ),
              prefixIcon: const Icon(
                Icons.map_outlined,
                color: CoresDendro.principal,
              ),
              fillColor: campoCor,
            ),
            items: [
              const DropdownMenuItem(
                value: _todosFiltroValor,
                child: Text('Todas as propriedades'),
              ),
              for (final propriedade in opcoes.propriedades)
                DropdownMenuItem(
                  value: propriedade.id,
                  child: Text(
                    propriedade.nome,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: (valor) {
              ref.read(provedorFiltroPropriedadeResultados.notifier).state =
                  valor == _todosFiltroValor ? null : valor;
              ref.read(provedorFiltroLevantamentoResultados.notifier).state =
                  null;
              ref.read(provedorFiltroTalhoesResultados.notifier).state =
                  <int>{};
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            key: ValueKey('inventory_$levantamentoId'),
            initialValue: levantamentoId ?? _todosFiltroValor,
            isExpanded: true,
            style: const TextStyle(
              color: CoresDendro.texto,
              fontWeight: FontWeight.w700,
            ),
            dropdownColor: campoCor,
            iconEnabledColor: CoresDendro.principal,
            iconDisabledColor: CoresDendro.textoDiscreto,
            decoration: InputDecoration(
              labelText: 'Levantamento',
              hintText: 'Selecione um levantamento',
              labelStyle: const TextStyle(
                color: CoresDendro.textoDiscreto,
                fontWeight: FontWeight.w700,
              ),
              floatingLabelStyle: const TextStyle(
                color: CoresDendro.principal,
                fontWeight: FontWeight.w800,
              ),
              prefixIcon: const Icon(
                Icons.assignment_outlined,
                color: CoresDendro.principal,
              ),
              fillColor: campoCor,
            ),
            items: [
              const DropdownMenuItem(
                value: _todosFiltroValor,
                child: Text('Mais recente de cada talhão'),
              ),
              for (final opcao in levantamentosVisiveis)
                DropdownMenuItem(
                  value: opcao.levantamento.id,
                  child: Text(
                    _rotuloLevantamento(opcao),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: (valor) {
              final levantamentoSelecionadoId = valor == _todosFiltroValor
                  ? null
                  : valor;
              OpcaoLevantamentoResultados? opcao;
              for (final item in opcoes.levantamentos) {
                if (item.levantamento.id == levantamentoSelecionadoId) {
                  opcao = item;
                  break;
                }
              }
              ref.read(provedorFiltroLevantamentoResultados.notifier).state =
                  levantamentoSelecionadoId;
              if (opcao != null) {
                ref.read(provedorFiltroPropriedadeResultados.notifier).state =
                    opcao.propriedade.id;
              }
              ref.read(provedorFiltroTalhoesResultados.notifier).state =
                  <int>{};
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            key: ValueKey('species_$especieId'),
            initialValue: especieId ?? _todosFiltroValor,
            isExpanded: true,
            style: const TextStyle(
              color: CoresDendro.texto,
              fontWeight: FontWeight.w700,
            ),
            dropdownColor: campoCor,
            iconEnabledColor: CoresDendro.principal,
            iconDisabledColor: CoresDendro.textoDiscreto,
            decoration: InputDecoration(
              labelText: 'Espécie',
              labelStyle: const TextStyle(
                color: CoresDendro.textoDiscreto,
                fontWeight: FontWeight.w700,
              ),
              floatingLabelStyle: const TextStyle(
                color: CoresDendro.principal,
                fontWeight: FontWeight.w800,
              ),
              prefixIcon: const Icon(
                Icons.eco_outlined,
                color: CoresDendro.principal,
              ),
              fillColor: campoCor,
            ),
            items: [
              const DropdownMenuItem(
                value: _todosFiltroValor,
                child: Text('Todas as espécies'),
              ),
              for (final especie in opcoes.especies)
                DropdownMenuItem(
                  value: especie.id,
                  child: Text(especie.nome, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (valor) {
              ref.read(provedorFiltroEspecieResultados.notifier).state =
                  valor == _todosFiltroValor ? null : valor;
              ref.read(provedorFiltroTalhoesResultados.notifier).state =
                  <int>{};
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Talhões',
                  style: TextStyle(
                    color: CoresDendro.textoDiscreto,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (_possuiAtivoFiltros(
                propriedadeId,
                levantamentoId,
                especieId,
                selecionadoTalhoes,
              ))
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: CoresDendro.principal,
                    textStyle: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  onPressed: () {
                    ref
                            .read(provedorFiltroPropriedadeResultados.notifier)
                            .state =
                        null;
                    ref
                            .read(provedorFiltroLevantamentoResultados.notifier)
                            .state =
                        null;
                    ref.read(provedorFiltroEspecieResultados.notifier).state =
                        null;
                    ref.read(provedorFiltroTalhoesResultados.notifier).state =
                        <int>{};
                  },
                  child: const Text('Limpar'),
                ),
            ],
          ),
          if (!possuiBaseFiltro)
            const Text(
              'Selecione uma propriedade ou espécie para carregar os talhões e os resultados.',
              style: TextStyle(
                color: CoresDendro.textoDiscreto,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            )
          else if (talhoesVisiveis.isEmpty)
            const Text(
              'Nenhum talhão disponível para os filtros selecionados.',
              style: TextStyle(
                color: CoresDendro.textoDiscreto,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final opcao in talhoesVisiveis)
                  FilterChip(
                    backgroundColor: estaEscuroModo
                        ? const Color(0xFFCFE3D4)
                        : Colors.white,
                    selectedColor: CoresDendro.principal,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: selecionadoTalhoes.contains(opcao.talhao.id)
                          ? CoresDendro.principal
                          : CoresDendro.escuroLegivelBorda,
                    ),
                    labelStyle: TextStyle(
                      color: selecionadoTalhoes.contains(opcao.talhao.id)
                          ? Colors.white
                          : CoresDendro.texto,
                      fontWeight: FontWeight.w800,
                    ),
                    label: Text(
                      '${opcao.talhao.identificacao} • ${opcao.especie.nome}',
                    ),
                    selected: selecionadoTalhoes.contains(opcao.talhao.id),
                    onSelected: (selecionado) {
                      final proximo = {...selecionadoTalhoes};
                      if (selecionado) {
                        proximo.add(opcao.talhao.id);
                      } else {
                        proximo.remove(opcao.talhao.id);
                      }
                      ref.read(provedorFiltroTalhoesResultados.notifier).state =
                          proximo;
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _VistaPainelResultados extends StatelessWidget {
  const _VistaPainelResultados({required this.painel});

  final PainelResultados painel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _VolumeResumoCartao(painel: painel),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: BlocoIndicador(
                rotulo: 'Árvores amostradas',
                valor: painel.arvoreQuantidade.toString(),
                icone: Icons.forest,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BlocoIndicador(
                rotulo: 'Área medida',
                valor: '${_formatoArea(painel.medidaAreaHa)} ha',
                icone: Icons.area_chart,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: BlocoIndicador(
                rotulo: 'DAP médio',
                valor: _formatoOpcionalMedicao(painel.mediaDapCm, 'cm'),
                icone: Icons.straighten,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BlocoIndicador(
                rotulo: 'Altura média',
                valor: _formatoOpcionalMedicao(painel.mediaAlturaM, 'm'),
                icone: Icons.height,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: BlocoIndicador(
                rotulo: 'Parcelas coletadas',
                valor:
                    '${painel.coletadaParcelaQuantidade}/${painel.parcelaQuantidade}',
                icone: Icons.grid_view,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BlocoIndicador(
                rotulo: 'Parcelas medidas',
                valor: painel.medidaParcelaQuantidade.toString(),
                icone: Icons.check_circle_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: BlocoIndicador(
                rotulo: 'Volume/ha',
                valor: _formatoOpcionalMedicao(painel.volumePorHaM3, 'm³/ha'),
                icone: Icons.inventory_2_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BlocoIndicador(
                rotulo: 'Árvores/ha',
                valor: _formatoOpcionalNumero(painel.arvoresPorHa),
                icone: Icons.park_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        BlocoIndicador(
          rotulo: 'Árvores com tronco tortuoso',
          valor:
              '${painel.troncoTortuosoQuantidade} (${_formatoPercentual(painel.troncoTortuosoPercentual)})',
          icone: Icons.nature_outlined,
        ),
        const SizedBox(height: 20),
        const TituloSecao(titulo: 'Distribuição diamétrica'),
        _DiametroDistribuicaoCartao(classes: painel.diametroClasses),
        const SizedBox(height: 20),
        const TituloSecao(titulo: 'Resumo por talhão'),
        if (painel.talhoes.isEmpty)
          const _VazioResultadosCartao()
        else
          for (final talhao in painel.talhoes)
            _TalhaoResultadoLinha(resumo: talhao),
      ],
    );
  }
}

class _VolumeResumoCartao extends StatelessWidget {
  const _VolumeResumoCartao({required this.painel});

  final PainelResultados painel;

  @override
  Widget build(BuildContext context) {
    final estimadoVolume = painel.estimadoVolumeM3;
    return CartaoDendro(
      fundoCor: CoresDendro.principal,
      bordaCor: CoresDendro.principal,
      espacamentoInterno: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 20,
      ),
      filho: Column(
        children: [
          Text(
            'Volume estimado total'.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            painel.possuiMedicoes
                ? _formatoOpcionalVolume(estimadoVolume)
                : 'Sem dados',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            painel.possuiMedicoes
                ? estimadoVolume == null
                      ? 'Informe a área das parcelas para extrapolar por hectare e talhão.'
                      : 'Calculado por Spurr e extrapolado pela área medida das parcelas.'
                : 'Registre árvores para alimentar os resultados.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.74),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiametroDistribuicaoCartao extends StatelessWidget {
  const _DiametroDistribuicaoCartao({required this.classes});

  final List<ResumoClasseDiametro> classes;

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return const CartaoDendro(
        filho: Text(
          'Sem árvores medidas para montar a distribuição.',
          style: TextStyle(
            color: CoresDendro.textoDiscreto,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    final maximoQuantidade = classes
        .map((item) => item.quantidade)
        .reduce((a, b) => a > b ? a : b);

    return CartaoDendro(
      espacamentoInterno: const EdgeInsets.fromLTRB(14, 16, 14, 12),
      filho: SizedBox(
        height: 190,
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final item in classes)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              item.quantidade.toString(),
                              style: const TextStyle(
                                color: CoresDendro.textoDiscreto,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FractionallySizedBox(
                                  heightFactor:
                                      item.quantidade / maximoQuantidade,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: CoresDendro.principal,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const SizedBox(width: 24),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (final item in classes)
                  Expanded(
                    child: Text(
                      item.rotulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: CoresDendro.textoDiscreto,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Classes de DAP (cm)',
              style: TextStyle(
                color: CoresDendro.textoDiscreto,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TalhaoResultadoLinha extends StatelessWidget {
  const _TalhaoResultadoLinha({required this.resumo});

  final ResumoResultadosTalhao resumo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CartaoDendro(
        espacamentoInterno: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        filho: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    resumo.talhao.identificacao,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                IndicadorSituacao(rotulo: resumo.especie.nome),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _IndicadorEmLinha('${resumo.arvoreQuantidade} árvores'),
                _IndicadorEmLinha('${_formatoArea(resumo.medidaAreaHa)} ha'),
                _IndicadorEmLinha(
                  '${resumo.coletadaParcelaQuantidade}/${resumo.parcelaQuantidade} parcelas',
                ),
                _IndicadorEmLinha(
                  'Tronco tortuoso: ${resumo.troncoTortuosoQuantidade} (${_formatoPercentual(resumo.troncoTortuosoPercentual)})',
                ),
                _IndicadorEmLinha(
                  'DAP ${_formatoOpcionalMedicao(resumo.mediaDapCm, 'cm')}',
                ),
                _IndicadorEmLinha(
                  'Alt. ${_formatoOpcionalMedicao(resumo.mediaAlturaM, 'm')}',
                ),
                _IndicadorEmLinha(
                  'Vol. ${_formatoOpcionalMedicao(resumo.volumePorHaM3, 'm³/ha')}',
                ),
                _IndicadorEmLinha(
                  'Total ${_formatoOpcionalVolume(resumo.estimadoVolumeM3)}',
                ),
                if (resumo.convertidoUnidade != 'm3')
                  _IndicadorEmLinha(
                    '${_formatoOpcionalNumero(resumo.convertidoEstimadoVolume)} ${resumo.convertidoUnidade}',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IndicadorEmLinha extends StatelessWidget {
  const _IndicadorEmLinha(this.rotulo);

  final String rotulo;

  @override
  Widget build(BuildContext context) {
    return Text(
      rotulo,
      style: const TextStyle(
        color: CoresDendro.principal,
        fontSize: 12,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _VazioResultadosCartao extends StatelessWidget {
  const _VazioResultadosCartao();

  @override
  Widget build(BuildContext context) {
    return const CartaoDendro(
      fundoCor: Color(0xFFF3F4F3),
      filho: Text(
        'Nenhum dado de parcela encontrado para os filtros selecionados.',
        style: TextStyle(
          color: CoresDendro.textoDiscreto,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SemResultadosFiltroCartao extends StatelessWidget {
  const _SemResultadosFiltroCartao();

  @override
  Widget build(BuildContext context) {
    return const CartaoDendro(
      fundoCor: Color(0xFFF3F4F3),
      filho: Column(
        children: [
          Icon(Icons.filter_alt_outlined, color: CoresDendro.principal),
          SizedBox(height: 10),
          Text(
            'Selecione uma propriedade ou espécie para visualizar os resultados.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CoresDendro.textoDiscreto,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartaoErroCarregamento extends StatelessWidget {
  const _CartaoErroCarregamento({
    required this.mensagem,
    required this.aoTentarNovamente,
  });

  final String mensagem;
  final VoidCallback aoTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      filho: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(height: 10),
          Text(
            mensagem,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800),
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

bool _possuiBaseFiltro(
  int? propriedadeId,
  int? levantamentoId,
  int? especieId,
  Set<int> talhaoIds,
) {
  return propriedadeId != null ||
      levantamentoId != null ||
      especieId != null ||
      talhaoIds.isNotEmpty;
}

bool _possuiAtivoFiltros(
  int? propriedadeId,
  int? levantamentoId,
  int? especieId,
  Set<int> talhaoIds,
) {
  return propriedadeId != null ||
      levantamentoId != null ||
      especieId != null ||
      talhaoIds.isNotEmpty;
}

String _rotuloLevantamento(OpcaoLevantamentoResultados opcao) {
  final data = opcao.levantamento.iniciadoEm;
  final dia = data.day.toString().padLeft(2, '0');
  final mes = data.month.toString().padLeft(2, '0');
  final hora = data.hour.toString().padLeft(2, '0');
  final minuto = data.minute.toString().padLeft(2, '0');
  final situacao = opcao.levantamento.situacao == SituacaoLevantamento.concluido
      ? 'Concluído'
      : opcao.levantamento.situacao == SituacaoLevantamento.emAndamento
      ? 'Em andamento'
      : 'Planejamento';
  return '${opcao.propriedade.nome} • $dia/$mes/${data.year} $hora:$minuto • $situacao';
}

String _formatoArea(double valor) {
  return valor.toStringAsFixed(2).replaceAll('.', ',');
}

String _formatoOpcionalMedicao(double? valor, String unidade) {
  if (valor == null) return '-';
  return '${valor.toStringAsFixed(1).replaceAll('.', ',')} $unidade';
}

String _formatoOpcionalVolume(double? valor) {
  if (valor == null) return '-';
  return '${valor.toStringAsFixed(2).replaceAll('.', ',')} m³';
}

String _formatoOpcionalNumero(double? valor) {
  if (valor == null) return '-';
  return valor.toStringAsFixed(1).replaceAll('.', ',');
}

String _formatoPercentual(double valor) {
  return '${valor.toStringAsFixed(1).replaceAll('.', ',')}%';
}
