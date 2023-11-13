import 'package:flutter/material.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/features/authentication/screens/signup/signup_footer_widget.dart';
import 'package:paywise_android/src/features/authentication/screens/signup/signup_form_widget.dart';
import '../../../../utils/themes/elevated_button_theme.dart';
import 'form_header_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Theme(
          data: ThemeData(elevatedButtonTheme: ElevatedButtonCustomTheme.lightElevatedButtonTheme),
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: const SingleChildScrollView(
              child: Column(
                children: [
                  FormHeaderWidget(image: tAuthImage, title: tSignUpTitle, subTitle: tSignUpSubTitle, imageHeight: 0.20),
                  SignUpFormWidget(),
                  SignUpFooterWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
