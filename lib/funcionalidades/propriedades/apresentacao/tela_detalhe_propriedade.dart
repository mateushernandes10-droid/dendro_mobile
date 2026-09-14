import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../aplicativo/tema/tema_dendro.dart';
import '../../../nucleo/banco/banco_dendro.dart';
import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../../exportacao_dados/apresentacao/tela_exportacao_dados.dart';
import '../../estrutura/apresentacao/navegacao_estrutura_dendro.dart';
import '../dados/repositorio_propriedades.dart';
import '../../talhoes/dados/repositorio_talhoes.dart';
import '../../parcelas/apresentacao/tela_parcelas_talhao.dart';

class TelaDetalhePropriedade extends ConsumerWidget {
  const TelaDetalhePropriedade({required this.propriedade, super.key});

  final Propriedade propriedade;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talhoes = ref.watch(provedorPropriedadeTalhoes(propriedade.id));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Text(propriedade.nome, maxLines: 2),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: MarcaDendro(tamanho: 32)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'property_detail_new_stand_${propriedade.id}',
        onPressed: () => _abrirTalhaoFormulario(context, propriedade.id),
        tooltip: 'Novo talhão',
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            _PropriedadeResumoCartao(
              propriedade: propriedade,
              aoAbrirResultados: () => _abrirResultados(context),
              aoExportacao: () => _abrirExportacao(context),
            ),
            const SizedBox(height: 18),
            const SecaoTitulo(titulo: 'Talhões'),
            talhoes.when(
              data: (itens) {
                if (itens.isEmpty) {
                  return _VazioTalhoesCartao(
                    aoCriar: () =>
                        _abrirTalhaoFormulario(context, propriedade.id),
                  );
                }

                return Column(
                  children: [
                    for (final item in itens)
                      _TalhaoItem(
                        resumo: item,
                        aoAbrir: () => _abrirTalhaoParcelas(context, item),
                        aoEditar: () => _abrirTalhaoFormulario(
                          context,
                          propriedade.id,
                          resumo: item,
                        ),
                        aoExcluir: () =>
                            _confirmarExcluirTalhao(context, ref, item),
                      ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (erro, pilhaTrace) => _CarregarErroCartao(
                mensagem: 'Não foi possível carregar os talhões.',
                aoTentarNovamente: () =>
                    ref.invalidate(provedorPropriedadeTalhoes(propriedade.id)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _abrirTalhaoFormulario(
    BuildContext context,
    int propriedadeId, {
    TalhaoResumo? resumo,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          _TalhaoFormularioPainel(propriedadeId: propriedadeId, resumo: resumo),
    );
  }

  Future<void> _abrirExportacao(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            TelaExportacaoDados(propriedadeId: propriedade.id),
      ),
    );
  }

  void _abrirResultados(BuildContext context) {
    NavegacaoEstruturaDendro.de(
      context,
    ).abrirResultados(propriedadeId: propriedade.id);
  }

  Future<void> _abrirTalhaoParcelas(BuildContext context, TalhaoResumo resumo) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TelaParcelasTalhao(talhaoId: resumo.talhao.id),
      ),
    );
  }

  Future<void> _confirmarExcluirTalhao(
    BuildContext context,
    WidgetRef ref,
    TalhaoResumo resumo,
  ) async {
    final talhao = resumo.talhao;
    final mensagem = resumo.possuiFilhos
        ? 'O talhão já contém levantamentos vinculados. Se confirmar, todos os dados salvos relacionados serão apagados. Deseja continuar?'
        : 'Deseja excluir o talhão "${talhao.identificacao}"?';

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir talhão'),
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

    await ref.read(provedorRepositorioTalhoes).excluir(talhao.id);
    ref.invalidate(provedorPropriedadeTalhoes(propriedade.id));
    ref.invalidate(provedorPropriedadeResumos);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Talhão ${talhao.identificacao} excluído.')),
    );
  }
}

class _PropriedadeResumoCartao extends StatelessWidget {
  const _PropriedadeResumoCartao({
    required this.propriedade,
    required this.aoAbrirResultados,
    required this.aoExportacao,
  });

