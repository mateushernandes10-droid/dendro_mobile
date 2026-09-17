import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:excel/excel.dart' as excel;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../nucleo/banco/banco_dendro.dart';
import '../../../nucleo/floresta/calculadora_volume_florestal.dart';
import '../../../nucleo/provedores/provedores_banco.dart';
import '../../atividades/dados/repositorio_atividades.dart';

final provedorRepositorioExportacaoDados = Provider<RepositorioExportacaoDados>(
  (ref) {
    return RepositorioExportacaoDados(ref.watch(provedorBancoDendro));
  },
);

final provedorExportacaoDados = FutureProvider.autoDispose
    .family<EstadoExportacaoDados, SolicitacaoExportacaoDados>((
      ref,
      solicitacao,
    ) {
      return ref
          .watch(provedorRepositorioExportacaoDados)
          .carregar(solicitacao);
    });

enum FormatoExportacaoDados {
  pdf(rotulo: 'PDF', extensao: 'pdf', tipoMime: 'application/pdf'),
  csv(rotulo: 'CSV', extensao: 'csv', tipoMime: 'text/csv'),
  brutoCsv(rotulo: 'Dados brutos CSV', extensao: 'csv', tipoMime: 'text/csv'),
  brutoXlsx(
    rotulo: 'Dados brutos XLSX',
    extensao: 'xlsx',
    tipoMime:
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  ),
  xls(
    rotulo: 'XLSX',
    extensao: 'xlsx',
    tipoMime:
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  ),
  kml(
    rotulo: 'KML',
    extensao: 'kml',
    tipoMime: 'application/vnd.google-earth.kml+xml',
  );

  const FormatoExportacaoDados({
    required this.rotulo,
    required this.extensao,
    required this.tipoMime,
  });

  final String rotulo;
  final String extensao;
  final String tipoMime;
}

class SolicitacaoExportacaoDados {
  const SolicitacaoExportacaoDados({
    this.propriedadeId,
    this.levantamentoId,
    this.especieId,
  });

  final int? propriedadeId;
  final int? levantamentoId;
  final int? especieId;

  @override
  bool operator ==(Object other) {
    return other is SolicitacaoExportacaoDados &&
        other.propriedadeId == propriedadeId &&
        other.levantamentoId == levantamentoId &&
        other.especieId == especieId;
  }

  @override
  int get hashCode => Object.hash(propriedadeId, levantamentoId, especieId);
}

class EstadoExportacaoDados {
  const EstadoExportacaoDados({
    required this.propriedades,
    required this.propriedade,
    required this.levantamento,
    required this.talhoes,
  });

  final List<Propriedade> propriedades;
  final Propriedade? propriedade;
  final Levantamento? levantamento;
  final List<OpcaoTalhaoExportacao> talhoes;
}

class OpcaoTalhaoExportacao {
  const OpcaoTalhaoExportacao({
    required this.talhaoLevantamento,
    required this.talhao,
    required this.especie,
    required this.parcelaQuantidade,
    required this.coletadaParcelaQuantidade,
    required this.arvoreQuantidade,
    required this.medidaAreaHa,
    required this.coordenadaQuantidade,
  });

  final TalhaoLevantamento talhaoLevantamento;
  final Talhao talhao;
  final Especie especie;
  final int parcelaQuantidade;
  final int coletadaParcelaQuantidade;
  final int arvoreQuantidade;
  final double medidaAreaHa;
  final int coordenadaQuantidade;

  bool get possuiDados =>
      parcelaQuantidade > 0 || arvoreQuantidade > 0 || coordenadaQuantidade > 0;
}

class ArquivoExportacaoGerado {
  const ArquivoExportacaoGerado({
    required this.caminho,
    required this.nomeArquivo,
    required this.tipoMime,
    required this.formato,
  });

  final String caminho;
  final String nomeArquivo;
  final String tipoMime;
  final FormatoExportacaoDados formato;
}

class DadosExportacao {
  const DadosExportacao({
    required this.propriedade,
    required this.levantamento,
    required this.talhoes,
  });

  final Propriedade propriedade;
  final Levantamento? levantamento;
  final List<DadosTalhaoExportacao> talhoes;

  int get parcelaQuantidade =>
      talhoes.fold(0, (total, talhao) => total + talhao.parcelas.length);

  int get coletadaParcelaQuantidade => talhoes.fold(
    0,
    (total, talhao) =>
        total +
        talhao.parcelas
            .where(
              (parcela) => parcela.parcela.situacao == SituacaoParcela.coletada,
            )
            .length,
  );

  int get arvoreQuantidade =>
      talhoes.fold(0, (total, talhao) => total + talhao.arvoreQuantidade);

  double get medidaAreaHa =>
      talhoes.fold(0, (total, talhao) => total + talhao.medidaAreaHa);

  double get amostraVolumeM3 =>
      talhoes.fold(0, (total, talhao) => total + talhao.amostraVolumeM3);

  double get talhaoAreaHa =>
      talhoes.fold(0, (total, talhao) => total + talhao.opcao.talhao.areaHa);

  double? get volumePorHaM3 =>
      medidaAreaHa == 0 ? null : amostraVolumeM3 / medidaAreaHa;

  double? get estimadoVolumeM3 {
    if (medidaAreaHa == 0) return null;
    return talhoes.fold<double>(
      0,
      (total, talhao) => total + (talhao.estimadoVolumeM3 ?? 0),
    );
  }

  double? get arvoresPorHa =>
      medidaAreaHa == 0 ? null : arvoreQuantidade / medidaAreaHa;

  double? get mediaDapCm {
    final todosArvores = [
      for (final talhao in talhoes)
        for (final parcela in talhao.parcelas) ...parcela.arvores,
    ];
    if (todosArvores.isEmpty) return null;
    return todosArvores.fold<double>(
          0,
          (total, arvore) => total + arvore.dapCm,
        ) /
        todosArvores.length;
  }

  double? get mediaAlturaM {
    final todosArvores = [
      for (final talhao in talhoes)
        for (final parcela in talhao.parcelas) ...parcela.arvores,
    ];
    if (todosArvores.isEmpty) return null;
    return todosArvores.fold<double>(
          0,
          (total, arvore) => total + arvore.alturaM,
        ) /
        todosArvores.length;
  }
}

class DadosTalhaoExportacao {
  const DadosTalhaoExportacao({
    required this.opcao,
    required this.modeloMatematico,
    required this.coeficientes,
    required this.parcelas,
  });

  final OpcaoTalhaoExportacao opcao;
  final ModeloMatematico? modeloMatematico;
  final List<CoeficienteExportacao> coeficientes;
  final List<DadosParcelaExportacao> parcelas;

  int get arvoreQuantidade =>
      parcelas.fold(0, (total, parcela) => total + parcela.arvores.length);

  double get medidaAreaHa => parcelas.fold(
    0,
    (total, parcela) =>
        total +
        (parcela.parcela.situacao == SituacaoParcela.pendente
            ? 0
            : parcela.parcela.areaHa ?? 0),
  );

  Map<String, double?> get coeficienteValoresPorSimbolo => {
    for (final coeficiente in coeficientes)
      coeficiente.simbolo: coeficiente.valor,
  };

  ConversaoVolumeMadeira get conversao =>
      CalculadoraVolumeFlorestal.conversaoParaEspecie(opcao.especie.nome);

  double get amostraVolumeM3 {
    return parcelas.fold<double>(
      0,
      (total, parcela) =>
          total +
          parcela.arvores.fold<double>(
            0,
            (parcelaTotal, arvore) => parcelaTotal + volumeArvoreM3(arvore),
          ),
    );
  }

  double? get volumePorHaM3 =>
      medidaAreaHa == 0 ? null : amostraVolumeM3 / medidaAreaHa;

  double? get estimadoVolumeM3 =>
      volumePorHaM3 == null ? null : volumePorHaM3! * opcao.talhao.areaHa;

  double? get convertidoEstimadoVolume =>
      estimadoVolumeM3 == null ? null : conversao.converter(estimadoVolumeM3!);

  double? get convertidoVolumePorHa =>
      volumePorHaM3 == null ? null : conversao.converter(volumePorHaM3!);

  double? get arvoresPorHa =>
      medidaAreaHa == 0 ? null : arvoreQuantidade / medidaAreaHa;

  double get basalAreaAmostraM2 {
    return parcelas.fold<double>(
      0,
      (total, parcela) =>
          total +
          parcela.arvores.fold<double>(
            0,
            (parcelaTotal, arvore) =>
                parcelaTotal +
                math.pi * (arvore.dapCm / 200) * (arvore.dapCm / 200),
          ),
    );
  }

  double? get basalAreaPorHa =>
      medidaAreaHa == 0 ? null : basalAreaAmostraM2 / medidaAreaHa;

  double? get mediaVolumePorArvoreM3 =>
      arvoreQuantidade == 0 ? null : amostraVolumeM3 / arvoreQuantidade;

  double volumeArvoreM3(Arvore arvore) {
    return CalculadoraVolumeFlorestal.volumeArvoreM3(
      dapCm: arvore.dapCm,
      alturaM: arvore.alturaM,
      coeficientes: coeficienteValoresPorSimbolo,
      modeloMatematicoCodigo: modeloMatematico?.codigo,
      modeloMatematicoExpressao: modeloMatematico?.expressao,
    );
  }

  double? get mediaDapCm {
    final todosArvores = [for (final parcela in parcelas) ...parcela.arvores];
    if (todosArvores.isEmpty) return null;
    return todosArvores.fold<double>(
          0,
          (total, arvore) => total + arvore.dapCm,
        ) /
        todosArvores.length;
  }

