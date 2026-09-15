import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../nucleo/banco/banco_dendro.dart';
import '../../../nucleo/floresta/calculadora_volume_florestal.dart';
import '../../../nucleo/provedores/provedores_banco.dart';
import '../../atividades/dados/repositorio_atividades.dart';
import 'selecao_modelo_levantamento.dart';

final provedorRepositorioLevantamentos = Provider<RepositorioLevantamentos>((
  ref,
) {
  return RepositorioLevantamentos(ref.watch(provedorBancoDendro));
});

final provedorLevantamentoAtivo =
    StreamProvider.autoDispose<LevantamentoResumo?>((ref) {
      return ref
          .watch(provedorRepositorioLevantamentos)
          .observarLevantamentoAtivoMaisRecente();
    });

final provedorLevantamentosAtivos =
    StreamProvider.autoDispose<List<LevantamentoResumo>>((ref) {
      return ref
          .watch(provedorRepositorioLevantamentos)
          .observarLevantamentosAtivos();
    });

final provedorLevantamentos =
    StreamProvider.autoDispose<List<LevantamentoResumo>>((ref) {
      return ref.watch(provedorRepositorioLevantamentos).observarTodos();
    });

final provedorLevantamentoDetalhe = StreamProvider.autoDispose
    .family<LevantamentoResumo?, int>((ref, levantamentoId) {
      return ref
          .watch(provedorRepositorioLevantamentos)
          .observarPorId(levantamentoId);
    });

class LevantamentoResumo {
  const LevantamentoResumo({
    required this.levantamento,
    required this.propriedade,
    required this.talhoes,
  });

  final Levantamento levantamento;
  final Propriedade propriedade;
  final List<LevantamentoTalhaoResumo> talhoes;

  int get arvoreQuantidade =>
      talhoes.fold(0, (total, talhao) => total + talhao.arvoreQuantidade);

  int get parcelaQuantidade =>
      talhoes.fold(0, (total, talhao) => total + talhao.parcelaQuantidade);

  int get coletadaParcelaQuantidade => talhoes.fold(
    0,
    (total, talhao) => total + talhao.coletadaParcelaQuantidade,
  );

  int get abrirParcelaQuantidade =>
      parcelaQuantidade - coletadaParcelaQuantidade;

  double get medidaAreaHa =>
      talhoes.fold(0, (total, talhao) => total + talhao.medidaAreaHa);

  String get talhaoRotulo {
    if (talhoes.isEmpty) return 'Sem talhão vinculado';
    if (talhoes.length == 1) return talhoes.single.talhao.identificacao;
    return '${talhoes.length} talhões';
  }
}

class LevantamentoTalhaoResumo {
  const LevantamentoTalhaoResumo({
    required this.talhaoLevantamento,
    required this.talhao,
    required this.especie,
    required this.modeloMatematico,
    required this.coeficientesModelo,
    required this.parcelaQuantidade,
    required this.coletadaParcelaQuantidade,
    required this.arvoreQuantidade,
    required this.medidaAreaHa,
  });

  final TalhaoLevantamento talhaoLevantamento;
  final Talhao talhao;
  final Especie especie;
  final ModeloMatematico modeloMatematico;
  final List<ValorCoeficienteModeloLevantamento> coeficientesModelo;
  final int parcelaQuantidade;
  final int coletadaParcelaQuantidade;
  final int arvoreQuantidade;
  final double medidaAreaHa;
}

class RepositorioLevantamentos {
  RepositorioLevantamentos(this._bancoDados);

  final BancoDendro _bancoDados;
  late final RepositorioAtividades _registroAtividade = RepositorioAtividades(
    _bancoDados,
  );

  Stream<LevantamentoResumo?> observarLevantamentoAtivoMaisRecente() {
    return observarLevantamentosAtivos().map(
      (levantamentos) => levantamentos.firstOrNull,
    );
  }

