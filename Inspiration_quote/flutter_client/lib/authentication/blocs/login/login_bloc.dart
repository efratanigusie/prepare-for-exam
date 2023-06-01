import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_client/authentication/models/user.dart';
import 'package:meta/meta.dart';

import '../../models/loginModel.dart';
import '../../repositories/auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is Login) {
        emit(
          LoginLoading(),
        );
        try {
          var response = await authRepository.login(event.loginModel);
          if (response.containsKey("accessToken")) {
            var data = response['user'];
            List<String> favorites = [];
            if (data['role'] != 'admin') {
              for (var item in data['favorites']) {
                favorites.add(item.toString());
              }
            }
            print(favorites.runtimeType);
            var user = User(
                email: data['email'],
                password: "",
                role: data['role'],
                id: data['_id'],
                favorites: favorites);
            emit(
              LoginSuccess(
                  token: response['accessToken'].toString(), loggedUser: user),
            );
          } else {
            emit(
              LoginFailed(message: "Email or Password not Correct"),
            );
          }
        } catch (e) {
          print("Error ${e.toString}");
          emit(
            LoginFailed(message: "Email or Password not Correct"),
          );
        }
      }
      if (event is Logout) {
        emit(
          LoginInitial(),
        );
      }
    });
  }
}
