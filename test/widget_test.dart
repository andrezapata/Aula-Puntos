import 'package:flutter_test/flutter_test.dart';
import 'package:aula_puntos/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AulaPuntosApp());
    expect(find.text('AULA PUNTOS - SENATI'), findsOneWidget);
  });
}
