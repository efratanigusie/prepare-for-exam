import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_client/admin/repositories/quote.dart';
import 'package:meta/meta.dart';

import '../../models/quote.dart';

part 'quote_event.dart';
part 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final QuoteRepository quoteRepository;
  QuoteBloc({required this.quoteRepository}) : super(QuoteInitial()) {
    on<QuoteEvent>(
      (event, emit) async {
        if (event is GetAllQuotes) {
          emit(
            QuoteActionInProgress(),
          );
          try {
            var response = await quoteRepository.getAll(event.token);
            emit(
              AllQuotesFetched(quotes: response),
            );
          } catch (e) {
            print(e.toString());
            emit(
              QuoteActionFailed(
                message: e.toString(),
              ),
            );
          }
        }
        if (event is CreateQuote) {
          emit(
            QuoteActionInProgress(),
          );
          try {
            var response =
                await quoteRepository.createQuote(event.quote, event.token);
            if (response == 0) {
              emit(
                QuoteActionSucceeded(message: "Quote Created"),
              );
            } else {
              emit(
                QuoteActionFailed(message: "Failed"),
              );
            }
          } catch (e) {
            print(e.toString());
            emit(
              QuoteActionFailed(
                message: e.toString(),
              ),
            );
          }
        }
        if (event is UpdateQuote) {
          emit(
            QuoteActionInProgress(),
          );
          try {
            var response = await quoteRepository.updateQuote(
                event.quote, event.id, event.token);
            print("response is $response");
            if (response == 0) {
              emit(QuoteActionSucceeded(message: "Quote Updated"));
            } else {
              emit(
                QuoteActionFailed(
                  message: "Failed",
                ),
              );
            }
          } catch (e) {
            print(e.toString());
            emit(
              QuoteActionFailed(
                message: e.toString(),
              ),
            );
          }
        }
        if (event is DeleteQuote) {
          emit(
            QuoteActionInProgress(),
          );
          try {
            var response =
                await quoteRepository.deleteQuote(event.id, event.token);
            if (response == 0) {
              emit(QuoteActionSucceeded(message: "Quote Deleted"));
            } else {
              emit(
                QuoteActionFailed(
                  message: "Failed",
                ),
              );
            }
          } catch (e) {
            print(e.toString());
            emit(
              QuoteActionFailed(
                message: e.toString(),
              ),
            );
          }
        }
      },
    );
  }
}
