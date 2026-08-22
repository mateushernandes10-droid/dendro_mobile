import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'dendro_database.g.dart';

enum InventoryRunStatus { planning, inProgress, completed }

enum PlotStatus { pending, inProgress, collected }

enum FormulaVariableKey { dap, height, age, basalArea }

enum PlotReferencePosition { p1, p2, p3, p4 }

@DataClassName('PropertyRecord')
class Properties extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get municipality => text()();
  TextColumn get state => text().withDefault(const Constant('RS'))();
  RealColumn get totalAreaHa => real()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SpeciesRecord')
class Species extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  TextColumn get scientificName => text().nullable()();
  TextColumn get description => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('FormulaRecord')
class Formulas extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  TextColumn get description => text().nullable()();
  TextColumn get expression => text()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('FormulaVariableRecord')
class FormulaVariables extends Table {
  TextColumn get id => text()();
  TextColumn get formulaId =>
      text().references(Formulas, #id, onDelete: KeyAction.cascade)();
  TextColumn get symbol => text()();
  TextColumn get label => text()();
  TextColumn get unit => text()();
  TextColumn get valueSource => text()();
  TextColumn get variableKey => textEnum<FormulaVariableKey>()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE(formula_id, symbol)'];
}

@DataClassName('FormulaCoefficientRecord')
class FormulaCoefficients extends Table {
  TextColumn get id => text()();
  TextColumn get formulaId =>
      text().references(Formulas, #id, onDelete: KeyAction.cascade)();
  TextColumn get symbol => text()();
  TextColumn get label => text()();
  RealColumn get value => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE(formula_id, symbol)'];
}

@DataClassName('SpeciesFormulaRecord')
class SpeciesFormulas extends Table {
  TextColumn get speciesId =>
      text().references(Species, #id, onDelete: KeyAction.cascade)();
  TextColumn get formulaId =>
      text().references(Formulas, #id, onDelete: KeyAction.cascade)();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {speciesId, formulaId};
}

@DataClassName('StandRecord')
class Stands extends Table {
  TextColumn get id => text()();
  TextColumn get propertyId =>
      text().references(Properties, #id, onDelete: KeyAction.cascade)();
  TextColumn get identification => text()();
  TextColumn get speciesId =>
      text().references(Species, #id, onDelete: KeyAction.restrict)();
  RealColumn get areaHa => real()();
  IntColumn get plantingYear => integer().nullable()();
  TextColumn get spacing => text().nullable()();
  TextColumn get managementRegime => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE(property_id, identification)'];
}

@DataClassName('InventoryRunRecord')
class InventoryRuns extends Table {
  TextColumn get id => text()();
  TextColumn get propertyId =>
      text().references(Properties, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => textEnum<InventoryRunStatus>()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TalhaoLevantamentoRecord')
class TalhaoLevantamentos extends Table {
  TextColumn get id => text()();
  TextColumn get inventoryRunId =>
      text().references(InventoryRuns, #id, onDelete: KeyAction.cascade)();
  TextColumn get standId =>
      text().references(Stands, #id, onDelete: KeyAction.cascade)();
  TextColumn get speciesId =>
      text().references(Species, #id, onDelete: KeyAction.restrict)();
  TextColumn get formulaId =>
      text().references(Formulas, #id, onDelete: KeyAction.restrict)();
  RealColumn get defaultPlotAreaHa => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE(inventory_run_id, stand_id)'];
}

@DataClassName('TalhaoFormulaCoefficientRecord')
class TalhaoFormulaCoefficients extends Table {
  TextColumn get id => text()();
  TextColumn get talhaoLevantamentoId => text().references(
    TalhaoLevantamentos,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get symbol => text()();
  TextColumn get label => text()();
  RealColumn get value => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'UNIQUE(talhao_levantamento_id, symbol)',
  ];
}

@DataClassName('PlotRecord')
class Plots extends Table {
  TextColumn get id => text()();
  TextColumn get talhaoLevantamentoId => text().references(
    TalhaoLevantamentos,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get identification => text()();
  TextColumn get status => textEnum<PlotStatus>()();
  RealColumn get areaHa => real().nullable()();
  TextColumn get referencePosition =>
      textEnum<PlotReferencePosition>().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'UNIQUE(talhao_levantamento_id, identification)',
  ];
}

@DataClassName('PlotGeoPointRecord')
class PlotGeoPoints extends Table {
  TextColumn get id => text()();
  TextColumn get plotId =>
      text().references(Plots, #id, onDelete: KeyAction.cascade)();
  IntColumn get pointOrder => integer()();
  TextColumn get referencePosition =>
      textEnum<PlotReferencePosition>().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get accuracyMeters => real().nullable()();
  DateTimeColumn get capturedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE(plot_id, point_order)'];
}

@DataClassName('TreeRecord')
class Trees extends Table {
  TextColumn get id => text()();
  TextColumn get plotId =>
      text().references(Plots, #id, onDelete: KeyAction.cascade)();
  IntColumn get number => integer()();
  RealColumn get dapCm => real()();
  RealColumn get heightM => real()();
  BoolColumn get hasTortuousStem =>
      boolean().withDefault(const Constant(false))();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get accuracyMeters => real().nullable()();
  DateTimeColumn get locationCapturedAt => dateTime().nullable()();
  TextColumn get plotReferencePosition =>
      textEnum<PlotReferencePosition>().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE(plot_id, number)'];
}

@DriftDatabase(
  tables: [
    Properties,
    Species,
    Formulas,
    FormulaVariables,
    FormulaCoefficients,
    SpeciesFormulas,
    Stands,
    InventoryRuns,
    TalhaoLevantamentos,
    TalhaoFormulaCoefficients,
    Plots,
    PlotGeoPoints,
    Trees,
  ],
)
class DendroDatabase extends _$DendroDatabase {
  DendroDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await seedInitialCatalogs();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(talhaoFormulaCoefficients);
      }
    },
  );

  Future<void> seedInitialCatalogs() async {
    final now = DateTime.now();

    await batch((batch) {
      batch.insertAllOnConflictUpdate(species, [
        SpeciesCompanion.insert(
          id: 'species_pinus',
          name: 'Pinus',
          scientificName: const Value('Pinus spp.'),
          description: const Value('Cadastro base para florestas de Pinus.'),
          createdAt: now,
          updatedAt: now,
        ),
        SpeciesCompanion.insert(
          id: 'species_eucalyptus',
          name: 'Eucalyptus',
          scientificName: const Value('Eucalyptus spp.'),
          description: const Value(
            'Cadastro base para florestas de Eucalyptus/Eucalipto.',
          ),
          createdAt: now,
          updatedAt: now,
        ),
      ]);

      batch.insertAllOnConflictUpdate(formulas, [
        FormulasCompanion.insert(
          id: 'formula_spurr',
          name: 'Modelo de Spurr',
          description: const Value('Modelo volumétrico configurável.'),
          expression: 'a + b * (D^2 * H)',
          createdAt: now,
          updatedAt: now,
        ),
        FormulasCompanion.insert(
          id: 'formula_schumacher_hall',
          name: 'Schumacher-Hall',
          description: const Value('Modelo volumétrico logarítmico.'),
          expression: 'exp(a + b * ln(D) + c * ln(H))',
          createdAt: now,
          updatedAt: now,
        ),
      ]);

      batch.insertAllOnConflictUpdate(formulaVariables, [
        _variable(
          id: 'formula_spurr_dap',
          formulaId: 'formula_spurr',
          symbol: 'D',
          label: 'DAP',
          unit: 'cm',
          valueSource: 'Medição da árvore',
          variableKey: FormulaVariableKey.dap,
        ),
        _variable(
          id: 'formula_spurr_height',
          formulaId: 'formula_spurr',
          symbol: 'H',
          label: 'Altura',
          unit: 'm',
          valueSource: 'Medição da árvore',
          variableKey: FormulaVariableKey.height,
        ),
        _variable(
          id: 'formula_schumacher_hall_dap',
          formulaId: 'formula_schumacher_hall',
          symbol: 'D',
          label: 'DAP',
          unit: 'cm',
          valueSource: 'Medição da árvore',
          variableKey: FormulaVariableKey.dap,
        ),
        _variable(
          id: 'formula_schumacher_hall_height',
          formulaId: 'formula_schumacher_hall',
          symbol: 'H',
          label: 'Altura',
          unit: 'm',
          valueSource: 'Medição da árvore',
          variableKey: FormulaVariableKey.height,
        ),
      ]);

      batch.insertAllOnConflictUpdate(formulaCoefficients, [
        _coefficient(
          id: 'formula_spurr_a',
          formulaId: 'formula_spurr',
          symbol: 'a',
          label: 'Coeficiente a',
        ),
        _coefficient(
          id: 'formula_spurr_b',
          formulaId: 'formula_spurr',
          symbol: 'b',
          label: 'Coeficiente b',
        ),
        _coefficient(
          id: 'formula_schumacher_hall_a',
          formulaId: 'formula_schumacher_hall',
          symbol: 'a',
          label: 'Coeficiente a',
        ),
        _coefficient(
          id: 'formula_schumacher_hall_b',
          formulaId: 'formula_schumacher_hall',
          symbol: 'b',
          label: 'Coeficiente b',
        ),
        _coefficient(
          id: 'formula_schumacher_hall_c',
          formulaId: 'formula_schumacher_hall',
          symbol: 'c',
          label: 'Coeficiente c',
        ),
      ]);

      batch.insertAllOnConflictUpdate(speciesFormulas, [
        SpeciesFormulasCompanion.insert(
          speciesId: 'species_pinus',
          formulaId: 'formula_spurr',
          isDefault: const Value(true),
          createdAt: now,
        ),
        SpeciesFormulasCompanion.insert(
          speciesId: 'species_pinus',
          formulaId: 'formula_schumacher_hall',
          createdAt: now,
        ),
        SpeciesFormulasCompanion.insert(
          speciesId: 'species_eucalyptus',
          formulaId: 'formula_spurr',
          isDefault: const Value(true),
          createdAt: now,
        ),
        SpeciesFormulasCompanion.insert(
          speciesId: 'species_eucalyptus',
          formulaId: 'formula_schumacher_hall',
          createdAt: now,
        ),
      ]);
    });
  }
}

FormulaVariablesCompanion _variable({
  required String id,
  required String formulaId,
  required String symbol,
  required String label,
  required String unit,
  required String valueSource,
  required FormulaVariableKey variableKey,
}) {
  return FormulaVariablesCompanion.insert(
    id: id,
    formulaId: formulaId,
    symbol: symbol,
    label: label,
    unit: unit,
    valueSource: valueSource,
    variableKey: variableKey,
  );
}

FormulaCoefficientsCompanion _coefficient({
  required String id,
  required String formulaId,
  required String symbol,
  required String label,
}) {
  return FormulaCoefficientsCompanion.insert(
    id: id,
    formulaId: formulaId,
    symbol: symbol,
    label: label,
  );
}

QueryExecutor _openConnection() => driftDatabase(name: 'dendro_mobile');
