import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../aplicativo/tema/tema_dendro.dart';
import '../../../nucleo/banco/banco_dendro.dart';
import '../../../nucleo/plataforma/salvador_arquivo_android.dart';
import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../dados/repositorio_exportacao_dados.dart';

class TelaExportacaoDados extends ConsumerStatefulWidget {
  const TelaExportacaoDados({
    this.propriedadeId,
    this.levantamentoId,
    this.especieId,
    this.inicialTalhaoIds = const {},
    super.key,
  });

  final int? propriedadeId;
  final int? levantamentoId;
  final int? especieId;
  final Set<int> inicialTalhaoIds;

  @override
  ConsumerState<TelaExportacaoDados> createState() =>
      _ExportacaoDadosTelaEstado();
}

class _ExportacaoDadosTelaEstado extends ConsumerState<TelaExportacaoDados> {
  int? _propriedadeId;
  FormatoExportacaoDados _formato = FormatoExportacaoDados.pdf;
  Set<int>? _selecionadoTalhaoIds;
  String? _selecaoSincronizarChave;
  _ExportacaoAcao? _atualAcao;

  @override
  void initState() {
    super.initState();
    _propriedadeId = widget.propriedadeId;
  }

  @override
  Widget build(BuildContext context) {
    final solicitacao = SolicitacaoExportacaoDados(
      propriedadeId: _propriedadeId,
      levantamentoId: widget.levantamentoId,
      especieId: widget.especieId,
    );
    final dados = ref.watch(provedorExportacaoDados(solicitacao));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportar'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: MarcaDendro(tamanho: 32)),
          ),
        ],
      ),
      body: SafeArea(
        child: dados.when(
          data: (estado) {
            _sincronizarPropriedadeSelecao(estado);
            _sincronizarTalhaoSelecao(estado);

            final selecionadoTalhaoIds = _selecionadoTalhaoIds ?? const <int>{};
            final selecionadoTalhaoQuantidade = selecionadoTalhaoIds.length;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              children: [
                _ExportacaoIntroducaoCartao(
                  propriedade: estado.propriedade,
                  levantamento: estado.levantamento,
                ),
                const SizedBox(height: 14),
                if (widget.levantamentoId == null)
                  _PropriedadeSeletor(
                    propriedades: estado.propriedades,
                    selecionadoPropriedadeId: _propriedadeId,
                    aoAlterado: _alterarPropriedade,
                  ),
                if (widget.levantamentoId == null) const SizedBox(height: 14),
                const TituloSecao(titulo: 'Formato do arquivo'),
                for (final formato in FormatoExportacaoDados.values) ...[
                  _ExportacaoFormatoBloco(
                    formato: formato,
                    selecionado: formato == _formato,
                    aoTocar: () => setState(() => _formato = formato),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 12),
                TituloSecao(
                  titulo: 'Seleção de dados',
                  complemento: estado.talhoes.isEmpty
                      ? null
                      : TextButton(
                          onPressed: () => _toggleTodosTalhoes(estado.talhoes),
                          child: Text(
                            selecionadoTalhaoQuantidade == estado.talhoes.length
                                ? 'Desmarcar todos'
                                : 'Selecionar todos',
                          ),
                        ),
                ),
                if (estado.propriedade == null)
                  const _VazioExportacaoCartao(
                    icone: Icons.map_outlined,
                    titulo: 'Selecione uma propriedade',
                    mensagem:
                        'Escolha a propriedade para listar os talhões disponíveis para exportação.',
                  )
                else if (estado.talhoes.isEmpty)
                  const _VazioExportacaoCartao(
                    icone: Icons.inventory_2_outlined,
                    titulo: 'Nenhum dado para exportar',
                    mensagem:
                        'Essa propriedade ainda não possui talhões com levantamento registrado.',
                  )
                else
                  for (final talhao in estado.talhoes)
                    _ExportacaoTalhaoBloco(
                      opcao: talhao,
                      selecionado: selecionadoTalhaoIds.contains(
                        talhao.talhaoLevantamento.id,
                      ),
                      aoAlterado: (selecionado) => _toggleTalhao(
                        talhao.talhaoLevantamento.id,
                        selecionado,
                      ),
                    ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed:
                        _atualAcao != null ||
                            estado.propriedade == null ||
                            selecionadoTalhaoIds.isEmpty
                        ? null
                        : () => _prepararExportacao(
                            estado,
                            _ExportacaoAcao.compartilhar,
                          ),
                    icon: _atualAcao == _ExportacaoAcao.compartilhar
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.ios_share),
                    label: Text(
                      _atualAcao == _ExportacaoAcao.compartilhar
                          ? 'Preparando...'
                          : 'Compartilhar arquivo',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed:
                        _atualAcao != null ||
                            estado.propriedade == null ||
                            selecionadoTalhaoIds.isEmpty
                        ? null
                        : () => _prepararExportacao(
                            estado,
                            _ExportacaoAcao.salvar,
                          ),
                    icon: _atualAcao == _ExportacaoAcao.salvar
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_alt_outlined),
                    label: Text(
                      _atualAcao == _ExportacaoAcao.salvar
                          ? 'Salvando...'
                          : 'Salvar no aparelho',
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (erro, pilhaTrace) => _ExportacaoCarregarErro(
            aoTentarNovamente: () =>
                ref.invalidate(provedorExportacaoDados(solicitacao)),
          ),
        ),
      ),
    );
  }

  void _sincronizarPropriedadeSelecao(EstadoExportacaoDados estado) {
    if (widget.levantamentoId != null || _propriedadeId != null) return;
    if (estado.propriedades.length != 1) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _propriedadeId != null) return;
      setState(() => _propriedadeId = estado.propriedades.single.id);
    });
  }

  void _sincronizarTalhaoSelecao(EstadoExportacaoDados estado) {
    final key =
        '${estado.propriedade?.id ?? 'none'}-${estado.levantamento?.id ?? 'latest'}-${estado.talhoes.map((item) => item.talhaoLevantamento.id).join('|')}';
    if (_selecaoSincronizarChave == key) return;

    final disponivelIds = {
      for (final opcao in estado.talhoes) opcao.talhaoLevantamento.id,
    };
    final inicial = widget.inicialTalhaoIds;
    final selecionado = inicial.isEmpty
        ? disponivelIds
        : {
            for (final opcao in estado.talhoes)
              if (inicial.contains(opcao.talhao.id) ||
                  inicial.contains(opcao.talhaoLevantamento.id))
                opcao.talhaoLevantamento.id,
          };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _selecaoSincronizarChave == key) return;
      setState(() {
        _selecaoSincronizarChave = key;
        _selecionadoTalhaoIds = selecionado.isEmpty
            ? disponivelIds
            : selecionado;
      });
    });
  }

  void _alterarPropriedade(int? propriedadeId) {
    setState(() {
      _propriedadeId = propriedadeId;
      _selecionadoTalhaoIds = null;
      _selecaoSincronizarChave = null;
    });
  }

  void _toggleTodosTalhoes(List<OpcaoTalhaoExportacao> talhoes) {
    final todosIds = {
      for (final talhao in talhoes) talhao.talhaoLevantamento.id,
    };
    final selecionado = _selecionadoTalhaoIds ?? const <int>{};

    setState(() {
      _selecionadoTalhaoIds = selecionado.length == todosIds.length
          ? <int>{}
          : todosIds;
    });
  }

  void _toggleTalhao(int talhaoLevantamentoId, bool selecionado) {
    final proximo = {...?_selecionadoTalhaoIds};
    if (selecionado) {
      proximo.add(talhaoLevantamentoId);
    } else {
      proximo.remove(talhaoLevantamentoId);
    }
    setState(() => _selecionadoTalhaoIds = proximo);
  }

  Future<void> _prepararExportacao(
    EstadoExportacaoDados estado,
    _ExportacaoAcao acao,
  ) async {
    final propriedade = estado.propriedade;
    final selecionadoTalhaoIds = _selecionadoTalhaoIds ?? const <int>{};
    if (propriedade == null || selecionadoTalhaoIds.isEmpty) return;

    setState(() => _atualAcao = acao);

    try {
      final solicitacao = SolicitacaoExportacaoDados(
        propriedadeId: _propriedadeId,
        levantamentoId: widget.levantamentoId,
        especieId: widget.especieId,
      );
      final repositorio = ref.read(provedorRepositorioExportacaoDados);
      final arquivo = await repositorio.gerarArquivo(
        solicitacao: solicitacao,
        formato: _formato,
        talhaoLevantamentoIds: selecionadoTalhaoIds,
      );

      if (acao == _ExportacaoAcao.salvar) {
        final salvo = await SalvadorArquivoAndroid.salvarArquivo(
          caminho: arquivo.caminho,
          nomeArquivo: arquivo.nomeArquivo,
          tipoMime: arquivo.tipoMime,
        );
        if (!mounted) return;
        if (!salvo) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Salvamento cancelado.')),
          );
          return;
        }

        await repositorio.registrarExportacao(
          formatos: [_formato.rotulo],
          propriedade: propriedade,
          talhaoQuantidade: selecionadoTalhaoIds.length,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${arquivo.nomeArquivo} salvo no aparelho.')),
        );
        return;
      }

      final resultado = await SharePlus.instance.share(
        ShareParams(
          title: 'DENDRO Mobile',
          subject: 'DENDRO Mobile - ${propriedade.nome}',
          text: 'Exportação DENDRO Mobile - ${propriedade.nome}',
          files: [XFile(arquivo.caminho, mimeType: arquivo.tipoMime)],
          fileNameOverrides: [arquivo.nomeArquivo],
        ),
      );

      if (!mounted) return;
      if (resultado.status == ShareResultStatus.success ||
          resultado.status == ShareResultStatus.unavailable) {
        await repositorio.registrarExportacao(
          formatos: [_formato.rotulo],
          propriedade: propriedade,
          talhaoQuantidade: selecionadoTalhaoIds.length,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${arquivo.nomeArquivo} pronto para compartilhar.'),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compartilhamento cancelado.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: Text(
            acao == _ExportacaoAcao.salvar
                ? 'Não foi possível salvar a exportação.'
                : 'Não foi possível preparar a exportação.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _atualAcao = null);
    }
  }
}

