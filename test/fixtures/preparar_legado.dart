import 'dart:io';
import 'dart:convert';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:dendro_mobile/nucleo/banco/migracao_nomenclatura.dart';

Map<String, List<Map<String, Object?>>> prepararV10(File arquivo) {
  final temporario = File('${arquivo.path}.v9');
  final antigos = prepararLegado(temporario, 9);
  temporario.deleteSync();
  final referencia =
      jsonDecode(File('test/fixtures/banco_v10.json').readAsStringSync())
          as Map<String, dynamic>;
  final banco = sqlite.sqlite3.open(arquivo.path);
  try {
    for (final item in referencia.values) {
      banco.execute(item['sql'] as String);
    }
    for (final entrada in referencia.entries) {
      for (final linha in entrada.value['dados'] as List) {
        _inserir(banco, entrada.key, Map<String, Object?>.from(linha as Map));
      }
    }
    for (final entrada in antigos.entries) {
      final tabela = nomesTabelasLegadas[entrada.key]!;
      for (final linha in entrada.value) {
        final nova = {
          for (final c in linha.entries)
            nomesColunasLegadas[c.key] ?? c.key: c.value,
        };
        if (tabela == 'levantamentos') nova['situacao'] = 'emAndamento';
        if (tabela == 'parcelas') nova['situacao'] = 'coletada';
        if (tabela == 'variaveis_modelo') nova['chave_variavel'] = 'altura';
        if (tabela == 'registros_atividade') {
          nova['tipo'] = 'propriedadeCriada';
          nova['tipo_entidade'] = 'propriedade';
        }
        _inserir(banco, tabela, nova);
      }
    }
    banco.execute('PRAGMA user_version = 10');
    return {
      for (final tabela in referencia.keys)
        tabela: banco
            .select('SELECT * FROM "$tabela" ORDER BY rowid')
            .map((r) => Map<String, Object?>.from(r))
            .toList(),
    };
  } finally {
    banco.close();
  }
}

