import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/features/authentication/controllers/login_controller.dart';
import 'package:paywise_android/src/utils/themes/elevated_button_theme.dart';
import '../../../../../common_widgets/button_loading_widget.dart';
import '../../../../../constants/image_strings.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../../utils/helper/helper_controller.dart';
import '../../signup/form_header_widget.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
    final email = TextEditingController();
    final controller = Get.put(LoginController());
    return SafeArea(
      child: Scaffold(
        body: Theme(
          data: ThemeData(
            elevatedButtonTheme: ElevatedButtonCustomTheme.lightElevatedButtonTheme,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(tDefaultSize),
              child: Column(
                children: [
                  const SizedBox(height: tDefaultSize),
                  FormHeaderWidget(
                    image: tForgotPasswordImage,
                    title: tForgetPassword.toUpperCase(),
                    subTitle: tForgetPasswordSubTitle,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    heightBetween: 30.0,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: tFormHeight),
                  Form(
                    key: forgotPasswordFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            return Helper.validateEmail(value);
                          },
                          controller: email,
                          decoration: const InputDecoration(
                            label: Text(tEmail),
                            hintText: tEmail,
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (forgotPasswordFormKey.currentState!.validate()) {
                                  controller.sendPasswordReset(email.text.trim());
                                }
                              },
                              label: controller.isLoading.value ? const ButtonLoadingWidget() : const Text('Send Reset Email'),
                              icon: controller.isLoading.value ? const SizedBox() : const Icon(Icons.send_to_mobile_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
