import 'package:drift/drift.dart';

const codigoPinus = 'species_pinus';
const codigoEucalyptus = 'species_eucalyptus';
const codigoModeloSpurr = 'formula_spurr';
const codigoModeloSchumacherHall = 'formula_schumacher_hall';
const codigoModeloFatorForma = 'formula_form_factor';
const fatorFormaPadraoPinus = 0.50;
const fatorFormaPadraoEucalyptus = 0.45;

Future<void> inserirCatalogosIniciais(GeneratedDatabase banco) async {
  final agora = DateTime.now().millisecondsSinceEpoch;

  final pinusId = await _inserirEspecie(
    banco,
    codigo: codigoPinus,
    nome: 'Pinus',
    nomeCientifico: 'Pinus spp.',
    descricao: 'Cadastro base para florestas de Pinus.',
    agora: agora,
  );
  final eucalyptusId = await _inserirEspecie(
    banco,
    codigo: codigoEucalyptus,
    nome: 'Eucalyptus',
    nomeCientifico: 'Eucalyptus spp.',
    descricao: 'Cadastro base para florestas de Eucalyptus/Eucalipto.',
    agora: agora,
  );

  final spurrId = await _inserirModelo(
    banco,
    codigo: codigoModeloSpurr,
    nome: 'Modelo de Spurr',
    descricao:
        'Modelo volumétrico usado como padrão para Pinus e Eucalyptus no inventário de referência.',
    expressao: 'a + b * (D^2 * H)',
    agora: agora,
  );
  final schumacherHallId = await _inserirModelo(
    banco,
    codigo: codigoModeloSchumacherHall,
    nome: 'Schumacher-Hall',
    descricao:
        'Modelo volumétrico ajustado a partir dos dados de cubagem do inventário de referência.',
    expressao: 'exp(a + b * ln(D) + c * ln(H))',
    agora: agora,
  );
  final fatorFormaId = await _inserirModelo(
    banco,
    codigo: codigoModeloFatorForma,
    nome: 'Fator de Forma',
    descricao:
        'Volume calculado pela área basal (pi / 4 * D²), altura em metros e fator de forma (ff) informado pelo usuário. O DAP é informado em centímetros e convertido para metros.',
    expressao: '(pi / 4) * (D / 100)^2 * H * ff',
    agora: agora,
  );

  for (final modeloId in [spurrId, schumacherHallId, fatorFormaId]) {
    await _inserirVariavel(
      banco,
      modeloId: modeloId,
      simbolo: 'D',
      rotulo: 'DAP',
      unidade: 'cm',
      chave: 'dap',
    );
    await _inserirVariavel(
      banco,
      modeloId: modeloId,
      simbolo: 'H',
      rotulo: 'Altura',
      unidade: 'm',
      chave: 'altura',
    );
  }

  const coeficientesSpurr = [
    ('a', 'Coeficiente a', 0.0175858265880592),
    ('b', 'Coeficiente b', 0.0000329326161133665),
  ];
  const coeficientesSchumacherHall = [
    ('a', 'Coeficiente a', -11.584059201173265),
    ('b', 'Coeficiente b', 1.8114471288118603),
    ('c', 'Coeficiente c', 1.6187968875426328),
  ];
  const coeficientesFatorForma = [('ff', 'Fator de forma', null)];

  for (final coeficiente in coeficientesSpurr) {
    await _inserirCoeficienteModelo(
      banco,
      modeloId: spurrId,
      simbolo: coeficiente.$1,
      rotulo: coeficiente.$2,
      valor: coeficiente.$3,
    );
  }
  for (final coeficiente in coeficientesSchumacherHall) {
    await _inserirCoeficienteModelo(
      banco,
      modeloId: schumacherHallId,
      simbolo: coeficiente.$1,
      rotulo: coeficiente.$2,
      valor: coeficiente.$3,
    );
  }
  for (final coeficiente in coeficientesFatorForma) {
    await _inserirCoeficienteModelo(
      banco,
      modeloId: fatorFormaId,
      simbolo: coeficiente.$1,
      rotulo: coeficiente.$2,
      valor: coeficiente.$3,
    );
  }

  for (final especieId in [pinusId, eucalyptusId]) {
    await _vincularEspecieModelo(
      banco,
      especieId: especieId,
      modeloId: spurrId,
      padrao: true,
      agora: agora,
    );
    await _vincularEspecieModelo(
      banco,
      especieId: especieId,
      modeloId: schumacherHallId,
      agora: agora,
    );
    await _vincularEspecieModelo(
      banco,
      especieId: especieId,
      modeloId: fatorFormaId,
      agora: agora,
    );

    for (final coeficiente in coeficientesSpurr) {
      await _inserirCoeficienteEspecie(
        banco,
        especieId: especieId,
        modeloId: spurrId,
        simbolo: coeficiente.$1,
        rotulo: coeficiente.$2,
        valor: coeficiente.$3,
        agora: agora,
      );
    }
    for (final coeficiente in coeficientesSchumacherHall) {
      await _inserirCoeficienteEspecie(
        banco,
        especieId: especieId,
        modeloId: schumacherHallId,
        simbolo: coeficiente.$1,
        rotulo: coeficiente.$2,
        valor: coeficiente.$3,
        agora: agora,
      );
    }
    for (final coeficiente in coeficientesFatorForma) {
      await _inserirCoeficienteEspecie(
        banco,
        especieId: especieId,
        modeloId: fatorFormaId,
        simbolo: coeficiente.$1,
        rotulo: coeficiente.$2,
        valor: especieId == pinusId
            ? fatorFormaPadraoPinus
            : fatorFormaPadraoEucalyptus,
        agora: agora,
      );
    }
  }
}

