import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/features/authentication/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../../repository/user_repository/user_repository.dart';
import '../../core/models/bank_model.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  //Loader
  final isLoading = false.obs;
  //other
  final userRepo = Get.put(UserRepository());
  final auth = AuthenticationRepository.instance;

  //textEditingControllers
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final acNo = TextEditingController();
  final rAcNo = TextEditingController();
  final ifsc = TextEditingController();
  final bankName = TextEditingController();
  final acHolder = TextEditingController();

  //Function to register user with email and password
  Future<void> createUser(String email, String password, String fullName, String? deviceToken) async {
    try {
      isLoading.value = true;
      UserCredential? userCredential = await auth.createUserWithEmailAndPassword(email, password);
      if (userCredential != null) {
        String? uId = userCredential.user?.uid;
        userCredential.user?.updateDisplayName(fullName);
        final user = UserModel(fullName: fullName, email: email, id: uId, deviceToken: deviceToken);
        await userRepo.createUserDocument(user);
        final bankData = BankModel(
          userId: FirebaseAuth.instance.currentUser?.uid,
          accountNumber: acNo.text.trim(),
          ifscCode: ifsc.text.trim(),
          bankName: bankName.text.trim(),
          accountHolderName: acHolder.text.trim(),
        );
        await userRepo.createUserBankDocument(bankData);
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5));
    }
  }
}
