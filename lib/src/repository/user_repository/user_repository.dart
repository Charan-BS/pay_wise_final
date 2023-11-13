import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/features/authentication/models/user_model.dart';
import 'package:paywise_android/src/features/core/models/bank_model.dart';
import '../../constants/constants.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
/*==============================User section=====================================*/

//Store user in firestore
  Future<void> createUserDocument(UserModel user) async {
    final currentUser = auth.currentUser; // Get the current user
    final userId = currentUser?.uid;
    return await _db
        .collection("Users")
        .doc(userId)
        .set(user.toJson())
        .whenComplete(
          () => Get.snackbar(
            "Success",
            "Your account has been created.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: tDarkColor,
          ),
        )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", error.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent.withOpacity(0.1), colorText: Colors.red);
    });
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _db.collection("Users").where('Email', isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>> allUsers(String email) async {
    final snapshot = await _db.collection("Users").where("Email", isNotEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<void> updateUserRecord(UserModel user, String id) async {
    await _db.collection("Users").doc(id).update({'FullName': user.fullName});
  }

/*==============================User Bank section=====================================*/
  //Store user in firestore
  Future<void> createUserBankDocument(BankModel bank) async {
    final currentUser = auth.currentUser;
    final userId = currentUser?.uid;
    return await _db.collection("Users").doc(userId).collection("BankDetails").doc(userId).set(bank.toJson());
  }

  Future<BankModel> getUserBankDetails() async {
    final currentUser = auth.currentUser;
    final userId = currentUser?.uid;
    final snapshot = await _db.collection("Users").doc(userId).collection("BankDetails").get();
    final bankData = snapshot.docs.map((e) => BankModel.fromSnapshot(e)).single;
    return bankData;
  }

  Future<void> updateUserBankRecord(BankModel bank) async {
    final currentUser = auth.currentUser;
    final userId = currentUser?.uid;
    await _db.collection("Users").doc(userId).collection("BankDetails").doc(userId).set(bank.toJson());
  }
}