enum _ExportacaoAcao { compartilhar, salvar }

extension _ExportacaoDadosFormatoUi on FormatoExportacaoDados {
  String get titulo {
    return switch (this) {
      FormatoExportacaoDados.pdf => 'Relatório PDF',
      FormatoExportacaoDados.csv => 'Dados e resultados (CSV)',
      FormatoExportacaoDados.brutoCsv => 'Dados brutos (CSV)',
      FormatoExportacaoDados.brutoXlsx => 'Dados brutos (XLSX)',
      FormatoExportacaoDados.xls => 'Planilha (Excel)',
      FormatoExportacaoDados.kml => 'Coordenadas (Google Earth)',
    };
  }

  String get descricao {
    return switch (this) {
      FormatoExportacaoDados.pdf =>
        'Resumo formatado para impressão e entrega.',
      FormatoExportacaoDados.brutoXlsx =>
        'Parcelas lado a lado, com árvore, DAP e altura. Uma aba por talhão.',
      FormatoExportacaoDados.brutoCsv =>
        'Todas as árvores dos talhões selecionados: propriedade, talhão, parcela, DAP e altura registrados, sem resultados calculados.',
      FormatoExportacaoDados.csv =>
        'Tabelas simples para análise em outros softwares.',
      FormatoExportacaoDados.xls =>
        'Dados organizados para conferência e cálculos.',
      FormatoExportacaoDados.kml =>
        'Arquivo com pontos GPS para abrir no Google Earth.',
    };
  }

