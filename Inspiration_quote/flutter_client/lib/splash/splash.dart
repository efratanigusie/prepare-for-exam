import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/admin/blocs/quote/quote_bloc.dart';
import 'package:flutter_client/appuser/blocs/favorite/favorite_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? prefs;
  Map<String, dynamic> userInfo = {};

  setSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
    var info = prefs!.getString('loggedUserInfo');
    print("cached login info");
    print(info);
    userInfo = info != null ? jsonDecode(info) as Map<String, dynamic> : {};
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setSharedPreference();
    });
    Future.delayed(const Duration(seconds: 3), () {
      //Authorization
      if (userInfo.isNotEmpty) {
        print("user info $userInfo");
        if (userInfo['role'] == "admin") {
          context.go("/admin");
          context.read<QuoteBloc>().add(GetAllQuotes(token: userInfo['token']));
          return;
        }
        if (userInfo['role'] == "appuser") {
          context.go("/user");
          context.read<QuoteBloc>().add(GetAllQuotes(token: userInfo['token']));
          context.read<FavoriteBloc>().add(GetFavoriteQuotes(
              token: userInfo['token'], userId: userInfo['id']));
          return;
        }
      } else {
        print("User info is empty");
        context.go("/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor:
            lightMode ? const Color(0xffe1f5fe) : const Color(0xff042a49),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              SizedBox(
                height: !isLandscape
                    ? MediaQuery.of(context).size.height
                    : MediaQuery.of(context).size.height + 250,
                child: Stack(
                  children: [
                    SizedBox(
                      height: !isLandscape
                          ? MediaQuery.of(context).size.height
                          : MediaQuery.of(context).size.height + 250,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        "assets/images/images.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Content(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 150,
            backgroundImage: AssetImage("assets/images/images.jpg"),
            child: Text("Welcome"),
          ),
          SizedBox(
            height: 20,
          ),
          SpinKitCircle(
            size: 40,
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}
