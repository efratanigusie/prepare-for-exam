part of 'quote_bloc.dart';

@immutable
abstract class QuoteEvent extends Equatable {}

class GetAllQuotes extends QuoteEvent {
  String token;
  GetAllQuotes({required this.token});
  @override
  List<Object?> get props => [];
}

class GetQuote extends QuoteEvent {
  final String id;
  final String token;

  GetQuote({required this.id, required this.token});
  @override
  List<Object?> get props => [id];
}

class CreateQuote extends QuoteEvent {
  final String token;
  final Quote quote;
  CreateQuote({required this.token, required this.quote});
  @override
  List<Object?> get props => [token, quote];
}

class UpdateQuote extends QuoteEvent {
  final String id;
  final String token;
  final Quote quote;
  UpdateQuote({required this.id, required this.token, required this.quote});
  @override
  List<Object?> get props => [id, token, quote];
}

class DeleteQuote extends QuoteEvent {
  final String id;
  final String token;
  DeleteQuote({required this.id, required this.token});
  @override
  List<Object?> get props => [id, token];
}
