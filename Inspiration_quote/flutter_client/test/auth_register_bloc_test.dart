import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_client/authentication/blocs/signup/signup_bloc.dart';
import 'package:flutter_client/authentication/models/user.dart';
import 'package:flutter_client/authentication/repositories/auth.dart';
import 'package:flutter_test/flutter_test.dart';

class MockLoginBloc extends MockBloc<SignupEvent, SignupState>
    implements SignupBloc {
  AuthRepository authRepository;
  MockLoginBloc(this.authRepository);
  void main() {
    User mockUser = User(
        email: "aa@gmail.com",
        password: "123455",
        role: "appUser",
        confirmPassword: "123455",
        id: "id",
        favorites: []);
    group("RegisterAuth bloc test", () {
      blocTest<SignupBloc, SignupState>(
        'emits nothing when nothing added',
        build: () {
          return SignupBloc(authRepository: authRepository);
        },
        expect: () => <SignupState>[],
      );

      blocTest<SignupBloc, SignupState>(
        'Register submitted',
        build: () {
          return SignupBloc(authRepository: authRepository);
        },
        act: (bloc) {
          return bloc.add(SignUp(user: mockUser));
        },
        wait: const Duration(milliseconds: 1000),
        expect: () {
          return [
            isA<SignupState>(),
            isA<SignupState>(),
          ];
        },
      );
    });
  }
}
