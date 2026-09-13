import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../floresta/calculadora_volume_florestal.dart';

import 'migracao_nomenclatura.dart';

part 'banco_dendro.g.dart';

enum SituacaoLevantamento { planejamento, emAndamento, concluido }

enum SituacaoParcela { pendente, emAndamento, coletada }

enum ChaveVariavelModelo { dap, altura, idade, areaBasal }

enum PosicaoReferenciaParcela { p1, p2, p3, p4 }

@DataClassName('Propriedade')
class Propriedades extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get municipio => text()();
  TextColumn get estado => text().withDefault(const Constant('RS'))();
  RealColumn get areaTotalHa => real()();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('Especie')
class Especies extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text().unique()();
  TextColumn get nomeCientifico => text().nullable()();
  TextColumn get descricao => text().nullable()();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ModeloMatematico')
class ModelosMatematicos extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text().unique()();
  TextColumn get descricao => text().nullable()();
  TextColumn get expressao => text()();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('VariavelModelo')
class VariaveisModelo extends Table {
  TextColumn get id => text()();
  TextColumn get modeloMatematicoId =>
      text().references(ModelosMatematicos, #id, onDelete: KeyAction.cascade)();
  TextColumn get simbolo => text()();
  TextColumn get rotulo => text()();
  TextColumn get unidade => text()();
  TextColumn get origemValor => text()();
  TextColumn get chaveVariavel => textEnum<ChaveVariavelModelo>()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE(modelo_matematico_id, simbolo)'];
}

@DataClassName('CoeficienteModelo')
class CoeficientesModelo extends Table {
  TextColumn get id => text()();
  TextColumn get modeloMatematicoId =>
      text().references(ModelosMatematicos, #id, onDelete: KeyAction.cascade)();
  TextColumn get simbolo => text()();
  TextColumn get rotulo => text()();
  RealColumn get valor => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE(modelo_matematico_id, simbolo)'];
}

@DataClassName('EspecieModelo')
class EspeciesModelos extends Table {
  TextColumn get especieId =>
      text().references(Especies, #id, onDelete: KeyAction.cascade)();
  TextColumn get modeloMatematicoId =>
      text().references(ModelosMatematicos, #id, onDelete: KeyAction.cascade)();
  BoolColumn get padrao => boolean().withDefault(const Constant(false))();
  DateTimeColumn get criadoEm => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {especieId, modeloMatematicoId};
}

@DataClassName('CoeficienteEspecieModelo')
class CoeficientesEspecieModelo extends Table {
  TextColumn get id => text()();
  TextColumn get especieId =>
      text().references(Especies, #id, onDelete: KeyAction.cascade)();
  TextColumn get modeloMatematicoId =>
      text().references(ModelosMatematicos, #id, onDelete: KeyAction.cascade)();
  TextColumn get simbolo => text()();
  TextColumn get rotulo => text()();
  RealColumn get valor => real().nullable()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'UNIQUE(especie_id, modelo_matematico_id, simbolo)',
  ];
}

@DataClassName('Talhao')
class Talhoes extends Table {
  TextColumn get id => text()();
  TextColumn get propriedadeId =>
      text().references(Propriedades, #id, onDelete: KeyAction.cascade)();
  TextColumn get identificacao => text()();
  TextColumn get especieId =>
      text().references(Especies, #id, onDelete: KeyAction.restrict)();
  RealColumn get areaHa => real()();
  IntColumn get anoPlantio => integer().nullable()();
  TextColumn get espacamento => text().nullable()();
  TextColumn get regimeManejo => text().nullable()();
  RealColumn get larguraParcelaM => real().nullable()();
  RealColumn get comprimentoParcelaM => real().nullable()();
  TextColumn get observacoes => text().nullable()();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE(propriedade_id, identificacao)'];
}

@DataClassName('Levantamento')
class Levantamentos extends Table {
  TextColumn get id => text()();
  TextColumn get propriedadeId =>
      text().references(Propriedades, #id, onDelete: KeyAction.cascade)();
  TextColumn get situacao => textEnum<SituacaoLevantamento>()();
  DateTimeColumn get iniciadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();
  DateTimeColumn get concluidoEm => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TalhaoLevantamento')
class TalhaoLevantamentos extends Table {
  TextColumn get id => text()();
  TextColumn get levantamentoId =>
      text().references(Levantamentos, #id, onDelete: KeyAction.cascade)();
  TextColumn get talhaoId =>
      text().references(Talhoes, #id, onDelete: KeyAction.cascade)();
  TextColumn get especieId =>
      text().references(Especies, #id, onDelete: KeyAction.restrict)();
  TextColumn get modeloMatematicoId =>
      text().references(ModelosMatematicos, #id, onDelete: KeyAction.restrict)();
  RealColumn get areaPadraoParcelaHa => real().nullable()();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE(levantamento_id, talhao_id)'];
}

@DataClassName('CoeficienteTalhaoLevantamento')
class CoeficientesTalhaoLevantamento extends Table {
  TextColumn get id => text()();
  TextColumn get talhaoLevantamentoId => text().references(
    TalhaoLevantamentos,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get simbolo => text()();
  TextColumn get rotulo => text()();
  RealColumn get valor => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'UNIQUE(talhao_levantamento_id, simbolo)',
  ];
}

@DataClassName('Parcela')
class Parcelas extends Table {
  TextColumn get id => text()();
  TextColumn get talhaoLevantamentoId => text().references(
    TalhaoLevantamentos,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get identificacao => text()();
  TextColumn get situacao => textEnum<SituacaoParcela>()();
  RealColumn get areaHa => real().nullable()();
  TextColumn get posicaoReferencia =>
      textEnum<PosicaoReferenciaParcela>().nullable()();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'UNIQUE(talhao_levantamento_id, identificacao)',
  ];
}

@DataClassName('PontoGeograficoParcela')
class PontosGeograficosParcela extends Table {
  TextColumn get id => text()();
  TextColumn get parcelaId =>
      text().references(Parcelas, #id, onDelete: KeyAction.cascade)();
  IntColumn get ordemPonto => integer()();
  TextColumn get posicaoReferencia =>
      textEnum<PosicaoReferenciaParcela>().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get precisaoMetros => real().nullable()();
  DateTimeColumn get capturadoEm => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE(parcela_id, ordem_ponto)'];
}

@DataClassName('Arvore')
class Arvores extends Table {
  TextColumn get id => text()();
  TextColumn get parcelaId =>
      text().references(Parcelas, #id, onDelete: KeyAction.cascade)();
  IntColumn get numero => integer()();
  RealColumn get dapCm => real()();
  RealColumn get alturaM => real()();
  BoolColumn get possuiTroncoTortuoso =>
      boolean().withDefault(const Constant(false))();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get precisaoMetros => real().nullable()();
  DateTimeColumn get localizacaoCapturadaEm => dateTime().nullable()();
  TextColumn get posicaoReferenciaParcela =>
      textEnum<PosicaoReferenciaParcela>().nullable()();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE(parcela_id, numero)'];
}

@DriftDatabase(
  tables: [
    Propriedades,
    Especies,
    ModelosMatematicos,
    VariaveisModelo,
    CoeficientesModelo,
    EspeciesModelos,
    CoeficientesEspecieModelo,
    Talhoes,
    Levantamentos,
    TalhaoLevantamentos,
    Parcelas,
    PontosGeograficosParcela,
    Arvores,
  ],
)
class BancoDendro extends _$BancoDendro {
  BancoDendro([QueryExecutor? executor])
    : super(executor ?? _abrirConexao());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _criarTabelaCoeficientesTalhao();
      await _criarTabelaRegistrosAtividade();
      await carregarCatalogosIniciais();
    },
    onUpgrade: (m, de, para) async {
      await transaction(() async {
        if (de < 10) await migrarNomenclaturaParaPortugues(this);
      if (de < 2) {
        await _criarTabelaCoeficientesTalhao();
      }
      if (de < 3) {
        await _criarTabelaRegistrosAtividade();
      }
      if (de < 4) {
        await _aplicarEngenheiroModeloMatematicoPadroes();
      }
      if (de < 5) {
        await _aplicarEngenheiroModeloMatematicoPadroes();
      }
      if (de < 6) {
        await _adicionarTalhaoParcelaDimensaoColunas();
      }
      if (de < 7) {
        await m.createTable(coeficientesEspecieModelo);
        await _aplicarEngenheiroModeloMatematicoPadroes();
        await _carregarCatalogoEspecieModeloMatematicoCoeficientePadroes();
      }
      if (de < 8) {
        await _cadastrarModeloFatorForma();
      }
      if (de < 9) {
        await _atualizarModeloFatorForma();
      }
      });
    },
  );

  Future<void> _criarTabelaCoeficientesTalhao() {
    return customStatement('''
CREATE TABLE IF NOT EXISTS coeficientes_talhao_levantamento (
  id TEXT NOT NULL PRIMARY KEY,
  talhao_levantamento_id TEXT NOT NULL REFERENCES talhao_levantamentos(id) ON DELETE CASCADE,
  simbolo TEXT NOT NULL,
  rotulo TEXT NOT NULL,
  valor REAL NULL,
  UNIQUE(talhao_levantamento_id, simbolo)
)
''');
  }

  Future<void> _criarTabelaRegistrosAtividade() {
    return customStatement('''
CREATE TABLE IF NOT EXISTS registros_atividade (
  id TEXT NOT NULL PRIMARY KEY,
  tipo TEXT NOT NULL,
  titulo TEXT NOT NULL,
  subtitulo TEXT NOT NULL DEFAULT '',
  tipo_entidade TEXT NULL,
  entidade_id TEXT NULL,
  ocorrido_em INTEGER NOT NULL
)
''');
  }

  Future<void> _adicionarTalhaoParcelaDimensaoColunas() async {
    await customStatement('ALTER TABLE talhoes ADD COLUMN largura_parcela_m REAL');
    await customStatement('ALTER TABLE talhoes ADD COLUMN comprimento_parcela_m REAL');
  }

  Future<void> _aplicarEngenheiroModeloMatematicoPadroes() async {
    await customUpdate(
      '''
UPDATE coeficientes_modelo
SET valor = ?
WHERE id = ?
  AND valor IS NULL
''',
      variables: [
        const Variable<double>(CalculadoraVolumeFlorestal.padraoSpurrA),
        const Variable<String>('formula_spurr_a'),
      ],
      updates: {coeficientesModelo},
    );
    await customUpdate(
      '''
UPDATE coeficientes_modelo
SET valor = ?
WHERE id = ?
  AND valor IS NULL
''',
      variables: [
        const Variable<double>(CalculadoraVolumeFlorestal.padraoSpurrB),
        const Variable<String>('formula_spurr_b'),
      ],
      updates: {coeficientesModelo},
    );
    await customUpdate(
      '''
UPDATE modelos_matematicos
SET descricao = ?
WHERE id = ?
  AND (descricao IS NULL OR descricao = ?)
''',
      variables: [
        const Variable<String>(
          'Modelo volumétrico usado como padrão para Pinus e Eucalyptus no inventário de referência.',
        ),
        const Variable<String>('formula_spurr'),
        const Variable<String>('Modelo volumétrico configurável.'),
      ],
      updates: {modelosMatematicos},
    );
    await customUpdate(
      '''
UPDATE modelos_matematicos
SET descricao = ?
WHERE id = ?
  AND (descricao IS NULL OR descricao = ?)
''',
      variables: [
        const Variable<String>(
          'Modelo volumétrico ajustado a partir dos dados de cubagem do inventário de referência.',
        ),
        const Variable<String>('formula_schumacher_hall'),
        const Variable<String>('Modelo volumétrico logarítmico.'),
      ],
      updates: {modelosMatematicos},
    );
    await customUpdate(
      '''
UPDATE coeficientes_modelo
SET valor = ?
WHERE id = ?
  AND valor IS NULL
''',
      variables: [
        const Variable<double>(CalculadoraVolumeFlorestal.padraoSchumacherHallA),
        const Variable<String>('formula_schumacher_hall_a'),
      ],
      updates: {coeficientesModelo},
    );
    await customUpdate(
      '''
UPDATE coeficientes_modelo
SET valor = ?
WHERE id = ?
  AND valor IS NULL
''',
      variables: [
        const Variable<double>(CalculadoraVolumeFlorestal.padraoSchumacherHallB),
        const Variable<String>('formula_schumacher_hall_b'),
      ],
      updates: {coeficientesModelo},
    );
    await customUpdate(
      '''
UPDATE coeficientes_modelo
SET valor = ?
WHERE id = ?
  AND valor IS NULL
''',
      variables: [
        const Variable<double>(CalculadoraVolumeFlorestal.padraoSchumacherHallC),
        const Variable<String>('formula_schumacher_hall_c'),
      ],
      updates: {coeficientesModelo},
    );
  }

  Future<void> carregarCatalogosIniciais() async {
    final agora = DateTime.now();

    await batch((lote) {
      lote.insertAllOnConflictUpdate(especies, [
        EspeciesCompanion.insert(
          id: 'species_pinus',
          nome: 'Pinus',
          nomeCientifico: const Value('Pinus spp.'),
          descricao: const Value('Cadastro base para florestas de Pinus.'),
          criadoEm: agora,
          atualizadoEm: agora,
        ),
        EspeciesCompanion.insert(
          id: 'species_eucalyptus',
          nome: 'Eucalyptus',
          nomeCientifico: const Value('Eucalyptus spp.'),
          descricao: const Value(
            'Cadastro base para florestas de Eucalyptus/Eucalipto.',
          ),
          criadoEm: agora,
          atualizadoEm: agora,
        ),
      ]);

      lote.insertAllOnConflictUpdate(modelosMatematicos, [
        ModelosMatematicosCompanion.insert(
          id: 'formula_spurr',
          nome: 'Modelo de Spurr',
          descricao: const Value(
            'Modelo volumétrico usado como padrão para Pinus e Eucalyptus no inventário de referência.',
          ),
          expressao: 'a + b * (D^2 * H)',
          criadoEm: agora,
          atualizadoEm: agora,
        ),
        ModelosMatematicosCompanion.insert(
          id: 'formula_schumacher_hall',
          nome: 'Schumacher-Hall',
          descricao: const Value(
            'Modelo volumétrico ajustado a partir dos dados de cubagem do inventário de referência.',
          ),
          expressao: 'exp(a + b * ln(D) + c * ln(H))',
          criadoEm: agora,
          atualizadoEm: agora,
        ),
      ]);

      lote.insertAllOnConflictUpdate(variaveisModelo, [
        _variavel(
          id: 'formula_spurr_dap',
          modeloMatematicoId: 'formula_spurr',
          simbolo: 'D',
          rotulo: 'DAP',
          unidade: 'cm',
          origemValor: 'Medição da árvore',
          chaveVariavel: ChaveVariavelModelo.dap,
        ),
        _variavel(
          id: 'formula_spurr_height',
          modeloMatematicoId: 'formula_spurr',
          simbolo: 'H',
          rotulo: 'Altura',
          unidade: 'm',
          origemValor: 'Medição da árvore',
          chaveVariavel: ChaveVariavelModelo.altura,
        ),
        _variavel(
          id: 'formula_schumacher_hall_dap',
          modeloMatematicoId: 'formula_schumacher_hall',
          simbolo: 'D',
          rotulo: 'DAP',
          unidade: 'cm',
          origemValor: 'Medição da árvore',
          chaveVariavel: ChaveVariavelModelo.dap,
        ),
        _variavel(
          id: 'formula_schumacher_hall_height',
          modeloMatematicoId: 'formula_schumacher_hall',
          simbolo: 'H',
          rotulo: 'Altura',
          unidade: 'm',
          origemValor: 'Medição da árvore',
          chaveVariavel: ChaveVariavelModelo.altura,
        ),
      ]);

      lote.insertAllOnConflictUpdate(coeficientesModelo, [
        _coeficiente(
          id: 'formula_spurr_a',
          modeloMatematicoId: 'formula_spurr',
          simbolo: 'a',
          rotulo: 'Coeficiente a',
          valor: CalculadoraVolumeFlorestal.padraoSpurrA,
        ),
        _coeficiente(
          id: 'formula_spurr_b',
          modeloMatematicoId: 'formula_spurr',
          simbolo: 'b',
          rotulo: 'Coeficiente b',
          valor: CalculadoraVolumeFlorestal.padraoSpurrB,
        ),
        _coeficiente(
          id: 'formula_schumacher_hall_a',
          modeloMatematicoId: 'formula_schumacher_hall',
          simbolo: 'a',
          rotulo: 'Coeficiente a',
          valor: CalculadoraVolumeFlorestal.padraoSchumacherHallA,
        ),
        _coeficiente(
          id: 'formula_schumacher_hall_b',
          modeloMatematicoId: 'formula_schumacher_hall',
          simbolo: 'b',
          rotulo: 'Coeficiente b',
          valor: CalculadoraVolumeFlorestal.padraoSchumacherHallB,
        ),
        _coeficiente(
          id: 'formula_schumacher_hall_c',
          modeloMatematicoId: 'formula_schumacher_hall',
          simbolo: 'c',
          rotulo: 'Coeficiente c',
          valor: CalculadoraVolumeFlorestal.padraoSchumacherHallC,
        ),
      ]);

      lote.insertAllOnConflictUpdate(especiesModelos, [
        EspeciesModelosCompanion.insert(
          especieId: 'species_pinus',
          modeloMatematicoId: 'formula_spurr',
          padrao: const Value(true),
          criadoEm: agora,
        ),
        EspeciesModelosCompanion.insert(
          especieId: 'species_pinus',
          modeloMatematicoId: 'formula_schumacher_hall',
          criadoEm: agora,
        ),
        EspeciesModelosCompanion.insert(
          especieId: 'species_eucalyptus',
          modeloMatematicoId: 'formula_spurr',
          padrao: const Value(true),
          criadoEm: agora,
        ),
        EspeciesModelosCompanion.insert(
          especieId: 'species_eucalyptus',
          modeloMatematicoId: 'formula_schumacher_hall',
          criadoEm: agora,
        ),
      ]);
    });

    await _aplicarEngenheiroModeloMatematicoPadroes();
    await _carregarCatalogoEspecieModeloMatematicoCoeficientePadroes();
    await _cadastrarModeloFatorForma();
  }

  Future<void> _cadastrarModeloFatorForma() async {
    const modeloMatematicoId = CalculadoraVolumeFlorestal.modeloFatorFormaId;
    final agora = DateTime.now();
    await into(modelosMatematicos).insert(
      ModelosMatematicosCompanion.insert(
        id: modeloMatematicoId,
        nome: 'Fator de Forma',
        expressao: CalculadoraVolumeFlorestal.expressaoFatorForma,
        descricao: const Value(
          'DAP informado em centímetros, convertido para metros no cálculo '
          '(D / 100). Altura em metros e fator de forma (ff) informado pelo usuário.',
        ),
        criadoEm: agora,
        atualizadoEm: agora,
      ),
      mode: InsertMode.insertOrIgnore,
    );
    for (final variavel in [
      _variavel(
        id: '${modeloMatematicoId}_dap',
        modeloMatematicoId: modeloMatematicoId,
        simbolo: 'D',
        rotulo: 'DAP',
        unidade: 'cm',
        origemValor: 'Medição da árvore',
        chaveVariavel: ChaveVariavelModelo.dap,
      ),
      _variavel(
        id: '${modeloMatematicoId}_height',
        modeloMatematicoId: modeloMatematicoId,
        simbolo: 'H',
        rotulo: 'Altura',
        unidade: 'm',
        origemValor: 'Medição da árvore',
        chaveVariavel: ChaveVariavelModelo.altura,
      ),
    ]) {
      await into(
        variaveisModelo,
      ).insert(variavel, mode: InsertMode.insertOrIgnore);
    }
    await into(coeficientesModelo).insert(
      _coeficiente(
        id: '${modeloMatematicoId}_ff',
        modeloMatematicoId: modeloMatematicoId,
        simbolo: 'ff',
        rotulo: 'Fator de forma',
      ),
      mode: InsertMode.insertOrIgnore,
    );
    final baseEspecie =
        await (select(especies)..where(
              (tabela) => tabela.id.isIn(['species_pinus', 'species_eucalyptus']),
            ))
            .get();
    for (final item in baseEspecie) {
      await into(especiesModelos).insert(
        EspeciesModelosCompanion.insert(
          especieId: item.id,
          modeloMatematicoId: modeloMatematicoId,
          criadoEm: agora,
        ),
        mode: InsertMode.insertOrIgnore,
      );
      await into(coeficientesEspecieModelo).insert(
        CoeficientesEspecieModeloCompanion.insert(
          id: _especieModeloMatematicoCoeficienteId(item.id, modeloMatematicoId, 'ff'),
          especieId: item.id,
          modeloMatematicoId: modeloMatematicoId,
          simbolo: 'ff',
          rotulo: 'Fator de forma',
          atualizadoEm: agora,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  Future<void> _atualizarModeloFatorForma() async {
    const id = CalculadoraVolumeFlorestal.modeloFatorFormaId;
    await (update(modelosMatematicos)..where((tabela) => tabela.id.equals(id))).write(
      ModelosMatematicosCompanion(
        nome: const Value('Fator de Forma'),
        expressao: const Value(CalculadoraVolumeFlorestal.expressaoFatorForma),
        descricao: const Value(
          'DAP informado em centímetros, convertido para metros no cálculo '
          '(D / 100). Altura em metros e fator de forma (ff) informado pelo usuário.',
        ),
        atualizadoEm: Value(DateTime.now()),
      ),
    );
    for (final tabela in [
      'coeficientes_modelo',
      'coeficientes_especie_modelo',
      'coeficientes_talhao_levantamento',
    ]) {
      await customStatement(
        'UPDATE $tabela SET rotulo = ? WHERE simbolo = ? AND rotulo = ?',
        ['Fator de forma', 'ff', 'Fator de fórmula'],
      );
    }
  }

  Future<void> _carregarCatalogoEspecieModeloMatematicoCoeficientePadroes() async {
    final agora = DateTime.now();
    final vinculos = await select(especiesModelos).get();

    for (final vinculo in vinculos) {
      final coeficientes =
          await (select(coeficientesModelo)
                ..where((tabela) => tabela.modeloMatematicoId.equals(vinculo.modeloMatematicoId))
                ..orderBy([(tabela) => OrderingTerm.asc(tabela.simbolo)]))
              .get();

      for (final coeficiente in coeficientes) {
        await into(coeficientesEspecieModelo).insertOnConflictUpdate(
          CoeficientesEspecieModeloCompanion.insert(
            id: _especieModeloMatematicoCoeficienteId(
              vinculo.especieId,
              vinculo.modeloMatematicoId,
              coeficiente.simbolo,
            ),
            especieId: vinculo.especieId,
            modeloMatematicoId: vinculo.modeloMatematicoId,
            simbolo: coeficiente.simbolo,
            rotulo: coeficiente.rotulo,
            valor: Value(
              coeficiente.valor ??
                  CalculadoraVolumeFlorestal.valorPadraoCoeficiente(
                    modeloMatematicoId: vinculo.modeloMatematicoId,
                    simbolo: coeficiente.simbolo,
                  ),
            ),
            atualizadoEm: agora,
          ),
        );
      }
    }
  }
}

VariaveisModeloCompanion _variavel({
  required String id,
  required String modeloMatematicoId,
  required String simbolo,
  required String rotulo,
  required String unidade,
  required String origemValor,
  required ChaveVariavelModelo chaveVariavel,
}) {
  return VariaveisModeloCompanion.insert(
    id: id,
    modeloMatematicoId: modeloMatematicoId,
    simbolo: simbolo,
    rotulo: rotulo,
    unidade: unidade,
    origemValor: origemValor,
    chaveVariavel: chaveVariavel,
  );
}

CoeficientesModeloCompanion _coeficiente({
  required String id,
  required String modeloMatematicoId,
  required String simbolo,
  required String rotulo,
  double? valor,
}) {
  return CoeficientesModeloCompanion.insert(
    id: id,
    modeloMatematicoId: modeloMatematicoId,
    simbolo: simbolo,
    rotulo: rotulo,
    valor: Value(valor),
  );
}

String _especieModeloMatematicoCoeficienteId(
  String especieId,
  String modeloMatematicoId,
  String simbolo,
) {
  return '${especieId}_${modeloMatematicoId}_$simbolo';
}

QueryExecutor _abrirConexao() => driftDatabase(name: 'dendro_mobile');
