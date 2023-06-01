import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/admin/models/quote.dart';
import 'package:flutter_client/authentication/blocs/login/login_bloc.dart';
import 'package:flutter_client/widgets/WidgetFunctions.dart';
import 'package:flutter_client/widgets/customButton.dart';
import 'package:flutter_client/widgets/customeTextField.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../blocs/quote/quote_bloc.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({Key? key}) : super(key: key);

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  var loggedUserEmail = "";
  var searchController = TextEditingController();
  SharedPreferences? prefs;
  Map<String, dynamic> userInfo = {};
  setSharedPreference() async {
    print("hello");
    prefs = await SharedPreferences.getInstance();
    String userPref = prefs!.getString('loggedUserInfo') ?? "";
    userInfo = jsonDecode(userPref) as Map<String, dynamic>;
    setState(() {
      loggedUserEmail = userInfo['loggedUserEmail'];
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      setSharedPreference();
    });
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<LoginBloc>(context).state;
    if (state is LoginSuccess) {
      loggedUserEmail = state.loggedUser.email;
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocConsumer<QuoteBloc, QuoteState>(
        listener: (context, state) {
          if (state is QuoteActionSucceeded) {
            showTopSnackBar(
              Overlay.of(context),
              SizedBox(
                width: 20,
                child: CustomSnackBar.success(
                    messagePadding: const EdgeInsets.all(0),
                    icon: Container(),
                    message: state.message),
              ),
              displayDuration: const Duration(milliseconds: 500),
            );
            context.read<QuoteBloc>().add(
                  GetAllQuotes(token: userInfo['token']),
                );
          }
        },
        builder: (context, state) {
          if (state is QuoteActionInProgress) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Admin Home"),
              ),
              body: const Center(
                child: SpinKitCircle(
                  size: 50,
                  color: Colors.deepPurple,
                ),
              ),
            );
          }

          if (state is AllQuotesFetched) {
            var filterdItems = state.quotes
                .where((e) =>
                    e.author.toLowerCase().contains(
                          searchController.text.toLowerCase(),
                        ) ||
                    e.body.toLowerCase().contains(
                          searchController.text.toLowerCase(),
                        ))
                .toList();
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Admin Home"),
                    const SizedBox(
                      width: 5,
                    ),
                    state.quotes.isEmpty
                        ? Container()
                        : Flexible(
                            child: Container(
                              padding: const EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 150,
                              height: 38,
                              child: TextField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                    hintText: "Search",
                                    prefixIcon: Icon(Icons.search)),
                              ),
                            ),
                          )
                  ],
                ),
              ),
              body: state.quotes.isEmpty
                  ? WidgetFunctions.showInfo(title: "No Quotes")
                  : filterdItems.isEmpty
                      ? WidgetFunctions.showInfo(
                          title: "No quote available for this query")
                      : Body(
                          quotes: filterdItems,
                          token: userInfo['token'],
                        ),
              floatingActionButton: BlocBuilder<QuoteBloc, QuoteState>(
                builder: (context, state) {
                  if (state is AllQuotesFetched) {
                    return FloatingActionButton(
                      onPressed: () {
                        print("user info ${userInfo['token']}");
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                          isDismissible: true,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: QuoteAddAndUpdateForm(
                              token: userInfo['token'],
                            ),
                          ),
                        );
                      },
                      child: const Icon(Icons.add),
                    );
                  }
                  return Container();
                },
              ),
              // bottomNavigationBar: const TabsScreen(),
              drawer: CustomDrawer(children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B5999),
                  ),
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
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    size: 26,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      fontFamily: 'PatrickHand',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    var prefs = await SharedPreferences.getInstance();
                    await prefs.remove("loggedUserInfo");
                    context.read<LoginBloc>().add(
                          Logout(),
                        );
                    context.go("/login");
                  },
                )
              ]),
            );
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Admin Home"),
            ),
            body: const Center(
              child: Text(
                "Server Error",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key, required this.children}) : super(key: key);
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.6,
      child: Drawer(
        child: ListView(
          children: children,
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key, required this.quotes, required this.token})
      : super(key: key);
  final List<Quote> quotes;
  final String token;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Scrollbar(
        child: ListView.builder(
          itemCount: quotes.length,
          itemBuilder: (_, index) {
            return Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: QuoteRow(
                value: quotes[index],
                onTap: () {
                  context.go(
                    Uri(path: "/admin/${quotes[index].id}").toString(),
                  );
                },
                token: token,
              ),
            );
          },
        ),
      ),
    );
  }
}

class QuoteRow extends StatelessWidget {
  const QuoteRow({
    Key? key,
    this.isUser = false,
    required this.value,
    required this.token,
    this.onTap,
  }) : super(key: key);

