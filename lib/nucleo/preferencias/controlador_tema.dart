import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final provedorControladorTema =
    StateNotifierProvider<ControladorTemaAplicativo, ThemeMode>((ref) {
      return ControladorTemaAplicativo(ArmazenamentoTemaEmArquivo());
    });

final provedorModoEscuro = Provider<bool>((ref) {
  return ref.watch(provedorControladorTema) == ThemeMode.dark;
});

abstract interface class ArmazenamentoPreferenciaTema {
  Future<bool?> carregarModoEscuro();

  Future<void> salvarModoEscuro(bool habilitado);
}

class ArmazenamentoTemaEmArquivo implements ArmazenamentoPreferenciaTema {
  static const _nomeArquivo = 'dendro_preferences.json';
  static const _escuroModoChave = 'darkMode';

  @override
  Future<bool?> carregarModoEscuro() async {
    try {
      final arquivo = await _arquivoPreferencias();
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
  Future<void> salvarModoEscuro(bool habilitado) async {
    final arquivo = await _arquivoPreferencias();
    final preferencias = await _carregarPreferencias(arquivo);

    preferencias[_escuroModoChave] = habilitado;

    await arquivo.parent.create(recursive: true);
    await arquivo.writeAsString(jsonEncode(preferencias));
  }

  Future<File> _arquivoPreferencias() async {
    final diretorio = await getApplicationSupportDirectory();
    return File('${diretorio.path}/$_nomeArquivo');
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

  final ArmazenamentoPreferenciaTema _armazenamento;
  late final Future<void> inicializado;

  Future<void> definirModoEscuro(bool habilitado) async {
    final anterior = state;
    state = habilitado ? ThemeMode.dark : ThemeMode.light;

    try {
      await _armazenamento.salvarModoEscuro(habilitado);
    } catch (_) {
      state = anterior;
      rethrow;
    }
  }

  Future<void> _carregarPreferencia() async {
    final habilitado = await _armazenamento.carregarModoEscuro();
    if (!mounted || habilitado == null) return;

    state = habilitado ? ThemeMode.dark : ThemeMode.light;
  }
}
