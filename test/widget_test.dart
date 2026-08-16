import 'package:dendro_mobile/app/dendro_app.dart';
import 'package:dendro_mobile/app/theme/dendro_theme.dart';
import 'package:dendro_mobile/core/database/dendro_database.dart';
import 'package:dendro_mobile/core/providers/database_providers.dart';
import 'package:dendro_mobile/features/home/presentation/home_screen.dart';
import 'package:dendro_mobile/features/plots/data/plots_repository.dart';
import 'package:dendro_mobile/features/properties/data/properties_repository.dart';
import 'package:dendro_mobile/features/shell/presentation/dendro_shell.dart';
import 'package:dendro_mobile/features/stands/data/stands_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('abre a tela inicial do DENDRO Mobile', (tester) async {
    final database = DendroDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dendroDatabaseProvider.overrideWithValue(database)],
        child: const DendroApp(),
      ),
    );

    expect(find.text('DENDRO'), findsOneWidget);

    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    });
    await tester.pump(const Duration(milliseconds: 2800));
    await tester.pump(const Duration(milliseconds: 400));
    for (var attempt = 0; attempt < 8; attempt++) {
      if (find.text('Novo Levantamento').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 300));
    }

    expect(find.text('Novo Levantamento'), findsOneWidget);
    expect(find.text('Nenhum levantamento em andamento'), findsOneWidget);
    expect(find.text('Continuar Coleta'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('home mostra coleta ativa sem estourar o card', (tester) async {
    final database = DendroDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.runAsync(() async {
      final propertiesRepository = PropertiesRepository(database);
      final standsRepository = StandsRepository(database);
      final plotsRepository = PlotsRepository(database);

      final propertyId = await propertiesRepository.create(
        name: 'Centro',
        municipality: 'Alegria',
        totalAreaHa: 20,
      );
      final species = await standsRepository.watchActiveSpecies().first;
      final pinus = species.firstWhere((item) => item.name == 'Pinus');
      final standId = await standsRepository.create(
        propertyId: propertyId,
        identification: 'Centro',
        speciesId: pinus.id,
        areaHa: 12,
      );
      await plotsRepository.startNewInventoryForStand(standId);
    });

    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dendroDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          theme: DendroTheme.light,
          home: const Scaffold(body: HomeScreen()),
        ),
      ),
    );
    for (var attempt = 0; attempt < 20; attempt++) {
      if (find.text('Continuar Coleta').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Continuar Coleta'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('novo levantamento abre busca e continua talhao em coleta', (
    tester,
  ) async {
    final database = DendroDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.runAsync(() async {
      final propertiesRepository = PropertiesRepository(database);
      final standsRepository = StandsRepository(database);
      final plotsRepository = PlotsRepository(database);

      final propertyId = await propertiesRepository.create(
        name: 'Centro',
        municipality: 'Alegria',
        totalAreaHa: 20,
      );
      final species = await standsRepository.watchActiveSpecies().first;
      final pinus = species.firstWhere((item) => item.name == 'Pinus');
      final standId = await standsRepository.create(
        propertyId: propertyId,
        identification: 'Centro',
        speciesId: pinus.id,
        areaHa: 12,
      );
      await plotsRepository.startNewInventoryForStand(standId);
    });

    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dendroDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          theme: DendroTheme.light,
          home: const Scaffold(body: HomeScreen()),
        ),
      ),
    );
    for (var attempt = 0; attempt < 20; attempt++) {
      if (find.text('Novo Levantamento').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 100));
    }

    await tester.tap(find.text('Novo Levantamento'));
    await tester.pumpAndSettle();
    for (var attempt = 0; attempt < 20; attempt++) {
      if (find.text('Buscar propriedade').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Buscar propriedade'), findsOneWidget);
    expect(find.text('Município'), findsOneWidget);
    expect(find.text('Espécie'), findsOneWidget);
    expect(find.text('Centro'), findsWidgets);
    expect(find.text('Em coleta'), findsOneWidget);
    expect(find.text('Continuar coleta'), findsOneWidget);

    await tester.tap(find.text('Continuar coleta'));
    await tester.pumpAndSettle();
    for (var attempt = 0; attempt < 20; attempt++) {
      if (find.text('Levantamento').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Levantamento'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('barra inferior permanece fixa em telas internas', (
    tester,
  ) async {
    final database = DendroDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.runAsync(() async {
      final propertiesRepository = PropertiesRepository(database);

      await propertiesRepository.create(
        name: 'Fazenda Navegação',
        municipality: 'Vacaria',
        totalAreaHa: 42,
      );
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dendroDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(theme: DendroTheme.light, home: const DendroShell()),
      ),
    );
    await tester.pumpAndSettle();

    var navigationLabels = _navigationLabels(tester);
    expect(navigationLabels, [
      'Início',
      'Levant.',
      'Propr.',
      'Result.',
      'Ajustes',
    ]);

    await tester.tap(find.text('Propr.'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Fazenda Navegação'));
    await tester.pumpAndSettle();

    var navigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(
      navigationBar.labelBehavior,
      NavigationDestinationLabelBehavior.alwaysHide,
    );
    expect(navigationBar.height, 62);
    expect(find.text('Talhões'), findsOneWidget);
    expect(find.text('Buscar propriedade'), findsNothing);

    await tester.tap(find.byIcon(Icons.map));
    await tester.pumpAndSettle();

    navigationBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    navigationLabels = _navigationLabels(tester);
    expect(
      navigationBar.labelBehavior,
      NavigationDestinationLabelBehavior.alwaysShow,
    );
    expect(navigationBar.height, isNull);
    expect(navigationLabels, [
      'Início',
      'Levant.',
      'Propr.',
      'Result.',
      'Ajustes',
    ]);
    expect(find.text('Buscar propriedade'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('barra inferior usa nomes completos em telas largas', (
    tester,
  ) async {
    final database = DendroDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    tester.view.physicalSize = const Size(900, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dendroDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(theme: DendroTheme.light, home: const DendroShell()),
      ),
    );
    await tester.pumpAndSettle();

    expect(_navigationLabels(tester), [
      'Início',
      'Levantamentos',
      'Propriedades',
      'Resultados',
      'Ajustes',
    ]);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}

List<String> _navigationLabels(WidgetTester tester) {
  final navigationBar = tester.widget<NavigationBar>(
    find.byType(NavigationBar),
  );
  return [
    for (final destination in navigationBar.destinations)
      (destination as NavigationDestination).label,
  ];
}