  double? get mediaAlturaM {
    final todosArvores = [for (final parcela in parcelas) ...parcela.arvores];
    if (todosArvores.isEmpty) return null;
    return todosArvores.fold<double>(
          0,
          (total, arvore) => total + arvore.alturaM,
        ) /
        todosArvores.length;
  }
}

class CoeficienteExportacao {
  const CoeficienteExportacao({
    required this.simbolo,
    required this.rotulo,
    required this.valor,
  });

  final String simbolo;
  final String rotulo;
  final double? valor;
}

class DadosParcelaExportacao {
  const DadosParcelaExportacao({required this.parcela, required this.arvores});

  final Parcela parcela;
  final List<Arvore> arvores;

  List<Arvore> get pontosReferencia =>
      arvores
          .where(
            (arvore) =>
                arvore.latitude != null &&
                arvore.longitude != null &&
                arvore.posicaoReferenciaParcela != null,
          )
          .toList()
        ..sort(
          (a, b) => a.posicaoReferenciaParcela!.index.compareTo(
            b.posicaoReferenciaParcela!.index,
          ),
        );
}

class RepositorioExportacaoDados {
  RepositorioExportacaoDados(this._bancoDados);

  final BancoDendro _bancoDados;
  late final RepositorioAtividades _registroAtividade = RepositorioAtividades(
    _bancoDados,
  );

  Future<EstadoExportacaoDados> carregar(
    SolicitacaoExportacaoDados solicitacao,
  ) async {
    final propriedades = await _propriedades();
    final levantamento = solicitacao.levantamentoId == null
        ? null
        : await _levantamentoPorId(solicitacao.levantamentoId!);
    final propriedadeId =
        levantamento?.propriedadeId ?? solicitacao.propriedadeId;
    final propriedade = propriedadeId == null
        ? null
        : await _propriedadePorId(propriedadeId);
    final talhoes = levantamento == null
        ? await _maisRecenteTalhaoOpcoesParaPropriedade(
            propriedadeId: propriedadeId,
            especieId: solicitacao.especieId,
          )
        : await _opcoesTalhaoDoLevantamento(
            levantamentoId: levantamento.id,
            especieId: solicitacao.especieId,
          );

    return EstadoExportacaoDados(
      propriedades: propriedades,
      propriedade: propriedade,
      levantamento: levantamento,
      talhoes: talhoes,
    );
  }

  Future<ArquivoExportacaoGerado> gerarArquivo({
    required SolicitacaoExportacaoDados solicitacao,
    required FormatoExportacaoDados formato,
    required Set<int> talhaoLevantamentoIds,
  }) async {
    final conjuntoDados = await _conjuntoDadosParaExportacao(
      solicitacao: solicitacao,
      talhaoLevantamentoIds: talhaoLevantamentoIds,
    );
    final bytes = switch (formato) {
      FormatoExportacaoDados.pdf => await _pdfBytes(conjuntoDados),
      FormatoExportacaoDados.csv => _csvBytes(conjuntoDados),
      FormatoExportacaoDados.brutoCsv => _brutoCsvBytes(conjuntoDados),
      FormatoExportacaoDados.brutoXlsx => _brutoXlsxBytes(conjuntoDados),
      FormatoExportacaoDados.xls => _xlsxBytes(conjuntoDados),
      FormatoExportacaoDados.kml => _kmlBytes(conjuntoDados),
    };

    final diretorio = await getTemporaryDirectory();
    final exportacaoDiretorio = Directory(
      '${diretorio.path}${Platform.pathSeparator}dendro_exports',
    );
    await exportacaoDiretorio.create(recursive: true);

    final nomeArquivo = _nomeArquivo(conjuntoDados.propriedade, formato);
    final arquivo = File(
      '${exportacaoDiretorio.path}${Platform.pathSeparator}$nomeArquivo',
    );
    await arquivo.writeAsBytes(bytes, flush: true);

    return ArquivoExportacaoGerado(
      caminho: arquivo.path,
      nomeArquivo: nomeArquivo,
      tipoMime: formato.tipoMime,
      formato: formato,
    );
  }

  Future<void> registrarExportacao({
    required List<String> formatos,
    required Propriedade propriedade,
    required int talhaoQuantidade,
  }) {
    final formatoRotulo = formatos.join(', ');
    final talhaoRotulo = talhaoQuantidade == 1
        ? '1 talhão'
        : '$talhaoQuantidade talhões';
    return _registroAtividade.registrarExportacao(
      formato: '$formatoRotulo - $talhaoRotulo',
      propriedadeNome: propriedade.nome,
      entidadeId: propriedade.id,
    );
  }

  Future<DadosExportacao> _conjuntoDadosParaExportacao({
    required SolicitacaoExportacaoDados solicitacao,
    required Set<int> talhaoLevantamentoIds,
  }) async {
    final estado = await carregar(solicitacao);
    final propriedade = estado.propriedade;
    if (propriedade == null) {
      throw StateError('Selecione uma propriedade para exportar.');
    }

    final selecionadoOpcoes = estado.talhoes
        .where(
          (opcao) =>
              talhaoLevantamentoIds.contains(opcao.talhaoLevantamento.id),
        )
        .toList();

    if (selecionadoOpcoes.isEmpty) {
      throw StateError('Selecione pelo menos um talhão para exportar.');
    }

    final talhoes = <DadosTalhaoExportacao>[];
    for (final opcao in selecionadoOpcoes) {
      final parcelas = await _parcelasParaTalhao(opcao.talhaoLevantamento.id);
      final modeloMatematico = await _modeloMatematicoPorId(
        opcao.talhaoLevantamento.modeloMatematicoId,
      );
      final coeficientes = await _coeficientesParaTalhao(
        talhaoLevantamentoId: opcao.talhaoLevantamento.id,
        especieId: opcao.talhaoLevantamento.especieId,
        modeloMatematicoId: opcao.talhaoLevantamento.modeloMatematicoId,
      );

      talhoes.add(
        DadosTalhaoExportacao(
          opcao: opcao,
          modeloMatematico: modeloMatematico,
          coeficientes: coeficientes,
          parcelas: [
            for (final parcela in parcelas)
              DadosParcelaExportacao(
                parcela: parcela,
                arvores: await _arvoresParaParcela(parcela.id),
              ),
          ],
        ),
      );
    }

    return DadosExportacao(
      propriedade: propriedade,
      levantamento: estado.levantamento,
      talhoes: talhoes,
    );
  }

  Future<List<Propriedade>> _propriedades() {
    return (_bancoDados.select(
      _bancoDados.propriedades,
    )..orderBy([(tabela) => OrderingTerm.asc(tabela.nome)])).get();
  }

  Future<Propriedade?> _propriedadePorId(int id) {
    return (_bancoDados.select(
      _bancoDados.propriedades,
    )..where((tabela) => tabela.id.equals(id))).getSingleOrNull();
  }

  Future<Levantamento?> _levantamentoPorId(int id) {
    return (_bancoDados.select(
      _bancoDados.levantamentos,
    )..where((tabela) => tabela.id.equals(id))).getSingleOrNull();
  }

  Future<ModeloMatematico?> _modeloMatematicoPorId(int id) {
    return (_bancoDados.select(
      _bancoDados.modelosMatematicos,
    )..where((tabela) => tabela.id.equals(id))).getSingleOrNull();
  }

  Future<List<CoeficienteExportacao>> _coeficientesParaTalhao({
    required int talhaoLevantamentoId,
    required int especieId,
    required int modeloMatematicoId,
  }) async {
    final linhas = await _bancoDados
        .customSelect(
          '''
SELECT simbolo, rotulo, valor
FROM coeficientes_talhao_levantamento
WHERE talhao_levantamento_id = ?
ORDER BY simbolo
''',
          variables: [Variable<int>(talhaoLevantamentoId)],
          readsFrom: const {},
        )
        .get();

    final globalValores = await _valoresCoeficientesGlobais(modeloMatematicoId);
    final especieValores = await _valoresCoeficientesDaEspecie(
      especieId: especieId,
      modeloMatematicoId: modeloMatematicoId,
    );
    if (linhas.isNotEmpty) {
      return [
        for (final linha in linhas)
          CoeficienteExportacao(
            simbolo: linha.read<String>('simbolo'),
            rotulo: linha.read<String>('rotulo'),
            valor: _valorEfetivoCoeficiente(
              modeloMatematicoCodigo: await _bancoDados.codigoModeloPorId(
                modeloMatematicoId,
              ),
              simbolo: linha.read<String>('simbolo'),
              valor: linha.readNullable<double>('valor'),
              especieValores: especieValores,
              globalValores: globalValores,
            ),
          ),
      ];
    }

    final coeficientes =
        await (_bancoDados.select(_bancoDados.coeficientesModelo)
              ..where(
                (tabela) =>
                    tabela.modeloMatematicoId.equals(modeloMatematicoId),
              )
              ..orderBy([(tabela) => OrderingTerm.asc(tabela.simbolo)]))
            .get();

    return [
      for (final coeficiente in coeficientes)
        CoeficienteExportacao(
          simbolo: coeficiente.simbolo,
          rotulo: coeficiente.rotulo,
          valor: _valorEfetivoCoeficiente(
            modeloMatematicoCodigo: await _bancoDados.codigoModeloPorId(
              modeloMatematicoId,
            ),
            simbolo: coeficiente.simbolo,
            valor: coeficiente.valor,
            especieValores: especieValores,
            globalValores: globalValores,
          ),
        ),
    ];
  }