  IconData get icone {
    return switch (this) {
      FormatoExportacaoDados.pdf => Icons.picture_as_pdf_outlined,
      FormatoExportacaoDados.brutoCsv => Icons.table_rows_outlined,
      FormatoExportacaoDados.brutoXlsx => Icons.grid_on_outlined,
      FormatoExportacaoDados.csv => Icons.table_rows_outlined,
      FormatoExportacaoDados.xls => Icons.grid_on_outlined,
      FormatoExportacaoDados.kml => Icons.public,
    };
  }
}

class _ExportacaoIntroducaoCartao extends StatelessWidget {
  const _ExportacaoIntroducaoCartao({
    required this.propriedade,
    required this.levantamento,
  });

  final Propriedade? propriedade;
  final Levantamento? levantamento;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      fundoCor: const Color(0xFFE0F2E8),
      bordaCor: const Color(0xFFA4D1B4),
      filho: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exportar dados',
            style: TextStyle(
              color: CoresDendro.principal,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            propriedade == null
                ? 'Selecione uma propriedade e o formato desejado.'
                : '${propriedade!.nome} - ${propriedade!.municipio}-${propriedade!.estado}',
            style: const TextStyle(
              color: CoresDendro.textoDiscreto,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (levantamento != null) ...[
            const SizedBox(height: 8),
            IndicadorSituacao(
              rotulo: 'Levantamento ${_formatoData(levantamento!.iniciadoEm)}',
            ),
          ],
        ],
      ),
    );
  }
}

class _PropriedadeSeletor extends StatelessWidget {
  const _PropriedadeSeletor({
    required this.propriedades,
    required this.selecionadoPropriedadeId,
    required this.aoAlterado,
  });

