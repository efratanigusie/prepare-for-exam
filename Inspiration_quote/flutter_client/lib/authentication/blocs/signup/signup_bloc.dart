import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_client/authentication/models/user.dart';
import 'package:meta/meta.dart';

import '../../repositories/auth.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;
  SignupBloc({required this.authRepository}) : super(SignupInitial()) {
    on<SignupEvent>((event, emit) async {
      if (event is SignUp) {
        emit(
          SignUpLoading(),
        );
        try {
          var response = await authRepository.register(event.user);
          if (response == 0) {
            emit(
              SignUpSuccess(),
            );
          } else {
            emit(
              SignUpFailed(message: "Failed to register"),
            );
          }
        } catch (e) {
          emit(
            SignUpFailed(
              message: e.toString(),
            ),
          );
        }
      }
    });
  }
}
