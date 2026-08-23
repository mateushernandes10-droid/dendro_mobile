import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:excel/excel.dart' as excel;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/database/dendro_database.dart';
import '../../../core/forest/forest_volume_calculator.dart';
import '../../../core/providers/database_providers.dart';
import '../../activity_log/data/activity_log_repository.dart';

final dataExportRepositoryProvider = Provider<DataExportRepository>((ref) {
  return DataExportRepository(ref.watch(dendroDatabaseProvider));
});

final dataExportProvider = FutureProvider.autoDispose
    .family<DataExportState, DataExportRequest>((ref, request) {
      return ref.watch(dataExportRepositoryProvider).load(request);
    });

enum DataExportFormat {
  pdf(label: 'PDF', extension: 'pdf', mimeType: 'application/pdf'),
  csv(label: 'CSV', extension: 'csv', mimeType: 'text/csv'),
  xls(
    label: 'XLSX',
    extension: 'xlsx',
    mimeType:
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  ),
  googleEarth(
    label: 'KML',
    extension: 'kml',
    mimeType: 'application/vnd.google-earth.kml+xml',
  );

  const DataExportFormat({
    required this.label,
    required this.extension,
    required this.mimeType,
  });

  final String label;
  final String extension;
  final String mimeType;
}

class DataExportRequest {
  const DataExportRequest({
    this.propertyId,
    this.inventoryRunId,
    this.speciesId,
  });

  final String? propertyId;
  final String? inventoryRunId;
  final String? speciesId;

  @override
  bool operator ==(Object other) {
    return other is DataExportRequest &&
        other.propertyId == propertyId &&
        other.inventoryRunId == inventoryRunId &&
        other.speciesId == speciesId;
  }

  @override
  int get hashCode => Object.hash(propertyId, inventoryRunId, speciesId);
}

class DataExportState {
  const DataExportState({
    required this.properties,
    required this.property,
    required this.inventoryRun,
    required this.stands,
  });

  final List<PropertyRecord> properties;
  final PropertyRecord? property;
  final InventoryRunRecord? inventoryRun;
  final List<DataExportStandOption> stands;
}

class DataExportStandOption {
  const DataExportStandOption({
    required this.talhaoLevantamento,
    required this.stand,
    required this.species,
    required this.plotCount,
    required this.collectedPlotCount,
    required this.treeCount,
    required this.measuredAreaHa,
    required this.geoPointCount,
  });

  final TalhaoLevantamentoRecord talhaoLevantamento;
  final StandRecord stand;
  final SpeciesRecord species;
  final int plotCount;
  final int collectedPlotCount;
  final int treeCount;
  final double measuredAreaHa;
  final int geoPointCount;

  bool get hasData => plotCount > 0 || treeCount > 0 || geoPointCount > 0;
}

class GeneratedDataExportFile {
  const GeneratedDataExportFile({
    required this.path,
    required this.fileName,
    required this.mimeType,
    required this.format,
  });

  final String path;
  final String fileName;
  final String mimeType;
  final DataExportFormat format;
}

class DataExportDataset {
  const DataExportDataset({
    required this.property,
    required this.inventoryRun,
    required this.stands,
  });

  final PropertyRecord property;
  final InventoryRunRecord? inventoryRun;
  final List<DataExportStandDataset> stands;

  int get plotCount =>
      stands.fold(0, (total, stand) => total + stand.plots.length);

  int get collectedPlotCount => stands.fold(
    0,
    (total, stand) =>
        total +
        stand.plots
            .where((plot) => plot.plot.status == PlotStatus.collected)
            .length,
  );

  int get treeCount =>
      stands.fold(0, (total, stand) => total + stand.treeCount);

  double get measuredAreaHa =>
      stands.fold(0, (total, stand) => total + stand.measuredAreaHa);

  double get sampleVolumeM3 =>
      stands.fold(0, (total, stand) => total + stand.sampleVolumeM3);

  double get standAreaHa =>
      stands.fold(0, (total, stand) => total + stand.option.stand.areaHa);

  double? get volumePerHaM3 =>
      measuredAreaHa == 0 ? null : sampleVolumeM3 / measuredAreaHa;

  double? get estimatedVolumeM3 {
    if (measuredAreaHa == 0) return null;
    return stands.fold<double>(
      0,
      (total, stand) => total + (stand.estimatedVolumeM3 ?? 0),
    );
  }

  double? get treesPerHa =>
      measuredAreaHa == 0 ? null : treeCount / measuredAreaHa;

  double? get averageDapCm {
    final allTrees = [
      for (final stand in stands)
        for (final plot in stand.plots) ...plot.trees,
    ];
    if (allTrees.isEmpty) return null;
    return allTrees.fold<double>(0, (total, tree) => total + tree.dapCm) /
        allTrees.length;
  }

  double? get averageHeightM {
    final allTrees = [
      for (final stand in stands)
        for (final plot in stand.plots) ...plot.trees,
    ];
    if (allTrees.isEmpty) return null;
    return allTrees.fold<double>(0, (total, tree) => total + tree.heightM) /
        allTrees.length;
  }
}

class DataExportStandDataset {
  const DataExportStandDataset({
    required this.option,
    required this.formula,
    required this.coefficients,
    required this.plots,
  });

  final DataExportStandOption option;
  final FormulaRecord? formula;
  final List<DataExportCoefficient> coefficients;
  final List<DataExportPlotDataset> plots;

  int get treeCount =>
      plots.fold(0, (total, plot) => total + plot.trees.length);

