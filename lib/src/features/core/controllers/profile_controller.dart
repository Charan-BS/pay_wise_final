import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/features/authentication/models/user_model.dart';
import 'package:paywise_android/src/repository/authentication_repository/authentication_repository.dart';
import 'package:paywise_android/src/repository/user_repository/user_repository.dart';
import '../../../../main.dart';
import '../../chat/models/chat_room_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  //Repositories
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  final isLoading = false.obs;

  //Get user email and pass to userRepository to fetch user record.
  getUserData() {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      //delete mail form backend and check
      Get.snackbar("Error", "Login to continue");
    }
  }

  //Fetch list of user records
  Future<List<UserModel>> getAllUsers() async {
    String? email = _authRepo.firebaseUser?.email;
    return await _userRepo.allUsers(email!);
  }

  updateRecord(String email, String fullName, String id) async {
    try {
      isLoading.value = true;
      final userModel = UserModel(fullName: fullName, email: email, id: id);
      await _userRepo.updateUserRecord(userModel, id);
      isLoading.value = false;
      Get.snackbar('Success', "User data updated successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser, User? user) async {
    isLoading.value = true;
    ChatRoomModel? chatRoom;
    final cUid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("ChatRooms").where("participants.${user?.uid}", isEqualTo: true).where("participants.${targetUser.id}", isEqualTo: true).get();
    if (snapshot.docs.isNotEmpty) {
      print('chatroom found');
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatroom;
      isLoading.value = false;
    } else {
      print('chatroom not found');
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomId: uuid.v1(),
        lastMessage: "",
        participants: {targetUser.id.toString(): true, cUid: true},
      );
      await FirebaseFirestore.instance.collection("ChatRooms").doc(newChatroom.chatroomId).set(newChatroom.toMap());
      chatRoom = newChatroom;
      isLoading.value = false;
    }
    return chatRoom;
  }
}
