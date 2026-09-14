import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../aplicativo/tema/tema_dendro.dart';
import '../../../nucleo/banco/banco_dendro.dart';
import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../dados/repositorio_propriedades.dart';
import 'tela_detalhe_propriedade.dart';

Future<bool?> mostrarPropriedadeFormularioPainel(
  BuildContext context, {
  Propriedade? propriedade,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) =>
        _PropriedadeFormularioPainel(propriedade: propriedade),
  );
}

class TelaPropriedades extends ConsumerStatefulWidget {
  const TelaPropriedades({super.key});

  @override
  ConsumerState<TelaPropriedades> createState() => _PropriedadesTelaEstado();
}

class _PropriedadesTelaEstado extends ConsumerState<TelaPropriedades> {
  late final TextEditingController _buscaControlador;

  @override
  void initState() {
    super.initState();
    _buscaControlador = TextEditingController();
  }

  @override
  void dispose() {
    _buscaControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resumos = ref.watch(provedorPropriedadeResumos);
    final avancadoFiltros = ref.watch(provedorPropriedadeAvancadoFiltros);

    return TelaDendro(
      titulo: 'Propriedades',
      icone: Icons.map,
      flutuanteAcaoBotao: FloatingActionButton(
        heroTag: 'properties_new_property',
        onPressed: () => _abrirPropriedadeFormulario(context),
        tooltip: 'Nova propriedade',
        child: const Icon(Icons.add_home_work),
      ),
      filhos: [
        _PropriedadeFiltros(
          controlador: _buscaControlador,
          filtros: avancadoFiltros,
          aoAlterado: (valor) {
            ref.read(provedorPropriedadeBuscaConsulta.notifier).state = valor;
          },
          aoAbrirFiltros: () => _abrirFiltros(context, avancadoFiltros),
          aoLimparFiltros: () {
            ref.read(provedorPropriedadeAvancadoFiltros.notifier).state =
                const PropriedadeAvancadoFiltros();
          },
        ),
        const SizedBox(height: 16),
        resumos.when(
          data: (itens) {
            if (itens.isEmpty) {
              return _VazioPropriedadesEstado(
                possuiBusca:
                    _buscaControlador.text.trim().isNotEmpty ||
                    avancadoFiltros.ativo,
                aoCriar: () => _abrirPropriedadeFormulario(context),
              );
            }

            return Column(
              children: [
                for (final item in itens)
                  _PropriedadeItem(
                    resumo: item,
                    aoAbrir: () =>
                        _abrirPropriedadeDetalhe(context, item.propriedade),
                    aoEditar: () => _abrirPropriedadeFormulario(
                      context,
                      propriedade: item.propriedade,
                    ),
                    aoExcluir: () => _confirmarExcluir(context, item),
                  ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (erro, pilhaTrace) => _CarregarErroCartao(
            mensagem: 'Não foi possível carregar as propriedades.',
            aoTentarNovamente: () => ref.invalidate(provedorPropriedadeResumos),
          ),
        ),
      ],
    );
  }

  Future<void> _abrirPropriedadeDetalhe(
    BuildContext context,
    Propriedade propriedade,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TelaDetalhePropriedade(propriedade: propriedade),
      ),
    );
  }

  Future<void> _abrirPropriedadeFormulario(
    BuildContext context, {
    Propriedade? propriedade,
  }) async {
    await mostrarPropriedadeFormularioPainel(context, propriedade: propriedade);
  }

  Future<void> _abrirFiltros(
    BuildContext context,
    PropriedadeAvancadoFiltros filtros,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _PropriedadeAvancadoFiltrosPainel(
        inicialFiltros: filtros,
        aoAplicar: (proximoFiltros) {
          ref.read(provedorPropriedadeAvancadoFiltros.notifier).state =
              proximoFiltros;
        },
      ),
    );
  }

  Future<void> _confirmarExcluir(
    BuildContext context,
    PropriedadeResumo resumo,
  ) async {
    final propriedade = resumo.propriedade;
    final mensagem = resumo.possuiFilhos
        ? 'A propriedade já contém talhões ou levantamentos. Se confirmar, todos os dados relacionados serão apagados. Deseja continuar?'
        : 'Deseja excluir a propriedade "${propriedade.nome}"?';

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir propriedade'),
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

    await ref.read(provedorRepositorioPropriedades).excluir(propriedade.id);

    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${propriedade.nome} excluída.')));
  }
}

class _PropriedadeFiltros extends StatelessWidget {
  const _PropriedadeFiltros({
    required this.controlador,
    required this.filtros,
    required this.aoAlterado,
    required this.aoAbrirFiltros,
    required this.aoLimparFiltros,
  });

