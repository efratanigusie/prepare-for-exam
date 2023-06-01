part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  final String token;
  final User loggedUser;
  LoginSuccess({required this.token, required this.loggedUser});

  @override
  List<Object?> get props => [token, loggedUser];
}

class LoginFailed extends LoginState {
  final String message;
  LoginFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
