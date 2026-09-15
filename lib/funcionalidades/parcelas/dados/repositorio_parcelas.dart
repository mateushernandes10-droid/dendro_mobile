import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../nucleo/banco/banco_dendro.dart';
import '../../../nucleo/floresta/calculadora_volume_florestal.dart';
import '../../../nucleo/provedores/provedores_banco.dart';
import '../../atividades/dados/repositorio_atividades.dart';
import '../../levantamentos/dados/selecao_modelo_levantamento.dart';

final provedorRepositorioParcelas = Provider<RepositorioParcelas>((ref) {
  return RepositorioParcelas(ref.watch(provedorBancoDendro));
});

final provedorParcelasTalhao = StreamProvider.autoDispose
    .family<EstadoParcelasTalhao, int>((ref, talhaoId) {
      final repositorio = ref.watch(provedorRepositorioParcelas);
      return repositorio.observarParcelasTalhao(talhaoId);
    });

final provedorParcelasTalhaoLevantamento = StreamProvider.autoDispose
    .family<EstadoParcelasTalhao, int>((ref, talhaoLevantamentoId) {
      final repositorio = ref.watch(provedorRepositorioParcelas);
      return repositorio.observarParcelasTalhaoLevantamento(
        talhaoLevantamentoId,
      );
    });

class EstadoParcelasTalhao {
  const EstadoParcelasTalhao({
    required this.talhao,
    required this.especie,
    required this.parcelas,
    required this.proximaIdentificacaoParcela,
    this.ativoTalhaoLevantamento,
    this.atualTalhaoLevantamento,
    this.atualLevantamento,
  });

  final Talhao talhao;
  final Especie especie;
  final List<ParcelaResumo> parcelas;
  final String proximaIdentificacaoParcela;
  final TalhaoLevantamento? ativoTalhaoLevantamento;
  final TalhaoLevantamento? atualTalhaoLevantamento;
  final Levantamento? atualLevantamento;

  int get totalParcelas => parcelas.length;

  int get coletadaParcelas => parcelas
      .where((resumo) => resumo.parcela.situacao == SituacaoParcela.coletada)
      .length;

  int get planejadoParcelas => parcelas
      .where(
        (resumo) =>
            resumo.levantamento.situacao == SituacaoLevantamento.planejamento,
      )
      .length;

  int get abrirParcelas => totalParcelas - coletadaParcelas;

  double get medidaAreaHa => parcelas.fold<double>(
    0,
    (total, resumo) => total + (resumo.parcela.areaHa ?? 0),
  );
}

class ParcelaResumo {
  const ParcelaResumo({
    required this.parcela,
    required this.talhaoLevantamento,
    required this.levantamento,
    required this.arvoreQuantidade,
    required this.geograficoPontoQuantidade,
    this.primeiroGeograficoPonto,
  });

  final Parcela parcela;
  final TalhaoLevantamento talhaoLevantamento;
  final Levantamento levantamento;
  final int arvoreQuantidade;
  final int geograficoPontoQuantidade;
  final PontoGeograficoParcela? primeiroGeograficoPonto;

  bool get possuiCoordinates => primeiroGeograficoPonto != null;
}

class _ContextoTalhao {
  const _ContextoTalhao({required this.talhao, required this.especie});

  final Talhao talhao;
  final Especie especie;
}

class _ContextoTalhaoLevantamento {
  const _ContextoTalhaoLevantamento({
    required this.talhaoLevantamento,
    required this.levantamento,
    required this.talhao,
    required this.especie,
  });

  final TalhaoLevantamento talhaoLevantamento;
  final Levantamento levantamento;
  final Talhao talhao;
  final Especie especie;
}

class ExcecaoLevantamentoAtivoNoTalhao implements Exception {
  const ExcecaoLevantamentoAtivoNoTalhao(this.existente);

  final TalhaoLevantamento existente;
}

class RepositorioParcelas {
  RepositorioParcelas(this._bancoDados);

