import 'package:flutter_client/authentication/pages/loginPage.dart';
import 'package:flutter_client/authentication/pages/signupPage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Sign In Validators',
    () {
      test("Empty password returns an error string", () {
        var result = PasswordFieldValidator.validate('');
        expect(result, "* required");
      });

      test(
        "Non-empty passward returns null ",
        () {
          var result = PasswordFieldValidator.validate("password");
          expect(result, null);
        },
      );

      test("Empty Email returns an error string", () {
        var result = EmailFieldValidator.validate('');
        expect(result, "* required");
      });

      test(
        "Non-empty Email returns null",
        () {
          var result = EmailFieldValidator.validate("email");
          expect(result, null);
        },
      );
    },
  );

  group(
    'Sign up Validators',
    () {
      test("Empty password returns an error string", () {
        var result = PasswordValidator.validate('');
        expect(result, "* required");
      });

      test(
        "Non-empty passward returns null ",
        () {
          var result = PasswordValidator.validate("password");
          expect(result, null);
        },
      );
    },
  );
}
