import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:dendro_mobile/nucleo/banco/banco_dendro.dart';
import 'package:dendro_mobile/nucleo/banco/migracao_nomenclatura.dart';
import 'package:dendro_mobile/funcionalidades/atividades/dados/repositorio_atividades.dart';
import 'package:dendro_mobile/funcionalidades/resultados/dados/repositorio_resultados.dart';

const tabelasEsperadas = {
  'propriedades', 'talhoes', 'especies', 'modelos_matematicos',
  'variaveis_modelo', 'coeficientes_modelo', 'especies_modelos',
  'coeficientes_especie_modelo', 'levantamentos', 'talhao_levantamentos',
  'coeficientes_talhao_levantamento', 'parcelas',
  'pontos_geograficos_parcela', 'arvores', 'registros_atividade',
};

void main() {
  // Os bancos comparados usam executores distintos, nunca compartilham conexao.
  setUp(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  test('migra todos os valores persistidos de enums da versao 9', () async {
    final pasta = Directory.systemTemp.createTempSync('dendro_enums_');
    final arquivo = File('${pasta.path}/inventario.sqlite');
    prepararLegado(arquivo, 9);
    final enums = jsonDecode(File('test/fixtures/enums_v9.json').readAsStringSync()) as Map<String,dynamic>;
    final legado = sqlite.sqlite3.open(arquivo.path);
    final tipos = (enums['ActivityLogType'] as List).cast<String>();
    final entidades = (enums['ActivityEntityType'] as List).cast<String>();
    try {
      legado.execute('DELETE FROM activity_logs');
      for(var i=0;i<tipos.length;i++) {
        _inserir(legado,'activity_logs',{'id':'evento_$i','type':tipos[i],'title':'Evento $i','subtitle':'Descrição preservada','entity_type':entidades[i%entidades.length],'entity_id':'p','occurred_at':i});
      }
      final situacoesLevantamento = (enums['InventoryRunStatus'] as List).cast<String>();
      for(var i=0;i<situacoesLevantamento.length;i++) {
        _inserir(legado,'inventory_runs',{'id':'levantamento_$i','property_id':'p','status':situacoesLevantamento[i],'started_at':123,'updated_at':456,'completed_at':null});
      }
      final situacoesParcela = (enums['PlotStatus'] as List).cast<String>();
      for(var i=0;i<situacoesParcela.length;i++) {
        _inserir(legado,'plots',{'id':'parcela_$i','talhao_levantamento_id':'tl','identification':'P$i','status':situacoesParcela[i],'area_ha':null,'reference_position':null,'created_at':123,'updated_at':456});
      }
      final variaveis = (enums['FormulaVariableKey'] as List).cast<String>();
      for(var i=0;i<variaveis.length;i++) {
        _inserir(legado,'formula_variables',{'id':'variavel_$i','formula_id':'modelo_teste','symbol':'X$i','label':'Variável $i','unit':'m','value_source':'Manual','variable_key':variaveis[i]});
      }
    } finally { legado.close(); }
    final banco = BancoDendro(NativeDatabase(arquivo));
    try {
      final atividades = await RepositorioAtividades(banco).recente(limite:100);
      expect(atividades.length, TipoAtividade.values.length);
      for(var i=0;i<tipos.length;i++){
        final registro = atividades.singleWhere((registro)=>registro.id=='evento_$i');
        expect(registro.tipo,TipoAtividade.values[i]);
        expect(registro.tipoEntidade,TipoEntidadeAtividade.values[i%entidades.length]);
        expect(registro.subtitulo,'Descrição preservada');
      }
      final levantamentos = await banco.select(banco.levantamentos).get();
      for(var i=0;i<SituacaoLevantamento.values.length;i++){
        expect(levantamentos.singleWhere((item)=>item.id=='levantamento_$i').situacao,SituacaoLevantamento.values[i]);
      }
      final parcelas = await banco.select(banco.parcelas).get();
      for(var i=0;i<SituacaoParcela.values.length;i++){
        expect(parcelas.singleWhere((item)=>item.id=='parcela_$i').situacao,SituacaoParcela.values[i]);
      }
      final variaveis = await banco.select(banco.variaveisModelo).get();
      for(var i=0;i<ChaveVariavelModelo.values.length;i++){
        expect(variaveis.singleWhere((item)=>item.id=='variavel_$i').chaveVariavel,ChaveVariavelModelo.values[i]);
      }
    } finally { await banco.close(); pasta.deleteSync(recursive:true); }
  });


  for (var versao = 1; versao <= 9; versao++) {
    test('migra estrutura legada v$versao com dados e relacionamentos', () async {
      final pasta = Directory.systemTemp.createTempSync('dendro_migracao_');
      final arquivo = File('${pasta.path}/inventario.sqlite');
      final anterior = prepararLegado(arquivo, versao);
      final novo = BancoDendro(NativeDatabase(arquivo, setup: (banco) {
        banco.execute('PRAGMA foreign_keys = ON');
      }));
      try {
        expect((await novo.select(novo.propriedades).getSingle()).nome, "Fazenda São João d'Água");
        expect((await novo.customSelect('PRAGMA user_version').getSingle()).data.values.single, 10);
        final tabelas = await novo.customSelect("SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'").get();
        expect(tabelas.map((linha) => linha.read<String>('name')).toSet(), tabelasEsperadas);
        expect(await novo.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
        expect(await novo.customSelect('PRAGMA integrity_check').get().then((linhas) => linhas.single.data.values.single), 'ok');
        // Compara todas as celulas legadas, inclusive nulos e Unicode.
        for (final entrada in anterior.entries) {
          final tabela = nomesTabelasLegadas[entrada.key]!;
          final atuais = await novo.customSelect('SELECT * FROM "$tabela"').get();
          for (final linha in entrada.value) {
            final esperada = <String, Object?>{
              for (final campo in linha.entries)
                nomesColunasLegadas[campo.key] ?? campo.key:
                  _valorEsperado(entrada.key, campo.key, campo.value),
            };
            final correspondente = atuais.singleWhere((atual) =>
              linha.containsKey('id') ? atual.data['id'] == linha['id'] :
              atual.data['especie_id'] == linha['species_id'] &&
              atual.data['modelo_matematico_id'] == linha['formula_id']);
            for (final campo in esperada.entries) {
              expect(correspondente.data[campo.key], campo.value, reason: '$tabela.${campo.key}');
            }
          }
        }
        final painel = await RepositorioResultados(novo).observarPainel(
          const FiltrosResultados(propriedadeId: 'p', talhaoIds: {}, especieId: null),
        ).first;
        // a=.12, b=.00004, DAP=20cm, altura=10m: .28 m3.
        expect(painel.amostraVolumeM3, closeTo(0.28, 1e-12));
        final arvore = await novo.select(novo.arvores).getSingle();
        expect(arvore.numero, 7);
        expect(arvore.dapCm, 20);
        expect(arvore.alturaM, 10);
        expect(arvore.possuiTroncoTortuoso, true);
        expect(arvore.latitude, -29.123456789);
        if (versao >= 3) {
          final atividades = await RepositorioAtividades(novo).recente();
          expect(atividades.single.tipo, TipoAtividade.propriedadeCriada);
          expect(atividades.single.tipoEntidade, TipoEntidadeAtividade.propriedade);
        }
        final fresco = BancoDendro(NativeDatabase.memory());
        try {
          await fresco.customSelect('SELECT 1').get();
          for (final tabela in tabelasEsperadas) {
            expect(await _colunas(novo, tabela), await _colunas(fresco, tabela), reason: tabela);
            expect(await _relacoes(novo, tabela), await _relacoes(fresco, tabela), reason: tabela);
            expect(await _indices(novo, tabela), await _indices(fresco, tabela), reason: tabela);
          }
        } finally { await fresco.close(); }
        await novo.customStatement("UPDATE arvores SET altura_m = 12 WHERE id = 'a'");
        expect((await novo.select(novo.arvores).getSingle()).alturaM, 12);
        await expectLater(
          novo.customStatement("INSERT INTO arvores (id, parcela_id, numero, dap_cm, altura_m, criado_em, atualizado_em) VALUES ('invalida','ausente',1,20,10,1,1)"),
          throwsA(isA<Exception>()),
        );
      } finally { await novo.close(); }
      final reaberto = BancoDendro(NativeDatabase(arquivo));
      try { expect((await reaberto.select(reaberto.arvores).getSingle()).alturaM, 12); }
      finally { await reaberto.close(); pasta.deleteSync(recursive: true); }
    });
  }
  test('falha reverte renomeacoes e conserva banco v9 para nova tentativa', () async {
    final pasta = Directory.systemTemp.createTempSync('dendro_rollback_');
    final arquivo = File('${pasta.path}/inventario.sqlite');
    prepararLegado(arquivo, 9);
    final legado = sqlite.sqlite3.open(arquivo.path);
    legado.execute("CREATE TRIGGER interromper BEFORE UPDATE OF type ON activity_logs BEGIN SELECT RAISE(ABORT, 'falha simulada'); END;");
    legado.close();
    final banco = BancoDendro(NativeDatabase(arquivo));
    try { await expectLater(banco.select(banco.propriedades).get(), throwsA(isA<Exception>())); }
    finally { await banco.close(); }
    final verificacao = sqlite.sqlite3.open(arquivo.path);
    try {
      expect(verificacao.select('PRAGMA user_version').single.values.single, 9);
      expect(verificacao.select('SELECT name FROM properties').single['name'], "Fazenda São João d'Água");
      expect(verificacao.select("SELECT name FROM sqlite_master WHERE name = 'propriedades'"), isEmpty);
      verificacao.execute('DROP TRIGGER interromper');
    } finally { verificacao.close(); }
    final tentativa = BancoDendro(NativeDatabase(arquivo));
    try { expect((await tentativa.select(tentativa.arvores).getSingle()).numero, 7); }
    finally { await tentativa.close(); pasta.deleteSync(recursive:true); }
  });
}

Future<List<String>> _colunas(BancoDendro banco, String tabela) async {
  final linhas = await banco.customSelect('PRAGMA table_info("$tabela")').get();
  return linhas.map((linha) {
    final d = linha.data;
    return "${d['name']}|${d['type']}|${d['notnull']}|${d['dflt_value']}|${d['pk']}";
  }).toList()..sort();
}
Future<List<String>> _relacoes(BancoDendro banco, String tabela) async {
  final linhas = await banco.customSelect('PRAGMA foreign_key_list("$tabela")').get();
  return linhas.map((linha) {
    final d = linha.data;
    return "${d['from']}|${d['table']}|${d['to']}|${d['on_update']}|${d['on_delete']}";
  }).toList()..sort();
}
Future<List<String>> _indices(BancoDendro banco, String tabela) async {
  final lista = await banco.customSelect('PRAGMA index_list("$tabela")').get();
  final resultado = <String>[];
  for (final indice in lista) {
    if (indice.data['unique'] != 1) continue;
    final nome = indice.data['name'];
    final campos = await banco.customSelect('PRAGMA index_info("$nome")').get();
    resultado.add(campos.map((campo) => campo.data['name']).join(','));
  }
  return resultado..sort();
}

Map<String, List<Map<String, Object?>>> prepararLegado(File arquivo, int versao) {
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
    final dados = <String, Map<String,Object?>>{
      'properties': {'id':'p','name':"Fazenda São João d'Água",'municipality':'São José','state':'RS','total_area_ha':42.123456789,'created_at':123,'updated_at':456},
      'species': {'id':'s','name':'Espécie teste','scientific_name':null,'description':'Observação çã','active':0,'created_at':123,'updated_at':456},
      'formulas': {'id':'modelo_teste','name':'Modelo independente','description':null,'expression':'a + b * (D^2 * H)','active':1,'created_at':123,'updated_at':456},
      'formula_variables': {'id':'v','formula_id':'modelo_teste','symbol':'H','label':'Altura','unit':'m','value_source':'Medição da árvore','variable_key':'height'},
      'formula_coefficients': {'id':'c','formula_id':'modelo_teste','symbol':'a','label':'Coeficiente a','value':0.12},
      'species_formulas': {'species_id':'s','formula_id':'modelo_teste','is_default':1,'created_at':123},
      'species_formula_coefficients': {'id':'ce','species_id':'s','formula_id':'modelo_teste','symbol':'a','label':'Coeficiente a','value':0.12,'updated_at':456},
      'stands': {'id':'t','property_id':'p','identification':'Talhão 01','species_id':'s','area_ha':10.0,'planting_year':2001,'spacing':null,'management_regime':'Manejo teste','plot_width_m':20.0,'plot_length_m':50.0,'notes':'Notas preservadas','created_at':123,'updated_at':456},
      'inventory_runs': {'id':'l','property_id':'p','status':'inProgress','started_at':123,'updated_at':456,'completed_at':null},
      'talhao_levantamentos': {'id':'tl','inventory_run_id':'l','stand_id':'t','species_id':'s','formula_id':'modelo_teste','default_plot_area_ha':0.1,'created_at':123,'updated_at':456},
      'talhao_formula_coefficients': {'id':'ct','talhao_levantamento_id':'tl','symbol':'a','label':'Coeficiente a','value':0.12},
      'plots': {'id':'pa','talhao_levantamento_id':'tl','identification':'P01','status':'collected','area_ha':0.1,'reference_position':'p1','created_at':123,'updated_at':456},
      'plot_geo_points': {'id':'g','plot_id':'pa','point_order':1,'reference_position':'p1','latitude':-29.123456789,'longitude':-51.987654321,'accuracy_meters':null,'captured_at':123},
      'trees': {'id':'a','plot_id':'pa','number':7,'dap_cm':20.0,'height_m':10.0,'has_tortuous_stem':1,'latitude':-29.123456789,'longitude':-51.987654321,'accuracy_meters':2.345678,'location_captured_at':123,'plot_reference_position':'p1','created_at':123,'updated_at':456},
      'activity_logs': {'id':'at','type':'propertyCreated','title':'Propriedade cadastrada','subtitle':'São João','entity_type':'property','entity_id':'p','occurred_at':123456789},
    };
    final tabelas = banco.select("SELECT name FROM sqlite_master WHERE type='table'").map((linha)=>linha['name']).toSet();
    for (final entrada in dados.entries) {
      if(!tabelas.contains(entrada.key)) continue;
      final colunas=banco.select('PRAGMA table_info("${entrada.key}")').map((linha)=>linha['name']).toSet();
      final linha=Map<String,Object?>.fromEntries(entrada.value.entries.where((campo)=>colunas.contains(campo.key)));
      _inserir(banco,entrada.key,linha);
    }
    _inserir(banco,'formula_coefficients',{'id':'b','formula_id':'modelo_teste','symbol':'b','label':'Coeficiente b','value':0.00004});
    if(versao>=2) _inserir(banco,'talhao_formula_coefficients',{'id':'ctb','talhao_levantamento_id':'tl','symbol':'b','label':'Coeficiente b','value':0.00004});
    banco.execute('PRAGMA user_version = $versao');
    return {
      for(final tabela in tabelas.cast<String>().where((nome)=>!nome.startsWith('sqlite_')))
        tabela: banco.select('SELECT * FROM "$tabela"').map((linha)=>Map<String,Object?>.from(linha)).toList(),
    };
  } finally { banco.close(); }
}
void _inserir(sqlite.Database banco, String tabela, Map<String,Object?> dados) {
  banco.execute('INSERT INTO "$tabela" (${dados.keys.map((nome)=>'"$nome"').join(',')}) VALUES (${List.filled(dados.length,'?').join(',')})',dados.values.toList());
}
Object? _valorEsperado(String tabela,String coluna,Object? valor) {
  if(tabela=='inventory_runs'&&coluna=='status') return 'emAndamento';
  if(tabela=='plots'&&coluna=='status') return 'coletada';
  if(tabela=='formula_variables'&&coluna=='variable_key') return 'altura';
  if(tabela=='activity_logs'&&coluna=='type') return 'propriedadeCriada';
  if(tabela=='activity_logs'&&coluna=='entity_type') return 'propriedade';
  return valor;
}