  Future<Map<String, double?>> _valoresCoeficientesDaEspecie({
    required int especieId,
    required int modeloMatematicoId,
  }) async {
    final coeficientes =
        await (_bancoDados.select(_bancoDados.coeficientesEspecieModelo)..where(
              (tabela) =>
                  tabela.especieId.equals(especieId) &
                  tabela.modeloMatematicoId.equals(modeloMatematicoId),
            ))
            .get();
    return {
      for (final coeficiente in coeficientes)
        coeficiente.simbolo: coeficiente.valor,
    };
  }

  Future<Map<String, double?>> _valoresCoeficientesGlobais(
    int modeloMatematicoId,
  ) async {
    final coeficientes =
        await (_bancoDados.select(_bancoDados.coeficientesModelo)..where(
              (tabela) => tabela.modeloMatematicoId.equals(modeloMatematicoId),
            ))
            .get();
    return {
      for (final coeficiente in coeficientes)
        coeficiente.simbolo: coeficiente.valor,
    };
  }

  double? _valorEfetivoCoeficiente({
    required String? modeloMatematicoCodigo,
    required String simbolo,
    required double? valor,
    required Map<String, double?> especieValores,
    required Map<String, double?> globalValores,
  }) {
    return valor ??
        especieValores[simbolo] ??
        globalValores[simbolo] ??
        CalculadoraVolumeFlorestal.valorPadraoCoeficiente(
          modeloMatematicoCodigo: modeloMatematicoCodigo,
          simbolo: simbolo,
        );
  }

  Future<List<OpcaoTalhaoExportacao>> _opcoesTalhaoDoLevantamento({
    required int levantamentoId,
    int? especieId,
  }) async {
    final condicoes = <Expression<bool>>[
      _bancoDados.talhaoLevantamentos.levantamentoId.equals(levantamentoId),
    ];
    if (especieId != null) {
      condicoes.add(
        _bancoDados.talhaoLevantamentos.especieId.equals(especieId),
      );
    }

    final consulta =
        _bancoDados.select(_bancoDados.talhaoLevantamentos).join([
            innerJoin(
              _bancoDados.talhoes,
              _bancoDados.talhoes.id.equalsExp(
                _bancoDados.talhaoLevantamentos.talhaoId,
              ),
            ),
            innerJoin(
              _bancoDados.especies,
              _bancoDados.especies.id.equalsExp(
                _bancoDados.talhaoLevantamentos.especieId,
              ),
            ),
          ])
          ..where(condicoes.reduce((valor, elemento) => valor & elemento))
          ..orderBy([OrderingTerm.asc(_bancoDados.talhoes.identificacao)]);

    return _opcoesDeLinhas(await consulta.get());
  }

  Future<List<OpcaoTalhaoExportacao>> _maisRecenteTalhaoOpcoesParaPropriedade({
    required int? propriedadeId,
    int? especieId,
  }) async {
    if (propriedadeId == null) return const [];

    final condicoes = <Expression<bool>>[
      _bancoDados.talhoes.propriedadeId.equals(propriedadeId),
    ];
    if (especieId != null) {
      condicoes.add(
        _bancoDados.talhaoLevantamentos.especieId.equals(especieId),
      );
    }

    final consulta =
        _bancoDados.select(_bancoDados.talhaoLevantamentos).join([
            innerJoin(
              _bancoDados.levantamentos,
              _bancoDados.levantamentos.id.equalsExp(
                _bancoDados.talhaoLevantamentos.levantamentoId,
              ),
            ),
            innerJoin(
              _bancoDados.talhoes,
              _bancoDados.talhoes.id.equalsExp(
                _bancoDados.talhaoLevantamentos.talhaoId,
              ),
            ),
            innerJoin(
              _bancoDados.especies,
              _bancoDados.especies.id.equalsExp(
                _bancoDados.talhaoLevantamentos.especieId,
              ),
            ),
          ])
          ..where(condicoes.reduce((valor, elemento) => valor & elemento))
          ..orderBy([
            OrderingTerm.asc(_bancoDados.talhoes.identificacao),
            OrderingTerm.desc(_bancoDados.talhaoLevantamentos.atualizadoEm),
          ]);

    final maisRecenteLinhasPorTalhaoId = <int, TypedResult>{};
    for (final linha in await consulta.get()) {
      final talhao = linha.readTable(_bancoDados.talhoes);
      maisRecenteLinhasPorTalhaoId.putIfAbsent(talhao.id, () => linha);
    }

    return _opcoesDeLinhas(maisRecenteLinhasPorTalhaoId.values.toList());
  }

  Future<List<OpcaoTalhaoExportacao>> _opcoesDeLinhas(
    List<TypedResult> linhas,
  ) async {
    final opcoes = <OpcaoTalhaoExportacao>[];

    for (final linha in linhas) {
      final talhaoLevantamento = linha.readTable(
        _bancoDados.talhaoLevantamentos,
      );
      opcoes.add(
        OpcaoTalhaoExportacao(
          talhaoLevantamento: talhaoLevantamento,
          talhao: linha.readTable(_bancoDados.talhoes),
          especie: linha.readTable(_bancoDados.especies),
          parcelaQuantidade: await _quantidadeParcelas(talhaoLevantamento.id),
          coletadaParcelaQuantidade: await _quantidadeParcelasColetadas(
            talhaoLevantamento.id,
          ),
          arvoreQuantidade: await _quantidadeArvores(talhaoLevantamento.id),
          medidaAreaHa: await _somarAreaMedida(talhaoLevantamento.id),
          coordenadaQuantidade: await _quantidadeCoordenadasArvores(
            talhaoLevantamento.id,
          ),
        ),
      );
    }

    opcoes.sort(
      (a, b) => a.talhao.identificacao.compareTo(b.talhao.identificacao),
    );
    return opcoes;
  }

  Future<int> _quantidadeParcelas(int talhaoLevantamentoId) async {
    final quantidade = _bancoDados.parcelas.id.count();
    final linha =
        await (_bancoDados.selectOnly(_bancoDados.parcelas)
              ..addColumns([quantidade])
              ..where(
                _bancoDados.parcelas.talhaoLevantamentoId.equals(
                  talhaoLevantamentoId,
                ),
              ))
            .getSingle();

    return linha.read(quantidade) ?? 0;
  }

  Future<int> _quantidadeParcelasColetadas(int talhaoLevantamentoId) async {
    final quantidade = _bancoDados.parcelas.id.count();
    final linha =
        await (_bancoDados.selectOnly(_bancoDados.parcelas)
              ..addColumns([quantidade])
              ..where(
                _bancoDados.parcelas.talhaoLevantamentoId.equals(
                      talhaoLevantamentoId,
                    ) &
                    _bancoDados.parcelas.situacao.equalsValue(
                      SituacaoParcela.coletada,
                    ),
              ))
            .getSingle();

    return linha.read(quantidade) ?? 0;
  }

  Future<int> _quantidadeArvores(int talhaoLevantamentoId) async {
    final quantidade = _bancoDados.arvores.id.count();
    final linha =
        await (_bancoDados.selectOnly(_bancoDados.arvores).join([
                innerJoin(
                  _bancoDados.parcelas,
                  _bancoDados.parcelas.id.equalsExp(
                    _bancoDados.arvores.parcelaId,
                  ),
                ),
              ])
              ..addColumns([quantidade])
              ..where(
                _bancoDados.parcelas.talhaoLevantamentoId.equals(
                  talhaoLevantamentoId,
                ),
              ))
            .getSingle();

    return linha.read(quantidade) ?? 0;
  }

  Future<double> _somarAreaMedida(int talhaoLevantamentoId) async {
    final linha = await _bancoDados
        .customSelect(
          '''
SELECT COALESCE(SUM(area_ha), 0.0) AS area
FROM parcelas
WHERE talhao_levantamento_id = ?
  AND situacao != ?
''',
          variables: [
            Variable<int>(talhaoLevantamentoId),
            Variable<String>(SituacaoParcela.pendente.name),
          ],
        )
        .getSingle();

    return linha.read<double>('area');
  }

  Future<int> _quantidadeCoordenadasArvores(int talhaoLevantamentoId) async {
    final linha = await _bancoDados
        .customSelect(
          '''
SELECT COUNT(*) AS count
FROM arvores tree
INNER JOIN parcelas plot ON plot.id = tree.parcela_id
WHERE plot.talhao_levantamento_id = ?
  AND tree.latitude IS NOT NULL
  AND tree.longitude IS NOT NULL
''',
          variables: [Variable<int>(talhaoLevantamentoId)],
        )
        .getSingle();

    return linha.read<int>('count');
  }

  Future<List<Parcela>> _parcelasParaTalhao(int talhaoLevantamentoId) {
    return (_bancoDados.select(_bancoDados.parcelas)
          ..where(
            (tabela) =>
                tabela.talhaoLevantamentoId.equals(talhaoLevantamentoId),
          )
          ..orderBy([
            (tabela) => OrderingTerm.asc(tabela.identificacao),
            (tabela) => OrderingTerm.asc(tabela.criadoEm),
          ]))
        .get();
  }

  Future<List<Arvore>> _arvoresParaParcela(int parcelaId) {
    return (_bancoDados.select(_bancoDados.arvores)
          ..where((tabela) => tabela.parcelaId.equals(parcelaId))
          ..orderBy([(tabela) => OrderingTerm.asc(tabela.numero)]))
        .get();
  }
}

