import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dendro_mobile/nucleo/banco/banco_dendro.dart';
import 'package:dendro_mobile/nucleo/banco/migracao_nomenclatura.dart';
import 'package:dendro_mobile/nucleo/banco/migracao_ids_inteiros.dart';
import '../../fixtures/preparar_legado.dart';

void main() {
  for (var versao = 1; versao <= 9; versao++) {
    test('migra banco original v$versao ate v11 preservando dados', () async {
      final pasta = Directory.systemTemp.createTempSync('dendro_legado_');
      final arquivo = File('${pasta.path}/banco.sqlite');
      final antigos = prepararLegado(arquivo, versao);
      final banco = BancoDendro(NativeDatabase(arquivo));
      try {
        await banco.select(banco.propriedades).get();
        expect(
          (await banco.customSelect('PRAGMA user_version').getSingle())
              .read<int>('user_version'),
          11,
        );
        for (final entrada in antigos.entries) {
          final tabela = nomesTabelasLegadas[entrada.key]!;
          final atuais = await banco
              .customSelect('SELECT * FROM "$tabela" ORDER BY rowid')
              .get();
          expect(atuais.length, greaterThanOrEqualTo(entrada.value.length));
          for (var i = 0; i < entrada.value.length; i++) {
            for (final campo in entrada.value[i].entries) {
              final nome = nomesColunasLegadas[campo.key] ?? campo.key;
              if (nome == 'id' ||
                  relacionamentosIds[tabela]!.containsKey(nome) ||
                  nome == 'entidade_id') {
                continue;
              }
              Object? esperado = campo.value;
              if (nome == 'situacao') {
                esperado = tabela == 'parcelas' ? 'coletada' : 'emAndamento';
              }
              if (nome == 'chave_variavel') esperado = 'altura';
              if (tabela == 'registros_atividade' && nome == 'tipo') {
                esperado = 'propriedadeCriada';
              }
              if (tabela == 'registros_atividade' && nome == 'tipo_entidade') {
                esperado = 'propriedade';
              }
              expect(
                atuais[i].data[nome],
                esperado,
                reason: 'v$versao $tabela.$nome',
              );
            }
          }
        }
        expect(
          await banco.customSelect('PRAGMA foreign_key_check').get(),
          isEmpty,
        );
        expect(
          (await banco.select(banco.arvores).get()).single.parcelaId,
          (await banco.select(banco.parcelas).get()).single.id,
        );
      } finally {
        await banco.close();
        pasta.deleteSync(recursive: true);
      }
    });
  }
}
