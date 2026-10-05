import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ChungCuApp());
    expect(find.text('Đăng nhập'), findsWidgets);
  });
}
