import 'dart:io';

import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class SalvadorArquivo {
  const SalvadorArquivo._();

  static const _canalAndroid = MethodChannel(
    'br.com.dendromobile.app/file_saver',
  );

  static Future<bool> salvarArquivo({
    required String caminho,
    required String nomeArquivo,
    required String tipoMime,
    Rect? origemCompartilhamento,
  }) async {
    if (Platform.isAndroid) {
      final salvo = await _canalAndroid.invokeMethod<bool>('saveFile', {
        'path': caminho,
        'fileName': nomeArquivo,
        'mimeType': tipoMime,
      });
      return salvo ?? false;
    }

    if (Platform.isIOS) {
      final resultado = await SharePlus.instance.share(
        ShareParams(
          title: 'Salvar arquivo',
          files: [XFile(caminho, mimeType: tipoMime)],
          fileNameOverrides: [nomeArquivo],
          sharePositionOrigin: origemCompartilhamento,
        ),
      );
      return resultado.status == ShareResultStatus.success ||
          resultado.status == ShareResultStatus.unavailable;
    }

    throw UnsupportedError('Salvamento não disponível nesta plataforma.');
  }
}