  final BancoDendro _bancoDados;
  late final RepositorioAtividades _registroAtividade = RepositorioAtividades(
    _bancoDados,
  );

  Stream<EstadoParcelasTalhao> observarParcelasTalhao(int talhaoId) async* {
    final context = await _lerContextoTalhao(talhaoId);

    final consulta =
        _bancoDados.select(_bancoDados.parcelas).join([
            innerJoin(
              _bancoDados.talhaoLevantamentos,
              _bancoDados.talhaoLevantamentos.id.equalsExp(
                _bancoDados.parcelas.talhaoLevantamentoId,
              ),
            ),
            innerJoin(
              _bancoDados.levantamentos,
              _bancoDados.levantamentos.id.equalsExp(
                _bancoDados.talhaoLevantamentos.levantamentoId,
              ),
            ),
          ])
          ..where(_bancoDados.talhaoLevantamentos.talhaoId.equals(talhaoId))
          ..orderBy([
            OrderingTerm.desc(_bancoDados.levantamentos.iniciadoEm),
            OrderingTerm.asc(_bancoDados.parcelas.identificacao),
          ]);

    yield* consulta.watch().asyncMap((linhas) async {
      final resumos = <ParcelaResumo>[];

      for (final linha in linhas) {
        final parcela = linha.readTable(_bancoDados.parcelas);
        final talhaoLevantamento = linha.readTable(
          _bancoDados.talhaoLevantamentos,
        );
        resumos.add(
          ParcelaResumo(
            parcela: parcela,
            talhaoLevantamento: talhaoLevantamento,
            levantamento: linha.readTable(_bancoDados.levantamentos),
            arvoreQuantidade: await _quantidadeArvores(parcela.id),
            geograficoPontoQuantidade: await _quantidadePontosGeograficos(
              parcela.id,
            ),
            primeiroGeograficoPonto: await _primeiroPontoGeografico(parcela.id),
          ),
        );
      }

      return EstadoParcelasTalhao(
        talhao: context.talhao,
        especie: context.especie,
        parcelas: resumos,
        proximaIdentificacaoParcela: await _proximaIdentificacaoParcelaDoTalhao(
          talhaoId,
        ),
        ativoTalhaoLevantamento: await _buscarTalhaoLevantamentoPorSituacao(
          talhaoId,
          SituacaoLevantamento.emAndamento,
        ),
      );
    });
  }

  Stream<EstadoParcelasTalhao> observarParcelasTalhaoLevantamento(
    int talhaoLevantamentoId,
  ) async* {
    final context = await _lerContextoTalhaoLevantamento(talhaoLevantamentoId);

    final consulta =
        _bancoDados.select(_bancoDados.parcelas).join([
            innerJoin(
              _bancoDados.talhaoLevantamentos,
              _bancoDados.talhaoLevantamentos.id.equalsExp(
                _bancoDados.parcelas.talhaoLevantamentoId,
              ),
            ),
            innerJoin(
              _bancoDados.levantamentos,
              _bancoDados.levantamentos.id.equalsExp(
                _bancoDados.talhaoLevantamentos.levantamentoId,
              ),
            ),
          ])
          ..where(
            _bancoDados.parcelas.talhaoLevantamentoId.equals(
              talhaoLevantamentoId,
            ),
          )
          ..orderBy([OrderingTerm.asc(_bancoDados.parcelas.identificacao)]);

    yield* consulta.watch().asyncMap((linhas) async {
      final resumos = <ParcelaResumo>[];

      for (final linha in linhas) {
        final parcela = linha.readTable(_bancoDados.parcelas);
        resumos.add(
          ParcelaResumo(
            parcela: parcela,
            talhaoLevantamento: linha.readTable(
              _bancoDados.talhaoLevantamentos,
            ),
            levantamento: linha.readTable(_bancoDados.levantamentos),
            arvoreQuantidade: await _quantidadeArvores(parcela.id),
            geograficoPontoQuantidade: await _quantidadePontosGeograficos(
              parcela.id,
            ),
            primeiroGeograficoPonto: await _primeiroPontoGeografico(parcela.id),
          ),
        );
      }

      return EstadoParcelasTalhao(
        talhao: context.talhao,
        especie: context.especie,
        parcelas: resumos,
        proximaIdentificacaoParcela: await _proximaIdentificacaoParcelaDoTalhao(
          context.talhao.id,
        ),
        ativoTalhaoLevantamento: await _buscarTalhaoLevantamentoPorSituacao(
          context.talhao.id,
          SituacaoLevantamento.emAndamento,
        ),
        atualTalhaoLevantamento: context.talhaoLevantamento,
        atualLevantamento: context.levantamento,
      );
    });
  }

