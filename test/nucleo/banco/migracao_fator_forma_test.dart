import 'dart:io';
import 'dart:convert';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dendro_mobile/nucleo/banco/banco_dendro.dart';

void main() {
  for (final versao in [7, 8]) {
    test(
      'catalogo v$versao migra mantendo coeficientes e corrigindo fator de forma',
      () async {
        final pasta = Directory.systemTemp.createTempSync('dendro_ff_');
        final arquivo = File('${pasta.path}/banco.sqlite');
        final referencia =
            jsonDecode(File('test/fixtures/banco_v10.json').readAsStringSync())
                as Map<String, dynamic>;
        final legado = sqlite.sqlite3.open(arquivo.path);
        for (final e in referencia.entries) {
          legado.execute(e.value['sql'] as String);
          for (final item in e.value['dados'] as List) {
            final r = Map<String, Object?>.from(item as Map);
            legado.execute(
              'INSERT INTO ${e.key} (${r.keys.join(',')}) VALUES (${List.filled(r.length, '?').join(',')})',
              r.values.toList(),
            );
          }
        }
        legado.execute(
          "UPDATE coeficientes_modelo SET valor=0.123 WHERE id='formula_spurr_a'",
        );
        if (versao == 7) {
          for (final tabela in [
            'coeficientes_especie_modelo',
            'especies_modelos',
            'variaveis_modelo',
            'coeficientes_modelo',
          ]) {
            legado.execute(
              "DELETE FROM $tabela WHERE modelo_matematico_id='formula_form_factor'",
            );
          }
          legado.execute(
            "DELETE FROM modelos_matematicos WHERE id='formula_form_factor'",
          );
        } else {
          legado.execute(
            "UPDATE modelos_matematicos SET nome='Calcular Volume - Fator de Fórmula', expressao='pi * D^2 * H * ff' WHERE id='formula_form_factor'",
          );
          legado.execute(
            "UPDATE coeficientes_especie_modelo SET valor=0.42, rotulo='Fator de fórmula' WHERE modelo_matematico_id='formula_form_factor'",
          );
        }
        legado.execute('PRAGMA user_version=$versao');
        legado.close();
        final banco = BancoDendro(NativeDatabase(arquivo));
        try {
          final modelos = await banco.select(banco.modelosMatematicos).get();
          final fator = modelos.singleWhere(
            (m) => m.codigo == 'formula_form_factor',
          );
          final spurr = modelos.singleWhere((m) => m.codigo == 'formula_spurr');
          expect(fator.nome, 'Fator de Forma');
          expect(fator.expressao, 'pi * (D / 100)^2 * H * ff');
          final coeficientes = await banco
              .select(banco.coeficientesModelo)
              .get();
          expect(
            coeficientes
                .singleWhere(
                  (c) => c.modeloMatematicoId == spurr.id && c.simbolo == 'a',
                )
                .valor,
            0.123,
          );
          expect(
            (await banco.select(banco.especiesModelos).get())
                .where((v) => v.padrao)
                .every((v) => v.modeloMatematicoId == spurr.id),
            isTrue,
          );
          final ff = (await banco.select(banco.coeficientesEspecieModelo).get())
              .where((c) => c.modeloMatematicoId == fator.id);
          expect(ff, hasLength(2));
          expect(
            ff.every((c) => c.valor == (versao == 8 ? 0.42 : null)),
            isTrue,
          );
        } finally {
          await banco.close();
          pasta.deleteSync(recursive: true);
        }
      },
    );
  }
}