  double get measuredAreaHa => plots.fold(
    0,
    (total, plot) =>
        total +
        (plot.plot.status == PlotStatus.pending ? 0 : plot.plot.areaHa ?? 0),
  );

  Map<String, double?> get coefficientValuesBySymbol => {
    for (final coefficient in coefficients)
      coefficient.symbol: coefficient.value,
  };

  WoodVolumeConversion get conversion =>
      ForestVolumeCalculator.conversionForSpecies(option.species.name);

  double get sampleVolumeM3 {
    return plots.fold<double>(
      0,
      (total, plot) =>
          total +
          plot.trees.fold<double>(
            0,
            (plotTotal, tree) => plotTotal + treeVolumeM3(tree),
          ),
    );
  }

  double? get volumePerHaM3 =>
      measuredAreaHa == 0 ? null : sampleVolumeM3 / measuredAreaHa;

  double? get estimatedVolumeM3 =>
      volumePerHaM3 == null ? null : volumePerHaM3! * option.stand.areaHa;

  double? get convertedEstimatedVolume =>
      estimatedVolumeM3 == null ? null : conversion.convert(estimatedVolumeM3!);

  double? get convertedVolumePerHa =>
      volumePerHaM3 == null ? null : conversion.convert(volumePerHaM3!);

  double? get treesPerHa =>
      measuredAreaHa == 0 ? null : treeCount / measuredAreaHa;

  double treeVolumeM3(TreeRecord tree) {
    return ForestVolumeCalculator.treeVolumeM3(
      dapCm: tree.dapCm,
      heightM: tree.heightM,
      coefficients: coefficientValuesBySymbol,
      formulaId: formula?.id,
      formulaExpression: formula?.expression,
    );
  }

  double? get averageDapCm {
    final allTrees = [for (final plot in plots) ...plot.trees];
    if (allTrees.isEmpty) return null;
    return allTrees.fold<double>(0, (total, tree) => total + tree.dapCm) /
        allTrees.length;
  }

  double? get averageHeightM {
    final allTrees = [for (final plot in plots) ...plot.trees];
    if (allTrees.isEmpty) return null;
    return allTrees.fold<double>(0, (total, tree) => total + tree.heightM) /
        allTrees.length;
  }
}

class DataExportCoefficient {
  const DataExportCoefficient({
    required this.symbol,
    required this.label,
    required this.value,
  });

  final String symbol;
  final String label;
  final double? value;
}

class DataExportPlotDataset {
  const DataExportPlotDataset({
    required this.plot,
    required this.trees,
    required this.geoPoints,
  });

  final PlotRecord plot;
  final List<TreeRecord> trees;
  final List<PlotGeoPointRecord> geoPoints;
}

class DataExportRepository {
  DataExportRepository(this._database);

  final DendroDatabase _database;
  late final ActivityLogRepository _activityLog = ActivityLogRepository(
    _database,
  );

  Future<DataExportState> load(DataExportRequest request) async {
    final properties = await _properties();
    final run = request.inventoryRunId == null
        ? null
        : await _inventoryRunById(request.inventoryRunId!);
    final propertyId = run?.propertyId ?? request.propertyId;
    final property = propertyId == null
        ? null
        : await _propertyById(propertyId);
    final stands = run == null
        ? await _latestStandOptionsForProperty(
            propertyId: propertyId,
            speciesId: request.speciesId,
          )
        : await _standOptionsForRun(
            runId: run.id,
            speciesId: request.speciesId,
          );

    return DataExportState(
      properties: properties,
      property: property,
      inventoryRun: run,
      stands: stands,
    );
  }

  Future<GeneratedDataExportFile> generateFile({
    required DataExportRequest request,
    required DataExportFormat format,
    required Set<String> talhaoLevantamentoIds,
  }) async {
    final dataset = await _datasetForExport(
      request: request,
      talhaoLevantamentoIds: talhaoLevantamentoIds,
    );
    final bytes = switch (format) {
      DataExportFormat.pdf => await _pdfBytes(dataset),
      DataExportFormat.csv => _csvBytes(dataset),
      DataExportFormat.xls => _xlsxBytes(dataset),
      DataExportFormat.googleEarth => _kmlBytes(dataset),
    };

    final directory = await getTemporaryDirectory();
    final exportDirectory = Directory(
      '${directory.path}${Platform.pathSeparator}dendro_exports',
    );
    await exportDirectory.create(recursive: true);

    final fileName = _fileName(dataset.property, format);
    final file = File(
      '${exportDirectory.path}${Platform.pathSeparator}$fileName',
    );
    await file.writeAsBytes(bytes, flush: true);

    return GeneratedDataExportFile(
      path: file.path,
      fileName: fileName,
      mimeType: format.mimeType,
      format: format,
    );
  }

  Future<void> recordExport({
    required List<String> formats,
    required PropertyRecord property,
    required int standCount,
  }) {
    final formatLabel = formats.join(', ');
    final standLabel = standCount == 1 ? '1 talhão' : '$standCount talhões';
    return _activityLog.recordExport(
      format: '$formatLabel - $standLabel',
      propertyName: property.name,
      entityId: property.id,
    );
  }