  Future<int> criarParcelaPlanejada({
    required int talhaoId,
    double? areaHa,
  }) async {
    final talhaoLevantamento = await _garantirPlanejamentoTalhaoLevantamento(
      talhaoId,
    );
    return _criarParcela(
      talhaoLevantamentoId: talhaoLevantamento.id,
      areaHa: areaHa,
    );
  }

  Future<int> criarParcelaParaTalhaoLevantamento({
    required int talhaoLevantamentoId,
    double? areaHa,
  }) {
    return _criarParcela(
      talhaoLevantamentoId: talhaoLevantamentoId,
      areaHa: areaHa,
    );
  }

  Future<TalhaoLevantamento> iniciarNovoLevantamentoParaTalhao(
    int talhaoId, {
    SelecaoModeloLevantamento? modeloMatematicoSelecao,
  }) async {
    final ativo = await _buscarTalhaoLevantamentoPorSituacao(
      talhaoId,
      SituacaoLevantamento.emAndamento,
    );
    if (ativo != null) {
      throw ExcecaoLevantamentoAtivoNoTalhao(ativo);
    }

    final context = await _lerContextoTalhao(talhaoId);
    final reutilizavelAtivoLevantamento =
        await _buscarMaisRecenteLevantamentoParaPropriedadePorSituacao(
          propriedadeId: context.talhao.propriedadeId,
          situacao: SituacaoLevantamento.emAndamento,
        );

    final planejamento = await _buscarTalhaoLevantamentoPorSituacao(
      talhaoId,
      SituacaoLevantamento.planejamento,
    );
    if (planejamento != null && await _possuiParcelas(planejamento.id)) {
      if (reutilizavelAtivoLevantamento != null) {
        final movido = await _moverTalhaoLevantamentoParaLevantamento(
          talhaoLevantamento: planejamento,
          levantamentoId: reutilizavelAtivoLevantamento.id,
        );
        if (modeloMatematicoSelecao != null) {
          await _aplicarSelecaoModeloMatematico(
            talhaoLevantamentoId: movido.id,
            modeloMatematicoSelecao: modeloMatematicoSelecao,
          );
          final atualizado = await _talhaoLevantamentoPorId(movido.id);
          await _registrarInicioLevantamento(
            context: context,
            levantamentoId: atualizado.levantamentoId,
            criadoLevantamento: false,
          );
          return atualizado;
        }
        await _registrarInicioLevantamento(
          context: context,
          levantamentoId: movido.levantamentoId,
          criadoLevantamento: false,
        );
        return movido;
      }

      await _promoverLevantamento(planejamento.levantamentoId);
      if (modeloMatematicoSelecao != null) {
        await _aplicarSelecaoModeloMatematico(
          talhaoLevantamentoId: planejamento.id,
          modeloMatematicoSelecao: modeloMatematicoSelecao,
        );
      }
      final promovido = await _talhaoLevantamentoPorId(planejamento.id);
      await _registrarInicioLevantamento(
        context: context,
        levantamentoId: promovido.levantamentoId,
        criadoLevantamento: true,
      );
      return promovido;
    }

    final criadoLevantamento = reutilizavelAtivoLevantamento == null;
    final levantamentoId =
        reutilizavelAtivoLevantamento?.id ??
        await _criarLevantamento(
          propriedadeId: context.talhao.propriedadeId,
          situacao: SituacaoLevantamento.emAndamento,
        );

    final talhaoLevantamento = await _criarTalhaoLevantamento(
      talhao: context.talhao,
      especie: context.especie,
      levantamentoId: levantamentoId,
      modeloMatematicoSelecao: modeloMatematicoSelecao,
    );

    await _registrarInicioLevantamento(
      context: context,
      levantamentoId: talhaoLevantamento.levantamentoId,
      criadoLevantamento: criadoLevantamento,
    );

    return talhaoLevantamento;
  }