Map<String, List<Map<String, Object?>>> prepararLegado(
  File arquivo,
  int versao,
) {
  final banco = sqlite.sqlite3.open(arquivo.path);
  try {
    banco.execute(File('test/fixtures/esquema_v9.sql').readAsStringSync());
    if (versao < 7) banco.execute('DROP TABLE species_formula_coefficients');
    if (versao < 6) {
      banco.execute('ALTER TABLE stands DROP COLUMN plot_width_m');
      banco.execute('ALTER TABLE stands DROP COLUMN plot_length_m');
    }
    if (versao < 3) banco.execute('DROP TABLE activity_logs');
    if (versao < 2) banco.execute('DROP TABLE talhao_formula_coefficients');
    final dados = <String, Map<String, Object?>>{
      'properties': {
        'id': 'p',
        'name': "Fazenda São João d'Água",
        'municipality': 'São José',
        'state': 'RS',
        'total_area_ha': 42.123456789,
        'created_at': 123,
        'updated_at': 456,
      },
      'species': {
        'id': 's',
        'name': 'Espécie teste',
        'scientific_name': null,
        'description': 'Observação çã',
        'active': 0,
        'created_at': 123,
        'updated_at': 456,
      },
      'formulas': {
        'id': 'modelo_teste',
        'name': 'Modelo independente',
        'description': null,
        'expression': 'a + b * (D^2 * H)',
        'active': 1,
        'created_at': 123,
        'updated_at': 456,
      },
      'formula_variables': {
        'id': 'v',
        'formula_id': 'modelo_teste',
        'symbol': 'H',
        'label': 'Altura',
        'unit': 'm',
        'value_source': 'Medição da árvore',
        'variable_key': 'height',
      },
      'formula_coefficients': {
        'id': 'c',
        'formula_id': 'modelo_teste',
        'symbol': 'a',
        'label': 'Coeficiente a',
        'value': 0.12,
      },
      'species_formulas': {
        'species_id': 's',
        'formula_id': 'modelo_teste',
        'is_default': 1,
        'created_at': 123,
      },
      'species_formula_coefficients': {
        'id': 'ce',
        'species_id': 's',
        'formula_id': 'modelo_teste',
        'symbol': 'a',
        'label': 'Coeficiente a',
        'value': 0.12,
        'updated_at': 456,
      },
      'stands': {
        'id': 't',
        'property_id': 'p',
        'identification': 'Talhão 01',
        'species_id': 's',
        'area_ha': 10.0,
        'planting_year': 2001,
        'spacing': null,
        'management_regime': 'Manejo teste',
        'plot_width_m': 20.0,
        'plot_length_m': 50.0,
        'notes': 'Notas preservadas',
        'created_at': 123,
        'updated_at': 456,
      },
      'inventory_runs': {
        'id': 'l',
        'property_id': 'p',
        'status': 'inProgress',
        'started_at': 123,
        'updated_at': 456,
        'completed_at': null,
      },
      'talhao_levantamentos': {
        'id': 'tl',
        'inventory_run_id': 'l',
        'stand_id': 't',
        'species_id': 's',
        'formula_id': 'modelo_teste',
        'default_plot_area_ha': 0.1,
        'created_at': 123,
        'updated_at': 456,
      },
      'talhao_formula_coefficients': {
        'id': 'ct',
        'talhao_levantamento_id': 'tl',
        'symbol': 'a',
        'label': 'Coeficiente a',
        'value': 0.12,
      },
      'plots': {
        'id': 'pa',
        'talhao_levantamento_id': 'tl',
        'identification': 'P01',
        'status': 'collected',
        'area_ha': 0.1,
        'reference_position': 'p1',
        'created_at': 123,
        'updated_at': 456,
      },
      'plot_geo_points': {
        'id': 'g',
        'plot_id': 'pa',
        'point_order': 1,
        'reference_position': 'p1',
        'latitude': -29.123456789,
        'longitude': -51.987654321,
        'accuracy_meters': null,
        'captured_at': 123,
      },
      'trees': {
        'id': 'a',
        'plot_id': 'pa',
        'number': 7,
        'dap_cm': 20.0,
        'height_m': 10.0,
        'has_tortuous_stem': 1,
        'latitude': -29.123456789,
        'longitude': -51.987654321,
        'accuracy_meters': 2.345678,
        'location_captured_at': 123,
        'plot_reference_position': 'p1',
        'created_at': 123,
        'updated_at': 456,
      },
      'activity_logs': {
        'id': 'at',
        'type': 'propertyCreated',
        'title': 'Propriedade cadastrada',
        'subtitle': 'São João',
        'entity_type': 'property',
        'entity_id': 'p',
        'occurred_at': 123456789,
      },
    };
    final tabelas = banco
        .select("SELECT name FROM sqlite_master WHERE type='table'")
        .map((linha) => linha['name'])
        .toSet();
    for (final entrada in dados.entries) {
      if (!tabelas.contains(entrada.key)) continue;
      final colunas = banco
          .select('PRAGMA table_info("${entrada.key}")')
          .map((linha) => linha['name'])
          .toSet();
      final linha = Map<String, Object?>.fromEntries(
        entrada.value.entries.where((campo) => colunas.contains(campo.key)),
      );
      _inserir(banco, entrada.key, linha);
    }
    _inserir(banco, 'formula_coefficients', {
      'id': 'b',
      'formula_id': 'modelo_teste',
      'symbol': 'b',
      'label': 'Coeficiente b',
      'value': 0.00004,
    });
    if (versao >= 2) {
      _inserir(banco, 'talhao_formula_coefficients', {
        'id': 'ctb',
        'talhao_levantamento_id': 'tl',
        'symbol': 'b',
        'label': 'Coeficiente b',
        'value': 0.00004,
      });
    }
    banco.execute('PRAGMA user_version = $versao');
    return {
      for (final tabela in tabelas.cast<String>().where(
        (nome) => !nome.startsWith('sqlite_'),
      ))
        tabela: banco
            .select('SELECT * FROM "$tabela"')
            .map((linha) => Map<String, Object?>.from(linha))
            .toList(),
    };
  } finally {
    banco.close();
  }
}

void _inserir(
  sqlite.Database banco,
  String tabela,
  Map<String, Object?> dados,
) {
  banco.execute(
    'INSERT INTO "$tabela" (${dados.keys.map((nome) => '"$nome"').join(',')}) VALUES (${List.filled(dados.length, '?').join(',')})',
    dados.values.toList(),
  );
}
