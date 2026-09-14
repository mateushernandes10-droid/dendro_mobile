import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../nucleo/banco/banco_dendro.dart';
import '../../../nucleo/provedores/provedores_banco.dart';
import '../../atividades/dados/repositorio_atividades.dart';

final provedorRepositorioPropriedades = Provider<RepositorioPropriedades>((
  ref,
) {
  return RepositorioPropriedades(ref.watch(provedorBancoDendro));
});

final provedorPropriedadeBuscaConsulta = StateProvider.autoDispose<String>((
  ref,
) {
  return '';
});

final provedorPropriedadeAvancadoFiltros =
    StateProvider.autoDispose<PropriedadeAvancadoFiltros>((ref) {
      return const PropriedadeAvancadoFiltros();
    });

final provedorPropriedadeResumos =
    StreamProvider.autoDispose<List<PropriedadeResumo>>((ref) {
      final repositorio = ref.watch(provedorRepositorioPropriedades);
      final buscaConsulta = ref.watch(provedorPropriedadeBuscaConsulta);
      final filtros = ref.watch(provedorPropriedadeAvancadoFiltros);

      return repositorio.observarResumos(
        buscaConsulta: buscaConsulta,
        filtros: filtros,
      );
    });

class PropriedadeAvancadoFiltros {
  const PropriedadeAvancadoFiltros({
    this.municipio = '',
    this.minimoAreaHa,
    this.maximoAreaHa,
    this.minimoTalhaoQuantidade,
    this.maximoTalhaoQuantidade,
  });

  final String municipio;
  final double? minimoAreaHa;
  final double? maximoAreaHa;
  final int? minimoTalhaoQuantidade;
  final int? maximoTalhaoQuantidade;

  bool get ativo {
    return municipio.trim().isNotEmpty ||
        minimoAreaHa != null ||
        maximoAreaHa != null ||
        minimoTalhaoQuantidade != null ||
        maximoTalhaoQuantidade != null;
  }
}

class PropriedadeResumo {
  const PropriedadeResumo({
    required this.propriedade,
    required this.talhaoQuantidade,
    required this.levantamentoQuantidade,
  });

  final Propriedade propriedade;
  final int talhaoQuantidade;
  final int levantamentoQuantidade;

  bool get possuiFilhos => talhaoQuantidade > 0 || levantamentoQuantidade > 0;
}

class RepositorioPropriedades {
  RepositorioPropriedades(this._bancoDados);

  final BancoDendro _bancoDados;
  late final RepositorioAtividades _registroAtividade = RepositorioAtividades(
    _bancoDados,
  );

  Stream<List<PropriedadeResumo>> observarResumos({
    String buscaConsulta = '',
    PropriedadeAvancadoFiltros filtros = const PropriedadeAvancadoFiltros(),
  }) {
    final normalizadoConsulta = buscaConsulta.trim();
    final municipio = filtros.municipio.trim();

    final instrucaoSql = _bancoDados.select(_bancoDados.propriedades)
      ..orderBy([(tabela) => OrderingTerm.asc(tabela.nome)]);

    if (normalizadoConsulta.isNotEmpty) {
      instrucaoSql.where(
        (tabela) => tabela.nome.like('%$normalizadoConsulta%'),
      );
    }
    if (municipio.isNotEmpty) {
      instrucaoSql.where((tabela) => tabela.municipio.like('%$municipio%'));
    }
    if (filtros.minimoAreaHa != null) {
      instrucaoSql.where(
        (tabela) =>
            tabela.areaTotalHa.isBiggerOrEqualValue(filtros.minimoAreaHa!),
      );
    }
    if (filtros.maximoAreaHa != null) {
      instrucaoSql.where(
        (tabela) =>
            tabela.areaTotalHa.isSmallerOrEqualValue(filtros.maximoAreaHa!),
      );
    }

    return instrucaoSql.watch().asyncMap((propriedades) async {
      final resumos = <PropriedadeResumo>[];

      for (final propriedade in propriedades) {
        final resumo = PropriedadeResumo(
          propriedade: propriedade,
          talhaoQuantidade: await _quantidadeTalhoes(propriedade.id),
          levantamentoQuantidade: await _quantidadeLevantamentos(
            propriedade.id,
          ),
        );

        if (filtros.minimoTalhaoQuantidade != null &&
            resumo.talhaoQuantidade < filtros.minimoTalhaoQuantidade!) {
          continue;
        }
        if (filtros.maximoTalhaoQuantidade != null &&
            resumo.talhaoQuantidade > filtros.maximoTalhaoQuantidade!) {
          continue;
        }

        resumos.add(resumo);
      }

      return resumos;
    });
  }

