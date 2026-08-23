import 'dart:io';

import 'package:flutter/services.dart';

class AndroidFileSaver {
  const AndroidFileSaver._();

  static const _channel = MethodChannel('br.com.dendromobile.app/file_saver');

  static Future<bool> saveFile({
    required String path,
    required String fileName,
    required String mimeType,
  }) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('Salvamento local disponível apenas no Android.');
    }

    final saved = await _channel.invokeMethod<bool>('saveFile', {
      'path': path,
      'fileName': fileName,
      'mimeType': mimeType,
    });
    return saved ?? false;
  }
}