  Future<DataExportDataset> _datasetForExport({
    required DataExportRequest request,
    required Set<String> talhaoLevantamentoIds,
  }) async {
    final state = await load(request);
    final property = state.property;
    if (property == null) {
      throw StateError('Selecione uma propriedade para exportar.');
    }

    final selectedOptions = state.stands
        .where(
          (option) =>
              talhaoLevantamentoIds.contains(option.talhaoLevantamento.id),
        )
        .toList();

    if (selectedOptions.isEmpty) {
      throw StateError('Selecione pelo menos um talhão para exportar.');
    }

    final stands = <DataExportStandDataset>[];
    for (final option in selectedOptions) {
      final plots = await _plotsForTalhao(option.talhaoLevantamento.id);
      final formula = await _formulaById(option.talhaoLevantamento.formulaId);
      final coefficients = await _coefficientsForTalhao(
        talhaoLevantamentoId: option.talhaoLevantamento.id,
        formulaId: option.talhaoLevantamento.formulaId,
      );

      stands.add(
        DataExportStandDataset(
          option: option,
          formula: formula,
          coefficients: coefficients,
          plots: [
            for (final plot in plots)
              DataExportPlotDataset(
                plot: plot,
                trees: await _treesForPlot(plot.id),
                geoPoints: await _geoPointsForPlot(plot.id),
              ),
          ],
        ),
      );
    }

    return DataExportDataset(
      property: property,
      inventoryRun: state.inventoryRun,
      stands: stands,
    );
  }

  Future<List<PropertyRecord>> _properties() {
    return (_database.select(
      _database.properties,
    )..orderBy([(table) => OrderingTerm.asc(table.name)])).get();
  }

