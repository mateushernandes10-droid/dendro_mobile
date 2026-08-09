import 'package:dendro_mobile/app/dendro_app.dart';
import 'package:dendro_mobile/core/database/dendro_database.dart';
import 'package:dendro_mobile/core/providers/database_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('abre a tela inicial do DENDRO Mobile', (tester) async {
    final database = DendroDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dendroDatabaseProvider.overrideWithValue(database)],
        child: const DendroApp(),
      ),
    );

    expect(find.text('DENDRO'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();

    expect(find.text('Talhão 42-B'), findsOneWidget);
    expect(find.text('Novo Levantamento'), findsOneWidget);
    expect(find.text('Continuar Coleta'), findsOneWidget);
  });
}
