import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/dendro_database.dart';
import '../../../core/forest/forest_volume_calculator.dart';
import '../../../core/providers/database_providers.dart';

final resultsRepositoryProvider = Provider<ResultsRepository>((ref) {
  return ResultsRepository(ref.watch(dendroDatabaseProvider));
});

final resultsPropertyFilterProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

final resultsStandFilterProvider = StateProvider.autoDispose<Set<String>>((
  ref,
) {
  return <String>{};
});

final resultsSpeciesFilterProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

final resultsFilterOptionsProvider =
    StreamProvider.autoDispose<ResultsFilterOptions>((ref) {
      return ref.watch(resultsRepositoryProvider).watchFilterOptions();
    });

final resultsDashboardProvider = StreamProvider.autoDispose<ResultsDashboard>((
  ref,
) {
  final filters = ResultsFilters(
    propertyId: ref.watch(resultsPropertyFilterProvider),
    standIds: ref.watch(resultsStandFilterProvider),
    speciesId: ref.watch(resultsSpeciesFilterProvider),
  );

  return ref.watch(resultsRepositoryProvider).watchDashboard(filters);
});

class ResultsFilters {
  const ResultsFilters({
    required this.propertyId,
    required this.standIds,
    required this.speciesId,
  });

  final String? propertyId;
  final Set<String> standIds;
  final String? speciesId;
}

class ResultsFilterOptions {
  const ResultsFilterOptions({
    required this.properties,
    required this.stands,
    required this.species,
  });

  final List<PropertyRecord> properties;
  final List<ResultsStandOption> stands;
  final List<SpeciesRecord> species;

  List<ResultsStandOption> visibleStands({
    String? propertyId,
    String? speciesId,
  }) {
    return stands.where((option) {
      if (propertyId != null && option.stand.propertyId != propertyId) {
        return false;
      }
      if (speciesId != null && option.species.id != speciesId) {
        return false;
      }
      return true;
    }).toList();
  }
}

class ResultsStandOption {
  const ResultsStandOption({required this.stand, required this.species});

  final StandRecord stand;
  final SpeciesRecord species;
}

class ResultsDashboard {
  const ResultsDashboard({
    required this.plotCount,
    required this.collectedPlotCount,
    required this.measuredPlotCount,
    required this.treeCount,
    required this.measuredAreaHa,
    required this.averageDapCm,
    required this.averageHeightM,
    required this.sampleVolumeM3,
    required this.volumePerHaM3,
    required this.estimatedVolumeM3,
    required this.treesPerHa,
    required this.diameterClasses,
    required this.stands,
  });

  final int plotCount;
  final int collectedPlotCount;
  final int measuredPlotCount;
  final int treeCount;
  final double measuredAreaHa;
  final double? averageDapCm;
  final double? averageHeightM;
  final double sampleVolumeM3;
  final double? volumePerHaM3;
  final double? estimatedVolumeM3;
  final double? treesPerHa;
  final List<DiameterClassSummary> diameterClasses;
  final List<ResultsStandSummary> stands;

  bool get hasMeasurements => treeCount > 0;
}

class DiameterClassSummary {
  const DiameterClassSummary({
    required this.startCm,
    required this.endCm,
    required this.count,
  });

  final int startCm;
  final int endCm;
  final int count;

  String get label => '$startCm-$endCm';
}

class ResultsStandSummary {
  const ResultsStandSummary({
    required this.stand,
    required this.species,
    required this.plotCount,
    required this.collectedPlotCount,
    required this.measuredPlotCount,
    required this.treeCount,
    required this.measuredAreaHa,
    required this.averageDapCm,
    required this.averageHeightM,
    required this.sampleVolumeM3,
    required this.volumePerHaM3,
    required this.estimatedVolumeM3,
    required this.convertedEstimatedVolume,
    required this.convertedVolumePerHa,
    required this.convertedUnit,
    required this.treesPerHa,
  });

