import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/admin/blocs/quote/quote_bloc.dart';
import 'package:flutter_client/appuser/blocs/favorite/favorite_bloc.dart';
import 'package:flutter_client/authentication/models/loginModel.dart';
import 'package:flutter_client/utilities/ColorPallets.dart';
import 'package:flutter_client/widgets/customButton.dart';
import 'package:flutter_client/widgets/customeTextField.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../blocs/login/login_bloc.dart';

class EmailFieldValidator {
  static validate(String value) {
    return value.isEmpty ? '* required' : null;
  }
}

class PasswordFieldValidator {
  static validate(String value) {
    return value.isEmpty ? '* required' : null;
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final emailTextEditingController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is LoginSuccess) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            // ignore: use_build_context_synchronously
            showTopSnackBar(
              context as OverlayState,
              SizedBox(
                width: 20,
                child: CustomSnackBar.success(
                    messagePadding: const EdgeInsets.all(0),
                    icon: Container(),
                    message: "Login sucess"),
              ),
               padding:EdgeInsets.only(top:0),
              displayDuration: const Duration(milliseconds: 500),
            );
            Map<String, dynamic> userData = {
              "token": state.token,
              "id": state.loggedUser.id!,
              "role": state.loggedUser.role,
              "loggedUserEmail": state.loggedUser.email
            };
            await prefs.setString(
              "loggedUserInfo",
              jsonEncode(userData),
            );
            print("shared prefs success");
            context.read<QuoteBloc>().add(
                  GetAllQuotes(token: state.token),
                );
            //Authorization
            if (state.loggedUser.role == "admin") {
              GoRouter.of(context).go("/admin");
            } else {
              context.read<FavoriteBloc>().add(
                    GetFavoriteQuotes(
                        userId: state.loggedUser.id!, token: state.token),
                  );
              GoRouter.of(context).go("/user");
            }
          }
          if (state is LoginLoading) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return const Center(
                  child: SpinKitSpinningLines(
                    size: 50,
                    color: Colors.deepPurpleAccent,
                  ),
                );
              },
            ).then((value) {});
          }
          if (state is LoginFailed) {
            showTopSnackBar(
              context as OverlayState,
              SizedBox(
                width: 20,
                child: CustomSnackBar.error(
                    messagePadding: const EdgeInsets.all(0),
                    icon: Container(),
                    message: "Login  Failed"),
              ),
               padding:EdgeInsets.only(top:0),
              displayDuration: const Duration(milliseconds: 500),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 300,
                  ),
                  customTextField(
                    Icons.email,
                    false,
                    true,
                    hintText: "Email",
                    validator: (value) => EmailFieldValidator.validate(value!),
                    controller: emailTextEditingController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  customTextField(
                    Icons.password,
                    true,
                    false,
                    hintText: "Password",
                    validator: (value) =>
                        PasswordFieldValidator.validate(value!),
                    controller: passwordController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    backroundcolor: ColorPalettes.iconColor,
                    displaytext: const Text("sign in"),
                    onPressedfun: () {
                      var formState = formKey.currentState;
                      if (formState!.validate()) {
                        var loginModel = LoginModel(
                            email: emailTextEditingController.text,
                            password: passwordController.text);

                        context.read<LoginBloc>().add(
                              Login(loginModel: loginModel),
                            );
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      context.go("/signup");
                    },
                    child: const Text(
                      "Don't have account?",
                      // style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
