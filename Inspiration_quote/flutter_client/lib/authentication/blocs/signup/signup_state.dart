part of 'signup_bloc.dart';

@immutable
abstract class SignupState extends Equatable {}

class SignupInitial extends SignupState {
  @override
  List<Object?> get props => [];
}

class SignUpLoading extends SignupState {
  @override
  List<Object?> get props => [];
}

class SignUpSuccess extends SignupState {
  @override
  List<Object?> get props => [];
}

class SignUpFailed extends SignupState {
  final String message;
  SignUpFailed({required this.message});
  @override
  List<Object?> get props => [];
}
