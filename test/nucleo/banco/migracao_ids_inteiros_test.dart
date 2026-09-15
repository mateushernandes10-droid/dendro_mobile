import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:flutter_test/flutter_test.dart';
import 'package:dendro_mobile/nucleo/banco/banco_dendro.dart';
import 'package:dendro_mobile/nucleo/banco/migracao_ids_inteiros.dart';
import 'package:dendro_mobile/funcionalidades/propriedades/dados/repositorio_propriedades.dart';
import 'package:dendro_mobile/funcionalidades/atividades/dados/repositorio_atividades.dart';
import 'package:dendro_mobile/funcionalidades/resultados/dados/repositorio_resultados.dart';
import 'package:dendro_mobile/nucleo/floresta/calculadora_volume_florestal.dart';
import '../../fixtures/preparar_legado.dart';

void main() {
  test(
    'banco novo usa inteiros, autoincremento e chave composta existente',
    () async {
      final banco = BancoDendro(NativeDatabase.memory());
      try {
        await banco.select(banco.especies).get();
        for (final tabela in relacionamentosIds.keys) {
          final campos = await banco
              .customSelect('PRAGMA table_info("$tabela")')
              .get();
          final sql =
              (await banco
                      .customSelect(
                        'SELECT sql FROM sqlite_master WHERE name=?',
                        variables: [Variable(tabela)],
                      )
                      .getSingle())
                  .read<String>('sql');
          if (tabela == 'especies_modelos') {
            expect(
              campos
                  .where((c) => c.read<int>('pk') > 0)
                  .map((c) => c.read<String>('name')),
              ['especie_id', 'modelo_matematico_id'],
            );
            expect(sql, isNot(contains('AUTOINCREMENT')));
          } else {
            expect(
              campos
                  .singleWhere((c) => c.read<String>('name') == 'id')
                  .read<String>('type'),
              'INTEGER',
            );
            expect(sql, contains('AUTOINCREMENT'));
          }
          for (final campo in relacionamentosIds[tabela]!.keys) {
            expect(
              campos
                  .singleWhere((c) => c.read<String>('name') == campo)
                  .read<String>('type'),
              'INTEGER',
            );
          }
        }
        final repositorio = RepositorioPropriedades(banco);
        final primeiro = await repositorio.criar(
          nome: 'A',
          municipio: 'B',
          areaTotalHa: 1,
        );
        await repositorio.excluir(primeiro);
        final segundo = await repositorio.criar(
          nome: 'C',
          municipio: 'B',
          areaTotalHa: 1,
        );
        expect(primeiro, greaterThan(0));
        expect(segundo, greaterThan(primeiro));
        final atividades = await RepositorioAtividades(banco).recente();
        expect(atividades.map((a) => a.id).toSet(), hasLength(3));
        expect(atividades.every((a) => a.id > 0), isTrue);
      } finally {
        await banco.close();
      }
    },
  );

  test('v10 preserva todos os campos e remapeia todas as PKs e FKs', () async {
    final pasta = Directory.systemTemp.createTempSync('dendro_ids_');
    final arquivo = File('${pasta.path}/banco.sqlite');
    final antigos = prepararV10(arquivo);
    final legado = sqlite.sqlite3.open(arquivo.path);
    final relacionamentosAnteriores = {
      for (final tabela in relacionamentosIds.keys)
        tabela:
            legado
                .select('PRAGMA foreign_key_list("$tabela")')
                .map(
                  (r) => [
                    'table',
                    'from',
                    'to',
                    'on_update',
                    'on_delete',
                    'match',
                  ].map((c) => r[c]).join('|'),
                )
                .toList()
              ..sort(),
    };
    final unicosAnteriores = {
      for (final tabela in relacionamentosIds.keys)
        tabela:
            legado
                .select('PRAGMA index_list("$tabela")')
                .where((r) => r['unique'] == 1 && r['origin'] != 'pk')
                .map(
                  (r) => legado
                      .select('PRAGMA index_info("${r['name']}")')
                      .map((c) => c['name'])
                      .join('|'),
                )
                .toList()
              ..sort(),
    };
    legado.close();
    var banco = BancoDendro(
      NativeDatabase(
        arquivo,
        setup: (db) => db.execute('PRAGMA foreign_keys=ON'),
      ),
    );
    final mapas = <String, Map<Object?, int>>{};
    try {
      await banco.select(banco.propriedades).get();
      for (final tabela in relacionamentosIds.keys) {
        final fks =
            (await banco
                    .customSelect('PRAGMA foreign_key_list("$tabela")')
                    .get())
                .map(
                  (r) => [
                    'table',
                    'from',
                    'to',
                    'on_update',
                    'on_delete',
                    'match',
                  ].map((c) => r.data[c]).join('|'),
                )
                .toList()
              ..sort();
        expect(
          fks,
          relacionamentosAnteriores[tabela],
          reason: 'Relacionamentos e ações de $tabela',
        );
        final unicos = <String>[];
        for (final indice
            in await banco.customSelect('PRAGMA index_list("$tabela")').get()) {
          if (indice.read<int>('unique') == 0 ||
              indice.read<String>('origin') == 'pk') {
            continue;
          }
          final nomes =
              (await banco
                      .customSelect(
                        'PRAGMA index_info("${indice.read<String>('name')}")',
                      )
                      .get())
                  .map((c) => c.read<String>('name'))
                  .join('|');
          if (nomes != 'codigo') unicos.add(nomes);
        }
        unicos.sort();
        expect(unicos, unicosAnteriores[tabela], reason: 'UNIQUE de $tabela');
        final atuais = await banco
            .customSelect('SELECT * FROM "$tabela" ORDER BY rowid')
            .get();
        expect(atuais, hasLength(antigos[tabela]!.length), reason: tabela);
        mapas[tabela] = {};
        for (var i = 0; i < atuais.length; i++) {
          final anterior = antigos[tabela]![i];
          final atual = atuais[i].data;
          if (anterior.containsKey('id')) {
            expect(atual['id'], isA<int>());
            mapas[tabela]![anterior['id']] = atual['id'] as int;
          }
          for (final campo in anterior.entries) {
            if (campo.key == 'id') continue;
            final pai = relacionamentosIds[tabela]![campo.key];
            Object? esperado = campo.value;
            if (pai != null) esperado = mapas[pai]![campo.value];
            if (tabela == 'registros_atividade' && campo.key == 'entidade_id') {
              esperado =
                  mapas[tabelasEntidadeAtividade[anterior['tipo_entidade']]]?[campo
                      .value];
            }
            expect(
              atual[campo.key],
              esperado,
              reason: '$tabela.${campo.key}, linha $i',
            );
          }
          if (tabela == 'modelos_matematicos' || tabela == 'especies') {
            expect(
              atual['codigo'],
              [
                    'species_pinus',
                    'species_eucalyptus',
                    'formula_spurr',
                    'formula_schumacher_hall',
                    'formula_form_factor',
                  ].contains(anterior['id'])
                  ? anterior['id']
                  : null,
            );
          }
        }
      }
      expect(
        await banco.customSelect('PRAGMA foreign_key_check').get(),
        isEmpty,
      );
      expect(
        (await banco.customSelect('PRAGMA integrity_check').getSingle())
            .data
            .values
            .single,
        'ok',
      );
      final painel = await RepositorioResultados(banco)
          .observarPainel(
            FiltrosResultados(
              propriedadeId: mapas['propriedades']!['p'],
              talhaoIds: {},
              especieId: null,
            ),
          )
          .first;
      expect(painel.amostraVolumeM3, closeTo(0.28, 1e-12));

      // Copiar linha sem a PK viola cada UNIQUE original. A inserção deve falhar.
      for (final tabela in relacionamentosIds.keys) {
        final indices = await banco
            .customSelect('PRAGMA index_list("$tabela")')
            .get();
        final possuiUnico = indices.any(
          (i) => i.read<int>('unique') == 1 && i.read<String>('origin') != 'pk',
        );
        if (!possuiUnico && tabela != 'especies_modelos') continue;
        final campos =
            (await banco.customSelect('PRAGMA table_info("$tabela")').get())
                .map((c) => c.read<String>('name'))
                .where((c) => c != 'id')
                .join(',');
        await expectLater(
          banco.customStatement(
            'INSERT INTO "$tabela" ($campos) SELECT $campos FROM "$tabela" LIMIT 1',
          ),
          throwsA(isA<Exception>()),
          reason: tabela,
        );
      }
      final arvore = (await banco.select(banco.arvores).get()).single;
      await (banco.update(banco.arvores)..where((a) => a.id.equals(arvore.id)))
          .write(const ArvoresCompanion(dapCm: Value(21)));
      await banco.close();
      banco = BancoDendro(NativeDatabase(arquivo));
      expect((await banco.select(banco.arvores).get()).single.dapCm, 21);
      final novo = await RepositorioPropriedades(
        banco,
      ).criar(nome: 'Depois', municipio: 'RS', areaTotalHa: 2);
      expect(
        novo,
        greaterThan(
          mapas['propriedades']!.values.reduce((a, b) => a > b ? a : b),
        ),
      );
    } finally {
      await banco.close();
      pasta.deleteSync(recursive: true);
    }
  });

  test(
    'falha tardia reverte esquema e dados v10, permite corrigir e repetir',
    () async {
      final pasta = Directory.systemTemp.createTempSync('dendro_rollback_');
      final arquivo = File('${pasta.path}/banco.sqlite');
      prepararV10(arquivo);
      var legado = sqlite.sqlite3.open(arquivo.path);
      legado.execute("UPDATE arvores SET parcela_id='parcela_inexistente'");
      final esquema = legado
          .select(
            "SELECT name,sql FROM sqlite_master WHERE type='table' ORDER BY name",
          )
          .map((r) => r.values.toList())
          .toList();
      legado.close();
      var banco = BancoDendro(NativeDatabase(arquivo));
      try {
        await expectLater(
          banco.select(banco.propriedades).get(),
          throwsA(isA<StateError>()),
        );
        await banco.close();
        legado = sqlite.sqlite3.open(arquivo.path);
        expect(legado.select('PRAGMA user_version').single.values.single, 10);
        expect(
          legado
              .select(
                "SELECT name,sql FROM sqlite_master WHERE type='table' ORDER BY name",
              )
              .map((r) => r.values.toList())
              .toList(),
          esquema,
        );
        expect(
          legado.select('SELECT parcela_id FROM arvores').single['parcela_id'],
          'parcela_inexistente',
        );
        legado.execute("UPDATE arvores SET parcela_id='pa'");
        legado.close();
        banco = BancoDendro(NativeDatabase(arquivo));
        expect(await banco.select(banco.arvores).get(), hasLength(1));
        expect(
          await banco.customSelect('PRAGMA foreign_key_check').get(),
          isEmpty,
        );
      } finally {
        await banco.close();
        pasta.deleteSync(recursive: true);
      }
    },
  );

  test(
    'historico conserva eventos de entidades excluidas e remapeia exportacao',
    () async {
      final pasta = Directory.systemTemp.createTempSync('dendro_log_');
      final arquivo = File('${pasta.path}/banco.sqlite');
      prepararV10(arquivo);
      final legado = sqlite.sqlite3.open(arquivo.path);
      legado.execute(
        "INSERT INTO registros_atividade VALUES ('removido','propriedadeExcluida','Excluída','Texto original','propriedade','uuid-ja-excluido',999)",
      );
      legado.execute(
        "INSERT INTO registros_atividade VALUES ('exportado','exportacaoCriada','CSV','Texto original','exportacao','p',1000)",
      );
      legado.close();
      final banco = BancoDendro(NativeDatabase(arquivo));
      try {
        final eventos = await RepositorioAtividades(banco).recente();
        expect(eventos, hasLength(3));
        final excluido =
            (await banco
                    .customSelect(
                      "SELECT * FROM registros_atividade WHERE tipo='propriedadeExcluida'",
                    )
                    .getSingle())
                .data;
        expect(excluido['entidade_id'], isNull);
        expect(excluido['referencia_legada'], 'uuid-ja-excluido');
        expect(excluido['subtitulo'], 'Texto original');
        final propriedade =
            (await banco.select(banco.propriedades).get()).single;
        expect(
          eventos
              .singleWhere((e) => e.tipo == TipoAtividade.exportacaoCriada)
              .entidadeId,
          propriedade.id,
        );
      } finally {
        await banco.close();
        pasta.deleteSync(recursive: true);
      }
    },
  );

  test(
    'codigo identifica modelos com IDs diferentes e sem depender da ordem',
    () async {
      final pasta = Directory.systemTemp.createTempSync('dendro_codigos_');
      final arquivo = File('${pasta.path}/banco.sqlite');
      prepararV10(arquivo);
      final legado = sqlite.sqlite3.open(arquivo.path);
      legado.execute("UPDATE modelos_matematicos SET rowid=rowid+100");
      legado.execute(
        "INSERT INTO modelos_matematicos VALUES ('outro','Outro modelo',NULL,'a + b * (D^2 * H)',1,123,456)",
      );
      legado.execute("UPDATE modelos_matematicos SET rowid=1 WHERE id='outro'");
      legado.close();
      final banco = BancoDendro(NativeDatabase(arquivo));
      try {
        final modelos = await banco.select(banco.modelosMatematicos).get();
        final fator = modelos.singleWhere(
          (m) => m.codigo == 'formula_form_factor',
        );
        expect(fator.id, isNot(3));
        expect(
          CalculadoraVolumeFlorestal.volumeArvoreM3(
            dapCm: 20,
            alturaM: 10,
            coeficientes: {'ff': 0.5},
            modeloMatematicoCodigo: fator.codigo,
          ),
          closeTo(0.6283185307179586, 1e-12),
        );
        expect(
          CalculadoraVolumeFlorestal.valorPadraoCoeficiente(
            modeloMatematicoCodigo: modelos
                .singleWhere((m) => m.codigo == 'formula_spurr')
                .codigo,
            simbolo: 'a',
          ),
          CalculadoraVolumeFlorestal.padraoSpurrA,
        );
        expect(
          CalculadoraVolumeFlorestal.valorPadraoCoeficiente(
            modeloMatematicoCodigo: modelos
                .singleWhere((m) => m.codigo == 'formula_schumacher_hall')
                .codigo,
            simbolo: 'c',
          ),
          CalculadoraVolumeFlorestal.padraoSchumacherHallC,
        );
      } finally {
        await banco.close();
        pasta.deleteSync(recursive: true);
      }
    },
  );

  test('traduz todos os enums legados antes de converter os IDs', () async {
    final pasta = Directory.systemTemp.createTempSync('dendro_enums11_');
    final arquivo = File('${pasta.path}/banco.sqlite');
    prepararLegado(arquivo, 9);
    final enums =
        jsonDecode(File('test/fixtures/enums_v9.json').readAsStringSync())
            as Map<String, dynamic>;
    final legado = sqlite.sqlite3.open(arquivo.path);
    legado.execute('DELETE FROM activity_logs');
    final tipos = (enums['ActivityLogType'] as List).cast<String>();
    final entidades = (enums['ActivityEntityType'] as List).cast<String>();
    for (var i = 0; i < tipos.length; i++) {
      legado.execute('INSERT INTO activity_logs VALUES (?,?,?,?,?,?,?)', [
        'evento-$i',
        tipos[i],
        'Título',
        'Texto',
        entidades[i % entidades.length],
        null,
        i,
      ]);
    }
    legado.close();
    final banco = BancoDendro(NativeDatabase(arquivo));
    try {
      final eventos = (await RepositorioAtividades(
        banco,
      ).recente(limite: 100)).reversed.toList();
      expect(eventos.map((e) => e.tipo), TipoAtividade.values);
      for (var i = 0; i < eventos.length; i++) {
        expect(
          eventos[i].tipoEntidade,
          TipoEntidadeAtividade.values[i % entidades.length],
        );
      }
    } finally {
      await banco.close();
      pasta.deleteSync(recursive: true);
    }
  });
}
