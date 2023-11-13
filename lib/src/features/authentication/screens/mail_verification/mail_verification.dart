import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/repository/authentication_repository/authentication_repository.dart';
import '../../controllers/mail_verification_controller.dart';

class MailVerification extends StatelessWidget {
  const MailVerification({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MailVerificationController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mark_email_read, size: 100),
                const SizedBox(height: tDefaultSize),
                const Text(
                  tEmailVerifyTitle,
                  style: TextStyle(fontSize: 32, fontFamily: tPacific),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: tDefaultSize),
                const Text(
                  tEmailVerifySubtitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: tDefaultSize),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.greenAccent)),
                    onPressed: () => controller.manuallyCheckVerificationCompleted(),
                    child: const Text(tContinue),
                  ),
                ),
                TextButton(
                  onPressed: () => controller.sendVerificationEmail(),
                  child: const Text(tResendEmail),
                ),
                const SizedBox(height: tDefaultSize),
                FilledButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black38)),
                  onPressed: () => AuthenticationRepository.instance.logout(),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_left),
                      SizedBox(width: 5),
                      Text(tBackToLogin),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
