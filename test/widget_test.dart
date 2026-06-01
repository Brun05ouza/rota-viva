import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rota_viva/app/app.dart';

void main() {
  testWidgets('renders the app shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RotaVivaApp()));

    expect(find.text('Rota Viva'), findsOneWidget);
  });
}
