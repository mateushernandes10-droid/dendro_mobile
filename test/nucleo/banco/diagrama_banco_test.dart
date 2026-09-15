import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dendro_mobile/nucleo/banco/banco_dendro.dart';

void main() {
  test(
    'diagrama completo representa tabelas campos tipos e nulabilidade',
    () async {
      final banco = BancoDendro(NativeDatabase.memory());
      try {
        final diagrama = File(
          'tcc_codex_context/docs/diagrams/04_banco_completo.mmd',
        ).readAsStringSync().replaceAll('\r', '');
        final tabelas = await banco
            .customSelect(
              "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
            )
            .get();
        expect(tabelas, hasLength(15));
        var total = 0;
        for (final linha in tabelas) {
          final tabela = linha.read<String>('name');
          final bloco = RegExp(
            '^    $tabela \\{([\\s\\S]*?)^    \\}',
            multiLine: true,
          ).firstMatch(diagrama);
          expect(bloco, isNotNull, reason: tabela);
          final campos = RegExp(
            r'^\s+(text|real|integer) (\w+)(.*)$',
            multiLine: true,
          ).allMatches(bloco!.group(1)!).toList();
          final colunas = await banco
              .customSelect('PRAGMA table_info("$tabela")')
              .get();
          expect(campos, hasLength(colunas.length), reason: tabela);
          for (final coluna in colunas) {
            final nome = coluna.read<String>('name');
            final campo = campos.singleWhere((c) => c.group(2) == nome);
            expect(
              campo.group(1),
              coluna.read<String>('type').toLowerCase(),
              reason: '$tabela.$nome',
            );
            final opcional =
                coluna.read<int>('notnull') == 0 && coluna.read<int>('pk') == 0;
            expect(
              campo.group(3)!.contains('nullable'),
              opcional,
              reason: 'Nulabilidade $tabela.$nome',
            );
            total++;
          }
        }
        expect(total, 114);
        final documento = File(
          'tcc_codex_context/docs/ENGINEERING_MODELS.md',
        ).readAsStringSync().replaceAll('\r', '');
        final fontes = Directory(
          'tcc_codex_context/docs/diagrams',
        ).listSync().whereType<File>().where((f) => f.path.endsWith('.mmd'));
        expect(fontes, hasLength(8));
        for (final fonte in fontes) {
          expect(
            documento,
            contains(fonte.readAsStringSync().replaceAll('\r', '').trim()),
            reason: fonte.path,
          );
        }
      } finally {
        await banco.close();
      }
    },
  );
}
