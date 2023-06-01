import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/authentication/blocs/signup/signup_bloc.dart';
import 'package:flutter_client/utilities/ColorPallets.dart';
import 'package:flutter_client/widgets/customButton.dart';
import 'package:flutter_client/widgets/customeTextField.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../models/user.dart';

class PasswordValidator {
  static validate(String value) {
    if (value.isEmpty) {
      return '* required';
    } else if (value.length < 6) {
      return "short password";
    }
    return null;
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  var selectedRole = "appuser";
  var roles = ["appuser", "admin"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            showTopSnackBar(
              Overlay.of(context),
              SizedBox(
                width: 20,
                child: CustomSnackBar.success(
                    messagePadding: const EdgeInsets.all(0),
                    icon: Container(),
                    message: "Sign up Success,login in to proceed."),
              ),
              displayDuration: const Duration(milliseconds: 500),
            );
            context.go("/login");
          }
          if (state is SignUpLoading) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return const Center(
                  child: SpinKitCircle(
                    size: 50,
                    color: Colors.deepPurpleAccent,
                  ),
                );
              },
            );
          }
          if (state is SignUpFailed) {
            showTopSnackBar(
              Overlay.of(context),
              SizedBox(
                width: 20,
                child: CustomSnackBar.error(
                    messagePadding: const EdgeInsets.all(0),
                    icon: Container(),
                    message: "Sign Up Failed"),
              ),
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
                    height: 200,
                  ),
                  customTextField(
                    Icons.email,
                    false,
                    true,
                    hintText: "Email",
                    validator: (value) {
                      if (!EmailValidator.validate(value!)) {
                        return "invalid email";
                      }
                      return null;
                    },
                    controller: emailController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  customTextField(
                    Icons.password,
                    true,
                    false,
                    hintText: "Password",
                    validator: (value) => PasswordValidator.validate(value!),
                    controller: passwordController,
                  ),
                  customTextField(
                    Icons.password,
                    true,
                    false,
                    hintText: "Confirm Password",
                    validator: (value) {
                      if (passwordController.text != value!) {
                        return "password doesn't match";
                      }
                      return null;
                    },
                    controller: confirmPasswordController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Role: ",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      DropdownButton(
                        borderRadius: BorderRadius.circular(5),
                        value: selectedRole,
                        items: roles
                            .map(
                              (department) => DropdownMenuItem(
                                value: department,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(department),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(
                            () {
                              selectedRole = newValue!;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: CustomButton(
                          backroundcolor: ColorPalettes.iconColor,
                          displaytext: const Text("sign up"),
                          onPressedfun: () {
                            var formState = formKey.currentState;
                            if (formState!.validate()) {
                              var user = User(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  confirmPassword:
                                      confirmPasswordController.text,
                                  role: selectedRole);

                              context.read<SignupBloc>().add(
                                    SignUp(user: user),
                                  );
                            }
                          },
                        ),
                      ),
                      Flexible(
                        child: CustomButton(
                          backroundcolor: ColorPalettes.iconColor,
                          displaytext: const Text("sign in"),
                          onPressedfun: () {
                            context.go("/login");
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
