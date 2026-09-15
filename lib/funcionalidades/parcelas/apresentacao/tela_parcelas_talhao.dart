import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../aplicativo/tema/tema_dendro.dart';
import '../../../nucleo/banco/banco_dendro.dart';
import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../../levantamentos/dados/repositorio_levantamentos.dart';
import '../../levantamentos/apresentacao/tela_detalhe_levantamento.dart';
import '../../estrutura/apresentacao/navegacao_estrutura_dendro.dart';
import '../../coleta_arvores/apresentacao/tela_coleta_arvores.dart';
import '../dados/repositorio_parcelas.dart';

class TelaParcelasTalhao extends ConsumerWidget {
  const TelaParcelasTalhao({
    required this.talhaoId,
    this.talhaoLevantamentoId,
    this.mostrarIniciarLevantamentoAcao = true,
    this.habilitarColetaArvores = false,
    super.key,
  });

  final int talhaoId;
  final int? talhaoLevantamentoId;
  final bool mostrarIniciarLevantamentoAcao;
  final bool habilitarColetaArvores;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vinculoId = talhaoLevantamentoId;
    final estado = vinculoId == null
        ? ref.watch(provedorParcelasTalhao(talhaoId))
        : ref.watch(provedorParcelasTalhaoLevantamento(vinculoId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parcelas'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: MarcaDendro(tamanho: 32)),
          ),
        ],
      ),
      floatingActionButton: estado.maybeWhen(
        data: (dados) => FloatingActionButton(
          heroTag: 'stand_plots_new_plot_${talhaoLevantamentoId ?? talhaoId}',
          onPressed: () => _abrirParcelaFormulario(context, ref, dados),
          tooltip: 'Nova parcela',
          child: const Icon(Icons.add),
        ),
        orElse: () => null,
      ),
      body: SafeArea(
        child: estado.when(
          data: (dados) => _ParcelasCorpo(
            estado: dados,
            mostrarIniciarLevantamentoAcao: mostrarIniciarLevantamentoAcao,
            aoAdicionar: () => _abrirParcelaFormulario(context, ref, dados),
            aoIniciarLevantamento: () =>
                _iniciarLevantamento(context, ref, dados),
            aoConcluirLevantamento: () =>
                _confirmarConcluirLevantamento(context, ref, dados),
            aoAbrirResultados: () => _abrirResultados(context, dados),
            aoAbrirParcela: (resumo) => _abrirParcela(context, ref, resumo),
            aoEditarParcela: (resumo) =>
                _abrirParcelaFormulario(context, ref, dados, resumo: resumo),
            aoExcluirParcela: (resumo) =>
                _confirmarExcluirParcela(context, ref, dados, resumo),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (erro, pilhaTrace) => _ErroCarregamento(
            aoTentarNovamente: () => _invalidarParcelas(ref),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarConcluirLevantamento(
    BuildContext context,
    WidgetRef ref,
    EstadoParcelasTalhao estado,
  ) async {
    final levantamento = estado.atualLevantamento;
    if (levantamento == null ||
        levantamento.situacao != SituacaoLevantamento.emAndamento) {
      return;
    }

    final possuiAbrirParcelas =
        estado.abrirParcelas > 0 || estado.totalParcelas == 0;
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
        content: Text(_concluirLevantamentoMensagem(estado)),
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
          .concluirLevantamento(levantamento.id);
      ref.invalidate(provedorLevantamentosAtivos);
      ref.invalidate(provedorLevantamentoAtivo);
      ref.invalidate(provedorLevantamentoDetalhe(levantamento.id));
      _invalidarParcelas(ref);

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

  Future<void> _iniciarLevantamento(
    BuildContext context,
    WidgetRef ref,
    EstadoParcelasTalhao estado,
  ) async {
    final ativoTalhao = estado.ativoTalhaoLevantamento;
    if (ativoTalhao != null) {
      await _abrirLevantamento(context, ativoTalhao.levantamentoId);
      _invalidarParcelas(ref);
      return;
    }

    try {
      final talhaoLevantamento = await ref
          .read(provedorRepositorioParcelas)
          .iniciarNovoLevantamentoParaTalhao(talhaoId);
      ref.invalidate(provedorLevantamentosAtivos);
      ref.invalidate(provedorLevantamentoAtivo);
      _invalidarParcelas(ref);
      if (!context.mounted) return;
      await _abrirLevantamento(context, talhaoLevantamento.levantamentoId);
      return;
    } on ExcecaoLevantamentoAtivoNoTalhao catch (erro) {
      ref.invalidate(provedorLevantamentosAtivos);
      ref.invalidate(provedorLevantamentoAtivo);

      if (!context.mounted) return;
      await _abrirLevantamento(context, erro.existente.levantamentoId);
      return;
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível iniciar o levantamento.'),
        ),
      );
      return;
    }
  }

  Future<void> _abrirLevantamento(BuildContext context, int levantamentoId) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            TelaDetalheLevantamento(levantamentoId: levantamentoId),
      ),
    );
  }

  void _abrirResultados(BuildContext context, EstadoParcelasTalhao estado) {
    NavegacaoEstruturaDendro.de(context).abrirResultados(
      propriedadeId: estado.talhao.propriedadeId,
      talhaoIds: {estado.talhao.id},
    );
  }

  Future<void> _abrirParcela(
    BuildContext context,
    WidgetRef ref,
    ParcelaResumo resumo,
  ) async {
    if (habilitarColetaArvores &&
        resumo.levantamento.situacao == SituacaoLevantamento.emAndamento) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => TelaColetaArvores(parcelaId: resumo.parcela.id),
        ),
      );
      _invalidarParcelas(ref);
      return;
    }

    await _abrirParcelaDetalhes(context, ref, resumo);
  }

  Future<void> _abrirParcelaDetalhes(
    BuildContext context,
    WidgetRef ref,
    ParcelaResumo resumo,
  ) async {
    final repositorio = ref.read(provedorRepositorioParcelas);
    final arvores = await repositorio.arvoresParaParcela(resumo.parcela.id);
    final pontos = await repositorio.pontosGeograficosDaParcela(
      resumo.parcela.id,
    );

    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _ParcelaDetalhesPainel(
        resumo: resumo,
        arvores: arvores,
        pontos: pontos,
      ),
    );
  }

  Future<void> _abrirParcelaFormulario(
    BuildContext context,
    WidgetRef ref,
    EstadoParcelasTalhao estado, {
    ParcelaResumo? resumo,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _ParcelaFormularioPainel(
        talhaoId: talhaoId,
        talhaoLevantamentoId: talhaoLevantamentoId,
        estado: estado,
        resumo: resumo,
      ),
    );
  }

  Future<void> _confirmarExcluirParcela(
    BuildContext context,
    WidgetRef ref,
    EstadoParcelasTalhao estado,
    ParcelaResumo resumo,
  ) async {
    final parcela = resumo.parcela;
    final possuiFilhos =
        resumo.arvoreQuantidade > 0 || resumo.geograficoPontoQuantidade > 0;
    final mensagem = possuiFilhos
        ? 'A parcela ${parcela.identificacao} já contém dados armazenados. Se confirmar, árvores e coordenadas vinculadas serão apagadas. Deseja continuar?'
        : 'Deseja excluir a parcela ${parcela.identificacao}?';

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir parcela'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmado != true || !context.mounted) return;

    await ref.read(provedorRepositorioParcelas).excluirParcela(parcela.id);
    _invalidarParcelas(ref);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Parcela ${parcela.identificacao} excluída.')),
    );
  }

  void _invalidarParcelas(WidgetRef ref) {
    final vinculoId = talhaoLevantamentoId;
    if (vinculoId == null) {
      ref.invalidate(provedorParcelasTalhao(talhaoId));
    } else {
      ref.invalidate(provedorParcelasTalhaoLevantamento(vinculoId));
    }
  }
}

