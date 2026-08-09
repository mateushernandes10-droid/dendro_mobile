import 'package:dendro_mobile/core/database/dendro_database.dart';
import 'package:dendro_mobile/features/properties/data/properties_repository.dart';
import 'package:dendro_mobile/features/stands/data/stands_repository.dart';
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

    final id = await repository.create(
      name: 'Fazenda Esperança',
      municipality: 'Vacaria',
      totalAreaHa: 158.17,
    );

    final results = await repository.searchByName('Esperança');

    expect(results, hasLength(1));
    expect(results.single.name, 'Fazenda Esperança');
    expect(results.single.state, 'RS');
    expect(results.single.totalAreaHa, 158.17);

    await repository.update(
      id: id,
      name: 'Fazenda Esperança Editada',
      municipality: 'Vacaria',
      state: 'RS',
      totalAreaHa: 160,
    );

    final updated = await repository.findById(id);
    expect(updated?.name, 'Fazenda Esperança Editada');
    expect(updated?.totalAreaHa, 160);

    await repository.delete(id);
    expect(await repository.searchByName('Esperança'), isEmpty);
  });

  test(
    'repositorio cadastra talhao vinculado a propriedade e especie',
    () async {
      final propertiesRepository = PropertiesRepository(database);
      final standsRepository = StandsRepository(database);

      final propertyId = await propertiesRepository.create(
        name: 'Fazenda Esperança',
        municipality: 'Vacaria',
        totalAreaHa: 158.17,
      );
      final species = await standsRepository.watchActiveSpecies().first;
      final pinus = species.firstWhere((item) => item.name == 'Pinus');

      await standsRepository.create(
        propertyId: propertyId,
        identification: 'Talhão 42-B',
        speciesId: pinus.id,
        areaHa: 45.2,
        plantingYear: 2012,
        spacing: '3 x 2 m',
      );

      final stands = await standsRepository.watchByProperty(propertyId).first;

      expect(stands, hasLength(1));
      expect(stands.single.stand.identification, 'Talhão 42-B');
      expect(stands.single.stand.areaHa, 45.2);
      expect(stands.single.stand.plantingYear, 2012);
      expect(stands.single.species.name, 'Pinus');
    },
  );
}