Future<int> _inserirEspecie(
  GeneratedDatabase banco, {
  required String codigo,
  required String nome,
  required String nomeCientifico,
  required String descricao,
  required int agora,
}) {
  return banco.customInsert(
    '''INSERT INTO especies
      (codigo, nome, nome_cientifico, descricao, ativo, criado_em, atualizado_em)
      VALUES (?, ?, ?, ?, 1, ?, ?)''',
    variables: [
      Variable(codigo),
      Variable(nome),
      Variable(nomeCientifico),
      Variable(descricao),
      Variable(agora),
      Variable(agora),
    ],
  );
}

Future<int> _inserirModelo(
  GeneratedDatabase banco, {
  required String codigo,
  required String nome,
  required String descricao,
  required String expressao,
  required int agora,
}) {
  return banco.customInsert(
    '''INSERT INTO modelos_matematicos
      (codigo, nome, descricao, expressao, ativo, criado_em, atualizado_em)
      VALUES (?, ?, ?, ?, 1, ?, ?)''',
    variables: [
      Variable(codigo),
      Variable(nome),
      Variable(descricao),
      Variable(expressao),
      Variable(agora),
      Variable(agora),
    ],
  );
}

Future<void> _inserirVariavel(
  GeneratedDatabase banco, {
  required int modeloId,
  required String simbolo,
  required String rotulo,
  required String unidade,
  required String chave,
}) {
  return banco.customStatement(
    '''INSERT INTO variaveis_modelo
      (modelo_matematico_id, simbolo, rotulo, unidade, origem_valor, chave_variavel)
      VALUES (?, ?, ?, ?, 'Medição da árvore', ?)''',
    [modeloId, simbolo, rotulo, unidade, chave],
  );
}

Future<void> _inserirCoeficienteModelo(
  GeneratedDatabase banco, {
  required int modeloId,
  required String simbolo,
  required String rotulo,
  required double? valor,
}) {
  return banco.customStatement(
    '''INSERT INTO coeficientes_modelo
      (modelo_matematico_id, simbolo, rotulo, valor) VALUES (?, ?, ?, ?)''',
    [modeloId, simbolo, rotulo, valor],
  );
}

Future<void> _vincularEspecieModelo(
  GeneratedDatabase banco, {
  required int especieId,
  required int modeloId,
  required int agora,
  bool padrao = false,
}) {
  return banco.customStatement(
    '''INSERT INTO especies_modelos
      (especie_id, modelo_matematico_id, padrao, criado_em)
      VALUES (?, ?, ?, ?)''',
    [especieId, modeloId, padrao ? 1 : 0, agora],
  );
}

Future<void> _inserirCoeficienteEspecie(
  GeneratedDatabase banco, {
  required int especieId,
  required int modeloId,
  required String simbolo,
  required String rotulo,
  required double? valor,
  required int agora,
}) {
  return banco.customStatement(
    '''INSERT INTO coeficientes_especie_modelo
      (especie_id, modelo_matematico_id, simbolo, rotulo, valor, atualizado_em)
      VALUES (?, ?, ?, ?, ?, ?)''',
    [especieId, modeloId, simbolo, rotulo, valor, agora],
  );
}
