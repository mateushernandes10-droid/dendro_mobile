import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../aplicativo/tema/tema_dendro.dart';
import '../../../nucleo/banco/banco_dendro.dart';
import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../../levantamentos/dados/repositorio_levantamentos.dart';
import '../../parcelas/dados/repositorio_parcelas.dart';
import '../dados/repositorio_arvores.dart';

class TelaColetaArvores extends ConsumerStatefulWidget {
  const TelaColetaArvores({required this.parcelaId, super.key});

  final int parcelaId;

  @override
  ConsumerState<TelaColetaArvores> createState() => _ColetaArvoresTelaEstado();
}

class _ColetaArvoresTelaEstado extends ConsumerState<TelaColetaArvores> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _dapControlador = TextEditingController();
  final _alturaControlador = TextEditingController();
  final _dapFocoNode = FocusNode();
  final _alturaFocoNode = FocusNode();

  bool _formularioAbrir = false;
  bool _salvando = false;
  bool _capturandoLocalizacao = false;
  bool _possuiTroncoTortuoso = false;
  int _arvoreNumero = 1;
  Arvore? _editandoArvore;
  PosicaoReferenciaParcela? _posicaoReferencia;
  double? _latitude;
  double? _longitude;
  double? _precisaoMetros;
  DateTime? _localizacaoCapturadaEm;

  @override
  void dispose() {
    _dapFocoNode.dispose();
    _alturaFocoNode.dispose();
    _dapControlador.dispose();
    _alturaControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coleta = ref.watch(provedorColetaArvores(widget.parcelaId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coleta da parcela'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: MarcaDendro(tamanho: 32)),
          ),
        ],
      ),
      body: SafeArea(
        child: coleta.when(
          data: (estado) => _corpo(estado),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (erro, pilhaTrace) => _ErroCarregamento(
            aoTentarNovamente: () =>
                ref.invalidate(provedorColetaArvores(widget.parcelaId)),
          ),
        ),
      ),
    );
  }

  Widget _corpo(EstadoColetaArvores estado) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _CabecalhoParcela(
          estado: estado,
          aoFinalizar: _salvando ? null : () => _finalizarParcela(estado),
        ),
        const SizedBox(height: 14),
        if (!_formularioAbrir)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _salvando
                  ? null
                  : () => _abrirNovoArvoreFormulario(estado),
              icon: const Icon(Icons.add),
              label: const Text('Nova árvore'),
            ),
          )
        else
          _ArvoreFormularioCartao(
            formularioChave: _chaveFormulario,
            arvoreNumero: _arvoreNumero,
            estaEditando: _editandoArvore != null,
            dapControlador: _dapControlador,
            alturaControlador: _alturaControlador,
            dapFocoNode: _dapFocoNode,
            alturaFocoNode: _alturaFocoNode,
            possuiTroncoTortuoso: _possuiTroncoTortuoso,
            latitude: _latitude,
            longitude: _longitude,
            precisaoMetros: _precisaoMetros,
            posicaoReferencia: _posicaoReferencia,
            salvando: _salvando,
            capturandoLocalizacao: _capturandoLocalizacao,
            aoFechar: _salvando ? null : _fecharFormulario,
            aoTortuosoAlterado: (valor) =>
                setState(() => _possuiTroncoTortuoso = valor),
            aoCapturarLocalizacao: () => _capturarLocalizacao(estado),
            aoLimparLocalizacao: _limparLocalizacao,
            aoDapEnviado: _focoAlturaCampo,
            aoSalvar: () => _salvarArvore(estado, manterAbrir: false),
            aoProximo: () => _salvarArvore(estado, manterAbrir: true),
          ),
        const SizedBox(height: 20),
        TituloSecao(
          titulo: 'Árvores registradas',
          complemento: IndicadorSituacao(
            rotulo: '${estado.arvoreQuantidade} total',
          ),
        ),
        if (estado.arvores.isEmpty)
          const _VazioArvoresCartao()
        else
          for (final arvore in estado.arvores.reversed)
            _ArvoreItem(
              arvore: arvore,
              aoEditar: () => _abrirEditarArvoreFormulario(arvore),
              aoExcluir: () => _confirmarExcluirArvore(arvore, estado),
            ),
      ],
    );
  }

  void _abrirNovoArvoreFormulario(EstadoColetaArvores estado) {
    setState(() {
      _editandoArvore = null;
      _arvoreNumero = estado.proximoNumeroArvore;
      _dapControlador.clear();
      _alturaControlador.clear();
      _possuiTroncoTortuoso = false;
      _posicaoReferencia = null;
      _latitude = null;
      _longitude = null;
      _precisaoMetros = null;
      _localizacaoCapturadaEm = null;
      _formularioAbrir = true;
    });
    _focoDapCampo();
  }

  void _abrirEditarArvoreFormulario(Arvore arvore) {
    setState(() {
      _editandoArvore = arvore;
      _arvoreNumero = arvore.numero;
      _dapControlador.text = _formatoMedicao(arvore.dapCm);
      _alturaControlador.text = _formatoMedicao(arvore.alturaM);
      _possuiTroncoTortuoso = arvore.possuiTroncoTortuoso;
      _posicaoReferencia = arvore.posicaoReferenciaParcela;
      _latitude = arvore.latitude;
      _longitude = arvore.longitude;
      _precisaoMetros = arvore.precisaoMetros;
      _localizacaoCapturadaEm = arvore.localizacaoCapturadaEm;
      _formularioAbrir = true;
    });
    _focoDapCampo();
  }

  void _fecharFormulario() {
    setState(() {
      _formularioAbrir = false;
      _editandoArvore = null;
    });
    _dapFocoNode.unfocus();
    _alturaFocoNode.unfocus();
  }

  void _focoDapCampo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_formularioAbrir) return;
      _dapFocoNode.requestFocus();
    });
  }

  void _focoAlturaCampo() {
    _alturaFocoNode.requestFocus();
  }

  void _limparLocalizacao() {
    setState(() {
      _latitude = null;
      _longitude = null;
      _precisaoMetros = null;
      _localizacaoCapturadaEm = null;
      _posicaoReferencia = null;
    });
  }

  Future<void> _capturarLocalizacao(EstadoColetaArvores estado) async {
    final referencia = await _selecionarReferenciaPosicao(estado);
    if (referencia == null || !mounted) return;

    final existenteArvore = _arvoreUsandoReferencia(estado, referencia);
    if (existenteArvore != null) {
      final deveSubstituir = await _confirmarReferenciaSubstituicao(
        referencia: referencia,
        existenteArvore: existenteArvore,
      );
      if (!deveSubstituir || !mounted) return;
    }

    setState(() => _capturandoLocalizacao = true);

    try {
      final servicoHabilitado = await Geolocator.isLocationServiceEnabled();
      if (!servicoHabilitado) {
        _mostrarAviso('Ative a localização do aparelho para capturar o ponto.');
        return;
      }

      var permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }

      if (permissao == LocationPermission.denied) {
        _mostrarAviso('Permissão de localização negada.');
        return;
      }

      if (permissao == LocationPermission.deniedForever) {
        _mostrarAviso('Libere a localização nas configurações do dispositivo.');
        return;
      }

      final posicao = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );

      setState(() {
        _latitude = posicao.latitude;
        _longitude = posicao.longitude;
        _precisaoMetros = posicao.accuracy;
        _localizacaoCapturadaEm = DateTime.now();
        _posicaoReferencia = referencia;
      });
    } catch (_) {
      _mostrarAviso('Não foi possível capturar a localização agora.');
    } finally {
      if (mounted) setState(() => _capturandoLocalizacao = false);
    }
  }

  Arvore? _arvoreUsandoReferencia(
    EstadoColetaArvores estado,
    PosicaoReferenciaParcela referencia,
  ) {
    final editandoArvoreId = _editandoArvore?.id;
    for (final arvore in estado.arvores) {
      if (arvore.id != editandoArvoreId &&
          arvore.posicaoReferenciaParcela == referencia) {
        return arvore;
      }
    }

    return null;
  }

  Future<bool> _confirmarReferenciaSubstituicao({
    required PosicaoReferenciaParcela referencia,
    required Arvore existenteArvore,
  }) async {
    final rotulo = _referenciaRotulo(referencia);
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
        title: Text('Ponto $rotulo já capturado'),
        content: Text(
          'O ponto $rotulo já está vinculado à árvore ${existenteArvore.numero}. '
          'Deseja substituir pela coordenada atual?',
        ),
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
            child: const Text('Substituir'),
          ),
        ],
      ),
    );

    return confirmado == true;
  }

  Future<void> _salvarArvore(
    EstadoColetaArvores estado, {
    required bool manterAbrir,
  }) async {
    if (!_chaveFormulario.currentState!.validate()) return;

    setState(() => _salvando = true);
    final repositorio = ref.read(provedorRepositorioArvores);
    final rascunho = RascunhoArvore(
      dapCm: _interpretarMedicao(_dapControlador.text)!,
      alturaM: _interpretarMedicao(_alturaControlador.text)!,
      possuiTroncoTortuoso: _possuiTroncoTortuoso,
      latitude: _latitude,
      longitude: _longitude,
      precisaoMetros: _precisaoMetros,
      localizacaoCapturadaEm: _localizacaoCapturadaEm,
      posicaoReferenciaParcela: _latitude == null || _longitude == null
          ? null
          : _posicaoReferencia,
    );

    try {
      final editandoArvore = _editandoArvore;
      if (editandoArvore == null) {
        await repositorio.criarArvore(
          parcelaId: widget.parcelaId,
          rascunho: rascunho,
        );
      } else {
        await repositorio.atualizarArvore(
          arvoreId: editandoArvore.id,
          rascunho: rascunho,
        );
      }

      _invalidarRelacionadosProvedores(estado);

      if (!mounted) return;
      if (manterAbrir) {
        final proximoNumero = await repositorio.proximoNumeroArvore(
          widget.parcelaId,
        );
        setState(() {
          _editandoArvore = null;
          _arvoreNumero = proximoNumero;
          _dapControlador.clear();
          _alturaControlador.clear();
          _possuiTroncoTortuoso = false;
          _posicaoReferencia = null;
          _latitude = null;
          _longitude = null;
          _precisaoMetros = null;
          _localizacaoCapturadaEm = null;
        });
        _focoDapCampo();
      } else {
        _fecharFormulario();
      }
    } catch (_) {
      if (!mounted) return;
      _mostrarAviso('Não foi possível salvar a árvore.');
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _confirmarExcluirArvore(
    Arvore arvore,
    EstadoColetaArvores estado,
  ) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir árvore ${arvore.numero}?'),
        content: const Text('Essa ação apaga as medidas salvas da árvore.'),
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

    if (confirmado != true) return;

    await ref.read(provedorRepositorioArvores).excluirArvore(arvore.id);
    _invalidarRelacionadosProvedores(estado);

    if (!mounted) return;
    _mostrarAviso('Árvore ${arvore.numero} excluída.');
  }

  Future<void> _finalizarParcela(EstadoColetaArvores estado) async {
    final mensagem = estado.arvores.isEmpty
        ? 'A parcela não possui árvores registradas. Deseja encerrar mesmo assim?'
        : 'Encerrar a parcela ${estado.parcela.identificacao} como coletada?';

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Encerrar parcela'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Encerrar'),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    await ref
        .read(provedorRepositorioArvores)
        .marcarParcelaColetada(widget.parcelaId);
    _invalidarRelacionadosProvedores(estado);

    if (!mounted) return;
    _mostrarAviso('Parcela ${estado.parcela.identificacao} encerrada.');
    Navigator.of(context).pop();
  }

  void _invalidarRelacionadosProvedores(EstadoColetaArvores estado) {
    ref.invalidate(provedorColetaArvores(widget.parcelaId));
    ref.invalidate(
      provedorParcelasTalhaoLevantamento(estado.talhaoLevantamento.id),
    );
    ref.invalidate(provedorParcelasTalhao(estado.talhao.id));
    ref.invalidate(provedorLevantamentosAtivos);
    ref.invalidate(provedorLevantamentoAtivo);
    ref.invalidate(provedorLevantamentoDetalhe(estado.levantamento.id));
  }

  void _mostrarAviso(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<PosicaoReferenciaParcela?> _selecionarReferenciaPosicao(
    EstadoColetaArvores estado,
  ) {
    return showModalBottomSheet<PosicaoReferenciaParcela>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _ReferenciaSeletorPainel(
        inicialPosicao: _posicaoReferencia,
        capturadoPosicoes: estado.capturadoReferenciaPosicoes,
      ),
    );
  }
}

