import 'package:flutter/material.dart';
import '../utilities/ColorPallets.dart';

Widget customTextField(IconData icon, bool isPassword, bool isEmail,
    {required TextEditingController controller,
    String? Function(String?)? validator,
    String? lableText,
    String? hintText,
    double padding = 8}) {
  return Padding(
    padding: EdgeInsets.only(bottom: padding),
    child: TextFormField(
      validator: validator,
      obscureText: isPassword,
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: ColorPalettes.iconColor,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorPalettes.textColor1),
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorPalettes.textColor1),
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
        ),
        contentPadding: const EdgeInsets.all(10),
        labelText: hintText,
        hintText: lableText,
        hintStyle:
            const TextStyle(fontSize: 14, color: ColorPalettes.textColor1),
      ),
    ),
  );
}
