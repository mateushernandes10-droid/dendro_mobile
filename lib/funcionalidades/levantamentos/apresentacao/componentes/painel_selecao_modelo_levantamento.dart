import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../aplicativo/tema/tema_dendro.dart';
import '../../../../nucleo/banco/banco_dendro.dart';
import '../../../../nucleo/floresta/calculadora_volume_florestal.dart';
import '../../../../compartilhado/componentes/componentes_dendro.dart';
import '../../../ajustes/dados/repositorio_ajustes.dart';
import '../../dados/selecao_modelo_levantamento.dart';

Future<LevantamentoModeloMatematicoSelecao?>
mostrarLevantamentoModeloMatematicoSelecaoPainel({
  required BuildContext context,
  required int especieId,
  LevantamentoModeloMatematicoSelecao? inicialSelecao,
}) {
  return showModalBottomSheet<LevantamentoModeloMatematicoSelecao>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => _LevantamentoModeloMatematicoSelecaoPainel(
      especieId: especieId,
      inicialSelecao: inicialSelecao,
    ),
  );
}

class _LevantamentoModeloMatematicoSelecaoPainel
    extends ConsumerStatefulWidget {
  const _LevantamentoModeloMatematicoSelecaoPainel({
    required this.especieId,
    required this.inicialSelecao,
  });

  final int especieId;
  final LevantamentoModeloMatematicoSelecao? inicialSelecao;

  @override
  ConsumerState<_LevantamentoModeloMatematicoSelecaoPainel> createState() =>
      _LevantamentoModeloMatematicoSelecaoPainelEstado();
}

