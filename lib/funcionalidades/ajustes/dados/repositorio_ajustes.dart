import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../nucleo/banco/banco_dendro.dart';
import '../../../nucleo/floresta/calculadora_volume_florestal.dart';
import '../../../nucleo/provedores/provedores_banco.dart';
import '../../atividades/dados/repositorio_atividades.dart';

final provedorRepositorioAjustes = Provider<RepositorioAjustes>((ref) {
  return RepositorioAjustes(ref.watch(provedorBancoDendro));
});

final provedorAjustesEspecie = StreamProvider.autoDispose<List<Especie>>(
  (ref) {
    return ref.watch(provedorRepositorioAjustes).observarEspecie();
  },
);

final provedorAjustesModelosMatematicos =
    StreamProvider.autoDispose<List<ModeloMatematicoResumo>>((ref) {
      return ref.watch(provedorRepositorioAjustes).observarModelosMatematicos();
    });

final provedorAjustesEspecieModelosMatematicos =
    StreamProvider.autoDispose<List<EspecieModelo>>((ref) {
      return ref.watch(provedorRepositorioAjustes).observarEspecieModelosMatematicos();
    });

final provedorAjustesEspecieModeloMatematicoCoeficientes =
    StreamProvider.autoDispose<List<CoeficienteEspecieModelo>>((ref) {
      return ref
          .watch(provedorRepositorioAjustes)
          .observarEspecieModeloMatematicoCoeficientes();
    });

class ModeloMatematicoResumo {
  const ModeloMatematicoResumo({
    required this.modeloMatematico,
    required this.variaveis,
    required this.coeficientes,
  });

  final ModeloMatematico modeloMatematico;
  final List<VariavelModelo> variaveis;
  final List<CoeficienteModelo> coeficientes;
}

class ModeloMatematicoVariavelRascunho {
  const ModeloMatematicoVariavelRascunho({
    required this.simbolo,
    required this.rotulo,
    required this.unidade,
    required this.origemValor,
    required this.chaveVariavel,
  });

  final String simbolo;
  final String rotulo;
  final String unidade;
  final String origemValor;
  final ChaveVariavelModelo chaveVariavel;
}

class RepositorioAjustes {
  RepositorioAjustes(this._bancoDados);

  final BancoDendro _bancoDados;
  final _uuid = const Uuid();
  late final RepositorioAtividades _registroAtividade = RepositorioAtividades(
    _bancoDados,
  );

  Stream<List<Especie>> observarEspecie() {
    return (_bancoDados.select(
      _bancoDados.especies,
    )..orderBy([(tabela) => OrderingTerm.asc(tabela.nome)])).watch();
  }

  Stream<List<EspecieModelo>> observarEspecieModelosMatematicos() {
    return _bancoDados.select(_bancoDados.especiesModelos).watch();
  }

  Stream<List<CoeficienteEspecieModelo>>
  observarEspecieModeloMatematicoCoeficientes() {
    return (_bancoDados.select(_bancoDados.coeficientesEspecieModelo)..orderBy([
          (tabela) => OrderingTerm.asc(tabela.especieId),
          (tabela) => OrderingTerm.asc(tabela.modeloMatematicoId),
          (tabela) => OrderingTerm.asc(tabela.simbolo),
        ]))
        .watch();
  }

  Stream<List<ModeloMatematicoResumo>> observarModelosMatematicos() {
    final consulta = _bancoDados.select(_bancoDados.modelosMatematicos)
      ..orderBy([(tabela) => OrderingTerm.asc(tabela.nome)]);

    return consulta.watch().asyncMap((modelosMatematicos) async {
      final resumos = <ModeloMatematicoResumo>[];

      for (final modeloMatematico in modelosMatematicos) {
        resumos.add(
          ModeloMatematicoResumo(
            modeloMatematico: modeloMatematico,
            variaveis: await _variaveisParaModeloMatematico(modeloMatematico.id),
            coeficientes: await _coeficientesParaModeloMatematico(modeloMatematico.id),
          ),
        );
      }

      return resumos;
    });
  }

