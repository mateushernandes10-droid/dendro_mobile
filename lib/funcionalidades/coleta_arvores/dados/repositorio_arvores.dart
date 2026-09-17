import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../nucleo/banco/banco_dendro.dart';
import '../../../nucleo/provedores/provedores_banco.dart';
import '../../atividades/dados/repositorio_atividades.dart';

final provedorRepositorioArvores = Provider<RepositorioArvores>((ref) {
  return RepositorioArvores(ref.watch(provedorBancoDendro));
});

final provedorColetaArvores = StreamProvider.autoDispose
    .family<EstadoColetaArvores, int>((ref, parcelaId) {
      return ref.watch(provedorRepositorioArvores).observarColeta(parcelaId);
    });

class EstadoColetaArvores {
  const EstadoColetaArvores({
    required this.parcela,
    required this.talhaoLevantamento,
    required this.levantamento,
    required this.talhao,
    required this.especie,
    required this.arvores,
    required this.pontosReferencia,
  });

  final Parcela parcela;
  final TalhaoLevantamento talhaoLevantamento;
  final Levantamento levantamento;
  final Talhao talhao;
  final Especie especie;
  final List<Arvore> arvores;
  final List<Arvore> pontosReferencia;

  int get arvoreQuantidade => arvores.length;

  int get proximoNumeroArvore {
    if (arvores.isEmpty) return 1;
    return arvores
            .map((arvore) => arvore.numero)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  Set<PosicaoReferenciaParcela> get capturadoReferenciaPosicoes => {
    for (final arvore in pontosReferencia) arvore.posicaoReferenciaParcela!,
  };
}

class RascunhoArvore {
  const RascunhoArvore({
    required this.dapCm,
    required this.alturaM,
    required this.possuiTroncoTortuoso,
    this.latitude,
    this.longitude,
    this.precisaoMetros,
    this.localizacaoCapturadaEm,
    this.posicaoReferenciaParcela,
  });

  final double dapCm;
  final double alturaM;
  final bool possuiTroncoTortuoso;
  final double? latitude;
  final double? longitude;
  final double? precisaoMetros;
  final DateTime? localizacaoCapturadaEm;
  final PosicaoReferenciaParcela? posicaoReferenciaParcela;
}

class RepositorioArvores {
  RepositorioArvores(this._bancoDados);

  final BancoDendro _bancoDados;
  late final RepositorioAtividades _registroAtividade = RepositorioAtividades(
    _bancoDados,
  );

  Stream<EstadoColetaArvores> observarColeta(int parcelaId) {
    final arvoresConsulta = _bancoDados.select(_bancoDados.arvores)
      ..where((tabela) => tabela.parcelaId.equals(parcelaId))
      ..orderBy([(tabela) => OrderingTerm.asc(tabela.numero)]);

    return arvoresConsulta.watch().asyncMap((arvores) async {
      final context = await _lerContextoColeta(parcelaId);

      return EstadoColetaArvores(
        parcela: context.parcela,
        talhaoLevantamento: context.talhaoLevantamento,
        levantamento: context.levantamento,
        talhao: context.talhao,
        especie: context.especie,
        arvores: arvores,
        pontosReferencia: _pontosReferenciaDasArvores(arvores),
      );
    });
  }

  Future<int> criarArvore({
    required int parcelaId,
    required RascunhoArvore rascunho,
  }) async {
    late final int id;
    final agora = DateTime.now();
    final numero = await proximoNumeroArvore(parcelaId);

    await _bancoDados.transaction(() async {
      if (rascunho.posicaoReferenciaParcela != null) {
        await _limparPosicaoReferenciaDasArvores(
          parcelaId: parcelaId,
          posicaoReferencia: rascunho.posicaoReferenciaParcela!,
        );
      }

      id = await _bancoDados
          .into(_bancoDados.arvores)
          .insert(
            ArvoresCompanion.insert(
              parcelaId: parcelaId,
              numero: numero,
              dapCm: rascunho.dapCm,
              alturaM: rascunho.alturaM,
              possuiTroncoTortuoso: Value(rascunho.possuiTroncoTortuoso),
              latitude: Value(rascunho.latitude),
              longitude: Value(rascunho.longitude),
              precisaoMetros: Value(rascunho.precisaoMetros),
              localizacaoCapturadaEm: Value(rascunho.localizacaoCapturadaEm),
              posicaoReferenciaParcela: Value(
                rascunho.posicaoReferenciaParcela,
              ),
              criadoEm: agora,
              atualizadoEm: agora,
            ),
          );

      await _atualizarParcela(parcelaId, situacao: SituacaoParcela.emAndamento);
    });

    return id;
  }

  Future<void> atualizarArvore({
    required int arvoreId,
    required RascunhoArvore rascunho,
  }) async {
    final arvore = await _arvorePorId(arvoreId);

    await _bancoDados.transaction(() async {
      if (rascunho.posicaoReferenciaParcela != null) {
        await _limparPosicaoReferenciaDasArvores(
          parcelaId: arvore.parcelaId,
          posicaoReferencia: rascunho.posicaoReferenciaParcela!,
        );
      }

      await (_bancoDados.update(
        _bancoDados.arvores,
      )..where((tabela) => tabela.id.equals(arvoreId))).write(
        ArvoresCompanion(
          dapCm: Value(rascunho.dapCm),
          alturaM: Value(rascunho.alturaM),
          possuiTroncoTortuoso: Value(rascunho.possuiTroncoTortuoso),
          latitude: Value(rascunho.latitude),
          longitude: Value(rascunho.longitude),
          precisaoMetros: Value(rascunho.precisaoMetros),
          localizacaoCapturadaEm: Value(rascunho.localizacaoCapturadaEm),
          posicaoReferenciaParcela: Value(rascunho.posicaoReferenciaParcela),
          atualizadoEm: Value(DateTime.now()),
        ),
      );

      await _atualizarParcela(arvore.parcelaId);
    });
  }

