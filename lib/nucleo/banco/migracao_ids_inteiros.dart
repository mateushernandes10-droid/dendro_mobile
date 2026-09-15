import 'package:drift/drift.dart';
import 'banco_dendro.dart';
import 'migracao_nomenclatura.dart';

/// Ordem topológica: os pais são copiados antes de seus dependentes.
const relacionamentosIds = <String, Map<String, String>>{
  'propriedades': {},
  'especies': {},
  'modelos_matematicos': {},
  'variaveis_modelo': {'modelo_matematico_id': 'modelos_matematicos'},
  'coeficientes_modelo': {'modelo_matematico_id': 'modelos_matematicos'},
  'especies_modelos': {
    'especie_id': 'especies',
    'modelo_matematico_id': 'modelos_matematicos',
  },
  'coeficientes_especie_modelo': {
    'especie_id': 'especies',
    'modelo_matematico_id': 'modelos_matematicos',
  },
  'talhoes': {'propriedade_id': 'propriedades', 'especie_id': 'especies'},
  'levantamentos': {'propriedade_id': 'propriedades'},
  'talhao_levantamentos': {
    'levantamento_id': 'levantamentos',
    'talhao_id': 'talhoes',
    'especie_id': 'especies',
    'modelo_matematico_id': 'modelos_matematicos',
  },
  'coeficientes_talhao_levantamento': {
    'talhao_levantamento_id': 'talhao_levantamentos',
  },
  'parcelas': {'talhao_levantamento_id': 'talhao_levantamentos'},
  'pontos_geograficos_parcela': {'parcela_id': 'parcelas'},
  'arvores': {'parcela_id': 'parcelas'},
  'registros_atividade': {},
};

const tabelasEntidadeAtividade = {
  'propriedade': 'propriedades', 'talhao': 'talhoes', 'parcela': 'parcelas',
  'especie': 'especies', 'modeloMatematico': 'modelos_matematicos',
  'levantamento': 'levantamentos',
  // O exportador registra o ID da propriedade, não um arquivo persistido.
  'exportacao': 'propriedades',
};

Future<void> migrarParaIdsInteiros(
  BancoDendro banco,
  Migrator migrador,
  int de,
) async {
  // A versão 1 também foi publicada com o esquema atual. Inspecionar a
  // estrutura evita converter novamente seus IDs, assim como os da versão 11.
  final campos = await banco.customSelect('PRAGMA table_info(especies)').get();
  if (campos.any(
    (c) =>
        c.data['name'] == 'id' &&
        c.read<String>('type').toUpperCase() == 'INTEGER',
  )) {
    return;
  }
  final chavesAtivas =
      (await banco.customSelect('PRAGMA foreign_keys').getSingle()).read<int>(
        'foreign_keys',
      );
  // SQLite exige alterar esta opção fora de transação. A checagem explícita
  // abaixo impede concluir a migração com relacionamentos inválidos.
  await banco.customStatement('PRAGMA foreign_keys = OFF');
  try {
    await banco.transaction(() async {
      await migrarNomenclaturaParaPortugues(banco);
      final existentes =
          (await banco
                  .customSelect(
                    "SELECT name FROM sqlite_master WHERE type = 'table'",
                  )
                  .get())
              .map((r) => r.read<String>('name'))
              .toSet();
      for (final tabela in relacionamentosIds.keys.where(existentes.contains)) {
        await banco.customStatement(
          'ALTER TABLE "$tabela" RENAME TO "legado_v10_$tabela"',
        );
      }
      await migrador.createAll();
      // Referências de atividades a entidades já excluídas não têm um novo ID.
      // Preservar o identificador original como metadado somente no banco legado.
      await banco.customStatement(
        'ALTER TABLE registros_atividade ADD COLUMN referencia_legada TEXT',
      );
      final mapas = <String, Map<String, int>>{};
      for (final entrada in relacionamentosIds.entries) {
        final tabela = entrada.key;
        final linhas = !existentes.contains(tabela)
            ? <QueryRow>[]
            : await banco
                  .customSelect(
                    'SELECT * FROM "legado_v10_$tabela" ORDER BY rowid',
                  )
                  .get();
        final mapa = mapas[tabela] = {};
        for (final linha in linhas) {
          final valores = Map<String, Object?>.of(linha.data);
          final antigoId = valores.remove('id') as String?;
          for (final fk in entrada.value.entries) {
            final antigo = valores[fk.key];
            final novo = mapas[fk.value]?[antigo];
            if (novo == null) {
              throw StateError('Referência inválida: $tabela.${fk.key}');
            }
            valores[fk.key] = novo;
          }
          if (tabela == 'especies' || tabela == 'modelos_matematicos') {
            // Apenas os identificadores que participavam de regras internas
            // viram códigos. UUIDs de cadastros personalizados são descartados.
            final normalizado = antigoId!.toLowerCase();
            final possuiSignificado = tabela == 'especies'
                ? ['species_pinus', 'species_eucalyptus'].contains(antigoId)
                : normalizado == 'formula_form_factor' ||
                      normalizado.contains('spurr') ||
                      normalizado.contains('schumacher');
            valores['codigo'] = possuiSignificado ? antigoId : null;
          }
          if (tabela == 'registros_atividade') {
            final referencia = valores['entidade_id'];
            final destino = tabelasEntidadeAtividade[valores['tipo_entidade']];
            final novoId = mapas[destino]?[referencia];
            valores['entidade_id'] = novoId;
            valores['referencia_legada'] = novoId == null ? referencia : null;
          }
          final novoId = await inserirLinha(banco, tabela, valores);
          if (antigoId != null) mapa[antigoId] = novoId;
        }
        final quantidade =
            (await banco
                    .customSelect(
                      'SELECT COUNT(*) AS quantidade FROM "$tabela"',
                    )
                    .getSingle())
                .read<int>('quantidade');
        if (quantidade != linhas.length) {
          throw StateError('Contagem divergente em $tabela');
        }
      }
      for (final tabela
          in relacionamentosIds.keys
              .where(existentes.contains)
              .toList()
              .reversed) {
        await banco.customStatement('DROP TABLE "legado_v10_$tabela"');
      }
      if ((await banco.customSelect('PRAGMA foreign_key_check').get())
          .isNotEmpty) {
        throw StateError('Migração produziu chaves estrangeiras inválidas.');
      }
    });
  } finally {
    await banco.customStatement('PRAGMA foreign_keys = $chavesAtivas');
  }
}

Future<int> inserirLinha(
  GeneratedDatabase banco,
  String tabela,
  Map<String, Object?> valores,
) {
  return banco.customInsert(
    'INSERT INTO "$tabela" (${valores.keys.map((c) => '"$c"').join(', ')}) VALUES (${List.filled(valores.length, '?').join(', ')})',
    variables: valores.values.map((valor) => Variable(valor)).toList(),
  );
}
