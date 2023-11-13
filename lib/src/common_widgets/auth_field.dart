import 'package:flutter/material.dart';
import 'package:paywise_android/src/constants/constants.dart';

class AuthField extends StatelessWidget {
  final Color color;
  final TextEditingController? controller;
  final String hintText;
  final IconData iconData;
  final String labelText;
  final bool isEnabled;
  final bool obscure;
  final String? Function(String?)? validator;
  const AuthField({
    super.key,
    this.controller,
    this.obscure = false,
    required this.hintText,
    required this.iconData,
    required this.labelText,
    this.validator,
    required this.isEnabled,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnabled,
      validator: validator,
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(tDefaultSize - 8),
        hintText: hintText,
        hintStyle: const TextStyle(fontFamily: tPrimaryFamily),
        prefixIcon: Icon(iconData, color: color),
        labelText: labelText,
        labelStyle: const TextStyle(fontFamily: tPrimaryFamily),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: tGreyColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: tBlueColor)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
      ),
    );
  }
}