  Future<String> criarEspecie({
    required String nome,
    String? nomeCientifico,
    String? descricao,
    bool ativo = true,
  }) async {
    final id = _uuid.v4();
    final agora = DateTime.now();
    final especieNome = nome.trim();

    await _bancoDados.transaction(() async {
      await _bancoDados
          .into(_bancoDados.especies)
          .insert(
            EspeciesCompanion.insert(
              id: id,
              nome: especieNome,
              nomeCientifico: Value(_vazioParaNulo(nomeCientifico)),
              descricao: Value(_vazioParaNulo(descricao)),
              ativo: Value(ativo),
              criadoEm: agora,
              atualizadoEm: agora,
            ),
          );

      await _registroAtividade.registrar(
        tipo: TipoAtividade.especieCriada,
        titulo: 'Especie cadastrada',
        subtitulo: especieNome,
        tipoEntidade: TipoEntidadeAtividade.especie,
        entidadeId: id,
        ocorridoEm: agora,
      );
    });

    return id;
  }

  Future<void> atualizarEspecie({
    required String id,
    required String nome,
    String? nomeCientifico,
    String? descricao,
    required bool ativo,
  }) {
    final agora = DateTime.now();
    final especieNome = nome.trim();

    return _bancoDados.transaction(() async {
      await (_bancoDados.update(
        _bancoDados.especies,
      )..where((tabela) => tabela.id.equals(id))).write(
        EspeciesCompanion(
          nome: Value(especieNome),
          nomeCientifico: Value(_vazioParaNulo(nomeCientifico)),
          descricao: Value(_vazioParaNulo(descricao)),
          ativo: Value(ativo),
          atualizadoEm: Value(agora),
        ),
      );

      await _registroAtividade.registrar(
        tipo: TipoAtividade.especieAtualizada,
        titulo: 'Especie atualizada',
        subtitulo: especieNome,
        tipoEntidade: TipoEntidadeAtividade.especie,
        entidadeId: id,
        ocorridoEm: agora,
      );
    });
  }

  Future<void> excluirEspecie(String id) async {
    final especie = await _especiePorId(id);

    await _bancoDados.transaction(() async {
      await (_bancoDados.delete(
        _bancoDados.especies,
      )..where((tabela) => tabela.id.equals(id))).go();

      if (especie == null) return;
      await _registroAtividade.registrar(
        tipo: TipoAtividade.especieExcluida,
        titulo: 'Especie excluida',
        subtitulo: especie.nome,
        tipoEntidade: TipoEntidadeAtividade.especie,
        entidadeId: id,
      );
    });
  }

  Future<String> criarModeloMatematico({
    required String nome,
    String? descricao,
    required String expressao,
    required List<ModeloMatematicoVariavelRascunho> variaveis,
    required List<String> coeficienteSimbolos,
    bool ativo = true,
  }) async {
    final id = _uuid.v4();
    final agora = DateTime.now();
    final modeloMatematicoNome = nome.trim();

    await _bancoDados.transaction(() async {
      await _bancoDados
          .into(_bancoDados.modelosMatematicos)
          .insert(
            ModelosMatematicosCompanion.insert(
              id: id,
              nome: modeloMatematicoNome,
              descricao: Value(_vazioParaNulo(descricao)),
              expressao: expressao.trim(),
              ativo: Value(ativo),
              criadoEm: agora,
              atualizadoEm: agora,
            ),
          );

      await _substituirVariaveis(id, variaveis);
      await _substituirCoeficienteDefinicoes(id, coeficienteSimbolos);

      await _registroAtividade.registrar(
        tipo: TipoAtividade.modeloMatematicoCriado,
        titulo: 'Modelo matematico cadastrado',
        subtitulo: modeloMatematicoNome,
        tipoEntidade: TipoEntidadeAtividade.modeloMatematico,
        entidadeId: id,
        ocorridoEm: agora,
      );
    });

    return id;
  }

  Future<void> atualizarModeloMatematico({
    required String id,
    required String nome,
    String? descricao,
    required String expressao,
    required List<ModeloMatematicoVariavelRascunho> variaveis,
    required List<String> coeficienteSimbolos,
    required bool ativo,
  }) {
    return _bancoDados.transaction(() async {
      final agora = DateTime.now();
      final modeloMatematicoNome = nome.trim();
      await (_bancoDados.update(
        _bancoDados.modelosMatematicos,
      )..where((tabela) => tabela.id.equals(id))).write(
        ModelosMatematicosCompanion(
          nome: Value(modeloMatematicoNome),
          descricao: Value(_vazioParaNulo(descricao)),
          expressao: Value(expressao.trim()),
          ativo: Value(ativo),
          atualizadoEm: Value(agora),
        ),
      );

      await _substituirVariaveis(id, variaveis);
      await _substituirCoeficienteDefinicoes(id, coeficienteSimbolos);

      await _registroAtividade.registrar(
        tipo: TipoAtividade.modeloMatematicoAtualizado,
        titulo: 'Modelo matematico atualizado',
        subtitulo: modeloMatematicoNome,
        tipoEntidade: TipoEntidadeAtividade.modeloMatematico,
        entidadeId: id,
        ocorridoEm: agora,
      );
    });
  }

