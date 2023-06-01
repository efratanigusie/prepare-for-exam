import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:integration_test/integration_test.dart';
// ignore: avoid_relative_lib_imports
// import '../../lib/main.dart' as main_method;

void main() {
  group('Check Apps Functionality', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets("check functionality", (tester) async {
      // main_method.main();
      tester.pumpAndSettle();
      final buttonOne = find.byKey(const Key("action_one"));
      final buttonTwo = find.byKey(const Key("action_two"));
      final buttonThree = find.byKey(const Key("action_three"));
      await tester.tap(buttonOne);
      await tester.tap(buttonTwo);
      await tester.tap(buttonThree);
      tester.pumpAndSettle();
    });
  });
}
