part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent extends Equatable {}

class SignUp extends SignupEvent {
  final User user;
  SignUp({required this.user});
  @override
  List<Object?> get props => [user];
}

class TriggerInitial extends SignupEvent {
  @override
  List<Object?> get props => [];
}