  Future<void> excluirModeloMatematico(String id) async {
    final modeloMatematico = await _modeloMatematicoPorId(id);

    await _bancoDados.transaction(() async {
      await (_bancoDados.delete(
        _bancoDados.modelosMatematicos,
      )..where((tabela) => tabela.id.equals(id))).go();

      if (modeloMatematico == null) return;
      await _registroAtividade.registrar(
        tipo: TipoAtividade.modeloMatematicoExcluido,
        titulo: 'Modelo matematico excluido',
        subtitulo: modeloMatematico.nome,
        tipoEntidade: TipoEntidadeAtividade.modeloMatematico,
        entidadeId: id,
      );
    });
  }

  Future<void> atualizarCoeficienteValores({
    required String modeloMatematicoId,
    required Map<String, double?> valoresPorCoeficienteId,
  }) {
    return _bancoDados.transaction(() async {
      final modeloMatematico = await _modeloMatematicoPorId(modeloMatematicoId);
      final agora = DateTime.now();
      for (final registro in valoresPorCoeficienteId.entries) {
        await (_bancoDados.update(_bancoDados.coeficientesModelo)
              ..where((tabela) => tabela.id.equals(registro.key)))
            .write(CoeficientesModeloCompanion(valor: Value(registro.value)));
      }

      await _atualizarModeloMatematico(modeloMatematicoId);

      await _registroAtividade.registrar(
        tipo: TipoAtividade.modeloMatematicoCoeficientesAtualizado,
        titulo: 'Coeficientes atualizados',
        subtitulo: modeloMatematico?.nome ?? 'Modelo matematico',
        tipoEntidade: TipoEntidadeAtividade.modeloMatematico,
        entidadeId: modeloMatematicoId,
        ocorridoEm: agora,
      );
    });
  }

  Future<void> atualizarEspecieModeloMatematicoCoeficienteValores({
    required String especieId,
    required String modeloMatematicoId,
    required Map<String, double?> valoresPorSimbolo,
  }) {
    return _bancoDados.transaction(() async {
      await _garantirEspecieModeloMatematicoCoeficienteLinhas(
        especieId: especieId,
        modeloMatematicoId: modeloMatematicoId,
      );

      final agora = DateTime.now();
      final modeloMatematico = await _modeloMatematicoPorId(modeloMatematicoId);

      for (final registro in valoresPorSimbolo.entries) {
        await (_bancoDados.update(_bancoDados.coeficientesEspecieModelo)..where(
              (tabela) =>
                  tabela.especieId.equals(especieId) &
                  tabela.modeloMatematicoId.equals(modeloMatematicoId) &
                  tabela.simbolo.equals(registro.key),
            ))
            .write(
              CoeficientesEspecieModeloCompanion(
                valor: Value(registro.value),
                atualizadoEm: Value(agora),
              ),
            );
      }

      await _registroAtividade.registrar(
        tipo: TipoAtividade.modeloMatematicoCoeficientesAtualizado,
        titulo: 'Coeficientes da especie atualizados',
        subtitulo: await _especieModeloMatematicoSubtitulo(especieId, modeloMatematicoId),
        tipoEntidade: TipoEntidadeAtividade.modeloMatematico,
        entidadeId: modeloMatematico?.id ?? modeloMatematicoId,
        ocorridoEm: agora,
      );
    });
  }

