import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final provedorControladorTema =
    StateNotifierProvider<ControladorTemaAplicativo, ThemeMode>((ref) {
      return ControladorTemaAplicativo(ArmazenamentoTemaArquivo());
    });

final provedorModoEscuro = Provider<bool>((ref) {
  return ref.watch(provedorControladorTema) == ThemeMode.dark;
});

abstract interface class ArmazenamentoModoTema {
  Future<bool?> carregarEscuroModo();

  Future<void> salvarEscuroModo(bool habilitado);
}

class ArmazenamentoTemaArquivo implements ArmazenamentoModoTema {
  static const _arquivoNome = 'dendro_preferences.json';
  static const _escuroModoChave = 'darkMode';

  @override
  Future<bool?> carregarEscuroModo() async {
    try {
      final arquivo = await _preferenciasArquivo();
      if (!await arquivo.exists()) return null;

      final conteudo = await arquivo.readAsString();
      final decodificado = jsonDecode(conteudo);
      if (decodificado is! Map<String, Object?>) return null;

      final valor = decodificado[_escuroModoChave];
      return valor is bool ? valor : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> salvarEscuroModo(bool habilitado) async {
    final arquivo = await _preferenciasArquivo();
    final preferencias = await _carregarPreferencias(arquivo);

    preferencias[_escuroModoChave] = habilitado;

    await arquivo.parent.create(recursive: true);
    await arquivo.writeAsString(jsonEncode(preferencias));
  }

  Future<File> _preferenciasArquivo() async {
    final diretorio = await getApplicationSupportDirectory();
    return File('${diretorio.path}/$_arquivoNome');
  }

  Future<Map<String, Object?>> _carregarPreferencias(File arquivo) async {
    try {
      if (!await arquivo.exists()) return {};

      final decodificado = jsonDecode(await arquivo.readAsString());
      if (decodificado is! Map<String, Object?>) return {};

      return Map<String, Object?>.from(decodificado);
    } catch (_) {
      return {};
    }
  }
}

class ControladorTemaAplicativo extends StateNotifier<ThemeMode> {
  ControladorTemaAplicativo(this._armazenamento) : super(ThemeMode.light) {
    inicializado = _carregarPreferencia();
  }

  final ArmazenamentoModoTema _armazenamento;
  late final Future<void> inicializado;

  Future<void> definirEscuroModo(bool habilitado) async {
    final anterior = state;
    state = habilitado ? ThemeMode.dark : ThemeMode.light;

    try {
      await _armazenamento.salvarEscuroModo(habilitado);
    } catch (_) {
      state = anterior;
      rethrow;
    }
  }

  Future<void> _carregarPreferencia() async {
    final habilitado = await _armazenamento.carregarEscuroModo();
    if (!mounted || habilitado == null) return;

    state = habilitado ? ThemeMode.dark : ThemeMode.light;
  }
}
