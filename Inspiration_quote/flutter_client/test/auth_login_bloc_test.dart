import 'package:flutter_client/authentication/blocs/login/login_bloc.dart';
import 'package:flutter_client/authentication/models/loginModel.dart';
import 'package:flutter_client/authentication/models/user.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_client/authentication/repositories/auth.dart';
import 'package:test/test.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState> implements LoginBloc {
  @override
  AuthRepository authRepository;
  MockLoginBloc(this.authRepository);

  void main() {
  LoginModel mockLoginModel =LoginModel(email: "aa@gmail.com", password: "alemu");
  User mockUser = User(
      email: "aa@gmail.com",
      password: "123455",
      role: "appUser",
      confirmPassword: "123455",
      id: "id",
      favorites: []);
  group('LoginBloc test', () {
    // before injected
    blocTest<LoginBloc, LoginState>(
      'emits [] when nothing is added before injected',
      build: () {
        return LoginBloc(authRepository: authRepository);
      },
      expect: () => <LoginState>[],
    );
    // build is where we instantite and prepare our bloc under test
    // act is used to add an event to the bloc which is tested
    // expect is Iterable<state> the bloc will emit after bloc executed
    blocTest<LoginBloc, LoginState>(
      'Logout submitted',
      build: () {
        return LoginBloc(authRepository: authRepository);
      },
      act: (bloc) {
        return bloc.add(Logout());
      },
      wait: const Duration(milliseconds: 1000),
      expect: () {
        return [isA<LoginState>()];
      },
    );
  });
}

}

