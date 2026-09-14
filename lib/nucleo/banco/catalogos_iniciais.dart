import 'package:drift/drift.dart';
import '../floresta/calculadora_volume_florestal.dart';
import 'migracao_ids_inteiros.dart';

// Referência imutável do catálogo v10. IDs textuais servem apenas à migração
// e à resolução de códigos do catálogo; nunca são gravados como PK na v11.
const _catalogoLegado = <String, List<Map<String, Object?>>>{
  "especies": [
    {
      "id": "species_pinus",
      "nome": "Pinus",
      "nome_cientifico": "Pinus spp.",
      "descricao": "Cadastro base para florestas de Pinus.",
      "ativo": 1,
      "criado_em": 0,
      "atualizado_em": 0,
    },
    {
      "id": "species_eucalyptus",
      "nome": "Eucalyptus",
      "nome_cientifico": "Eucalyptus spp.",
      "descricao": "Cadastro base para florestas de Eucalyptus/Eucalipto.",
      "ativo": 1,
      "criado_em": 0,
      "atualizado_em": 0,
    },
  ],
  "modelos_matematicos": [
    {
      "id": "formula_spurr",
      "nome": "Modelo de Spurr",
      "descricao":
          "Modelo volumétrico usado como padrão para Pinus e Eucalyptus no inventário de referência.",
      "expressao": "a + b * (D^2 * H)",
      "ativo": 1,
      "criado_em": 0,
      "atualizado_em": 0,
    },
    {
      "id": "formula_schumacher_hall",
      "nome": "Schumacher-Hall",
      "descricao":
          "Modelo volumétrico ajustado a partir dos dados de cubagem do inventário de referência.",
      "expressao": "exp(a + b * ln(D) + c * ln(H))",
      "ativo": 1,
      "criado_em": 0,
      "atualizado_em": 0,
    },
    {
      "id": "formula_form_factor",
      "nome": "Fator de Forma",
      "descricao":
          "DAP informado em centímetros, convertido para metros no cálculo (D / 100). Altura em metros e fator de forma (ff) informado pelo usuário.",
      "expressao": "pi * (D / 100)^2 * H * ff",
      "ativo": 1,
      "criado_em": 0,
      "atualizado_em": 0,
    },
  ],
  "variaveis_modelo": [
    {
      "id": "formula_spurr_dap",
      "modelo_matematico_id": "formula_spurr",
      "simbolo": "D",
      "rotulo": "DAP",
      "unidade": "cm",
      "origem_valor": "Medição da árvore",
      "chave_variavel": "dap",
    },
    {
      "id": "formula_spurr_height",
      "modelo_matematico_id": "formula_spurr",
      "simbolo": "H",
      "rotulo": "Altura",
      "unidade": "m",
      "origem_valor": "Medição da árvore",
      "chave_variavel": "altura",
    },
    {
      "id": "formula_schumacher_hall_dap",
      "modelo_matematico_id": "formula_schumacher_hall",
      "simbolo": "D",
      "rotulo": "DAP",
      "unidade": "cm",
      "origem_valor": "Medição da árvore",
      "chave_variavel": "dap",
    },
    {
      "id": "formula_schumacher_hall_height",
      "modelo_matematico_id": "formula_schumacher_hall",
      "simbolo": "H",
      "rotulo": "Altura",
      "unidade": "m",
      "origem_valor": "Medição da árvore",
      "chave_variavel": "altura",
    },
    {
      "id": "formula_form_factor_dap",
      "modelo_matematico_id": "formula_form_factor",
      "simbolo": "D",
      "rotulo": "DAP",
      "unidade": "cm",
      "origem_valor": "Medição da árvore",
      "chave_variavel": "dap",
    },
    {
      "id": "formula_form_factor_height",
      "modelo_matematico_id": "formula_form_factor",
      "simbolo": "H",
      "rotulo": "Altura",
      "unidade": "m",
      "origem_valor": "Medição da árvore",
      "chave_variavel": "altura",
    },
  ],
  "coeficientes_modelo": [
    {
      "id": "formula_spurr_a",
      "modelo_matematico_id": "formula_spurr",
      "simbolo": "a",
      "rotulo": "Coeficiente a",
      "valor": 0.0175858265880592,
    },
    {
      "id": "formula_spurr_b",
      "modelo_matematico_id": "formula_spurr",
      "simbolo": "b",
      "rotulo": "Coeficiente b",
      "valor": 0.0000329326161133665,
    },
    {
      "id": "formula_schumacher_hall_a",
      "modelo_matematico_id": "formula_schumacher_hall",
      "simbolo": "a",
      "rotulo": "Coeficiente a",
      "valor": -11.584059201173265,
    },
    {
      "id": "formula_schumacher_hall_b",
      "modelo_matematico_id": "formula_schumacher_hall",
      "simbolo": "b",
      "rotulo": "Coeficiente b",
      "valor": 1.8114471288118603,
    },
    {
      "id": "formula_schumacher_hall_c",
      "modelo_matematico_id": "formula_schumacher_hall",
      "simbolo": "c",
      "rotulo": "Coeficiente c",
      "valor": 1.6187968875426328,
    },
    {
      "id": "formula_form_factor_ff",
      "modelo_matematico_id": "formula_form_factor",
      "simbolo": "ff",
      "rotulo": "Fator de forma",
      "valor": null,
    },
  ],
  "especies_modelos": [
    {
      "especie_id": "species_pinus",
      "modelo_matematico_id": "formula_spurr",
      "padrao": 1,
      "criado_em": 0,
    },
    {
      "especie_id": "species_pinus",
      "modelo_matematico_id": "formula_schumacher_hall",
      "padrao": 0,
      "criado_em": 0,
    },
    {
      "especie_id": "species_eucalyptus",
      "modelo_matematico_id": "formula_spurr",
      "padrao": 1,
      "criado_em": 0,
    },
    {
      "especie_id": "species_eucalyptus",
      "modelo_matematico_id": "formula_schumacher_hall",
      "padrao": 0,
      "criado_em": 0,
    },
    {
      "especie_id": "species_eucalyptus",
      "modelo_matematico_id": "formula_form_factor",
      "padrao": 0,
      "criado_em": 0,
    },
    {
      "especie_id": "species_pinus",
      "modelo_matematico_id": "formula_form_factor",
      "padrao": 0,
      "criado_em": 0,
    },
  ],
  "coeficientes_especie_modelo": [
    {
      "id": "species_pinus_formula_spurr_a",
      "especie_id": "species_pinus",
      "modelo_matematico_id": "formula_spurr",
      "simbolo": "a",
      "rotulo": "Coeficiente a",
      "valor": 0.0175858265880592,
      "atualizado_em": 0,
    },
    {
      "id": "species_pinus_formula_spurr_b",
      "especie_id": "species_pinus",
      "modelo_matematico_id": "formula_spurr",
      "simbolo": "b",
      "rotulo": "Coeficiente b",
      "valor": 0.0000329326161133665,
      "atualizado_em": 0,
    },
    {
      "id": "species_pinus_formula_schumacher_hall_a",
      "especie_id": "species_pinus",
      "modelo_matematico_id": "formula_schumacher_hall",
      "simbolo": "a",
      "rotulo": "Coeficiente a",
      "valor": -11.584059201173265,
      "atualizado_em": 0,
    },
    {
      "id": "species_pinus_formula_schumacher_hall_b",
      "especie_id": "species_pinus",
      "modelo_matematico_id": "formula_schumacher_hall",
      "simbolo": "b",
      "rotulo": "Coeficiente b",
      "valor": 1.8114471288118603,
      "atualizado_em": 0,
    },
    {
      "id": "species_pinus_formula_schumacher_hall_c",
      "especie_id": "species_pinus",
      "modelo_matematico_id": "formula_schumacher_hall",
      "simbolo": "c",
      "rotulo": "Coeficiente c",
      "valor": 1.6187968875426328,
      "atualizado_em": 0,
    },
    {
      "id": "species_eucalyptus_formula_spurr_a",
      "especie_id": "species_eucalyptus",
      "modelo_matematico_id": "formula_spurr",
      "simbolo": "a",
      "rotulo": "Coeficiente a",
      "valor": 0.0175858265880592,
      "atualizado_em": 0,
    },
    {
      "id": "species_eucalyptus_formula_spurr_b",
      "especie_id": "species_eucalyptus",
      "modelo_matematico_id": "formula_spurr",
      "simbolo": "b",
      "rotulo": "Coeficiente b",
      "valor": 0.0000329326161133665,
      "atualizado_em": 0,
    },
    {
      "id": "species_eucalyptus_formula_schumacher_hall_a",
      "especie_id": "species_eucalyptus",
      "modelo_matematico_id": "formula_schumacher_hall",
      "simbolo": "a",
      "rotulo": "Coeficiente a",
      "valor": -11.584059201173265,
      "atualizado_em": 0,
    },
    {
      "id": "species_eucalyptus_formula_schumacher_hall_b",
      "especie_id": "species_eucalyptus",
      "modelo_matematico_id": "formula_schumacher_hall",
      "simbolo": "b",
      "rotulo": "Coeficiente b",
      "valor": 1.8114471288118603,
      "atualizado_em": 0,
    },
    {
      "id": "species_eucalyptus_formula_schumacher_hall_c",
      "especie_id": "species_eucalyptus",
      "modelo_matematico_id": "formula_schumacher_hall",
      "simbolo": "c",
      "rotulo": "Coeficiente c",
      "valor": 1.6187968875426328,
      "atualizado_em": 0,
    },
    {
      "id": "species_eucalyptus_formula_form_factor_ff",
      "especie_id": "species_eucalyptus",
      "modelo_matematico_id": "formula_form_factor",
      "simbolo": "ff",
      "rotulo": "Fator de forma",
      "valor": null,
      "atualizado_em": 0,
    },
    {
      "id": "species_pinus_formula_form_factor_ff",
      "especie_id": "species_pinus",
      "modelo_matematico_id": "formula_form_factor",
      "simbolo": "ff",
      "rotulo": "Fator de forma",
      "valor": null,
      "atualizado_em": 0,
    },
  ],
};
const _estruturaLegada = <String, String>{
  "coeficientes_talhao_levantamento":
      "CREATE TABLE coeficientes_talhao_levantamento (\n  id TEXT NOT NULL PRIMARY KEY,\n  talhao_levantamento_id TEXT NOT NULL REFERENCES talhao_levantamentos(id) ON DELETE CASCADE,\n  simbolo TEXT NOT NULL,\n  rotulo TEXT NOT NULL,\n  valor REAL NULL,\n  UNIQUE(talhao_levantamento_id, simbolo)\n)",
  "registros_atividade":
      "CREATE TABLE registros_atividade (\n  id TEXT NOT NULL PRIMARY KEY,\n  tipo TEXT NOT NULL,\n  titulo TEXT NOT NULL,\n  subtitulo TEXT NOT NULL DEFAULT '',\n  tipo_entidade TEXT NULL,\n  entidade_id TEXT NULL,\n  ocorrido_em INTEGER NOT NULL\n)",
  "coeficientes_especie_modelo":
      "CREATE TABLE \"coeficientes_especie_modelo\" (\"id\" TEXT NOT NULL, \"especie_id\" TEXT NOT NULL REFERENCES especies (id) ON DELETE CASCADE, \"modelo_matematico_id\" TEXT NOT NULL REFERENCES modelos_matematicos (id) ON DELETE CASCADE, \"simbolo\" TEXT NOT NULL, \"rotulo\" TEXT NOT NULL, \"valor\" REAL NULL, \"atualizado_em\" INTEGER NOT NULL, PRIMARY KEY (\"id\"), UNIQUE(especie_id, modelo_matematico_id, simbolo))",
};

