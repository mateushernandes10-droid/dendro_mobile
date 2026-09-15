import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'catalogos_iniciais.dart';
import 'migracao_ids_inteiros.dart';
part 'banco_dendro.g.dart';

enum SituacaoLevantamento { planejamento, emAndamento, concluido }

enum SituacaoParcela { pendente, emAndamento, coletada }

enum ChaveVariavelModelo { dap, altura, idade, areaBasal }

enum PosicaoReferenciaParcela { p1, p2, p3, p4 }

@DataClassName('Propriedade')
class Propriedades extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get municipio => text()();
  TextColumn get estado => text().withDefault(const Constant('RS'))();
  RealColumn get areaTotalHa => real()();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();
}

@DataClassName('Especie')
class Especies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text().nullable().unique()();
  TextColumn get nome => text().unique()();
  TextColumn get nomeCientifico => text().nullable()();
  TextColumn get descricao => text().nullable()();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();
}

@DataClassName('ModeloMatematico')
class ModelosMatematicos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text().nullable().unique()();
  TextColumn get nome => text().unique()();
  TextColumn get descricao => text().nullable()();
  TextColumn get expressao => text()();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();
}

@DataClassName('VariavelModelo')
class VariaveisModelo extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get modeloMatematicoId => integer().references(
    ModelosMatematicos,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get simbolo => text()();
  TextColumn get rotulo => text()();
  TextColumn get unidade => text()();
  TextColumn get origemValor => text()();
  TextColumn get chaveVariavel => textEnum<ChaveVariavelModelo>()();

  @override
  List<String> get customConstraints => [
    'UNIQUE(modelo_matematico_id, simbolo)',
  ];
}

@DataClassName('CoeficienteModelo')
class CoeficientesModelo extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get modeloMatematicoId => integer().references(
    ModelosMatematicos,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get simbolo => text()();
  TextColumn get rotulo => text()();
  RealColumn get valor => real().nullable()();

  @override
  List<String> get customConstraints => [
    'UNIQUE(modelo_matematico_id, simbolo)',
  ];
}

@DataClassName('EspecieModelo')
class EspeciesModelos extends Table {
  IntColumn get especieId =>
      integer().references(Especies, #id, onDelete: KeyAction.cascade)();
  IntColumn get modeloMatematicoId => integer().references(
    ModelosMatematicos,
    #id,
    onDelete: KeyAction.cascade,
  )();
  BoolColumn get padrao => boolean().withDefault(const Constant(false))();
  DateTimeColumn get criadoEm => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {especieId, modeloMatematicoId};
}

@DataClassName('CoeficienteEspecieModelo')
class CoeficientesEspecieModelo extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get especieId =>
      integer().references(Especies, #id, onDelete: KeyAction.cascade)();
  IntColumn get modeloMatematicoId => integer().references(
    ModelosMatematicos,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get simbolo => text()();
  TextColumn get rotulo => text()();
  RealColumn get valor => real().nullable()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  List<String> get customConstraints => [
    'UNIQUE(especie_id, modelo_matematico_id, simbolo)',
  ];
}

@DataClassName('Talhao')
class Talhoes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get propriedadeId =>
      integer().references(Propriedades, #id, onDelete: KeyAction.cascade)();
  TextColumn get identificacao => text()();
  IntColumn get especieId =>
      integer().references(Especies, #id, onDelete: KeyAction.restrict)();
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
  List<String> get customConstraints => [
    'UNIQUE(propriedade_id, identificacao)',
  ];
}

@DataClassName('Levantamento')
class Levantamentos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get propriedadeId =>
      integer().references(Propriedades, #id, onDelete: KeyAction.cascade)();
  TextColumn get situacao => textEnum<SituacaoLevantamento>()();
  DateTimeColumn get iniciadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();
  DateTimeColumn get concluidoEm => dateTime().nullable()();
}

@DataClassName('TalhaoLevantamento')
class TalhaoLevantamentos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get levantamentoId =>
      integer().references(Levantamentos, #id, onDelete: KeyAction.cascade)();
  IntColumn get talhaoId =>
      integer().references(Talhoes, #id, onDelete: KeyAction.cascade)();
  IntColumn get especieId =>
      integer().references(Especies, #id, onDelete: KeyAction.restrict)();
  IntColumn get modeloMatematicoId => integer().references(
    ModelosMatematicos,
    #id,
    onDelete: KeyAction.restrict,
  )();
  RealColumn get areaPadraoParcelaHa => real().nullable()();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  List<String> get customConstraints => ['UNIQUE(levantamento_id, talhao_id)'];
}

@DataClassName('CoeficienteTalhaoLevantamento')
class CoeficientesTalhaoLevantamento extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get talhaoLevantamentoId => integer().references(
    TalhaoLevantamentos,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get simbolo => text()();
  TextColumn get rotulo => text()();
  RealColumn get valor => real().nullable()();

  @override
  List<String> get customConstraints => [
    'UNIQUE(talhao_levantamento_id, simbolo)',
  ];
}

@DataClassName('AtividadeBanco')
class RegistrosAtividade extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tipo => text()();
  TextColumn get titulo => text()();
  TextColumn get subtitulo => text().withDefault(const Constant(''))();
  TextColumn get tipoEntidade => text().nullable()();
  IntColumn get entidadeId => integer().nullable()();
  DateTimeColumn get ocorridoEm => dateTime()();
}

@DataClassName('Parcela')
class Parcelas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get talhaoLevantamentoId => integer().references(
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
  List<String> get customConstraints => [
    'UNIQUE(talhao_levantamento_id, identificacao)',
  ];
}

@DataClassName('PontoGeograficoParcela')
class PontosGeograficosParcela extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get parcelaId =>
      integer().references(Parcelas, #id, onDelete: KeyAction.cascade)();
  IntColumn get ordemPonto => integer()();
  TextColumn get posicaoReferencia =>
      textEnum<PosicaoReferenciaParcela>().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get precisaoMetros => real().nullable()();
  DateTimeColumn get capturadoEm => dateTime()();

  @override
  List<String> get customConstraints => ['UNIQUE(parcela_id, ordem_ponto)'];
}

@DataClassName('Arvore')
class Arvores extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get parcelaId =>
      integer().references(Parcelas, #id, onDelete: KeyAction.cascade)();
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
    CoeficientesTalhaoLevantamento,
    Parcelas,
    PontosGeograficosParcela,
    Arvores,
    RegistrosAtividade,
  ],
)
class BancoDendro extends _$BancoDendro {
  BancoDendro([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'dendro_mobile'));
  @override
  int get schemaVersion => 12;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await carregarCatalogosIniciais();
    },
    onUpgrade: (m, de, para) => migrarParaIdsInteiros(this, m, de),
  );
  Future<void> carregarCatalogosIniciais() => inserirCatalogosIniciais(this);
  Future<String?> codigoModeloPorId(int id) async => (await (select(
    modelosMatematicos,
  )..where((m) => m.id.equals(id))).getSingleOrNull())?.codigo;
}