  Future<List<Propriedade>> buscaPorNome(String consulta) {
    final normalizadoConsulta = consulta.trim();

    final instrucaoSql = _bancoDados.select(_bancoDados.propriedades)
      ..orderBy([(tabela) => OrderingTerm.asc(tabela.nome)]);

    if (normalizadoConsulta.isNotEmpty) {
      instrucaoSql.where(
        (tabela) => tabela.nome.like('%$normalizadoConsulta%'),
      );
    }

    return instrucaoSql.get();
  }

  Future<Propriedade?> buscarPorId(int id) {
    return (_bancoDados.select(
      _bancoDados.propriedades,
    )..where((tabela) => tabela.id.equals(id))).getSingleOrNull();
  }

  Future<int> criar({
    required String nome,
    required String municipio,
    String estado = 'RS',
    required double areaTotalHa,
  }) async {
    late final int id;
    final agora = DateTime.now();

    final propriedadeNome = nome.trim();
    final municipioNome = municipio.trim();
    final estadoCode = estado.trim();

    await _bancoDados.transaction(() async {
      id = await _bancoDados
          .into(_bancoDados.propriedades)
          .insert(
            PropriedadesCompanion.insert(
              nome: propriedadeNome,
              municipio: municipioNome,
              estado: Value(estadoCode),
              areaTotalHa: areaTotalHa,
              criadoEm: agora,
              atualizadoEm: agora,
            ),
          );

      await _registroAtividade.registrar(
        tipo: TipoAtividade.propriedadeCriada,
        titulo: 'Propriedade cadastrada',
        subtitulo: '$propriedadeNome - $municipioNome-$estadoCode',
        tipoEntidade: TipoEntidadeAtividade.propriedade,
        entidadeId: id,
        ocorridoEm: agora,
      );
    });

    return id;
  }

  Future<void> atualizar({
    required int id,
    required String nome,
    required String municipio,
    required String estado,
    required double areaTotalHa,
  }) async {
    final agora = DateTime.now();
    final propriedadeNome = nome.trim();
    final municipioNome = municipio.trim();
    final estadoCode = estado.trim();

    await _bancoDados.transaction(() async {
      await (_bancoDados.update(
        _bancoDados.propriedades,
      )..where((tabela) => tabela.id.equals(id))).write(
        PropriedadesCompanion(
          nome: Value(propriedadeNome),
          municipio: Value(municipioNome),
          estado: Value(estadoCode),
          areaTotalHa: Value(areaTotalHa),
          atualizadoEm: Value(agora),
        ),
      );

      await _registroAtividade.registrar(
        tipo: TipoAtividade.propriedadeAtualizada,
        titulo: 'Propriedade atualizada',
        subtitulo: '$propriedadeNome - $municipioNome-$estadoCode',
        tipoEntidade: TipoEntidadeAtividade.propriedade,
        entidadeId: id,
        ocorridoEm: agora,
      );
    });
  }

  Future<void> excluir(int id) async {
    final propriedade = await buscarPorId(id);

    await _bancoDados.transaction(() async {
      await (_bancoDados.delete(
        _bancoDados.propriedades,
      )..where((tabela) => tabela.id.equals(id))).go();

      if (propriedade == null) return;
      await _registroAtividade.registrar(
        tipo: TipoAtividade.propriedadeExcluida,
        titulo: 'Propriedade excluida',
        subtitulo:
            '${propriedade.nome} - ${propriedade.municipio}-${propriedade.estado}',
        tipoEntidade: TipoEntidadeAtividade.propriedade,
        entidadeId: id,
      );
    });
  }

  Future<PropriedadeResumo?> obterResumo(int id) async {
    final propriedade = await buscarPorId(id);
    if (propriedade == null) return null;

    return PropriedadeResumo(
      propriedade: propriedade,
      talhaoQuantidade: await _quantidadeTalhoes(id),
      levantamentoQuantidade: await _quantidadeLevantamentos(id),
    );
  }

  Future<int> _quantidadeTalhoes(int propriedadeId) async {
    final quantidade = _bancoDados.talhoes.id.count();

    final linha =
        await (_bancoDados.selectOnly(_bancoDados.talhoes)
              ..addColumns([quantidade])
              ..where(_bancoDados.talhoes.propriedadeId.equals(propriedadeId)))
            .getSingle();

    return linha.read(quantidade) ?? 0;
  }

  Future<int> _quantidadeLevantamentos(int propriedadeId) async {
    final quantidade = _bancoDados.levantamentos.id.count();

    final linha =
        await (_bancoDados.selectOnly(_bancoDados.levantamentos)
              ..addColumns([quantidade])
              ..where(
                _bancoDados.levantamentos.propriedadeId.equals(propriedadeId),
              ))
            .getSingle();

    return linha.read(quantidade) ?? 0;
  }
}
