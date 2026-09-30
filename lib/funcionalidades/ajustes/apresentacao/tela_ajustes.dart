import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../aplicativo/tema/tema_dendro.dart';
import '../../../nucleo/banco/banco_dendro.dart';
import '../../../nucleo/preferencias/controlador_tema.dart';
import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../../backup/apresentacao/tela_backup_restauracao.dart';
import '../dados/repositorio_ajustes.dart';

class TelaAjustes extends StatelessWidget {
  const TelaAjustes({super.key});

  @override
  Widget build(BuildContext context) {
    return TelaDendro(
      titulo: 'Ajustes',
      icone: Icons.settings,
      filhos: [
        const TituloSecao(titulo: 'Preferências'),
        const _TemaModoCartao(),
        const SizedBox(height: 18),
        const TituloSecao(titulo: 'Cadastros'),
        _AjustesOpcaoBloco(
          icone: Icons.eco_outlined,
          titulo: 'Cadastro de espécies',
          subtitulo: 'Espécies, vínculos de fórmulas e modelo padrão.',
          aoTocar: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const _TelaEspecieAjustes(),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        _AjustesOpcaoBloco(
          icone: Icons.functions,
          titulo: 'Modelos matemáticos',
          subtitulo: 'Fórmulas, variáveis e símbolos dos coeficientes.',
          aoTocar: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const _TelaModeloMatematicoAjustes(),
              ),
            );
          },
        ),
        const SizedBox(height: 18),
        const TituloSecao(titulo: 'Dados'),
        _AjustesOpcaoBloco(
          icone: Icons.backup_outlined,
          titulo: 'Backup e Restauração',
          subtitulo: 'Salve, compartilhe ou restaure todos os dados do app.',
          aoTocar: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const TelaBackupRestauracao(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TelaEspecieAjustes extends ConsumerWidget {
  const _TelaEspecieAjustes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final especieAsync = ref.watch(provedorEspeciesAjustes);
    final modelosMatematicosAsync = ref.watch(
      provedorAjustesModelosMatematicos,
    );
    final especieModelosMatematicosAsync = ref.watch(
      provedorVinculosEspecieModelo,
    );
    final especieModeloMatematicoCoeficientesAsync = ref.watch(
      provedorCoeficientesModeloPorEspecie,
    );

    return TelaDendro(
      titulo: 'Cadastro de espécies',
      icone: Icons.eco,
      flutuanteAcaoBotao: FloatingActionButton(
        heroTag: 'settings_new_species',
        onPressed: () => _abrirEspecieFormulario(context),
        tooltip: 'Nova espécie',
        child: const Icon(Icons.add),
      ),
      filhos: [
        const TituloSecao(titulo: 'Espécies cadastradas'),
        _CatalogoEstado(
          asyncValores: [
            especieAsync,
            modelosMatematicosAsync,
            especieModelosMatematicosAsync,
            especieModeloMatematicoCoeficientesAsync,
          ],
          aoTentarNovamente: () {
            ref.invalidate(provedorEspeciesAjustes);
            ref.invalidate(provedorAjustesModelosMatematicos);
            ref.invalidate(provedorVinculosEspecieModelo);
            ref.invalidate(provedorCoeficientesModeloPorEspecie);
          },
          construtor: () {
            final especies = especieAsync.value ?? const <Especie>[];
            final modelosMatematicos =
                modelosMatematicosAsync.value ??
                const <ModeloMatematicoResumo>[];
            final vinculos =
                especieModelosMatematicosAsync.value ?? const <EspecieModelo>[];
            final coeficientes =
                especieModeloMatematicoCoeficientesAsync.value ??
                const <CoeficienteEspecieModelo>[];

            if (especies.isEmpty) {
              return _VazioCatalogoCartao(
                icone: Icons.eco_outlined,
                titulo: 'Nenhuma espécie cadastrada',
                mensagem:
                    'Cadastre espécies para vincular os modelos matemáticos.',
                botaoRotulo: 'Cadastrar espécie',
                aoPressionado: () => _abrirEspecieFormulario(context),
              );
            }

            return Column(
              children: [
                for (final item in especies)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _EspecieCartao(
                      especie: item,
                      modelosMatematicos: modelosMatematicos,
                      vinculos: vinculos
                          .where((vinculo) => vinculo.especieId == item.id)
                          .toList(),
                      coeficientes: coeficientes
                          .where(
                            (coeficiente) => coeficiente.especieId == item.id,
                          )
                          .toList(),
                      aoEditar: () =>
                          _abrirEspecieFormulario(context, especie: item),
                      aoExcluir: () =>
                          _confirmarExcluirEspecie(context, ref, item),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TelaModeloMatematicoAjustes extends ConsumerWidget {
  const _TelaModeloMatematicoAjustes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelosMatematicosAsync = ref.watch(
      provedorAjustesModelosMatematicos,
    );

    return TelaDendro(
      titulo: 'Modelos matemáticos',
      icone: Icons.functions,
      flutuanteAcaoBotao: FloatingActionButton(
        heroTag: 'settings_new_formula',
        onPressed: () => _abrirModeloMatematicoFormulario(context),
        tooltip: 'Nova fórmula',
        child: const Icon(Icons.add),
      ),
      filhos: [
        const TituloSecao(titulo: 'Fórmulas cadastradas'),
        modelosMatematicosAsync.when(
          data: (modelosMatematicos) {
            if (modelosMatematicos.isEmpty) {
              return _VazioCatalogoCartao(
                icone: Icons.functions,
                titulo: 'Nenhuma fórmula cadastrada',
                mensagem:
                    'Cadastre os modelos que serão usados no cálculo de volume.',
                botaoRotulo: 'Cadastrar fórmula',
                aoPressionado: () => _abrirModeloMatematicoFormulario(context),
              );
            }

            return Column(
              children: [
                for (final modeloMatematico in modelosMatematicos)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ModeloMatematicoCartao(
                      key: ValueKey(modeloMatematico.modeloMatematico.id),
                      resumo: modeloMatematico,
                      aoEditar: () => _abrirModeloMatematicoFormulario(
                        context,
                        resumo: modeloMatematico,
                      ),
                      aoExcluir: () => _confirmarExcluirModeloMatematico(
                        context,
                        ref,
                        modeloMatematico.modeloMatematico,
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const _CarregandoCartao(),
          error: (erro, pilhaTrace) => _AjustesErroCartao(
            mensagem: 'Não foi possível carregar as fórmulas.',
            aoTentarNovamente: () =>
                ref.invalidate(provedorAjustesModelosMatematicos),
          ),
        ),
      ],
    );
  }
}

class _AjustesOpcaoBloco extends StatelessWidget {
  const _AjustesOpcaoBloco({
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.aoTocar,
  });

  final IconData icone;
  final String titulo;
  final String subtitulo;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: aoTocar,
      child: CartaoDendro(
        espacamentoInterno: const EdgeInsets.fromLTRB(14, 12, 8, 12),
        filho: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: CoresDendro.principalSuave,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icone, color: CoresDendro.principal),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitulo,
                    maxLines: 2,
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
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: CoresDendro.textoDiscreto),
          ],
        ),
      ),
    );
  }
}

Future<void> _abrirEspecieFormulario(BuildContext context, {Especie? especie}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _EspecieFormularioPainel(especie: especie),
  );
}

Future<void> _abrirModeloMatematicoFormulario(
  BuildContext context, {
  ModeloMatematicoResumo? resumo,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _ModeloMatematicoFormularioPainel(resumo: resumo),
  );
}

Future<void> _confirmarExcluirEspecie(
  BuildContext context,
  WidgetRef ref,
  Especie especie,
) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Excluir espécie'),
      content: Text(
        'Deseja excluir "${especie.nome}"? Se ela estiver vinculada a talhões, o app não permitirá a exclusão.',
      ),
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

  try {
    await ref.read(provedorRepositorioAjustes).excluirEspecie(especie.id);
    if (!context.mounted) return;
    _mostrarAviso(context, '${especie.nome} excluída.');
  } catch (_) {
    if (!context.mounted) return;
    _mostrarAviso(
      context,
      'Não foi possível excluir a espécie. Verifique se ela está em uso.',
      estaErro: true,
    );
  }
}

Future<void> _confirmarExcluirModeloMatematico(
  BuildContext context,
  WidgetRef ref,
  ModeloMatematico modeloMatematico,
) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Excluir fórmula'),
      content: Text(
        'Deseja excluir "${modeloMatematico.nome}"? Se ela estiver em uso em algum levantamento, o app não permitirá a exclusão.',
      ),
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

  try {
    await ref
        .read(provedorRepositorioAjustes)
        .excluirModeloMatematico(modeloMatematico.id);
    if (!context.mounted) return;
    _mostrarAviso(context, '${modeloMatematico.nome} excluída.');
  } catch (_) {
    if (!context.mounted) return;
    _mostrarAviso(
      context,
      'Não foi possível excluir a fórmula. Verifique se ela está em uso.',
      estaErro: true,
    );
  }
}

class _CatalogoEstado extends StatelessWidget {
  const _CatalogoEstado({
    required this.asyncValores,
    required this.construtor,
    required this.aoTentarNovamente,
  });

  final List<AsyncValue<Object?>> asyncValores;
  final Widget Function() construtor;
  final VoidCallback aoTentarNovamente;

  @override
  Widget build(BuildContext context) {
    if (asyncValores.any((valor) => valor.hasError)) {
      return _AjustesErroCartao(
        mensagem: 'Não foi possível carregar os cadastros.',
        aoTentarNovamente: aoTentarNovamente,
      );
    }

    if (asyncValores.any((valor) => valor.isLoading && !valor.hasValue)) {
      return const _CarregandoCartao();
    }

    return construtor();
  }
}

class _TemaModoCartao extends ConsumerWidget {
  const _TemaModoCartao();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final escuroModo = ref.watch(provedorModoEscuro);

    return CartaoDendro(
      espacamentoInterno: const EdgeInsets.fromLTRB(4, 4, 10, 4),
      filho: Material(
        color: Colors.transparent,
        child: SwitchListTile(
          value: escuroModo,
          onChanged: (habilitado) async {
            try {
              await ref
                  .read(provedorControladorTema.notifier)
                  .definirModoEscuro(habilitado);
              if (!context.mounted) return;
              _mostrarAviso(
                context,
                habilitado ? 'Modo escuro ativado.' : 'Modo claro ativado.',
              );
            } catch (_) {
              if (!context.mounted) return;
              _mostrarAviso(
                context,
                'Não foi possível salvar a preferência de tema.',
                estaErro: true,
              );
            }
          },
          secondary: Icon(
            escuroModo ? Icons.dark_mode : Icons.light_mode_outlined,
            color: CoresDendro.principal,
          ),
          title: const Text(
            'Modo escuro',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          subtitle: const Text(
            'Aplica o tema escuro ao app e mantém essa escolha ao abrir novamente.',
          ),
          contentPadding: const EdgeInsets.only(left: 8),
          activeThumbColor: CoresDendro.principal,
        ),
      ),
    );
  }
}

class _EspecieCartao extends ConsumerWidget {
  const _EspecieCartao({
    required this.especie,
    required this.modelosMatematicos,
    required this.vinculos,
    required this.coeficientes,
    required this.aoEditar,
    required this.aoExcluir,
  });

  final Especie especie;
  final List<ModeloMatematicoResumo> modelosMatematicos;
  final List<EspecieModelo> vinculos;
  final List<CoeficienteEspecieModelo> coeficientes;
  final VoidCallback aoEditar;
  final VoidCallback aoExcluir;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CartaoDendro(
      espacamentoInterno: EdgeInsets.zero,
      filho: ExpansionTile(
        tilePadding: const EdgeInsets.fromLTRB(14, 8, 4, 8),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        shape: const RoundedRectangleBorder(),
        collapsedShape: const RoundedRectangleBorder(),
        title: Row(
          children: [
            Expanded(
              child: Text(
                especie.nome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            IndicadorSituacao(
              rotulo: especie.ativo ? 'Ativa' : 'Inativa',
              cor: especie.ativo
                  ? CoresDendro.principalSuave
                  : CoresDendro.superficieDiscreto,
              textoCor: especie.ativo
                  ? CoresDendro.principal
                  : CoresDendro.textoDiscreto,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            _especieSubtitulo(especie),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CoresDendro.textoDiscreto,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        trailing: PopupMenuButton<_EspecieAcao>(
          tooltip: 'Ações',
          icon: const Icon(Icons.more_vert),
          onSelected: (acao) {
            switch (acao) {
              case _EspecieAcao.editar:
                aoEditar();
              case _EspecieAcao.excluir:
                aoExcluir();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: _EspecieAcao.editar,
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 10),
                  Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: _EspecieAcao.excluir,
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
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Modelos vinculados',
              style: TextStyle(
                color: CoresDendro.textoDiscreto,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (modelosMatematicos.isEmpty)
            const _DiscretoTexto(
              'Cadastre uma fórmula para vincular à espécie.',
            )
          else
            for (final modeloMatematico in modelosMatematicos)
              _EspecieModeloMatematicoLinha(
                especieId: especie.id,
                resumo: modeloMatematico,
                vinculo: _vinculoParaModeloMatematico(
                  vinculos,
                  modeloMatematico.modeloMatematico.id,
                ),
                coeficientes: coeficientes
                    .where(
                      (coeficiente) =>
                          coeficiente.modeloMatematicoId ==
                          modeloMatematico.modeloMatematico.id,
                    )
                    .toList(),
                aoVinculadoAlterado: (vinculado) async {
                  try {
                    await ref
                        .read(provedorRepositorioAjustes)
                        .definirVinculoEspecieModelo(
                          especieId: especie.id,
                          modeloMatematicoId:
                              modeloMatematico.modeloMatematico.id,
                          vinculado: vinculado,
                        );
                  } catch (_) {
                    if (!context.mounted) return;
                    _mostrarAviso(
                      context,
                      'Não foi possível alterar o vínculo da fórmula.',
                      estaErro: true,
                    );
                  }
                },
                aoDefinirPadrao: () async {
                  try {
                    await ref
                        .read(provedorRepositorioAjustes)
                        .definirModeloPadraoDaEspecie(
                          especieId: especie.id,
                          modeloMatematicoId:
                              modeloMatematico.modeloMatematico.id,
                        );
                  } catch (_) {
                    if (!context.mounted) return;
                    _mostrarAviso(
                      context,
                      'Não foi possível definir a fórmula padrão.',
                      estaErro: true,
                    );
                  }
                },
              ),
        ],
      ),
    );
  }
}

class _EspecieModeloMatematicoLinha extends ConsumerStatefulWidget {
  const _EspecieModeloMatematicoLinha({
    required this.especieId,
    required this.resumo,
    required this.vinculo,
    required this.coeficientes,
    required this.aoVinculadoAlterado,
    required this.aoDefinirPadrao,
  });

  final int especieId;
  final ModeloMatematicoResumo resumo;
  final EspecieModelo? vinculo;
  final List<CoeficienteEspecieModelo> coeficientes;
  final ValueChanged<bool> aoVinculadoAlterado;
  final VoidCallback aoDefinirPadrao;

  @override
  ConsumerState<_EspecieModeloMatematicoLinha> createState() =>
      _EspecieModeloMatematicoLinhaEstado();
}

class _EspecieModeloMatematicoLinhaEstado
    extends ConsumerState<_EspecieModeloMatematicoLinha> {
  final Map<String, TextEditingController> _controladores = {};
  bool _expandido = false;
  bool _salvando = false;

  bool get _vinculado => widget.vinculo != null;
  bool get _padrao => widget.vinculo?.padrao ?? false;

  @override
  void initState() {
    super.initState();
    _sincronizarControladores();
  }

  @override
  void didUpdateWidget(covariant _EspecieModeloMatematicoLinha antigoWidget) {
    super.didUpdateWidget(antigoWidget);
    if (!_vinculado) _expandido = false;
    _sincronizarControladores();
  }

  @override
  void dispose() {
    for (final controlador in _controladores.values) {
      controlador.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estaEscuro = Theme.of(context).brightness == Brightness.dark;
    final modeloMatematico = widget.resumo.modeloMatematico;
    final fundoCor = _padrao
        ? (estaEscuro
              ? CoresDendro.escuroLegivelCampo
              : CoresDendro.principalSuave.withValues(alpha: 0.55))
        : _vinculado
        ? (estaEscuro ? const Color(0xFFD3E4D7) : const Color(0xFFF3F4F3))
        : (estaEscuro ? const Color(0xFFC2D3C7) : const Color(0xFFF3F4F3));
    final bordaCor = _padrao
        ? CoresDendro.principal
        : _vinculado
        ? (estaEscuro ? const Color(0xFF7D9B86) : CoresDendro.contorno)
        : (estaEscuro ? const Color(0xFF91A99A) : CoresDendro.contorno);
    final caixaSelecaoBordaCor = _vinculado
        ? CoresDendro.principal
        : CoresDendro.textoDiscreto;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fundoCor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: bordaCor),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: _vinculado,
                  onChanged: (valor) =>
                      widget.aoVinculadoAlterado(valor ?? false),
                  activeColor: CoresDendro.principal,
                  checkColor: Colors.white,
                  side: BorderSide(color: caixaSelecaoBordaCor, width: 1.5),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _vinculado
                        ? () => setState(() => _expandido = !_expandido)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            modeloMatematico.nome,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: CoresDendro.texto,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            modeloMatematico.expressao,
                            maxLines: 1,
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
                  ),
                ),
                IconButton(
                  onPressed: _vinculado ? widget.aoDefinirPadrao : null,
                  tooltip: _padrao ? 'Fórmula padrão' : 'Definir como padrão',
                  style: IconButton.styleFrom(
                    foregroundColor: _padrao
                        ? CoresDendro.aviso
                        : CoresDendro.textoDiscreto,
                  ),
                  icon: Icon(
                    _padrao ? Icons.star : Icons.star_border,
                    color: _padrao
                        ? CoresDendro.aviso
                        : CoresDendro.textoDiscreto,
                  ),
                ),
                IconButton(
                  onPressed: _vinculado
                      ? () => setState(() => _expandido = !_expandido)
                      : null,
                  tooltip: _expandido ? 'Recolher' : 'Editar coeficientes',
                  icon: Icon(
                    _expandido ? Icons.expand_less : Icons.expand_more,
                    color: _vinculado
                        ? CoresDendro.principal
                        : CoresDendro.textoDiscreto,
                  ),
                ),
              ],
            ),
            if (_expandido && _vinculado)
              _CoeficienteCamposParaEspecie(linha: this),
          ],
        ),
      ),
    );
  }

  void _sincronizarControladores() {
    final simbolos = widget.resumo.coeficientes
        .map((item) => item.simbolo)
        .toSet();
    final valoresPorSimbolo = {
      for (final coeficiente in widget.coeficientes)
        coeficiente.simbolo: coeficiente.valor,
    };

    for (final simbolo in _controladores.keys.toList()) {
      if (!simbolos.contains(simbolo)) {
        _controladores.remove(simbolo)?.dispose();
      }
    }

    for (final coeficiente in widget.resumo.coeficientes) {
      final valor = valoresPorSimbolo[coeficiente.simbolo] ?? coeficiente.valor;
      final texto = valor == null ? '' : _formatoNumero(valor);
      final controlador = _controladores[coeficiente.simbolo];
      if (controlador == null) {
        _controladores[coeficiente.simbolo] = TextEditingController(
          text: texto,
        );
      } else if (controlador.text != texto) {
        controlador.text = texto;
      }
    }
  }

  Future<void> _salvarCoeficientes() async {
    final values = <String, double?>{};

    for (final coeficiente in widget.resumo.coeficientes) {
      final interpretado = _interpretarOpcionalReal(
        _controladores[coeficiente.simbolo]?.text ?? '',
      );
      if (interpretado == _invalidoReal ||
          (coeficiente.simbolo.toLowerCase() == 'ff' &&
              interpretado != null &&
              (interpretado is! double ||
                  !interpretado.isFinite ||
                  interpretado <= 0))) {
        _mostrarAviso(
          context,
          'Informe um valor válido para ${coeficiente.rotulo}.',
          estaErro: true,
        );
        return;
      }
      values[coeficiente.simbolo] = interpretado as double?;
    }

    setState(() => _salvando = true);

    try {
      await ref
          .read(provedorRepositorioAjustes)
          .atualizarCoeficientesModeloDaEspecie(
            especieId: widget.especieId,
            modeloMatematicoId: widget.resumo.modeloMatematico.id,
            valoresPorSimbolo: values,
          );
      if (!mounted) return;
      _mostrarAviso(context, 'Coeficientes da espécie salvos.');
    } catch (_) {
      if (!mounted) return;
      _mostrarAviso(
        context,
        'Não foi possível salvar os coeficientes da espécie.',
        estaErro: true,
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }
}

class _CoeficienteCamposParaEspecie extends StatelessWidget {
  const _CoeficienteCamposParaEspecie({required this.linha});

  final _EspecieModeloMatematicoLinhaEstado linha;

  @override
  Widget build(BuildContext context) {
    final coeficientes = linha.widget.resumo.coeficientes;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          if (coeficientes.isEmpty)
            const _DiscretoTexto(
              'Este modelo não possui coeficientes definidos.',
            )
          else ...[
            const Text(
              'Coeficientes da espécie',
              style: TextStyle(
                color: CoresDendro.textoDiscreto,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Esses valores serão usados como padrão nos novos levantamentos desta espécie.',
              style: TextStyle(
                color: CoresDendro.textoDiscreto,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            for (final coeficiente in coeficientes)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: linha._controladores[coeficiente.simbolo],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[-0-9,.]')),
                  ],
                  decoration: InputDecoration(
                    labelText: '${coeficiente.rotulo} (${coeficiente.simbolo})',
                    prefixIcon: const Icon(Icons.numbers),
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: linha._salvando ? null : linha._salvarCoeficientes,
                icon: linha._salvando
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: const Text('Salvar coeficientes da espécie'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ModeloMatematicoCartao extends StatelessWidget {
  const _ModeloMatematicoCartao({
    required this.resumo,
    required this.aoEditar,
    required this.aoExcluir,
    super.key,
  });

  final ModeloMatematicoResumo resumo;
  final VoidCallback aoEditar;
  final VoidCallback aoExcluir;

  @override
  Widget build(BuildContext context) {
    final modeloMatematico = resumo.modeloMatematico;

    return CartaoDendro(
      espacamentoInterno: EdgeInsets.zero,
      filho: ExpansionTile(
        tilePadding: const EdgeInsets.fromLTRB(14, 8, 4, 8),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        shape: const RoundedRectangleBorder(),
        collapsedShape: const RoundedRectangleBorder(),
        title: Row(
          children: [
            Expanded(
              child: Text(
                modeloMatematico.nome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            IndicadorSituacao(
              rotulo: modeloMatematico.ativo ? 'Ativo' : 'Inativo',
              cor: modeloMatematico.ativo
                  ? CoresDendro.principalSuave
                  : CoresDendro.superficieDiscreto,
              textoCor: modeloMatematico.ativo
                  ? CoresDendro.principal
                  : CoresDendro.textoDiscreto,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            modeloMatematico.expressao,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CoresDendro.textoDiscreto,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        trailing: PopupMenuButton<_ModeloMatematicoAcao>(
          tooltip: 'Ações',
          icon: const Icon(Icons.more_vert),
          onSelected: (acao) {
            switch (acao) {
              case _ModeloMatematicoAcao.editar:
                aoEditar();
              case _ModeloMatematicoAcao.excluir:
                aoExcluir();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: _ModeloMatematicoAcao.editar,
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 10),
                  Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: _ModeloMatematicoAcao.excluir,
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
        children: [
          if (resumo.modeloMatematico.descricao != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                resumo.modeloMatematico.descricao!,
                style: const TextStyle(
                  color: CoresDendro.textoDiscreto,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          _VariaveisModelo(variaveis: resumo.variaveis),
          const SizedBox(height: 12),
          _ModeloMatematicoCoeficienteSimbolos(
            coeficientes: resumo.coeficientes,
          ),
        ],
      ),
    );
  }
}

class _VariaveisModelo extends StatelessWidget {
  const _VariaveisModelo({required this.variaveis});

  final List<VariavelModelo> variaveis;

  @override
  Widget build(BuildContext context) {
    if (variaveis.isEmpty) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: _DiscretoTexto('Nenhuma variável definida para este modelo.'),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final variavel in variaveis)
            IndicadorSituacao(
              rotulo:
                  '${variavel.simbolo} - ${variavel.rotulo} (${variavel.unidade})',
              cor: const Color(0xFFF3F4F3),
              textoCor: CoresDendro.texto,
            ),
        ],
      ),
    );
  }
}

class _ModeloMatematicoCoeficienteSimbolos extends StatelessWidget {
  const _ModeloMatematicoCoeficienteSimbolos({required this.coeficientes});

  final List<CoeficienteModelo> coeficientes;

  @override
  Widget build(BuildContext context) {
    if (coeficientes.isEmpty) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: _DiscretoTexto('Nenhum coeficiente definido para este modelo.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Símbolos dos coeficientes',
          style: TextStyle(
            color: CoresDendro.textoDiscreto,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final coeficiente in coeficientes)
              IndicadorSituacao(
                rotulo: '${coeficiente.simbolo} - ${coeficiente.rotulo}',
                cor: const Color(0xFFF3F4F3),
                textoCor: CoresDendro.texto,
              ),
          ],
        ),
        const SizedBox(height: 8),
        const _DiscretoTexto(
          'Os valores de cada coeficiente são definidos no cadastro da espécie.',
        ),
      ],
    );
  }
}

class _EspecieFormularioPainel extends ConsumerStatefulWidget {
  const _EspecieFormularioPainel({this.especie});

  final Especie? especie;

  @override
  ConsumerState<_EspecieFormularioPainel> createState() =>
      _EspecieFormularioPainelEstado();
}

class _EspecieFormularioPainelEstado
    extends ConsumerState<_EspecieFormularioPainel> {
  final _chaveFormulario = GlobalKey<FormState>();
  late final TextEditingController _nomeControlador;
  late final TextEditingController _cientificoNomeControlador;
  late final TextEditingController _descricaoControlador;
  late bool _ativo;
  bool _salvando = false;

  bool get _estaEditando => widget.especie != null;

  @override
  void initState() {
    super.initState();
    final especie = widget.especie;
    _nomeControlador = TextEditingController(text: especie?.nome ?? '');
    _cientificoNomeControlador = TextEditingController(
      text: especie?.nomeCientifico ?? '',
    );
    _descricaoControlador = TextEditingController(
      text: especie?.descricao ?? '',
    );
    _ativo = especie?.ativo ?? true;
  }

  @override
  void dispose() {
    _nomeControlador.dispose();
    _cientificoNomeControlador.dispose();
    _descricaoControlador.dispose();
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
              _PainelCabecalho(
                titulo: _estaEditando ? 'Editar espécie' : 'Nova espécie',
                salvando: _salvando,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _nomeControlador,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome da espécie',
                  prefixIcon: Icon(Icons.eco_outlined),
                ),
                validator: _validarCampoObrigatorio,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cientificoNomeControlador,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome científico (opcional)',
                  prefixIcon: Icon(Icons.local_florist_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoControlador,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Observação (opcional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                value: _ativo,
                onChanged: _salvando
                    ? null
                    : (valor) => setState(() => _ativo = valor),
                title: const Text('Espécie ativa'),
                contentPadding: EdgeInsets.zero,
                activeThumbColor: CoresDendro.principal,
              ),
              const SizedBox(height: 12),
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

    final repositorio = ref.read(provedorRepositorioAjustes);

    try {
      if (_estaEditando) {
        await repositorio.atualizarEspecie(
          id: widget.especie!.id,
          nome: _nomeControlador.text,
          nomeCientifico: _cientificoNomeControlador.text,
          descricao: _descricaoControlador.text,
          ativo: _ativo,
        );
      } else {
        await repositorio.criarEspecie(
          nome: _nomeControlador.text,
          nomeCientifico: _cientificoNomeControlador.text,
          descricao: _descricaoControlador.text,
          ativo: _ativo,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      _mostrarAviso(
        context,
        _estaEditando ? 'Espécie atualizada.' : 'Espécie cadastrada.',
      );
    } catch (_) {
      if (!mounted) return;
      _mostrarAviso(
        context,
        'Não foi possível salvar a espécie. Verifique se o nome já existe.',
        estaErro: true,
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }
}

class _ModeloMatematicoFormularioPainel extends ConsumerStatefulWidget {
  const _ModeloMatematicoFormularioPainel({this.resumo});

  final ModeloMatematicoResumo? resumo;

  @override
  ConsumerState<_ModeloMatematicoFormularioPainel> createState() =>
      _ModeloMatematicoFormularioPainelEstado();
}

class _ModeloMatematicoFormularioPainelEstado
    extends ConsumerState<_ModeloMatematicoFormularioPainel> {
  final _chaveFormulario = GlobalKey<FormState>();
  late final TextEditingController _nomeControlador;
  late final TextEditingController _descricaoControlador;
  late final TextEditingController _expressaoControlador;
  late final TextEditingController _coeficienteSimbolosControlador;
  late final Set<ChaveVariavelModelo> _selecionadoVariaveis;
  late bool _ativo;
  bool _salvando = false;

  bool get _estaEditando => widget.resumo != null;

  @override
  void initState() {
    super.initState();
    final resumo = widget.resumo;
    _nomeControlador = TextEditingController(
      text: resumo?.modeloMatematico.nome ?? '',
    );
    _descricaoControlador = TextEditingController(
      text: resumo?.modeloMatematico.descricao ?? '',
    );
    _expressaoControlador = TextEditingController(
      text: resumo?.modeloMatematico.expressao ?? '',
    );
    _coeficienteSimbolosControlador = TextEditingController(
      text:
          resumo?.coeficientes.map((item) => item.simbolo).join(', ') ?? 'a, b',
    );
    _selecionadoVariaveis = resumo == null
        ? {ChaveVariavelModelo.dap, ChaveVariavelModelo.altura}
        : resumo.variaveis.map((item) => item.chaveVariavel).toSet();
    _ativo = resumo?.modeloMatematico.ativo ?? true;
  }

  @override
  void dispose() {
    _nomeControlador.dispose();
    _descricaoControlador.dispose();
    _expressaoControlador.dispose();
    _coeficienteSimbolosControlador.dispose();
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
              _PainelCabecalho(
                titulo: _estaEditando ? 'Editar fórmula' : 'Nova fórmula',
                salvando: _salvando,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _nomeControlador,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome do modelo',
                  prefixIcon: Icon(Icons.functions),
                ),
                validator: _validarCampoObrigatorio,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _expressaoControlador,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Fórmula',
                  hintText: 'Ex.: a + b * (D^2 * H)',
                  prefixIcon: Icon(Icons.calculate_outlined),
                ),
                validator: _validarCampoObrigatorio,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _coeficienteSimbolosControlador,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Símbolos dos coeficientes',
                  hintText: 'Ex.: a, b, c, ff',
                  helperText:
                      'Os valores são configurados no cadastro da espécie.',
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (valor) {
                  if (_interpretarSimbolos(valor ?? '').isEmpty) {
                    return 'Informe ao menos um coeficiente';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoControlador,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Variáveis usadas',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              CheckboxListTile(
                value: _interpretarSimbolos(
                  _coeficienteSimbolosControlador.text,
                ).contains('ff'),
                onChanged: _salvando
                    ? null
                    : (valor) {
                        final simbolos = _interpretarSimbolos(
                          _coeficienteSimbolosControlador.text,
                        ).toSet();
                        if (valor ?? false) {
                          simbolos.add('ff');
                        } else {
                          simbolos.remove('ff');
                        }
                        setState(() {
                          _coeficienteSimbolosControlador.text = simbolos.join(
                            ', ',
                          );
                        });
                      },
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: CoresDendro.principal,
                title: const Text('Fator de forma (ff)'),
                subtitle: const Text(
                  'Valor informado na espécie ou na coleta.',
                ),
              ),
              for (final definicao in _variavelDefinicoes)
                CheckboxListTile(
                  value: _selecionadoVariaveis.contains(definicao.key),
                  onChanged: _salvando
                      ? null
                      : (valor) {
                          setState(() {
                            if (valor ?? false) {
                              _selecionadoVariaveis.add(definicao.key);
                            } else {
                              _selecionadoVariaveis.remove(definicao.key);
                            }
                          });
                        },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: CoresDendro.principal,
                  title: Text(definicao.rotulo),
                  subtitle: Text('${definicao.simbolo} - ${definicao.unidade}'),
                ),
              SwitchListTile(
                value: _ativo,
                onChanged: _salvando
                    ? null
                    : (valor) => setState(() => _ativo = valor),
                title: const Text('Fórmula ativa'),
                contentPadding: EdgeInsets.zero,
                activeThumbColor: CoresDendro.principal,
              ),
              const SizedBox(height: 12),
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

    if (_selecionadoVariaveis.isEmpty) {
      _mostrarAviso(
        context,
        'Selecione ao menos uma variável para a fórmula.',
        estaErro: true,
      );
      return;
    }

    setState(() => _salvando = true);

    final repositorio = ref.read(provedorRepositorioAjustes);
    final variaveis = _variavelDefinicoes
        .where((item) => _selecionadoVariaveis.contains(item.key))
        .map((item) => item.paraRascunho())
        .toList();
    final coeficientes = _interpretarSimbolos(
      _coeficienteSimbolosControlador.text,
    );

    try {
      if (_estaEditando) {
        await repositorio.atualizarModeloMatematico(
          id: widget.resumo!.modeloMatematico.id,
          nome: _nomeControlador.text,
          descricao: _descricaoControlador.text,
          expressao: _expressaoControlador.text,
          variaveis: variaveis,
          coeficienteSimbolos: coeficientes,
          ativo: _ativo,
        );
      } else {
        await repositorio.criarModeloMatematico(
          nome: _nomeControlador.text,
          descricao: _descricaoControlador.text,
          expressao: _expressaoControlador.text,
          variaveis: variaveis,
          coeficienteSimbolos: coeficientes,
          ativo: _ativo,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      _mostrarAviso(
        context,
        _estaEditando ? 'Fórmula atualizada.' : 'Fórmula cadastrada.',
      );
    } catch (_) {
      if (!mounted) return;
      _mostrarAviso(
        context,
        'Não foi possível salvar a fórmula. Verifique se o nome já existe.',
        estaErro: true,
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }
}

class _PainelCabecalho extends StatelessWidget {
  const _PainelCabecalho({required this.titulo, required this.salvando});

  final String titulo;
  final bool salvando;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
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

class _VazioCatalogoCartao extends StatelessWidget {
  const _VazioCatalogoCartao({
    required this.icone,
    required this.titulo,
    required this.mensagem,
    required this.botaoRotulo,
    required this.aoPressionado,
  });

  final IconData icone;
  final String titulo;
  final String mensagem;
  final String botaoRotulo;
  final VoidCallback aoPressionado;

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
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: aoPressionado,
              icon: const Icon(Icons.add),
              label: Text(botaoRotulo),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarregandoCartao extends StatelessWidget {
  const _CarregandoCartao();

  @override
  Widget build(BuildContext context) {
    return const CartaoDendro(
      filho: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _AjustesErroCartao extends StatelessWidget {
  const _AjustesErroCartao({
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

class _DiscretoTexto extends StatelessWidget {
  const _DiscretoTexto(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        color: CoresDendro.textoDiscreto,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _VariavelDefinicao {
  const _VariavelDefinicao({
    required this.key,
    required this.simbolo,
    required this.rotulo,
    required this.unidade,
    required this.origemValor,
  });

  final ChaveVariavelModelo key;
  final String simbolo;
  final String rotulo;
  final String unidade;
  final String origemValor;

  RascunhoVariavelModelo paraRascunho() {
    return RascunhoVariavelModelo(
      simbolo: simbolo,
      rotulo: rotulo,
      unidade: unidade,
      origemValor: origemValor,
      chaveVariavel: key,
    );
  }
}

const _variavelDefinicoes = [
  _VariavelDefinicao(
    key: ChaveVariavelModelo.dap,
    simbolo: 'D',
    rotulo: 'DAP',
    unidade: 'cm',
    origemValor: 'Medição da árvore',
  ),
  _VariavelDefinicao(
    key: ChaveVariavelModelo.altura,
    simbolo: 'H',
    rotulo: 'Altura',
    unidade: 'm',
    origemValor: 'Medição da árvore',
  ),
  _VariavelDefinicao(
    key: ChaveVariavelModelo.idade,
    simbolo: 'I',
    rotulo: 'Idade',
    unidade: 'anos',
    origemValor: 'Talhão',
  ),
  _VariavelDefinicao(
    key: ChaveVariavelModelo.areaBasal,
    simbolo: 'G',
    rotulo: 'Área basal',
    unidade: 'm2/ha',
    origemValor: 'Cálculo',
  ),
];

enum _EspecieAcao { editar, excluir }

enum _ModeloMatematicoAcao { editar, excluir }

EspecieModelo? _vinculoParaModeloMatematico(
  List<EspecieModelo> vinculos,
  int modeloMatematicoId,
) {
  for (final vinculo in vinculos) {
    if (vinculo.modeloMatematicoId == modeloMatematicoId) return vinculo;
  }
  return null;
}

String _especieSubtitulo(Especie especie) {
  final nomeCientifico = especie.nomeCientifico;
  final descricao = especie.descricao;

  if (nomeCientifico != null && descricao != null) {
    return '$nomeCientifico - $descricao';
  }
  if (nomeCientifico != null) return nomeCientifico;
  if (descricao != null) return descricao;
  return 'Sem observação cadastrada';
}

String? _validarCampoObrigatorio(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Campo obrigatório';
  }
  return null;
}

List<String> _interpretarSimbolos(String valor) {
  final simbolos = <String>[];

  for (final item in valor.split(',')) {
    final simbolo = item.trim();
    if (simbolo.isEmpty || simbolos.contains(simbolo)) continue;
    simbolos.add(simbolo);
  }

  return simbolos;
}

Object? _interpretarOpcionalReal(String valor) {
  final aparado = valor.trim();
  if (aparado.isEmpty) return null;
  return double.tryParse(aparado.replaceAll(',', '.')) ?? _invalidoReal;
}

const _invalidoReal = Object();

String _formatoNumero(double valor) => valor.toString().replaceAll('.', ',');

void _mostrarAviso(
  BuildContext context,
  String mensagem, {
  bool estaErro = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensagem),
      backgroundColor: estaErro ? Colors.red.shade700 : null,
    ),
  );
}
