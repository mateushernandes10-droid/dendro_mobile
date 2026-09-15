import 'package:dendro_mobile/nucleo/preferencias/controlador_tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('controlador carrega preferencia de modo escuro', () async {
    final armazenamento = _MemoriaTemaModoArmazenamento(
      inicialEscuroModo: true,
    );
    final controlador = ControladorTemaAplicativo(armazenamento);
    addTearDown(controlador.dispose);

    await controlador.inicializado;

    expect(controlador.state, ThemeMode.dark);
  });

  test('controlador salva alternancia de tema', () async {
    final armazenamento = _MemoriaTemaModoArmazenamento(
      inicialEscuroModo: false,
    );
    final controlador = ControladorTemaAplicativo(armazenamento);
    addTearDown(controlador.dispose);

    await controlador.inicializado;
    await controlador.definirModoEscuro(true);

    expect(controlador.state, ThemeMode.dark);
    expect(armazenamento.escuroModo, isTrue);

    await controlador.definirModoEscuro(false);

    expect(controlador.state, ThemeMode.light);
    expect(armazenamento.escuroModo, isFalse);
  });
}

class _MemoriaTemaModoArmazenamento implements ArmazenamentoPreferenciaTema {
  _MemoriaTemaModoArmazenamento({bool? inicialEscuroModo})
    : escuroModo = inicialEscuroModo;

  bool? escuroModo;

  @override
  Future<bool?> carregarModoEscuro() async => escuroModo;

  @override
  Future<void> salvarModoEscuro(bool habilitado) async {
    escuroModo = habilitado;
  }
}
