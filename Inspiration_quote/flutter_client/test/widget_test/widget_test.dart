import 'package:flutter_client/splash/splash.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Welcome text ', (tester) async {
    await tester.pumpWidget(const Content());
    final titleFinder = find.text("Welcome");

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
  });
}