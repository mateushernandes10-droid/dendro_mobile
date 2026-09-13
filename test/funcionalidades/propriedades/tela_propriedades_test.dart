import 'dart:async';

import 'package:dendro_mobile/aplicativo/tema/tema_dendro.dart';
import 'package:dendro_mobile/nucleo/banco/banco_dendro.dart';
import 'package:dendro_mobile/funcionalidades/propriedades/dados/repositorio_propriedades.dart';
import 'package:dendro_mobile/funcionalidades/propriedades/apresentacao/tela_propriedades.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('cadastra propriedade pela tela', (testador) async {
    final repositorio = _RepositorioSimuladoPropriedades();
    addTearDown(repositorio.fechar);

    await testador.pumpWidget(
      ProviderScope(
        overrides: [provedorRepositorioPropriedades.overrideWithValue(repositorio)],
        child: MaterialApp(
          theme: TemaDendro.claro,
          home: const Scaffold(body: TelaPropriedades()),
        ),
      ),
    );

    await testador.pump();
    await testador.pump(const Duration(milliseconds: 300));

    expect(find.text('Nenhuma propriedade cadastrada'), findsOneWidget);

    await testador.tap(find.text('Cadastrar propriedade'));
    await testador.pump();
    await testador.pump(const Duration(milliseconds: 300));

    await testador.enterText(
      find.widgetWithText(TextFormField, 'Nome da propriedade'),
      'Fazenda Esperança',
    );
    await testador.enterText(
      find.widgetWithText(TextFormField, 'Município'),
      'Vacaria',
    );
    await testador.enterText(
      find.widgetWithText(TextFormField, 'Área total (ha)'),
      '158,17',
    );

    await testador.tap(find.text('Cadastrar'));
    await testador.pump();
    await testador.pump(const Duration(milliseconds: 500));

    expect(find.text('Fazenda Esperança'), findsOneWidget);
    expect(find.text('Vacaria-RS'), findsOneWidget);
    expect(find.text('158,17 ha'), findsOneWidget);
  });
}

class _RepositorioSimuladoPropriedades implements RepositorioPropriedades {
  final _alteracoes = StreamController<void>.broadcast();
  final _propriedades = <Propriedade>[];
  int _proximoId = 1;

  Future<void> fechar() => _alteracoes.close();

  @override
  Stream<List<PropriedadeResumo>> observarResumos({
    String buscaConsulta = '',
    PropriedadeAvancadoFiltros filtros = const PropriedadeAvancadoFiltros(),
  }) async* {
    yield _resumos(buscaConsulta, filtros);
    yield* _alteracoes.stream.map((_) => _resumos(buscaConsulta, filtros));
  }

  @override
  Future<List<Propriedade>> buscaPorNome(String consulta) async {
    return _filtrado(consulta);
  }

  @override
  Future<Propriedade?> buscarPorId(String id) async {
    return _propriedades.where((propriedade) => propriedade.id == id).firstOrNull;
  }

  @override
  Future<String> criar({
    required String nome,
    required String municipio,
    String estado = 'RS',
    required double areaTotalHa,
  }) async {
    final agora = DateTime(2026, 8, 9);
    final id = 'property_${_proximoId++}';

    _propriedades.add(
      Propriedade(
        id: id,
        nome: nome.trim(),
        municipio: municipio.trim(),
        estado: estado.trim(),
        areaTotalHa: areaTotalHa,
        criadoEm: agora,
        atualizadoEm: agora,
      ),
    );
    _alteracoes.add(null);

    return id;
  }

  @override
  Future<void> atualizar({
    required String id,
    required String nome,
    required String municipio,
    required String estado,
    required double areaTotalHa,
  }) async {
    final indice = _propriedades.indexWhere((propriedade) => propriedade.id == id);
    if (indice == -1) return;

    final atual = _propriedades[indice];
    _propriedades[indice] = Propriedade(
      id: atual.id,
      nome: nome.trim(),
      municipio: municipio.trim(),
      estado: estado.trim(),
      areaTotalHa: areaTotalHa,
      criadoEm: atual.criadoEm,
      atualizadoEm: DateTime(2026, 8, 9),
    );
    _alteracoes.add(null);
  }

  @override
  Future<void> excluir(String id) async {
    _propriedades.removeWhere((propriedade) => propriedade.id == id);
    _alteracoes.add(null);
  }

  @override
  Future<PropriedadeResumo?> obterResumo(String id) async {
    final propriedade = await buscarPorId(id);
    if (propriedade == null) return null;

    return PropriedadeResumo(
      propriedade: propriedade,
      talhaoQuantidade: 0,
      levantamentoQuantidade: 0,
    );
  }

  List<PropriedadeResumo> _resumos(
    String consulta,
    PropriedadeAvancadoFiltros filtros,
  ) {
    return _filtrado(consulta, filtros)
        .map(
          (propriedade) => PropriedadeResumo(
            propriedade: propriedade,
            talhaoQuantidade: 0,
            levantamentoQuantidade: 0,
          ),
        )
        .toList();
  }

  List<Propriedade> _filtrado(
    String consulta, [
    PropriedadeAvancadoFiltros filtros = const PropriedadeAvancadoFiltros(),
  ]) {
    final normalizadoConsulta = consulta.trim().toLowerCase();
    final municipio = filtros.municipio.trim().toLowerCase();
    final registros = normalizadoConsulta.isEmpty
        ? _propriedades
        : _propriedades
              .where(
                (propriedade) =>
                    propriedade.nome.toLowerCase().contains(normalizadoConsulta),
              )
              .toList();

    return registros.where((propriedade) {
      if (municipio.isNotEmpty &&
          !propriedade.municipio.toLowerCase().contains(municipio)) {
        return false;
      }
      if (filtros.minimoAreaHa != null &&
          propriedade.areaTotalHa < filtros.minimoAreaHa!) {
        return false;
      }
      if (filtros.maximoAreaHa != null &&
          propriedade.areaTotalHa > filtros.maximoAreaHa!) {
        return false;
      }
      return true;
    }).toList()..sort((a, b) => a.nome.compareTo(b.nome));
  }
}
