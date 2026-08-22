import 'dart:async';

import 'package:dendro_mobile/app/theme/dendro_theme.dart';
import 'package:dendro_mobile/core/database/dendro_database.dart';
import 'package:dendro_mobile/features/properties/data/properties_repository.dart';
import 'package:dendro_mobile/features/properties/presentation/properties_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('cadastra propriedade pela tela', (tester) async {
    final repository = _FakePropertiesRepository();
    addTearDown(repository.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [propertiesRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          theme: DendroTheme.light,
          home: const Scaffold(body: PropertiesScreen()),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Nenhuma propriedade cadastrada'), findsOneWidget);

    await tester.tap(find.text('Cadastrar propriedade'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nome da propriedade'),
      'Fazenda Esperança',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Município'),
      'Vacaria',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Área total (ha)'),
      '158,17',
    );

    await tester.tap(find.text('Cadastrar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Fazenda Esperança'), findsOneWidget);
    expect(find.text('Vacaria-RS'), findsOneWidget);
    expect(find.text('158,17 ha'), findsOneWidget);
  });
}

class _FakePropertiesRepository implements PropertiesRepository {
  final _changes = StreamController<void>.broadcast();
  final _properties = <PropertyRecord>[];
  int _nextId = 1;

  Future<void> close() => _changes.close();

  @override
  Stream<List<PropertySummary>> watchSummaries({
    String searchQuery = '',
    PropertyAdvancedFilters filters = const PropertyAdvancedFilters(),
  }) async* {
    yield _summaries(searchQuery, filters);
    yield* _changes.stream.map((_) => _summaries(searchQuery, filters));
  }

  @override
  Future<List<PropertyRecord>> searchByName(String query) async {
    return _filtered(query);
  }

  @override
  Future<PropertyRecord?> findById(String id) async {
    return _properties.where((property) => property.id == id).firstOrNull;
  }

  @override
  Future<String> create({
    required String name,
    required String municipality,
    String state = 'RS',
    required double totalAreaHa,
  }) async {
    final now = DateTime(2026, 8, 9);
    final id = 'property_${_nextId++}';

    _properties.add(
      PropertyRecord(
        id: id,
        name: name.trim(),
        municipality: municipality.trim(),
        state: state.trim(),
        totalAreaHa: totalAreaHa,
        createdAt: now,
        updatedAt: now,
      ),
    );
    _changes.add(null);

    return id;
  }

  @override
  Future<void> update({
    required String id,
    required String name,
    required String municipality,
    required String state,
    required double totalAreaHa,
  }) async {
    final index = _properties.indexWhere((property) => property.id == id);
    if (index == -1) return;

    final current = _properties[index];
    _properties[index] = PropertyRecord(
      id: current.id,
      name: name.trim(),
      municipality: municipality.trim(),
      state: state.trim(),
      totalAreaHa: totalAreaHa,
      createdAt: current.createdAt,
      updatedAt: DateTime(2026, 8, 9),
    );
    _changes.add(null);
  }

  @override
  Future<void> delete(String id) async {
    _properties.removeWhere((property) => property.id == id);
    _changes.add(null);
  }

  @override
  Future<PropertySummary?> getSummary(String id) async {
    final property = await findById(id);
    if (property == null) return null;

    return PropertySummary(
      property: property,
      standCount: 0,
      inventoryRunCount: 0,
    );
  }

  List<PropertySummary> _summaries(
    String query,
    PropertyAdvancedFilters filters,
  ) {
    return _filtered(query, filters)
        .map(
          (property) => PropertySummary(
            property: property,
            standCount: 0,
            inventoryRunCount: 0,
          ),
        )
        .toList();
  }

  List<PropertyRecord> _filtered(
    String query, [
    PropertyAdvancedFilters filters = const PropertyAdvancedFilters(),
  ]) {
    final normalizedQuery = query.trim().toLowerCase();
    final municipality = filters.municipality.trim().toLowerCase();
    final records = normalizedQuery.isEmpty
        ? _properties
        : _properties
              .where(
                (property) =>
                    property.name.toLowerCase().contains(normalizedQuery),
              )
              .toList();

    return records.where((property) {
      if (municipality.isNotEmpty &&
          !property.municipality.toLowerCase().contains(municipality)) {
        return false;
      }
      if (filters.minAreaHa != null &&
          property.totalAreaHa < filters.minAreaHa!) {
        return false;
      }
      if (filters.maxAreaHa != null &&
          property.totalAreaHa > filters.maxAreaHa!) {
        return false;
      }
      return true;
    }).toList()..sort((a, b) => a.name.compareTo(b.name));
  }
}
