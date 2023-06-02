// ignore_for_file: unnecessary_cast

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/admin/pages/homepage.dart';
import 'package:flutter_client/authentication/blocs/login/login_bloc.dart';
import 'package:flutter_client/utilities/ColorPallets.dart';
import 'package:flutter_client/widgets/WidgetFunctions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../admin/blocs/quote/quote_bloc.dart';
import '../../admin/models/quote.dart';
import '../blocs/favorite/favorite_bloc.dart';

class AppUserHomepage extends StatefulWidget {
  const AppUserHomepage({Key? key}) : super(key: key);

  @override
  State<AppUserHomepage> createState() => _AppUserHomepageState();
}

class _AppUserHomepageState extends State<AppUserHomepage> {
  late List<Map<String, dynamic>> _pages;
  var searchController = TextEditingController();
  var selectedCategory = "";
  SharedPreferences? prefs;
  Map<String, dynamic> userInfo = {};
  setSharedPreference() async {
    print("hello");
    prefs = await SharedPreferences.getInstance();
    String userPref = prefs!.getString('loggedUserInfo') ?? "";
    userInfo = jsonDecode(userPref) as Map<String, dynamic>;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setSharedPreference();
    });
    searchController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  int _selectedPageIndex = 0;
  var category = "";
  void selectPage(int index) {
    setState(() {
      if (index == 0 || index == 2) {
        selectedCategory = "";
      }
      _selectedPageIndex = index;
    });
  }

  var categories = [
    Category(
      title: "Depression",
      color: Colors.purple,
    ),
    Category(
      title: "Anxiety",
      color: Colors.red,
    ),
    Category(
      title: "Fear",
      color: Colors.orange,
    ),
    Category(
      title: "Boost mood",
      color: Colors.amber,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var loggedUserEmail = userInfo['loggedUserEmail'] ?? "";
    var state = BlocProvider.of<LoginBloc>(context).state;
    if (state is LoginSuccess) {
      loggedUserEmail = state.loggedUser.email;
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<QuoteBloc, QuoteState>(builder: (context, state) {
        if (state is QuoteActionInProgress) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Home"),
            ),
          );
        }
        if (state is AllQuotesFetched) {
          var quotes = state.quotes
              .where(
                (element) =>
                    (element.author.toLowerCase().contains(
                              searchController.text.toLowerCase(),
                            ) ||
                        element.body.toLowerCase().contains(
                              searchController.text.toLowerCase(),
                            )) &&
                    element.category.toLowerCase().contains(
                          selectedCategory.toLowerCase(),
                        ),
              )
              .toList();

          _pages = [
            {
              "page": MyHomePage(
                userId: userInfo['id'],
                token: userInfo['token'],
                quotes: quotes,
              ),
              "title": "Home",
              "action": []
            },
            {
              'page': CategoriesScreen(
                selectedPage: _selectedPageIndex,
              ),
              'title': 'Categories',
              "action": []
            },
            {
              'page': const FavoritesScreen(),
              'title': 'Your Favorites',
              "action": []
            },
          ];
          return Scaffold(
            appBar: AppBar(
              // automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(selectedCategory.isNotEmpty
                      ? selectedCategory
                      : _pages[_selectedPageIndex]['title']),
                  const SizedBox(
                    width: 5,
                  ),
                  _pages[_selectedPageIndex]['title'] == 'Home'
                      ? Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: 150,
                            height: 38,
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search",
                                  prefixIcon: Icon(Icons.search)),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            body: _selectedPageIndex == 0
                ? MyHomePage(
                    quotes: quotes,
                    userId: userInfo['id'],
                    token: userInfo['token'],
                  )
                : _selectedPageIndex == 1
                    ? Container(
                        margin: const EdgeInsets.only(top: 25),
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                            padding: const EdgeInsets.all(10),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 2 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 40),
                            itemCount: categories.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return CategoryItem(
                                title: categories[index].title,
                                color: categories[index].color,
                                onTap: () {
                                  setState(() {
                                    _selectedPageIndex = 0;
                                    selectedCategory = categories[index].title;
                                  });
                                },
                              );
                            }),
                      )
                    : const FavoritesScreen(),
            drawer: CustomDrawer(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFF3B5999)),
                  padding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 130, left: 20),
                        child: Text(
                          loggedUserEmail,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30, left: 30),
                        child: const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 2,
                ),
                buildListTile(
                    title: 'Category',
                    icon: Icons.category,
                    onTap: () {
                      selectPage(1);
                    }),
                const Divider(),
                buildListTile(
                    title: 'Favorites',
                    icon: Icons.favorite,
                    onTap: () {
                      selectPage(2);
                    }),
                const Divider(),
                buildListTile(
                    title: 'Log Out',
                    icon: Icons.logout,
                    onTap: () {
                      context.read<LoginBloc>().add(
                            Logout(),
                          );
                      GoRouter.of(context).go("/login");
                    }),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: selectPage,
              backgroundColor: Colors.blueGrey,
              unselectedItemColor: Colors.white,
              selectedItemColor: ColorPalettes.backgroundOne,
              currentIndex: _selectedPageIndex,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: "Category",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: "Favorite",
                ),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
          body: const Center(
            child: Text(
              "Server Error",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        );
      }),
    );
  }

  Widget buildListTile(
      {required String title, required IconData icon, void Function()? onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'PatrickHand',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
    required this.quotes,
    required this.token,
    required this.userId,
  }) : super(key: key);
  final List<Quote> quotes;
  final String token;
  final String userId;
  @override
  Widget build(BuildContext context) {
    List<Quote> favorites = [];
    var loginState = BlocProvider.of<LoginBloc>(context).state;
    var favoriteQuotesState = BlocProvider.of<FavoriteBloc>(context).state;
    if (favoriteQuotesState is FavoriteQuotesFetched) {
      favorites = favoriteQuotesState.quotes;
    }
    print(favorites.length);
    for (var item in quotes) {
      print("item found");
      print(
        favorites.any((favorite) => favorite.id == item.id),
      );
    }
    print("favorites");
    for (var item in favorites) {
      print(item);
    }
    print("quotes");
    for (var item in quotes) {
      print(item);
    }
    int i = 0;
    return quotes.isEmpty
        ? WidgetFunctions.showInfo(title: "No Quotes")
        : ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Card(
                  child: ListTile(
                    onTap: () => context.go("/user/${quotes[index].id}"),
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/images.jpg"),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quotes[index].body,
                          style: const TextStyle(
                              fontFamily: "PatrickHand",
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          quotes[index].category,
                          style: const TextStyle(
                              fontFamily: "PatrickHand",
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      quotes[index].author,
                      style: TextStyle(
                          fontFamily: "PatrickHand",
                          fontSize: 14,
                          color: Colors.grey.shade400),
                    ),
                    trailing: BlocConsumer<FavoriteBloc, FavoriteState>(
                      listener: (context, state) {
                        if (state is FavoriteActionSucceeded && i == index) {
                          context.read<FavoriteBloc>().add(
                                GetFavoriteQuotes(userId: userId, token: token),
                              );
                        }
                        if (state is FavoriteQuotesFetched) {
                          favorites = state.quotes;
                        }
                      },
                      builder: (context, state) {
                        if (state is FavoriteActionInProgress && i == index) {
                          return IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.grey.shade300,
                            ),
                          );
                        }
                        return IconButton(
                          onPressed: () {
                            i = index;
                            favorites.any((favorite) =>
                                    favorite.category ==
                                        quotes[index].category &&
                                    favorite.body == quotes[index].body &&
                                    favorite.author == quotes[index].author)
                                ? context.read<FavoriteBloc>().add(
                                    RemoveFromMyFavorites(
                                        token: token,
                                        quoteId: quotes[index].id!,
                                        userId: userId))
                                : context.read<FavoriteBloc>().add(
                                      AddToMyFavorites(
                                          token: token,
                                          quoteId: quotes[index].id!,
                                          userId: userId),
                                    );
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: favorites.any((favorite) =>
                                    favorite.category ==
                                        quotes[index].category &&
                                    favorite.body == quotes[index].body &&
                                    favorite.author == quotes[index].author)
                                ? Colors.redAccent
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
  }
}

class Category {
  String title;
  Color color;
  Category({required this.title, required this.color});
}

class CategoriesScreen extends StatefulWidget {
  int selectedPage;
  CategoriesScreen({Key? key, required this.selectedPage}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var categories = [
    Category(
      title: "Depression",
      color: Colors.purple,
    ),
    Category(
      title: "Anxiety",
      color: Colors.red,
    ),
    Category(
      title: "Fear",
      color: Colors.orange,
    ),
    Category(
      title: "Boost mood",
      color: Colors.amber,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 2 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 40),
          itemCount: categories.length,
          itemBuilder: (BuildContext ctx, index) {
            return CategoryItem(
              title: categories[index].title,
              color: categories[index].color,
              onTap: () {
                setState(() {
                  widget.selectedPage = 0;
                });
              },
            );
          }),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        if (state is FavoriteActionInProgress) {
          return const Center(
            child: SpinKitCircle(
              size: 40,
              color: Colors.deepPurple,
            ),
          );
        }
        if (state is FavoriteQuotesFetched) {
          return ListView.builder(
            itemCount: state.quotes.length,
            itemBuilder: (context, index) {
              return state.quotes.isEmpty
                  ? WidgetFunctions.showInfo(title: "No Favorite Quotes")
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/images.jpg"),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.quotes[index].body,
                              style: const TextStyle(
                                  fontFamily: "PatrickHand",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              state.quotes[index].category,
                              style: const TextStyle(
                                  fontFamily: "PatrickHand",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          state.quotes[index].author,
                          style: TextStyle(
                              fontFamily: "PatrickHand",
                              fontSize: 14,
                              color: Colors.grey.shade400),
                        ),
                      ),
                    );
            },
          );
        }
        return const Center(
          child: Text("Server Error"),
        );
      },
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final Color color;
  final void Function()? onTap;
  CategoryItem(
      {Key? key, required this.title, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [color.withOpacity(0.7), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                fontFamily: "PatrickHand",
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