Future<List<int>> _pdfBytes(DadosExportacao conjuntoDados) async {
  final documento = pw.Document();
  final geradoEm = DateTime.now();

  documento.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(28),
      footer: (context) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'DENDRO Mobile - ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
      ),
      build: (context) => [
        _pdfCabecalho(conjuntoDados, geradoEm),
        pw.SizedBox(height: 14),
        _pdfSecaoTitulo('1. Identificação do levantamento'),
        _pdfInformacaoGrade([
          ['Propriedade', conjuntoDados.propriedade.nome],
          [
            'Município',
            '${conjuntoDados.propriedade.municipio}-${conjuntoDados.propriedade.estado}',
          ],
          [
            'Área total da propriedade',
            '${_decimal(conjuntoDados.propriedade.areaTotalHa)} ha',
          ],
          [
            'Área inventariada selecionada',
            '${_decimal(conjuntoDados.talhaoAreaHa)} ha',
          ],
          ['Gerado em', _dataHora(geradoEm)],
          if (conjuntoDados.levantamento != null)
            [
              'Data do levantamento',
              _dataHora(conjuntoDados.levantamento!.iniciadoEm),
            ],
          if (conjuntoDados.levantamento != null)
            [
              'Status',
              _levantamentoSituacaoRotulo(conjuntoDados.levantamento!.situacao),
            ],
        ]),
        pw.SizedBox(height: 12),
        _pdfSecaoTitulo('2. Objetivo'),
        _pdfParagrafo(_objetivoTexto(conjuntoDados, geradoEm)),
        pw.SizedBox(height: 12),
        _pdfSecaoTitulo('3. Metodologia'),
        _pdfParagrafo(_metodologiaTexto(conjuntoDados)),
        _pdfMarcadorLista([
          'Intensidade amostral: ${conjuntoDados.parcelaQuantidade} parcelas, sendo ${conjuntoDados.coletadaParcelaQuantidade} coletadas, totalizando ${_decimal(conjuntoDados.medidaAreaHa)} ha de área medida.',
          'Diâmetro à Altura do Peito (DAP): medido a 1,30 m do solo em todas as árvores da amostra.',
          'Altura total (h): informada em metros para estimativa do volume individual.',
          'As coordenadas GPS registradas no aplicativo são incluídas nos arquivos de coordenadas e na conferência das parcelas.',
        ]),
        pw.SizedBox(height: 12),
        _pdfSecaoTitulo('4. Modelos matemáticos utilizados'),
        _pdfParagrafo(
          'A partir dos dados dendrométricos coletados em campo, foram aplicados os modelos matemáticos configurados no DENDRO Mobile para estimativa de altura e volume de madeira.',
        ),
        _pdfModeloMatematicoTabela(conjuntoDados),
        pw.SizedBox(height: 12),
        _pdfSecaoTitulo('5. Resultados do inventário'),
        _pdfInformacaoGrade([
          ['Talhões inventariados', conjuntoDados.talhoes.length.toString()],
          ['Parcelas avaliadas', conjuntoDados.parcelaQuantidade.toString()],
          ['Árvores amostradas', conjuntoDados.arvoreQuantidade.toString()],
          [
            'Área total inventariada',
            '${_decimal(conjuntoDados.talhaoAreaHa)} ha',
          ],
          ['Área total medida', '${_decimal(conjuntoDados.medidaAreaHa)} ha'],
          ['Árvores/ha', _opcionalDecimal(conjuntoDados.arvoresPorHa)],
          [
            'Volume amostrado',
            '${_decimalPrecisao(conjuntoDados.amostraVolumeM3, fracaoDigitos: 4)} m³',
          ],
          [
            'Volume/ha',
            _opcionalDecimal(conjuntoDados.volumePorHaM3, sufixo: ' m³/ha'),
          ],
          [
            'Volume estimado total',
            _opcionalDecimal(conjuntoDados.estimadoVolumeM3, sufixo: ' m³'),
          ],
          [
            'DAP médio',
            _opcionalDecimal(conjuntoDados.mediaDapCm, sufixo: ' cm'),
          ],
          [
            'Altura média',
            _opcionalDecimal(conjuntoDados.mediaAlturaM, sufixo: ' m'),
          ],
        ]),
        pw.SizedBox(height: 14),
        _pdfSecaoTitulo('5.1 Área e volume por espécie'),
        _pdfEspecieResultadosTabela(conjuntoDados),
        pw.SizedBox(height: 14),
        _pdfSecaoTitulo('5.2 Dados dendrométricos por talhão'),
        _pdfDendrometricTabela(conjuntoDados, geradoEm),
        pw.SizedBox(height: 16),
        for (final talhao in conjuntoDados.talhoes) ...[
          _pdfSecaoTitulo(
            '5.3 Parcelas - ${talhao.opcao.talhao.identificacao}',
          ),
          _pdfParagrafo(
            'Espécie: ${talhao.opcao.especie.nome}. Modelo: ${talhao.modeloMatematico?.nome ?? 'sem modelo'}. Coeficientes: ${_coeficienteLista(talhao)}.',
          ),
          if (talhao.parcelas.isEmpty)
            pw.Text(
              'Nenhuma parcela cadastrada para este talhão.',
              style: const pw.TextStyle(fontSize: 9),
            )
          else
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              headerStyle: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.centerLeft,
              headers: [
                'Parcela',
                'Status',
                'Área (ha)',
                'Árvores',
                'Vol. amostral',
                'DAP médio',
                'Alt. média',
                'GPS',
              ],
              data: [
                for (final parcela in talhao.parcelas)
                  [
                    parcela.parcela.identificacao,
                    _parcelaSituacaoRotulo(parcela.parcela.situacao),
                    _opcionalDecimal(parcela.parcela.areaHa),
                    parcela.arvores.length.toString(),
                    _opcionalDecimal(
                      _parcelaVolumeM3(talhao, parcela),
                      sufixo: ' m³',
                    ),
                    _opcionalDecimal(_mediaDap(parcela.arvores), sufixo: ' cm'),
                    _opcionalDecimal(
                      _mediaAltura(parcela.arvores),
                      sufixo: ' m',
                    ),
                    parcela.pontosReferencia.length.toString(),
                  ],
              ],
            ),
          pw.SizedBox(height: 12),
        ],
        _pdfSecaoTitulo('6. Observações técnicas'),
        _pdfMarcadorLista(_observacoesTecnicas(conjuntoDados)),
      ],
    ),
  );

  return documento.save();
}

Iterable<List<Object?>> _brutoLinhas(DadosExportacao conjuntoDados) sync* {
  yield [
    'Propriedade',
    'Talhão',
    'Parcela',
    'Árvore',
    'DAP (cm)',
    'Altura (m)',
    'Levantamento ID',
    'Espécie',
    'Status parcela',
    'Área parcela (ha)',
    'Tronco torto',
    'Ponto de referência da parcela',
    'Latitude do ponto',
    'Longitude do ponto',
    'Precisão GPS (m)',
    'Data da captura GPS',
    'Data cadastro árvore',
    'Data atualização árvore',
    'Árvore ID',
  ];
  for (final talhao in conjuntoDados.talhoes) {
    for (final parcela in talhao.parcelas) {
      for (final arvore in parcela.arvores) {
        yield [
          conjuntoDados.propriedade.nome,
          talhao.opcao.talhao.identificacao,
          parcela.parcela.identificacao,
          arvore.numero,
          arvore.dapCm,
          arvore.alturaM,
          talhao.opcao.talhaoLevantamento.levantamentoId,
          talhao.opcao.especie.nome,
          _parcelaSituacaoRotulo(parcela.parcela.situacao),
          parcela.parcela.areaHa,
          arvore.possuiTroncoTortuoso ? 'Sim' : 'Não',
          _referenciaRotulo(arvore.posicaoReferenciaParcela),
          arvore.latitude,
          arvore.longitude,
          arvore.precisaoMetros,
          arvore.localizacaoCapturadaEm?.toIso8601String(),
          arvore.criadoEm.toIso8601String(),
          arvore.atualizadoEm.toIso8601String(),
          arvore.id,
        ];
      }
    }
  }
}

List<int> _brutoCsvBytes(DadosExportacao conjuntoDados) {
  final buffer = StringBuffer('\uFEFF');
  for (final linha in _brutoLinhas(conjuntoDados)) {
    buffer.write(
      _csvLinha([
        for (final valor in linha)
          if (valor is double) valor.toString().replaceAll('.', ',') else valor,
      ]),
    );
    buffer.write('\r\n');
  }
  return utf8.encode(buffer.toString());
}

List<int> _brutoXlsxBytes(DadosExportacao conjuntoDados) {
  final planilha = excel.Excel.createExcel();
  for (
    var talhaoIndex = 0;
    talhaoIndex < conjuntoDados.talhoes.length;
    talhaoIndex++
  ) {
    final talhao = conjuntoDados.talhoes[talhaoIndex];
    final painelNome = 'Talhão ${talhaoIndex + 1}';
    final painel = planilha[painelNome];
    if (talhaoIndex == 0) planilha.setDefaultSheet(painelNome);
    painel.appendRow(
      _excelLinha(['Propriedade', conjuntoDados.propriedade.nome]),
    );
    painel.appendRow(
      _excelLinha(['Talhão', talhao.opcao.talhao.identificacao]),
    );
    painel.appendRow(
      _excelLinha([
        'Levantamento',
        talhao.opcao.talhaoLevantamento.levantamentoId,
      ]),
    );
    painel.appendRow(
      _excelLinha(['Colunas de cada parcela: Árvore | DAP (cm) | Altura (m)']),
    );
    for (
      var parcelaIndex = 0;
      parcelaIndex < talhao.parcelas.length;
      parcelaIndex++
    ) {
      final parcela = talhao.parcelas[parcelaIndex];
      final coluna = parcelaIndex * 4;
      final titulo = painel.cell(
        excel.CellIndex.indexByColumnRow(columnIndex: coluna, rowIndex: 5),
      );
      titulo.value = excel.TextCellValue(parcela.parcela.identificacao);
      titulo.cellStyle = excel.CellStyle(bold: true);
      for (
        var arvoreIndex = 0;
        arvoreIndex < parcela.arvores.length;
        arvoreIndex++
      ) {
        final arvore = parcela.arvores[arvoreIndex];
        final values = _excelLinha([
          arvore.numero,
          arvore.dapCm,
          arvore.alturaM,
        ]);
        for (
          var deslocamento = 0;
          deslocamento < values.length;
          deslocamento++
        ) {
          painel
                  .cell(
                    excel.CellIndex.indexByColumnRow(
                      columnIndex: coluna + deslocamento,
                      rowIndex: 6 + arvoreIndex,
                    ),
                  )
                  .value =
              values[deslocamento];
        }
      }
    }
  }
  planilha.delete('Sheet1');
  return planilha.encode()!;
}

