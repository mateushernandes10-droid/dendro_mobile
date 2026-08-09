import 'package:dendro_mobile/core/database/dendro_database.dart';
import 'package:dendro_mobile/features/properties/data/properties_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DendroDatabase database;

  setUp(() {
    database = DendroDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('cria catalogos iniciais de especies e formulas', () async {
    final species = await database.select(database.species).get();
    final formulas = await database.select(database.formulas).get();
    final variables = await database.select(database.formulaVariables).get();
    final coefficients = await database
        .select(database.formulaCoefficients)
        .get();

    expect(
      species.map((item) => item.name),
      containsAll(['Pinus', 'Eucalyptus']),
    );
    expect(
      formulas.map((item) => item.name),
      containsAll(['Modelo de Spurr', 'Schumacher-Hall']),
    );
    expect(variables, hasLength(4));
    expect(coefficients, hasLength(5));
  });

  test('repositorio cadastra e busca propriedade', () async {
    final repository = PropertiesRepository(database);

    await repository.create(
      name: 'Fazenda Esperança',
      municipality: 'Vacaria',
      totalAreaHa: 158.17,
    );

    final results = await repository.searchByName('Esperança');

    expect(results, hasLength(1));
    expect(results.single.name, 'Fazenda Esperança');
    expect(results.single.state, 'RS');
    expect(results.single.totalAreaHa, 158.17);
  });
}
