import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/common_widgets/auth_field.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/features/authentication/controllers/login_controller.dart';
import 'package:paywise_android/src/features/authentication/screens/signup/signup_screen.dart';
import '../../../../common_widgets/button_loading_widget.dart';
import '../../../../utils/helper/helper_controller.dart';
import '../forget_password/forget_password_options/forget_password_bottom_sheet.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight),
      child: Form(
        key: loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthField(
              validator: (value) {
                return Helper.validateEmail(value);
              },
              controller: controller.email,
              hintText: tEmail,
              iconData: Icons.email_outlined,
              labelText: tEmail,
              isEnabled: true,
            ),
            const SizedBox(height: tFormHeight),
            AuthField(
              validator: (value) {
                return Helper.validatePassword(value);
              },
              controller: controller.password,
              hintText: tPassword,
              iconData: Icons.fingerprint,
              labelText: tPassword,
              isEnabled: true,
              obscure: true,
            ),
            const SizedBox(height: tFormHeight - 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ForgetPasswordScreen.buildShowModalBottomSheet(context);
                },
                child: const Text(tForgetPassword),
              ),
            ),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (loginFormKey.currentState!.validate()) {
                      LoginController.instance.login();
                    }
                  },
                  icon: controller.isLoading.value ? const SizedBox() : const Icon(Icons.login),
                  label: controller.isLoading.value
                      ? const ButtonLoadingWidget()
                      : Text(
                          tLogin.toUpperCase(),
                          style: const TextStyle(fontFamily: tFatFace),
                        ),
                ),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Get.to(() => const SignUpScreen());
                },
                child: Text.rich(
                  TextSpan(text: tDontHaveAnAccount, style: Theme.of(context).textTheme.bodyLarge, children: const [
                    TextSpan(
                      text: tCreateAccount,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