  Future<void> atualizarAreaParcela({required int id, double? areaHa}) async {
    final parcela = await (_bancoDados.select(
      _bancoDados.parcelas,
    )..where((tabela) => tabela.id.equals(id))).getSingleOrNull();
    final context = parcela == null
        ? null
        : await _lerContextoTalhaoLevantamento(parcela.talhaoLevantamentoId);
    final agora = DateTime.now();

    await _bancoDados.transaction(() async {
      await (_bancoDados.update(
        _bancoDados.parcelas,
      )..where((tabela) => tabela.id.equals(id))).write(
        ParcelasCompanion(areaHa: Value(areaHa), atualizadoEm: Value(agora)),
      );
      await atualizarLevantamentoDaParcela(id);

      if (parcela == null || context == null) return;
      await _registroAtividade.registrar(
        tipo: TipoAtividade.parcelaAtualizada,
        titulo: 'Parcela atualizada',
        subtitulo: _parcelaAtividadeSubtitulo(parcela.identificacao, context),
        tipoEntidade: TipoEntidadeAtividade.parcela,
        entidadeId: id,
        ocorridoEm: agora,
      );
    });
  }

  Future<void> excluirParcela(int id) async {
    final parcela = await (_bancoDados.select(
      _bancoDados.parcelas,
    )..where((tabela) => tabela.id.equals(id))).getSingleOrNull();
    final context = parcela == null
        ? null
        : await _lerContextoTalhaoLevantamento(parcela.talhaoLevantamentoId);

    await _bancoDados.transaction(() async {
      await (_bancoDados.delete(
        _bancoDados.parcelas,
      )..where((tabela) => tabela.id.equals(id))).go();

      if (parcela != null) {
        await atualizarTalhaoLevantamento(parcela.talhaoLevantamentoId);
      }

      if (parcela == null || context == null) return;
      await _registroAtividade.registrar(
        tipo: TipoAtividade.parcelaExcluida,
        titulo: 'Parcela excluida',
        subtitulo: _parcelaAtividadeSubtitulo(parcela.identificacao, context),
        tipoEntidade: TipoEntidadeAtividade.parcela,
        entidadeId: id,
      );
    });
  }

  Future<List<Arvore>> arvoresParaParcela(int parcelaId) {
    return (_bancoDados.select(_bancoDados.arvores)
          ..where((tabela) => tabela.parcelaId.equals(parcelaId))
          ..orderBy([(tabela) => OrderingTerm.asc(tabela.numero)]))
        .get();
  }

  Future<List<PontoGeograficoParcela>> pontosGeograficosDaParcela(
    int parcelaId,
  ) {
    return (_bancoDados.select(_bancoDados.pontosGeograficosParcela)
          ..where((tabela) => tabela.parcelaId.equals(parcelaId))
          ..orderBy([(tabela) => OrderingTerm.asc(tabela.ordemPonto)]))
        .get();
  }

  Future<String> proximaIdentificacaoParcela(int talhaoLevantamentoId) async {
    final talhaoLevantamento = await _talhaoLevantamentoPorId(
      talhaoLevantamentoId,
    );
    return _proximaIdentificacaoParcelaDoTalhao(talhaoLevantamento.talhaoId);
  }

