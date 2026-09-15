import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../nucleo/banco/banco_dendro.dart';
import '../../../nucleo/provedores/provedores_banco.dart';
import '../../atividades/dados/repositorio_atividades.dart';

final provedorRepositorioTalhoes = Provider<RepositorioTalhoes>((ref) {
  return RepositorioTalhoes(ref.watch(provedorBancoDendro));
});

final provedorEspeciesAtivas = StreamProvider.autoDispose<List<Especie>>((ref) {
  return ref.watch(provedorRepositorioTalhoes).observarEspeciesAtivas();
});

final provedorTalhoesDaPropriedade = StreamProvider.autoDispose
    .family<List<TalhaoResumo>, int>((ref, propriedadeId) {
      return ref
          .watch(provedorRepositorioTalhoes)
          .observarPorPropriedade(propriedadeId);
    });

final provedorOpcoesNovoLevantamento =
    StreamProvider.autoDispose<List<OpcaoPropriedadeNovoLevantamento>>((ref) {
      return ref
          .watch(provedorRepositorioTalhoes)
          .observarLevantamentoIniciarOpcoes();
    });

class OpcaoPropriedadeNovoLevantamento {
  const OpcaoPropriedadeNovoLevantamento({
    required this.propriedade,
    required this.talhoes,
  });

  final Propriedade propriedade;
  final List<TalhaoResumo> talhoes;

  OpcaoPropriedadeNovoLevantamento copyWith({List<TalhaoResumo>? talhoes}) {
    return OpcaoPropriedadeNovoLevantamento(
      propriedade: propriedade,
      talhoes: talhoes ?? this.talhoes,
    );
  }
}

class TalhaoResumo {
  const TalhaoResumo({
    required this.talhao,
    required this.especie,
    required this.talhaoLevantamentoQuantidade,
    required this.possuiAtivoLevantamento,
  });

  final Talhao talhao;
  final Especie especie;
  final int talhaoLevantamentoQuantidade;
  final bool possuiAtivoLevantamento;

  bool get possuiFilhos => talhaoLevantamentoQuantidade > 0;
}

class _TalhaoResumoAcumulador {
  _TalhaoResumoAcumulador({required this.talhao, required this.especie});

  final Talhao talhao;
  final Especie especie;
  int talhaoLevantamentoQuantidade = 0;
  bool possuiAtivoLevantamento = false;

  TalhaoResumo paraResumo() {
    return TalhaoResumo(
      talhao: talhao,
      especie: especie,
      talhaoLevantamentoQuantidade: talhaoLevantamentoQuantidade,
      possuiAtivoLevantamento: possuiAtivoLevantamento,
    );
  }
}

class _AcumuladorPropriedadeNovoLevantamento {
  _AcumuladorPropriedadeNovoLevantamento(this.propriedade);

  final Propriedade propriedade;
  final Map<int, _TalhaoResumoAcumulador> talhoesPorId = {};

  OpcaoPropriedadeNovoLevantamento paraOpcao() {
    final talhoes =
        talhoesPorId.values.map((resumo) => resumo.paraResumo()).toList()..sort(
          (a, b) => a.talhao.identificacao.compareTo(b.talhao.identificacao),
        );

    return OpcaoPropriedadeNovoLevantamento(
      propriedade: propriedade,
      talhoes: talhoes,
    );
  }
}

class RepositorioTalhoes {
  RepositorioTalhoes(this._bancoDados);

  final BancoDendro _bancoDados;
  late final RepositorioAtividades _registroAtividade = RepositorioAtividades(
    _bancoDados,
  );

  Stream<List<Especie>> observarEspeciesAtivas() {
    return (_bancoDados.select(_bancoDados.especies)
          ..where((tabela) => tabela.ativo.equals(true))
          ..orderBy([(tabela) => OrderingTerm.asc(tabela.nome)]))
        .watch();
  }

