import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/admin/blocs/quote/quote_bloc.dart';
import 'package:flutter_client/admin/dataproviders/remoteDataProvider.dart';
import 'package:flutter_client/admin/repositories/quote.dart';
import 'package:flutter_client/appuser/blocs/favorite/favorite_bloc.dart';
import 'package:flutter_client/appuser/dataproviders/favorite.dart';
import 'package:flutter_client/appuser/pages/homepage.dart';
import 'package:flutter_client/appuser/pages/quoteDetail.dart';
import 'package:flutter_client/appuser/repositories/favorite.dart';
import 'package:flutter_client/authentication/blocs/signup/signup_bloc.dart';
import 'package:flutter_client/authentication/dataProviders/auth.dart';
import 'package:flutter_client/authentication/pages/loginPage.dart';
import 'package:flutter_client/authentication/pages/signupPage.dart';
import 'package:flutter_client/blocObserver.dart';
import 'package:flutter_client/splash/splash.dart';
import 'package:go_router/go_router.dart';

import 'admin/pages/homepage.dart';
import 'authentication/blocs/login/login_bloc.dart';
import 'authentication/repositories/auth.dart';

void main() {
  Bloc.observer = Observer();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    App(),
  );
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            authDataProvider: AuthDataProvider(),
          ),
        ),
        RepositoryProvider(
          create: (context) => QuoteRepository(
            dataProvider: QuoteDataProvider(),
          ),
        ),
        RepositoryProvider(
          create: (context) => FavoriteRepository(
            favoriteDataProvider: FavoriteDataProvider(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SignupBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => LoginBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => QuoteBloc(
              quoteRepository: context.read<QuoteRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => FavoriteBloc(
              favoriteRepository: context.read<FavoriteRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
            primaryColor: const Color.fromARGB(255, 135, 233, 212),
            primarySwatch: Colors.blueGrey,
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: _goRouter,
        ),
      ),
    );
  }

  final GoRouter _goRouter = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
        routes: [
          GoRoute(
            path: "login",
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: LoginPage(),
            ),
          ),
          GoRoute(
            path: "signup",
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const SignupPage(),
            ),
          ),
          GoRoute(
            path: "admin",
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const AdminHomepage(),
            ),
            routes: [
              GoRoute(
                  path: ":id",
                  pageBuilder: (context, state) {
                    var id = state.pathParameters["id"];
                    return MaterialPage(
                      key: state.pageKey,
                      child: QuoteDetails(
                        id: id.toString(),
                      ),
                    );
                  }),
            ],
          ),
          GoRoute(
            path: "user",
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const AppUserHomepage(),
            ),
            routes: [
              GoRoute(
                  path: ":id",
                  pageBuilder: (context, state) {
                    final String id = state.pathParameters["id"]!;
                    return MaterialPage(
                      key: state.pageKey,
                      child: QuoteDetails(
                        id: id,
                      ),
                    );
                  }),
            ],
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              state.error.toString(),
            ),
          ),
        ),
      );
    },
  );
}
