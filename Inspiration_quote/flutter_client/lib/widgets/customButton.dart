import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.backroundcolor,
    required this.displaytext,
    required this.onPressedfun,
    this.borderRadius = 30,
    this.height = 60,
  }) : super(key: key);

  final Color backroundcolor;
  final Widget displaytext;
  final Function() onPressedfun;
  final double height;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      height: height,
      child: ElevatedButton(
        onPressed: onPressedfun,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width - 50, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          primary: backroundcolor,
        ),
        child: displaytext,
      ),
    );
  }
}
