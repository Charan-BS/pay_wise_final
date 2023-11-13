import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/repository/authentication_repository/authentication_repository.dart';
import '../../../utils/helper/helper_controller.dart';

class MailVerificationController extends GetxController {
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    sendVerificationEmail();
    setTimerForAutoRedirect();
  }

  //Send of resend Email verification
  Future<void> sendVerificationEmail() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      Helper.successSnackBar(title: 'Success', message: 'Verification email sent successfully');
    } catch (e) {
      Helper.errorSnackBar(title: 'Oh snap, something went wrong!', message: e.toString());
      print(e.toString());
    }
  }

  //Set timer to check if verification completed then redirect
  void setTimerForAutoRedirect() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user!.emailVerified) {
        timer.cancel();
        Helper.successSnackBar(title: 'Logged In successfully', message: 'Go to profile section to learn more about the app');
        AuthenticationRepository.instance.setInitialScreen(user);
      }
    });
  }

  //Manually check if verification completed then redirect
  void manuallyCheckVerificationCompleted() async {
    FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user!.emailVerified) {
      Helper.successSnackBar(title: 'Logged In successfully', message: 'Go to profile section to learn more about the app');
      AuthenticationRepository.instance.setInitialScreen(user);
    } else {
      Helper.errorSnackBar(title: 'Please check your email', message: 'Email is not verified yet');
    }
  }
}
