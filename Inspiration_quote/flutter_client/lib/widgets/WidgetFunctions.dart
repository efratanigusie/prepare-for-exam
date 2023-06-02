import 'package:flutter/material.dart';

class WidgetFunctions {
  static Widget showInfo({required String title, String subtitle = ""}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info, size: 40, color: Colors.blueAccent),
          const SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: const TextStyle(
              fontFamily: "PatrickHand",
              fontSize: 20,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: "PatrickHand",
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