List<int> _csvBytes(DadosExportacao conjuntoDados) {
  final referenciaData =
      conjuntoDados.levantamento?.iniciadoEm ?? DateTime.now();
  final buffer = StringBuffer()
    ..writeln(
      _csvLinha([
        'Propriedade',
        'Município',
        'UF',
        'Levantamento',
        'Status levantamento',
        'Talhão',
        'Espécie',
        'Área talhão (ha)',
        'Ano plantio',
        'Idade',
        'Espaçamento',
        'Regime manejo',
        'Largura parcela (m)',
        'Comprimento parcela (m)',
        'Área padrão parcela (ha)',
        'Modelo',
        'Parcela',
        'Status parcela',
        'Área parcela (ha)',
        'Árvore',
        'DAP (cm)',
        'Altura (m)',
        'Volume árvore (m³)',
        'Volume/ha talhão (m³/ha)',
        'Volume estimado talhão (m³)',
        'Equivalente talhão',
        'Unidade equivalente',
        'Tronco torto',
        'Ponto de referência da parcela',
        'Latitude do ponto',
        'Longitude do ponto',
        'Precisão GPS (m)',
        'Data da captura GPS',
      ]),
    );

  for (final talhao in conjuntoDados.talhoes) {
    for (final parcela in talhao.parcelas) {
      if (parcela.arvores.isEmpty) {
        buffer.writeln(
          _csvLinha([
            conjuntoDados.propriedade.nome,
            conjuntoDados.propriedade.municipio,
            conjuntoDados.propriedade.estado,
            conjuntoDados.levantamento == null
                ? ''
                : _dataHora(conjuntoDados.levantamento!.iniciadoEm),
            conjuntoDados.levantamento == null
                ? ''
                : _levantamentoSituacaoRotulo(
                    conjuntoDados.levantamento!.situacao,
                  ),
            talhao.opcao.talhao.identificacao,
            talhao.opcao.especie.nome,
            _decimal(talhao.opcao.talhao.areaHa),
            talhao.opcao.talhao.anoPlantio?.toString() ?? '',
            _talhaoIdade(talhao, referenciaData)?.toString() ?? '',
            talhao.opcao.talhao.espacamento ?? '',
            talhao.opcao.talhao.regimeManejo ?? '',
            _opcionalDecimal(talhao.opcao.talhao.larguraParcelaM),
            _opcionalDecimal(talhao.opcao.talhao.comprimentoParcelaM),
            _opcionalDecimal(_talhaoPadraoParcelaAreaHa(talhao)),
            talhao.modeloMatematico?.nome ?? '',
            parcela.parcela.identificacao,
            _parcelaSituacaoRotulo(parcela.parcela.situacao),
            _opcionalDecimal(parcela.parcela.areaHa),
            ...List.filled(14, ''),
          ]),
        );
        continue;
      }

      for (final arvore in parcela.arvores) {
        buffer.writeln(
          _csvLinha([
            conjuntoDados.propriedade.nome,
            conjuntoDados.propriedade.municipio,
            conjuntoDados.propriedade.estado,
            conjuntoDados.levantamento == null
                ? ''
                : _dataHora(conjuntoDados.levantamento!.iniciadoEm),
            conjuntoDados.levantamento == null
                ? ''
                : _levantamentoSituacaoRotulo(
                    conjuntoDados.levantamento!.situacao,
                  ),
            talhao.opcao.talhao.identificacao,
            talhao.opcao.especie.nome,
            _decimal(talhao.opcao.talhao.areaHa),
            talhao.opcao.talhao.anoPlantio?.toString() ?? '',
            _talhaoIdade(talhao, referenciaData)?.toString() ?? '',
            talhao.opcao.talhao.espacamento ?? '',
            talhao.opcao.talhao.regimeManejo ?? '',
            _opcionalDecimal(talhao.opcao.talhao.larguraParcelaM),
            _opcionalDecimal(talhao.opcao.talhao.comprimentoParcelaM),
            _opcionalDecimal(_talhaoPadraoParcelaAreaHa(talhao)),
            talhao.modeloMatematico?.nome ?? '',
            parcela.parcela.identificacao,
            _parcelaSituacaoRotulo(parcela.parcela.situacao),
            _opcionalDecimal(parcela.parcela.areaHa),
            'Árvore ${arvore.numero}',
            _decimal(arvore.dapCm),
            _decimal(arvore.alturaM),
            _decimalPrecisao(talhao.volumeArvoreM3(arvore), fracaoDigitos: 5),
            _opcionalDecimal(talhao.volumePorHaM3),
            _opcionalDecimal(talhao.estimadoVolumeM3),
            _opcionalDecimal(talhao.convertidoEstimadoVolume),
            talhao.conversao.unidade,
            arvore.possuiTroncoTortuoso ? 'Sim' : 'Não',
            _referenciaRotulo(arvore.posicaoReferenciaParcela),
            _coordenadaOpcional(arvore.latitude),
            _coordenadaOpcional(arvore.longitude),
            _opcionalDecimal(arvore.precisaoMetros),
            arvore.localizacaoCapturadaEm == null
                ? ''
                : _dataHora(arvore.localizacaoCapturadaEm!),
          ]),
        );
      }
    }
  }

  return utf8.encode('\uFEFF${buffer.toString()}');
}

List<int> _xlsxBytes(DadosExportacao conjuntoDados) {
  final referenciaData =
      conjuntoDados.levantamento?.iniciadoEm ?? DateTime.now();
  final planilha = excel.Excel.createExcel();
  final resumo = planilha['Resumo'];
  final arvores = planilha['Árvores'];
  final coordenadas = planilha['Coordenadas'];

  if (planilha.sheets.containsKey('Sheet1')) {
    planilha.delete('Sheet1');
  }

  resumo
    ..appendRow(_excelLinha(['DENDRO Mobile - Relatório de Inventário']))
    ..appendRow(_excelLinha([]))
    ..appendRow(_excelLinha(['Propriedade', conjuntoDados.propriedade.nome]))
    ..appendRow(
      _excelLinha([
        'Município',
        '${conjuntoDados.propriedade.municipio}-${conjuntoDados.propriedade.estado}',
      ]),
    )
    ..appendRow(
      _excelLinha([
        'Área cadastrada (ha)',
        conjuntoDados.propriedade.areaTotalHa,
      ]),
    )
    ..appendRow(_excelLinha(['Gerado em', _dataHora(DateTime.now())]))
    ..appendRow(_excelLinha([]))
    ..appendRow(
      _excelLinha([
        'Talhão',
        'Espécie',
        'Área talhão (ha)',
        'Ano plantio',
        'Idade',
        'Espaçamento',
        'Regime manejo',
        'Largura parcela (m)',
        'Comprimento parcela (m)',
        'Área padrão parcela (ha)',
        'Modelo',
        'Coeficientes',
        'Parcelas',
        'Parcelas coletadas',
        'Árvores',
        'Área medida (ha)',
        'Árvores/ha',
        'Volume amostrado (m³)',
        'Volume/ha (m³/ha)',
        'Volume estimado (m³)',
        'Equivalente',
        'Unidade equivalente',
        'DAP médio (cm)',
        'Altura média (m)',
      ]),
    );

  for (final talhao in conjuntoDados.talhoes) {
    resumo.appendRow(
      _excelLinha([
        talhao.opcao.talhao.identificacao,
        talhao.opcao.especie.nome,
        talhao.opcao.talhao.areaHa,
        talhao.opcao.talhao.anoPlantio,
        _talhaoIdade(talhao, referenciaData),
        talhao.opcao.talhao.espacamento ?? '',
        talhao.opcao.talhao.regimeManejo ?? '',
        talhao.opcao.talhao.larguraParcelaM,
        talhao.opcao.talhao.comprimentoParcelaM,
        _talhaoPadraoParcelaAreaHa(talhao),
        talhao.modeloMatematico?.nome ?? '',
        talhao.coeficientes
            .map((coeficiente) {
              return '${coeficiente.simbolo}=${_opcionalCoeficiente(coeficiente.valor)}';
            })
            .join(' | '),
        talhao.opcao.parcelaQuantidade,
        talhao.opcao.coletadaParcelaQuantidade,
        talhao.arvoreQuantidade,
        talhao.medidaAreaHa,
        talhao.arvoresPorHa,
        talhao.amostraVolumeM3,
        talhao.volumePorHaM3,
        talhao.estimadoVolumeM3,
        talhao.convertidoEstimadoVolume,
        talhao.conversao.unidade,
        talhao.mediaDapCm,
        talhao.mediaAlturaM,
      ]),
    );
  }

  arvores.appendRow(
    _excelLinha([
      'Propriedade',
      'Talhão',
      'Espécie',
      'Ano plantio',
      'Idade',
      'Espaçamento',
      'Regime manejo',
      'Largura parcela (m)',
      'Comprimento parcela (m)',
      'Área padrão parcela (ha)',
      'Parcela',
      'Status parcela',
      'Árvore',
      'DAP (cm)',
      'Altura (m)',
      'Volume (m³)',
      'Tronco torto',
    ]),
  );

  coordenadas.appendRow(
    _excelLinha([
      'Propriedade',
      'Talhão',
      'Parcela',
      'Ponto de referência da parcela',
      'Latitude do ponto',
      'Longitude do ponto',
      'Precisão GPS (m)',
      'Data da captura GPS',
    ]),
  );

  for (final talhao in conjuntoDados.talhoes) {
    for (final parcela in talhao.parcelas) {
      for (final arvore in parcela.arvores) {
        arvores.appendRow(
          _excelLinha([
            conjuntoDados.propriedade.nome,
            talhao.opcao.talhao.identificacao,
            talhao.opcao.especie.nome,
            talhao.opcao.talhao.anoPlantio,
            _talhaoIdade(talhao, referenciaData),
            talhao.opcao.talhao.espacamento ?? '',
            talhao.opcao.talhao.regimeManejo ?? '',
            talhao.opcao.talhao.larguraParcelaM,
            talhao.opcao.talhao.comprimentoParcelaM,
            _talhaoPadraoParcelaAreaHa(talhao),
            parcela.parcela.identificacao,
            _parcelaSituacaoRotulo(parcela.parcela.situacao),
            arvore.numero,
            arvore.dapCm,
            arvore.alturaM,
            talhao.volumeArvoreM3(arvore),
            arvore.possuiTroncoTortuoso ? 'Sim' : 'Não',
          ]),
        );

        if (arvore.latitude != null && arvore.longitude != null) {
          coordenadas.appendRow(
            _excelLinha([
              conjuntoDados.propriedade.nome,
              talhao.opcao.talhao.identificacao,
              parcela.parcela.identificacao,
              _referenciaRotulo(arvore.posicaoReferenciaParcela),
              arvore.latitude,
              arvore.longitude,
              arvore.precisaoMetros,
              arvore.localizacaoCapturadaEm == null
                  ? ''
                  : _dataHora(arvore.localizacaoCapturadaEm!),
            ]),
          );
        }
      }
    }
  }

  final bytes = planilha.save();
  if (bytes == null) {
    throw StateError('Não foi possível gerar a planilha.');
  }
  return bytes;
}

