import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_client/admin/blocs/quote/quote_bloc.dart';
import 'package:flutter_client/admin/models/quote.dart';
import 'package:flutter_client/appuser/repositories/favorite.dart';
import 'package:meta/meta.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteQuoteEvent, FavoriteState> {
  final FavoriteRepository favoriteRepository;
  FavoriteBloc({required this.favoriteRepository}) : super(FavoriteInitial()) {
    on<FavoriteQuoteEvent>((event, emit) async {
      if (event is AddToMyFavorites) {
        emit(
          FavoriteActionInProgress(),
        );
        try {
          var response = await favoriteRepository.addToFavorite(
              event.token, event.quoteId, event.userId);
          if (response == 0) {
            emit(
              FavoriteActionSucceeded(message: "Success"),
            );
          } else {
            emit(
              FavoriteActionFailed(message: "Failed"),
            );
          }
        } catch (e) {
          print(
            e.toString(),
          );
          emit(
            FavoriteActionFailed(message: "Server Error"),
          );
        }
      }
      if (event is RemoveFromMyFavorites) {
        emit(
          FavoriteActionInProgress(),
        );
        try {
          var response = await favoriteRepository.removeFromMyFavorites(
              event.token, event.quoteId, event.userId);
          if (response == 0) {
            emit(
              FavoriteActionSucceeded(message: "Success"),
            );
          } else {
            emit(
              FavoriteActionFailed(message: "Failed"),
            );
          }
        } catch (e) {
          print(
            e.toString(),
          );
          emit(
            FavoriteActionFailed(message: "Server Error"),
          );
        }
      }
      if (event is GetFavoriteQuotes) {
        emit(
          FavoriteActionInProgress(),
        );
        try {
          var response = await favoriteRepository.getFavoiteQuotes(
              event.token, event.userId);
          emit(
            FavoriteQuotesFetched(quotes: response),
          );
        } catch (e) {
          emit(FavoriteActionFailed(message: "Failed to Fetched Favorites"));
        }
      }
    });
  }
}
