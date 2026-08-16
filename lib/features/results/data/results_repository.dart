import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/dendro_database.dart';
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

    return query.watch().map(_dashboardFromRows);
  }

  ResultsDashboard _dashboardFromRows(List<TypedResult> rows) {
    final seenPlots = <String>{};
    final seenTrees = <String>{};
    final diameterBuckets = <int, int>{};
    final standsById = <String, _StandResultsAccumulator>{};

    var plotCount = 0;
    var collectedPlotCount = 0;
    var measuredPlotCount = 0;
    var treeCount = 0;
    var measuredAreaHa = 0.0;
    var dapSum = 0.0;
    var heightSum = 0.0;

    for (final row in rows) {
      final plot = row.readTable(_database.plots);
      final stand = row.readTable(_database.stands);
      final species = row.readTable(_database.species);
      final tree = row.readTableOrNull(_database.trees);

      final standAccumulator = standsById.putIfAbsent(
        stand.id,
        () => _StandResultsAccumulator(stand: stand, species: species),
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
      standAccumulator.addTree(tree);

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

    return ResultsDashboard(
      plotCount: plotCount,
      collectedPlotCount: collectedPlotCount,
      measuredPlotCount: measuredPlotCount,
      treeCount: treeCount,
      measuredAreaHa: measuredAreaHa,
      averageDapCm: treeCount == 0 ? null : dapSum / treeCount,
      averageHeightM: treeCount == 0 ? null : heightSum / treeCount,
      diameterClasses: diameterClasses,
      stands: stands,
    );
  }
}

class _StandResultsAccumulator {
  _StandResultsAccumulator({required this.stand, required this.species});

  final StandRecord stand;
  final SpeciesRecord species;
  int plotCount = 0;
  int collectedPlotCount = 0;
  int measuredPlotCount = 0;
  int treeCount = 0;
  double measuredAreaHa = 0;
  double dapSum = 0;
  double heightSum = 0;

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

  void addTree(TreeRecord tree) {
    treeCount++;
    dapSum += tree.dapCm;
    heightSum += tree.heightM;
  }

  ResultsStandSummary toSummary() {
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
    );
  }
}
