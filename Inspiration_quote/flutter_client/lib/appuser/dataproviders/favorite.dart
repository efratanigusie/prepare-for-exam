import 'dart:convert';
import 'dart:io';

import 'package:flutter_client/admin/dataproviders/remoteDataProvider.dart';
import 'package:flutter_client/admin/models/quote.dart';
import 'package:flutter_client/localDB/localdatabase.dart';
import 'package:flutter_client/utilities/urls.dart';
import 'package:http/http.dart' as http;

class FavoriteDataProvider {
  Future<int> addToFavorite(
    String token,
    String quoteId,
    String userId,
  ) async {
    var allQuotes = await QuoteDataProvider().getAll(token);
    var quote = allQuotes.firstWhere((quote) => quote.id == quoteId);
    try {
      const url = apiBaseURL;
      var response = await http.post(
        Uri.parse("$url/quote/favorite/$userId"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({"quoteId": quoteId}),
      );
      print("response is ");
      print(
        jsonDecode(response.body),
      );
      if (response.statusCode == 201) {
        return 0;
      } else {
        return 1;
      }
    } on SocketException {
      print("Socket Exeption");
      LocalCache.db.addToFavorites(quote);
      return 0;
    } catch (e) {
      print("Exception is ");
      print(
        e.toString(),
      );
      return 1;
    }
  }

  Future<int> removeFromMyFavorites(
    String token,
    String quoteId,
    String userId,
  ) async {
    try {
      const url = apiBaseURL;
      print("favorite remove request is comming in DP");
      var response = await http.delete(
        Uri.parse("$url/quote/favorite/$userId"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"quoteId": quoteId}),
      );
      print("favorite delete status code: ${response.statusCode}");
      if (response.statusCode == 204) {
        return 0;
      } else {
        return 1;
      }
    } on SocketException {
      print("Socket Exception");
      LocalCache.db.removeFromFavorites(quoteId);
      return 0;
    } catch (e) {
      print("Exception is ");
      print(
        e.toString(),
      );
      return 1;
    }
  }

  Future<List<Quote>> getFavoiteQuotes(String token, String userId) async {
    print("Get Favorite Qutoes request");
    try {
      const url = apiBaseURL;
      var response = await http.get(
        Uri.parse("$url/quote/favorite/$userId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var quotes = await jsonDecode(response.body)['favorites'];
        LocalCache.db.deleteAllQuotes(type: "favorites");
        for (var item in quotes) {
          LocalCache.db.createQuote(Quote.fromJson(item), type: "favorites");
        }
      } else {
        throw Exception("Error while feching favorites");
      }
    } on SocketException {
      print("This is Socket Exception");
    } catch (e) {
      throw Exception("Error while feching favorites");
    }
    print("After Exception");
    return await LocalCache.db.getAllQuotes(type: "favorites");
  }
}
