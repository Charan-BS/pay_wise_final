import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/features/authentication/screens/login/login_screen.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Get.to(() => const LoginScreen());
          },
          child: Text.rich(
            TextSpan(children: [
              TextSpan(
                text: tAlreadyHaveAnAccount,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextSpan(text: tLogin.toUpperCase())
            ]),
          ),
        ),
      ],
    );
  }
}
