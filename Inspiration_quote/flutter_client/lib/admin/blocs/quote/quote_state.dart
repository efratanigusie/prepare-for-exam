part of 'quote_bloc.dart';

@immutable
abstract class QuoteState extends Equatable {}

class QuoteInitial extends QuoteState {
  @override
  List<Object?> get props => [];
}

class QuoteActionInProgress extends QuoteState {
  @override
  List<Object?> get props => [];
}

class QuoteActionSucceeded extends QuoteState {
  final String message;
  QuoteActionSucceeded({required this.message});
  @override
  List<Object?> get props => [message];
}

class QuoteActionFailed extends QuoteState {
  final String message;
  QuoteActionFailed({required this.message});
  @override
  List<Object?> get props => [message];
}

class AllQuotesFetched extends QuoteState {
  final List<Quote> quotes;
  AllQuotesFetched({required this.quotes});
  @override
  List<Object?> get props => [quotes];
}