  Future<void> excluirArvore(int arvoreId) async {
    final arvore = await _arvorePorId(arvoreId);

    await _bancoDados.transaction(() async {
      await (_bancoDados.delete(
        _bancoDados.arvores,
      )..where((tabela) => tabela.id.equals(arvoreId))).go();

      final restante = await _quantidadeArvores(arvore.parcelaId);
      final parcela = await _parcelaPorId(arvore.parcelaId);
      final situacao =
          restante == 0 && parcela.situacao == SituacaoParcela.emAndamento
          ? SituacaoParcela.pendente
          : null;

      await _atualizarParcela(arvore.parcelaId, situacao: situacao);
    });
  }

  Future<void> marcarParcelaColetada(int parcelaId) async {
    final context = await _lerContextoColeta(parcelaId);
    final jaColetada = context.parcela.situacao == SituacaoParcela.coletada;
    final agora = DateTime.now();

    await _bancoDados.transaction(() async {
      await _atualizarParcela(parcelaId, situacao: SituacaoParcela.coletada);

      if (jaColetada) return;
      await _registroAtividade.registrar(
        tipo: TipoAtividade.parcelaColetada,
        titulo: 'Parcela coletada',
        subtitulo:
            '${context.parcela.identificacao} - ${context.talhao.identificacao}',
        tipoEntidade: TipoEntidadeAtividade.parcela,
        entidadeId: parcelaId,
        ocorridoEm: agora,
      );
    });
  }

  Future<int> proximoNumeroArvore(int parcelaId) async {
    final arvores = await (_bancoDados.select(
      _bancoDados.arvores,
    )..where((tabela) => tabela.parcelaId.equals(parcelaId))).get();

    if (arvores.isEmpty) return 1;
    return arvores
            .map((arvore) => arvore.numero)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  Future<_ContextoColeta> _lerContextoColeta(int parcelaId) async {
    final consulta = _bancoDados.select(_bancoDados.parcelas).join([
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
    ])..where(_bancoDados.parcelas.id.equals(parcelaId));

    final linha = await consulta.getSingle();
    return _ContextoColeta(
      parcela: linha.readTable(_bancoDados.parcelas),
      talhaoLevantamento: linha.readTable(_bancoDados.talhaoLevantamentos),
      levantamento: linha.readTable(_bancoDados.levantamentos),
      talhao: linha.readTable(_bancoDados.talhoes),
      especie: linha.readTable(_bancoDados.especies),
    );
  }

  Future<void> _atualizarParcela(
    int parcelaId, {
    SituacaoParcela? situacao,
  }) async {
    final parcela = await _parcelaPorId(parcelaId);
    final talhaoLevantamento =
        await (_bancoDados.select(_bancoDados.talhaoLevantamentos)..where(
              (tabela) => tabela.id.equals(parcela.talhaoLevantamentoId),
            ))
            .getSingle();
    final agora = DateTime.now();

    await (_bancoDados.update(
      _bancoDados.parcelas,
    )..where((tabela) => tabela.id.equals(parcelaId))).write(
      ParcelasCompanion(
        situacao: situacao == null ? const Value.absent() : Value(situacao),
        atualizadoEm: Value(agora),
      ),
    );

    await (_bancoDados.update(_bancoDados.talhaoLevantamentos)
          ..where((tabela) => tabela.id.equals(talhaoLevantamento.id)))
        .write(TalhaoLevantamentosCompanion(atualizadoEm: Value(agora)));

    await (_bancoDados.update(_bancoDados.levantamentos)..where(
          (tabela) => tabela.id.equals(talhaoLevantamento.levantamentoId),
        ))
        .write(LevantamentosCompanion(atualizadoEm: Value(agora)));
  }

  Future<Arvore> _arvorePorId(int arvoreId) {
    return (_bancoDados.select(
      _bancoDados.arvores,
    )..where((tabela) => tabela.id.equals(arvoreId))).getSingle();
  }

  Future<Parcela> _parcelaPorId(int parcelaId) {
    return (_bancoDados.select(
      _bancoDados.parcelas,
    )..where((tabela) => tabela.id.equals(parcelaId))).getSingle();
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

  Future<void> _limparPosicaoReferenciaDasArvores({
    required int parcelaId,
    required PosicaoReferenciaParcela posicaoReferencia,
  }) {
    return (_bancoDados.update(_bancoDados.arvores)..where(
          (tabela) =>
              tabela.parcelaId.equals(parcelaId) &
              tabela.posicaoReferenciaParcela.equalsValue(posicaoReferencia),
        ))
        .write(
          ArvoresCompanion(
            posicaoReferenciaParcela: const Value<PosicaoReferenciaParcela?>(
              null,
            ),
            atualizadoEm: Value(DateTime.now()),
          ),
        );
  }
}

class _ContextoColeta {
  const _ContextoColeta({
    required this.parcela,
    required this.talhaoLevantamento,
    required this.levantamento,
    required this.talhao,
    required this.especie,
  });

  final Parcela parcela;
  final TalhaoLevantamento talhaoLevantamento;
  final Levantamento levantamento;
  final Talhao talhao;
  final Especie especie;
}

List<Arvore> _pontosReferenciaDasArvores(List<Arvore> arvores) {
  return arvores
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