List<int> _kmlBytes(DadosExportacao conjuntoDados) {
  final buffer = StringBuffer()
    ..writeln('<?xml version="1.0" encoding="UTF-8"?>')
    ..writeln('<kml xmlns="http://www.opengis.net/kml/2.2">')
    ..writeln('<Document>')
    ..writeln(
      '<name>${_xml('DENDRO - ${conjuntoDados.propriedade.nome}')}</name>',
    )
    ..writeln('''
<Style id="plotPoint">
  <IconStyle><color>ff6ac46a</color><scale>1.1</scale></IconStyle>
</Style>
<Style id="treePoint">
  <IconStyle><color>ff1b5e20</color><scale>0.9</scale></IconStyle>
</Style>
<Style id="plotPolygon">
  <LineStyle><color>ff0b4d2a</color><width>2</width></LineStyle>
  <PolyStyle><color>336ac46a</color></PolyStyle>
</Style>
''');

  var possuiCoordinates = false;
  for (final talhao in conjuntoDados.talhoes) {
    for (final parcela in talhao.parcelas) {
      final orderedPontos = parcela.pontosReferencia;

      if (orderedPontos.length >= 3) {
        possuiCoordinates = true;
        final coordenadas = [
          for (final ponto in orderedPontos) _coordenadaKml(ponto),
          _coordenadaKml(orderedPontos.first),
        ].join(' ');
        buffer.writeln('''
<Placemark>
  <name>${_xml('${talhao.opcao.talhao.identificacao} - ${parcela.parcela.identificacao}')}</name>
  <styleUrl>#plotPolygon</styleUrl>
  <description>${_xml('Parcela com ${parcela.arvores.length} árvores medidas')}</description>
  <Polygon>
    <outerBoundaryIs>
      <LinearRing>
        <coordinates>$coordenadas</coordinates>
      </LinearRing>
    </outerBoundaryIs>
  </Polygon>
</Placemark>
''');
      }

      for (final ponto in orderedPontos) {
        possuiCoordinates = true;
        final pontoRotulo = _referenciaRotulo(ponto.posicaoReferenciaParcela);
        buffer.writeln('''
<Placemark>
  <name>${_xml('${talhao.opcao.talhao.identificacao} - ${parcela.parcela.identificacao} - $pontoRotulo')}</name>
  <styleUrl>#plotPoint</styleUrl>
  <description>${_xml('Ponto de referência da parcela')}</description>
  <Point><coordinates>${_coordenadaKml(ponto)}</coordinates></Point>
</Placemark>
''');
      }

      for (final arvore in parcela.arvores) {
        if (arvore.latitude == null || arvore.longitude == null) continue;
        possuiCoordinates = true;
        buffer.writeln('''
<Placemark>
  <name>${_xml('${talhao.opcao.talhao.identificacao} - ${parcela.parcela.identificacao} - Árvore ${arvore.numero}')}</name>
  <styleUrl>#treePoint</styleUrl>
  <description>${_xml('DAP ${_decimal(arvore.dapCm)} cm | Altura ${_decimal(arvore.alturaM)} m | Volume ${_decimalPrecisao(talhao.volumeArvoreM3(arvore), fracaoDigitos: 5)} m³ | ${arvore.possuiTroncoTortuoso ? 'Tronco torto' : 'Tronco normal'}')}</description>
  <Point><coordinates>${_valorCoordenada(arvore.longitude!)},${_valorCoordenada(arvore.latitude!)},0</coordinates></Point>
</Placemark>
''');
      }
    }
  }

  if (!possuiCoordinates) {
    buffer.writeln(
      '<description>${_xml('Nenhuma coordenada GPS foi registrada para os talhões selecionados.')}</description>',
    );
  }

  buffer
    ..writeln('</Document>')
    ..writeln('</kml>');

  return utf8.encode(buffer.toString());
}

pw.Widget _pdfCabecalho(DadosExportacao conjuntoDados, DateTime geradoEm) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(14),
    decoration: pw.BoxDecoration(
      color: PdfColors.green900,
      borderRadius: pw.BorderRadius.circular(4),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'DENDRO Mobile',
          style: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          'Relatório de Inventário Florestal',
          style: pw.TextStyle(
            color: PdfColors.green100,
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          '${conjuntoDados.propriedade.nome} - ${conjuntoDados.propriedade.municipio}/${conjuntoDados.propriedade.estado}',
          style: const pw.TextStyle(color: PdfColors.white, fontSize: 10),
        ),
        pw.Text(
          'Emitido em ${_dataHora(geradoEm)}',
          style: const pw.TextStyle(color: PdfColors.green100, fontSize: 9),
        ),
      ],
    ),
  );
}

String _objetivoTexto(DadosExportacao conjuntoDados, DateTime referenciaData) {
  final especies = _especieFrase(conjuntoDados);
  final idade = _idadeFrase(conjuntoDados, referenciaData);
  return 'O objetivo deste levantamento é apresentar uma análise quantitativa e qualitativa da floresta de $especies$idade, localizada na propriedade ${conjuntoDados.propriedade.nome}, município de ${conjuntoDados.propriedade.municipio}/${conjuntoDados.propriedade.estado}, com área total cadastrada de ${_decimal(conjuntoDados.propriedade.areaTotalHa)} hectares. O relatório consolida os dados coletados nas parcelas selecionadas e estima o volume de madeira para a área inventariada.';
}

String _metodologiaTexto(DadosExportacao conjuntoDados) {
  final parcelaDimensaoTexto = _parcelaDimensaoFrase(conjuntoDados);
  final parcelaArea = _mediaParcelaAreaHa(conjuntoDados);
  final parcelaAreaTexto =
      parcelaDimensaoTexto ??
      (parcelaArea == null
          ? 'área fixa informada durante a coleta'
          : 'área média de ${_decimalPrecisao(parcelaArea, fracaoDigitos: 4)} ha (${_decimal(parcelaArea * 10000)} m²)');
  final espacamentoTexto = _espacamentoFrase(conjuntoDados);

  return 'O levantamento foi realizado pelo método de amostragem sistemática com parcelas de área fixa, preferencialmente retangulares, com $parcelaAreaTexto.$espacamentoTexto Os dados foram registrados em campo pelo aplicativo, permitindo rastreabilidade das parcelas, árvores medidas e coordenadas GPS quando informadas.';
}

pw.Widget _pdfParagrafo(String valor) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Text(
      valor,
      textAlign: pw.TextAlign.justify,
      style: const pw.TextStyle(fontSize: 9, lineSpacing: 2),
    ),
  );
}

