import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/admin/blocs/quote/quote_bloc.dart';
import 'package:flutter_client/admin/models/quote.dart';
import 'package:flutter_client/utilities/ColorPallets.dart';

class QuoteDetails extends StatelessWidget {
  QuoteDetails({Key? key, required this.id}) : super(key: key);
  final String id;
  var quotes = [];
  Quote? quote;
  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<QuoteBloc>(context).state;
    if (state is AllQuotesFetched) {
      quote = state.quotes.firstWhere((quote) => quote.id == id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(quote!.category),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(
                width: 1,
                color: Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                    color: Colors.deepPurple,
                    blurRadius: .3,
                    blurStyle: BlurStyle.outer)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Text(
                  "\"${quote!.body}\"",
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w300,
                    fontFamily: "PatrickHand",
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(),
                  Text(
                    "By: ${quote!.author}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QuoteDetailRow extends StatelessWidget {
  const QuoteDetailRow({Key? key, required this.title, required this.value})
      : super(key: key);
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: const TextStyle(
                fontFamily: "PatrickHand",
                fontSize: 18,
                decoration: TextDecoration.underline),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: "PatrickHand",
              fontSize: 18,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
