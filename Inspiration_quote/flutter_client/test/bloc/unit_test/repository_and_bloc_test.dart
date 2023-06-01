import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_client/admin/blocs/quote/quote_bloc.dart';
import 'package:flutter_client/admin/models/quote.dart';
import 'package:flutter_client/admin/repositories/quote.dart';
import 'package:flutter_client/appuser/blocs/favorite/favorite_bloc.dart';
import 'package:flutter_client/appuser/repositories/favorite.dart';
import 'package:flutter_client/authentication/blocs/login/login_bloc.dart';
import 'package:flutter_client/authentication/blocs/signup/signup_bloc.dart';
import 'package:flutter_client/authentication/models/loginModel.dart';
import 'package:flutter_client/authentication/models/user.dart';
import 'package:flutter_client/authentication/repositories/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

var quoteOne = Quote(author: "Feven", category: "Depression", body: "body one");
var quoteTwo =
    Quote(author: "John", category: "Motivational", body: "body two");

var userOne =
    User(email: "etsub@gmail.com", password: "password", role: "admin");

var userTwo = User(email: "a@gmail.com", password: "passworsd", role: "user");

var userThree = User(email: "ab@gmail.com", password: "faaaf", role: "user");

var loginModelOne = LoginModel(email: "feven@gmail.com", password: "password");
var loginModelTwo = LoginModel(email: "a@gmailcom", password: "passworsd");
//Quote repository test

class MockQuoteRepositoryTest extends Mock implements QuoteRepository {
  @override
  Future<int> createQuote(quoteOne, token) {
    return super.noSuchMethod(Invocation.method(#quotes, null),
        returnValue: Future.value(0));
  }

  @override
  Future<int> updateQuote(quoteTwo, id, token) {
    return super.noSuchMethod(Invocation.method(#quotes, null),
        returnValue: Future.value(0));
  }

  @override
  Future<int> deleteQuote(id, token) {
    return super.noSuchMethod(Invocation.method(#quotes, null),
        returnValue: Future.value(0));
  }

  @override
  Future<List<Quote>> getAll(token) {
    return super.noSuchMethod(Invocation.method(#quotes, null),
        returnValue: Future.value([quoteOne, quoteTwo]));
  }

  @override
  Future<Quote> getQoute(id, token) {
    return super.noSuchMethod(Invocation.method(#quotes, null),
        returnValue: Future.value(quoteOne));
  }
}
//Auth repository test

class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Future<int> register(userOne) {
    return super.noSuchMethod(
      Invocation.method(#auth, null),
      returnValue: Future.value(0),
    );
  }

  @override
  Future<List<User>> getAllUsers() {
    return super.noSuchMethod(
      Invocation.method(#auth, null),
      returnValue: Future.value([userOne, userTwo]),
    );
  }

  @override
  Future<Map<String, dynamic>> login(loginModelOne) {
    return super.noSuchMethod(
      Invocation.method(#auth, null),
      returnValue: Future.value({"token": "token", "user": userOne}),
    );
  }
}

//Favorite repository test
class MockFavoriteRepository extends Mock implements FavoriteRepository {
  @override
  Future<int> addToFavorite(
    token,
    quoteId,
    userId,
  ) {
    return super.noSuchMethod(
      Invocation.method(#auth, null),
      returnValue: Future.value(0),
    );
  }

  @override
  Future<int> removeFromMyFavorites(
    token,
    quoteId,
    userId,
  ) {
    return super.noSuchMethod(
      Invocation.method(#auth, null),
      returnValue: Future.value(0),
    );
  }

  @override
  Future<List<Quote>> getFavoiteQuotes(String token, String userId) {
    return super.noSuchMethod(
      Invocation.method(#auth, null),
      returnValue: Future.value([quoteOne, quoteTwo]),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MockQuoteRepositoryTest mockQuoteRepositoryTest = MockQuoteRepositoryTest();
  MockFavoriteRepository mockFavoriteRepository = MockFavoriteRepository();
  MockAuthRepository mockAuthRepository = MockAuthRepository();

  Future<int> createQuote() async {
    return 0;
  }

  Future<int> createUser() async {
    return 0;
  }

  Future<int> createFavorite() async {
    return 0;
  }

  Future<Map<String, dynamic>> loginUser() async {
    return {"token": "token", "user": userOne};
  }

  setUp(() {
    mockQuoteRepositoryTest = MockQuoteRepositoryTest();
    mockFavoriteRepository = MockFavoriteRepository();
    mockAuthRepository = MockAuthRepository();
  });

  group("QuoteRepository", () {
    blocTest<QuoteBloc, QuoteState>(
        "Create Quote Event should emits [QuoteActionInProgress,QuoteActionSuccess()] when Success",
        build: () {
          when(mockQuoteRepositoryTest.createQuote(quoteOne, "token"))
              .thenAnswer(
            (realInvocation) => createQuote(),
          );
          return QuoteBloc(quoteRepository: mockQuoteRepositoryTest);
        },
        act: (bloc) => bloc.add(
              CreateQuote(token: "token", quote: quoteOne),
            ),
        expect: () {
          return [QuoteActionInProgress(), isA<QuoteActionSucceeded>()];
        });
  });

  group("FavoriteRepository", () {
    blocTest<FavoriteBloc, FavoriteState>(
        "Favorite Quote Event should emits [FavoriteActionInProgress,FavoriteActionSuccess] when Success",
        build: () {
          when(mockFavoriteRepository.addToFavorite(
                  "token", "quoteId", "userId"))
              .thenAnswer(
            (realInvocation) => createFavorite(),
          );
          return FavoriteBloc(favoriteRepository: mockFavoriteRepository);
        },
        act: (bloc) => bloc.add(
              AddToMyFavorites(
                  token: "token", quoteId: "quoteId", userId: "userId"),
            ),
        expect: () {
          return [FavoriteActionInProgress(), isA<FavoriteActionSucceeded>()];
        });
  });
  group("AuthRepository", () {
    blocTest<SignupBloc, SignupState>(
        "Create User Event should emits [SignUpLoading,SignUpSuccess] when Success",
        build: () {
          when(mockAuthRepository.register(userOne)).thenAnswer(
            (realInvocation) => createUser(),
          );
          return SignupBloc(authRepository: mockAuthRepository);
        },
        act: (bloc) => bloc.add(
              SignUp(user: userOne),
            ),
        expect: () {
          return [SignUpLoading(), isA<SignUpSuccess>()];
        });
  });
  group("AuthRepository", () {
    blocTest<LoginBloc, LoginState>(
        "Login User Event should emits [LoginLoading,LoginFailed] when Success for non existent user",
        build: () {
          when(mockAuthRepository.login(
                  LoginModel(email: userOne.email, password: userOne.password)))
              .thenAnswer(
            (realInvocation) => loginUser(),
          );
          return LoginBloc(authRepository: mockAuthRepository);
        },
        act: (bloc) => bloc.add(
              Login(
                loginModel: LoginModel(
                    email: userOne.email, password: userOne.password),
              ),
            ),
        expect: () {
          return [LoginLoading(), isA<LoginFailed>()];
        });
  });
}
