import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../../utils/helper/helper_controller.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final showPassword = false.obs;

  /// TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();

  ///Loader
  final isLoading = false.obs;

  ///EmailPasswordLogin
  Future<void> login() async {
    try {
      isLoading.value = true;
      final auth = AuthenticationRepository.instance;
      String? error = await auth.loginWithEmailAndPassword(email.text.trim(), password.text.trim());
      if (error == null) {
        auth.setInitialScreen(auth.firebaseUser);
        isLoading.value = false;
      } else {
        Helper.errorSnackBar(title: 'Error', message: error);
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      Helper.errorSnackBar(title: 'Oh snap', message: e.toString());
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      isLoading.value = true;
      final auth = AuthenticationRepository.instance;
      await auth.sendPasswordResetEmail(email);
      isLoading.value = false;
    } catch (e) {
      Helper.errorSnackBar(title: 'Error', message: e.toString());
      isLoading.value = false;
    }
  }

  Future<void> googleSignIn() async {
    try {
      isLoading.value = true;
      final auth = AuthenticationRepository.instance;
      await auth.signInWithGoogle();
      isLoading.value = false;
      auth.setInitialScreen(auth.firebaseUser);
    } catch (e) {
      isLoading.value = false;
      Helper.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