pw.Widget _pdfMarcadorLista(List<String> itens) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      for (final item in itens)
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 8, bottom: 3),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('- ', style: const pw.TextStyle(fontSize: 9)),
              pw.Expanded(
                child: pw.Text(
                  item,
                  style: const pw.TextStyle(fontSize: 9, lineSpacing: 2),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

pw.Widget _pdfModeloMatematicoTabela(DadosExportacao conjuntoDados) {
  return pw.TableHelper.fromTextArray(
    border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
    headerDecoration: const pw.BoxDecoration(color: PdfColors.green900),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontSize: 7,
      fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: const pw.TextStyle(fontSize: 6.5),
    cellAlignment: pw.Alignment.centerLeft,
    headers: ['Espécie', 'Modelo', 'Altura', 'Volume', 'Conversão'],
    data: [
      for (final talhao in _combinacoesDistintasDeModelo(conjuntoDados))
        [
          talhao.opcao.especie.nome,
          talhao.modeloMatematico?.nome ?? 'Sem modelo',
          'h = 6,4229 * Ln(DAP) + 0,8203',
          _volumeEquacaoComValores(talhao),
          _conversaoEquacao(talhao),
        ],
    ],
  );
}

pw.Widget _pdfEspecieResultadosTabela(DadosExportacao conjuntoDados) {
  return pw.TableHelper.fromTextArray(
    border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
    headerDecoration: const pw.BoxDecoration(color: PdfColors.green900),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontSize: 8,
      fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: const pw.TextStyle(fontSize: 7.5),
    cellAlignment: pw.Alignment.centerLeft,
    headers: [
      'Espécie',
      'Área (ha)',
      'Talhões',
      'Parcelas',
      'Árvores',
      'Vol./ha',
      'Vol. total',
      'Equiv.',
    ],
    data: [
      for (final resumo in _especieResumos(conjuntoDados))
        [
          resumo.especieNome,
          _decimal(resumo.areaHa),
          resumo.talhaoQuantidade.toString(),
          resumo.parcelaQuantidade.toString(),
          resumo.arvoreQuantidade.toString(),
          _opcionalDecimal(resumo.volumePorHaM3, sufixo: ' m³/ha'),
          _opcionalDecimal(resumo.estimadoVolumeM3, sufixo: ' m³'),
          resumo.convertidoEstimadoVolume == null
              ? ''
              : '${_decimal(resumo.convertidoEstimadoVolume!)} ${resumo.conversao.unidade}',
        ],
    ],
  );
}

pw.Widget _pdfDendrometricTabela(
  DadosExportacao conjuntoDados,
  DateTime referenciaData,
) {
  return pw.TableHelper.fromTextArray(
    border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.4),
    headerDecoration: const pw.BoxDecoration(color: PdfColors.green900),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontSize: 6,
      fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: const pw.TextStyle(fontSize: 5.8),
    cellAlignment: pw.Alignment.centerLeft,
    headers: [
      'Talhão',
      'Espécie',
      'Área',
      'Ano',
      'Idade',
      'N/ha',
      'DAP',
      'H',
      'G',
      'v/arv',
      'V/ha',
      'Vol. ${referenciaData.year}',
    ],
    data: [
      for (final talhao in conjuntoDados.talhoes)
        [
          talhao.opcao.talhao.identificacao,
          talhao.opcao.especie.nome,
          _decimal(talhao.opcao.talhao.areaHa),
          talhao.opcao.talhao.anoPlantio?.toString() ?? '',
          _talhaoIdade(talhao, referenciaData)?.toString() ?? '',
          _opcionalDecimal(talhao.arvoresPorHa),
          _opcionalDecimal(talhao.mediaDapCm, sufixo: ' cm'),
          _opcionalDecimal(talhao.mediaAlturaM, sufixo: ' m'),
          _opcionalDecimal(talhao.basalAreaPorHa, sufixo: ' m²/ha'),
          _opcionalDecimal(talhao.mediaVolumePorArvoreM3, sufixo: ' m³'),
          _opcionalDecimal(talhao.volumePorHaM3, sufixo: ' m³/ha'),
          _opcionalDecimal(talhao.estimadoVolumeM3, sufixo: ' m³'),
        ],
    ],
  );
}

pw.Widget _pdfSecaoTitulo(String valor) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Text(
      valor,
      style: pw.TextStyle(
        color: PdfColors.green900,
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );
}

pw.Widget _pdfInformacaoGrade(List<List<String>> linhas) {
  return pw.TableHelper.fromTextArray(
    border: null,
    cellPadding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 0),
    cellStyle: const pw.TextStyle(fontSize: 9),
    cellAlignment: pw.Alignment.centerLeft,
    columnWidths: {
      0: const pw.FixedColumnWidth(95),
      1: const pw.FlexColumnWidth(),
    },
    data: [
      for (final linha in linhas) [linha[0], linha[1]],
    ],
  );
}

List<excel.CellValue?> _excelLinha(List<Object?> values) {
  return [
    for (final valor in values)
      if (valor == null)
        null
      else if (valor is int)
        excel.IntCellValue(valor)
      else if (valor is double)
        excel.DoubleCellValue(valor)
      else if (valor is bool)
        excel.BoolCellValue(valor)
      else
        excel.TextCellValue(valor.toString()),
  ];
}

String _csvLinha(List<Object?> values) {
  return values.map(_csvValor).join(';');
}

String _csvValor(Object? valor) {
  final texto = valor?.toString() ?? '';
  final deveAspas =
      texto.contains(';') ||
      texto.contains('"') ||
      texto.contains('\n') ||
      texto.contains('\r');
  final escapado = texto.replaceAll('"', '""');
  return deveAspas ? '"$escapado"' : escapado;
}

String _coordenadaKml(Arvore ponto) {
  return '${_valorCoordenada(ponto.longitude!)},${_valorCoordenada(ponto.latitude!)},0';
}

String _xml(String valor) {
  return valor
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');
}

String _nomeArquivo(Propriedade propriedade, FormatoExportacaoDados formato) {
  final geradoEm = DateTime.now();
  final nome = _sanitizarParteNomeArquivo(propriedade.nome);
  final tipo =
      formato == FormatoExportacaoDados.brutoCsv ||
          formato == FormatoExportacaoDados.brutoXlsx
      ? 'dados_brutos_'
      : '';
  return 'dendro_$tipo${nome}_${_arquivoMarcaTempo(geradoEm)}.${formato.extensao}';
}

String _sanitizarParteNomeArquivo(String valor) {
  final normalizado = valor
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  return normalizado.isEmpty ? 'relatorio' : normalizado;
}

String _arquivoMarcaTempo(DateTime valor) {
  final ano = valor.year.toString();
  final mes = valor.month.toString().padLeft(2, '0');
  final dia = valor.day.toString().padLeft(2, '0');
  final hora = valor.hour.toString().padLeft(2, '0');
  final minuto = valor.minute.toString().padLeft(2, '0');
  return '$ano$mes${dia}_$hora$minuto';
}

String _dataHora(DateTime valor) {
  final dia = valor.day.toString().padLeft(2, '0');
  final mes = valor.month.toString().padLeft(2, '0');
  final ano = valor.year.toString();
  final hora = valor.hour.toString().padLeft(2, '0');
  final minuto = valor.minute.toString().padLeft(2, '0');
  return '$dia/$mes/$ano $hora:$minuto';
}

String _decimal(double valor) {
  return _decimalPrecisao(valor);
}

String _decimalPrecisao(double valor, {int fracaoDigitos = 2}) {
  return valor.toStringAsFixed(fracaoDigitos).replaceAll('.', ',');
}

String _decimalCompacto(double valor) {
  if (valor == valor.roundToDouble()) return valor.toStringAsFixed(0);
  return _decimalPrecisao(valor);
}

String _opcionalDecimal(double? valor, {String sufixo = ''}) {
  if (valor == null) return '';
  return '${_decimal(valor)}$sufixo';
}

String _valorCoordenada(double valor) {
  return valor.toStringAsFixed(8);
}

String _coordenadaOpcional(double? valor) {
  if (valor == null) return '';
  return _valorCoordenada(valor);
}

double? _mediaDap(List<Arvore> arvores) {
  if (arvores.isEmpty) return null;
  return arvores.fold<double>(0, (total, arvore) => total + arvore.dapCm) /
      arvores.length;
}

double? _mediaAltura(List<Arvore> arvores) {
  if (arvores.isEmpty) return null;
  return arvores.fold<double>(0, (total, arvore) => total + arvore.alturaM) /
      arvores.length;
}

double? _parcelaVolumeM3(
  DadosTalhaoExportacao talhao,
  DadosParcelaExportacao parcela,
) {
  if (parcela.arvores.isEmpty) return null;
  return parcela.arvores.fold<double>(
    0,
    (total, arvore) => total + talhao.volumeArvoreM3(arvore),
  );
}

List<DadosTalhaoExportacao> _combinacoesDistintasDeModelo(
  DadosExportacao conjuntoDados,
) {
  final porChave = <String, DadosTalhaoExportacao>{};
  for (final talhao in conjuntoDados.talhoes) {
    final key = [
      talhao.opcao.especie.id,
      talhao.modeloMatematico?.id ?? '',
      _coeficienteLista(talhao),
    ].join('|');
    porChave.putIfAbsent(key, () => talhao);
  }
  return porChave.values.toList()
    ..sort((a, b) => a.opcao.especie.nome.compareTo(b.opcao.especie.nome));
}

List<_EspecieExportacaoResumo> _especieResumos(DadosExportacao conjuntoDados) {
  final porEspecie = <int, List<DadosTalhaoExportacao>>{};
  for (final talhao in conjuntoDados.talhoes) {
    porEspecie.putIfAbsent(talhao.opcao.especie.id, () => []).add(talhao);
  }

  final resumos = [
    for (final talhoes in porEspecie.values) _EspecieExportacaoResumo(talhoes),
  ]..sort((a, b) => a.especieNome.compareTo(b.especieNome));

  return resumos;
}