class _ParcelasCorpo extends StatelessWidget {
  const _ParcelasCorpo({
    required this.estado,
    required this.mostrarIniciarLevantamentoAcao,
    required this.aoAdicionar,
    required this.aoIniciarLevantamento,
    required this.aoConcluirLevantamento,
    required this.aoAbrirResultados,
    required this.aoAbrirParcela,
    required this.aoEditarParcela,
    required this.aoExcluirParcela,
  });

  final EstadoParcelasTalhao estado;
  final bool mostrarIniciarLevantamentoAcao;
  final VoidCallback aoAdicionar;
  final VoidCallback aoIniciarLevantamento;
  final VoidCallback aoConcluirLevantamento;
  final VoidCallback aoAbrirResultados;
  final ValueChanged<ParcelaResumo> aoAbrirParcela;
  final ValueChanged<ParcelaResumo> aoEditarParcela;
  final ValueChanged<ParcelaResumo> aoExcluirParcela;

  @override
  Widget build(BuildContext context) {
    final possuiAtivoLevantamento = estado.ativoTalhaoLevantamento != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        _TalhaoResumoCartao(
          estado: estado,
          aoAbrirResultados: aoAbrirResultados,
          aoConcluirLevantamento:
              estado.atualLevantamento?.situacao ==
                  SituacaoLevantamento.emAndamento
              ? aoConcluirLevantamento
              : null,
        ),
        if (mostrarIniciarLevantamentoAcao) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: aoIniciarLevantamento,
              icon: Icon(
                possuiAtivoLevantamento
                    ? Icons.forest
                    : Icons.play_arrow_rounded,
              ),
              label: Text(
                possuiAtivoLevantamento
                    ? 'Continuar Coleta'
                    : 'Iniciar levantamento',
              ),
            ),
          ),
        ],
        const SizedBox(height: 18),
        const TituloSecao(titulo: 'Parcelas'),
        if (estado.parcelas.isEmpty)
          _VazioParcelasCartao(aoAdicionar: aoAdicionar)
        else
          for (final resumo in estado.parcelas)
            _ParcelaItem(
              resumo: resumo,
              aoAbrir: () => aoAbrirParcela(resumo),
              aoEditar: () => aoEditarParcela(resumo),
              aoExcluir: () => aoExcluirParcela(resumo),
            ),
      ],
    );
  }
}