  Stream<List<TalhaoResumo>> observarPorPropriedade(int propriedadeId) {
    final consulta =
        _bancoDados.select(_bancoDados.talhoes).join([
            innerJoin(
              _bancoDados.especies,
              _bancoDados.especies.id.equalsExp(_bancoDados.talhoes.especieId),
            ),
            leftOuterJoin(
              _bancoDados.talhaoLevantamentos,
              _bancoDados.talhaoLevantamentos.talhaoId.equalsExp(
                _bancoDados.talhoes.id,
              ),
            ),
            leftOuterJoin(
              _bancoDados.levantamentos,
              _bancoDados.levantamentos.id.equalsExp(
                _bancoDados.talhaoLevantamentos.levantamentoId,
              ),
            ),
          ])
          ..where(_bancoDados.talhoes.propriedadeId.equals(propriedadeId))
          ..orderBy([OrderingTerm.asc(_bancoDados.talhoes.identificacao)]);

    return consulta.watch().map((linhas) {
      final resumosPorTalhao = <int, _TalhaoResumoAcumulador>{};

      for (final linha in linhas) {
        final talhao = linha.readTable(_bancoDados.talhoes);
        final resumo = resumosPorTalhao.putIfAbsent(
          talhao.id,
          () => _TalhaoResumoAcumulador(
            talhao: talhao,
            especie: linha.readTable(_bancoDados.especies),
          ),
        );

        final talhaoLevantamento = linha.readTableOrNull(
          _bancoDados.talhaoLevantamentos,
        );
        if (talhaoLevantamento == null) continue;

        resumo.talhaoLevantamentoQuantidade++;
        final levantamento = linha.readTableOrNull(_bancoDados.levantamentos);
        if (levantamento?.situacao == SituacaoLevantamento.emAndamento) {
          resumo.possuiAtivoLevantamento = true;
        }
      }

      return resumosPorTalhao.values
          .map((resumo) => resumo.paraResumo())
          .toList();
    });
  }

  Stream<List<OpcaoPropriedadeNovoLevantamento>>
  observarLevantamentoIniciarOpcoes() {
    final consulta =
        _bancoDados.select(_bancoDados.propriedades).join([
          leftOuterJoin(
            _bancoDados.talhoes,
            _bancoDados.talhoes.propriedadeId.equalsExp(
              _bancoDados.propriedades.id,
            ),
          ),
          leftOuterJoin(
            _bancoDados.especies,
            _bancoDados.especies.id.equalsExp(_bancoDados.talhoes.especieId),
          ),
          leftOuterJoin(
            _bancoDados.talhaoLevantamentos,
            _bancoDados.talhaoLevantamentos.talhaoId.equalsExp(
              _bancoDados.talhoes.id,
            ),
          ),
          leftOuterJoin(
            _bancoDados.levantamentos,
            _bancoDados.levantamentos.id.equalsExp(
              _bancoDados.talhaoLevantamentos.levantamentoId,
            ),
          ),
        ])..orderBy([
          OrderingTerm.asc(_bancoDados.propriedades.nome),
          OrderingTerm.asc(_bancoDados.talhoes.identificacao),
        ]);

    return consulta.watch().map((linhas) {
      final propriedadesPorId = <int, _AcumuladorPropriedadeNovoLevantamento>{};

      for (final linha in linhas) {
        final propriedade = linha.readTable(_bancoDados.propriedades);
        final propriedadeResumo = propriedadesPorId.putIfAbsent(
          propriedade.id,
          () => _AcumuladorPropriedadeNovoLevantamento(propriedade),
        );

        final talhao = linha.readTableOrNull(_bancoDados.talhoes);
        final especie = linha.readTableOrNull(_bancoDados.especies);
        if (talhao == null || especie == null) continue;

        final talhaoResumo = propriedadeResumo.talhoesPorId.putIfAbsent(
          talhao.id,
          () => _TalhaoResumoAcumulador(talhao: talhao, especie: especie),
        );

        final talhaoLevantamento = linha.readTableOrNull(
          _bancoDados.talhaoLevantamentos,
        );
        if (talhaoLevantamento == null) continue;

        talhaoResumo.talhaoLevantamentoQuantidade++;
        final levantamento = linha.readTableOrNull(_bancoDados.levantamentos);
        if (levantamento?.situacao == SituacaoLevantamento.emAndamento) {
          talhaoResumo.possuiAtivoLevantamento = true;
        }
      }

      return propriedadesPorId.values
          .map((resumo) => resumo.paraOpcao())
          .toList();
    });
  }

  Future<int> criar({
    required int propriedadeId,
    required String identificacao,
    required int especieId,
    required double areaHa,
    int? anoPlantio,
    String? espacamento,
    String? regimeManejo,
    double? larguraParcelaM,
    double? comprimentoParcelaM,
    String? observacoes,
  }) async {
    late final int id;
    final agora = DateTime.now();
    final talhaoNome = identificacao.trim();
    final propriedade = await _propriedadePorId(propriedadeId);

    await _bancoDados.transaction(() async {
      id = await _bancoDados
          .into(_bancoDados.talhoes)
          .insert(
            TalhoesCompanion.insert(
              propriedadeId: propriedadeId,
              identificacao: talhaoNome,
              especieId: especieId,
              areaHa: areaHa,
              anoPlantio: Value(anoPlantio),
              espacamento: Value(_vazioParaNulo(espacamento)),
              regimeManejo: Value(_vazioParaNulo(regimeManejo)),
              larguraParcelaM: Value(larguraParcelaM),
              comprimentoParcelaM: Value(comprimentoParcelaM),
              observacoes: Value(_vazioParaNulo(observacoes)),
              criadoEm: agora,
              atualizadoEm: agora,
            ),
          );

      await _registroAtividade.registrar(
        tipo: TipoAtividade.talhaoCriado,
        titulo: 'Talhao cadastrado',
        subtitulo: _talhaoAtividadeSubtitulo(talhaoNome, propriedade),
        tipoEntidade: TipoEntidadeAtividade.talhao,
        entidadeId: id,
        ocorridoEm: agora,
      );
    });

    return id;
  }