  Future<PropertyRecord?> _propertyById(String id) {
    return (_database.select(
      _database.properties,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<InventoryRunRecord?> _inventoryRunById(String id) {
    return (_database.select(
      _database.inventoryRuns,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<FormulaRecord?> _formulaById(String id) {
    return (_database.select(
      _database.formulas,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<List<DataExportCoefficient>> _coefficientsForTalhao({
    required String talhaoLevantamentoId,
    required String formulaId,
  }) async {
    final rows = await _database
        .customSelect(
          '''
SELECT symbol, label, value
FROM talhao_formula_coefficients
WHERE talhao_levantamento_id = ?
ORDER BY symbol
''',
          variables: [Variable<String>(talhaoLevantamentoId)],
          readsFrom: const {},
        )
        .get();

    final globalValues = await _globalCoefficientValues(formulaId);
    if (rows.isNotEmpty) {
      return [
        for (final row in rows)
          DataExportCoefficient(
            symbol: row.read<String>('symbol'),
            label: row.read<String>('label'),
            value: _effectiveCoefficientValue(
              formulaId: formulaId,
              symbol: row.read<String>('symbol'),
              value: row.readNullable<double>('value'),
              globalValues: globalValues,
            ),
          ),
      ];
    }

    final coefficients =
        await (_database.select(_database.formulaCoefficients)
              ..where((table) => table.formulaId.equals(formulaId))
              ..orderBy([(table) => OrderingTerm.asc(table.symbol)]))
            .get();

    return [
      for (final coefficient in coefficients)
        DataExportCoefficient(
          symbol: coefficient.symbol,
          label: coefficient.label,
          value: _effectiveCoefficientValue(
            formulaId: formulaId,
            symbol: coefficient.symbol,
            value: coefficient.value,
            globalValues: globalValues,
          ),
        ),
    ];
  }

  Future<Map<String, double?>> _globalCoefficientValues(
    String formulaId,
  ) async {
    final coefficients = await (_database.select(
      _database.formulaCoefficients,
    )..where((table) => table.formulaId.equals(formulaId))).get();
    return {
      for (final coefficient in coefficients)
        coefficient.symbol: coefficient.value,
    };
  }

  double? _effectiveCoefficientValue({
    required String formulaId,
    required String symbol,
    required double? value,
    required Map<String, double?> globalValues,
  }) {
    return value ??
        globalValues[symbol] ??
        ForestVolumeCalculator.defaultCoefficientValue(
          formulaId: formulaId,
          symbol: symbol,
        );
  }

  Future<List<DataExportStandOption>> _standOptionsForRun({
    required String runId,
    String? speciesId,
  }) async {
    final conditions = <Expression<bool>>[
      _database.talhaoLevantamentos.inventoryRunId.equals(runId),
    ];
    if (speciesId != null) {
      conditions.add(_database.talhaoLevantamentos.speciesId.equals(speciesId));
    }

    final query =
        _database.select(_database.talhaoLevantamentos).join([
            innerJoin(
              _database.stands,
              _database.stands.id.equalsExp(
                _database.talhaoLevantamentos.standId,
              ),
            ),
            innerJoin(
              _database.species,
              _database.species.id.equalsExp(
                _database.talhaoLevantamentos.speciesId,
              ),
            ),
          ])
          ..where(conditions.reduce((value, element) => value & element))
          ..orderBy([OrderingTerm.asc(_database.stands.identification)]);

    return _optionsFromRows(await query.get());
  }

  Future<List<DataExportStandOption>> _latestStandOptionsForProperty({
    required String? propertyId,
    String? speciesId,
  }) async {
    if (propertyId == null) return const [];

    final conditions = <Expression<bool>>[
      _database.stands.propertyId.equals(propertyId),
    ];
    if (speciesId != null) {
      conditions.add(_database.talhaoLevantamentos.speciesId.equals(speciesId));
    }

    final query =
        _database.select(_database.talhaoLevantamentos).join([
            innerJoin(
              _database.inventoryRuns,
              _database.inventoryRuns.id.equalsExp(
                _database.talhaoLevantamentos.inventoryRunId,
              ),
            ),
            innerJoin(
              _database.stands,
              _database.stands.id.equalsExp(
                _database.talhaoLevantamentos.standId,
              ),
            ),
            innerJoin(
              _database.species,
              _database.species.id.equalsExp(
                _database.talhaoLevantamentos.speciesId,
              ),
            ),
          ])
          ..where(conditions.reduce((value, element) => value & element))
          ..orderBy([
            OrderingTerm.asc(_database.stands.identification),
            OrderingTerm.desc(_database.talhaoLevantamentos.updatedAt),
          ]);

    final latestRowsByStandId = <String, TypedResult>{};
    for (final row in await query.get()) {
      final stand = row.readTable(_database.stands);
      latestRowsByStandId.putIfAbsent(stand.id, () => row);
    }

    return _optionsFromRows(latestRowsByStandId.values.toList());
  }

  Future<List<DataExportStandOption>> _optionsFromRows(
    List<TypedResult> rows,
  ) async {
    final options = <DataExportStandOption>[];

    for (final row in rows) {
      final talhao = row.readTable(_database.talhaoLevantamentos);
      options.add(
        DataExportStandOption(
          talhaoLevantamento: talhao,
          stand: row.readTable(_database.stands),
          species: row.readTable(_database.species),
          plotCount: await _countPlots(talhao.id),
          collectedPlotCount: await _countCollectedPlots(talhao.id),
          treeCount: await _countTrees(talhao.id),
          measuredAreaHa: await _sumMeasuredArea(talhao.id),
          geoPointCount: await _countGeoPoints(talhao.id),
        ),
      );
    }

    options.sort(
      (a, b) => a.stand.identification.compareTo(b.stand.identification),
    );
    return options;
  }

  Future<int> _countPlots(String talhaoLevantamentoId) async {
    final count = _database.plots.id.count();
    final row =
        await (_database.selectOnly(_database.plots)
              ..addColumns([count])
              ..where(
                _database.plots.talhaoLevantamentoId.equals(
                  talhaoLevantamentoId,
                ),
              ))
            .getSingle();

    return row.read(count) ?? 0;
  }

  Future<int> _countCollectedPlots(String talhaoLevantamentoId) async {
    final count = _database.plots.id.count();
    final row =
        await (_database.selectOnly(_database.plots)
              ..addColumns([count])
              ..where(
                _database.plots.talhaoLevantamentoId.equals(
                      talhaoLevantamentoId,
                    ) &
                    _database.plots.status.equalsValue(PlotStatus.collected),
              ))
            .getSingle();

    return row.read(count) ?? 0;
  }

  Future<int> _countTrees(String talhaoLevantamentoId) async {
    final count = _database.trees.id.count();
    final row =
        await (_database.selectOnly(_database.trees).join([
                innerJoin(
                  _database.plots,
                  _database.plots.id.equalsExp(_database.trees.plotId),
                ),
              ])
              ..addColumns([count])
              ..where(
                _database.plots.talhaoLevantamentoId.equals(
                  talhaoLevantamentoId,
                ),
              ))
            .getSingle();

    return row.read(count) ?? 0;
  }

  Future<double> _sumMeasuredArea(String talhaoLevantamentoId) async {
    final row = await _database
        .customSelect(
          '''
SELECT COALESCE(SUM(area_ha), 0.0) AS area
FROM plots
WHERE talhao_levantamento_id = ?
  AND status != ?
''',
          variables: [
            Variable<String>(talhaoLevantamentoId),
            Variable<String>(PlotStatus.pending.name),
          ],
        )
        .getSingle();

    return row.read<double>('area');
  }

  Future<int> _countGeoPoints(String talhaoLevantamentoId) async {
    final plotPointRows = await _database
        .customSelect(
          '''
SELECT COUNT(*) AS count
FROM plot_geo_points point
INNER JOIN plots plot ON plot.id = point.plot_id
WHERE plot.talhao_levantamento_id = ?
''',
          variables: [Variable<String>(talhaoLevantamentoId)],
        )
        .getSingle();
    final treePointRows = await _database
        .customSelect(
          '''
SELECT COUNT(*) AS count
FROM trees tree
INNER JOIN plots plot ON plot.id = tree.plot_id
WHERE plot.talhao_levantamento_id = ?
  AND tree.latitude IS NOT NULL
  AND tree.longitude IS NOT NULL
''',
          variables: [Variable<String>(talhaoLevantamentoId)],
        )
        .getSingle();

    return (plotPointRows.read<int>('count')) +
        (treePointRows.read<int>('count'));
  }

  Future<List<PlotRecord>> _plotsForTalhao(String talhaoLevantamentoId) {
    return (_database.select(_database.plots)
          ..where(
            (table) => table.talhaoLevantamentoId.equals(talhaoLevantamentoId),
          )
          ..orderBy([
            (table) => OrderingTerm.asc(table.identification),
            (table) => OrderingTerm.asc(table.createdAt),
          ]))
        .get();
  }

  Future<List<TreeRecord>> _treesForPlot(String plotId) {
    return (_database.select(_database.trees)
          ..where((table) => table.plotId.equals(plotId))
          ..orderBy([(table) => OrderingTerm.asc(table.number)]))
        .get();
  }

  Future<List<PlotGeoPointRecord>> _geoPointsForPlot(String plotId) {
    return (_database.select(_database.plotGeoPoints)
          ..where((table) => table.plotId.equals(plotId))
          ..orderBy([
            (table) => OrderingTerm.asc(table.pointOrder),
            (table) => OrderingTerm.asc(table.capturedAt),
          ]))
        .get();
  }
}

Future<List<int>> _pdfBytes(DataExportDataset dataset) async {
  final document = pw.Document();
  final generatedAt = DateTime.now();

  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(28),
      footer: (context) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'DENDRO Mobile - ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
      ),
      build: (context) => [
        pw.Text(
          'DENDRO Mobile',
          style: pw.TextStyle(
            color: PdfColors.green900,
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          'Relatório de Inventário Florestal',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        _pdfInfoGrid([
          ['Propriedade', dataset.property.name],
          [
            'Município',
            '${dataset.property.municipality}-${dataset.property.state}',
          ],
          ['Área cadastrada', '${_decimal(dataset.property.totalAreaHa)} ha'],
          ['Gerado em', _dateTime(generatedAt)],
          if (dataset.inventoryRun != null)
            ['Levantamento', _dateTime(dataset.inventoryRun!.startedAt)],
          if (dataset.inventoryRun != null)
            ['Status', _inventoryStatusLabel(dataset.inventoryRun!.status)],
        ]),
        pw.SizedBox(height: 14),
        _pdfSectionTitle('Resumo geral'),
        _pdfInfoGrid([
          ['Talhões', dataset.stands.length.toString()],
          ['Parcelas', dataset.plotCount.toString()],
          ['Parcelas coletadas', dataset.collectedPlotCount.toString()],
          ['Árvores medidas', dataset.treeCount.toString()],
          ['Área medida', '${_decimal(dataset.measuredAreaHa)} ha'],
          ['Árvores/ha', _nullableDecimal(dataset.treesPerHa)],
          [
            'Volume amostrado',
            '${_decimalPrecision(dataset.sampleVolumeM3, fractionDigits: 4)} m³',
          ],
          [
            'Volume/ha',
            _nullableDecimal(dataset.volumePerHaM3, suffix: ' m³/ha'),
          ],
          [
            'Volume estimado total',
            _nullableDecimal(dataset.estimatedVolumeM3, suffix: ' m³'),
          ],
          ['DAP médio', _nullableDecimal(dataset.averageDapCm, suffix: ' cm')],
          [
            'Altura média',
            _nullableDecimal(dataset.averageHeightM, suffix: ' m'),
          ],
        ]),
        pw.SizedBox(height: 14),
        _pdfSectionTitle('Talhões selecionados'),
        pw.TableHelper.fromTextArray(
          border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.green900),
          headerStyle: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
          ),
          cellStyle: const pw.TextStyle(fontSize: 8),
          cellAlignment: pw.Alignment.centerLeft,
          headers: [
            'Talhão',
            'Espécie',
            'Área (ha)',
            'Modelo',
            'Parcelas',
            'Árvores',
            'N/ha',
            'Vol./ha',
            'Vol. estimado',
            'Equiv.',
            'DAP médio',
            'Alt. média',
          ],
          data: [
            for (final stand in dataset.stands)
              [
                stand.option.stand.identification,
                stand.option.species.name,
                _decimal(stand.option.stand.areaHa),
                stand.formula?.name ?? 'Sem modelo',
                '${stand.option.collectedPlotCount}/${stand.option.plotCount}',
                stand.treeCount.toString(),
                _nullableDecimal(stand.treesPerHa),
                _nullableDecimal(stand.volumePerHaM3, suffix: ' m³/ha'),
                _nullableDecimal(stand.estimatedVolumeM3, suffix: ' m³'),
                _convertedStandVolumeLabel(stand),
                _nullableDecimal(stand.averageDapCm, suffix: ' cm'),
                _nullableDecimal(stand.averageHeightM, suffix: ' m'),
              ],
          ],
        ),
        pw.SizedBox(height: 16),
        for (final stand in dataset.stands) ...[
          _pdfSectionTitle('Parcelas - ${stand.option.stand.identification}'),
          if (stand.coefficients.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 6),
              child: pw.Text(
                'Coeficientes: ${stand.coefficients.map((item) => '${item.symbol}=${_nullableDecimal(item.value)}').join(' | ')}',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey700,
                ),
              ),
            ),
          if (stand.plots.isEmpty)
            pw.Text(
              'Nenhuma parcela cadastrada para este talhão.',
              style: const pw.TextStyle(fontSize: 9),
            )
          else
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              headerStyle: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.centerLeft,
              headers: [
                'Parcela',
                'Status',
                'Área (ha)',
                'Árvores',
                'Vol. amostral',
                'DAP médio',
                'Alt. média',
                'GPS',
              ],
              data: [
                for (final plot in stand.plots)
                  [
                    plot.plot.identification,
                    _plotStatusLabel(plot.plot.status),
                    _nullableDecimal(plot.plot.areaHa),
                    plot.trees.length.toString(),
                    _nullableDecimal(_plotVolumeM3(stand, plot), suffix: ' m³'),
                    _nullableDecimal(_averageDap(plot.trees), suffix: ' cm'),
                    _nullableDecimal(_averageHeight(plot.trees), suffix: ' m'),
                    plot.geoPoints.length.toString(),
                  ],
              ],
            ),
          pw.SizedBox(height: 12),
        ],
      ],
    ),
  );

  return document.save();
}

List<int> _csvBytes(DataExportDataset dataset) {
  final buffer = StringBuffer()
    ..writeln(
      _csvLine([
        'Propriedade',
        'Município',
        'UF',
        'Levantamento',
        'Status levantamento',
        'Talhão',
        'Espécie',
        'Área talhão (ha)',
        'Modelo',
        'Parcela',
        'Status parcela',
        'Área parcela (ha)',
        'Árvore',
        'DAP (cm)',
        'Altura (m)',
        'Volume árvore (m³)',
        'Volume/ha talhão (m³/ha)',
        'Volume estimado talhão (m³)',
        'Equivalente talhão',
        'Unidade equivalente',
        'Tronco torto',
        'Latitude árvore',
        'Longitude árvore',
        'Precisão árvore (m)',
        'Ponto referência',
        'Latitude parcela',
        'Longitude parcela',
        'Precisão parcela (m)',
      ]),
    );

  for (final stand in dataset.stands) {
    for (final plot in stand.plots) {
      final firstPoint = plot.geoPoints.isEmpty ? null : plot.geoPoints.first;
      if (plot.trees.isEmpty) {
        buffer.writeln(
          _csvLine([
            dataset.property.name,
            dataset.property.municipality,
            dataset.property.state,
            dataset.inventoryRun == null
                ? ''
                : _dateTime(dataset.inventoryRun!.startedAt),
            dataset.inventoryRun == null
                ? ''
                : _inventoryStatusLabel(dataset.inventoryRun!.status),
            stand.option.stand.identification,
            stand.option.species.name,
            _decimal(stand.option.stand.areaHa),
            stand.formula?.name ?? '',
            plot.plot.identification,
            _plotStatusLabel(plot.plot.status),
            _nullableDecimal(plot.plot.areaHa),
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            _referenceLabel(firstPoint?.referencePosition),
            _nullableCoordinate(firstPoint?.latitude),
            _nullableCoordinate(firstPoint?.longitude),
            _nullableDecimal(firstPoint?.accuracyMeters),
          ]),
        );
        continue;
      }

      for (final tree in plot.trees) {
        final plotPoint = _matchingPlotPoint(plot, tree) ?? firstPoint;

        buffer.writeln(
          _csvLine([
            dataset.property.name,
            dataset.property.municipality,
            dataset.property.state,
            dataset.inventoryRun == null
                ? ''
                : _dateTime(dataset.inventoryRun!.startedAt),
            dataset.inventoryRun == null
                ? ''
                : _inventoryStatusLabel(dataset.inventoryRun!.status),
            stand.option.stand.identification,
            stand.option.species.name,
            _decimal(stand.option.stand.areaHa),
            stand.formula?.name ?? '',
            plot.plot.identification,
            _plotStatusLabel(plot.plot.status),
            _nullableDecimal(plot.plot.areaHa),
            'Árvore ${tree.number}',
            _decimal(tree.dapCm),
            _decimal(tree.heightM),
            _decimalPrecision(stand.treeVolumeM3(tree), fractionDigits: 5),
            _nullableDecimal(stand.volumePerHaM3),
            _nullableDecimal(stand.estimatedVolumeM3),
            _nullableDecimal(stand.convertedEstimatedVolume),
            stand.conversion.unit,
            tree.hasTortuousStem ? 'Sim' : 'Não',
            _nullableCoordinate(tree.latitude),
            _nullableCoordinate(tree.longitude),
            _nullableDecimal(tree.accuracyMeters),
            _referenceLabel(tree.plotReferencePosition),
            _nullableCoordinate(plotPoint?.latitude),
            _nullableCoordinate(plotPoint?.longitude),
            _nullableDecimal(plotPoint?.accuracyMeters),
          ]),
        );
      }
    }
  }

  return utf8.encode('\uFEFF${buffer.toString()}');
}

List<int> _xlsxBytes(DataExportDataset dataset) {
  final workbook = excel.Excel.createExcel();
  final summary = workbook['Resumo'];
  final trees = workbook['Árvores'];
  final coordinates = workbook['Coordenadas'];

  if (workbook.sheets.containsKey('Sheet1')) {
    workbook.delete('Sheet1');
  }

  summary
    ..appendRow(_excelRow(['DENDRO Mobile - Relatório de Inventário']))
    ..appendRow(_excelRow([]))
    ..appendRow(_excelRow(['Propriedade', dataset.property.name]))
    ..appendRow(
      _excelRow([
        'Município',
        '${dataset.property.municipality}-${dataset.property.state}',
      ]),
    )
    ..appendRow(
      _excelRow(['Área cadastrada (ha)', dataset.property.totalAreaHa]),
    )
    ..appendRow(_excelRow(['Gerado em', _dateTime(DateTime.now())]))
    ..appendRow(_excelRow([]))
    ..appendRow(
      _excelRow([
        'Talhão',
        'Espécie',
        'Área talhão (ha)',
        'Modelo',
        'Coeficientes',
        'Parcelas',
        'Parcelas coletadas',
        'Árvores',
        'Área medida (ha)',
        'Árvores/ha',
        'Volume amostrado (m³)',
        'Volume/ha (m³/ha)',
        'Volume estimado (m³)',
        'Equivalente',
        'Unidade equivalente',
        'DAP médio (cm)',
        'Altura média (m)',
      ]),
    );

  for (final stand in dataset.stands) {
    summary.appendRow(
      _excelRow([
        stand.option.stand.identification,
        stand.option.species.name,
        stand.option.stand.areaHa,
        stand.formula?.name ?? '',
        stand.coefficients
            .map((coefficient) {
              return '${coefficient.symbol}=${_nullableDecimal(coefficient.value)}';
            })
            .join(' | '),
        stand.option.plotCount,
        stand.option.collectedPlotCount,
        stand.treeCount,
        stand.measuredAreaHa,
        stand.treesPerHa,
        stand.sampleVolumeM3,
        stand.volumePerHaM3,
        stand.estimatedVolumeM3,
        stand.convertedEstimatedVolume,
        stand.conversion.unit,
        stand.averageDapCm,
        stand.averageHeightM,
      ]),
    );
  }

  trees.appendRow(
    _excelRow([
      'Propriedade',
      'Talhão',
      'Espécie',
      'Parcela',
      'Status parcela',
      'Árvore',
      'DAP (cm)',
      'Altura (m)',
      'Volume (m³)',
      'Tronco torto',
      'Latitude',
      'Longitude',
      'Precisão GPS (m)',
      'Ponto referência',
    ]),
  );

  coordinates.appendRow(
    _excelRow([
      'Propriedade',
      'Talhão',
      'Parcela',
      'Origem',
      'Ponto',
      'Latitude',
      'Longitude',
      'Precisão GPS (m)',
      'Capturado em',
    ]),
  );

  for (final stand in dataset.stands) {
    for (final plot in stand.plots) {
      for (final tree in plot.trees) {
        trees.appendRow(
          _excelRow([
            dataset.property.name,
            stand.option.stand.identification,
            stand.option.species.name,
            plot.plot.identification,
            _plotStatusLabel(plot.plot.status),
            tree.number,
            tree.dapCm,
            tree.heightM,
            stand.treeVolumeM3(tree),
            tree.hasTortuousStem ? 'Sim' : 'Não',
            tree.latitude,
            tree.longitude,
            tree.accuracyMeters,
            _referenceLabel(tree.plotReferencePosition),
          ]),
        );

        if (tree.latitude != null && tree.longitude != null) {
          coordinates.appendRow(
            _excelRow([
              dataset.property.name,
              stand.option.stand.identification,
              plot.plot.identification,
              'Árvore',
              _referenceLabel(tree.plotReferencePosition),
              tree.latitude,
              tree.longitude,
              tree.accuracyMeters,
              tree.locationCapturedAt == null
                  ? ''
                  : _dateTime(tree.locationCapturedAt!),
            ]),
          );
        }
      }

      for (final point in plot.geoPoints) {
        coordinates.appendRow(
          _excelRow([
            dataset.property.name,
            stand.option.stand.identification,
            plot.plot.identification,
            'Parcela',
            _referenceLabel(point.referencePosition).isEmpty
                ? 'P${point.pointOrder}'
                : _referenceLabel(point.referencePosition),
            point.latitude,
            point.longitude,
            point.accuracyMeters,
            _dateTime(point.capturedAt),
          ]),
        );
      }
    }
  }

  final bytes = workbook.save();
  if (bytes == null) {
    throw StateError('Não foi possível gerar a planilha.');
  }
  return bytes;
}

List<int> _kmlBytes(DataExportDataset dataset) {
  final buffer = StringBuffer()
    ..writeln('<?xml version="1.0" encoding="UTF-8"?>')
    ..writeln('<kml xmlns="http://www.opengis.net/kml/2.2">')
    ..writeln('<Document>')
    ..writeln('<name>${_xml('DENDRO - ${dataset.property.name}')}</name>')
    ..writeln('''
<Style id="plotPoint">
  <IconStyle><color>ff6ac46a</color><scale>1.1</scale></IconStyle>
</Style>
<Style id="treePoint">
  <IconStyle><color>ff1b5e20</color><scale>0.9</scale></IconStyle>
</Style>
<Style id="plotPolygon">
  <LineStyle><color>ff0b4d2a</color><width>2</width></LineStyle>
  <PolyStyle><color>336ac46a</color></PolyStyle>
</Style>
''');

  var hasCoordinates = false;
  for (final stand in dataset.stands) {
    for (final plot in stand.plots) {
      final orderedPoints = [...plot.geoPoints]
        ..sort((a, b) => a.pointOrder.compareTo(b.pointOrder));

      if (orderedPoints.length >= 3) {
        hasCoordinates = true;
        final coordinates = [
          for (final point in orderedPoints) _kmlCoordinate(point),
          _kmlCoordinate(orderedPoints.first),
        ].join(' ');
        buffer.writeln('''
<Placemark>
  <name>${_xml('${stand.option.stand.identification} - ${plot.plot.identification}')}</name>
  <styleUrl>#plotPolygon</styleUrl>
  <description>${_xml('Parcela com ${plot.trees.length} árvores medidas')}</description>
  <Polygon>
    <outerBoundaryIs>
      <LinearRing>
        <coordinates>$coordinates</coordinates>
      </LinearRing>
    </outerBoundaryIs>
  </Polygon>
</Placemark>
''');
      }

      for (final point in orderedPoints) {
        hasCoordinates = true;
        final pointLabel = _referenceLabel(point.referencePosition).isEmpty
            ? 'P${point.pointOrder}'
            : _referenceLabel(point.referencePosition);
        buffer.writeln('''
<Placemark>
  <name>${_xml('${stand.option.stand.identification} - ${plot.plot.identification} - $pointLabel')}</name>
  <styleUrl>#plotPoint</styleUrl>
  <description>${_xml('Ponto de referência da parcela')}</description>
  <Point><coordinates>${_kmlCoordinate(point)}</coordinates></Point>
</Placemark>
''');
      }

      for (final tree in plot.trees) {
        if (tree.latitude == null || tree.longitude == null) continue;
        hasCoordinates = true;
        buffer.writeln('''
<Placemark>
  <name>${_xml('${stand.option.stand.identification} - ${plot.plot.identification} - Árvore ${tree.number}')}</name>
  <styleUrl>#treePoint</styleUrl>
  <description>${_xml('DAP ${_decimal(tree.dapCm)} cm | Altura ${_decimal(tree.heightM)} m | Volume ${_decimalPrecision(stand.treeVolumeM3(tree), fractionDigits: 5)} m³ | ${tree.hasTortuousStem ? 'Tronco torto' : 'Tronco normal'}')}</description>
  <Point><coordinates>${_coordinateValue(tree.longitude!)},${_coordinateValue(tree.latitude!)},0</coordinates></Point>
</Placemark>
''');
      }
    }
  }

  if (!hasCoordinates) {
    buffer.writeln(
      '<description>${_xml('Nenhuma coordenada GPS foi registrada para os talhões selecionados.')}</description>',
    );
  }

  buffer
    ..writeln('</Document>')
    ..writeln('</kml>');

  return utf8.encode(buffer.toString());
}

pw.Widget _pdfSectionTitle(String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Text(
      value,
      style: pw.TextStyle(
        color: PdfColors.green900,
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );
}

pw.Widget _pdfInfoGrid(List<List<String>> rows) {
  return pw.TableHelper.fromTextArray(
    border: null,
    cellPadding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 0),
    cellStyle: const pw.TextStyle(fontSize: 9),
    cellAlignment: pw.Alignment.centerLeft,
    columnWidths: {
      0: const pw.FixedColumnWidth(95),
      1: const pw.FlexColumnWidth(),
    },
    data: [
      for (final row in rows) [row[0], row[1]],
    ],
  );
}

List<excel.CellValue?> _excelRow(List<Object?> values) {
  return [
    for (final value in values)
      if (value == null)
        null
      else if (value is int)
        excel.IntCellValue(value)
      else if (value is double)
        excel.DoubleCellValue(value)
      else if (value is bool)
        excel.BoolCellValue(value)
      else
        excel.TextCellValue(value.toString()),
  ];
}

String _csvLine(List<Object?> values) {
  return values.map(_csvValue).join(';');
}

String _csvValue(Object? value) {
  final text = value?.toString() ?? '';
  final mustQuote =
      text.contains(';') || text.contains('"') || text.contains('\n');
  final escaped = text.replaceAll('"', '""');
  return mustQuote ? '"$escaped"' : escaped;
}

PlotGeoPointRecord? _matchingPlotPoint(
  DataExportPlotDataset plot,
  TreeRecord tree,
) {
  if (tree.plotReferencePosition == null) return null;
  for (final point in plot.geoPoints) {
    if (point.referencePosition == tree.plotReferencePosition) return point;
  }
  return null;
}

String _kmlCoordinate(PlotGeoPointRecord point) {
  return '${_coordinateValue(point.longitude)},${_coordinateValue(point.latitude)},0';
}

String _xml(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');
}

String _fileName(PropertyRecord property, DataExportFormat format) {
  final generatedAt = DateTime.now();
  final name = _safeFilePart(property.name);
  return 'dendro_${name}_${_fileStamp(generatedAt)}.${format.extension}';
}

String _safeFilePart(String value) {
  final normalized = value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  return normalized.isEmpty ? 'relatorio' : normalized;
}

String _fileStamp(DateTime value) {
  final year = value.year.toString();
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$year$month${day}_$hour$minute';
}

String _dateTime(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final year = value.year.toString();
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$day/$month/$year $hour:$minute';
}

String _decimal(double value) {
  return _decimalPrecision(value);
}

String _decimalPrecision(double value, {int fractionDigits = 2}) {
  return value.toStringAsFixed(fractionDigits).replaceAll('.', ',');
}

String _nullableDecimal(double? value, {String suffix = ''}) {
  if (value == null) return '';
  return '${_decimal(value)}$suffix';
}

String _coordinateValue(double value) {
  return value.toStringAsFixed(8);
}

String _nullableCoordinate(double? value) {
  if (value == null) return '';
  return _coordinateValue(value);
}

double? _averageDap(List<TreeRecord> trees) {
  if (trees.isEmpty) return null;
  return trees.fold<double>(0, (total, tree) => total + tree.dapCm) /
      trees.length;
}

double? _averageHeight(List<TreeRecord> trees) {
  if (trees.isEmpty) return null;
  return trees.fold<double>(0, (total, tree) => total + tree.heightM) /
      trees.length;
}

double? _plotVolumeM3(
  DataExportStandDataset stand,
  DataExportPlotDataset plot,
) {
  if (plot.trees.isEmpty) return null;
  return plot.trees.fold<double>(
    0,
    (total, tree) => total + stand.treeVolumeM3(tree),
  );
}

String _convertedStandVolumeLabel(DataExportStandDataset stand) {
  if (stand.conversion.unit == 'm3') return '';
  final value = stand.convertedEstimatedVolume;
  if (value == null) return '';
  return '${_decimal(value)} ${stand.conversion.unit}';
}

String _inventoryStatusLabel(InventoryRunStatus status) {
  return switch (status) {
    InventoryRunStatus.planning => 'Planejamento',
    InventoryRunStatus.inProgress => 'Em andamento',
    InventoryRunStatus.completed => 'Finalizado',
  };
}

String _plotStatusLabel(PlotStatus status) {
  return switch (status) {
    PlotStatus.pending => 'Pendente',
    PlotStatus.inProgress => 'Em coleta',
    PlotStatus.collected => 'Coletada',
  };
}

String _referenceLabel(PlotReferencePosition? position) {
  return switch (position) {
    PlotReferencePosition.p1 => 'P1',
    PlotReferencePosition.p2 => 'P2',
    PlotReferencePosition.p3 => 'P3',
    PlotReferencePosition.p4 => 'P4',
    null => '',
  };
}
