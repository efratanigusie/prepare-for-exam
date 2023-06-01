part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteState extends Equatable {}

class FavoriteInitial extends FavoriteState {
  @override
  List<Object?> get props => [];
}

class FavoriteActionInProgress extends FavoriteState {
  @override
  List<Object?> get props => [];
}

class FavoriteActionSucceeded extends FavoriteState {
  final String message;
  FavoriteActionSucceeded({required this.message});
  @override
  List<Object?> get props => [message];
}

class FavoriteActionFailed extends FavoriteState {
  final String message;
  FavoriteActionFailed({required this.message});
  @override
  List<Object?> get props => [message];
}

class FavoriteQuotesFetched extends FavoriteState {
  final List<Quote> quotes;
  FavoriteQuotesFetched({required this.quotes});
  @override
  List<Object?> get props => [quotes];
}
