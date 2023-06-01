part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {}

class Login extends LoginEvent {
  final LoginModel loginModel;
  Login({required this.loginModel});
  @override
  List<Object?> get props => [loginModel];
}

class Logout extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class TriggerInitial extends LoginEvent {
  @override
  List<Object?> get props => [];
}
