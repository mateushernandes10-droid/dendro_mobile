import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/dendro_database.dart';

final dendroDatabaseProvider = Provider<DendroDatabase>((ref) {
  final database = DendroDatabase();
  ref.onDispose(database.close);
  return database;
});
