import 'package:dendro_mobile/app/dendro_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('abre a tela inicial do DENDRO Mobile', (tester) async {
    await tester.pumpWidget(const DendroApp());

    expect(find.text('DENDRO'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();

    expect(find.text('Talhão 42-B'), findsOneWidget);
    expect(find.text('Novo Levantamento'), findsOneWidget);
    expect(find.text('Continuar Coleta'), findsOneWidget);
  });
}