  Future<void> definirEspecieModeloMatematicoVinculado({
    required String especieId,
    required String modeloMatematicoId,
    required bool vinculado,
  }) {
    return _bancoDados.transaction(() async {
      final existente = await _buscarEspecieModeloMatematico(
        especieId: especieId,
        modeloMatematicoId: modeloMatematicoId,
      );

      if (vinculado) {
        await _garantirEspecieModeloMatematicoVinculado(
          especieId: especieId,
          modeloMatematicoId: modeloMatematicoId,
        );
        await _garantirEspecieModeloMatematicoCoeficienteLinhas(
          especieId: especieId,
          modeloMatematicoId: modeloMatematicoId,
        );
        if (existente == null) {
          await _registroAtividade.registrar(
            tipo: TipoAtividade.especieModeloMatematicoVinculado,
            titulo: 'Modelo vinculado a especie',
            subtitulo: await _especieModeloMatematicoSubtitulo(especieId, modeloMatematicoId),
            tipoEntidade: TipoEntidadeAtividade.especie,
            entidadeId: especieId,
          );
        }
        return;
      }

      if (existente == null) return;

      await (_bancoDados.delete(_bancoDados.especiesModelos)..where(
            (tabela) =>
                tabela.especieId.equals(especieId) &
                tabela.modeloMatematicoId.equals(modeloMatematicoId),
          ))
          .go();

      if (existente.padrao) {
        await _garantirEspeciePossuiPadraoModeloMatematico(especieId);
      }

      await _registroAtividade.registrar(
        tipo: TipoAtividade.especieModeloMatematicoDesvinculado,
        titulo: 'Modelo removido da especie',
        subtitulo: await _especieModeloMatematicoSubtitulo(especieId, modeloMatematicoId),
        tipoEntidade: TipoEntidadeAtividade.especie,
        entidadeId: especieId,
      );
    });
  }

  Future<void> definirPadraoModeloMatematicoParaEspecie({
    required String especieId,
    required String modeloMatematicoId,
  }) {
    return _bancoDados.transaction(() async {
      await _garantirEspecieModeloMatematicoVinculado(
        especieId: especieId,
        modeloMatematicoId: modeloMatematicoId,
      );

      await (_bancoDados.update(_bancoDados.especiesModelos)
            ..where((tabela) => tabela.especieId.equals(especieId)))
          .write(const EspeciesModelosCompanion(padrao: Value(false)));

      await (_bancoDados.update(_bancoDados.especiesModelos)..where(
            (tabela) =>
                tabela.especieId.equals(especieId) &
                tabela.modeloMatematicoId.equals(modeloMatematicoId),
          ))
          .write(const EspeciesModelosCompanion(padrao: Value(true)));

      await _registroAtividade.registrar(
        tipo: TipoAtividade.especiePadraoModeloMatematicoAlterado,
        titulo: 'Modelo padrao alterado',
        subtitulo: await _especieModeloMatematicoSubtitulo(especieId, modeloMatematicoId),
        tipoEntidade: TipoEntidadeAtividade.especie,
        entidadeId: especieId,
      );
    });
  }

  Future<List<VariavelModelo>> _variaveisParaModeloMatematico(String modeloMatematicoId) {
    return (_bancoDados.select(_bancoDados.variaveisModelo)
          ..where((tabela) => tabela.modeloMatematicoId.equals(modeloMatematicoId))
          ..orderBy([(tabela) => OrderingTerm.asc(tabela.simbolo)]))
        .get();
  }

  Future<List<CoeficienteModelo>> _coeficientesParaModeloMatematico(
    String modeloMatematicoId,
  ) {
    return (_bancoDados.select(_bancoDados.coeficientesModelo)
          ..where((tabela) => tabela.modeloMatematicoId.equals(modeloMatematicoId))
          ..orderBy([(tabela) => OrderingTerm.asc(tabela.simbolo)]))
        .get();
  }

  Future<void> _substituirVariaveis(
    String modeloMatematicoId,
    List<ModeloMatematicoVariavelRascunho> variaveis,
  ) async {
    await (_bancoDados.delete(
      _bancoDados.variaveisModelo,
    )..where((tabela) => tabela.modeloMatematicoId.equals(modeloMatematicoId))).go();

    for (final variavel in variaveis) {
      await _bancoDados
          .into(_bancoDados.variaveisModelo)
          .insert(
            VariaveisModeloCompanion.insert(
              id: _uuid.v4(),
              modeloMatematicoId: modeloMatematicoId,
              simbolo: variavel.simbolo.trim(),
              rotulo: variavel.rotulo.trim(),
              unidade: variavel.unidade.trim(),
              origemValor: variavel.origemValor.trim(),
              chaveVariavel: variavel.chaveVariavel,
            ),
          );
    }
  }

