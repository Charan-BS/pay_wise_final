import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/constants/constants.dart';

class Helper extends GetxController {
  /* ----------------- Validating --------------------*/
  static String? validateName(String value) {
    if (value.isNotEmpty) {
      if (value.contains(' ')) {
        return "No white spaces allowed"; // Spaces in the middle, return an error
      } else if (value.length >= 15) {
        return "No more character than 15";
      }
    } else {
      return "This field cannot be empty"; // Empty input, return an error
    }
    return null;
  }

  static String? validateNotEmpty(value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "This field cannot be empty";
    }
  }

  static String? validateEmail(value) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!) ? null : "Please enter a valid email";
  }

  static String? validatePassword(value) {
    if (value!.length < 6) {
      return "Password must be at least 6 characters";
    } else {
      return null;
    }
  }

  static String? validateAccountNumber(value, rvalue) {
    if (value.isEmpty || rvalue.isEmpty) {
      return "Account number cannot be empty";
    }

    if (value != rvalue) {
      return "Account numbers do not match";
    }
    return null;
  }

  static String? validateAmount(value) {
    if (value.isEmpty) {
      return 'Amount cannot be empty';
    }

    if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
      return 'Invalid amount format';
    }

    final amount = double.tryParse(value);
    if (amount == null || amount < 0 || amount > 1000000) {
      return 'Amount must be between 0 and 10,00,000';
    }
    return null; // Validation passed
  }

/* ----------------- Snack-Bars --------------------*/

  static successSnackBar({required title, message}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: tWhiteColor,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(tDefaultSize - 10),
      icon: const Icon(Icons.check_circle, color: tWhiteColor),
      mainButton: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text('Okay', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  static errorSnackBar({required title, message}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: tDarkColor,
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(tDefaultSize - 10),
      icon: const Icon(Icons.check_circle, color: tWhiteColor),
      mainButton: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text('Okay', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
