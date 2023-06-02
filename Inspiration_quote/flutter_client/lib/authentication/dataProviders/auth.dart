import 'dart:convert';
import 'package:flutter_client/utilities/urls.dart';
import 'package:http/http.dart' as http;

import '../models/loginModel.dart';
import '../models/user.dart';

class AuthDataProvider {
  Future<int> register(User user) async {
    const url = apiBaseURL;
    print("incoming data ${user.toJson()}");
    try {
      final response = await http.post(
        Uri.parse('$url/signup'),
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
          "Access-Control-Allow-Origin": "*"
        },
        body: json.encode(user.toJson()),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        return 0;
      }
    } catch (e) {
      print(e.toString());
    }
    return 1;
  }

  Future<List<User>> getAllUsers() async {
    const url = apiBaseURL;
    try {
      final response = await http.get(
        Uri.parse("$url/getallusers"),
      );
      var users = jsonDecode(response.body);
      return users.map((user) => User.fromJson(user)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception("Error while fetching users");
    }
  }

  Future<Map<String, dynamic>> login(LoginModel loginModel) async {
    const url = apiBaseURL;
    try {
      print("data");
      print(loginModel.toJson());
      var response = await http.post(
        Uri.parse("$url/login"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
          "Access-Control-Allow-Origin": "*"
        },
        body: json.encode(loginModel.toJson()),
      );
      print("status code ${response.statusCode}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {};
      }
    } catch (e) {
      print(
        e.toString(),
      );
      return {};
    }
  }

  Future<int> updateProfile(Map<String, dynamic> updateInfo) async {
    try {
      return 0;
    } catch (e) {
      return 1;
    }
  }

  Future<int> deleteProfile(int id) async {
    try {
      return 0;
    } catch (e) {
      return 1;
    }
  }
}
