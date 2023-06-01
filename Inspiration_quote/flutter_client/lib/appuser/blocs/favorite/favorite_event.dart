part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteQuoteEvent extends Equatable {}

class AddToMyFavorites extends FavoriteQuoteEvent {
  final String token;
  final String quoteId;
  final String userId;
  AddToMyFavorites(
      {required this.token, required this.quoteId, required this.userId});
  @override
  List<Object?> get props => [token, quoteId, userId];
}

class RemoveFromMyFavorites extends FavoriteQuoteEvent {
  final String token;
  final String quoteId;
  final String userId;
  RemoveFromMyFavorites(
      {required this.token, required this.quoteId, required this.userId});
  @override
  List<Object?> get props => [token, quoteId, userId];
}

class GetFavoriteQuotes extends FavoriteQuoteEvent {
  final String userId;
  final String token;
  GetFavoriteQuotes({required this.userId, required this.token});
  @override
  List<Object?> get props => [userId, token];
}
