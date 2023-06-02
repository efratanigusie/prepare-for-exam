import 'package:flutter_client/admin/models/quote.dart';

class User {
  String email;
  String password;
  String role;
  String? confirmPassword;
  String? id;
  List<String> favorites;
  User(
      {required this.email,
      required this.password,
      required this.role,
      this.confirmPassword,
      this.id,
      this.favorites = const []});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        password: json['password'],
        role: json['role'],
        id: json['_id'],
        favorites: json['favorites'].map((item) => item.toString()).toList());
  }
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "role": role,
      "confirmPassword": confirmPassword,
      "favorites": favorites,
    };
  }
}
