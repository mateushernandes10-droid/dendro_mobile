import 'dart:convert';
import 'dart:io';

import 'package:dendro_mobile/nucleo/banco/banco_dendro.dart';
import 'package:dendro_mobile/funcionalidades/exportacao_dados/dados/repositorio_exportacao_dados.dart';
import 'package:dendro_mobile/funcionalidades/parcelas/dados/repositorio_parcelas.dart';
import 'package:dendro_mobile/funcionalidades/propriedades/dados/repositorio_propriedades.dart';
import 'package:dendro_mobile/funcionalidades/talhoes/dados/repositorio_talhoes.dart';
import 'package:dendro_mobile/funcionalidades/coleta_arvores/dados/repositorio_arvores.dart';
import 'package:drift/native.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'exporta todas as arvores selecionadas com medicoes originais em CSV e XLSX',
    () async {
      final bancoDados = BancoDendro(NativeDatabase.memory());
      final diretorio = await Directory.systemTemp.createTemp(
        'dendro_raw_export_',
      );
      const canal = MethodChannel('plugins.flutter.io/path_provider');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(canal, (_) async => diretorio.path);
      try {
        final propriedadeId = await RepositorioPropriedades(bancoDados).criar(
          nome: 'Fazenda "São João"; Sul',
          municipio: 'Vacaria',
          areaTotalHa: 30,
        );
        final parcelas = RepositorioParcelas(bancoDados);
        final arvores = RepositorioArvores(bancoDados);
        final levantamentoTalhoes = <TalhaoLevantamento>[];
        for (var i = 1; i <= 2; i++) {
          final talhaoId = await RepositorioTalhoes(bancoDados).criar(
            propriedadeId: propriedadeId,
            identificacao: 'T-0$i',
            especieId: (await bancoDados.select(bancoDados.especies).get())
                .singleWhere((e) => e.codigo == 'species_pinus')
                .id,
            areaHa: 10,
          );
          final levantamentoTalhao = await parcelas
              .iniciarNovoLevantamentoParaTalhao(talhaoId);
          levantamentoTalhoes.add(levantamentoTalhao);
          final parcelaId = await parcelas.criarParcelaParaTalhaoLevantamento(
            talhaoLevantamentoId: levantamentoTalhao.id,
            areaHa: 0.04,
          );
          await arvores.criarArvore(
            parcelaId: parcelaId,
            rascunho: RascunhoArvore(
              dapCm: i == 1 ? 20.123456789 : 30,
              alturaM: i == 1 ? 0 : 14.987654321,
              possuiTroncoTortuoso: false,
            ),
          );
          if (i == 2) await arvores.marcarParcelaColetada(parcelaId);
        }
        final repositorio = RepositorioExportacaoDados(bancoDados);
        final solicitacao = SolicitacaoExportacaoDados(
          levantamentoId: levantamentoTalhoes.first.levantamentoId,
        );
        final selecionado = levantamentoTalhoes.map((s) => s.id).toSet();
        final csv = await repositorio.gerarArquivo(
          solicitacao: solicitacao,
          formato: FormatoExportacaoDados.brutoCsv,
          talhaoLevantamentoIds: selecionado,
        );
        final csvBytes = await File(csv.caminho).readAsBytes();
        expect(csvBytes.take(3), [0xef, 0xbb, 0xbf]);
        final texto = utf8.decode(csvBytes);
        final linhas = const LineSplitter().convert(texto);
        expect(linhas, hasLength(3));
        expect(
          linhas.first,
          startsWith('Propriedade;Talhão;Parcela;Árvore;DAP (cm);Altura (m)'),
        );
        expect(
          linhas[1],
          startsWith(
            '"Fazenda ""São João""; Sul";T-01;P01;1;20,123456789;0,0;',
          ),
        );
        expect(linhas[2], contains(';T-02;P01;1;30,0;14,987654321;'));
        expect(texto, isNot(contains('Volume')));
        expect(csv.nomeArquivo, contains('dados_brutos'));

        final segundoParcelaId = await parcelas
            .criarParcelaParaTalhaoLevantamento(
              talhaoLevantamentoId: levantamentoTalhoes.first.id,
              areaHa: 0.04,
            );
        for (final dap in [25.25, 26.75]) {
          await arvores.criarArvore(
            parcelaId: segundoParcelaId,
            rascunho: RascunhoArvore(
              dapCm: dap,
              alturaM: 12.5,
              possuiTroncoTortuoso: false,
            ),
          );
        }
        await parcelas.criarParcelaParaTalhaoLevantamento(
          talhaoLevantamentoId: levantamentoTalhoes.first.id,
          areaHa: 0.04,
        );

        final xlsx = await repositorio.gerarArquivo(
          solicitacao: solicitacao,
          formato: FormatoExportacaoDados.brutoXlsx,
          talhaoLevantamentoIds: selecionado,
        );
        final planilha = Excel.decodeBytes(
          await File(xlsx.caminho).readAsBytes(),
        );
        expect(planilha.tables.keys, ['Talhão 1', 'Talhão 2']);
        CellValue? celula(String endereco, [String aba = 'Talhão 1']) =>
            planilha[aba].cell(CellIndex.indexByString(endereco)).value;
        expect(celula('B1'), TextCellValue('Fazenda "São João"; Sul'));
        expect(celula('B2'), TextCellValue('T-01'));
        expect(celula('A6'), TextCellValue('P01'));
        expect(celula('E6'), TextCellValue('P02'));
        expect(celula('I6'), TextCellValue('P03'));
        expect(celula('A7'), IntCellValue(1));
        expect(celula('B7'), DoubleCellValue(20.123456789));
        expect(celula('C7'), IntCellValue(0));
        expect(celula('D7'), isNull);
        expect(celula('A8'), isNull);
        expect(celula('E7'), IntCellValue(1));
        expect(celula('F7'), DoubleCellValue(25.25));
        expect(celula('G7'), DoubleCellValue(12.5));
        expect(celula('E8'), IntCellValue(2));
        expect(celula('F8'), DoubleCellValue(26.75));
        expect(celula('I7'), isNull);
        expect(celula('B2', 'Talhão 2'), TextCellValue('T-02'));
        expect(celula('C7', 'Talhão 2'), DoubleCellValue(14.987654321));

        final filtrado = await repositorio.gerarArquivo(
          solicitacao: solicitacao,
          formato: FormatoExportacaoDados.brutoCsv,
          talhaoLevantamentoIds: {levantamentoTalhoes.last.id},
        );
        final filtradoTexto = await File(filtrado.caminho).readAsString();
        expect(const LineSplitter().convert(filtradoTexto), hasLength(2));
        expect(filtradoTexto, isNot(contains('T-01')));
        expect(filtradoTexto, contains('T-02'));
      } finally {
        await bancoDados.close();
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(canal, null);
        await diretorio.delete(recursive: true);
      }
    },
  );

  test(
    'exporta coordenadas das arvores e referencias P1 a P4 em KML CSV e XLSX',
    () async {
      final bancoDados = BancoDendro(NativeDatabase.memory());
      final diretorio = await Directory.systemTemp.createTemp(
        'dendro_coordinate_export_',
      );
      const canal = MethodChannel('plugins.flutter.io/path_provider');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(canal, (_) async => diretorio.path);

      try {
        final propriedadeId = await RepositorioPropriedades(bancoDados).criar(
          nome: 'Fazenda Coordenadas',
          municipio: 'Vacaria',
          areaTotalHa: 20,
        );
        final especieId = (await bancoDados.select(bancoDados.especies).get())
            .singleWhere((especie) => especie.codigo == 'species_pinus')
            .id;
        final talhaoId = await RepositorioTalhoes(bancoDados).criar(
          propriedadeId: propriedadeId,
          identificacao: 'T-GPS',
          especieId: especieId,
          areaHa: 8,
        );
        final repositorioParcelas = RepositorioParcelas(bancoDados);
        final talhaoLevantamento = await repositorioParcelas
            .iniciarNovoLevantamentoParaTalhao(talhaoId);
        final parcelaId = await repositorioParcelas
            .criarParcelaParaTalhaoLevantamento(
              talhaoLevantamentoId: talhaoLevantamento.id,
              areaHa: 0.04,
            );
        final repositorioArvores = RepositorioArvores(bancoDados);
        final referencias = PosicaoReferenciaParcela.values;
        final coordenadas = [
          (latitude: -28.5000, longitude: -50.9000),
          (latitude: -28.5000, longitude: -50.8990),
          (latitude: -28.4990, longitude: -50.8990),
          (latitude: -28.4990, longitude: -50.9000),
        ];

        for (var indice = 0; indice < referencias.length; indice++) {
          await repositorioArvores.criarArvore(
            parcelaId: parcelaId,
            rascunho: RascunhoArvore(
              dapCm: 20 + indice.toDouble(),
              alturaM: 15 + indice.toDouble(),
              possuiTroncoTortuoso: false,
              latitude: coordenadas[indice].latitude,
              longitude: coordenadas[indice].longitude,
              precisaoMetros: 3.5,
              localizacaoCapturadaEm: DateTime(2026, 9, 16, 10, indice),
              posicaoReferenciaParcela: referencias[indice],
            ),
          );
        }

        final repositorio = RepositorioExportacaoDados(bancoDados);
        final solicitacao = SolicitacaoExportacaoDados(
          levantamentoId: talhaoLevantamento.levantamentoId,
        );
        final estado = await repositorio.carregar(solicitacao);
        expect(estado.talhoes.single.coordenadaQuantidade, 4);

        final kml = await repositorio.gerarArquivo(
          solicitacao: solicitacao,
          formato: FormatoExportacaoDados.kml,
          talhaoLevantamentoIds: {talhaoLevantamento.id},
        );
        final textoKml = await File(kml.caminho).readAsString();
        expect(kml.nomeArquivo, endsWith('.kml'));
        expect(kml.tipoMime, 'application/vnd.google-earth.kml+xml');
        expect(textoKml, contains('<Polygon>'));
        expect(textoKml, contains('T-GPS - P01 - P1'));
        expect(textoKml, contains('T-GPS - P01 - P2'));
        expect(textoKml, contains('T-GPS - P01 - P3'));
        expect(textoKml, contains('T-GPS - P01 - P4'));
        expect(textoKml, contains('-50.90000000,-28.50000000,0'));
        expect(textoKml, contains('-50.89900000,-28.49900000,0'));
        expect(
          textoKml,
          isNot(contains('Nenhuma coordenada GPS foi registrada')),
        );

        final csv = await repositorio.gerarArquivo(
          solicitacao: solicitacao,
          formato: FormatoExportacaoDados.csv,
          talhaoLevantamentoIds: {talhaoLevantamento.id},
        );
        final textoCsv = await File(csv.caminho).readAsString();
        expect(textoCsv, contains('Latitude árvore;Longitude árvore'));
        expect(textoCsv, contains('-28.50000000;-50.90000000;3,50;P1'));
        expect(textoCsv, contains('-28.49900000;-50.89900000;3,50;P3'));

        final xlsx = await repositorio.gerarArquivo(
          solicitacao: solicitacao,
          formato: FormatoExportacaoDados.xls,
          talhaoLevantamentoIds: {talhaoLevantamento.id},
        );
        final planilha = Excel.decodeBytes(
          await File(xlsx.caminho).readAsBytes(),
        );
        expect(planilha.tables.keys, contains('Coordenadas'));
        final abaCoordenadas = planilha['Coordenadas'];
        CellValue? coordenadaCelula(String endereco) =>
            abaCoordenadas.cell(CellIndex.indexByString(endereco)).value;
        expect(coordenadaCelula('D2'), TextCellValue('Árvore'));
        expect(coordenadaCelula('E2'), TextCellValue('P1'));
        expect(coordenadaCelula('F2'), DoubleCellValue(-28.5));
        expect(coordenadaCelula('G2'), DoubleCellValue(-50.9));
        expect(coordenadaCelula('E5'), TextCellValue('P4'));
        expect(abaCoordenadas.maxRows, 5);
      } finally {
        await bancoDados.close();
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(canal, null);
        await diretorio.delete(recursive: true);
      }
    },
  );
}