class _LevantamentoModeloMatematicoSelecaoPainelEstado
    extends ConsumerState<_LevantamentoModeloMatematicoSelecaoPainel> {
  final Map<String, TextEditingController> _controladores = {};
  int? _selecionadoModeloMatematicoId;
  int? _ultimoPreparadoModeloMatematicoId;

  @override
  void dispose() {
    for (final controlador in _controladores.values) {
      controlador.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelosMatematicosAsync = ref.watch(
      provedorAjustesModelosMatematicos,
    );
    final vinculosAsync = ref.watch(provedorAjustesEspecieModelosMatematicos);
    final especieCoeficientesAsync = ref.watch(
      provedorAjustesEspecieModeloMatematicoCoeficientes,
    );
    final inferiorRecuo = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: inferiorRecuo),
      child: modelosMatematicosAsync.when(
        data: (modelosMatematicos) {
          if (vinculosAsync.isLoading && !vinculosAsync.hasValue) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (especieCoeficientesAsync.isLoading &&
              !especieCoeficientesAsync.hasValue) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (vinculosAsync.hasError || especieCoeficientesAsync.hasError) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: _ModeloMatematicoSelecaoErro(
                aoTentarNovamente: () {
                  ref.invalidate(provedorAjustesEspecieModelosMatematicos);
                  ref.invalidate(
                    provedorAjustesEspecieModeloMatematicoCoeficientes,
                  );
                },
              ),
            );
          }

          final vinculos = vinculosAsync.value ?? const [];
          final especieCoeficientes =
              especieCoeficientesAsync.value ??
              const <CoeficienteEspecieModelo>[];
          final vinculadoModeloMatematicoIds = vinculos
              .where((vinculo) => vinculo.especieId == widget.especieId)
              .map((vinculo) => vinculo.modeloMatematicoId)
              .toSet();
          final disponivelModelosMatematicos = modelosMatematicos
              .where(
                (resumo) =>
                    resumo.modeloMatematico.ativo &&
                    vinculadoModeloMatematicoIds.contains(
                      resumo.modeloMatematico.id,
                    ),
              )
              .toList();
          _garantirSelecionadoModeloMatematico(
            disponivelModelosMatematicos,
            vinculos,
          );

          final selecionadoModeloMatematico = _selecionadoModeloMatematico(
            disponivelModelosMatematicos,
          );
          _prepararCoeficienteControllers(
            selecionadoModeloMatematico,
            especieCoeficientes,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Ajustar modelo matemático',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      tooltip: 'Fechar',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (disponivelModelosMatematicos.isEmpty)
                  const _ModeloMatematicoSelecaoVazio()
                else ...[
                  const Text(
                    'Modelo',
                    style: TextStyle(
                      color: CoresDendro.textoDiscreto,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final modeloMatematico in disponivelModelosMatematicos)
                    _ModeloMatematicoEscolhaBloco(
                      resumo: modeloMatematico,
                      selecionado:
                          modeloMatematico.modeloMatematico.id ==
                          _selecionadoModeloMatematicoId,
                      aoTocar: () {
                        setState(() {
                          _selecionadoModeloMatematicoId =
                              modeloMatematico.modeloMatematico.id;
                          _ultimoPreparadoModeloMatematicoId = null;
                        });
                      },
                    ),
                  const SizedBox(height: 12),
                  if (selecionadoModeloMatematico != null)
                    _CoeficienteCampos(
                      coeficientes: selecionadoModeloMatematico.coeficientes,
                      controladores: _controladores,
                    ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: selecionadoModeloMatematico == null
                          ? null
                          : () => _confirmar(selecionadoModeloMatematico),
                      icon: const Icon(Icons.check),
                      label: const Text('Usar este modelo'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (erro, pilhaTrace) => Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: _ModeloMatematicoSelecaoErro(
            aoTentarNovamente: () =>
                ref.invalidate(provedorAjustesModelosMatematicos),
          ),
        ),
      ),
    );
  }

  void _garantirSelecionadoModeloMatematico(
    List<ModeloMatematicoResumo> modelosMatematicos,
    List<EspecieModelo> vinculos,
  ) {
    if (modelosMatematicos.isEmpty) {
      _selecionadoModeloMatematicoId = null;
      return;
    }

    final inicialModeloMatematicoId = widget.inicialSelecao?.modeloMatematicoId;
    final selecionadoAindaExiste = modelosMatematicos.any(
      (resumo) => resumo.modeloMatematico.id == _selecionadoModeloMatematicoId,
    );
    if (_selecionadoModeloMatematicoId != null && selecionadoAindaExiste) {
      return;
    }

    if (inicialModeloMatematicoId != null &&
        modelosMatematicos.any(
          (resumo) => resumo.modeloMatematico.id == inicialModeloMatematicoId,
        )) {
      _selecionadoModeloMatematicoId = inicialModeloMatematicoId;
      return;
    }

    final padraoVinculo = vinculos
        .where(
          (vinculo) => vinculo.especieId == widget.especieId && vinculo.padrao,
        )
        .firstOrNull;
    if (padraoVinculo != null &&
        modelosMatematicos.any(
          (resumo) =>
              resumo.modeloMatematico.id == padraoVinculo.modeloMatematicoId,
        )) {
      _selecionadoModeloMatematicoId = padraoVinculo.modeloMatematicoId;
      return;
    }

    final primeiroVinculado = vinculos
        .where((vinculo) => vinculo.especieId == widget.especieId)
        .firstOrNull;
    if (primeiroVinculado != null &&
        modelosMatematicos.any(
          (resumo) =>
              resumo.modeloMatematico.id ==
              primeiroVinculado.modeloMatematicoId,
        )) {
      _selecionadoModeloMatematicoId = primeiroVinculado.modeloMatematicoId;
      return;
    }

    _selecionadoModeloMatematicoId =
        modelosMatematicos.first.modeloMatematico.id;
  }

  ModeloMatematicoResumo? _selecionadoModeloMatematico(
    List<ModeloMatematicoResumo> modelosMatematicos,
  ) {
    for (final modeloMatematico in modelosMatematicos) {
      if (modeloMatematico.modeloMatematico.id ==
          _selecionadoModeloMatematicoId) {
        return modeloMatematico;
      }
    }
    return null;
  }

  void _prepararCoeficienteControllers(
    ModeloMatematicoResumo? selecionadoModeloMatematico,
    List<CoeficienteEspecieModelo> especieCoeficientes,
  ) {
    if (selecionadoModeloMatematico == null) return;
    if (_ultimoPreparadoModeloMatematicoId ==
        selecionadoModeloMatematico.modeloMatematico.id) {
      return;
    }

    for (final controlador in _controladores.values) {
      controlador.dispose();
    }
    _controladores.clear();

    final inicialValores =
        selecionadoModeloMatematico.modeloMatematico.id ==
            widget.inicialSelecao?.modeloMatematicoId
        ? widget.inicialSelecao!.coeficienteValoresPorSimbolo
        : const <String, double?>{};
    final especieValores = {
      for (final coeficiente in especieCoeficientes)
        if (coeficiente.especieId == widget.especieId &&
            coeficiente.modeloMatematicoId ==
                selecionadoModeloMatematico.modeloMatematico.id)
          coeficiente.simbolo: coeficiente.valor,
    };

    for (final coeficiente in selecionadoModeloMatematico.coeficientes) {
      final valor = inicialValores.containsKey(coeficiente.simbolo)
          ? inicialValores[coeficiente.simbolo]
          : especieValores[coeficiente.simbolo] ??
                coeficiente.valor ??
                CalculadoraVolumeFlorestal.valorPadraoCoeficiente(
                  modeloMatematicoCodigo:
                      selecionadoModeloMatematico.modeloMatematico.codigo,
                  simbolo: coeficiente.simbolo,
                );

      _controladores[coeficiente.simbolo] = TextEditingController(
        text: valor == null ? '' : _formatoNumero(valor),
      );
    }

    _ultimoPreparadoModeloMatematicoId =
        selecionadoModeloMatematico.modeloMatematico.id;
  }

  void _confirmar(ModeloMatematicoResumo selecionadoModeloMatematico) {
    final values = <String, double?>{};

    for (final coeficiente in selecionadoModeloMatematico.coeficientes) {
      final interpretado = _interpretarOpcionalReal(
        _controladores[coeficiente.simbolo]?.text ?? '',
      );
      if (interpretado == _invalidoReal ||
          (coeficiente.simbolo.toLowerCase() == 'ff' &&
              (interpretado is! double ||
                  !interpretado.isFinite ||
                  interpretado <= 0))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade700,
            content: Text(
              'Informe um valor válido para ${coeficiente.rotulo}.',
            ),
          ),
        );
        return;
      }

      values[coeficiente.simbolo] = interpretado as double?;
    }

    Navigator.of(context).pop(
      LevantamentoModeloMatematicoSelecao(
        modeloMatematicoId: selecionadoModeloMatematico.modeloMatematico.id,
        modeloMatematicoNome: selecionadoModeloMatematico.modeloMatematico.nome,
        coeficienteValoresPorSimbolo: values,
      ),
    );
  }
}

