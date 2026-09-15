import 'dart:io';
import 'package:dendro_mobile/nucleo/banco/banco_dendro.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('migra v7 preservando medidas, relacionamentos e atividades', () async {
    final pasta = Directory.systemTemp.createTempSync('dendro_migracao_');
    final arquivo = File('${pasta.path}/teste.sqlite');
    final banco = BancoDendro(
      NativeDatabase(
        arquivo,
        setup: (antigo) {
          antigo.execute(
            File(
              'test/nucleo/banco/fixtures/esquema_v7.sql',
            ).readAsStringSync(),
          );
          antigo.execute("""
      INSERT INTO properties VALUES ('p','Fazenda Teste','Teste','RS',50,100,100);
      INSERT INTO species VALUES ('species_pinus','Pinus',NULL,NULL,1,100,100);
      INSERT INTO formulas VALUES ('formula_spurr','Spurr',NULL,'a+b*D^2*H',1,100,100);
      INSERT INTO stands VALUES ('t','p','Talhão 01','species_pinus',10,NULL,NULL,NULL,20,20,NULL,100,100);
      INSERT INTO inventory_runs VALUES ('l','p','inProgress',100,100,NULL);
      INSERT INTO talhao_levantamentos VALUES ('tl','l','t','species_pinus','formula_spurr',0.04,100,100);
      INSERT INTO plots VALUES ('pa','tl','1','collected',0.04,NULL,100,100);
      INSERT INTO trees VALUES ('a','pa',1,25,20,1,-27,-53,5,100,'p1',100,100);
      INSERT INTO talhao_formula_coefficients VALUES ('c','tl','a','a',0.125);
      INSERT INTO activity_logs VALUES ('h','plotCollected','Teste','', 'plot','pa',100);
      INSERT INTO activity_logs VALUES ('h2','plotDeleted','Excluída','', 'plot','apagada',100);
    """);
        },
      ),
    );
    try {
      final especies = await banco.select(banco.especies).get();
      expect(especies.single.codigo, 'species_pinus');
      final arvores = await banco.select(banco.arvores).get();
      expect(arvores.single.dapCm, 25);
      expect(arvores.single.alturaM, 20);
      expect(arvores.single.latitude, -27);
      expect(arvores.single.possuiTroncoTortuoso, isTrue);
      final parcelas = await banco.select(banco.parcelas).get();
      expect(arvores.single.parcelaId, parcelas.single.id);
      expect(parcelas.single.situacao, SituacaoParcela.coletada);
      expect(
        (await banco.select(banco.levantamentos).get()).single.situacao,
        SituacaoLevantamento.emAndamento,
      );
      expect(
        (await banco.select(banco.coeficientesTalhaoLevantamento).get())
            .single
            .valor,
        0.125,
      );
      final atividades = await banco
          .customSelect('SELECT * FROM registros_atividade ORDER BY id')
          .get();
      expect(atividades.first.data['entidade_id'], parcelas.single.id);
      expect(atividades.last.data['referencia_legada'], 'apagada');
      expect(
        await banco.customSelect('PRAGMA foreign_key_check').get(),
        isEmpty,
      );
    } finally {
      await banco.close();
    }
    final reaberto = BancoDendro(NativeDatabase(arquivo));
    expect((await reaberto.select(reaberto.arvores).get()).single.dapCm, 25);
    await reaberto.close();
    pasta.deleteSync(recursive: true);
  });

  for (final versao in [1, 11]) {
    test(
      'abre esquema inteiro da versão $versao sem recriar registros',
      () async {
        final pasta = Directory.systemTemp.createTempSync('dendro_inteiro_');
        final arquivo = File('${pasta.path}/teste.sqlite');
        final banco = BancoDendro(NativeDatabase(arquivo));
        final antes = await banco.select(banco.especies).get();
        await banco.customStatement('PRAGMA user_version = $versao');
        await banco.close();
        final reaberto = BancoDendro(NativeDatabase(arquivo));
        expect(await reaberto.select(reaberto.especies).get(), antes);
        await reaberto.close();
        pasta.deleteSync(recursive: true);
      },
    );
  }

  final original = Platform.environment['DENDRO_BANCO_DIAGNOSTICO'];
  if (original != null) {
    test('abre cópia do banco do dispositivo', () async {
      final pasta = Directory.systemTemp.createTempSync('dendro_copia_');
      final copia = File(original).copySync('${pasta.path}/copia.sqlite');
      final banco = BancoDendro(NativeDatabase(copia));
      try {
        expect(await banco.select(banco.especies).get(), isNotEmpty);
        expect(
          await banco.customSelect('PRAGMA foreign_key_check').get(),
          isEmpty,
        );
      } finally {
        await banco.close();
        pasta.deleteSync(recursive: true);
      }
    });
  }
}