  final TextEditingController controlador;
  final PropriedadeAvancadoFiltros filtros;
  final ValueChanged<String> aoAlterado;
  final VoidCallback aoAbrirFiltros;
  final VoidCallback aoLimparFiltros;

  @override
  Widget build(BuildContext context) {
    final ativoRotulos = _ativoFiltroRotulos(filtros);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controlador,
                onChanged: aoAlterado,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar propriedade',
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.outlined(
              onPressed: aoAbrirFiltros,
              icon: Icon(filtros.ativo ? Icons.filter_alt : Icons.tune),
              tooltip: 'Filtros',
              style: IconButton.styleFrom(
                minimumSize: const Size(52, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        if (ativoRotulos.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final rotulo in ativoRotulos)
                ActionChip(
                  label: Text(rotulo),
                  avatar: const Icon(Icons.filter_alt, size: 16),
                  onPressed: aoAbrirFiltros,
                ),
              ActionChip(
                label: const Text('Limpar filtros'),
                avatar: const Icon(Icons.close, size: 16),
                onPressed: aoLimparFiltros,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _PropriedadeAvancadoFiltrosPainel extends StatefulWidget {
  const _PropriedadeAvancadoFiltrosPainel({
    required this.inicialFiltros,
    required this.aoAplicar,
  });

  final PropriedadeAvancadoFiltros inicialFiltros;
  final ValueChanged<PropriedadeAvancadoFiltros> aoAplicar;

  @override
  State<_PropriedadeAvancadoFiltrosPainel> createState() =>
      _PropriedadeAvancadoFiltrosPainelEstado();
}

class _PropriedadeAvancadoFiltrosPainelEstado
    extends State<_PropriedadeAvancadoFiltrosPainel> {
  late final TextEditingController _municipioControlador;
  late final TextEditingController _minimoAreaControlador;
  late final TextEditingController _maximoAreaControlador;
  late final TextEditingController _minimoTalhaoControlador;
  late final TextEditingController _maximoTalhaoControlador;

  @override
  void initState() {
    super.initState();
    final filtros = widget.inicialFiltros;
    _municipioControlador = TextEditingController(text: filtros.municipio);
    _minimoAreaControlador = TextEditingController(
      text: filtros.minimoAreaHa == null
          ? ''
          : _formatoArea(filtros.minimoAreaHa!),
    );
    _maximoAreaControlador = TextEditingController(
      text: filtros.maximoAreaHa == null
          ? ''
          : _formatoArea(filtros.maximoAreaHa!),
    );
    _minimoTalhaoControlador = TextEditingController(
      text: filtros.minimoTalhaoQuantidade?.toString() ?? '',
    );
    _maximoTalhaoControlador = TextEditingController(
      text: filtros.maximoTalhaoQuantidade?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _municipioControlador.dispose();
    _minimoAreaControlador.dispose();
    _maximoAreaControlador.dispose();
    _minimoTalhaoControlador.dispose();
    _maximoTalhaoControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inferiorRecuo = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: inferiorRecuo),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Filtros de propriedades',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  tooltip: 'Fechar',
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _municipioControlador,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Município',
                prefixIcon: Icon(Icons.place_outlined),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minimoAreaControlador,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Área mín. (ha)',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _maximoAreaControlador,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Área máx. (ha)',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minimoTalhaoControlador,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Talhões mín.',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _maximoTalhaoControlador,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Talhões máx.',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _limpar,
                    icon: const Icon(Icons.cleaning_services_outlined),
                    label: const Text('Limpar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _aplicar,
                    icon: const Icon(Icons.check),
                    label: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _limpar() {
    widget.aoAplicar(const PropriedadeAvancadoFiltros());
    Navigator.of(context).pop();
  }

  void _aplicar() {
    final minimoArea = _interpretarOpcionalArea(_minimoAreaControlador.text);
    final maximoArea = _interpretarOpcionalArea(_maximoAreaControlador.text);
    final minimoTalhao = _interpretarOpcionalInteiro(
      _minimoTalhaoControlador.text,
    );
    final maximoTalhao = _interpretarOpcionalInteiro(
      _maximoTalhaoControlador.text,
    );

    if (_invalidoOpcionalNumero(_minimoAreaControlador.text, minimoArea) ||
        _invalidoOpcionalNumero(_maximoAreaControlador.text, maximoArea) ||
        _invalidoOpcionalNumero(_minimoTalhaoControlador.text, minimoTalhao) ||
        _invalidoOpcionalNumero(_maximoTalhaoControlador.text, maximoTalhao)) {
      _mostrarFiltroErro('Revise os valores informados.');
      return;
    }
    if (minimoArea != null && maximoArea != null && minimoArea > maximoArea) {
      _mostrarFiltroErro('A área mínima não pode ser maior que a máxima.');
      return;
    }
    if (minimoTalhao != null &&
        maximoTalhao != null &&
        minimoTalhao > maximoTalhao) {
      _mostrarFiltroErro(
        'A quantidade mínima de talhões não pode ser maior que a máxima.',
      );
      return;
    }

    widget.aoAplicar(
      PropriedadeAvancadoFiltros(
        municipio: _municipioControlador.text.trim(),
        minimoAreaHa: minimoArea,
        maximoAreaHa: maximoArea,
        minimoTalhaoQuantidade: minimoTalhao,
        maximoTalhaoQuantidade: maximoTalhao,
      ),
    );
    Navigator.of(context).pop();
  }

  void _mostrarFiltroErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red.shade700, content: Text(mensagem)),
    );
  }
}

class _PropriedadeItem extends StatelessWidget {
  const _PropriedadeItem({
    required this.resumo,
    required this.aoAbrir,
    required this.aoEditar,
    required this.aoExcluir,
  });

  final PropriedadeResumo resumo;
  final VoidCallback aoAbrir;
  final VoidCallback aoEditar;
  final VoidCallback aoExcluir;

  @override
  Widget build(BuildContext context) {
    final propriedade = resumo.propriedade;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: aoAbrir,
        child: CartaoDendro(
          espacamentoInterno: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          filho: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      propriedade.nome,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        _PropriedadeMetadados(
                          icone: Icons.place,
                          rotulo:
                              '${propriedade.municipio}-${propriedade.estado}',
                        ),
                        _PropriedadeMetadados(
                          icone: Icons.area_chart,
                          rotulo: '${_formatoArea(propriedade.areaTotalHa)} ha',
                        ),
                        _PropriedadeMetadados(
                          icone: Icons.grid_view,
                          rotulo: _formatoTalhaoQuantidade(
                            resumo.talhaoQuantidade,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_PropriedadeAcao>(
                tooltip: 'Ações',
                icon: const Icon(Icons.more_vert),
                onSelected: (acao) {
                  switch (acao) {
                    case _PropriedadeAcao.editar:
                      aoEditar();
                    case _PropriedadeAcao.excluir:
                      aoExcluir();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _PropriedadeAcao.editar,
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 10),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: _PropriedadeAcao.excluir,
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

class _PropriedadeMetadados extends StatelessWidget {
  const _PropriedadeMetadados({required this.icone, required this.rotulo});

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

class _PropriedadeFormularioPainel extends ConsumerStatefulWidget {
  const _PropriedadeFormularioPainel({this.propriedade});

  final Propriedade? propriedade;

  @override
  ConsumerState<_PropriedadeFormularioPainel> createState() =>
      _PropriedadeFormularioPainelEstado();
}

class _PropriedadeFormularioPainelEstado
    extends ConsumerState<_PropriedadeFormularioPainel> {
  final _chaveFormulario = GlobalKey<FormState>();
  late final TextEditingController _nomeControlador;
  late final TextEditingController _municipioControlador;
  late final TextEditingController _estadoControlador;
  late final TextEditingController _areaControlador;
  bool _salvando = false;

  bool get _estaEditando => widget.propriedade != null;

  @override
  void initState() {
    super.initState();
    final propriedade = widget.propriedade;

    _nomeControlador = TextEditingController(text: propriedade?.nome ?? '');
    _municipioControlador = TextEditingController(
      text: propriedade?.municipio ?? '',
    );
    _estadoControlador = TextEditingController(
      text: propriedade?.estado ?? 'RS',
    );
    _areaControlador = TextEditingController(
      text: propriedade == null ? '' : _formatoArea(propriedade.areaTotalHa),
    );
  }

  @override
  void dispose() {
    _nomeControlador.dispose();
    _municipioControlador.dispose();
    _estadoControlador.dispose();
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
                      _estaEditando ? 'Editar propriedade' : 'Nova propriedade',
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
                controller: _nomeControlador,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome da propriedade',
                  prefixIcon: Icon(Icons.home_work_outlined),
                ),
                validator: _obrigatorioValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _municipioControlador,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Município',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
                validator: _obrigatorioValidator,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    width: 92,
                    child: TextFormField(
                      controller: _estadoControlador,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(2),
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                      ],
                      decoration: const InputDecoration(labelText: 'UF'),
                      validator: _obrigatorioValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _areaControlador,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Área total (ha)',
                        prefixIcon: Icon(Icons.area_chart_outlined),
                      ),
                      validator: _validarArea,
                    ),
                  ),
                ],
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

    final repositorio = ref.read(provedorRepositorioPropriedades);
    final area = _interpretarArea(_areaControlador.text)!;
    final estado = _estadoControlador.text.trim().toUpperCase();

    try {
      if (_estaEditando) {
        await repositorio.atualizar(
          id: widget.propriedade!.id,
          nome: _nomeControlador.text,
          municipio: _municipioControlador.text,
          estado: estado,
          areaTotalHa: area,
        );
      } else {
        await repositorio.criar(
          nome: _nomeControlador.text,
          municipio: _municipioControlador.text,
          estado: estado,
          areaTotalHa: area,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _estaEditando
                ? 'Propriedade atualizada.'
                : 'Propriedade cadastrada.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar a propriedade.')),
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

    if (area == null) {
      return 'Informe uma área válida';
    }
    if (area < 0) {
      return 'Área não pode ser negativa';
    }
    return null;
  }
}

class _VazioPropriedadesEstado extends StatelessWidget {
  const _VazioPropriedadesEstado({
    required this.possuiBusca,
    required this.aoCriar,
  });

  final bool possuiBusca;
  final VoidCallback aoCriar;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      fundoCor: const Color(0xFFF3F4F3),
      bordaCor: CoresDendro.contorno,
      filho: Column(
        children: [
          Icon(
            possuiBusca ? Icons.search_off : Icons.add_home_work_outlined,
            size: 42,
            color: CoresDendro.secundario,
          ),
          const SizedBox(height: 12),
          Text(
            possuiBusca
                ? 'Nenhuma propriedade encontrada'
                : 'Nenhuma propriedade cadastrada',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            possuiBusca
                ? 'Tente buscar por outro nome.'
                : 'Cadastre a primeira propriedade para iniciar os levantamentos.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CoresDendro.textoDiscreto,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (!possuiBusca) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: aoCriar,
                icon: const Icon(Icons.add),
                label: const Text('Cadastrar propriedade'),
              ),
            ),
          ],
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

enum _PropriedadeAcao { editar, excluir }

List<String> _ativoFiltroRotulos(PropriedadeAvancadoFiltros filtros) {
  final rotulos = <String>[];
  final municipio = filtros.municipio.trim();

  if (municipio.isNotEmpty) {
    rotulos.add('Município: $municipio');
  }
  if (filtros.minimoAreaHa != null || filtros.maximoAreaHa != null) {
    rotulos.add(
      'Área: ${_intervaloRotulo(filtros.minimoAreaHa, filtros.maximoAreaHa, sufixo: ' ha')}',
    );
  }
  if (filtros.minimoTalhaoQuantidade != null ||
      filtros.maximoTalhaoQuantidade != null) {
    rotulos.add(
      'Talhões: ${_intervaloRotulo(filtros.minimoTalhaoQuantidade, filtros.maximoTalhaoQuantidade)}',
    );
  }

  return rotulos;
}

String _intervaloRotulo(num? minimo, num? maximo, {String sufixo = ''}) {
  if (minimo != null && maximo != null) {
    return '${_formatoNumero(minimo)}-${_formatoNumero(maximo)}$sufixo';
  }
  if (minimo != null) return 'acima de ${_formatoNumero(minimo)}$sufixo';
  return 'até ${_formatoNumero(maximo!)}$sufixo';
}

String _formatoNumero(num valor) {
  if (valor is int || valor == valor.roundToDouble()) {
    return valor.toStringAsFixed(0);
  }
  return valor.toStringAsFixed(2).replaceAll('.', ',');
}

String _formatoArea(double valor) {
  return valor.toStringAsFixed(2).replaceAll('.', ',');
}

String _formatoTalhaoQuantidade(int quantidade) {
  return quantidade == 1 ? '1 talhão' : '$quantidade talhões';
}

double? _interpretarArea(String valor) {
  return double.tryParse(valor.trim().replaceAll(',', '.'));
}

double? _interpretarOpcionalArea(String valor) {
  final normalizado = valor.trim();
  if (normalizado.isEmpty) return null;
  return _interpretarArea(normalizado);
}

int? _interpretarOpcionalInteiro(String valor) {
  final normalizado = valor.trim();
  if (normalizado.isEmpty) return null;
  return int.tryParse(normalizado);
}

bool _invalidoOpcionalNumero(String bruto, Object? interpretado) {
  return bruto.trim().isNotEmpty && interpretado == null;
}