  Stream<List<LevantamentoResumo>> observarLevantamentosAtivos() {
    final consulta = _bancoDados.select(_bancoDados.levantamentos)
      ..where(
        (tabela) =>
            tabela.situacao.equalsValue(SituacaoLevantamento.emAndamento),
      )
      ..orderBy([(tabela) => OrderingTerm.desc(tabela.atualizadoEm)]);

    return consulta.watch().asyncMap((levantamentos) async {
      if (await _normalizarLevantamentosAtivosPorPropriedade()) {
        levantamentos = await consulta.get();
      }

      final resumos = <LevantamentoResumo>[];
      for (final levantamento in levantamentos) {
        resumos.add(await _resumoParaLevantamento(levantamento));
      }
      return resumos;
    });
  }

  Stream<List<LevantamentoResumo>> observarTodos() {
    final consulta = _bancoDados.select(_bancoDados.levantamentos)
      ..orderBy([(tabela) => OrderingTerm.desc(tabela.atualizadoEm)]);

    return consulta.watch().asyncMap((levantamentos) async {
      if (await _normalizarLevantamentosAtivosPorPropriedade()) {
        levantamentos = await consulta.get();
      }

      final resumos = <LevantamentoResumo>[];
      for (final levantamento in levantamentos) {
        resumos.add(await _resumoParaLevantamento(levantamento));
      }

      resumos.sort((a, b) {
        final situacaoComparacao = _prioridadeSituacao(
          a.levantamento.situacao,
        ).compareTo(_prioridadeSituacao(b.levantamento.situacao));
        if (situacaoComparacao != 0) return situacaoComparacao;
        return b.levantamento.atualizadoEm.compareTo(
          a.levantamento.atualizadoEm,
        );
      });

      return resumos;
    });
  }

  Stream<LevantamentoResumo?> observarPorId(int levantamentoId) {
    final consulta = _bancoDados.select(_bancoDados.levantamentos)
      ..where((tabela) => tabela.id.equals(levantamentoId))
      ..limit(1);

    return consulta.watch().asyncMap((levantamentos) async {
      if (levantamentos.isEmpty) return null;
      return _resumoParaLevantamento(levantamentos.single);
    });
  }

  Future<void> concluirLevantamento(int levantamentoId) async {
    final agora = DateTime.now();
    final resumo = await _resumoPorId(levantamentoId);

    await _bancoDados.transaction(() async {
      await (_bancoDados.update(
        _bancoDados.levantamentos,
      )..where((tabela) => tabela.id.equals(levantamentoId))).write(
        LevantamentosCompanion(
          situacao: const Value(SituacaoLevantamento.concluido),
          atualizadoEm: Value(agora),
          concluidoEm: Value(agora),
        ),
      );

      if (resumo == null) return;
      await _registroAtividade.registrar(
        tipo: TipoAtividade.levantamentoConcluido,
        titulo: 'Levantamento finalizado',
        subtitulo: _levantamentoAtividadeSubtitulo(resumo),
        tipoEntidade: TipoEntidadeAtividade.levantamento,
        entidadeId: levantamentoId,
        ocorridoEm: agora,
      );

      for (final talhaoResumo in resumo.talhoes) {
        await _registroAtividade.registrar(
          tipo: TipoAtividade.talhaoConcluido,
          titulo: 'Talhao finalizado',
          subtitulo:
              '${talhaoResumo.talhao.identificacao} - ${resumo.propriedade.nome}',
          tipoEntidade: TipoEntidadeAtividade.talhao,
          entidadeId: talhaoResumo.talhao.id,
          ocorridoEm: agora,
        );
      }
    });
  }

  Future<void> excluirLevantamento(int levantamentoId) {
    return _bancoDados.transaction(() async {
      final resumo = await _resumoPorId(levantamentoId);
      final talhoes = await (_bancoDados.select(
        _bancoDados.talhaoLevantamentos,
      )..where((tabela) => tabela.levantamentoId.equals(levantamentoId))).get();
      final talhaoIds = talhoes
          .map((talhaoLevantamento) => talhaoLevantamento.id)
          .toList();

      if (talhaoIds.isNotEmpty) {
        await _excluirDadosTalhoesDoLevantamento(talhaoIds);
      }

      await (_bancoDados.delete(
        _bancoDados.levantamentos,
      )..where((tabela) => tabela.id.equals(levantamentoId))).go();

      if (resumo == null) return;
      await _registroAtividade.registrar(
        tipo: TipoAtividade.levantamentoExcluido,
        titulo: 'Levantamento excluido',
        subtitulo: _levantamentoAtividadeSubtitulo(resumo),
        tipoEntidade: TipoEntidadeAtividade.levantamento,
        entidadeId: levantamentoId,
      );
    });
  }