class _CabecalhoParcela extends StatelessWidget {
  const _CabecalhoParcela({required this.estado, required this.aoFinalizar});

  final EstadoColetaArvores estado;
  final VoidCallback? aoFinalizar;

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
                  estado.parcela.identificacao,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CoresDendro.principal,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IndicadorSituacao(
                rotulo: _parcelaSituacaoRotulo(estado.parcela.situacao),
              ),
              const SizedBox(width: 6),
              IconButton.filledTonal(
                onPressed: aoFinalizar,
                icon: const Icon(Icons.check_circle_outline),
                tooltip: 'Encerrar parcela',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '${estado.talhao.identificacao} • ${estado.especie.nome}',
            style: const TextStyle(
              color: CoresDendro.textoDiscreto,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _CabecalhoIndicador(
                  icone: Icons.forest,
                  rotulo: 'Árvores',
                  valor: estado.arvoreQuantidade.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CabecalhoIndicador(
                  icone: Icons.add_location_alt,
                  rotulo: 'Pontos GPS',
                  valor: estado.pontosReferencia.length.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CabecalhoIndicador extends StatelessWidget {
  const _CabecalhoIndicador({
    required this.icone,
    required this.rotulo,
    required this.valor,
  });

  final IconData icone;
  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final fundoCor = Theme.of(context).brightness == Brightness.dark
        ? CoresDendro.escuroLegivelCampo
        : Colors.white.withValues(alpha: 0.78);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: fundoCor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icone, size: 18, color: CoresDendro.principal),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rotulo,
                  style: const TextStyle(
                    color: CoresDendro.textoDiscreto,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  valor,
                  style: const TextStyle(
                    color: CoresDendro.principal,
                    fontSize: 18,
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

class _ArvoreFormularioCartao extends StatelessWidget {
  const _ArvoreFormularioCartao({
    required this.formularioChave,
    required this.arvoreNumero,
    required this.estaEditando,
    required this.dapControlador,
    required this.alturaControlador,
    required this.dapFocoNode,
    required this.alturaFocoNode,
    required this.possuiTroncoTortuoso,
    required this.latitude,
    required this.longitude,
    required this.precisaoMetros,
    required this.posicaoReferencia,
    required this.salvando,
    required this.capturandoLocalizacao,
    required this.aoFechar,
    required this.aoTortuosoAlterado,
    required this.aoCapturarLocalizacao,
    required this.aoLimparLocalizacao,
    required this.aoDapEnviado,
    required this.aoSalvar,
    required this.aoProximo,
  });

  final GlobalKey<FormState> formularioChave;
  final int arvoreNumero;
  final bool estaEditando;
  final TextEditingController dapControlador;
  final TextEditingController alturaControlador;
  final FocusNode dapFocoNode;
  final FocusNode alturaFocoNode;
  final bool possuiTroncoTortuoso;
  final double? latitude;
  final double? longitude;
  final double? precisaoMetros;
  final PosicaoReferenciaParcela? posicaoReferencia;
  final bool salvando;
  final bool capturandoLocalizacao;
  final VoidCallback? aoFechar;
  final ValueChanged<bool> aoTortuosoAlterado;
  final VoidCallback aoCapturarLocalizacao;
  final VoidCallback aoLimparLocalizacao;
  final VoidCallback aoDapEnviado;
  final VoidCallback aoSalvar;
  final VoidCallback aoProximo;

  bool get possuiLocalizacao => latitude != null && longitude != null;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      fundoCor: const Color(0xFFF8FAF8),
      filho: Form(
        key: formularioChave,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Árvore $arvoreNumero',
                    style: const TextStyle(
                      color: CoresDendro.principal,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: capturandoLocalizacao
                      ? null
                      : aoCapturarLocalizacao,
                  tooltip: 'Capturar coordenada',
                  style: IconButton.styleFrom(
                    backgroundColor: CoresDendro.principalSuave,
                    foregroundColor: CoresDendro.principal,
                    disabledBackgroundColor: CoresDendro.escuroLegivelCampo,
                    disabledForegroundColor: CoresDendro.textoDiscreto,
                  ),
                  icon: capturandoLocalizacao
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                ),
                IconButton(
                  onPressed: aoFechar,
                  tooltip: 'Recolher',
                  icon: const Icon(Icons.keyboard_arrow_up),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _MedicaoCampo(
              controlador: dapControlador,
              focoNode: dapFocoNode,
              rotulo: 'DAP (cm)',
              auxiliar: 'Diâmetro a 1,30 m',
              textoEntradaAcao: TextInputAction.next,
              aoCampoEnviado: (_) => aoDapEnviado(),
              validador: (valor) => _medicaoValidator(valor, 'DAP'),
            ),
            const SizedBox(height: 12),
            _MedicaoCampo(
              controlador: alturaControlador,
              focoNode: alturaFocoNode,
              rotulo: 'Altura (m)',
              auxiliar: 'Medida ou estimada',
              textoEntradaAcao: TextInputAction.done,
              validador: (valor) => _medicaoValidator(valor, 'altura'),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: possuiTroncoTortuoso,
              onChanged: salvando ? null : aoTortuosoAlterado,
              title: const Text(
                'Tronco torto?',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 4),
            if (possuiLocalizacao)
              _CartaoLocalizacaoCapturada(
                latitude: latitude!,
                longitude: longitude!,
                precisaoMetros: precisaoMetros,
                posicaoReferencia: posicaoReferencia,
                aoLimpar: salvando ? null : aoLimparLocalizacao,
              )
            else
              const Text(
                'A coordenada é opcional. Use o botão de localização quando esta árvore representar uma quina da parcela.',
                style: TextStyle(
                  color: CoresDendro.textoDiscreto,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: salvando ? null : aoSalvar,
                    icon: const Icon(Icons.save_outlined),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CoresDendro.principal,
                      disabledForegroundColor: CoresDendro.textoDiscreto,
                      side: BorderSide(
                        color: salvando
                            ? CoresDendro.contorno
                            : CoresDendro.principal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    label: const Text('Salvar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: salvando ? null : aoProximo,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Próxima'),
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

class _MedicaoCampo extends StatelessWidget {
  const _MedicaoCampo({
    required this.controlador,
    required this.focoNode,
    required this.rotulo,
    required this.auxiliar,
    required this.textoEntradaAcao,
    required this.validador,
    this.aoCampoEnviado,
  });

  final TextEditingController controlador;
  final FocusNode focoNode;
  final String rotulo;
  final String auxiliar;
  final TextInputAction textoEntradaAcao;
  final FormFieldValidator<String> validador;
  final ValueChanged<String>? aoCampoEnviado;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton.filledTonal(
          onPressed: () => _etapa(-0.1),
          style: IconButton.styleFrom(
            backgroundColor: CoresDendro.principalSuave,
            foregroundColor: CoresDendro.principal,
          ),
          icon: const Icon(Icons.remove),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: controlador,
            focusNode: focoNode,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CoresDendro.texto,
              fontWeight: FontWeight.w800,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: textoEntradaAcao,
            onFieldSubmitted: aoCampoEnviado,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
            ],
            decoration: InputDecoration(
              labelText: rotulo,
              helperText: auxiliar,
              labelStyle: const TextStyle(
                color: CoresDendro.textoDiscreto,
                fontWeight: FontWeight.w700,
              ),
              helperStyle: const TextStyle(
                color: CoresDendro.textoDiscreto,
                fontWeight: FontWeight.w700,
              ),
              fillColor: CoresDendro.escuroLegivelCampo,
            ),
            validator: validador,
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: () => _etapa(0.1),
          style: IconButton.styleFrom(
            backgroundColor: CoresDendro.principalSuave,
            foregroundColor: CoresDendro.principal,
          ),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  void _etapa(double delta) {
    final atual = _interpretarMedicao(controlador.text) ?? 0;
    final atualizado = (atual + delta).clamp(0, double.infinity);
    controlador.text = _formatoMedicao(atualizado.toDouble());
  }
}

class _ReferenciaSeletorPainel extends StatefulWidget {
  const _ReferenciaSeletorPainel({
    required this.inicialPosicao,
    required this.capturadoPosicoes,
  });

  final PosicaoReferenciaParcela? inicialPosicao;
  final Set<PosicaoReferenciaParcela> capturadoPosicoes;

  @override
  State<_ReferenciaSeletorPainel> createState() =>
      _ReferenciaSeletorPainelEstado();
}

class _ReferenciaSeletorPainelEstado extends State<_ReferenciaSeletorPainel> {
  late PosicaoReferenciaParcela _selecionado;

  @override
  void initState() {
    super.initState();
    _selecionado =
        widget.inicialPosicao ??
        _proximoReferenciaPosicao(widget.capturadoPosicoes);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Qual ponta da parcela?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Selecione o ponto de referência antes de capturar o GPS. Pontos em verde já possuem coordenada salva.',
            style: TextStyle(
              color: CoresDendro.textoDiscreto,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          _ReferenciaSeletor(
            selecionado: _selecionado,
            capturadoPosicoes: widget.capturadoPosicoes,
            aoAlterado: (valor) {
              if (valor == null) return;
              setState(() => _selecionado = valor);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(_selecionado),
                  icon: const Icon(Icons.my_location),
                  label: const Text('Capturar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReferenciaSeletor extends StatelessWidget {
  const _ReferenciaSeletor({
    required this.selecionado,
    required this.capturadoPosicoes,
    required this.aoAlterado,
  });

  final PosicaoReferenciaParcela? selecionado;
  final Set<PosicaoReferenciaParcela> capturadoPosicoes;
  final ValueChanged<PosicaoReferenciaParcela?>? aoAlterado;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final posicao in PosicaoReferenciaParcela.values)
          ChoiceChip(
            label: Text(_referenciaRotulo(posicao)),
            selected: selecionado == posicao,
            onSelected: aoAlterado == null
                ? null
                : (selecionado) => aoAlterado!(selecionado ? posicao : null),
            backgroundColor: capturadoPosicoes.contains(posicao)
                ? const Color(0xFFD7F0DF)
                : const Color(0xFFF0F2F0),
            selectedColor: CoresDendro.principal,
            labelStyle: TextStyle(
              color: selecionado == posicao
                  ? Colors.white
                  : capturadoPosicoes.contains(posicao)
                  ? CoresDendro.principal
                  : CoresDendro.textoDiscreto,
              fontWeight: FontWeight.w900,
            ),
          ),
      ],
    );
  }
}

class _CartaoLocalizacaoCapturada extends StatelessWidget {
  const _CartaoLocalizacaoCapturada({
    required this.latitude,
    required this.longitude,
    required this.precisaoMetros,
    required this.posicaoReferencia,
    required this.aoLimpar,
  });

  final double latitude;
  final double longitude;
  final double? precisaoMetros;
  final PosicaoReferenciaParcela? posicaoReferencia;
  final VoidCallback? aoLimpar;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      fundoCor: const Color(0xFFEAF7EF),
      bordaCor: const Color(0xFFA4D1B4),
      espacamentoInterno: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      filho: Row(
        children: [
          const Icon(Icons.add_location_alt, color: CoresDendro.principal),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${posicaoReferencia == null ? 'Ponto GPS' : _referenciaRotulo(posicaoReferencia!)} • '
              '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}'
              '${precisaoMetros == null ? '' : ' • ±${precisaoMetros!.toStringAsFixed(1)} m'}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
          IconButton(
            onPressed: aoLimpar,
            tooltip: 'Remover coordenada',
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class _ArvoreItem extends StatelessWidget {
  const _ArvoreItem({
    required this.arvore,
    required this.aoEditar,
    required this.aoExcluir,
  });

  final Arvore arvore;
  final VoidCallback aoEditar;
  final VoidCallback aoExcluir;

  @override
  Widget build(BuildContext context) {
    final referencia = arvore.posicaoReferenciaParcela;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CartaoDendro(
        espacamentoInterno: const EdgeInsets.fromLTRB(12, 10, 4, 10),
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Árvore ${arvore.numero}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      if (referencia != null)
                        IndicadorSituacao(
                          rotulo: _referenciaRotulo(referencia),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'DAP: ${_formatoMedicao(arvore.dapCm)} cm • Alt.: ${_formatoMedicao(arvore.alturaM)} m',
                    style: const TextStyle(
                      color: CoresDendro.textoDiscreto,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (arvore.latitude != null && arvore.longitude != null)
                    Text(
                      '${arvore.latitude!.toStringAsFixed(5)}, ${arvore.longitude!.toStringAsFixed(5)}',
                      style: const TextStyle(
                        color: CoresDendro.textoDiscreto,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
            PopupMenuButton<_ArvoreAcao>(
              tooltip: 'Ações',
              icon: const Icon(Icons.more_vert),
              onSelected: (acao) {
                switch (acao) {
                  case _ArvoreAcao.editar:
                    aoEditar();
                  case _ArvoreAcao.excluir:
                    aoExcluir();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _ArvoreAcao.editar,
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined),
                      SizedBox(width: 10),
                      Text('Editar'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: _ArvoreAcao.excluir,
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
    );
  }
}

class _VazioArvoresCartao extends StatelessWidget {
  const _VazioArvoresCartao();

  @override
  Widget build(BuildContext context) {
    return const CartaoDendro(
      fundoCor: Color(0xFFF3F4F3),
      filho: Column(
        children: [
          Icon(Icons.forest_outlined, size: 42, color: CoresDendro.secundario),
          SizedBox(height: 12),
          Text(
            'Nenhuma árvore registrada',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 6),
          Text(
            'Use “Nova árvore” para iniciar a coleta desta parcela.',
            textAlign: TextAlign.center,
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
                'Não foi possível carregar a coleta.',
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

enum _ArvoreAcao { editar, excluir }

String? _medicaoValidator(String? valor, String rotulo) {
  final interpretado = _interpretarMedicao(valor ?? '');
  if (interpretado == null) return 'Informe $rotulo';
  if (interpretado <= 0) return '$rotulo deve ser maior que zero';
  return null;
}

double? _interpretarMedicao(String valor) {
  final aparado = valor.trim();
  if (aparado.isEmpty) return null;
  return double.tryParse(aparado.replaceAll(',', '.'));
}

String _formatoMedicao(double valor) {
  return valor.toStringAsFixed(1).replaceAll('.', ',');
}

String _parcelaSituacaoRotulo(SituacaoParcela situacao) {
  switch (situacao) {
    case SituacaoParcela.pendente:
      return 'Pendente';
    case SituacaoParcela.emAndamento:
      return 'Em andamento';
    case SituacaoParcela.coletada:
      return 'Coletada';
  }
}

String _referenciaRotulo(PosicaoReferenciaParcela posicao) {
  switch (posicao) {
    case PosicaoReferenciaParcela.p1:
      return 'P1';
    case PosicaoReferenciaParcela.p2:
      return 'P2';
    case PosicaoReferenciaParcela.p3:
      return 'P3';
    case PosicaoReferenciaParcela.p4:
      return 'P4';
  }
}

PosicaoReferenciaParcela _proximoReferenciaPosicao(
  Set<PosicaoReferenciaParcela> capturado,
) {
  for (final posicao in PosicaoReferenciaParcela.values) {
    if (!capturado.contains(posicao)) return posicao;
  }
  return PosicaoReferenciaParcela.p1;
}
