import 'dart:io';

import 'package:dendro_mobile/funcionalidades/backup/dados/repositorio_backup.dart';
import 'package:dendro_mobile/funcionalidades/coleta_arvores/dados/repositorio_arvores.dart';
import 'package:dendro_mobile/funcionalidades/parcelas/dados/repositorio_parcelas.dart';
import 'package:dendro_mobile/funcionalidades/propriedades/dados/repositorio_propriedades.dart';
import 'package:dendro_mobile/funcionalidades/talhoes/dados/repositorio_talhoes.dart';
import 'package:dendro_mobile/nucleo/banco/banco_dendro.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'backup restaura os dados e preserva uma copia do estado anterior',
    () async {
      final diretorio = await Directory.systemTemp.createTemp('dendro_backup_');
      addTearDown(() => diretorio.delete(recursive: true));

      final banco = BancoDendro(NativeDatabase.memory());
      addTearDown(banco.close);
      final propriedades = RepositorioPropriedades(banco);
      final talhoes = RepositorioTalhoes(banco);
      final parcelas = RepositorioParcelas(banco);
      final arvores = RepositorioArvores(banco);
      final backup = RepositorioBackup(
        banco,
        obterDiretorioDocumentos: () async => diretorio,
      );

      final propriedadeId = await propriedades.criar(
        nome: 'Fazenda preservada',
        municipio: 'Santa Maria',
        areaTotalHa: 25,
      );
      final especie = (await talhoes.observarEspeciesAtivas().first).first;
      final talhaoId = await talhoes.criar(
        propriedadeId: propriedadeId,
        identificacao: 'T-01',
        especieId: especie.id,
        areaHa: 10,
      );
      final talhaoLevantamento = await parcelas
          .iniciarNovoLevantamentoParaTalhao(talhaoId);
      final parcelaId = await parcelas.criarParcelaParaTalhaoLevantamento(
        talhaoLevantamentoId: talhaoLevantamento.id,
        areaHa: 0.04,
      );
      await arvores.criarArvore(
        parcelaId: parcelaId,
        rascunho: const RascunhoArvore(
          dapCm: 24,
          alturaM: 17,
          possuiTroncoTortuoso: true,
        ),
      );
      await arvores.marcarParcelaColetada(parcelaId);
      final arquivo = await backup.criarBackup();
      expect(await File(arquivo.caminho).exists(), isTrue);

      await propriedades.excluir(propriedadeId);
      expect(await banco.select(banco.propriedades).get(), isEmpty);

      await backup.restaurar(arquivo.caminho);

      final restauradas = await banco.select(banco.propriedades).get();
      expect(restauradas.single.nome, 'Fazenda preservada');
      expect(await banco.select(banco.talhoes).get(), hasLength(1));
      expect(await banco.select(banco.levantamentos).get(), hasLength(1));
      expect(await banco.select(banco.talhaoLevantamentos).get(), hasLength(1));
      expect(await banco.select(banco.parcelas).get(), hasLength(1));
      final arvoresRestauradas = await banco.select(banco.arvores).get();
      expect(arvoresRestauradas.single.dapCm, 24);
      expect(arvoresRestauradas.single.possuiTroncoTortuoso, isTrue);
      final backupsLocais = await backup.listarBackupsLocais();
      expect(backupsLocais, hasLength(2));
      expect(
        backupsLocais.any(
          (item) => item.nomeArquivo.startsWith('dendro_antes_restauracao_'),
        ),
        isTrue,
      );
    },
  );

  test('restauracao rejeita arquivo que nao pertence ao DENDRO', () async {
    final diretorio = await Directory.systemTemp.createTemp('dendro_backup_');
    addTearDown(() => diretorio.delete(recursive: true));

    final banco = BancoDendro(NativeDatabase.memory());
    addTearDown(banco.close);
    final backup = RepositorioBackup(
      banco,
      obterDiretorioDocumentos: () async => diretorio,
    );
    final arquivo = File(
      '${diretorio.path}${Platform.pathSeparator}invalido.txt',
    );
    await arquivo.writeAsString('arquivo qualquer');

    await expectLater(
      backup.restaurar(arquivo.path),
      throwsA(isA<ExcecaoBackup>()),
    );
  });
}