  Future<void> removerTalhaoDeLevantamento(int talhaoLevantamentoId) {
    return _bancoDados.transaction(() async {
      final talhaoLevantamento =
          await (_bancoDados.select(_bancoDados.talhaoLevantamentos)
                ..where((tabela) => tabela.id.equals(talhaoLevantamentoId))
                ..limit(1))
              .getSingleOrNull();

      if (talhaoLevantamento == null) return;
      final levantamento = await _levantamentoPorId(
        talhaoLevantamento.levantamentoId,
      );
      final talhao = await _talhaoPorId(talhaoLevantamento.talhaoId);
      final propriedade = levantamento == null
          ? null
          : await _propriedadePorId(levantamento.propriedadeId);

      await _excluirDadosTalhoesDoLevantamento([talhaoLevantamento.id]);

      await (_bancoDados.update(_bancoDados.levantamentos)..where(
            (tabela) => tabela.id.equals(talhaoLevantamento.levantamentoId),
          ))
          .write(LevantamentosCompanion(atualizadoEm: Value(DateTime.now())));

      if (talhao == null) return;
      await _registroAtividade.registrar(
        tipo: TipoAtividade.talhaoRemovidoLevantamento,
        titulo: 'Talhao removido do levantamento',
        subtitulo: _talhaoAtividadeSubtitulo(talhao, propriedade),
        tipoEntidade: TipoEntidadeAtividade.levantamento,
        entidadeId: talhaoLevantamento.levantamentoId,
      );
    });
  }

  Future<void> atualizarTalhaoNoLevantamento({
    required int talhaoLevantamentoId,
    required String identificacao,
    required int especieId,
    required double areaHa,
    int? anoPlantio,
    String? espacamento,
    String? regimeManejo,
    double? larguraParcelaM,
    double? comprimentoParcelaM,
    String? observacoes,
    SelecaoModeloLevantamento? modeloMatematicoSelecao,
  }) {
    return _bancoDados.transaction(() async {
      final talhaoLevantamento =
          await (_bancoDados.select(_bancoDados.talhaoLevantamentos)
                ..where((tabela) => tabela.id.equals(talhaoLevantamentoId))
                ..limit(1))
              .getSingle();
      final levantamento = await _levantamentoPorId(
        talhaoLevantamento.levantamentoId,
      );
      final propriedade = levantamento == null
          ? null
          : await _propriedadePorId(levantamento.propriedadeId);
      final agora = DateTime.now();
      final modeloMatematicoId =
          modeloMatematicoSelecao?.modeloMatematicoId ??
          await _obterIdModeloPadrao(especieId);

      await (_bancoDados.update(_bancoDados.talhoes)
            ..where((tabela) => tabela.id.equals(talhaoLevantamento.talhaoId)))
          .write(
            TalhoesCompanion(
              identificacao: Value(identificacao.trim()),
              especieId: Value(especieId),
              areaHa: Value(areaHa),
              anoPlantio: Value(anoPlantio),
              espacamento: Value(_vazioParaNulo(espacamento)),
              regimeManejo: Value(_vazioParaNulo(regimeManejo)),
              larguraParcelaM: Value(larguraParcelaM),
              comprimentoParcelaM: Value(comprimentoParcelaM),
              observacoes: Value(_vazioParaNulo(observacoes)),
              atualizadoEm: Value(agora),
            ),
          );

      await (_bancoDados.update(
        _bancoDados.talhaoLevantamentos,
      )..where((tabela) => tabela.id.equals(talhaoLevantamentoId))).write(
        TalhaoLevantamentosCompanion(
          especieId: Value(especieId),
          modeloMatematicoId: Value(modeloMatematicoId),
          atualizadoEm: Value(agora),
        ),
      );

      await _substituirCoeficientesModeloDoTalhao(
        talhaoLevantamentoId: talhaoLevantamentoId,
        especieId: especieId,
        modeloMatematicoId: modeloMatematicoId,
        coeficienteValoresPorSimbolo:
            modeloMatematicoSelecao?.coeficienteValoresPorSimbolo ?? const {},
      );

      await (_bancoDados.update(_bancoDados.levantamentos)..where(
            (tabela) => tabela.id.equals(talhaoLevantamento.levantamentoId),
          ))
          .write(LevantamentosCompanion(atualizadoEm: Value(agora)));

      await _registroAtividade.registrar(
        tipo: TipoAtividade.talhaoAtualizadoLevantamento,
        titulo: 'Talhao do levantamento atualizado',
        subtitulo: _talhaoAtividadeSubtitulo(
          Talhao(
            id: talhaoLevantamento.talhaoId,
            propriedadeId:
                (await (_bancoDados.select(_bancoDados.talhoes)..where(
                          (t) => t.id.equals(talhaoLevantamento.talhaoId),
                        ))
                        .getSingle())
                    .propriedadeId,
            identificacao: identificacao.trim(),
            especieId: especieId,
            areaHa: areaHa,
            anoPlantio: anoPlantio,
            espacamento: _vazioParaNulo(espacamento),
            regimeManejo: _vazioParaNulo(regimeManejo),
            larguraParcelaM: larguraParcelaM,
            comprimentoParcelaM: comprimentoParcelaM,
            observacoes: _vazioParaNulo(observacoes),
            criadoEm: agora,
            atualizadoEm: agora,
          ),
          propriedade,
        ),
        tipoEntidade: TipoEntidadeAtividade.levantamento,
        entidadeId: talhaoLevantamento.levantamentoId,
        ocorridoEm: agora,
      );
    });
  }