  final Propriedade propriedade;
  final VoidCallback aoAbrirResultados;
  final VoidCallback aoExportacao;

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
              Expanded(
                child: Text(
                  propriedade.nome,
                  style: const TextStyle(
                    color: CoresDendro.principal,
                    fontSize: 22,
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
              const SizedBox(width: 6),
              IconButton.filledTonal(
                onPressed: aoExportacao,
                icon: const Icon(Icons.ios_share),
                tooltip: 'Exportar',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _MetadadosIndicador(
                icone: Icons.place,
                rotulo: '${propriedade.municipio}-${propriedade.estado}',
              ),
              _MetadadosIndicador(
                icone: Icons.area_chart,
                rotulo: '${_formatoArea(propriedade.areaTotalHa)} ha',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TalhaoItem extends StatelessWidget {
  const _TalhaoItem({
    required this.resumo,
    required this.aoAbrir,
    required this.aoEditar,
    required this.aoExcluir,
  });

  final TalhaoResumo resumo;
  final VoidCallback aoAbrir;
  final VoidCallback aoEditar;
  final VoidCallback aoExcluir;

  @override
  Widget build(BuildContext context) {
    final talhao = resumo.talhao;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: aoAbrir,
        child: CartaoDendro(
          espacamentoInterno: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          filho: Row(
            children: [
              Container(
                width: 42,
                height: 42,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            talhao.identificacao,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (resumo.possuiAtivoLevantamento) ...[
                          const SizedBox(width: 8),
                          const SituacaoIndicador(rotulo: 'Em coleta'),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        _MetadadosTexto(
                          icone: Icons.eco,
                          rotulo: resumo.especie.nome,
                        ),
                        _MetadadosTexto(
                          icone: Icons.area_chart,
                          rotulo: '${_formatoArea(talhao.areaHa)} ha',
                        ),
                        if (talhao.anoPlantio != null)
                          _MetadadosTexto(
                            icone: Icons.calendar_month,
                            rotulo: 'Plantio ${talhao.anoPlantio}',
                          ),
                        if (_formatoParcelaDimensao(talhao) != null)
                          _MetadadosTexto(
                            icone: Icons.crop_free,
                            rotulo:
                                'Parcela ${_formatoParcelaDimensao(talhao)} m',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_TalhaoAcao>(
                tooltip: 'Ações',
                icon: const Icon(Icons.more_vert),
                onSelected: (acao) {
                  switch (acao) {
                    case _TalhaoAcao.editar:
                      aoEditar();
                    case _TalhaoAcao.excluir:
                      aoExcluir();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _TalhaoAcao.editar,
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 10),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: _TalhaoAcao.excluir,
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

class _TalhaoFormularioPainel extends ConsumerStatefulWidget {
  const _TalhaoFormularioPainel({required this.propriedadeId, this.resumo});

  final int propriedadeId;
  final TalhaoResumo? resumo;

  @override
  ConsumerState<_TalhaoFormularioPainel> createState() =>
      _TalhaoFormularioPainelEstado();
}

class _TalhaoFormularioPainelEstado
    extends ConsumerState<_TalhaoFormularioPainel> {
  final _chaveFormulario = GlobalKey<FormState>();
  late final TextEditingController _identificacaoControlador;
  late final TextEditingController _areaControlador;
  late final TextEditingController _plantioAnoControlador;
  late final TextEditingController _espacamentoControlador;
  late final TextEditingController _manejoRegimeControlador;
  late final TextEditingController _parcelaLarguraControlador;
  late final TextEditingController _parcelaComprimentoControlador;
  late final TextEditingController _observacoesControlador;
  int? _especieId;
  bool _salvando = false;

  bool get _estaEditando => widget.resumo != null;

  @override
  void initState() {
    super.initState();
    final talhao = widget.resumo?.talhao;

    _identificacaoControlador = TextEditingController(
      text: talhao?.identificacao ?? '',
    );
    _areaControlador = TextEditingController(
      text: talhao == null ? '' : _formatoArea(talhao.areaHa),
    );
    _plantioAnoControlador = TextEditingController(
      text: talhao?.anoPlantio?.toString() ?? '',
    );
    _espacamentoControlador = TextEditingController(
      text: talhao?.espacamento ?? '',
    );
    _manejoRegimeControlador = TextEditingController(
      text: talhao?.regimeManejo ?? '',
    );
    _parcelaLarguraControlador = TextEditingController(
      text: talhao?.larguraParcelaM == null
          ? ''
          : _formatoArea(talhao!.larguraParcelaM!),
    );
    _parcelaComprimentoControlador = TextEditingController(
      text: talhao?.comprimentoParcelaM == null
          ? ''
          : _formatoArea(talhao!.comprimentoParcelaM!),
    );
    _observacoesControlador = TextEditingController(
      text: talhao?.observacoes ?? '',
    );
    _especieId = talhao?.especieId;
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
                  Expanded(
                    child: Text(
                      _estaEditando ? 'Editar talhão' : 'Novo talhão',
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
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Identificação',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                validator: _obrigatorioValidator,
              ),
              const SizedBox(height: 12),
              especies.when(
                data: (itens) => DropdownButtonFormField<int>(
                  initialValue: _especieId,
                  decoration: const InputDecoration(
                    labelText: 'Espécie',
                    prefixIcon: Icon(Icons.eco_outlined),
                  ),
                  items: [
                    for (final item in itens)
                      DropdownMenuItem(value: item.id, child: Text(item.nome)),
                  ],
                  onChanged: _salvando
                      ? null
                      : (valor) => setState(() => _especieId = valor),
                  validator: (valor) =>
                      valor == null ? 'Selecione uma espécie' : null,
                ),
                loading: () =>
                    const CartaoDendro(filho: LinearProgressIndicator()),
                error: (erro, pilhaTrace) => const CartaoDendro(
                  filho: Text('Não foi possível carregar as espécies.'),
                ),
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

    final repositorio = ref.read(provedorRepositorioTalhoes);
    final area = _interpretarArea(_areaControlador.text)!;
    final anoPlantio = _interpretarOpcionalInteiro(_plantioAnoControlador.text);

    try {
      if (_estaEditando) {
        await repositorio.atualizar(
          id: widget.resumo!.talhao.id,
          identificacao: _identificacaoControlador.text,
          especieId: _especieId!,
          areaHa: area,
          anoPlantio: anoPlantio,
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
      } else {
        await repositorio.criar(
          propriedadeId: widget.propriedadeId,
          identificacao: _identificacaoControlador.text,
          especieId: _especieId!,
          areaHa: area,
          anoPlantio: anoPlantio,
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
      }

      if (!mounted) return;
      ref.invalidate(provedorPropriedadeTalhoes(widget.propriedadeId));
      ref.invalidate(provedorPropriedadeResumos);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _estaEditando ? 'Talhão atualizado.' : 'Talhão cadastrado.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar o talhão.')),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
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

class _VazioTalhoesCartao extends StatelessWidget {
  const _VazioTalhoesCartao({required this.aoCriar});

  final VoidCallback aoCriar;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      fundoCor: const Color(0xFFF3F4F3),
      filho: Column(
        children: [
          const Icon(
            Icons.forest_outlined,
            size: 42,
            color: CoresDendro.secundario,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhum talhão cadastrado',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Cadastre os talhões da propriedade para organizar os levantamentos.',
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
              label: const Text('Cadastrar talhão'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarregarErroCartao extends StatelessWidget {
  const _CarregarErroCartao({
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

class _MetadadosIndicador extends StatelessWidget {
  const _MetadadosIndicador({required this.icone, required this.rotulo});

  final IconData icone;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    final fundoCor = Theme.of(context).brightness == Brightness.dark
        ? CoresDendro.escuroLegivelCampo
        : Colors.white;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: fundoCor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 14, color: CoresDendro.principal),
            const SizedBox(width: 5),
            Text(
              rotulo,
              style: const TextStyle(
                color: CoresDendro.principal,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadadosTexto extends StatelessWidget {
  const _MetadadosTexto({required this.icone, required this.rotulo});

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
            color: CoresDendro.textoDiscreto,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

enum _TalhaoAcao { editar, excluir }

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