  final Quote value;
  final bool isUser;
  final String token;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        trailing: isUser
            ? null
            : SizedBox(
                width: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                            ),
                            isDismissible: true,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: QuoteAddAndUpdateForm(
                                isUpdate: true,
                                quote: value,
                                token: token,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.yellow.shade300,
                        ),
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        onPressed: () async {
                          print("token is ");
                          print(token);
                          print("value ${value.id}");
                          await showConfirmDialogCustom(context,
                              title: "Do you want to delete this Quote?",
                              dialogType: DialogType.DELETE,
                              onAccept: (context) {
                            Navigator.pop(context);
                            context.read<QuoteBloc>().add(
                                  DeleteQuote(id: value.id!, token: token),
                                );
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        leading: const CircleAvatar(
          backgroundImage: AssetImage("assets/images/images.jpg"),
        ),
        title: Text(
          value.body,
          style: const TextStyle(fontFamily: "PatrickHand", fontSize: 18),
        ),
        subtitle: Text(
          value.author,
          style: TextStyle(
              fontFamily: "PatrickHand",
              fontSize: 16,
              color: Colors.grey.shade400),
        ),
      ),
    );
  }
}

class QuoteAddAndUpdateForm extends StatefulWidget {
  const QuoteAddAndUpdateForm(
      {Key? key, this.quote, this.isUpdate = false, required this.token})
      : super(key: key);
  final bool isUpdate;
  final Quote? quote;
  final String token;
  @override
  State<QuoteAddAndUpdateForm> createState() => _QuoteAddAndUpdateFormState();
}

class _QuoteAddAndUpdateFormState extends State<QuoteAddAndUpdateForm> {
  var categories = ["Depression", "Anxiety", "Fear", "Boost mood"];
  var selectedCategory = "Depression";
  var formKey = GlobalKey<FormState>();
  var authorController = TextEditingController();
  var bodyController = TextEditingController();
  @override
  void initState() {
    if (widget.isUpdate) {
      authorController.text = widget.quote!.author;
      bodyController.text = widget.quote!.body;
      selectedCategory = categories[categories.indexOf(widget.quote!.category)];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("token is ");
    print(widget.token);
    return BlocConsumer<QuoteBloc, QuoteState>(
      listener: (context, state) {
        if (state is QuoteActionSucceeded) {
          Navigator.pop(context);
          context.read<QuoteBloc>().add(
                GetAllQuotes(token: widget.token),
              );
          showTopSnackBar(
            Overlay.of(context),
            SizedBox(
              width: 20,
              child: CustomSnackBar.success(
                  messagePadding: const EdgeInsets.all(0),
                  icon: Container(),
                  message: state.message),
            ),
            displayDuration: const Duration(milliseconds: 500),
          );
        }
        if (state is QuoteActionFailed) {
          showTopSnackBar(
            Overlay.of(context),
            SizedBox(
              width: 20,
              child: CustomSnackBar.error(
                  messagePadding: const EdgeInsets.all(0),
                  icon: Container(),
                  message: state.message),
            ),
            displayDuration: const Duration(milliseconds: 500),
          );
        }
      },
      builder: (context, state) {
        if (state is QuoteActionInProgress) {
          return const Center(
            child: SpinKitCircle(
              size: 30,
              color: Colors.deepPurple,
            ),
          );
        }
        return Form(
          key: formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isUpdate ? "Update Quote" : "Add Quote",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 47, 108, 212),
                        fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              customTextField(
                Icons.description,
                false,
                false,
                lableText: "body",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "title is required";
                  }
                  return null;
                },
                controller: bodyController,
              ),
              const SizedBox(
                height: 10,
              ),
              customTextField(
                Icons.person,
                false,
                false,
                lableText: "author",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Author is required";
                  }
                  return null;
                },
                controller: authorController,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Category: ",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  DropdownButton(
                    borderRadius: BorderRadius.circular(5),
                    value: selectedCategory,
                    items: categories
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
                          selectedCategory = newValue!;
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                backroundcolor: Colors.grey.shade500,
                displaytext: Text(widget.isUpdate ? "Update" : "Add"),
                onPressedfun: () async {
                  var state = formKey.currentState;
                  var prefs = await SharedPreferences.getInstance();
                  var authToken = prefs.getString("token") ?? "";
                  if (state!.validate()) {
                    !widget.isUpdate
                        ? context.read<QuoteBloc>().add(
                              CreateQuote(
                                token: widget.token,
                                quote: Quote(
                                    author: authorController.text,
                                    category: selectedCategory,
                                    body: bodyController.text),
                              ),
                            )
                        : context.read<QuoteBloc>().add(
                              UpdateQuote(
                                id: widget.quote!.id!,
                                token: widget.token,
                                quote: Quote(
                                    author: authorController.text,
                                    category: selectedCategory,
                                    body: bodyController.text),
                              ),
                            );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
