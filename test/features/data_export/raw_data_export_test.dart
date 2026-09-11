import 'dart:convert';
import 'dart:io';

import 'package:dendro_mobile/core/database/dendro_database.dart';
import 'package:dendro_mobile/features/data_export/data/data_export_repository.dart';
import 'package:dendro_mobile/features/plots/data/plots_repository.dart';
import 'package:dendro_mobile/features/properties/data/properties_repository.dart';
import 'package:dendro_mobile/features/stands/data/stands_repository.dart';
import 'package:dendro_mobile/features/tree_collection/data/trees_repository.dart';
import 'package:drift/native.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'exporta todas as arvores selecionadas com medicoes originais em CSV e XLSX',
    () async {
      final database = DendroDatabase(NativeDatabase.memory());
      final directory = await Directory.systemTemp.createTemp(
        'dendro_raw_export_',
      );
      const channel = MethodChannel('plugins.flutter.io/path_provider');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (_) async => directory.path);
      try {
        final propertyId = await PropertiesRepository(database).create(
          name: 'Fazenda "São João"; Sul',
          municipality: 'Vacaria',
          totalAreaHa: 30,
        );
        final plots = PlotsRepository(database);
        final trees = TreesRepository(database);
        final runStands = <TalhaoLevantamentoRecord>[];
        for (var i = 1; i <= 2; i++) {
          final standId = await StandsRepository(database).create(
            propertyId: propertyId,
            identification: 'T-0$i',
            speciesId: 'species_pinus',
            areaHa: 10,
          );
          final runStand = await plots.startNewInventoryForStand(standId);
          runStands.add(runStand);
          final plotId = await plots.createPlotForTalhaoLevantamento(
            talhaoLevantamentoId: runStand.id,
            areaHa: 0.04,
          );
          await trees.createTree(
            plotId: plotId,
            draft: TreeDraft(
              dapCm: i == 1 ? 20.123456789 : 30,
              heightM: i == 1 ? 0 : 14.987654321,
              hasTortuousStem: false,
            ),
          );
          if (i == 2) await trees.markPlotCollected(plotId);
        }
        final repository = DataExportRepository(database);
        final request = DataExportRequest(
          inventoryRunId: runStands.first.inventoryRunId,
        );
        final selected = runStands.map((s) => s.id).toSet();
        final csv = await repository.generateFile(
          request: request,
          format: DataExportFormat.rawCsv,
          talhaoLevantamentoIds: selected,
        );
        final csvBytes = await File(csv.path).readAsBytes();
        expect(csvBytes.take(3), [0xef, 0xbb, 0xbf]);
        final text = utf8.decode(csvBytes);
        final lines = const LineSplitter().convert(text);
        expect(lines, hasLength(3));
        expect(
          lines.first,
          startsWith('Propriedade;Talhão;Parcela;Árvore;DAP (cm);Altura (m)'),
        );
        expect(
          lines[1],
          startsWith(
            '"Fazenda ""São João""; Sul";T-01;P01;1;20,123456789;0,0;',
          ),
        );
        expect(lines[2], contains(';T-02;P01;1;30,0;14,987654321;'));
        expect(text, isNot(contains('Volume')));
        expect(csv.fileName, contains('dados_brutos'));

        final secondPlotId = await plots.createPlotForTalhaoLevantamento(
          talhaoLevantamentoId: runStands.first.id,
          areaHa: 0.04,
        );
        for (final dap in [25.25, 26.75]) {
          await trees.createTree(
            plotId: secondPlotId,
            draft: TreeDraft(dapCm: dap, heightM: 12.5, hasTortuousStem: false),
          );
        }
        await plots.createPlotForTalhaoLevantamento(
          talhaoLevantamentoId: runStands.first.id,
          areaHa: 0.04,
        );

        final xlsx = await repository.generateFile(
          request: request,
          format: DataExportFormat.rawXlsx,
          talhaoLevantamentoIds: selected,
        );
        final workbook = Excel.decodeBytes(await File(xlsx.path).readAsBytes());
        expect(workbook.tables.keys, ['Talhão 1', 'Talhão 2']);
        CellValue? cell(String address, [String tab = 'Talhão 1']) =>
            workbook[tab].cell(CellIndex.indexByString(address)).value;
        expect(cell('B1'), TextCellValue('Fazenda "São João"; Sul'));
        expect(cell('B2'), TextCellValue('T-01'));
        expect(cell('A6'), TextCellValue('P01'));
        expect(cell('E6'), TextCellValue('P02'));
        expect(cell('I6'), TextCellValue('P03'));
        expect(cell('A7'), IntCellValue(1));
        expect(cell('B7'), DoubleCellValue(20.123456789));
        expect(cell('C7'), IntCellValue(0));
        expect(cell('D7'), isNull);
        expect(cell('A8'), isNull);
        expect(cell('E7'), IntCellValue(1));
        expect(cell('F7'), DoubleCellValue(25.25));
        expect(cell('G7'), DoubleCellValue(12.5));
        expect(cell('E8'), IntCellValue(2));
        expect(cell('F8'), DoubleCellValue(26.75));
        expect(cell('I7'), isNull);
        expect(cell('B2', 'Talhão 2'), TextCellValue('T-02'));
        expect(cell('C7', 'Talhão 2'), DoubleCellValue(14.987654321));

        final filtered = await repository.generateFile(
          request: request,
          format: DataExportFormat.rawCsv,
          talhaoLevantamentoIds: {runStands.last.id},
        );
        final filteredText = await File(filtered.path).readAsString();
        expect(const LineSplitter().convert(filteredText), hasLength(2));
        expect(filteredText, isNot(contains('T-01')));
        expect(filteredText, contains('T-02'));
      } finally {
        await database.close();
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null);
        await directory.delete(recursive: true);
      }
    },
  );
}
