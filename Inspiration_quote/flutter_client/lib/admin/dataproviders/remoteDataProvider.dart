import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter_client/admin/models/quote.dart';
import 'package:flutter_client/localDB/localdatabase.dart';
import 'package:flutter_client/utilities/urls.dart';
import 'package:http/http.dart' as http;

class QuoteDataProvider {
  Future<int> createQuote(Quote quote, String token) async {
    const url = apiBaseURL;
    try {
      var response = await http.post(
        Uri.parse("$url/quote"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(quote.toJson()),
      );
      print("response in dp is ${jsonDecode(response.body)}");
      print("Status is ${response.statusCode}");
      if (response.statusCode == 201) {
        return 0;
      } else {
        return 1;
      }
    } catch (e) {
      print(
        e.toString(),
      );
      return 1;
    }
  }

  Future<int> updateQuote(Quote quote, String id, String token) async {
    const url = apiBaseURL;
    try {
      var response = await http.put(
        Uri.parse("$url/quote/$id"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(quote.toJson()),
      );
      if (response.statusCode == 204) {
        return 0;
      } else {
        return 1;
      }
    } catch (e) {
      print(
        e.toString(),
      );
      return 1;
    }
  }

  Future<int> deleteQuote(String id, String token) async {
    const url = apiBaseURL;
    try {
      var response = await http.delete(
        Uri.parse("$url/quote/$id"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 204) {
        return 0;
      } else {
        return 1;
      }
    } catch (e) {
      print(
        e.toString(),
      );
      return 1;
    }
  }

  Future<List<Quote>> getAll(String token) async {
    const url = apiBaseURL;
    List<Quote> quotes = [];
    try {
      var response = await http.get(
        Uri.parse("$url/quote"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['quotes'];
        LocalCache.db.deleteAllQuotes(type: "quotes");
        for (var item in data) {
          print("item $item");
          LocalCache.db.createQuote(Quote.fromJson(item), type: "quotes");
        }
      } else {
        throw Exception("Error while fetching quotes");
      }
    } catch (e) {
      print(e.toString());
    }
    return await LocalCache.db.getAllQuotes(type: "quotes");
  }

  Future<Quote> getQoute(String id, String token) async {
    const url = apiBaseURL;
    try {
      var response = await http.get(
        Uri.parse("$url/quote/$id"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        return Quote.fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw Exception("Error while fetching quote");
      }
    } catch (e) {
      print(e.toString());
      throw Exception("Error while fetching quote");
    }
  }
}
