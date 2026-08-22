import 'package:dendro_mobile/app/dendro_app.dart';
import 'package:dendro_mobile/app/theme/dendro_theme.dart';
import 'package:dendro_mobile/core/database/dendro_database.dart';
import 'package:dendro_mobile/core/providers/database_providers.dart';
import 'package:dendro_mobile/features/home/presentation/home_screen.dart';
import 'package:dendro_mobile/features/inventory_runs/presentation/new_inventory_screen.dart';
import 'package:dendro_mobile/features/plots/data/plots_repository.dart';
import 'package:dendro_mobile/features/properties/data/properties_repository.dart';
import 'package:dendro_mobile/features/settings/data/settings_repository.dart';
import 'package:dendro_mobile/features/settings/presentation/settings_screen.dart';
import 'package:dendro_mobile/features/shell/presentation/dendro_shell.dart';
import 'package:dendro_mobile/features/stands/data/stands_repository.dart';
import 'package:dendro_mobile/features/tree_collection/data/trees_repository.dart';
import 'package:dendro_mobile/shared/widgets/dendro_widgets.dart';
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
    for (var attempt = 0; attempt < 30; attempt++) {
      if (find.text('Novo Levantamento').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 300));
    }

    expect(find.text('Novo Levantamento'), findsOneWidget);
    expect(find.text('Nenhum levantamento em andamento'), findsOneWidget);
    expect(find.text('Continuar Coleta'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('card claro preserva texto legivel no modo escuro', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: DendroTheme.dark,
        home: const Scaffold(body: DendroCard(child: Text('Titulo do card'))),
      ),
    );

    final textContext = tester.element(find.text('Titulo do card'));

    expect(DefaultTextStyle.of(textContext).style.color, DendroColors.text);
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

  testWidgets('home mostra talhao no card e resumo total do levantamento', (
    tester,
  ) async {
    final database = DendroDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.runAsync(() async {
      final propertiesRepository = PropertiesRepository(database);
      final standsRepository = StandsRepository(database);
      final plotsRepository = PlotsRepository(database);
      final treesRepository = TreesRepository(database);

      final propertyId = await propertiesRepository.create(
        name: 'Fazenda Total',
        municipality: 'Vacaria',
        totalAreaHa: 40,
      );
      final species = await standsRepository.watchActiveSpecies().first;
      final pinus = species.firstWhere((item) => item.name == 'Pinus');

      final firstStandId = await standsRepository.create(
        propertyId: propertyId,
        identification: 'T-01',
        speciesId: pinus.id,
        areaHa: 12,
      );
      final secondStandId = await standsRepository.create(
        propertyId: propertyId,
        identification: 'T-02',
        speciesId: pinus.id,
        areaHa: 8,
      );

      final firstTalhao = await plotsRepository.startNewInventoryForStand(
        firstStandId,
      );
      final firstPlotId = await plotsRepository.createPlotForTalhaoLevantamento(
        talhaoLevantamentoId: firstTalhao.id,
        areaHa: 0.04,
      );
      await treesRepository.createTree(
        plotId: firstPlotId,
        draft: const TreeDraft(dapCm: 20, heightM: 12, hasTortuousStem: false),
      );
      await treesRepository.createTree(
        plotId: firstPlotId,
        draft: const TreeDraft(dapCm: 22, heightM: 13, hasTortuousStem: false),
      );

      final secondTalhao = await plotsRepository.startNewInventoryForStand(
        secondStandId,
      );
      final secondPlotId = await plotsRepository
          .createPlotForTalhaoLevantamento(
            talhaoLevantamentoId: secondTalhao.id,
            areaHa: 0.05,
          );
      await treesRepository.createTree(
        plotId: secondPlotId,
        draft: const TreeDraft(dapCm: 25, heightM: 14, hasTortuousStem: false),
      );
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

    expect(find.text('T-01'), findsOneWidget);
    expect(find.text('Continuar Coleta'), findsOneWidget);
    expect(find.text('Resumo do levantamento'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('0,04 ha'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('0,09 ha'), findsOneWidget);

    await tester.tap(find.text('Continuar Coleta'));
    await tester.pumpAndSettle();

    expect(find.text('Parcelas'), findsWidgets);
    expect(find.text('Talhões do levantamento'), findsNothing);

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

  testWidgets('novo talhao no levantamento permite ajustar modelo', (
    tester,
  ) async {
    final database = DendroDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.runAsync(() async {
      final propertiesRepository = PropertiesRepository(database);

      await propertiesRepository.create(
        name: 'Fazenda Modelo',
        municipality: 'Vacaria',
        totalAreaHa: 30,
      );
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dendroDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          theme: DendroTheme.light,
          home: const NewInventoryScreen(),
        ),
      ),
    );
    for (var attempt = 0; attempt < 20; attempt++) {
      if (find.text('Fazenda Modelo').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 100));
    }

    await tester.tap(find.widgetWithText(OutlinedButton, 'Novo talhão'));
    await tester.pumpAndSettle();

    expect(find.text('Cadastrar talhão'), findsOneWidget);
    expect(find.text('Modelo matemático'), findsOneWidget);
    expect(find.text('Ajustar modelo matemático'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('ajuste de modelo mostra apenas formulas vinculadas a especie', (
    tester,
  ) async {
    final database = DendroDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.runAsync(() async {
      final settingsRepository = SettingsRepository(database);
      final propertiesRepository = PropertiesRepository(database);
      final standsRepository = StandsRepository(database);

      await settingsRepository.setSpeciesFormulaLinked(
        speciesId: 'species_pinus',
        formulaId: 'formula_schumacher_hall',
        linked: false,
      );

      final propertyId = await propertiesRepository.create(
        name: 'Fazenda Vinculos',
        municipality: 'Vacaria',
        totalAreaHa: 30,
      );
      await standsRepository.create(
        propertyId: propertyId,
        identification: 'T-01',
        speciesId: 'species_pinus',
        areaHa: 10,
      );
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dendroDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          theme: DendroTheme.light,
          home: const NewInventoryScreen(),
        ),
      ),
    );
    for (var attempt = 0; attempt < 20; attempt++) {
      if (find.text('Ajustar modelo matemático').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 100));
    }

    await tester.tap(find.text('Ajustar modelo matemático'));
    await tester.pumpAndSettle();
    for (var attempt = 0; attempt < 20; attempt++) {
      if (find.text('Modelo de Spurr').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Modelo de Spurr'), findsOneWidget);
    expect(find.text('Schumacher-Hall'), findsNothing);

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

  testWidgets('ajustes navega para especies e modelos do catalogo', (
    tester,
  ) async {
    final database = DendroDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dendroDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          theme: DendroTheme.light,
          home: const Scaffold(body: SettingsScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('Modo escuro'), findsOneWidget);
    expect(find.text('Cadastro de espécies'), findsOneWidget);
    expect(find.text('Modelos matemáticos'), findsOneWidget);
    expect(find.text('Nova espécie'), findsNothing);
    expect(find.text('Nova fórmula'), findsNothing);

    await tester.tap(find.text('Cadastro de espécies'));
    await tester.pumpAndSettle();

    expect(find.text('Cadastro de espécies'), findsOneWidget);
    expect(find.text('Espécies cadastradas'), findsOneWidget);
    expect(find.text('Pinus'), findsOneWidget);
    expect(find.byTooltip('Voltar'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();

    expect(find.text('Ajustes'), findsOneWidget);

    await tester.tap(find.text('Modelos matemáticos'));
    await tester.pumpAndSettle();

    expect(find.text('Fórmulas cadastradas'), findsOneWidget);
    expect(find.text('Modelo de Spurr'), findsOneWidget);
    expect(find.text('Schumacher-Hall'), findsOneWidget);
    expect(find.byTooltip('Voltar'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

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