  final StandRecord stand;
  final SpeciesRecord species;
  final int plotCount;
  final int collectedPlotCount;
  final int measuredPlotCount;
  final int treeCount;
  final double measuredAreaHa;
  final double? averageDapCm;
  final double? averageHeightM;
  final double sampleVolumeM3;
  final double? volumePerHaM3;
  final double? estimatedVolumeM3;
  final double? convertedEstimatedVolume;
  final double? convertedVolumePerHa;
  final String convertedUnit;
  final double? treesPerHa;
}

class ResultsRepository {
  ResultsRepository(this._database);

  final DendroDatabase _database;

  Stream<ResultsFilterOptions> watchFilterOptions() {
    final query =
        _database.select(_database.properties).join([
          leftOuterJoin(
            _database.stands,
            _database.stands.propertyId.equalsExp(_database.properties.id),
          ),
          leftOuterJoin(
            _database.species,
            _database.species.id.equalsExp(_database.stands.speciesId),
          ),
        ])..orderBy([
          OrderingTerm.asc(_database.properties.name),
          OrderingTerm.asc(_database.stands.identification),
        ]);

    return query.watch().map((rows) {
      final propertiesById = <String, PropertyRecord>{};
      final standsById = <String, ResultsStandOption>{};
      final speciesById = <String, SpeciesRecord>{};

      for (final row in rows) {
        final property = row.readTable(_database.properties);
        propertiesById[property.id] = property;

        final stand = row.readTableOrNull(_database.stands);
        final species = row.readTableOrNull(_database.species);
        if (stand == null || species == null) continue;

        standsById[stand.id] = ResultsStandOption(
          stand: stand,
          species: species,
        );
        speciesById[species.id] = species;
      }

      final properties = propertiesById.values.toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      final stands = standsById.values.toList()
        ..sort(
          (a, b) => a.stand.identification.compareTo(b.stand.identification),
        );
      final species = speciesById.values.toList()
        ..sort((a, b) => a.name.compareTo(b.name));

      return ResultsFilterOptions(
        properties: properties,
        stands: stands,
        species: species,
      );
    });
  }

  Stream<ResultsDashboard> watchDashboard(ResultsFilters filters) {
    final query =
        _database.select(_database.plots).join([
          innerJoin(
            _database.talhaoLevantamentos,
            _database.talhaoLevantamentos.id.equalsExp(
              _database.plots.talhaoLevantamentoId,
            ),
          ),
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
            _database.properties,
            _database.properties.id.equalsExp(_database.stands.propertyId),
          ),
          innerJoin(
            _database.species,
            _database.species.id.equalsExp(
              _database.talhaoLevantamentos.speciesId,
            ),
          ),
          innerJoin(
            _database.formulas,
            _database.formulas.id.equalsExp(
              _database.talhaoLevantamentos.formulaId,
            ),
          ),
          leftOuterJoin(
            _database.trees,
            _database.trees.plotId.equalsExp(_database.plots.id),
          ),
        ])..orderBy([
          OrderingTerm.asc(_database.properties.name),
          OrderingTerm.asc(_database.stands.identification),
          OrderingTerm.asc(_database.plots.identification),
          OrderingTerm.asc(_database.trees.number),
        ]);

    final conditions = <Expression<bool>>[];
    if (filters.propertyId != null) {
      conditions.add(_database.properties.id.equals(filters.propertyId!));
    }
    if (filters.standIds.isNotEmpty) {
      conditions.add(_database.stands.id.isIn(filters.standIds));
    }
    if (filters.speciesId != null) {
      conditions.add(
        _database.talhaoLevantamentos.speciesId.equals(filters.speciesId!),
      );
    }
    if (conditions.isNotEmpty) {
      query.where(conditions.reduce((value, element) => value & element));
    }