  Future<void> _substituirCoeficienteDefinicoes(
    String modeloMatematicoId,
    List<String> simbolos,
  ) async {
    final normalizadoSimbolos = _normalizarSimbolos(simbolos);
    final existente = await _coeficientesParaModeloMatematico(modeloMatematicoId);
    final existentePorSimbolo = {
      for (final coeficiente in existente) coeficiente.simbolo: coeficiente,
    };

    for (final coeficiente in existente) {
      if (!normalizadoSimbolos.contains(coeficiente.simbolo)) {
        await (_bancoDados.delete(
          _bancoDados.coeficientesModelo,
        )..where((tabela) => tabela.id.equals(coeficiente.id))).go();
      }
    }

    for (final simbolo in normalizadoSimbolos) {
      final existenteCoeficiente = existentePorSimbolo[simbolo];
      if (existenteCoeficiente == null) {
        await _bancoDados
            .into(_bancoDados.coeficientesModelo)
            .insert(
              CoeficientesModeloCompanion.insert(
                id: _uuid.v4(),
                modeloMatematicoId: modeloMatematicoId,
                simbolo: simbolo,
                rotulo: simbolo == 'ff'
                    ? 'Fator de forma'
                    : 'Coeficiente $simbolo',
              ),
            );
      } else {
        await (_bancoDados.update(
          _bancoDados.coeficientesModelo,
        )..where((tabela) => tabela.id.equals(existenteCoeficiente.id))).write(
          CoeficientesModeloCompanion(
            rotulo: Value(
              simbolo == 'ff' ? 'Fator de forma' : 'Coeficiente $simbolo',
            ),
          ),
        );
      }
    }

    await _sincronizarEspecieModeloMatematicoCoeficientesParaModeloMatematico(modeloMatematicoId);
  }

  Future<void> _atualizarModeloMatematico(String modeloMatematicoId) {
    return (_bancoDados.update(_bancoDados.modelosMatematicos)
          ..where((tabela) => tabela.id.equals(modeloMatematicoId)))
        .write(ModelosMatematicosCompanion(atualizadoEm: Value(DateTime.now())));
  }

  Future<Especie?> _especiePorId(String id) {
    return (_bancoDados.select(
      _bancoDados.especies,
    )..where((tabela) => tabela.id.equals(id))).getSingleOrNull();
  }

  Future<ModeloMatematico?> _modeloMatematicoPorId(String id) {
    return (_bancoDados.select(
      _bancoDados.modelosMatematicos,
    )..where((tabela) => tabela.id.equals(id))).getSingleOrNull();
  }

  Future<String> _especieModeloMatematicoSubtitulo(
    String especieId,
    String modeloMatematicoId,
  ) async {
    final especie = await _especiePorId(especieId);
    final modeloMatematico = await _modeloMatematicoPorId(modeloMatematicoId);

    return '${modeloMatematico?.nome ?? 'Modelo'} - ${especie?.nome ?? 'Especie'}';
  }

  Future<bool> _especiePossuiPadraoModeloMatematico(String especieId) async {
    final linha =
        await (_bancoDados.select(_bancoDados.especiesModelos)
              ..where(
                (tabela) =>
                    tabela.especieId.equals(especieId) &
                    tabela.padrao.equals(true),
              )
              ..limit(1))
            .getSingleOrNull();

    return linha != null;
  }

