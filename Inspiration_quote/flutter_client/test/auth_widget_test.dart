import 'package:flutter_client/admin/pages/homepage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("The auth displayed as expected", (WidgetTester tester) async {
    await tester.pumpWidget(AdminHomepage());

    expect(find.text("Admin Home"), findsOneWidget);
  });
}