  final List<Propriedade> propriedades;
  final int? selecionadoPropriedadeId;
  final ValueChanged<int?> aoAlterado;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      filho: DropdownButtonFormField<int>(
        key: ValueKey(selecionadoPropriedadeId),
        isExpanded: true,
        initialValue: selecionadoPropriedadeId,
        decoration: const InputDecoration(
          labelText: 'Propriedade',
          prefixIcon: Icon(Icons.map_outlined),
        ),
        items: [
          for (final propriedade in propriedades)
            DropdownMenuItem(
              value: propriedade.id,
              child: Text(propriedade.nome, overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: aoAlterado,
      ),
    );
  }
}

class _ExportacaoFormatoBloco extends StatelessWidget {
  const _ExportacaoFormatoBloco({
    required this.formato,
    required this.selecionado,
    required this.aoTocar,
  });

  final FormatoExportacaoDados formato;
  final bool selecionado;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: aoTocar,
      child: CartaoDendro(
        fundoCor: selecionado
            ? const Color(0xFFE0F2E8)
            : const Color(0xFFF3F4F3),
        bordaCor: selecionado ? CoresDendro.principal : CoresDendro.contorno,
        espacamentoInterno: const EdgeInsets.fromLTRB(12, 10, 10, 10),
        filho: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selecionado
                    ? CoresDendro.principal
                    : CoresDendro.principalSuave,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                formato.icone,
                color: selecionado ? Colors.white : CoresDendro.principal,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formato.titulo,
                    style: const TextStyle(
                      color: CoresDendro.texto,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formato.descricao,
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
            Icon(
              selecionado
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selecionado
                  ? CoresDendro.principal
                  : CoresDendro.textoDiscreto,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportacaoTalhaoBloco extends StatelessWidget {
  const _ExportacaoTalhaoBloco({
    required this.opcao,
    required this.selecionado,
    required this.aoAlterado,
  });

  final OpcaoTalhaoExportacao opcao;
  final bool selecionado;
  final ValueChanged<bool> aoAlterado;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CartaoDendro(
        fundoCor: selecionado
            ? const Color(0xFFE0F2E8)
            : const Color(0xFFF3F4F3),
        bordaCor: selecionado ? CoresDendro.principal : CoresDendro.contorno,
        espacamentoInterno: const EdgeInsets.fromLTRB(4, 8, 10, 8),
        filho: Row(
          children: [
            Checkbox(
              value: selecionado,
              activeColor: CoresDendro.principal,
              checkColor: Colors.white,
              onChanged: (valor) => aoAlterado(valor ?? false),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${opcao.talhao.identificacao} • ${opcao.especie.nome}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CoresDendro.texto,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      _TalhaoMetadados('${opcao.parcelaQuantidade} parcelas'),
                      _TalhaoMetadados('${opcao.arvoreQuantidade} árvores'),
                      _TalhaoMetadados(
                        '${_formatoArea(opcao.medidaAreaHa)} ha',
                      ),
                      if (opcao.geograficoPontoQuantidade > 0)
                        _TalhaoMetadados(
                          '${opcao.geograficoPontoQuantidade} GPS',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IndicadorSituacao(
              rotulo:
                  '${opcao.coletadaParcelaQuantidade}/${opcao.parcelaQuantidade == 0 ? '-' : opcao.parcelaQuantidade}',
            ),
          ],
        ),
      ),
    );
  }
}

class _TalhaoMetadados extends StatelessWidget {
  const _TalhaoMetadados(this.rotulo);

  final String rotulo;

  @override
  Widget build(BuildContext context) {
    return Text(
      rotulo,
      style: const TextStyle(
        color: CoresDendro.textoDiscreto,
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _VazioExportacaoCartao extends StatelessWidget {
  const _VazioExportacaoCartao({
    required this.icone,
    required this.titulo,
    required this.mensagem,
  });

  final IconData icone;
  final String titulo;
  final String mensagem;

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
        ],
      ),
    );
  }
}

class _ExportacaoCarregarErro extends StatelessWidget {
  const _ExportacaoCarregarErro({required this.aoTentarNovamente});

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
                'Não foi possível carregar os dados de exportação.',
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

String _formatoArea(double valor) {
  return valor.toStringAsFixed(2).replaceAll('.', ',');
}

String _formatoData(DateTime valor) {
  final dia = valor.day.toString().padLeft(2, '0');
  final mes = valor.month.toString().padLeft(2, '0');
  final ano = valor.year.toString();
  return '$dia/$mes/$ano';
}