class _TalhaoResumoCartao extends StatelessWidget {
  const _TalhaoResumoCartao({
    required this.estado,
    required this.aoAbrirResultados,
    this.aoConcluirLevantamento,
  });

  final EstadoParcelasTalhao estado;
  final VoidCallback aoAbrirResultados;
  final VoidCallback? aoConcluirLevantamento;

  @override
  Widget build(BuildContext context) {
    final talhao = estado.talhao;
    final anoPlantio = talhao.anoPlantio;
    final parcelaDimensao = _formatoParcelaDimensao(talhao);

    return CartaoDendro(
      fundoCor: const Color(0xFFE0F2E8),
      bordaCor: const Color(0xFFA4D1B4),
      filho: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  talhao.identificacao,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CoresDendro.principal,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                onPressed: aoAbrirResultados,
                icon: const Icon(Icons.bar_chart),
                tooltip: 'Resultados',
                visualDensity: VisualDensity.compact,
              ),
              if (aoConcluirLevantamento != null) ...[
                const SizedBox(width: 10),
                Tooltip(
                  message: 'Encerrar levantamento',
                  child: FilledButton.icon(
                    onPressed: aoConcluirLevantamento,
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Encerrar'),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 36),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ResumoChip(
                icone: Icons.eco,
                rotulo: estado.especie.nome,
                valor: 'Espécie',
              ),
              _ResumoChip(
                icone: Icons.area_chart,
                rotulo: '${_formatoArea(talhao.areaHa)} ha',
                valor: 'Área total',
              ),
              if (anoPlantio != null)
                _ResumoChip(
                  icone: Icons.calendar_month,
                  rotulo: anoPlantio.toString(),
                  valor: 'Plantio',
                ),
              if (parcelaDimensao != null)
                _ResumoChip(
                  icone: Icons.crop_free,
                  rotulo: '$parcelaDimensao m',
                  valor: 'Parcela padrão',
                ),
              _ResumoChip(
                icone: Icons.grid_view,
                rotulo: '${estado.coletadaParcelas}/${estado.totalParcelas}',
                valor: 'Coletadas',
              ),
            ],
          ),
          if (estado.medidaAreaHa > 0) ...[
            const SizedBox(height: 12),
            Text(
              'Área medida em parcelas: ${_formatoArea(estado.medidaAreaHa)} ha',
              style: const TextStyle(
                color: CoresDendro.textoDiscreto,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResumoChip extends StatelessWidget {
  const _ResumoChip({
    required this.icone,
    required this.rotulo,
    required this.valor,
  });

  final IconData icone;
  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final estaEscuro = Theme.of(context).brightness == Brightness.dark;
    final fundoCor = estaEscuro
        ? CoresDendro.escuroLegivelCampo
        : Colors.white.withValues(alpha: 0.78);
    final bordaCor = estaEscuro
        ? CoresDendro.escuroLegivelBorda
        : Colors.white.withValues(alpha: 0.72);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: fundoCor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bordaCor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 17, color: CoresDendro.principal),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valor.toUpperCase(),
                  style: const TextStyle(
                    color: CoresDendro.textoDiscreto,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  rotulo,
                  style: const TextStyle(
                    color: CoresDendro.texto,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ParcelaItem extends StatelessWidget {
  const _ParcelaItem({
    required this.resumo,
    required this.aoAbrir,
    required this.aoEditar,
    required this.aoExcluir,
  });

  final ParcelaResumo resumo;
  final VoidCallback aoAbrir;
  final VoidCallback aoEditar;
  final VoidCallback aoExcluir;

  @override
  Widget build(BuildContext context) {
    final parcela = resumo.parcela;
    final cores = _situacaoCores(
      parcela.situacao,
      resumo.levantamento.situacao,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: aoAbrir,
        child: CartaoDendro(
          fundoCor: cores.fundo,
          bordaCor: cores.borda,
          espacamentoInterno: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          filho: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: cores.iconFundo,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(cores.icone, color: cores.iconCor, size: 18),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            parcela.identificacao,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: cores.texto,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        _ParcelaSituacaoIndicador(
                          rotulo: _situacaoRotulo(
                            parcela.situacao,
                            resumo.levantamento.situacao,
                          ),
                          cores: cores,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _parcelaSubtitulo(resumo),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cores.discretoTexto,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_ParcelaAcao>(
                tooltip: 'Ações',
                icon: Icon(Icons.more_vert, color: cores.texto),
                onSelected: (acao) {
                  switch (acao) {
                    case _ParcelaAcao.editar:
                      aoEditar();
                    case _ParcelaAcao.excluir:
                      aoExcluir();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _ParcelaAcao.editar,
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 10),
                        Text('Editar área'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: _ParcelaAcao.excluir,
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
        ),
      ),
    );
  }
}

class _ParcelaSituacaoIndicador extends StatelessWidget {
  const _ParcelaSituacaoIndicador({required this.rotulo, required this.cores});

  final String rotulo;
  final _ParcelaSituacaoCores cores;

  @override
  Widget build(BuildContext context) {
    final estaEscuro = cores.fundo == CoresDendro.principal;

    return IndicadorSituacao(
      rotulo: rotulo,
      cor: estaEscuro ? Colors.white.withValues(alpha: 0.16) : cores.iconFundo,
      textoCor: estaEscuro ? Colors.white : cores.iconCor,
    );
  }
}

class _ParcelaSituacaoCores {
  const _ParcelaSituacaoCores({
    required this.fundo,
    required this.borda,
    required this.iconFundo,
    required this.iconCor,
    required this.texto,
    required this.discretoTexto,
    required this.icone,
  });

  final Color fundo;
  final Color borda;
  final Color iconFundo;
  final Color iconCor;
  final Color texto;
  final Color discretoTexto;
  final IconData icone;
}

class _VazioParcelasCartao extends StatelessWidget {
  const _VazioParcelasCartao({required this.aoAdicionar});

  final VoidCallback aoAdicionar;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      fundoCor: const Color(0xFFF3F4F3),
      filho: Column(
        children: [
          const Icon(
            Icons.grid_view_outlined,
            size: 42,
            color: CoresDendro.secundario,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhuma parcela cadastrada',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Crie as parcelas do talhão antes ou durante a coleta de campo.',
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
              onPressed: aoAdicionar,
              icon: const Icon(Icons.add),
              style: OutlinedButton.styleFrom(
                foregroundColor: CoresDendro.principal,
                side: const BorderSide(color: CoresDendro.principal),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              label: const Text('Cadastrar parcela'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParcelaFormularioPainel extends ConsumerStatefulWidget {
  const _ParcelaFormularioPainel({
    required this.talhaoId,
    required this.talhaoLevantamentoId,
    required this.estado,
    this.resumo,
  });

  final int talhaoId;
  final int? talhaoLevantamentoId;
  final EstadoParcelasTalhao estado;
  final ParcelaResumo? resumo;

  @override
  ConsumerState<_ParcelaFormularioPainel> createState() =>
      _ParcelaFormularioPainelEstado();
}

class _ParcelaFormularioPainelEstado
    extends ConsumerState<_ParcelaFormularioPainel> {
  final _chaveFormulario = GlobalKey<FormState>();
  late final TextEditingController _identificacaoControlador;
  late final TextEditingController _areaControlador;
  bool _salvando = false;

  bool get _estaEditando => widget.resumo != null;

  @override
  void initState() {
    super.initState();
    final parcela = widget.resumo?.parcela;
    _identificacaoControlador = TextEditingController(
      text: parcela?.identificacao ?? widget.estado.proximaIdentificacaoParcela,
    );
    _areaControlador = TextEditingController(
      text: parcela?.areaHa == null ? '' : _formatoArea(parcela!.areaHa!),
    );
  }

  @override
  void dispose() {
    _identificacaoControlador.dispose();
    _areaControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  Expanded(
                    child: Text(
                      _estaEditando ? 'Editar parcela' : 'Cadastrar parcela',
                      style: const TextStyle(
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
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Identificação',
                  prefixIcon: Icon(Icons.label_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _areaControlador,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Área da parcela (ha, opcional)',
                  prefixIcon: Icon(Icons.area_chart_outlined),
                ),
                validator: _validarArea,
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
                  label: Text(
                    _estaEditando ? 'Salvar alterações' : 'Cadastrar',
                  ),
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
    final repositorio = ref.read(provedorRepositorioParcelas);
    final areaHa = _interpretarOpcionalArea(_areaControlador.text);

    try {
      if (_estaEditando) {
        await repositorio.atualizarAreaParcela(
          id: widget.resumo!.parcela.id,
          areaHa: areaHa,
        );
      } else if (widget.talhaoLevantamentoId != null) {
        await repositorio.criarParcelaParaTalhaoLevantamento(
          talhaoLevantamentoId: widget.talhaoLevantamentoId!,
          areaHa: areaHa,
        );
      } else {
        await repositorio.criarParcelaPlanejada(
          talhaoId: widget.talhaoId,
          areaHa: areaHa,
        );
      }

      if (!mounted) return;
      final vinculoId = widget.talhaoLevantamentoId;
      if (vinculoId == null) {
        ref.invalidate(provedorParcelasTalhao(widget.talhaoId));
      } else {
        ref.invalidate(provedorParcelasTalhaoLevantamento(vinculoId));
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _estaEditando ? 'Parcela atualizada.' : 'Parcela cadastrada.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar a parcela.')),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  String? _validarArea(String? valor) {
    final aparado = valor?.trim() ?? '';
    if (aparado.isEmpty) return null;

    final area = _interpretarOpcionalArea(aparado);
    if (area == null) return 'Informe uma área válida';
    if (area <= 0) return 'Área deve ser maior que zero';
    return null;
  }
}

class _ParcelaDetalhesPainel extends StatelessWidget {
  const _ParcelaDetalhesPainel({
    required this.resumo,
    required this.arvores,
    required this.pontos,
  });

  final ParcelaResumo resumo;
  final List<Arvore> arvores;
  final List<PontoGeograficoParcela> pontos;

  @override
  Widget build(BuildContext context) {
    final parcela = resumo.parcela;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  parcela.identificacao,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IndicadorSituacao(
                rotulo: _situacaoRotulo(
                  parcela.situacao,
                  resumo.levantamento.situacao,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: BlocoIndicador(
                  rotulo: 'Árvores',
                  valor: arvores.length.toString(),
                  icone: Icons.forest,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BlocoIndicador(
                  rotulo: 'Pontos GPS',
                  valor: pontos.length.toString(),
                  icone: Icons.add_location_alt,
                ),
              ),
            ],
          ),
          if (parcela.areaHa != null) ...[
            const SizedBox(height: 10),
            CartaoDendro(
              filho: Text(
                'Área da parcela: ${_formatoArea(parcela.areaHa!)} ha',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
          const SizedBox(height: 18),
          const TituloSecao(titulo: 'Árvores registradas'),
          if (arvores.isEmpty)
            const CartaoDendro(
              filho: Text(
                'Nenhuma árvore registrada nesta parcela.',
                style: TextStyle(
                  color: CoresDendro.textoDiscreto,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            for (final arvore in arvores) _ItemConsultaArvore(arvore: arvore),
          const SizedBox(height: 18),
          const TituloSecao(titulo: 'Pontos GPS'),
          if (pontos.isEmpty)
            const CartaoDendro(
              filho: Text(
                'Nenhum ponto GPS registrado nesta parcela.',
                style: TextStyle(
                  color: CoresDendro.textoDiscreto,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            for (final ponto in pontos)
              _ItemConsultaPontoGeografico(ponto: ponto),
        ],
      ),
    );
  }
}

class _ItemConsultaArvore extends StatelessWidget {
  const _ItemConsultaArvore({required this.arvore});

  final Arvore arvore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CartaoDendro(
        espacamentoInterno: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        filho: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: CoresDendro.principalSuave,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.forest, color: CoresDendro.principal),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Árvore ${arvore.numero}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'DAP: ${_formatoMedicao(arvore.dapCm)} cm • Alt.: ${_formatoMedicao(arvore.alturaM)} m',
                    style: const TextStyle(
                      color: CoresDendro.textoDiscreto,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemConsultaPontoGeografico extends StatelessWidget {
  const _ItemConsultaPontoGeografico({required this.ponto});

  final PontoGeograficoParcela ponto;

  @override
  Widget build(BuildContext context) {
    final referencia = ponto.posicaoReferencia?.name.toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CartaoDendro(
        espacamentoInterno: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        filho: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: CoresDendro.principalSuave,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add_location_alt,
                color: CoresDendro.principal,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    referencia == null
                        ? 'Ponto ${ponto.ordemPonto}'
                        : '$referencia • Ponto ${ponto.ordemPonto}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    _formatarCoordenada(ponto),
                    style: const TextStyle(
                      color: CoresDendro.textoDiscreto,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErroCarregamento extends StatelessWidget {
  const _ErroCarregamento({required this.aoTentarNovamente});

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
                'Não foi possível carregar as parcelas.',
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

enum _ParcelaAcao { editar, excluir }

_ParcelaSituacaoCores _situacaoCores(
  SituacaoParcela situacao,
  SituacaoLevantamento levantamentoSituacao,
) {
  if (levantamentoSituacao == SituacaoLevantamento.planejamento) {
    return const _ParcelaSituacaoCores(
      fundo: Color(0xFFEAF7EF),
      borda: Color(0xFFA4D1B4),
      iconFundo: CoresDendro.principalSuave,
      iconCor: CoresDendro.principal,
      texto: CoresDendro.principal,
      discretoTexto: CoresDendro.textoDiscreto,
      icone: Icons.assignment_outlined,
    );
  }

  switch (situacao) {
    case SituacaoParcela.coletada:
      return const _ParcelaSituacaoCores(
        fundo: Colors.white,
        borda: CoresDendro.contorno,
        iconFundo: CoresDendro.principalSuave,
        iconCor: CoresDendro.principal,
        texto: CoresDendro.texto,
        discretoTexto: CoresDendro.textoDiscreto,
        icone: Icons.check_circle,
      );
    case SituacaoParcela.emAndamento:
      return _ParcelaSituacaoCores(
        fundo: CoresDendro.principal,
        borda: CoresDendro.principal,
        iconFundo: Colors.white.withValues(alpha: 0.16),
        iconCor: Colors.white,
        texto: Colors.white,
        discretoTexto: Colors.white.withValues(alpha: 0.78),
        icone: Icons.more_horiz,
      );
    case SituacaoParcela.pendente:
      return const _ParcelaSituacaoCores(
        fundo: Colors.white,
        borda: CoresDendro.contorno,
        iconFundo: Color(0xFFF0F2F0),
        iconCor: CoresDendro.textoDiscreto,
        texto: CoresDendro.textoDiscreto,
        discretoTexto: CoresDendro.textoDiscreto,
        icone: Icons.radio_button_unchecked,
      );
  }
}

String _parcelaSubtitulo(ParcelaResumo resumo) {
  final parcela = resumo.parcela;
  final area = parcela.areaHa == null
      ? null
      : '${_formatoArea(parcela.areaHa!)} ha';

  switch (parcela.situacao) {
    case SituacaoParcela.coletada:
      final coordenada = resumo.possuiCoordinates
          ? _formatarCoordenada(resumo.primeiroGeograficoPonto!)
          : 'Sem coordenadas';
      return [
        '${resumo.arvoreQuantidade} árvores',
        coordenada,
        ?area,
      ].join(' • ');
    case SituacaoParcela.emAndamento:
      return [
        'Em andamento',
        '${resumo.arvoreQuantidade} árvores',
        ?area,
      ].join(' • ');
    case SituacaoParcela.pendente:
      final situacao =
          resumo.levantamento.situacao == SituacaoLevantamento.planejamento
          ? 'Planejada'
          : 'Pendente';
      return area == null ? situacao : '$situacao • $area';
  }
}

String _situacaoRotulo(
  SituacaoParcela situacao,
  SituacaoLevantamento levantamentoSituacao,
) {
  if (levantamentoSituacao == SituacaoLevantamento.planejamento) {
    return 'Planejada';
  }

  switch (situacao) {
    case SituacaoParcela.coletada:
      return 'Coletada';
    case SituacaoParcela.emAndamento:
      return 'Em andamento';
    case SituacaoParcela.pendente:
      return 'Pendente';
  }
}

String _concluirLevantamentoMensagem(EstadoParcelasTalhao estado) {
  if (estado.totalParcelas == 0) {
    return 'Esse levantamento ainda não possui parcelas cadastradas. Deseja encerrar mesmo assim?';
  }

  if (estado.abrirParcelas > 0) {
    return 'Existem ${estado.abrirParcelas} ${_plural(estado.abrirParcelas, 'parcela')} ainda não ${_plural(estado.abrirParcelas, 'coletada')}. Se confirmar, o levantamento será encerrado e deixará de aparecer em andamento.';
  }

  return 'Encerrar o levantamento com ${estado.coletadaParcelas} ${_plural(estado.coletadaParcelas, 'parcela')} ${_plural(estado.coletadaParcelas, 'coletada')}?';
}

String _plural(int quantidade, String singular) {
  if (quantidade == 1) return singular;
  return '${singular}s';
}

String _formatarCoordenada(PontoGeograficoParcela ponto) {
  return '${ponto.latitude.toStringAsFixed(5)}, ${ponto.longitude.toStringAsFixed(5)}';
}

String _formatoArea(double valor) {
  return valor.toStringAsFixed(2).replaceAll('.', ',');
}

String? _formatoParcelaDimensao(Talhao talhao) {
  final largura = talhao.larguraParcelaM;
  final comprimento = talhao.comprimentoParcelaM;
  if (largura == null || comprimento == null) return null;
  return '${_formatoCompactoNumero(largura)} x ${_formatoCompactoNumero(comprimento)}';
}

String _formatoCompactoNumero(double valor) {
  if (valor == valor.roundToDouble()) return valor.toStringAsFixed(0);
  return _formatoArea(valor);
}

String _formatoMedicao(double valor) {
  return valor.toStringAsFixed(1).replaceAll('.', ',');
}

double? _interpretarOpcionalArea(String valor) {
  final aparado = valor.trim();
  if (aparado.isEmpty) return null;
  return double.tryParse(aparado.replaceAll(',', '.'));
}
