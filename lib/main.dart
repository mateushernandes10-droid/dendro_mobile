import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'aplicativo/aplicativo_dendro.dart';

void main() {
  runApp(const ProviderScope(child: AplicativoDendro()));
}