  Future<String> _proximaIdentificacaoParcelaDoTalhao(int talhaoId) async {
    final existente = await (_bancoDados.select(_bancoDados.parcelas).join([
      innerJoin(
        _bancoDados.talhaoLevantamentos,
        _bancoDados.talhaoLevantamentos.id.equalsExp(
          _bancoDados.parcelas.talhaoLevantamentoId,
        ),
      ),
    ])..where(_bancoDados.talhaoLevantamentos.talhaoId.equals(talhaoId))).get();
    var maximoNumero = 0;
    for (final linha in existente) {
      final parcela = linha.readTable(_bancoDados.parcelas);
      final corresponder = RegExp(
        r'^P(\d+)$',
      ).firstMatch(parcela.identificacao);
      final numero = corresponder == null
          ? null
          : int.tryParse(corresponder.group(1)!);
      if (numero != null && numero > maximoNumero) {
        maximoNumero = numero;
      }
    }

    return 'P${(maximoNumero + 1).toString().padLeft(2, '0')}';
  }

  Future<void> atualizarLevantamentoDaParcela(int parcelaId) async {
    final parcela = await (_bancoDados.select(
      _bancoDados.parcelas,
    )..where((tabela) => tabela.id.equals(parcelaId))).getSingleOrNull();

    if (parcela == null) return;
    await atualizarTalhaoLevantamento(parcela.talhaoLevantamentoId);
  }

  Future<void> atualizarTalhaoLevantamento(int talhaoLevantamentoId) async {
    final talhaoLevantamento = await _talhaoLevantamentoPorId(
      talhaoLevantamentoId,
    );
    final agora = DateTime.now();

    await (_bancoDados.update(_bancoDados.talhaoLevantamentos)
          ..where((tabela) => tabela.id.equals(talhaoLevantamentoId)))
        .write(TalhaoLevantamentosCompanion(atualizadoEm: Value(agora)));

    await (_bancoDados.update(_bancoDados.levantamentos)..where(
          (tabela) => tabela.id.equals(talhaoLevantamento.levantamentoId),
        ))
        .write(LevantamentosCompanion(atualizadoEm: Value(agora)));
  }

  Future<int> _criarParcela({
    required int talhaoLevantamentoId,
    double? areaHa,
  }) async {
    late final int id;
    final agora = DateTime.now();
    final identificacao = await proximaIdentificacaoParcela(
      talhaoLevantamentoId,
    );
    final context = await _lerContextoTalhaoLevantamento(talhaoLevantamentoId);
    final resolvidoAreaHa = areaHa ?? _areaPadraoParcelaHa(context.talhao);

    await _bancoDados.transaction(() async {
      id = await _bancoDados
          .into(_bancoDados.parcelas)
          .insert(
            ParcelasCompanion.insert(
              talhaoLevantamentoId: talhaoLevantamentoId,
              identificacao: identificacao,
              situacao: SituacaoParcela.pendente,
              areaHa: Value(resolvidoAreaHa),
              criadoEm: agora,
              atualizadoEm: agora,
            ),
          );

      await atualizarTalhaoLevantamento(talhaoLevantamentoId);
      await _registroAtividade.registrar(
        tipo: TipoAtividade.parcelaCriada,
        titulo: 'Parcela cadastrada',
        subtitulo: _parcelaAtividadeSubtitulo(identificacao, context),
        tipoEntidade: TipoEntidadeAtividade.parcela,
        entidadeId: id,
        ocorridoEm: agora,
      );
    });
    return id;
  }

  double? _areaPadraoParcelaHa(Talhao talhao) {
    final largura = talhao.larguraParcelaM;
    final comprimento = talhao.comprimentoParcelaM;
    if (largura == null ||
        comprimento == null ||
        largura <= 0 ||
        comprimento <= 0) {
      return null;
    }
    return largura * comprimento / 10000;
  }