  Future<LevantamentoResumo?> _resumoPorId(int levantamentoId) async {
    final levantamento =
        await (_bancoDados.select(_bancoDados.levantamentos)
              ..where((tabela) => tabela.id.equals(levantamentoId))
              ..limit(1))
            .getSingleOrNull();

    if (levantamento == null) return null;
    return _resumoParaLevantamento(levantamento);
  }

  Future<LevantamentoResumo> _resumoParaLevantamento(
    Levantamento levantamento,
  ) async {
    final propriedade =
        await (_bancoDados.select(_bancoDados.propriedades)
              ..where((tabela) => tabela.id.equals(levantamento.propriedadeId)))
            .getSingle();

    return LevantamentoResumo(
      levantamento: levantamento,
      propriedade: propriedade,
      talhoes: await _resumosTalhoes(levantamento.id),
    );
  }

  Future<List<LevantamentoTalhaoResumo>> _resumosTalhoes(
    int levantamentoId,
  ) async {
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
            innerJoin(
              _bancoDados.modelosMatematicos,
              _bancoDados.modelosMatematicos.id.equalsExp(
                _bancoDados.talhaoLevantamentos.modeloMatematicoId,
              ),
            ),
          ])
          ..where(
            _bancoDados.talhaoLevantamentos.levantamentoId.equals(
              levantamentoId,
            ),
          )
          ..orderBy([OrderingTerm.asc(_bancoDados.talhoes.identificacao)]);

    final linhas = await consulta.get();
    final resumos = <LevantamentoTalhaoResumo>[];

    for (final linha in linhas) {
      final talhaoLevantamento = linha.readTable(
        _bancoDados.talhaoLevantamentos,
      );
      resumos.add(
        LevantamentoTalhaoResumo(
          talhaoLevantamento: talhaoLevantamento,
          talhao: linha.readTable(_bancoDados.talhoes),
          especie: linha.readTable(_bancoDados.especies),
          modeloMatematico: linha.readTable(_bancoDados.modelosMatematicos),
          coeficientesModelo: await _modeloMatematicoCoeficientesParaTalhao(
            talhaoLevantamento,
          ),
          parcelaQuantidade: await _quantidadeParcelas(talhaoLevantamento.id),
          coletadaParcelaQuantidade: await _quantidadeParcelasColetadas(
            talhaoLevantamento.id,
          ),
          arvoreQuantidade: await _quantidadeArvores(talhaoLevantamento.id),
          medidaAreaHa: await _somarAreaMedida(talhaoLevantamento.id),
        ),
      );
    }

    return resumos;
  }

  Future<bool> _normalizarLevantamentosAtivosPorPropriedade() async {
    final ativoLevantamentos =
        await (_bancoDados.select(_bancoDados.levantamentos)
              ..where(
                (tabela) => tabela.situacao.equalsValue(
                  SituacaoLevantamento.emAndamento,
                ),
              )
              ..orderBy([
                (tabela) => OrderingTerm.asc(tabela.propriedadeId),
                (tabela) => OrderingTerm.desc(tabela.atualizadoEm),
              ]))
            .get();

    final levantamentosPorPropriedade = <int, List<Levantamento>>{};
    for (final levantamento in ativoLevantamentos) {
      levantamentosPorPropriedade
          .putIfAbsent(levantamento.propriedadeId, () => [])
          .add(levantamento);
    }

    final duplicadoGrupos = levantamentosPorPropriedade.values
        .where((levantamentos) => levantamentos.length > 1)
        .toList();
    if (duplicadoGrupos.isEmpty) return false;

    var alterado = false;

    await _bancoDados.transaction(() async {
      for (final levantamentos in duplicadoGrupos) {
        levantamentos.sort((a, b) => b.atualizadoEm.compareTo(a.atualizadoEm));
        final destinoLevantamento = levantamentos.first;

        for (final origemLevantamento in levantamentos.skip(1)) {
          final origemTalhoes =
              await (_bancoDados.select(_bancoDados.talhaoLevantamentos)..where(
                    (tabela) =>
                        tabela.levantamentoId.equals(origemLevantamento.id),
                  ))
                  .get();

          final possuiColisao = await _possuiTalhaoDuplicado(
            destinoLevantamentoId: destinoLevantamento.id,
            origemTalhoes: origemTalhoes,
          );
          if (possuiColisao) continue;

          final agora = DateTime.now();
          for (final talhaoLevantamento in origemTalhoes) {
            await (_bancoDados.update(_bancoDados.talhaoLevantamentos)
                  ..where((tabela) => tabela.id.equals(talhaoLevantamento.id)))
                .write(
                  TalhaoLevantamentosCompanion(
                    levantamentoId: Value(destinoLevantamento.id),
                    atualizadoEm: Value(agora),
                  ),
                );
          }

          await (_bancoDados.delete(
            _bancoDados.levantamentos,
          )..where((tabela) => tabela.id.equals(origemLevantamento.id))).go();

          await (_bancoDados.update(_bancoDados.levantamentos)
                ..where((tabela) => tabela.id.equals(destinoLevantamento.id)))
              .write(LevantamentosCompanion(atualizadoEm: Value(agora)));

          alterado = true;
        }
      }
    });

    return alterado;
  }

  Future<bool> _possuiTalhaoDuplicado({
    required int destinoLevantamentoId,
    required List<TalhaoLevantamento> origemTalhoes,
  }) async {
    for (final talhaoLevantamento in origemTalhoes) {
      final duplicado =
          await (_bancoDados.select(_bancoDados.talhaoLevantamentos)
                ..where(
                  (tabela) =>
                      tabela.levantamentoId.equals(destinoLevantamentoId) &
                      tabela.talhaoId.equals(talhaoLevantamento.talhaoId),
                )
                ..limit(1))
              .getSingleOrNull();

      if (duplicado != null) return true;
    }

    return false;
  }

  Future<void> _excluirDadosTalhoesDoLevantamento(List<int> talhaoIds) async {
    if (talhaoIds.isEmpty) return;

    final parcelas = await (_bancoDados.select(
      _bancoDados.parcelas,
    )..where((tabela) => tabela.talhaoLevantamentoId.isIn(talhaoIds))).get();
    final parcelaIds = parcelas.map((parcela) => parcela.id).toList();

    if (parcelaIds.isNotEmpty) {
      await (_bancoDados.delete(
        _bancoDados.pontosGeograficosParcela,
      )..where((tabela) => tabela.parcelaId.isIn(parcelaIds))).go();
      await (_bancoDados.delete(
        _bancoDados.arvores,
      )..where((tabela) => tabela.parcelaId.isIn(parcelaIds))).go();
      await (_bancoDados.delete(
        _bancoDados.parcelas,
      )..where((tabela) => tabela.id.isIn(parcelaIds))).go();
    }

    await _excluirCopiasCoeficientesModelo(talhaoIds);

    await (_bancoDados.delete(
      _bancoDados.talhaoLevantamentos,
    )..where((tabela) => tabela.id.isIn(talhaoIds))).go();
  }

  Future<int> _obterIdModeloPadrao(int especieId) async {
    final modelosMatematicos = await (_bancoDados.select(
      _bancoDados.especiesModelos,
    )..where((tabela) => tabela.especieId.equals(especieId))).get();

    final padraoModeloMatematico = modelosMatematicos
        .where((modeloMatematico) => modeloMatematico.padrao)
        .cast<EspecieModelo?>()
        .firstOrNull;

    if (padraoModeloMatematico != null) {
      return padraoModeloMatematico.modeloMatematicoId;
    }
    if (modelosMatematicos.isNotEmpty) {
      return modelosMatematicos.first.modeloMatematicoId;
    }

    final alternativo = await (_bancoDados.select(
      _bancoDados.modelosMatematicos,
    )..limit(1)).getSingle();
    return alternativo.id;
  }

  Future<List<ValorCoeficienteModeloLevantamento>>
  _modeloMatematicoCoeficientesParaTalhao(
    TalhaoLevantamento talhaoLevantamento,
  ) async {
    final snapshot = await _bancoDados
        .customSelect(
          '''
SELECT simbolo, rotulo, valor
FROM coeficientes_talhao_levantamento
WHERE talhao_levantamento_id = ?
ORDER BY simbolo
''',
          variables: [Variable<int>(talhaoLevantamento.id)],
          readsFrom: const {},
        )
        .get();

    if (snapshot.isNotEmpty) {
      return [
        for (final linha in snapshot)
          ValorCoeficienteModeloLevantamento(
            simbolo: linha.read<String>('simbolo'),
            rotulo: linha.read<String>('rotulo'),
            valor: linha.readNullable<double>('valor'),
          ),
      ];
    }

    final global =
        await (_bancoDados.select(_bancoDados.coeficientesModelo)
              ..where(
                (tabela) => tabela.modeloMatematicoId.equals(
                  talhaoLevantamento.modeloMatematicoId,
                ),
              )
              ..orderBy([(tabela) => OrderingTerm.asc(tabela.simbolo)]))
            .get();
    final especieValores = await _valoresCoeficientesModeloDaEspecie(
      especieId: talhaoLevantamento.especieId,
      modeloMatematicoId: talhaoLevantamento.modeloMatematicoId,
    );

    return [
      for (final coeficiente in global)
        ValorCoeficienteModeloLevantamento(
          simbolo: coeficiente.simbolo,
          rotulo: coeficiente.rotulo,
          valor:
              especieValores[coeficiente.simbolo] ??
              coeficiente.valor ??
              CalculadoraVolumeFlorestal.valorPadraoCoeficiente(
                modeloMatematicoCodigo: await _bancoDados.codigoModeloPorId(
                  talhaoLevantamento.modeloMatematicoId,
                ),
                simbolo: coeficiente.simbolo,
              ),
        ),
    ];
  }

  Future<void> _substituirCoeficientesModeloDoTalhao({
    required int talhaoLevantamentoId,
    required int especieId,
    required int modeloMatematicoId,
    required Map<String, double?> coeficienteValoresPorSimbolo,
  }) async {
    await _bancoDados.customStatement(
      'DELETE FROM coeficientes_talhao_levantamento WHERE talhao_levantamento_id = ?',
      [talhaoLevantamentoId],
    );

    final coeficientes =
        await (_bancoDados.select(_bancoDados.coeficientesModelo)
              ..where(
                (tabela) =>
                    tabela.modeloMatematicoId.equals(modeloMatematicoId),
              )
              ..orderBy([(tabela) => OrderingTerm.asc(tabela.simbolo)]))
            .get();
    final especieValores = await _valoresCoeficientesModeloDaEspecie(
      especieId: especieId,
      modeloMatematicoId: modeloMatematicoId,
    );

    for (final coeficiente in coeficientes) {
      await _bancoDados.customStatement(
        '''
INSERT INTO coeficientes_talhao_levantamento
  (talhao_levantamento_id, simbolo, rotulo, valor)
VALUES (?, ?, ?, ?)
''',
        [
          talhaoLevantamentoId,
          coeficiente.simbolo,
          coeficiente.rotulo,
          coeficienteValoresPorSimbolo.containsKey(coeficiente.simbolo)
              ? coeficienteValoresPorSimbolo[coeficiente.simbolo]
              : especieValores[coeficiente.simbolo] ??
                    coeficiente.valor ??
                    CalculadoraVolumeFlorestal.valorPadraoCoeficiente(
                      modeloMatematicoCodigo: await _bancoDados
                          .codigoModeloPorId(modeloMatematicoId),
                      simbolo: coeficiente.simbolo,
                    ),
        ],
      );
    }
  }

  Future<Map<String, double?>> _valoresCoeficientesModeloDaEspecie({
    required int especieId,
    required int modeloMatematicoId,
  }) async {
    final linhas =
        await (_bancoDados.select(_bancoDados.coeficientesEspecieModelo)..where(
              (tabela) =>
                  tabela.especieId.equals(especieId) &
                  tabela.modeloMatematicoId.equals(modeloMatematicoId),
            ))
            .get();

    return {
      for (final coeficiente in linhas) coeficiente.simbolo: coeficiente.valor,
    };
  }

  Future<void> _excluirCopiasCoeficientesModelo(List<int> talhaoIds) async {
    for (final talhaoId in talhaoIds) {
      await _bancoDados.customStatement(
        'DELETE FROM coeficientes_talhao_levantamento WHERE talhao_levantamento_id = ?',
        [talhaoId],
      );
    }
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
    final area = _bancoDados.parcelas.areaHa.sum();
    final linha =
        await (_bancoDados.selectOnly(_bancoDados.parcelas)
              ..addColumns([area])
              ..where(
                _bancoDados.parcelas.talhaoLevantamentoId.equals(
                  talhaoLevantamentoId,
                ),
              ))
            .getSingle();

    return linha.read(area) ?? 0;
  }

  Future<Levantamento?> _levantamentoPorId(int id) {
    return (_bancoDados.select(
      _bancoDados.levantamentos,
    )..where((tabela) => tabela.id.equals(id))).getSingleOrNull();
  }

  Future<Talhao?> _talhaoPorId(int id) {
    return (_bancoDados.select(
      _bancoDados.talhoes,
    )..where((tabela) => tabela.id.equals(id))).getSingleOrNull();
  }

  Future<Propriedade?> _propriedadePorId(int id) {
    return (_bancoDados.select(
      _bancoDados.propriedades,
    )..where((tabela) => tabela.id.equals(id))).getSingleOrNull();
  }
}

String _levantamentoAtividadeSubtitulo(LevantamentoResumo resumo) {
  return '${resumo.propriedade.nome} - ${resumo.talhaoRotulo}';
}

String _talhaoAtividadeSubtitulo(Talhao talhao, Propriedade? propriedade) {
  if (propriedade == null) return talhao.identificacao;
  return '${talhao.identificacao} - ${propriedade.nome}';
}

String? _vazioParaNulo(String? valor) {
  final aparado = valor?.trim();
  if (aparado == null || aparado.isEmpty) return null;
  return aparado;
}

int _prioridadeSituacao(SituacaoLevantamento situacao) {
  switch (situacao) {
    case SituacaoLevantamento.emAndamento:
      return 0;
    case SituacaoLevantamento.concluido:
      return 1;
    case SituacaoLevantamento.planejamento:
      return 2;
  }
}
