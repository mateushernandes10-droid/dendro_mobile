import 'package:dendro_mobile/nucleo/banco/banco_dendro.dart';
import 'package:dendro_mobile/nucleo/banco/catalogos_iniciais.dart';
import 'package:dendro_mobile/nucleo/floresta/calculadora_volume_florestal.dart';
import 'package:dendro_mobile/funcionalidades/atividades/dados/repositorio_atividades.dart';
import 'package:dendro_mobile/funcionalidades/levantamentos/dados/selecao_modelo_levantamento.dart';
import 'package:dendro_mobile/funcionalidades/levantamentos/dados/repositorio_levantamentos.dart';
import 'package:dendro_mobile/funcionalidades/parcelas/dados/repositorio_parcelas.dart';
import 'package:dendro_mobile/funcionalidades/propriedades/dados/repositorio_propriedades.dart';
import 'package:dendro_mobile/funcionalidades/resultados/dados/repositorio_resultados.dart';
import 'package:dendro_mobile/funcionalidades/ajustes/dados/repositorio_ajustes.dart';
import 'package:dendro_mobile/funcionalidades/talhoes/dados/repositorio_talhoes.dart';
import 'package:dendro_mobile/funcionalidades/coleta_arvores/dados/repositorio_arvores.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BancoDendro bancoDados;
  late int pinusId, eucalyptusId, spurrId, schumacherId, fatorId;

  setUp(() async {
    bancoDados = BancoDendro(NativeDatabase.memory());
    final modelos = await bancoDados
        .select(bancoDados.modelosMatematicos)
        .get();
    spurrId = modelos.singleWhere((m) => m.codigo == 'formula_spurr').id;
    schumacherId = modelos
        .singleWhere((m) => m.codigo == 'formula_schumacher_hall')
        .id;
    fatorId = modelos.singleWhere((m) => m.codigo == 'formula_form_factor').id;
    final especies = await bancoDados.select(bancoDados.especies).get();
    pinusId = especies.singleWhere((e) => e.codigo == codigoPinus).id;
    eucalyptusId = especies.singleWhere((e) => e.codigo == codigoEucalyptus).id;
  });

  tearDown(() async {
    await bancoDados.close();
  });

  test('cria catalogos iniciais de especies e formulas', () async {
    final especies = await bancoDados.select(bancoDados.especies).get();
    final modelosMatematicos = await bancoDados
        .select(bancoDados.modelosMatematicos)
        .get();
    final variaveis = await bancoDados.select(bancoDados.variaveisModelo).get();
    final coeficientes = await bancoDados
        .select(bancoDados.coeficientesModelo)
        .get();
    final coeficientesEspecie = await bancoDados
        .select(bancoDados.coeficientesEspecieModelo)
        .get();

    expect(
      especies.map((item) => item.nome),
      containsAll(['Pinus', 'Eucalyptus']),
    );
    expect(
      modelosMatematicos.map((item) => item.nome),
      containsAll(['Modelo de Spurr', 'Schumacher-Hall', 'Fator de Forma']),
    );
    expect(
      modelosMatematicos.singleWhere((item) => item.id == fatorId).expressao,
      CalculadoraVolumeFlorestal.expressaoFatorForma,
    );
    expect(variaveis, hasLength(6));
    expect(coeficientes, hasLength(6));
    expect(
      coeficientes.singleWhere((item) => item.simbolo == 'ff').valor,
      isNull,
    );
    expect(
      coeficientesEspecie
          .singleWhere(
            (item) =>
                item.especieId == pinusId &&
                item.modeloMatematicoId == fatorId &&
                item.simbolo == 'ff',
          )
          .valor,
      fatorFormaPadraoPinus,
    );
    expect(
      coeficientesEspecie
          .singleWhere(
            (item) =>
                item.especieId == eucalyptusId &&
                item.modeloMatematicoId == fatorId &&
                item.simbolo == 'ff',
          )
          .valor,
      fatorFormaPadraoEucalyptus,
    );
    expect(
      coeficientes
          .singleWhere(
            (item) => item.modeloMatematicoId == spurrId && item.simbolo == 'a',
          )
          .valor,
      closeTo(CalculadoraVolumeFlorestal.padraoSpurrA, 0.0000000001),
    );
    expect(
      coeficientes
          .singleWhere(
            (item) => item.modeloMatematicoId == spurrId && item.simbolo == 'b',
          )
          .valor,
      closeTo(CalculadoraVolumeFlorestal.padraoSpurrB, 0.0000000001),
    );
    expect(
      coeficientes
          .singleWhere(
            (item) =>
                item.modeloMatematicoId == schumacherId && item.simbolo == 'a',
          )
          .valor,
      closeTo(CalculadoraVolumeFlorestal.padraoSchumacherHallA, 0.0000000001),
    );
    expect(
      coeficientes
          .singleWhere(
            (item) =>
                item.modeloMatematicoId == schumacherId && item.simbolo == 'b',
          )
          .valor,
      closeTo(CalculadoraVolumeFlorestal.padraoSchumacherHallB, 0.0000000001),
    );
    expect(
      coeficientes
          .singleWhere(
            (item) =>
                item.modeloMatematicoId == schumacherId && item.simbolo == 'c',
          )
          .valor,
      closeTo(CalculadoraVolumeFlorestal.padraoSchumacherHallC, 0.0000000001),
    );
  });

  test('coleta usa ff informado sem alterar o ff da especie', () async {
    final modeloMatematicoId = fatorId;
    await RepositorioAjustes(bancoDados).atualizarCoeficientesModeloDaEspecie(
      especieId: pinusId,
      modeloMatematicoId: modeloMatematicoId,
      valoresPorSimbolo: {'ff': 0.5},
    );
    final propriedadeId = await RepositorioPropriedades(
      bancoDados,
    ).criar(nome: 'Fazenda FF', municipio: 'Vacaria', areaTotalHa: 10);
    final talhaoId = await RepositorioTalhoes(bancoDados).criar(
      propriedadeId: propriedadeId,
      identificacao: 'FF-01',
      especieId: pinusId,
      areaHa: 10,
    );
    final parcelas = RepositorioParcelas(bancoDados);
    final levantamentoTalhao = await parcelas.iniciarNovoLevantamentoParaTalhao(
      talhaoId,
      modeloMatematicoSelecao: SelecaoModeloLevantamento(
        modeloMatematicoId: modeloMatematicoId,
        modeloMatematicoNome: 'Fator de Forma',
        coeficienteValoresPorSimbolo: {'ff': 0.25},
      ),
    );
    final parcelaId = await parcelas.criarParcelaParaTalhaoLevantamento(
      talhaoLevantamentoId: levantamentoTalhao.id,
      areaHa: 0.04,
    );
    await RepositorioArvores(bancoDados).criarArvore(
      parcelaId: parcelaId,
      rascunho: const RascunhoArvore(
        dapCm: 20,
        alturaM: 10,
        possuiTroncoTortuoso: false,
      ),
    );
    final resumo = await RepositorioLevantamentos(
      bancoDados,
    ).observarPorId(levantamentoTalhao.levantamentoId).first;
    expect(resumo!.talhoes.single.coeficientesModelo.single.valor, 0.25);
    final especieValores =
        await (bancoDados.select(bancoDados.coeficientesEspecieModelo)..where(
              (t) =>
                  t.modeloMatematicoId.equals(modeloMatematicoId) &
                  t.especieId.equals(pinusId),
            ))
            .getSingle();
    expect(especieValores.valor, 0.5);
  });

  test('repositorio de ajustes mantem especies formulas e vinculos', () async {
    final repositorio = RepositorioAjustes(bancoDados);

    final especieId = await repositorio.criarEspecie(
      nome: 'Acacia',
      nomeCientifico: 'Acacia mearnsii',
      descricao: 'Cadastro para testes',
    );
    final modeloMatematicoId = await repositorio.criarModeloMatematico(
      nome: 'Modelo Regional',
      descricao: 'Modelo local',
      expressao: 'a + b * D + c * H',
      variaveis: const [
        RascunhoVariavelModelo(
          simbolo: 'D',
          rotulo: 'DAP',
          unidade: 'cm',
          origemValor: 'Medição da árvore',
          chaveVariavel: ChaveVariavelModelo.dap,
        ),
        RascunhoVariavelModelo(
          simbolo: 'H',
          rotulo: 'Altura',
          unidade: 'm',
          origemValor: 'Medição da árvore',
          chaveVariavel: ChaveVariavelModelo.altura,
        ),
      ],
      coeficienteSimbolos: const ['a', 'b', 'c'],
    );

    await repositorio.definirVinculoEspecieModelo(
      especieId: especieId,
      modeloMatematicoId: modeloMatematicoId,
      vinculado: true,
    );

    final vinculos = await bancoDados.select(bancoDados.especiesModelos).get();
    final customVinculo = vinculos.singleWhere(
      (vinculo) =>
          vinculo.especieId == especieId &&
          vinculo.modeloMatematicoId == modeloMatematicoId,
    );
    expect(customVinculo.padrao, isTrue);

    final coeficientes =
        (await bancoDados.select(bancoDados.coeficientesModelo).get())
            .where((item) => item.modeloMatematicoId == modeloMatematicoId)
            .toList();
    await repositorio.atualizarValoresCoeficientes(
      modeloMatematicoId: modeloMatematicoId,
      valoresPorCoeficienteId: {
        for (final coeficiente in coeficientes)
          coeficiente.id: switch (coeficiente.simbolo) {
            'a' => -0.8732,
            'b' => 1.9542,
            _ => 0.8711,
          },
      },
    );

    final modelosMatematicos = await repositorio
        .observarModelosMatematicos()
        .first;
    final customModeloMatematico = modelosMatematicos.singleWhere(
      (resumo) => resumo.modeloMatematico.id == modeloMatematicoId,
    );

    expect(customModeloMatematico.modeloMatematico.nome, 'Modelo Regional');
    expect(customModeloMatematico.variaveis.map((item) => item.simbolo), [
      'D',
      'H',
    ]);
    expect(customModeloMatematico.coeficientes, hasLength(3));
    expect(
      customModeloMatematico.coeficientes
          .singleWhere((item) => item.simbolo == 'a')
          .valor,
      closeTo(-0.8732, 0.00001),
    );
  });

  test('repositorio cadastra e busca propriedade', () async {
    final repositorio = RepositorioPropriedades(bancoDados);

    final id = await repositorio.criar(
      nome: 'Fazenda Esperança',
      municipio: 'Vacaria',
      areaTotalHa: 158.17,
    );

    final resultados = await repositorio.buscarPorNome('Esperança');

    expect(resultados, hasLength(1));
    expect(resultados.single.nome, 'Fazenda Esperança');
    expect(resultados.single.estado, 'RS');
    expect(resultados.single.areaTotalHa, 158.17);

    await repositorio.atualizar(
      id: id,
      nome: 'Fazenda Esperança Editada',
      municipio: 'Vacaria',
      estado: 'RS',
      areaTotalHa: 160,
    );

    final atualizado = await repositorio.buscarPorId(id);
    expect(atualizado?.nome, 'Fazenda Esperança Editada');
    expect(atualizado?.areaTotalHa, 160);

    await repositorio.excluir(id);
    expect(await repositorio.buscarPorNome('Esperança'), isEmpty);
  });

  test(
    'repositorio cadastra talhao vinculado a propriedade e especie',
    () async {
      final repositorioPropriedades = RepositorioPropriedades(bancoDados);
      final repositorioTalhoes = RepositorioTalhoes(bancoDados);

      final propriedadeId = await repositorioPropriedades.criar(
        nome: 'Fazenda Esperança',
        municipio: 'Vacaria',
        areaTotalHa: 158.17,
      );
      final especies = await repositorioTalhoes.observarEspeciesAtivas().first;
      final pinus = especies.firstWhere((item) => item.nome == 'Pinus');

      await repositorioTalhoes.criar(
        propriedadeId: propriedadeId,
        identificacao: 'Talhão 42-B',
        especieId: pinus.id,
        areaHa: 45.2,
        anoPlantio: 2012,
        espacamento: '3 x 2 m',
        larguraParcelaM: 20,
        comprimentoParcelaM: 25,
      );

      final talhoes = await repositorioTalhoes
          .observarPorPropriedade(propriedadeId)
          .first;

      expect(talhoes, hasLength(1));
      expect(talhoes.single.talhao.identificacao, 'Talhão 42-B');
      expect(talhoes.single.talhao.areaHa, 45.2);
      expect(talhoes.single.talhao.anoPlantio, 2012);
      expect(talhoes.single.talhao.larguraParcelaM, 20);
      expect(talhoes.single.talhao.comprimentoParcelaM, 25);
      expect(talhoes.single.especie.nome, 'Pinus');
      expect(talhoes.single.possuiAtivoLevantamento, isFalse);
    },
  );

  test('repositorio cria parcela planejada e inicia levantamento', () async {
    final repositorioPropriedades = RepositorioPropriedades(bancoDados);
    final repositorioTalhoes = RepositorioTalhoes(bancoDados);
    final repositorioParcelas = RepositorioParcelas(bancoDados);
    final repositorioLevantamentos = RepositorioLevantamentos(bancoDados);

    final propriedadeId = await repositorioPropriedades.criar(
      nome: 'Fazenda Teste',
      municipio: 'Vacaria',
      areaTotalHa: 80,
    );
    final especies = await repositorioTalhoes.observarEspeciesAtivas().first;
    final pinus = especies.firstWhere((item) => item.nome == 'Pinus');

    final talhaoId = await repositorioTalhoes.criar(
      propriedadeId: propriedadeId,
      identificacao: 'T-01',
      especieId: pinus.id,
      areaHa: 12.5,
      larguraParcelaM: 20,
      comprimentoParcelaM: 20,
    );

    final inicialEstado = await repositorioParcelas
        .observarParcelasTalhao(talhaoId)
        .first;
    expect(inicialEstado.parcelas, isEmpty);
    expect(inicialEstado.talhao.identificacao, 'T-01');
    expect(await bancoDados.select(bancoDados.levantamentos).get(), isEmpty);

    await repositorioParcelas.criarParcelaPlanejada(talhaoId: talhaoId);

    final atualizadoEstado = await repositorioParcelas
        .observarParcelasTalhao(talhaoId)
        .firstWhere((estado) => estado.parcelas.isNotEmpty);

    expect(atualizadoEstado.parcelas.single.parcela.identificacao, 'P01');
    expect(
      atualizadoEstado.parcelas.single.parcela.situacao,
      SituacaoParcela.pendente,
    );
    expect(atualizadoEstado.parcelas.single.parcela.areaHa, 0.04);
    expect(
      atualizadoEstado.parcelas.single.levantamento.situacao,
      SituacaoLevantamento.planejamento,
    );

    await repositorioParcelas.iniciarNovoLevantamentoParaTalhao(talhaoId);

    final levantamentos = await bancoDados
        .select(bancoDados.levantamentos)
        .get();
    final talhaoLevantamentos = await bancoDados
        .select(bancoDados.talhaoLevantamentos)
        .get();

    expect(levantamentos, hasLength(1));
    expect(levantamentos.single.situacao, SituacaoLevantamento.emAndamento);
    expect(talhaoLevantamentos, hasLength(1));

    final ativoTalhaoEstado = await repositorioParcelas
        .observarParcelasTalhao(talhaoId)
        .firstWhere((estado) => estado.ativoTalhaoLevantamento != null);

    expect(
      ativoTalhaoEstado.ativoTalhaoLevantamento!.levantamentoId,
      levantamentos.single.id,
    );

    final propriedadeTalhoes = await repositorioTalhoes
        .observarPorPropriedade(propriedadeId)
        .firstWhere(
          (itens) => itens.any((item) => item.possuiAtivoLevantamento),
        );

    expect(propriedadeTalhoes.single.possuiAtivoLevantamento, isTrue);

    final ativoLevantamento = await repositorioLevantamentos
        .observarLevantamentoAtivoMaisRecente()
        .first;

    expect(ativoLevantamento, isNotNull);
    expect(ativoLevantamento!.propriedade.nome, 'Fazenda Teste');
    expect(ativoLevantamento.talhaoRotulo, 'T-01');
    expect(ativoLevantamento.parcelaQuantidade, 1);
    expect(ativoTalhaoEstado.proximaIdentificacaoParcela, 'P02');

    expect(
      () => repositorioParcelas.iniciarNovoLevantamentoParaTalhao(talhaoId),
      throwsA(isA<ExcecaoLevantamentoAtivoNoTalhao>()),
    );

    await repositorioParcelas.criarParcelaPlanejada(
      talhaoId: talhaoId,
      areaHa: 0.04,
    );

    final estadoComNovoPlanejadoParcela = await repositorioParcelas
        .observarParcelasTalhao(talhaoId)
        .firstWhere((estado) => estado.parcelas.length == 2);
    final identificacoes = estadoComNovoPlanejadoParcela.parcelas
        .map((resumo) => resumo.parcela.identificacao)
        .toSet();

    expect(identificacoes, containsAll(['P01', 'P02']));
    expect(estadoComNovoPlanejadoParcela.proximaIdentificacaoParcela, 'P03');

    final segundoTalhaoId = await repositorioTalhoes.criar(
      propriedadeId: propriedadeId,
      identificacao: 'T-02',
      especieId: pinus.id,
      areaHa: 8,
    );
    await repositorioParcelas.iniciarNovoLevantamentoParaTalhao(
      segundoTalhaoId,
    );

    final segundoTalhaoEstado = await repositorioParcelas
        .observarParcelasTalhao(segundoTalhaoId)
        .firstWhere((estado) => estado.ativoTalhaoLevantamento != null);

    final ativoLevantamentos = await repositorioLevantamentos
        .observarLevantamentosAtivos()
        .first;

    expect(segundoTalhaoEstado.parcelas, isEmpty);
    expect(ativoLevantamentos, hasLength(1));
    expect(ativoLevantamentos.single.propriedade.id, propriedadeId);
    expect(ativoLevantamentos.single.talhoes, hasLength(2));
    expect(
      ativoLevantamentos.single.talhoes.map(
        (resumo) => resumo.talhao.identificacao,
      ),
      containsAll(['T-01', 'T-02']),
    );

    final todosLevantamentos = await repositorioLevantamentos
        .observarTodos()
        .first;

    expect(todosLevantamentos, hasLength(2));
    expect(
      todosLevantamentos.where(
        (resumo) =>
            resumo.levantamento.situacao == SituacaoLevantamento.emAndamento,
      ),
      hasLength(1),
    );
    expect(
      todosLevantamentos.where(
        (resumo) =>
            resumo.levantamento.situacao == SituacaoLevantamento.planejamento,
      ),
      hasLength(1),
    );
  });

  test(
    'levantamento salva modelo e coeficientes especificos do talhao',
    () async {
      final repositorioPropriedades = RepositorioPropriedades(bancoDados);
      final repositorioTalhoes = RepositorioTalhoes(bancoDados);
      final repositorioParcelas = RepositorioParcelas(bancoDados);
      final repositorioLevantamentos = RepositorioLevantamentos(bancoDados);

      final propriedadeId = await repositorioPropriedades.criar(
        nome: 'Fazenda Modelo',
        municipio: 'Vacaria',
        areaTotalHa: 70,
      );
      final especies = await repositorioTalhoes.observarEspeciesAtivas().first;
      final pinus = especies.firstWhere((item) => item.nome == 'Pinus');
      final talhaoId = await repositorioTalhoes.criar(
        propriedadeId: propriedadeId,
        identificacao: 'M-01',
        especieId: pinus.id,
        areaHa: 15,
      );
      final schumacher =
          (await bancoDados.select(bancoDados.modelosMatematicos).get())
              .singleWhere(
                (modeloMatematico) => modeloMatematico.id == schumacherId,
              );

      final talhaoLevantamento = await repositorioParcelas
          .iniciarNovoLevantamentoParaTalhao(
            talhaoId,
            modeloMatematicoSelecao: SelecaoModeloLevantamento(
              modeloMatematicoId: schumacherId,
              modeloMatematicoNome: 'Schumacher-Hall',
              coeficienteValoresPorSimbolo: {'a': -9.87, 'b': 1.95, 'c': 0.87},
            ),
          );

      expect(talhaoLevantamento.modeloMatematicoId, schumacher.id);

      final coeficientes = await bancoDados
          .customSelect(
            '''
SELECT simbolo, valor
FROM coeficientes_talhao_levantamento
WHERE talhao_levantamento_id = ?
ORDER BY simbolo
''',
            variables: [drift.Variable<int>(talhaoLevantamento.id)],
          )
          .get();

      expect(coeficientes, hasLength(3));
      expect(coeficientes[0].read<String>('simbolo'), 'a');
      expect(coeficientes[0].read<double>('valor'), closeTo(-9.87, 0.00001));
      expect(coeficientes[1].read<String>('simbolo'), 'b');
      expect(coeficientes[1].read<double>('valor'), closeTo(1.95, 0.00001));
      expect(coeficientes[2].read<String>('simbolo'), 'c');
      expect(coeficientes[2].read<double>('valor'), closeTo(0.87, 0.00001));

      final resumo = await repositorioLevantamentos
          .observarPorId(talhaoLevantamento.levantamentoId)
          .first;

      expect(resumo, isNotNull);
      expect(resumo!.talhoes.single.modeloMatematico.nome, 'Schumacher-Hall');
      expect(resumo.talhoes.single.coeficientesModelo, hasLength(3));
      expect(
        resumo.talhoes.single.coeficientesModelo
            .singleWhere((coeficiente) => coeficiente.simbolo == 'a')
            .valor,
        closeTo(-9.87, 0.00001),
      );
    },
  );

  test(
    'levantamento usa coeficientes vinculados a especie por padrao',
    () async {
      final repositorioAjustes = RepositorioAjustes(bancoDados);
      final repositorioPropriedades = RepositorioPropriedades(bancoDados);
      final repositorioTalhoes = RepositorioTalhoes(bancoDados);
      final repositorioParcelas = RepositorioParcelas(bancoDados);

      final especies = await repositorioTalhoes.observarEspeciesAtivas().first;
      final pinus = especies.firstWhere((item) => item.nome == 'Pinus');
      await repositorioAjustes.atualizarCoeficientesModeloDaEspecie(
        especieId: pinus.id,
        modeloMatematicoId: spurrId,
        valoresPorSimbolo: const {
          'a': 0.0175858265880592,
          'b': 0.0000329326161133665,
        },
      );

      final propriedadeId = await repositorioPropriedades.criar(
        nome: 'Fazenda Coeficiente',
        municipio: 'Vacaria',
        areaTotalHa: 40,
      );
      final talhaoId = await repositorioTalhoes.criar(
        propriedadeId: propriedadeId,
        identificacao: 'C-01',
        especieId: pinus.id,
        areaHa: 10,
      );

      final talhaoLevantamento = await repositorioParcelas
          .iniciarNovoLevantamentoParaTalhao(talhaoId);
      final coeficientes = await bancoDados
          .customSelect(
            '''
SELECT simbolo, valor
FROM coeficientes_talhao_levantamento
WHERE talhao_levantamento_id = ?
ORDER BY simbolo
''',
            variables: [drift.Variable<int>(talhaoLevantamento.id)],
          )
          .get();

      expect(talhaoLevantamento.modeloMatematicoId, spurrId);
      expect(coeficientes, hasLength(2));
      expect(
        coeficientes
            .singleWhere(
              (coeficiente) => coeficiente.read<String>('simbolo') == 'a',
            )
            .read<double>('valor'),
        closeTo(0.0175858265880592, 0.0000000000000001),
      );
      expect(
        coeficientes
            .singleWhere(
              (coeficiente) => coeficiente.read<String>('simbolo') == 'b',
            )
            .read<double>('valor'),
        closeTo(0.0000329326161133665, 0.0000000000000001),
      );
    },
  );

  test('repositorio coleta arvore e encerra parcela', () async {
    final repositorioPropriedades = RepositorioPropriedades(bancoDados);
    final repositorioTalhoes = RepositorioTalhoes(bancoDados);
    final repositorioParcelas = RepositorioParcelas(bancoDados);
    final repositorioArvores = RepositorioArvores(bancoDados);
    final repositorioLevantamentos = RepositorioLevantamentos(bancoDados);

    final propriedadeId = await repositorioPropriedades.criar(
      nome: 'Fazenda Coleta',
      municipio: 'Vacaria',
      areaTotalHa: 80,
    );
    final especies = await repositorioTalhoes.observarEspeciesAtivas().first;
    final pinus = especies.firstWhere((item) => item.nome == 'Pinus');

    final talhaoId = await repositorioTalhoes.criar(
      propriedadeId: propriedadeId,
      identificacao: 'T-02',
      especieId: pinus.id,
      areaHa: 10,
    );

    final talhaoLevantamento = await repositorioParcelas
        .iniciarNovoLevantamentoParaTalhao(talhaoId);
    final parcelaId = await repositorioParcelas
        .criarParcelaParaTalhaoLevantamento(
          talhaoLevantamentoId: talhaoLevantamento.id,
          areaHa: 0.04,
        );

    final primeiroArvoreId = await repositorioArvores.criarArvore(
      parcelaId: parcelaId,
      rascunho: RascunhoArvore(
        dapCm: 31.5,
        alturaM: 22.7,
        possuiTroncoTortuoso: false,
        latitude: -28.5123,
        longitude: -50.9123,
        precisaoMetros: 4.5,
        localizacaoCapturadaEm: DateTime(2026, 8, 15, 10),
        posicaoReferenciaParcela: PosicaoReferenciaParcela.p1,
      ),
    );

    var estado = await repositorioArvores.observarColeta(parcelaId).first;

    expect(estado.arvores, hasLength(1));
    expect(estado.arvores.single.numero, 1);
    expect(estado.arvores.single.dapCm, 31.5);
    expect(estado.parcela.situacao, SituacaoParcela.emAndamento);
    expect(estado.pontosReferencia, hasLength(1));
    expect(
      estado.pontosReferencia.single.posicaoReferenciaParcela,
      PosicaoReferenciaParcela.p1,
    );

    final substituicaoArvoreId = await repositorioArvores.criarArvore(
      parcelaId: parcelaId,
      rascunho: RascunhoArvore(
        dapCm: 29.2,
        alturaM: 21.1,
        possuiTroncoTortuoso: false,
        latitude: -28.6123,
        longitude: -50.8123,
        precisaoMetros: 3.8,
        localizacaoCapturadaEm: DateTime(2026, 8, 15, 11),
        posicaoReferenciaParcela: PosicaoReferenciaParcela.p1,
      ),
    );

    estado = await repositorioArvores.observarColeta(parcelaId).first;
    final primeiroArvore = estado.arvores.firstWhere(
      (arvore) => arvore.id == primeiroArvoreId,
    );
    final substituicaoArvore = estado.arvores.firstWhere(
      (arvore) => arvore.id == substituicaoArvoreId,
    );

    expect(estado.arvores, hasLength(2));
    expect(primeiroArvore.posicaoReferenciaParcela, isNull);
    expect(
      substituicaoArvore.posicaoReferenciaParcela,
      PosicaoReferenciaParcela.p1,
    );
    expect(estado.pontosReferencia, hasLength(1));
    expect(estado.pontosReferencia.single.latitude, closeTo(-28.6123, 0.00001));
    expect(
      estado.pontosReferencia.single.longitude,
      closeTo(-50.8123, 0.00001),
    );

    await repositorioArvores.marcarParcelaColetada(parcelaId);
    estado = await repositorioArvores.observarColeta(parcelaId).first;

    expect(estado.parcela.situacao, SituacaoParcela.coletada);

    await repositorioLevantamentos.concluirLevantamento(
      talhaoLevantamento.levantamentoId,
    );

    final concluidoLevantamentos = await bancoDados
        .select(bancoDados.levantamentos)
        .get();
    expect(
      concluidoLevantamentos.single.situacao,
      SituacaoLevantamento.concluido,
    );
    expect(concluidoLevantamentos.single.concluidoEm, isNotNull);
    expect(
      await repositorioLevantamentos.observarLevantamentosAtivos().first,
      isEmpty,
    );

    await repositorioParcelas.iniciarNovoLevantamentoParaTalhao(talhaoId);
    final levantamentosAposReiniciar = await bancoDados
        .select(bancoDados.levantamentos)
        .get();
    expect(levantamentosAposReiniciar, hasLength(2));
    expect(
      levantamentosAposReiniciar.where(
        (levantamento) =>
            levantamento.situacao == SituacaoLevantamento.emAndamento,
      ),
      hasLength(1),
    );
  });

  test(
    'repositorio agrupa levantamentos ativos antigos da mesma propriedade',
    () async {
      final repositorioPropriedades = RepositorioPropriedades(bancoDados);
      final repositorioTalhoes = RepositorioTalhoes(bancoDados);
      final repositorioLevantamentos = RepositorioLevantamentos(bancoDados);

      final propriedadeId = await repositorioPropriedades.criar(
        nome: 'Fazenda Agrupada',
        municipio: 'Vacaria',
        areaTotalHa: 80,
      );
      final especies = await repositorioTalhoes.observarEspeciesAtivas().first;
      final pinus = especies.firstWhere((item) => item.nome == 'Pinus');
      final modeloMatematico =
          (await bancoDados.select(bancoDados.modelosMatematicos).get()).first;

      final primeiroTalhaoId = await repositorioTalhoes.criar(
        propriedadeId: propriedadeId,
        identificacao: 'A-01',
        especieId: pinus.id,
        areaHa: 12,
      );
      final segundoTalhaoId = await repositorioTalhoes.criar(
        propriedadeId: propriedadeId,
        identificacao: 'A-02',
        especieId: pinus.id,
        areaHa: 8,
      );

      final iniciadoEm = DateTime(2026, 8, 22, 8);
      await bancoDados
          .into(bancoDados.levantamentos)
          .insert(
            LevantamentosCompanion.insert(
              id: const drift.Value(101),
              propriedadeId: propriedadeId,
              situacao: SituacaoLevantamento.emAndamento,
              iniciadoEm: iniciadoEm,
              atualizadoEm: iniciadoEm,
            ),
          );
      await bancoDados
          .into(bancoDados.levantamentos)
          .insert(
            LevantamentosCompanion.insert(
              id: const drift.Value(102),
              propriedadeId: propriedadeId,
              situacao: SituacaoLevantamento.emAndamento,
              iniciadoEm: iniciadoEm.add(const Duration(minutes: 5)),
              atualizadoEm: iniciadoEm.add(const Duration(minutes: 5)),
            ),
          );

      await bancoDados
          .into(bancoDados.talhaoLevantamentos)
          .insert(
            TalhaoLevantamentosCompanion.insert(
              id: const drift.Value(101),
              levantamentoId: 101,
              talhaoId: primeiroTalhaoId,
              especieId: pinus.id,
              modeloMatematicoId: modeloMatematico.id,
              criadoEm: iniciadoEm,
              atualizadoEm: iniciadoEm,
            ),
          );
      await bancoDados
          .into(bancoDados.talhaoLevantamentos)
          .insert(
            TalhaoLevantamentosCompanion.insert(
              id: const drift.Value(102),
              levantamentoId: 102,
              talhaoId: segundoTalhaoId,
              especieId: pinus.id,
              modeloMatematicoId: modeloMatematico.id,
              criadoEm: iniciadoEm.add(const Duration(minutes: 5)),
              atualizadoEm: iniciadoEm.add(const Duration(minutes: 5)),
            ),
          );

      final ativoLevantamentos = await repositorioLevantamentos
          .observarLevantamentosAtivos()
          .first;

      expect(ativoLevantamentos, hasLength(1));
      expect(ativoLevantamentos.single.propriedade.nome, 'Fazenda Agrupada');
      expect(ativoLevantamentos.single.talhoes, hasLength(2));
      expect(
        ativoLevantamentos.single.talhoes.map(
          (resumo) => resumo.talhao.identificacao,
        ),
        containsAll(['A-01', 'A-02']),
      );

      final armazenadoLevantamentos = await bancoDados
          .select(bancoDados.levantamentos)
          .get();
      expect(armazenadoLevantamentos, hasLength(1));
      expect(armazenadoLevantamentos.single.id, 102);
    },
  );

  test('repositorio exclui levantamento e dados vinculados', () async {
    final repositorioPropriedades = RepositorioPropriedades(bancoDados);
    final repositorioTalhoes = RepositorioTalhoes(bancoDados);
    final repositorioParcelas = RepositorioParcelas(bancoDados);
    final repositorioArvores = RepositorioArvores(bancoDados);
    final repositorioLevantamentos = RepositorioLevantamentos(bancoDados);

    final propriedadeId = await repositorioPropriedades.criar(
      nome: 'Fazenda Desistencia',
      municipio: 'Vacaria',
      areaTotalHa: 30,
    );
    final especies = await repositorioTalhoes.observarEspeciesAtivas().first;
    final pinus = especies.firstWhere((item) => item.nome == 'Pinus');

    final talhaoId = await repositorioTalhoes.criar(
      propriedadeId: propriedadeId,
      identificacao: 'D-01',
      especieId: pinus.id,
      areaHa: 10,
    );

    final talhaoLevantamento = await repositorioParcelas
        .iniciarNovoLevantamentoParaTalhao(talhaoId);
    final parcelaId = await repositorioParcelas
        .criarParcelaParaTalhaoLevantamento(
          talhaoLevantamentoId: talhaoLevantamento.id,
          areaHa: 0.04,
        );
    await repositorioArvores.criarArvore(
      parcelaId: parcelaId,
      rascunho: RascunhoArvore(
        dapCm: 24,
        alturaM: 15,
        possuiTroncoTortuoso: false,
        latitude: -28.5,
        longitude: -50.9,
        precisaoMetros: 3,
        localizacaoCapturadaEm: DateTime(2026, 8, 22, 10),
        posicaoReferenciaParcela: PosicaoReferenciaParcela.p1,
      ),
    );

    expect(
      await bancoDados.select(bancoDados.levantamentos).get(),
      hasLength(1),
    );
    expect(
      await bancoDados.select(bancoDados.talhaoLevantamentos).get(),
      hasLength(1),
    );
    expect(await bancoDados.select(bancoDados.parcelas).get(), hasLength(1));
    expect(await bancoDados.select(bancoDados.arvores).get(), hasLength(1));
    final arvoreComReferencia =
        (await bancoDados.select(bancoDados.arvores).get()).single;
    expect(
      arvoreComReferencia.posicaoReferenciaParcela,
      PosicaoReferenciaParcela.p1,
    );

    await repositorioLevantamentos.excluirLevantamento(
      talhaoLevantamento.levantamentoId,
    );

    expect(await bancoDados.select(bancoDados.levantamentos).get(), isEmpty);
    expect(
      await bancoDados.select(bancoDados.talhaoLevantamentos).get(),
      isEmpty,
    );
    expect(await bancoDados.select(bancoDados.parcelas).get(), isEmpty);
    expect(await bancoDados.select(bancoDados.arvores).get(), isEmpty);
    expect(
      await bancoDados.select(bancoDados.propriedades).get(),
      hasLength(1),
    );
    expect(await bancoDados.select(bancoDados.talhoes).get(), hasLength(1));
    expect(await repositorioLevantamentos.observarTodos().first, isEmpty);
  });

  test('repositorio edita e remove talhao de um levantamento', () async {
    final repositorioPropriedades = RepositorioPropriedades(bancoDados);
    final repositorioTalhoes = RepositorioTalhoes(bancoDados);
    final repositorioParcelas = RepositorioParcelas(bancoDados);
    final repositorioArvores = RepositorioArvores(bancoDados);
    final repositorioLevantamentos = RepositorioLevantamentos(bancoDados);

    final propriedadeId = await repositorioPropriedades.criar(
      nome: 'Fazenda Ajuste',
      municipio: 'Vacaria',
      areaTotalHa: 50,
    );
    final especies = await repositorioTalhoes.observarEspeciesAtivas().first;
    final pinus = especies.firstWhere((item) => item.nome == 'Pinus');
    final eucalyptus = especies.firstWhere((item) => item.nome == 'Eucalyptus');

    final primeiroTalhaoId = await repositorioTalhoes.criar(
      propriedadeId: propriedadeId,
      identificacao: 'R-01',
      especieId: pinus.id,
      areaHa: 10,
    );
    final segundoTalhaoId = await repositorioTalhoes.criar(
      propriedadeId: propriedadeId,
      identificacao: 'R-02',
      especieId: pinus.id,
      areaHa: 12,
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
      rascunho: RascunhoArvore(
        dapCm: 21,
        alturaM: 13,
        possuiTroncoTortuoso: false,
        latitude: -28.5,
        longitude: -50.9,
        localizacaoCapturadaEm: DateTime(2026, 8, 22, 11),
        posicaoReferenciaParcela: PosicaoReferenciaParcela.p1,
      ),
    );

    final segundoTalhao = await repositorioParcelas
        .iniciarNovoLevantamentoParaTalhao(segundoTalhaoId);
    expect(primeiroTalhao.levantamentoId, segundoTalhao.levantamentoId);

    await repositorioLevantamentos.atualizarTalhaoNoLevantamento(
      talhaoLevantamentoId: segundoTalhao.id,
      identificacao: 'R-02 ajustado',
      especieId: eucalyptus.id,
      areaHa: 14,
      anoPlantio: 2020,
      espacamento: '3 x 2',
      regimeManejo: 'Desbaste',
      observacoes: 'Ajustado no levantamento',
    );

    var resumo = await repositorioLevantamentos
        .observarPorId(primeiroTalhao.levantamentoId)
        .first;
    expect(resumo, isNotNull);
    var ajustadoTalhao = resumo!.talhoes.firstWhere(
      (item) => item.talhaoLevantamento.id == segundoTalhao.id,
    );
    expect(ajustadoTalhao.talhao.identificacao, 'R-02 ajustado');
    expect(ajustadoTalhao.talhao.areaHa, 14);
    expect(ajustadoTalhao.talhao.anoPlantio, 2020);
    expect(ajustadoTalhao.especie.nome, 'Eucalyptus');

    await repositorioLevantamentos.removerTalhaoDeLevantamento(
      primeiroTalhao.id,
    );

    resumo = await repositorioLevantamentos
        .observarPorId(primeiroTalhao.levantamentoId)
        .first;
    expect(resumo, isNotNull);
    expect(resumo!.talhoes, hasLength(1));
    expect(resumo.talhoes.single.talhaoLevantamento.id, segundoTalhao.id);
    expect(
      await bancoDados.select(bancoDados.levantamentos).get(),
      hasLength(1),
    );
    expect(
      await bancoDados.select(bancoDados.talhaoLevantamentos).get(),
      hasLength(1),
    );
    expect(await bancoDados.select(bancoDados.parcelas).get(), isEmpty);
    expect(await bancoDados.select(bancoDados.arvores).get(), isEmpty);
    expect(await bancoDados.select(bancoDados.talhoes).get(), hasLength(2));
  });

  test('repositorio de resultados calcula dashboard com filtros', () async {
    final repositorioPropriedades = RepositorioPropriedades(bancoDados);
    final repositorioTalhoes = RepositorioTalhoes(bancoDados);
    final repositorioParcelas = RepositorioParcelas(bancoDados);
    final repositorioArvores = RepositorioArvores(bancoDados);
    final repositorioResultados = RepositorioResultados(bancoDados);
    final repositorioLevantamentos = RepositorioLevantamentos(bancoDados);

    final propriedadeId = await repositorioPropriedades.criar(
      nome: 'Fazenda Resultado',
      municipio: 'Vacaria',
      areaTotalHa: 100,
    );
    final especies = await repositorioTalhoes.observarEspeciesAtivas().first;
    final pinus = especies.firstWhere((item) => item.nome == 'Pinus');
    final eucalyptus = especies.firstWhere((item) => item.nome == 'Eucalyptus');

    final pinusTalhaoId = await repositorioTalhoes.criar(
      propriedadeId: propriedadeId,
      identificacao: 'P-01',
      especieId: pinus.id,
      areaHa: 10,
    );
    final eucalyptusTalhaoId = await repositorioTalhoes.criar(
      propriedadeId: propriedadeId,
      identificacao: 'E-01',
      especieId: eucalyptus.id,
      areaHa: 12,
    );

    final pinusTalhao = await repositorioParcelas
        .iniciarNovoLevantamentoParaTalhao(pinusTalhaoId);
    final pinusParcelaId = await repositorioParcelas
        .criarParcelaParaTalhaoLevantamento(
          talhaoLevantamentoId: pinusTalhao.id,
          areaHa: 0.04,
        );
    await repositorioArvores.criarArvore(
      parcelaId: pinusParcelaId,
      rascunho: const RascunhoArvore(
        dapCm: 20,
        alturaM: 10,
        possuiTroncoTortuoso: false,
      ),
    );
    await repositorioArvores.criarArvore(
      parcelaId: pinusParcelaId,
      rascunho: const RascunhoArvore(
        dapCm: 25,
        alturaM: 14,
        possuiTroncoTortuoso: true,
      ),
    );
    await repositorioArvores.marcarParcelaColetada(pinusParcelaId);

    final eucalyptusTalhao = await repositorioParcelas
        .iniciarNovoLevantamentoParaTalhao(eucalyptusTalhaoId);
    final eucalyptusParcelaId = await repositorioParcelas
        .criarParcelaParaTalhaoLevantamento(
          talhaoLevantamentoId: eucalyptusTalhao.id,
          areaHa: 0.05,
        );
    await repositorioArvores.criarArvore(
      parcelaId: eucalyptusParcelaId,
      rascunho: const RascunhoArvore(
        dapCm: 30,
        alturaM: 18,
        possuiTroncoTortuoso: false,
      ),
    );

    final opcoes = await repositorioResultados.observarOpcoesFiltros().first;
    expect(opcoes.propriedades.single.nome, 'Fazenda Resultado');
    expect(opcoes.levantamentos, hasLength(1));
    expect(opcoes.talhoes, hasLength(2));
    expect(
      opcoes.especies.map((item) => item.nome),
      containsAll(['Pinus', 'Eucalyptus']),
    );
    expect(opcoes.talhoesVisiveis(), isEmpty);
    expect(
      opcoes
          .talhoesVisiveis(
            levantamentoId: pinusTalhao.levantamentoId,
            especieId: pinus.id,
          )
          .single
          .talhao
          .id,
      pinusTalhaoId,
    );

    final semFiltro = await repositorioResultados
        .observarPainel(
          const FiltrosResultados(
            propriedadeId: null,
            levantamentoId: null,
            talhaoIds: {},
            especieId: null,
          ),
        )
        .first;

    expect(semFiltro.arvoreQuantidade, 0);
    expect(semFiltro.troncoTortuosoQuantidade, 0);
    expect(semFiltro.troncoTortuosoPercentual, 0);
    expect(semFiltro.talhoes, isEmpty);

    final painel = await repositorioResultados
        .observarPainel(
          FiltrosResultados(
            propriedadeId: propriedadeId,
            levantamentoId: pinusTalhao.levantamentoId,
            talhaoIds: const {},
            especieId: null,
          ),
        )
        .first;

    expect(painel.arvoreQuantidade, 2);
    expect(painel.troncoTortuosoQuantidade, 1);
    expect(painel.troncoTortuosoPercentual, closeTo(50, 0.0001));
    expect(painel.parcelaQuantidade, 1);
    expect(painel.coletadaParcelaQuantidade, 1);
    expect(painel.medidaParcelaQuantidade, 1);
    expect(painel.medidaAreaHa, closeTo(0.04, 0.0001));
    expect(painel.mediaDapCm, closeTo(22.5, 0.0001));
    expect(painel.mediaAlturaM, closeTo(12, 0.0001));
    expect(
      painel.diametroClasses.map((item) => item.rotulo),
      containsAll(['20-24', '25-29']),
    );
    expect(
      painel.diametroClasses.map((item) => item.rotulo),
      isNot(contains('30-34')),
    );

    final pinusSomente = await repositorioResultados
        .observarPainel(
          FiltrosResultados(
            propriedadeId: propriedadeId,
            levantamentoId: pinusTalhao.levantamentoId,
            talhaoIds: {pinusTalhaoId},
            especieId: null,
          ),
        )
        .first;

    expect(pinusSomente.arvoreQuantidade, 2);
    expect(pinusSomente.troncoTortuosoQuantidade, 1);
    expect(pinusSomente.troncoTortuosoPercentual, closeTo(50, 0.0001));
    expect(pinusSomente.talhoes.single.troncoTortuosoQuantidade, 1);
    expect(
      pinusSomente.talhoes.single.troncoTortuosoPercentual,
      closeTo(50, 0.0001),
    );
    expect(pinusSomente.talhoes.single.talhao.identificacao, 'P-01');
    expect(pinusSomente.mediaDapCm, closeTo(22.5, 0.0001));

    final pinusEntrePropriedades = await repositorioResultados
        .observarPainel(
          FiltrosResultados(
            propriedadeId: null,
            levantamentoId: pinusTalhao.levantamentoId,
            talhaoIds: const {},
            especieId: pinus.id,
          ),
        )
        .first;

    expect(pinusEntrePropriedades.arvoreQuantidade, 2);
    expect(pinusEntrePropriedades.talhoes.single.talhao.id, pinusTalhaoId);

    await repositorioLevantamentos.concluirLevantamento(
      pinusTalhao.levantamentoId,
    );
    final novoPinusTalhao = await repositorioParcelas
        .iniciarNovoLevantamentoParaTalhao(pinusTalhaoId);
    final novaParcelaId = await repositorioParcelas
        .criarParcelaParaTalhaoLevantamento(
          talhaoLevantamentoId: novoPinusTalhao.id,
          areaHa: 0.04,
        );
    await repositorioArvores.criarArvore(
      parcelaId: novaParcelaId,
      rascunho: const RascunhoArvore(
        dapCm: 40,
        alturaM: 22,
        possuiTroncoTortuoso: false,
      ),
    );
    await repositorioArvores.marcarParcelaColetada(novaParcelaId);

    final levantamentoAnterior = await repositorioResultados
        .observarPainel(
          FiltrosResultados(
            propriedadeId: propriedadeId,
            levantamentoId: pinusTalhao.levantamentoId,
            talhaoIds: const {},
            especieId: null,
          ),
        )
        .first;
    final levantamentoNovo = await repositorioResultados
        .observarPainel(
          FiltrosResultados(
            propriedadeId: propriedadeId,
            levantamentoId: novoPinusTalhao.levantamentoId,
            talhaoIds: const {},
            especieId: null,
          ),
        )
        .first;
    final levantamentoMaisRecentePorTalhao = await repositorioResultados
        .observarPainel(
          FiltrosResultados(
            propriedadeId: propriedadeId,
            levantamentoId: null,
            talhaoIds: {pinusTalhaoId},
            especieId: null,
          ),
        )
        .first;

    expect(levantamentoAnterior.arvoreQuantidade, 2);
    expect(levantamentoAnterior.mediaDapCm, closeTo(22.5, 0.0001));
    expect(levantamentoNovo.arvoreQuantidade, 1);
    expect(levantamentoNovo.mediaDapCm, closeTo(40, 0.0001));
    expect(levantamentoMaisRecentePorTalhao.arvoreQuantidade, 1);
    expect(levantamentoMaisRecentePorTalhao.mediaDapCm, closeTo(40, 0.0001));
  });

  test('repositorios registram historico de atividades', () async {
    final repositorioRegistroAtividade = RepositorioAtividades(bancoDados);
    final repositorioPropriedades = RepositorioPropriedades(bancoDados);
    final repositorioTalhoes = RepositorioTalhoes(bancoDados);
    final repositorioParcelas = RepositorioParcelas(bancoDados);
    final repositorioArvores = RepositorioArvores(bancoDados);
    final repositorioLevantamentos = RepositorioLevantamentos(bancoDados);

    expect(await repositorioRegistroAtividade.recente(limite: 20), isEmpty);

    final propriedadeId = await repositorioPropriedades.criar(
      nome: 'Fazenda Log',
      municipio: 'Vacaria',
      areaTotalHa: 20,
    );
    final talhaoId = await repositorioTalhoes.criar(
      propriedadeId: propriedadeId,
      identificacao: 'L-01',
      especieId: pinusId,
      areaHa: 10,
    );
    final talhaoLevantamento = await repositorioParcelas
        .iniciarNovoLevantamentoParaTalhao(talhaoId);
    final parcelaId = await repositorioParcelas
        .criarParcelaParaTalhaoLevantamento(
          talhaoLevantamentoId: talhaoLevantamento.id,
          areaHa: 0.04,
        );
    await repositorioArvores.criarArvore(
      parcelaId: parcelaId,
      rascunho: const RascunhoArvore(
        dapCm: 20,
        alturaM: 12,
        possuiTroncoTortuoso: false,
      ),
    );
    await repositorioArvores.marcarParcelaColetada(parcelaId);
    await repositorioLevantamentos.concluirLevantamento(
      talhaoLevantamento.levantamentoId,
    );

    final registros = await repositorioRegistroAtividade.recente(limite: 20);
    final tipos = registros.map((atividade) => atividade.tipo).toSet();

    expect(tipos, contains(TipoAtividade.propriedadeCriada));
    expect(tipos, contains(TipoAtividade.talhaoCriado));
    expect(tipos, contains(TipoAtividade.levantamentoIniciado));
    expect(tipos, contains(TipoAtividade.parcelaCriada));
    expect(tipos, contains(TipoAtividade.parcelaColetada));
    expect(tipos, contains(TipoAtividade.levantamentoConcluido));
    expect(tipos, contains(TipoAtividade.talhaoConcluido));
    expect(
      registros.map((atividade) => atividade.titulo),
      isNot(contains('Exportacao realizada')),
    );
  });

  test('suficiencia e resultados usam somente parcelas finalizadas', () async {
    final propriedades = RepositorioPropriedades(bancoDados);
    final talhoes = RepositorioTalhoes(bancoDados);
    final parcelas = RepositorioParcelas(bancoDados);
    final arvores = RepositorioArvores(bancoDados);
    final levantamentos = RepositorioLevantamentos(bancoDados);
    final resultados = RepositorioResultados(bancoDados);

    final propriedadeId = await propriedades.criar(
      nome: 'Fazenda Suficiência',
      municipio: 'Santa Maria',
      areaTotalHa: 20,
    );
    final talhaoId = await talhoes.criar(
      propriedadeId: propriedadeId,
      identificacao: 'T-01',
      especieId: pinusId,
      areaHa: 10,
      larguraParcelaM: 20,
      comprimentoParcelaM: 20,
    );
    final vinculo = await parcelas.iniciarNovoLevantamentoParaTalhao(
      talhaoId,
      erroAmostralMaximoPercentual: 4.5,
    );

    for (var indice = 0; indice < 3; indice++) {
      final parcelaId = await parcelas.criarParcelaParaTalhaoLevantamento(
        talhaoLevantamentoId: vinculo.id,
        areaHa: 0.04,
      );
      await arvores.criarArvore(
        parcelaId: parcelaId,
        rascunho: RascunhoArvore(
          dapCm: indice == 2 ? 80 : 20,
          alturaM: indice == 2 ? 30 : 12,
          possuiTroncoTortuoso: false,
        ),
      );
      if (indice < 2) {
        await arvores.marcarParcelaColetada(parcelaId);
      }
    }

    final resumo = await levantamentos
        .observarPorId(vinculo.levantamentoId)
        .first;
    final avaliacao = (await levantamentos.avaliarSuficienciaAmostral(
      resumo!,
    )).single;

    expect(
      resumo.talhoes.single.talhaoLevantamento.erroAmostralMaximoPercentual,
      4.5,
    );
    expect(avaliacao.parcelasRegistradas, 3);
    expect(avaliacao.parcelasAbertas, 1);
    expect(avaliacao.resultado.parcelasUtilizadas, 2);
    expect(avaliacao.resultado.erroMaximoPercentual, 4.5);
    expect(avaliacao.resultado.suficiente, isTrue);

    final painel = await resultados
        .observarPainel(
          FiltrosResultados(
            propriedadeId: propriedadeId,
            levantamentoId: vinculo.levantamentoId,
            talhaoIds: const {},
            especieId: null,
          ),
        )
        .first;
    expect(painel.parcelaQuantidade, 2);
    expect(painel.arvoreQuantidade, 2);
    expect(painel.mediaDapCm, 20);
  });
}