class _ModeloMatematicoEscolhaBloco extends StatelessWidget {
  const _ModeloMatematicoEscolhaBloco({
    required this.resumo,
    required this.selecionado,
    required this.aoTocar,
  });

  final ModeloMatematicoResumo resumo;
  final bool selecionado;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: aoTocar,
        child: CartaoDendro(
          fundoCor: selecionado
              ? CoresDendro.principalSuave
              : const Color(0xFFF3F4F3),
          bordaCor: selecionado ? CoresDendro.principal : CoresDendro.contorno,
          espacamentoInterno: const EdgeInsets.fromLTRB(10, 10, 8, 10),
          filho: Row(
            children: [
              Icon(
                selecionado
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selecionado
                    ? CoresDendro.principal
                    : CoresDendro.textoDiscreto,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            resumo.modeloMatematico.nome,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SituacaoIndicador(
                          rotulo: 'Vinculado',
                          cor: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      resumo.modeloMatematico.expressao,
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
            ],
          ),
        ),
      ),
    );
  }
}

class _CoeficienteCampos extends StatelessWidget {
  const _CoeficienteCampos({
    required this.coeficientes,
    required this.controladores,
  });

  final List<CoeficienteModelo> coeficientes;
  final Map<String, TextEditingController> controladores;

  @override
  Widget build(BuildContext context) {
    if (coeficientes.isEmpty) {
      return const CartaoDendro(
        fundoCor: Color(0xFFF3F4F3),
        filho: Text(
          'Este modelo não possui coeficientes cadastrados.',
          style: TextStyle(
            color: CoresDendro.textoDiscreto,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Coeficientes para este levantamento',
          style: TextStyle(
            color: CoresDendro.textoDiscreto,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        for (final coeficiente in coeficientes)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              controller: controladores[coeficiente.simbolo],
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
      ],
    );
  }
}

class _ModeloMatematicoSelecaoVazio extends StatelessWidget {
  const _ModeloMatematicoSelecaoVazio();

  @override
  Widget build(BuildContext context) {
    return const CartaoDendro(
      fundoCor: Color(0xFFF3F4F3),
      filho: Text(
        'Nenhum modelo matemático vinculado à espécie selecionada.',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _ModeloMatematicoSelecaoErro extends StatelessWidget {
  const _ModeloMatematicoSelecaoErro({required this.aoTentarNovamente});

  final VoidCallback aoTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      filho: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(height: 10),
          const Text(
            'Não foi possível carregar os modelos matemáticos.',
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

Object? _interpretarOpcionalReal(String valor) {
  final aparado = valor.trim();
  if (aparado.isEmpty) return null;
  return double.tryParse(aparado.replaceAll(',', '.')) ?? _invalidoReal;
}

const _invalidoReal = Object();

String _formatoNumero(double valor) => valor.toString().replaceAll('.', ',');