class _EspecieExportacaoResumo {
  _EspecieExportacaoResumo(this.talhoes);

  final List<DadosTalhaoExportacao> talhoes;

  String get especieNome => talhoes.first.opcao.especie.nome;

  ConversaoVolumeMadeira get conversao => talhoes.first.conversao;

  int get talhaoQuantidade => talhoes.length;

  int get parcelaQuantidade =>
      talhoes.fold(0, (total, talhao) => total + talhao.parcelas.length);

  int get arvoreQuantidade =>
      talhoes.fold(0, (total, talhao) => total + talhao.arvoreQuantidade);

  double get areaHa =>
      talhoes.fold(0, (total, talhao) => total + talhao.opcao.talhao.areaHa);

  double get medidaAreaHa =>
      talhoes.fold(0, (total, talhao) => total + talhao.medidaAreaHa);

  double get amostraVolumeM3 =>
      talhoes.fold(0, (total, talhao) => total + talhao.amostraVolumeM3);

  double? get volumePorHaM3 =>
      areaHa == 0 ? null : (estimadoVolumeM3 ?? 0) / areaHa;

  double? get estimadoVolumeM3 {
    if (talhoes.every((talhao) => talhao.estimadoVolumeM3 == null)) return null;
    return talhoes.fold<double>(
      0,
      (total, talhao) => total + (talhao.estimadoVolumeM3 ?? 0),
    );
  }

  double? get convertidoEstimadoVolume =>
      estimadoVolumeM3 == null ? null : conversao.converter(estimadoVolumeM3!);
}

String _especieFrase(DadosExportacao conjuntoDados) {
  final nomes = _especieResumos(conjuntoDados).map((item) => item.especieNome);
  return _juntarListaLegivel(nomes.toList());
}

String _idadeFrase(DadosExportacao conjuntoDados, DateTime referenciaData) {
  final idades = <int>{};
  for (final talhao in conjuntoDados.talhoes) {
    final idade = _talhaoIdade(talhao, referenciaData);
    if (idade != null) idades.add(idade);
  }
  if (idades.isEmpty) return '';
  final ordenado = idades.toList()..sort();
  if (ordenado.length == 1) return ', com ${ordenado.single} anos de idade';
  return ', com idades entre ${ordenado.first} e ${ordenado.last} anos';
}

String _espacamentoFrase(DadosExportacao conjuntoDados) {
  final espacamentos =
      conjuntoDados.talhoes
          .map((talhao) => talhao.opcao.talhao.espacamento?.trim())
          .whereType<String>()
          .where((valor) => valor.isNotEmpty)
          .toSet()
          .toList()
        ..sort();
  if (espacamentos.isEmpty) return '';
  return ' O espaçamento original do plantio informado foi ${_juntarListaLegivel(espacamentos)}.';
}

double? _mediaParcelaAreaHa(DadosExportacao conjuntoDados) {
  final areas = [
    for (final talhao in conjuntoDados.talhoes)
      for (final parcela in talhao.parcelas)
        if (parcela.parcela.situacao != SituacaoParcela.pendente &&
            parcela.parcela.areaHa != null)
          parcela.parcela.areaHa!,
  ];
  if (areas.isEmpty) return null;
  return areas.fold<double>(0, (total, area) => total + area) / areas.length;
}

String? _parcelaDimensaoFrase(DadosExportacao conjuntoDados) {
  final dimensoes =
      conjuntoDados.talhoes
          .map(_talhaoParcelaDimensaoRotulo)
          .whereType<String>()
          .toSet()
          .toList()
        ..sort();
  if (dimensoes.isEmpty) return null;
  if (dimensoes.length == 1) {
    return 'parcelas retangulares de ${dimensoes.single} metros';
  }
  return 'parcelas retangulares com dimensões de ${_juntarListaLegivel(dimensoes)} metros';
}

String? _talhaoParcelaDimensaoRotulo(DadosTalhaoExportacao talhao) {
  final largura = talhao.opcao.talhao.larguraParcelaM;
  final comprimento = talhao.opcao.talhao.comprimentoParcelaM;
  if (largura == null ||
      comprimento == null ||
      largura <= 0 ||
      comprimento <= 0) {
    return null;
  }
  return '${_decimalCompacto(largura)} x ${_decimalCompacto(comprimento)}';
}

double? _talhaoPadraoParcelaAreaHa(DadosTalhaoExportacao talhao) {
  final largura = talhao.opcao.talhao.larguraParcelaM;
  final comprimento = talhao.opcao.talhao.comprimentoParcelaM;
  if (largura == null ||
      comprimento == null ||
      largura <= 0 ||
      comprimento <= 0) {
    return null;
  }
  return largura * comprimento / 10000;
}

String _juntarListaLegivel(List<String> values) {
  if (values.isEmpty) return '';
  if (values.length == 1) return values.single;
  if (values.length == 2) return '${values.first} e ${values.last}';
  return '${values.take(values.length - 1).join(', ')} e ${values.last}';
}

int? _talhaoIdade(DadosTalhaoExportacao talhao, DateTime referenciaData) {
  final anoPlantio = talhao.opcao.talhao.anoPlantio;
  if (anoPlantio == null || anoPlantio <= 0) return null;
  final idade = referenciaData.year - anoPlantio;
  return idade < 0 ? null : idade;
}

String _volumeEquacaoComValores(DadosTalhaoExportacao talhao) {
  final expressao = (talhao.modeloMatematico?.expressao ?? '').toLowerCase();
  if (expressao.contains('exp(') ||
      (talhao.modeloMatematico?.codigo ?? '').contains('schumacher')) {
    return 'v = exp(${_coeficienteValor(talhao, 'a')} + ${_coeficienteValor(talhao, 'b')} * Ln(DAP) + ${_coeficienteValor(talhao, 'c')} * Ln(h))';
  }

  return 'v = ${_coeficienteValor(talhao, 'a')} + ${_coeficienteValor(talhao, 'b')} * DAP² * h';
}

String _conversaoEquacao(DadosTalhaoExportacao talhao) {
  if (talhao.conversao.unidade == 'ton') {
    return '1 m³ = ${_decimalPrecisao(talhao.conversao.fator, fracaoDigitos: 4)} ton';
  }
  if (talhao.conversao.unidade == 'mst') {
    return '1 m³ = ${_decimalPrecisao(talhao.conversao.fator, fracaoDigitos: 1)} mst';
  }
  return 'Sem conversão adicional';
}

String _coeficienteValor(DadosTalhaoExportacao talhao, String simbolo) {
  final valor = talhao.coeficienteValoresPorSimbolo[simbolo];
  if (valor == null) return simbolo;
  return _coeficienteNumero(valor);
}

String _coeficienteLista(DadosTalhaoExportacao talhao) {
  if (talhao.coeficientes.isEmpty) return 'não informados';
  return talhao.coeficientes
      .map((item) => '${item.simbolo}=${_opcionalCoeficiente(item.valor)}')
      .join(' | ');
}

String _opcionalCoeficiente(double? valor) {
  if (valor == null) return '';
  return _coeficienteNumero(valor);
}

String _coeficienteNumero(double valor) =>
    valor.toString().replaceAll('.', ',');

List<String> _observacoesTecnicas(DadosExportacao conjuntoDados) {
  final observacoes = <String>[
    'Os volumes foram calculados com os modelos e coeficientes vinculados ao talhão no momento do levantamento.',
    'A extrapolação para hectare e talhão considera o volume médio por unidade de área amostrada e a área cadastrada de cada talhão.',
  ];

  if (conjuntoDados.talhoes.any(
    (talhao) => talhao.opcao.talhao.anoPlantio == null,
  )) {
    observacoes.add(
      'Há talhões sem ano de plantio informado; nesses casos, idade e IMA não são apresentados.',
    );
  }
  if (conjuntoDados.talhoes.any(
    (talhao) => talhao.parcelas.any(
      (parcela) =>
          parcela.parcela.situacao != SituacaoParcela.pendente &&
          parcela.parcela.areaHa == null,
    ),
  )) {
    observacoes.add(
      'Há parcelas coletadas sem área informada; elas permanecem no relatório, mas não contribuem para extrapolação por hectare.',
    );
  }
  if (conjuntoDados.talhoes.any(
    (talhao) => _talhaoParcelaDimensaoRotulo(talhao) == null,
  )) {
    observacoes.add(
      'Há talhões sem largura e comprimento padrão da parcela; nesses casos, o relatório usa a área cadastrada nas parcelas coletadas.',
    );
  }
  return observacoes;
}

String _levantamentoSituacaoRotulo(SituacaoLevantamento situacao) {
  return switch (situacao) {
    SituacaoLevantamento.planejamento => 'Planejamento',
    SituacaoLevantamento.emAndamento => 'Em andamento',
    SituacaoLevantamento.concluido => 'Finalizado',
  };
}

String _parcelaSituacaoRotulo(SituacaoParcela situacao) {
  return switch (situacao) {
    SituacaoParcela.pendente => 'Pendente',
    SituacaoParcela.emAndamento => 'Em coleta',
    SituacaoParcela.coletada => 'Coletada',
  };
}

String _referenciaRotulo(PosicaoReferenciaParcela? posicao) {
  return switch (posicao) {
    PosicaoReferenciaParcela.p1 => 'P1',
    PosicaoReferenciaParcela.p2 => 'P2',
    PosicaoReferenciaParcela.p3 => 'P3',
    PosicaoReferenciaParcela.p4 => 'P4',
    null => '',
  };
}
