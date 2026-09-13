import 'dart:io';

import 'package:flutter/services.dart';

class SalvadorArquivoAndroid {
  const SalvadorArquivoAndroid._();

  static const _canal = MethodChannel('br.com.dendromobile.app/file_saver');

  static Future<bool> salvarArquivo({
    required String caminho,
    required String nomeArquivo,
    required String tipoMime,
  }) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('Salvamento local disponível apenas no Android.');
    }

    final salvo = await _canal.invokeMethod<bool>('saveFile', {
      'path': caminho,
      'fileName': nomeArquivo,
      'mimeType': tipoMime,
    });
    return salvo ?? false;
  }
}
