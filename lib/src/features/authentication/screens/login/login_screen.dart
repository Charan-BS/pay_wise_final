import 'package:flutter/material.dart';
import 'package:paywise_android/src/constants/sizes.dart';
import 'package:paywise_android/src/utils/themes/elevated_button_theme.dart';

import 'login_form_widget.dart';
import 'login_header_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Theme(
          data: ThemeData(elevatedButtonTheme: ElevatedButtonCustomTheme.lightElevatedButtonTheme),
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoginHeaderWidget(size: size),
                  const LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