    return query.watch().asyncMap(_dashboardFromRows);
  }

  Future<ResultsDashboard> _dashboardFromRows(List<TypedResult> rows) async {
    final seenPlots = <String>{};
    final seenTrees = <String>{};
    final diameterBuckets = <int, int>{};
    final standsById = <String, _StandResultsAccumulator>{};
    final coefficientCache = <String, Map<String, double?>>{};

    var plotCount = 0;
    var collectedPlotCount = 0;
    var measuredPlotCount = 0;
    var treeCount = 0;
    var measuredAreaHa = 0.0;
    var dapSum = 0.0;
    var heightSum = 0.0;
    var sampleVolumeM3 = 0.0;

    for (final row in rows) {
      final plot = row.readTable(_database.plots);
      final talhao = row.readTable(_database.talhaoLevantamentos);
      final stand = row.readTable(_database.stands);
      final species = row.readTable(_database.species);
      final formula = row.readTable(_database.formulas);
      final tree = row.readTableOrNull(_database.trees);

      final standAccumulator = standsById.putIfAbsent(
        talhao.id,
        () => _StandResultsAccumulator(
          talhao: talhao,
          stand: stand,
          species: species,
          formula: formula,
        ),
      );

      if (seenPlots.add(plot.id)) {
        plotCount++;
        standAccumulator.addPlot(plot);

        if (plot.status == PlotStatus.collected) {
          collectedPlotCount++;
        }
        if (plot.status != PlotStatus.pending) {
          measuredPlotCount++;
          measuredAreaHa += plot.areaHa ?? 0;
        }
      }

      if (tree == null || !seenTrees.add(tree.id)) continue;

      treeCount++;
      dapSum += tree.dapCm;
      heightSum += tree.heightM;
      final coefficients = coefficientCache.putIfAbsent(
        talhao.id,
        () => const <String, double?>{},
      );
      if (coefficients.isEmpty) {
        coefficientCache[talhao.id] = await _coefficientsForTalhao(
          talhaoLevantamentoId: talhao.id,
          speciesId: talhao.speciesId,
          formulaId: talhao.formulaId,
        );
      }
      final treeVolumeM3 = ForestVolumeCalculator.treeVolumeM3(
        dapCm: tree.dapCm,
        heightM: tree.heightM,
        coefficients: coefficientCache[talhao.id]!,
        formulaId: formula.id,
        formulaExpression: formula.expression,
      );
      sampleVolumeM3 += treeVolumeM3;
      standAccumulator.addTree(tree, treeVolumeM3);

      final bucketStart = (tree.dapCm ~/ 5) * 5;
      diameterBuckets[bucketStart] = (diameterBuckets[bucketStart] ?? 0) + 1;
    }

    final diameterClasses = [
      for (final entry
          in diameterBuckets.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key)))
        DiameterClassSummary(
          startCm: entry.key,
          endCm: entry.key + 4,
          count: entry.value,
        ),
    ];

    final stands = standsById.values.map((item) => item.toSummary()).toList()
      ..sort(
        (a, b) => a.stand.identification.compareTo(b.stand.identification),
      );
    final estimatedVolumeM3 = stands.fold<double>(
      0,
      (total, stand) => total + (stand.estimatedVolumeM3 ?? 0),
    );

    return ResultsDashboard(
      plotCount: plotCount,
      collectedPlotCount: collectedPlotCount,
      measuredPlotCount: measuredPlotCount,
      treeCount: treeCount,
      measuredAreaHa: measuredAreaHa,
      averageDapCm: treeCount == 0 ? null : dapSum / treeCount,
      averageHeightM: treeCount == 0 ? null : heightSum / treeCount,
      sampleVolumeM3: sampleVolumeM3,
      volumePerHaM3: measuredAreaHa == 0
          ? null
          : sampleVolumeM3 / measuredAreaHa,
      estimatedVolumeM3: measuredAreaHa == 0 ? null : estimatedVolumeM3,
      treesPerHa: measuredAreaHa == 0 ? null : treeCount / measuredAreaHa,
      diameterClasses: diameterClasses,
      stands: stands,
    );
  }

  Future<Map<String, double?>> _coefficientsForTalhao({
    required String talhaoLevantamentoId,
    required String speciesId,
    required String formulaId,
  }) async {
    final rows = await _database
        .customSelect(
          '''
SELECT symbol, value
FROM talhao_formula_coefficients
WHERE talhao_levantamento_id = ?
''',
          variables: [Variable<String>(talhaoLevantamentoId)],
          readsFrom: {_database.talhaoLevantamentos},
        )
        .get();

    final values = {
      for (final row in rows)
        row.read<String>('symbol'): row.readNullable<double>('value'),
    };
    if (values.isNotEmpty) return values;

    final globalRows = await (_database.select(
      _database.formulaCoefficients,
    )..where((table) => table.formulaId.equals(formulaId))).get();
    final speciesRows =
        await (_database.select(_database.speciesFormulaCoefficients)..where(
              (table) =>
                  table.speciesId.equals(speciesId) &
                  table.formulaId.equals(formulaId),
            ))
            .get();
    final speciesValues = {
      for (final coefficient in speciesRows)
        coefficient.symbol: coefficient.value,
    };
    return {
      for (final coefficient in globalRows)
        coefficient.symbol:
            speciesValues[coefficient.symbol] ??
            coefficient.value ??
            ForestVolumeCalculator.defaultCoefficientValue(
              formulaId: formulaId,
              symbol: coefficient.symbol,
            ),
    };
  }
}

