import 'package:flutter_client/appuser/dataproviders/favorite.dart';

import '../../admin/models/quote.dart';

class FavoriteRepository {
  final FavoriteDataProvider favoriteDataProvider;
  FavoriteRepository({required this.favoriteDataProvider});

  Future<int> addToFavorite(
    String token,
    String quoteId,
    String userId,
  ) async {
    return await favoriteDataProvider.addToFavorite(token, quoteId, userId);
  }

  Future<int> removeFromMyFavorites(
    String token,
    String quoteId,
    String userId,
  ) async {
    return await favoriteDataProvider.removeFromMyFavorites(
        token, quoteId, userId);
  }

  Future<List<Quote>> getFavoiteQuotes(String token, String userId) async {
    return await favoriteDataProvider.getFavoiteQuotes(token, userId);
  }
}
