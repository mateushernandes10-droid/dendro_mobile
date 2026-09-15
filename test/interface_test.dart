import 'package:dendro_mobile/aplicativo/aplicativo_dendro.dart';
import 'package:dendro_mobile/aplicativo/tema/tema_dendro.dart';
import 'package:dendro_mobile/nucleo/banco/banco_dendro.dart';
import 'package:dendro_mobile/nucleo/provedores/provedores_banco.dart';
import 'package:dendro_mobile/funcionalidades/inicio/apresentacao/tela_inicio.dart';
import 'package:dendro_mobile/funcionalidades/levantamentos/apresentacao/tela_novo_levantamento.dart';
import 'package:dendro_mobile/funcionalidades/parcelas/dados/repositorio_parcelas.dart';
import 'package:dendro_mobile/funcionalidades/propriedades/dados/repositorio_propriedades.dart';
import 'package:dendro_mobile/funcionalidades/ajustes/dados/repositorio_ajustes.dart';
import 'package:dendro_mobile/funcionalidades/ajustes/apresentacao/tela_ajustes.dart';
import 'package:dendro_mobile/funcionalidades/estrutura/apresentacao/estrutura_dendro.dart';
import 'package:dendro_mobile/funcionalidades/talhoes/dados/repositorio_talhoes.dart';
import 'package:dendro_mobile/funcionalidades/coleta_arvores/dados/repositorio_arvores.dart';
import 'package:dendro_mobile/compartilhado/componentes/componentes_dendro.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('novo levantamento cadastra propriedade pelo botao flutuante', (
    testador,
  ) async {
    final bancoDados = BancoDendro(NativeDatabase.memory());
    addTearDown(bancoDados.close);
    await testador.pumpWidget(
      ProviderScope(
        overrides: [provedorBancoDendro.overrideWithValue(bancoDados)],
        child: MaterialApp(
          theme: TemaDendro.claro,
          home: const TelaNovoLevantamento(),
        ),
      ),
    );
    await testador.pumpAndSettle();
    await testador.tap(find.byTooltip('Nova propriedade'));
    await testador.pumpAndSettle();
    await testador.enterText(
      find.widgetWithText(TextFormField, 'Nome da propriedade'),
      'Fazenda Nova Coleta',
    );
    await testador.enterText(
      find.widgetWithText(TextFormField, 'Município'),
      'Vacaria',
    );
    await testador.enterText(
      find.widgetWithText(TextFormField, 'Área total (ha)'),
      '25,5',
    );
    await testador.ensureVisible(find.text('Cadastrar'));
    await testador.tap(find.text('Cadastrar'));
    await testador.pumpAndSettle();
    expect(find.text('Novo levantamento'), findsOneWidget);
    expect(find.text('Fazenda Nova Coleta'), findsOneWidget);
    expect(find.text('Nome da propriedade'), findsNothing);
    final propriedades = await testador.runAsync(
      () => bancoDados.select(bancoDados.propriedades).get(),
    );
    expect(propriedades!.single.areaTotalHa, 25.5);
    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pump(const Duration(milliseconds: 1));
  });

  testWidgets('abre a tela inicial do DENDRO Mobile', (testador) async {
    final bancoDados = BancoDendro(NativeDatabase.memory());
    addTearDown(bancoDados.close);

    await testador.pumpWidget(
      ProviderScope(
        overrides: [provedorBancoDendro.overrideWithValue(bancoDados)],
        child: const AplicativoDendro(),
      ),
    );

    expect(find.text('DENDRO'), findsOneWidget);

    await testador.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    });
    await testador.pump(const Duration(milliseconds: 2800));
    await testador.pump(const Duration(milliseconds: 400));
    for (var tentativa = 0; tentativa < 30; tentativa++) {
      if (find.text('Novo Levantamento').evaluate().isNotEmpty) break;
      await testador.pump(const Duration(milliseconds: 300));
    }

    expect(find.text('Novo Levantamento'), findsOneWidget);
    expect(find.text('Nenhum levantamento em andamento'), findsOneWidget);
    expect(find.text('Continuar Coleta'), findsNothing);

    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pump(const Duration(milliseconds: 1));
  });

  testWidgets('card claro preserva texto legivel no modo escuro', (
    testador,
  ) async {
    await testador.pumpWidget(
      MaterialApp(
        theme: TemaDendro.escuro,
        home: const Scaffold(body: CartaoDendro(filho: Text('Titulo do card'))),
      ),
    );

    final textoContexto = testador.element(find.text('Titulo do card'));

    expect(DefaultTextStyle.of(textoContexto).style.color, CoresDendro.texto);
  });

  testWidgets('home mostra coleta ativa sem estourar o card', (testador) async {
    final bancoDados = BancoDendro(NativeDatabase.memory());
    addTearDown(bancoDados.close);

    await testador.runAsync(() async {
      final repositorioPropriedades = RepositorioPropriedades(bancoDados);
      final repositorioTalhoes = RepositorioTalhoes(bancoDados);
      final repositorioParcelas = RepositorioParcelas(bancoDados);

      final propriedadeId = await repositorioPropriedades.criar(
        nome: 'Centro',
        municipio: 'Alegria',
        areaTotalHa: 20,
      );
      final especies = await repositorioTalhoes.observarEspeciesAtivas().first;
      final pinus = especies.firstWhere((item) => item.nome == 'Pinus');
      final talhaoId = await repositorioTalhoes.criar(
        propriedadeId: propriedadeId,
        identificacao: 'Centro',
        especieId: pinus.id,
        areaHa: 12,
      );
      await repositorioParcelas.iniciarNovoLevantamentoParaTalhao(talhaoId);
    });

    testador.view.physicalSize = const Size(360, 780);
    testador.view.devicePixelRatio = 1;
    addTearDown(() {
      testador.view.resetPhysicalSize();
      testador.view.resetDevicePixelRatio();
    });

    await testador.pumpWidget(
      ProviderScope(
        overrides: [provedorBancoDendro.overrideWithValue(bancoDados)],
        child: MaterialApp(
          theme: TemaDendro.claro,
          home: const Scaffold(body: TelaInicio()),
        ),
      ),
    );
    for (var tentativa = 0; tentativa < 20; tentativa++) {
      if (find.text('Continuar Coleta').evaluate().isNotEmpty) break;
      await testador.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Continuar Coleta'), findsOneWidget);
    expect(testador.takeException(), isNull);

    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pump(const Duration(milliseconds: 1));
  });

  testWidgets('home mostra talhao no card e resumo total do levantamento', (
    testador,
  ) async {
    final bancoDados = BancoDendro(NativeDatabase.memory());
    addTearDown(bancoDados.close);

    await testador.runAsync(() async {
      final repositorioPropriedades = RepositorioPropriedades(bancoDados);
      final repositorioTalhoes = RepositorioTalhoes(bancoDados);
      final repositorioParcelas = RepositorioParcelas(bancoDados);
      final repositorioArvores = RepositorioArvores(bancoDados);

      final propriedadeId = await repositorioPropriedades.criar(
        nome: 'Fazenda Total',
        municipio: 'Vacaria',
        areaTotalHa: 40,
      );
      final especies = await repositorioTalhoes.observarEspeciesAtivas().first;
      final pinus = especies.firstWhere((item) => item.nome == 'Pinus');

      final primeiroTalhaoId = await repositorioTalhoes.criar(
        propriedadeId: propriedadeId,
        identificacao: 'T-01',
        especieId: pinus.id,
        areaHa: 12,
      );
      final segundoTalhaoId = await repositorioTalhoes.criar(
        propriedadeId: propriedadeId,
        identificacao: 'T-02',
        especieId: pinus.id,
        areaHa: 8,
      );

      final primeiroTalhao = await repositorioParcelas
          .iniciarNovoLevantamentoParaTalhao(primeiroTalhaoId);
      final primeiroParcelaId = await repositorioParcelas
          .criarParcelaParaTalhaoLevantamento(
            talhaoLevantamentoId: primeiroTalhao.id,
            areaHa: 0.04,
          );
      await repositorioArvores.criarArvore(
        parcelaId: primeiroParcelaId,
        rascunho: const RascunhoArvore(
          dapCm: 20,
          alturaM: 12,
          possuiTroncoTortuoso: false,
        ),
      );
      await repositorioArvores.criarArvore(
        parcelaId: primeiroParcelaId,
        rascunho: const RascunhoArvore(
          dapCm: 22,
          alturaM: 13,
          possuiTroncoTortuoso: false,
        ),
      );

      final segundoTalhao = await repositorioParcelas
          .iniciarNovoLevantamentoParaTalhao(segundoTalhaoId);
      final segundoParcelaId = await repositorioParcelas
          .criarParcelaParaTalhaoLevantamento(
            talhaoLevantamentoId: segundoTalhao.id,
            areaHa: 0.05,
          );
      await repositorioArvores.criarArvore(
        parcelaId: segundoParcelaId,
        rascunho: const RascunhoArvore(
          dapCm: 25,
          alturaM: 14,
          possuiTroncoTortuoso: false,
        ),
      );
    });

    testador.view.physicalSize = const Size(360, 780);
    testador.view.devicePixelRatio = 1;
    addTearDown(() {
      testador.view.resetPhysicalSize();
      testador.view.resetDevicePixelRatio();
    });

    await testador.pumpWidget(
      ProviderScope(
        overrides: [provedorBancoDendro.overrideWithValue(bancoDados)],
        child: MaterialApp(
          theme: TemaDendro.claro,
          home: const Scaffold(body: TelaInicio()),
        ),
      ),
    );
    for (var tentativa = 0; tentativa < 20; tentativa++) {
      if (find.text('Continuar Coleta').evaluate().isNotEmpty) break;
      await testador.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('T-01'), findsOneWidget);
    expect(find.text('Continuar Coleta'), findsOneWidget);
    expect(find.text('Resumo do levantamento'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('0,04 ha'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('0,09 ha'), findsOneWidget);

    await testador.tap(find.text('Continuar Coleta'));
    await testador.pumpAndSettle();

    expect(find.text('Parcelas'), findsWidgets);
    expect(find.text('Talhões do levantamento'), findsNothing);

    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pump(const Duration(milliseconds: 1));
  });

  testWidgets('novo levantamento abre busca e continua talhao em coleta', (
    testador,
  ) async {
    final bancoDados = BancoDendro(NativeDatabase.memory());
    addTearDown(bancoDados.close);

    await testador.runAsync(() async {
      final repositorioPropriedades = RepositorioPropriedades(bancoDados);
      final repositorioTalhoes = RepositorioTalhoes(bancoDados);
      final repositorioParcelas = RepositorioParcelas(bancoDados);

      final propriedadeId = await repositorioPropriedades.criar(
        nome: 'Centro',
        municipio: 'Alegria',
        areaTotalHa: 20,
      );
      final especies = await repositorioTalhoes.observarEspeciesAtivas().first;
      final pinus = especies.firstWhere((item) => item.nome == 'Pinus');
      final talhaoId = await repositorioTalhoes.criar(
        propriedadeId: propriedadeId,
        identificacao: 'Centro',
        especieId: pinus.id,
        areaHa: 12,
      );
      await repositorioParcelas.iniciarNovoLevantamentoParaTalhao(talhaoId);
    });

    testador.view.physicalSize = const Size(360, 780);
    testador.view.devicePixelRatio = 1;
    addTearDown(() {
      testador.view.resetPhysicalSize();
      testador.view.resetDevicePixelRatio();
    });

    await testador.pumpWidget(
      ProviderScope(
        overrides: [provedorBancoDendro.overrideWithValue(bancoDados)],
        child: MaterialApp(
          theme: TemaDendro.claro,
          home: const Scaffold(body: TelaInicio()),
        ),
      ),
    );
    for (var tentativa = 0; tentativa < 20; tentativa++) {
      if (find.text('Novo Levantamento').evaluate().isNotEmpty) break;
      await testador.pump(const Duration(milliseconds: 100));
    }

    await testador.tap(find.text('Novo Levantamento'));
    await testador.pumpAndSettle();
    for (var tentativa = 0; tentativa < 20; tentativa++) {
      if (find.text('Buscar propriedade').evaluate().isNotEmpty) break;
      await testador.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Buscar propriedade'), findsOneWidget);
    expect(find.text('Município'), findsOneWidget);
    expect(find.text('Espécie'), findsOneWidget);
    expect(find.text('Centro'), findsWidgets);
    expect(find.text('Em coleta'), findsOneWidget);
    expect(find.text('Continuar coleta'), findsOneWidget);

    await testador.tap(find.text('Continuar coleta'));
    await testador.pumpAndSettle();
    for (var tentativa = 0; tentativa < 20; tentativa++) {
      if (find.text('Levantamento').evaluate().isNotEmpty) break;
      await testador.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Levantamento'), findsOneWidget);
    expect(testador.takeException(), isNull);

    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pump(const Duration(milliseconds: 1));
  });

  testWidgets('novo talhao no levantamento permite ajustar modelo', (
    testador,
  ) async {
    final bancoDados = BancoDendro(NativeDatabase.memory());
    addTearDown(bancoDados.close);

    await testador.runAsync(() async {
      final repositorioPropriedades = RepositorioPropriedades(bancoDados);

      await repositorioPropriedades.criar(
        nome: 'Fazenda Modelo',
        municipio: 'Vacaria',
        areaTotalHa: 30,
      );
    });

    await testador.pumpWidget(
      ProviderScope(
        overrides: [provedorBancoDendro.overrideWithValue(bancoDados)],
        child: MaterialApp(
          theme: TemaDendro.claro,
          home: const TelaNovoLevantamento(),
        ),
      ),
    );
    for (var tentativa = 0; tentativa < 20; tentativa++) {
      if (find.text('Fazenda Modelo').evaluate().isNotEmpty) break;
      await testador.pump(const Duration(milliseconds: 100));
    }

    await testador.tap(find.widgetWithText(OutlinedButton, 'Novo talhão'));
    await testador.pumpAndSettle();

    expect(find.text('Cadastrar talhão'), findsOneWidget);
    expect(find.text('Modelo matemático'), findsOneWidget);
    expect(find.text('Ajustar modelo matemático'), findsOneWidget);

    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pump(const Duration(milliseconds: 1));
  });

  testWidgets('ajuste de modelo mostra apenas formulas vinculadas a especie', (
    testador,
  ) async {
    final bancoDados = BancoDendro(NativeDatabase.memory());
    addTearDown(bancoDados.close);

    await testador.runAsync(() async {
      final repositorioAjustes = RepositorioAjustes(bancoDados);
      final repositorioPropriedades = RepositorioPropriedades(bancoDados);
      final repositorioTalhoes = RepositorioTalhoes(bancoDados);

      await repositorioAjustes.definirVinculoEspecieModelo(
        especieId: (await bancoDados.select(bancoDados.especies).get())
            .singleWhere((e) => e.codigo == 'species_pinus')
            .id,
        modeloMatematicoId:
            (await bancoDados.select(bancoDados.modelosMatematicos).get())
                .singleWhere((m) => m.codigo == 'formula_schumacher_hall')
                .id,
        vinculado: false,
      );

      final propriedadeId = await repositorioPropriedades.criar(
        nome: 'Fazenda Vinculos',
        municipio: 'Vacaria',
        areaTotalHa: 30,
      );
      await repositorioTalhoes.criar(
        propriedadeId: propriedadeId,
        identificacao: 'T-01',
        especieId: (await bancoDados.select(bancoDados.especies).get())
            .singleWhere((e) => e.codigo == 'species_pinus')
            .id,
        areaHa: 10,
      );
    });

    await testador.pumpWidget(
      ProviderScope(
        overrides: [provedorBancoDendro.overrideWithValue(bancoDados)],
        child: MaterialApp(
          theme: TemaDendro.claro,
          home: const TelaNovoLevantamento(),
        ),
      ),
    );
    for (var tentativa = 0; tentativa < 20; tentativa++) {
      if (find.text('Ajustar modelo matemático').evaluate().isNotEmpty) break;
      await testador.pump(const Duration(milliseconds: 100));
    }

    await testador.tap(find.text('Ajustar modelo matemático'));
    await testador.pumpAndSettle();
    for (var tentativa = 0; tentativa < 20; tentativa++) {
      if (find.text('Modelo de Spurr').evaluate().isNotEmpty) break;
      await testador.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Modelo de Spurr'), findsOneWidget);
    expect(find.text('Schumacher-Hall'), findsNothing);

    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pump(const Duration(milliseconds: 1));
  });

  testWidgets('barra inferior permanece fixa em telas internas', (
    testador,
  ) async {
    final bancoDados = BancoDendro(NativeDatabase.memory());
    addTearDown(bancoDados.close);
    testador.view.physicalSize = const Size(360, 780);
    testador.view.devicePixelRatio = 1;
    addTearDown(() {
      testador.view.resetPhysicalSize();
      testador.view.resetDevicePixelRatio();
    });

    await testador.runAsync(() async {
      final repositorioPropriedades = RepositorioPropriedades(bancoDados);

      await repositorioPropriedades.criar(
        nome: 'Fazenda Navegação',
        municipio: 'Vacaria',
        areaTotalHa: 42,
      );
    });

    await testador.pumpWidget(
      ProviderScope(
        overrides: [provedorBancoDendro.overrideWithValue(bancoDados)],
        child: MaterialApp(
          theme: TemaDendro.claro,
          home: const EstruturaDendro(),
        ),
      ),
    );
    await testador.pumpAndSettle();

    var navegacaoRotulos = _navegacaoRotulos(testador);
    expect(navegacaoRotulos, [
      'Início',
      'Levant.',
      'Propr.',
      'Result.',
      'Ajustes',
    ]);

    await testador.tap(find.text('Propr.'));
    await testador.pumpAndSettle();

    await testador.tap(find.text('Fazenda Navegação'));
    await testador.pumpAndSettle();

    var navegacaoBarra = testador.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(
      navegacaoBarra.labelBehavior,
      NavigationDestinationLabelBehavior.alwaysHide,
    );
    expect(navegacaoBarra.height, 62);
    expect(find.text('Talhões'), findsOneWidget);
    expect(find.text('Buscar propriedade'), findsNothing);

    await testador.tap(find.byIcon(Icons.map));
    await testador.pumpAndSettle();

    navegacaoBarra = testador.widget<NavigationBar>(find.byType(NavigationBar));
    navegacaoRotulos = _navegacaoRotulos(testador);
    expect(
      navegacaoBarra.labelBehavior,
      NavigationDestinationLabelBehavior.alwaysShow,
    );
    expect(navegacaoBarra.height, isNull);
    expect(navegacaoRotulos, [
      'Início',
      'Levant.',
      'Propr.',
      'Result.',
      'Ajustes',
    ]);
    expect(find.text('Buscar propriedade'), findsOneWidget);

    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pump(const Duration(milliseconds: 1));
  });

  testWidgets('barra inferior usa nomes completos em telas largas', (
    testador,
  ) async {
    final bancoDados = BancoDendro(NativeDatabase.memory());
    addTearDown(bancoDados.close);
    testador.view.physicalSize = const Size(900, 780);
    testador.view.devicePixelRatio = 1;
    addTearDown(() {
      testador.view.resetPhysicalSize();
      testador.view.resetDevicePixelRatio();
    });

    await testador.pumpWidget(
      ProviderScope(
        overrides: [provedorBancoDendro.overrideWithValue(bancoDados)],
        child: MaterialApp(
          theme: TemaDendro.claro,
          home: const EstruturaDendro(),
        ),
      ),
    );
    await testador.pumpAndSettle();

    expect(_navegacaoRotulos(testador), [
      'Início',
      'Levantamentos',
      'Propriedades',
      'Resultados',
      'Ajustes',
    ]);

    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pump(const Duration(milliseconds: 1));
  });

  testWidgets('atalho de resultados troca a aba selecionada', (testador) async {
    final bancoDados = BancoDendro(NativeDatabase.memory());
    addTearDown(bancoDados.close);
    testador.view.physicalSize = const Size(360, 780);
    testador.view.devicePixelRatio = 1;
    addTearDown(() {
      testador.view.resetPhysicalSize();
      testador.view.resetDevicePixelRatio();
    });

    await testador.runAsync(() async {
      final repositorioPropriedades = RepositorioPropriedades(bancoDados);

      await repositorioPropriedades.criar(
        nome: 'Fazenda Resultado',
        municipio: 'Vacaria',
        areaTotalHa: 42,
      );
    });

    await testador.pumpWidget(
      ProviderScope(
        overrides: [provedorBancoDendro.overrideWithValue(bancoDados)],
        child: MaterialApp(
          theme: TemaDendro.claro,
          home: const EstruturaDendro(),
        ),
      ),
    );
    await testador.pumpAndSettle();

    await testador.tap(find.text('Propr.'));
    await testador.pumpAndSettle();
    await testador.tap(find.text('Fazenda Resultado'));
    await testador.pumpAndSettle();

    await testador.tap(find.byTooltip('Resultados'));
    await testador.pumpAndSettle();

    final navegacaoBarra = testador.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(navegacaoBarra.selectedIndex, 3);
    expect(find.text('Filtros'), findsOneWidget);
    expect(find.text('Fazenda Resultado'), findsWidgets);

    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pump(const Duration(milliseconds: 1));
  });

  testWidgets('ajustes navega para especies e modelos do catalogo', (
    testador,
  ) async {
    final bancoDados = BancoDendro(NativeDatabase.memory());
    addTearDown(bancoDados.close);

    await testador.pumpWidget(
      ProviderScope(
        overrides: [provedorBancoDendro.overrideWithValue(bancoDados)],
        child: MaterialApp(
          theme: TemaDendro.claro,
          home: const Scaffold(body: TelaAjustes()),
        ),
      ),
    );
    await testador.pumpAndSettle();

    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('Modo escuro'), findsOneWidget);
    expect(find.text('Cadastro de espécies'), findsOneWidget);
    expect(find.text('Modelos matemáticos'), findsOneWidget);
    expect(find.text('Nova espécie'), findsNothing);
    expect(find.text('Nova fórmula'), findsNothing);

    await testador.tap(find.text('Cadastro de espécies'));
    await testador.pumpAndSettle();

    expect(find.text('Cadastro de espécies'), findsOneWidget);
    expect(find.text('Espécies cadastradas'), findsOneWidget);
    expect(find.text('Pinus'), findsOneWidget);
    expect(find.byTooltip('Voltar'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await testador.tap(find.byTooltip('Voltar'));
    await testador.pumpAndSettle();

    expect(find.text('Ajustes'), findsOneWidget);

    await testador.tap(find.text('Modelos matemáticos'));
    await testador.pumpAndSettle();

    expect(find.text('Fórmulas cadastradas'), findsOneWidget);
    expect(find.text('Modelo de Spurr'), findsOneWidget);
    expect(find.text('Schumacher-Hall'), findsOneWidget);
    expect(find.text('Fator de Forma'), findsOneWidget);
    expect(find.byTooltip('Voltar'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await testador.tap(find.byIcon(Icons.add));
    await testador.pumpAndSettle();
    final fator = find.widgetWithText(CheckboxListTile, 'Fator de forma (ff)');
    await testador.ensureVisible(fator);
    await testador.tap(fator);
    await testador.pumpAndSettle();
    expect(testador.widget<CheckboxListTile>(fator).value, isTrue);
    final coeficienteCampo = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Símbolos dos coeficientes',
    );
    expect(
      testador.widget<TextField>(coeficienteCampo).controller!.text,
      'a, b, ff',
    );

    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pump(const Duration(milliseconds: 1));
  });
}

List<String> _navegacaoRotulos(WidgetTester testador) {
  final navegacaoBarra = testador.widget<NavigationBar>(
    find.byType(NavigationBar),
  );
  return [
    for (final destino in navegacaoBarra.destinations)
      (destino as NavigationDestination).label,
  ];
}