class _StandResultsAccumulator {
  _StandResultsAccumulator({
    required this.talhao,
    required this.stand,
    required this.species,
    required this.formula,
  });

  final TalhaoLevantamentoRecord talhao;
  final StandRecord stand;
  final SpeciesRecord species;
  final FormulaRecord formula;
  int plotCount = 0;
  int collectedPlotCount = 0;
  int measuredPlotCount = 0;
  int treeCount = 0;
  double measuredAreaHa = 0;
  double dapSum = 0;
  double heightSum = 0;
  double sampleVolumeM3 = 0;

  void addPlot(PlotRecord plot) {
    plotCount++;
    if (plot.status == PlotStatus.collected) {
      collectedPlotCount++;
    }
    if (plot.status != PlotStatus.pending) {
      measuredPlotCount++;
      measuredAreaHa += plot.areaHa ?? 0;
    }
  }

  void addTree(TreeRecord tree, double volumeM3) {
    treeCount++;
    dapSum += tree.dapCm;
    heightSum += tree.heightM;
    sampleVolumeM3 += volumeM3;
  }

  ResultsStandSummary toSummary() {
    final volumePerHaM3 = measuredAreaHa == 0
        ? null
        : sampleVolumeM3 / measuredAreaHa;
    final estimatedVolumeM3 = volumePerHaM3 == null
        ? null
        : volumePerHaM3 * stand.areaHa;
    final conversion = ForestVolumeCalculator.conversionForSpecies(
      species.name,
    );
    return ResultsStandSummary(
      stand: stand,
      species: species,
      plotCount: plotCount,
      collectedPlotCount: collectedPlotCount,
      measuredPlotCount: measuredPlotCount,
      treeCount: treeCount,
      measuredAreaHa: measuredAreaHa,
      averageDapCm: treeCount == 0 ? null : dapSum / treeCount,
      averageHeightM: treeCount == 0 ? null : heightSum / treeCount,
      sampleVolumeM3: sampleVolumeM3,
      volumePerHaM3: volumePerHaM3,
      estimatedVolumeM3: estimatedVolumeM3,
      convertedEstimatedVolume: estimatedVolumeM3 == null
          ? null
          : conversion.convert(estimatedVolumeM3),
      convertedVolumePerHa: volumePerHaM3 == null
          ? null
          : conversion.convert(volumePerHaM3),
      convertedUnit: conversion.unit,
      treesPerHa: measuredAreaHa == 0 ? null : treeCount / measuredAreaHa,
    );
  }
}
