import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../nucleo/banco/banco_dendro.dart';
import '../../../nucleo/provedores/provedores_banco.dart';

final provedorRepositorioAtividades = Provider<RepositorioAtividades>((ref) {
  return RepositorioAtividades(ref.watch(provedorBancoDendro));
});

final provedorAtividadesRecentes =
    StreamProvider.autoDispose<List<RegistroAtividade>>((ref) {
      return ref
          .watch(provedorRepositorioAtividades)
          .observarRecente(limite: 4);
    });

final provedorHistoricoAtividades =
    StreamProvider.autoDispose<List<RegistroAtividade>>((ref) {
      return ref
          .watch(provedorRepositorioAtividades)
          .observarRecente(limite: 100);
    });

enum TipoAtividade {
  propriedadeCriada,
  propriedadeAtualizada,
  propriedadeExcluida,
  talhaoCriado,
  talhaoAtualizado,
  talhaoExcluido,
  parcelaCriada,
  parcelaAtualizada,
  parcelaExcluida,
  parcelaColetada,
  especieCriada,
  especieAtualizada,
  especieExcluida,
  especieModeloMatematicoVinculado,
  especieModeloMatematicoDesvinculado,
  especiePadraoModeloMatematicoAlterado,
  modeloMatematicoCriado,
  modeloMatematicoAtualizado,
  modeloMatematicoExcluido,
  modeloMatematicoCoeficientesAtualizado,
  levantamentoIniciado,
  levantamentoConcluido,
  levantamentoExcluido,
  talhaoAdicionadoLevantamento,
  talhaoAtualizadoLevantamento,
  talhaoRemovidoLevantamento,
  talhaoConcluido,
  exportacaoCriada,
}

enum TipoEntidadeAtividade {
  propriedade,
  talhao,
  parcela,
  especie,
  modeloMatematico,
  levantamento,
  exportacao,
}

class RegistroAtividade {
  const RegistroAtividade({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.subtitulo,
    required this.ocorridoEm,
    this.tipoEntidade,
    this.entidadeId,
    this.referenciaLegada,
  });

  final int id;
  final TipoAtividade tipo;
  final String titulo;
  final String subtitulo;
  final DateTime ocorridoEm;
  final TipoEntidadeAtividade? tipoEntidade;
  final int? entidadeId;
  final String? referenciaLegada;
}

class RepositorioAtividades {
  RepositorioAtividades(this._bancoDados);

  final BancoDendro _bancoDados;

  static final _alteracoes = StreamController<void>.broadcast();

  Stream<List<RegistroAtividade>> observarRecente({int limite = 4}) async* {
    yield await recente(limite: limite);
    yield* _alteracoes.stream.asyncMap((_) => recente(limite: limite));
  }

  Future<List<RegistroAtividade>> recente({int limite = 4}) async {
    final linhas = await _bancoDados
        .customSelect(
          '''
SELECT id, tipo, titulo, subtitulo, tipo_entidade, entidade_id, referencia_legada, ocorrido_em
FROM registros_atividade
ORDER BY ocorrido_em DESC
LIMIT ?
''',
          variables: [Variable<int>(limite)],
        )
        .get();

    return [for (final linha in linhas) _registroDeLinha(linha)];
  }

  Future<void> registrar({
    required TipoAtividade tipo,
    required String titulo,
    String subtitulo = '',
    TipoEntidadeAtividade? tipoEntidade,
    int? entidadeId,
    DateTime? ocorridoEm,
  }) async {
    final instante = ocorridoEm ?? DateTime.now();

    await _bancoDados.customStatement(
      '''
INSERT INTO registros_atividade
  (tipo, titulo, subtitulo, tipo_entidade, entidade_id, ocorrido_em)
VALUES (?, ?, ?, ?, ?, ?)
''',
      [
        tipo.name,
        titulo.trim(),
        subtitulo.trim(),
        tipoEntidade?.name,
        entidadeId,
        instante.millisecondsSinceEpoch,
      ],
    );
    _alteracoes.add(null);
  }

  Future<void> registroExportacao({
    required String formato,
    required String propriedadeNome,
    int? entidadeId,
  }) {
    return registrar(
      tipo: TipoAtividade.exportacaoCriada,
      titulo: 'Exportacao realizada',
      subtitulo: '$formato - $propriedadeNome',
      tipoEntidade: TipoEntidadeAtividade.exportacao,
      entidadeId: entidadeId,
    );
  }

  RegistroAtividade _registroDeLinha(QueryRow linha) {
    return RegistroAtividade(
      id: linha.read<int>('id'),
      tipo: _interpretarTipo(linha.read<String>('tipo')),
      titulo: linha.read<String>('titulo'),
      subtitulo: linha.read<String>('subtitulo'),
      tipoEntidade: _interpretarEntidadeTipo(
        linha.readNullable<String>('tipo_entidade'),
      ),
      entidadeId: linha.readNullable<int>('entidade_id'),
      referenciaLegada: linha.readNullable<String>('referencia_legada'),
      ocorridoEm: DateTime.fromMillisecondsSinceEpoch(
        linha.read<int>('ocorrido_em'),
      ),
    );
  }
}

TipoAtividade _interpretarTipo(String valor) {
  for (final tipo in TipoAtividade.values) {
    if (tipo.name == valor) return tipo;
  }
  return TipoAtividade.propriedadeAtualizada;
}

TipoEntidadeAtividade? _interpretarEntidadeTipo(String? valor) {
  if (valor == null) return null;
  for (final tipo in TipoEntidadeAtividade.values) {
    if (tipo.name == valor) return tipo;
  }
  return null;
}