  Future<void> atualizar({
    required int id,
    required String identificacao,
    required int especieId,
    required double areaHa,
    int? anoPlantio,
    String? espacamento,
    String? regimeManejo,
    double? larguraParcelaM,
    double? comprimentoParcelaM,
    String? observacoes,
  }) async {
    final atual = await _talhaoPorId(id);
    final propriedade = atual == null
        ? null
        : await _propriedadePorId(atual.propriedadeId);
    final agora = DateTime.now();
    final talhaoNome = identificacao.trim();

    await _bancoDados.transaction(() async {
      await (_bancoDados.update(
        _bancoDados.talhoes,
      )..where((tabela) => tabela.id.equals(id))).write(
        TalhoesCompanion(
          identificacao: Value(talhaoNome),
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

      await _registroAtividade.registrar(
        tipo: TipoAtividade.talhaoAtualizado,
        titulo: 'Talhao atualizado',
        subtitulo: _talhaoAtividadeSubtitulo(talhaoNome, propriedade),
        tipoEntidade: TipoEntidadeAtividade.talhao,
        entidadeId: id,
        ocorridoEm: agora,
      );
    });
  }

  Future<void> excluir(int id) async {
    final talhao = await _talhaoPorId(id);
    final propriedade = talhao == null
        ? null
        : await _propriedadePorId(talhao.propriedadeId);

    await _bancoDados.transaction(() async {
      await (_bancoDados.delete(
        _bancoDados.talhoes,
      )..where((tabela) => tabela.id.equals(id))).go();

      if (talhao == null) return;
      await _registroAtividade.registrar(
        tipo: TipoAtividade.talhaoExcluido,
        titulo: 'Talhao excluido',
        subtitulo: _talhaoAtividadeSubtitulo(talhao.identificacao, propriedade),
        tipoEntidade: TipoEntidadeAtividade.talhao,
        entidadeId: id,
      );
    });
  }

  Future<TalhaoResumo?> obterResumo(int id) async {
    final consulta = _bancoDados.select(_bancoDados.talhoes).join([
      innerJoin(
        _bancoDados.especies,
        _bancoDados.especies.id.equalsExp(_bancoDados.talhoes.especieId),
      ),
    ])..where(_bancoDados.talhoes.id.equals(id));

    final linha = await consulta.getSingleOrNull();
    if (linha == null) return null;

    final talhao = linha.readTable(_bancoDados.talhoes);
    return TalhaoResumo(
      talhao: talhao,
      especie: linha.readTable(_bancoDados.especies),
      talhaoLevantamentoQuantidade: await _quantidadeLevantamentosDoTalhao(
        talhao.id,
      ),
      possuiAtivoLevantamento: await _possuiLevantamentoAtivo(talhao.id),
    );
  }

  Future<int> _quantidadeLevantamentosDoTalhao(int talhaoId) async {
    final quantidade = _bancoDados.talhaoLevantamentos.id.count();

    final linha =
        await (_bancoDados.selectOnly(_bancoDados.talhaoLevantamentos)
              ..addColumns([quantidade])
              ..where(
                _bancoDados.talhaoLevantamentos.talhaoId.equals(talhaoId),
              ))
            .getSingle();

    return linha.read(quantidade) ?? 0;
  }

  Future<bool> _possuiLevantamentoAtivo(int talhaoId) async {
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
                _bancoDados.levantamentos.situacao.equalsValue(
                  SituacaoLevantamento.emAndamento,
                ),
          )
          ..limit(1);

    return await consulta.getSingleOrNull() != null;
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

String _talhaoAtividadeSubtitulo(String talhaoNome, Propriedade? propriedade) {
  if (propriedade == null) return talhaoNome;
  return '$talhaoNome - ${propriedade.nome}';
}

String? _vazioParaNulo(String? valor) {
  final aparado = valor?.trim();
  if (aparado == null || aparado.isEmpty) return null;
  return aparado;
}
