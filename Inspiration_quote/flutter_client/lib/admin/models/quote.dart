import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  String body;
  String category;
  String author;
  String? id;

  Quote(
      {required this.author,
      this.id,
      required this.category,
      required this.body});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      author: json['author'],
      category: json['category'],
      body: json['body'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "body": body,
      "category": category,
      "author": author,
    };
  }

  @override
  List<Object?> get props => [body, author, category];
}
