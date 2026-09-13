import 'dart:io';

import 'package:dendro_mobile/nucleo/banco/banco_dendro.dart';
import 'package:dendro_mobile/nucleo/floresta/calculadora_volume_florestal.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('atualiza banco v7 preservando coeficientes e modelo padrao', () async {
    final diretorio = await Directory.systemTemp.createTemp('dendro_ff_test_');
    final arquivo = File('${diretorio.path}/test.sqlite');
    var bancoDados = BancoDendro(NativeDatabase(arquivo));
    try {
      await bancoDados.select(bancoDados.modelosMatematicos).get();
      const id = CalculadoraVolumeFlorestal.modeloFatorFormaId;
      // Reproduce the v7 catalog. No table structure changed in v8.
      for (final tabela in [
        'coeficientes_especie_modelo',
        'especies_modelos',
        'variaveis_modelo',
        'coeficientes_modelo',
      ]) {
        await bancoDados.customStatement(
          'DELETE FROM $tabela WHERE modelo_matematico_id = ?',
          [id],
        );
      }
      await (bancoDados.delete(
        bancoDados.modelosMatematicos,
      )..where((t) => t.id.equals(id))).go();
      await (bancoDados.update(bancoDados.coeficientesModelo)
            ..where((t) => t.id.equals('formula_spurr_a')))
          .write(const CoeficientesModeloCompanion(valor: Value(0.123)));
      await bancoDados.customStatement('PRAGMA user_version = 7');
      await bancoDados.close();
      bancoDados = BancoDendro(NativeDatabase(arquivo));

      final modelosMatematicos = await bancoDados.select(bancoDados.modelosMatematicos).get();
      expect(modelosMatematicos.where((f) => f.id == id), hasLength(1));
      final coeficientes = await bancoDados
          .select(bancoDados.coeficientesModelo)
          .get();
      expect(
        coeficientes.singleWhere((c) => c.id == 'formula_spurr_a').valor,
        0.123,
      );
      expect(coeficientes.singleWhere((c) => c.modeloMatematicoId == id).valor, isNull);
      final vinculos = await bancoDados.select(bancoDados.especiesModelos).get();
      expect(vinculos.where((l) => l.modeloMatematicoId == id), hasLength(2));
      expect(
        vinculos
            .where((l) => l.padrao)
            .every((l) => l.modeloMatematicoId == 'formula_spurr'),
        isTrue,
      );

      await (bancoDados.update(bancoDados.coeficientesEspecieModelo)..where(
            (t) => t.modeloMatematicoId.equals(id) & t.especieId.equals('species_pinus'),
          ))
          .write(const CoeficientesEspecieModeloCompanion(valor: Value(0.42)));
      await bancoDados.close();
      bancoDados = BancoDendro(NativeDatabase(arquivo));
      final salvo =
          await (bancoDados.select(bancoDados.coeficientesEspecieModelo)..where(
                (t) =>
                    t.modeloMatematicoId.equals(id) &
                    t.especieId.equals('species_pinus'),
              ))
              .getSingle();
      expect(salvo.valor, 0.42);

      // Simulate the v8 model already configured by the user.
      await (bancoDados.update(
        bancoDados.modelosMatematicos,
      )..where((t) => t.id.equals(id))).write(
        const ModelosMatematicosCompanion(
          nome: Value('Calcular Volume - Fator de Fórmula'),
          expressao: Value('pi * D^2 * H * ff'),
        ),
      );
      await (bancoDados.update(
        bancoDados.coeficientesEspecieModelo,
      )..where((t) => t.modeloMatematicoId.equals(id))).write(
        const CoeficientesEspecieModeloCompanion(
          rotulo: Value('Fator de fórmula'),
        ),
      );
      await bancoDados.customStatement('PRAGMA user_version = 8');
      await bancoDados.close();
      bancoDados = BancoDendro(NativeDatabase(arquivo));
      final atualizado = await (bancoDados.select(
        bancoDados.modelosMatematicos,
      )..where((t) => t.id.equals(id))).getSingle();
      expect(atualizado.nome, 'Fator de Forma');
      expect(atualizado.expressao, 'pi * (D / 100)^2 * H * ff');
      final preservado =
          await (bancoDados.select(bancoDados.coeficientesEspecieModelo)..where(
                (t) =>
                    t.modeloMatematicoId.equals(id) &
                    t.especieId.equals('species_pinus'),
              ))
              .getSingle();
      expect(preservado.valor, 0.42);
      expect(preservado.rotulo, 'Fator de forma');
    } finally {
      await bancoDados.close();
      await diretorio.delete(recursive: true);
    }
  });
}
