import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/features/core/models/bank_model.dart';

import '../../../repository/user_repository/user_repository.dart';

class BankUpdateController extends GetxController {
  static BankUpdateController get instance => Get.find();
  //Repositories
  final _userRepo = Get.put(UserRepository());
  final isLoading = false.obs;

  getUserData() {
    return _userRepo.getUserBankDetails();
  }

  Future updateBankRecord(String? userId, String? acNo, String? ifscCode, String? bankName, String? accountHolderName) async {
    try {
      isLoading.value = true;
      final bankModel = BankModel(
        userId: userId,
        accountNumber: acNo,
        ifscCode: ifscCode,
        bankName: bankName,
        accountHolderName: accountHolderName,
      );
      await _userRepo.updateUserBankRecord(bankModel);
      print('updated successfully');
      isLoading.value = false;
      Get.snackbar(
        'Success',
        "User Bank details updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
      );
    } catch (e) {
      print(e.toString());
      isLoading.value = false;
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    }
  }
}