  Future<_ContextoTalhao> _lerContextoTalhao(int talhaoId) async {
    final linha = await (_bancoDados.select(_bancoDados.talhoes).join([
      innerJoin(
        _bancoDados.especies,
        _bancoDados.especies.id.equalsExp(_bancoDados.talhoes.especieId),
      ),
    ])..where(_bancoDados.talhoes.id.equals(talhaoId))).getSingle();

    return _ContextoTalhao(
      talhao: linha.readTable(_bancoDados.talhoes),
      especie: linha.readTable(_bancoDados.especies),
    );
  }

  Future<_ContextoTalhaoLevantamento> _lerContextoTalhaoLevantamento(
    int talhaoLevantamentoId,
  ) async {
    final linha =
        await (_bancoDados.select(_bancoDados.talhaoLevantamentos).join([
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
            ])..where(
              _bancoDados.talhaoLevantamentos.id.equals(talhaoLevantamentoId),
            ))
            .getSingle();

    return _ContextoTalhaoLevantamento(
      talhaoLevantamento: linha.readTable(_bancoDados.talhaoLevantamentos),
      levantamento: linha.readTable(_bancoDados.levantamentos),
      talhao: linha.readTable(_bancoDados.talhoes),
      especie: linha.readTable(_bancoDados.especies),
    );
  }

  Future<TalhaoLevantamento> _garantirPlanejamentoTalhaoLevantamento(
    int talhaoId,
  ) async {
    final existente = await _buscarTalhaoLevantamentoPorSituacao(
      talhaoId,
      SituacaoLevantamento.planejamento,
    );
    if (existente != null) return existente;

    final context = await _lerContextoTalhao(talhaoId);
    final levantamentoId = await _criarLevantamento(
      propriedadeId: context.talhao.propriedadeId,
      situacao: SituacaoLevantamento.planejamento,
    );

    return _criarTalhaoLevantamento(
      talhao: context.talhao,
      especie: context.especie,
      levantamentoId: levantamentoId,
    );
  }

  Future<TalhaoLevantamento?> _buscarTalhaoLevantamentoPorSituacao(
    int talhaoId,
    SituacaoLevantamento situacao,
  ) async {
    final consulta =
        _bancoDados.select(_bancoDados.talhaoLevantamentos).join([
            innerJoin(
              _bancoDados.levantamentos,
              _bancoDados.levantamentos.id.equalsExp(
                _bancoDados.talhaoLevantamentos.levantamentoId,
              ),
            ),
          ])
          ..where(
            _bancoDados.talhaoLevantamentos.talhaoId.equals(talhaoId) &
                _bancoDados.levantamentos.situacao.equalsValue(situacao),
          )
          ..orderBy([
            OrderingTerm.desc(_bancoDados.levantamentos.atualizadoEm),
            OrderingTerm.desc(_bancoDados.talhaoLevantamentos.atualizadoEm),
          ])
          ..limit(1);

    final linha = await consulta.getSingleOrNull();
    return linha?.readTable(_bancoDados.talhaoLevantamentos);
  }

