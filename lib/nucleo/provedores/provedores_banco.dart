import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../banco/banco_dendro.dart';

final provedorBancoDendro = Provider<BancoDendro>((ref) {
  final bancoDados = BancoDendro();
  ref.onDispose(bancoDados.close);
  return bancoDados;
});