  Future<EspecieModelo?> _buscarEspecieModeloMatematico({
    required String especieId,
    required String modeloMatematicoId,
  }) {
    return (_bancoDados.select(_bancoDados.especiesModelos)
          ..where(
            (tabela) =>
                tabela.especieId.equals(especieId) &
                tabela.modeloMatematicoId.equals(modeloMatematicoId),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> _garantirEspecieModeloMatematicoVinculado({
    required String especieId,
    required String modeloMatematicoId,
  }) async {
    final existente = await _buscarEspecieModeloMatematico(
      especieId: especieId,
      modeloMatematicoId: modeloMatematicoId,
    );
    if (existente != null) return;

    final possuiPadrao = await _especiePossuiPadraoModeloMatematico(especieId);
    await _bancoDados
        .into(_bancoDados.especiesModelos)
        .insert(
          EspeciesModelosCompanion.insert(
            especieId: especieId,
            modeloMatematicoId: modeloMatematicoId,
            padrao: Value(!possuiPadrao),
            criadoEm: DateTime.now(),
          ),
        );
  }

  Future<void> _sincronizarEspecieModeloMatematicoCoeficientesParaModeloMatematico(
    String modeloMatematicoId,
  ) async {
    final definicoes = await _coeficientesParaModeloMatematico(modeloMatematicoId);
    final definicaoSimbolos = definicoes.map((item) => item.simbolo).toSet();
    final existente = await (_bancoDados.select(
      _bancoDados.coeficientesEspecieModelo,
    )..where((tabela) => tabela.modeloMatematicoId.equals(modeloMatematicoId))).get();

    for (final coeficiente in existente) {
      if (!definicaoSimbolos.contains(coeficiente.simbolo)) {
        await (_bancoDados.delete(
          _bancoDados.coeficientesEspecieModelo,
        )..where((tabela) => tabela.id.equals(coeficiente.id))).go();
      }
    }

    final vinculos = await (_bancoDados.select(
      _bancoDados.especiesModelos,
    )..where((tabela) => tabela.modeloMatematicoId.equals(modeloMatematicoId))).get();

    for (final vinculo in vinculos) {
      await _garantirEspecieModeloMatematicoCoeficienteLinhas(
        especieId: vinculo.especieId,
        modeloMatematicoId: modeloMatematicoId,
        definicoes: definicoes,
      );
    }
  }

  Future<void> _garantirEspecieModeloMatematicoCoeficienteLinhas({
    required String especieId,
    required String modeloMatematicoId,
    List<CoeficienteModelo>? definicoes,
  }) async {
    final coeficienteDefinicoes =
        definicoes ?? await _coeficientesParaModeloMatematico(modeloMatematicoId);
    final existente =
        await (_bancoDados.select(_bancoDados.coeficientesEspecieModelo)..where(
              (tabela) =>
                  tabela.especieId.equals(especieId) &
                  tabela.modeloMatematicoId.equals(modeloMatematicoId),
            ))
            .get();
    final existentePorSimbolo = {
      for (final coeficiente in existente) coeficiente.simbolo: coeficiente,
    };
    final definicaoSimbolos = coeficienteDefinicoes
        .map((item) => item.simbolo)
        .toSet();
    final agora = DateTime.now();

    for (final coeficiente in existente) {
      if (!definicaoSimbolos.contains(coeficiente.simbolo)) {
        await (_bancoDados.delete(
          _bancoDados.coeficientesEspecieModelo,
        )..where((tabela) => tabela.id.equals(coeficiente.id))).go();
      }
    }

    for (final definicao in coeficienteDefinicoes) {
      final existente = existentePorSimbolo[definicao.simbolo];
      final padraoValor =
          definicao.valor ??
          CalculadoraVolumeFlorestal.valorPadraoCoeficiente(
            modeloMatematicoId: modeloMatematicoId,
            simbolo: definicao.simbolo,
          );

      if (existente == null) {
        await _bancoDados
            .into(_bancoDados.coeficientesEspecieModelo)
            .insert(
              CoeficientesEspecieModeloCompanion.insert(
                id: _especieModeloMatematicoCoeficienteId(
                  especieId,
                  modeloMatematicoId,
                  definicao.simbolo,
                ),
                especieId: especieId,
                modeloMatematicoId: modeloMatematicoId,
                simbolo: definicao.simbolo,
                rotulo: definicao.rotulo,
                valor: Value(padraoValor),
                atualizadoEm: agora,
              ),
            );
      } else {
        await (_bancoDados.update(
          _bancoDados.coeficientesEspecieModelo,
        )..where((tabela) => tabela.id.equals(existente.id))).write(
          CoeficientesEspecieModeloCompanion(
            rotulo: Value(definicao.rotulo),
            valor: existente.valor == null
                ? Value(padraoValor)
                : const Value.absent(),
            atualizadoEm: Value(agora),
          ),
        );
      }
    }
  }

  Future<void> _garantirEspeciePossuiPadraoModeloMatematico(String especieId) async {
    final modelosMatematicos =
        await (_bancoDados.select(_bancoDados.especiesModelos)
              ..where((tabela) => tabela.especieId.equals(especieId))
              ..limit(1))
            .get();

    if (modelosMatematicos.isEmpty) return;

    await (_bancoDados.update(_bancoDados.especiesModelos)..where(
          (tabela) =>
              tabela.especieId.equals(especieId) &
              tabela.modeloMatematicoId.equals(modelosMatematicos.first.modeloMatematicoId),
        ))
        .write(const EspeciesModelosCompanion(padrao: Value(true)));
  }
}

String _especieModeloMatematicoCoeficienteId(
  String especieId,
  String modeloMatematicoId,
  String simbolo,
) {
  return '${especieId}_${modeloMatematicoId}_$simbolo';
}

List<String> _normalizarSimbolos(List<String> simbolos) {
  final normalizado = <String>[];

  for (final simbolo in simbolos) {
    final aparado = simbolo.trim();
    if (aparado.isEmpty || normalizado.contains(aparado)) continue;
    normalizado.add(aparado);
  }

  return normalizado;
}

String? _vazioParaNulo(String? valor) {
  final aparado = valor?.trim();
  if (aparado == null || aparado.isEmpty) return null;
  return aparado;
}
