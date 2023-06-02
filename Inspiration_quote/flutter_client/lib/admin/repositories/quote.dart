import 'package:flutter_client/admin/dataproviders/remoteDataProvider.dart';

import '../models/quote.dart';

class QuoteRepository {
  final QuoteDataProvider dataProvider;
  QuoteRepository({required this.dataProvider});
  Future<int> createQuote(Quote quote, String token) async {
    return await dataProvider.createQuote(quote, token);
  }

  Future<int> updateQuote(Quote quote, String id, String token) async {
    return await dataProvider.updateQuote(quote, id, token);
  }

  Future<int> deleteQuote(String id, String token) async {
    return await dataProvider.deleteQuote(id, token);
  }

  Future<List<Quote>> getAll(String token) async {
    return await dataProvider.getAll(token);
  }

  Future<Quote> getQoute(String id, String token) async {
    return await dataProvider.getQoute(id, token);
  }
}
