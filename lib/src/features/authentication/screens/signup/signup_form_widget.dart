import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/common_widgets/auth_field.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/features/authentication/controllers/signup_controller.dart';
import 'package:paywise_android/src/features/authentication/screens/bank_details/bank_details.dart';
import '../../../../api/notification_services.dart';
import '../../../../utils/helper/helper_controller.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({Key? key}) : super(key: key);
  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    notificationServices.requestNotificationPermission();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
    SignUpController controller = Get.put(SignUpController());
    return Form(
      key: signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: tFormHeight - 20),
          AuthField(
            validator: (String? value) => Helper.validateName(value.toString()),
            controller: controller.fullName,
            hintText: tFullName,
            iconData: Icons.person_outline_rounded,
            labelText: tFullName,
            isEnabled: true,
          ),
          const SizedBox(height: tFormHeight - 20),
          AuthField(
            validator: (value) => Helper.validateEmail(value),
            controller: controller.email,
            hintText: tEmail,
            iconData: Icons.email_outlined,
            labelText: tEmail,
            isEnabled: true,
          ),
          const SizedBox(height: tFormHeight - 20),
          AuthField(
            validator: (value) => Helper.validatePassword(value),
            controller: controller.password,
            hintText: tPassword,
            iconData: Icons.fingerprint,
            labelText: tPassword,
            isEnabled: true,
            obscure: true,
          ),
          const SizedBox(height: tFormHeight - 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (signupFormKey.currentState!.validate()) {
                  Get.to(() => const BankDetails());
                }
              },
              icon: const Icon(Icons.login),
              label: Text(
                tNext.toUpperCase(),
                style: const TextStyle(fontFamily: tFatFace, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