  Future<Levantamento?>
  _buscarMaisRecenteLevantamentoParaPropriedadePorSituacao({
    required int propriedadeId,
    required SituacaoLevantamento situacao,
  }) {
    return (_bancoDados.select(_bancoDados.levantamentos)
          ..where(
            (tabela) =>
                tabela.propriedadeId.equals(propriedadeId) &
                tabela.situacao.equalsValue(situacao),
          )
          ..orderBy([(tabela) => OrderingTerm.desc(tabela.atualizadoEm)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> _criarLevantamento({
    required int propriedadeId,
    required SituacaoLevantamento situacao,
  }) async {
    late final int id;
    final agora = DateTime.now();

    id = await _bancoDados
        .into(_bancoDados.levantamentos)
        .insert(
          LevantamentosCompanion.insert(
            propriedadeId: propriedadeId,
            situacao: situacao,
            iniciadoEm: agora,
            atualizadoEm: agora,
          ),
        );

    return id;
  }

  Future<TalhaoLevantamento> _criarTalhaoLevantamento({
    required Talhao talhao,
    required Especie especie,
    required int levantamentoId,
    SelecaoModeloLevantamento? modeloMatematicoSelecao,
  }) async {
    late final int id;
    final agora = DateTime.now();
    final modeloMatematicoId =
        modeloMatematicoSelecao?.modeloMatematicoId ??
        await _obterIdModeloPadrao(especie.id);

    id = await _bancoDados
        .into(_bancoDados.talhaoLevantamentos)
        .insert(
          TalhaoLevantamentosCompanion.insert(
            levantamentoId: levantamentoId,
            talhaoId: talhao.id,
            especieId: especie.id,
            modeloMatematicoId: modeloMatematicoId,
            criadoEm: agora,
            atualizadoEm: agora,
          ),
        );

    await _substituirCoeficientesModeloDoTalhao(
      talhaoLevantamentoId: id,
      especieId: especie.id,
      modeloMatematicoId: modeloMatematicoId,
      coeficienteValoresPorSimbolo:
          modeloMatematicoSelecao?.coeficienteValoresPorSimbolo ?? const {},
    );
    await _atualizarLevantamento(levantamentoId, agora: agora);
    return _talhaoLevantamentoPorId(id);
  }

  Future<void> _aplicarSelecaoModeloMatematico({
    required int talhaoLevantamentoId,
    required SelecaoModeloLevantamento modeloMatematicoSelecao,
  }) async {
    final agora = DateTime.now();
    final talhaoLevantamento = await _talhaoLevantamentoPorId(
      talhaoLevantamentoId,
    );

    await (_bancoDados.update(
      _bancoDados.talhaoLevantamentos,
    )..where((tabela) => tabela.id.equals(talhaoLevantamentoId))).write(
      TalhaoLevantamentosCompanion(
        modeloMatematicoId: Value(modeloMatematicoSelecao.modeloMatematicoId),
        atualizadoEm: Value(agora),
      ),
    );

    await _substituirCoeficientesModeloDoTalhao(
      talhaoLevantamentoId: talhaoLevantamentoId,
      especieId: talhaoLevantamento.especieId,
      modeloMatematicoId: modeloMatematicoSelecao.modeloMatematicoId,
      coeficienteValoresPorSimbolo:
          modeloMatematicoSelecao.coeficienteValoresPorSimbolo,
    );
    await _atualizarLevantamento(
      talhaoLevantamento.levantamentoId,
      agora: agora,
    );
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

  Future<TalhaoLevantamento> _moverTalhaoLevantamentoParaLevantamento({
    required TalhaoLevantamento talhaoLevantamento,
    required int levantamentoId,
  }) async {
    if (talhaoLevantamento.levantamentoId == levantamentoId) {
      return talhaoLevantamento;
    }

    final anteriorLevantamentoId = talhaoLevantamento.levantamentoId;
    final agora = DateTime.now();

    await (_bancoDados.update(
      _bancoDados.talhaoLevantamentos,
    )..where((tabela) => tabela.id.equals(talhaoLevantamento.id))).write(
      TalhaoLevantamentosCompanion(
        levantamentoId: Value(levantamentoId),
        atualizadoEm: Value(agora),
      ),
    );

    await _atualizarLevantamento(levantamentoId, agora: agora);
    await _excluirLevantamentoSeVazio(anteriorLevantamentoId);

    return _talhaoLevantamentoPorId(talhaoLevantamento.id);
  }

  Future<void> _promoverLevantamento(int levantamentoId) {
    final agora = DateTime.now();
    return (_bancoDados.update(
      _bancoDados.levantamentos,
    )..where((tabela) => tabela.id.equals(levantamentoId))).write(
      LevantamentosCompanion(
        situacao: const Value(SituacaoLevantamento.emAndamento),
        iniciadoEm: Value(agora),
        atualizadoEm: Value(agora),
        concluidoEm: const Value(null),
      ),
    );
  }

  Future<void> _atualizarLevantamento(int levantamentoId, {DateTime? agora}) {
    return (_bancoDados.update(
      _bancoDados.levantamentos,
    )..where((tabela) => tabela.id.equals(levantamentoId))).write(
      LevantamentosCompanion(atualizadoEm: Value(agora ?? DateTime.now())),
    );
  }

  Future<void> _excluirLevantamentoSeVazio(int levantamentoId) async {
    final quantidade = _bancoDados.talhaoLevantamentos.id.count();
    final linha =
        await (_bancoDados.selectOnly(_bancoDados.talhaoLevantamentos)
              ..addColumns([quantidade])
              ..where(
                _bancoDados.talhaoLevantamentos.levantamentoId.equals(
                  levantamentoId,
                ),
              ))
            .getSingle();

    if ((linha.read(quantidade) ?? 0) > 0) return;

    await (_bancoDados.delete(
      _bancoDados.levantamentos,
    )..where((tabela) => tabela.id.equals(levantamentoId))).go();
  }

  Future<TalhaoLevantamento> _talhaoLevantamentoPorId(int id) {
    return (_bancoDados.select(
      _bancoDados.talhaoLevantamentos,
    )..where((tabela) => tabela.id.equals(id))).getSingle();
  }

  Future<bool> _possuiParcelas(int talhaoLevantamentoId) async {
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

    return (linha.read(quantidade) ?? 0) > 0;
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

  Future<int> _quantidadeArvores(int parcelaId) async {
    final quantidade = _bancoDados.arvores.id.count();

    final linha =
        await (_bancoDados.selectOnly(_bancoDados.arvores)
              ..addColumns([quantidade])
              ..where(_bancoDados.arvores.parcelaId.equals(parcelaId)))
            .getSingle();

    return linha.read(quantidade) ?? 0;
  }

  Future<int> _quantidadePontosGeograficos(int parcelaId) async {
    final quantidade = _bancoDados.pontosGeograficosParcela.id.count();

    final linha =
        await (_bancoDados.selectOnly(_bancoDados.pontosGeograficosParcela)
              ..addColumns([quantidade])
              ..where(
                _bancoDados.pontosGeograficosParcela.parcelaId.equals(
                  parcelaId,
                ),
              ))
            .getSingle();

    return linha.read(quantidade) ?? 0;
  }

  Future<PontoGeograficoParcela?> _primeiroPontoGeografico(int parcelaId) {
    return (_bancoDados.select(_bancoDados.pontosGeograficosParcela)
          ..where((tabela) => tabela.parcelaId.equals(parcelaId))
          ..orderBy([(tabela) => OrderingTerm.asc(tabela.ordemPonto)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> _registrarInicioLevantamento({
    required _ContextoTalhao context,
    required int levantamentoId,
    required bool criadoLevantamento,
  }) async {
    final propriedade = await _propriedadePorId(context.talhao.propriedadeId);
    await _registroAtividade.registrar(
      tipo: criadoLevantamento
          ? TipoAtividade.levantamentoIniciado
          : TipoAtividade.talhaoAdicionadoLevantamento,
      titulo: criadoLevantamento
          ? 'Levantamento iniciado'
          : 'Talhao adicionado ao levantamento',
      subtitulo: _talhaoAtividadeSubtitulo(context.talhao, propriedade),
      tipoEntidade: TipoEntidadeAtividade.levantamento,
      entidadeId: levantamentoId,
    );
  }

  Future<Propriedade?> _propriedadePorId(int id) {
    return (_bancoDados.select(
      _bancoDados.propriedades,
    )..where((tabela) => tabela.id.equals(id))).getSingleOrNull();
  }
}

String _parcelaAtividadeSubtitulo(
  String parcelaNome,
  _ContextoTalhaoLevantamento context,
) {
  return '$parcelaNome - ${context.talhao.identificacao}';
}

String _talhaoAtividadeSubtitulo(Talhao talhao, Propriedade? propriedade) {
  if (propriedade == null) return talhao.identificacao;
  return '${talhao.identificacao} - ${propriedade.nome}';
}