Future<void> inserirCatalogosIniciais(GeneratedDatabase banco) async {
  final mapas = <String, Map<String, int>>{};
  final agora = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  for (final tabela in relacionamentosIds.keys.where(
    _catalogoLegado.containsKey,
  )) {
    final mapa = mapas[tabela] = {};
    for (final item in _catalogoLegado[tabela]!) {
      final valores = Map<String, Object?>.from(item);
      final antigoId = valores.remove('id') as String?;
      for (final campo in ['criado_em', 'atualizado_em']) {
        if (valores.containsKey(campo)) valores[campo] = agora;
      }
      for (final fk in relacionamentosIds[tabela]!.entries) {
        valores[fk.key] = mapas[fk.value]![valores[fk.key]]!;
      }
      if (tabela == 'especies' || tabela == 'modelos_matematicos') {
        valores['codigo'] = antigoId;
      }
      final id = await inserirLinha(banco, tabela, valores);
      if (antigoId != null) mapa[antigoId] = id;
    }
  }
}

/// Mantém as etapas históricas anteriores à troca das chaves primárias.
Future<void> completarEstruturaLegada(GeneratedDatabase banco, int de) async {
  final existentes =
      (await banco
              .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
              .get())
          .map((r) => r.read<String>('name'))
          .toSet();
  for (final tabela in [
    'coeficientes_talhao_levantamento',
    'registros_atividade',
    'coeficientes_especie_modelo',
  ]) {
    if (!existentes.contains(tabela)) {
      await banco.customStatement(_estruturaLegada[tabela]!);
    }
  }
  if (de < 6) {
    for (final coluna in ['largura_parcela_m', 'comprimento_parcela_m']) {
      await banco.customStatement(
        'ALTER TABLE talhoes ADD COLUMN $coluna REAL',
      );
    }
  }
  if (de < 7) {
    for (final item in _catalogoLegado['coeficientes_modelo']!) {
      if (item['valor'] != null) {
        await banco.customStatement(
          'UPDATE coeficientes_modelo SET valor = ? WHERE id = ? AND valor IS NULL',
          [item['valor'], item['id']],
        );
      }
    }
    for (final item in _catalogoLegado['modelos_matematicos']!) {
      await banco.customStatement(
        'UPDATE modelos_matematicos SET descricao = ? WHERE id = ? AND (descricao IS NULL OR descricao IN (?, ?))',
        [
          item['descricao'],
          item['id'],
          'Modelo volumétrico configurável.',
          'Modelo volumétrico logarítmico.',
        ],
      );
    }
    final vinculos = await banco
        .customSelect('SELECT * FROM especies_modelos')
        .get();
    for (final vinculo in vinculos) {
      final especie = vinculo.read<String>('especie_id');
      final modelo = vinculo.read<String>('modelo_matematico_id');
      final coeficientes = await banco
          .customSelect(
            'SELECT * FROM coeficientes_modelo WHERE modelo_matematico_id = ?',
            variables: [Variable(modelo)],
          )
          .get();
      for (final c in coeficientes) {
        final simbolo = c.read<String>('simbolo');
        await inserirLinha(banco, 'coeficientes_especie_modelo', {
          'id': '${especie}_${modelo}_$simbolo',
          'especie_id': especie,
          'modelo_matematico_id': modelo,
          'simbolo': simbolo,
          'rotulo': c.data['rotulo'],
          'valor':
              c.data['valor'] ??
              CalculadoraVolumeFlorestal.valorPadraoCoeficiente(
                modeloMatematicoCodigo: modelo,
                simbolo: simbolo,
              ),
          'atualizado_em': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        });
      }
    }
  }
  if (de < 8) {
    for (final tabela in relacionamentosIds.keys.where(
      _catalogoLegado.containsKey,
    )) {
      for (final item in _catalogoLegado[tabela]!) {
        if (item['id'] == 'formula_form_factor' ||
            item['modelo_matematico_id'] == 'formula_form_factor') {
          final valores = Map<String, Object?>.from(item);
          if (valores.containsKey('especie_id')) {
            final existe = await banco
                .customSelect(
                  'SELECT id FROM especies WHERE id = ?',
                  variables: [Variable(valores['especie_id'])],
                )
                .get();
            if (existe.isEmpty) continue;
          }
          for (final campo in ['criado_em', 'atualizado_em']) {
            if (valores.containsKey(campo)) {
              valores[campo] = DateTime.now().millisecondsSinceEpoch ~/ 1000;
            }
          }
          await banco.customStatement(
            'INSERT OR IGNORE INTO "$tabela" (${valores.keys.join(', ')}) VALUES (${List.filled(valores.length, '?').join(', ')})',
            valores.values.toList(),
          );
        }
      }
    }
  }
  if (de < 9) {
    final modelo = (_catalogoLegado['modelos_matematicos']!).firstWhere(
      (m) => m['id'] == 'formula_form_factor',
    );
    await banco.customStatement(
      'UPDATE modelos_matematicos SET nome = ?, expressao = ?, descricao = ?, atualizado_em = ? WHERE id = ?',
      [
        modelo['nome'],
        modelo['expressao'],
        modelo['descricao'],
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'formula_form_factor',
      ],
    );
    for (final tabela in [
      'coeficientes_modelo',
      'coeficientes_especie_modelo',
      'coeficientes_talhao_levantamento',
    ]) {
      await banco.customStatement(
        'UPDATE $tabela SET rotulo = ? WHERE simbolo = ? AND rotulo = ?',
        ['Fator de forma', 'ff', 'Fator de fórmula'],
      );
    }
  }
}
