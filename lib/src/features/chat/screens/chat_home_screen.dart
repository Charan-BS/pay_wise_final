import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/features/chat/models/firebase_helper.dart';
import 'package:paywise_android/src/features/chat/screens/chat_room_screen.dart';
import '../../authentication/models/user_model.dart';
import '../../core/screens/profile/profile_screen.dart';
import '../models/chat_room_model.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});
  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
          color: Colors.black,
          iconSize: 30,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text('Connected Users', style: TextStyle(fontFamily: tPrimaryFamily, color: Colors.black)),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () => Get.to(() => const ProfileScreen()),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 1),
                  shape: BoxShape.circle,
                  color: tWhiteColor,
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.person, color: Colors.green, size: 25),
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("ChatRooms").where("participants.${FirebaseAuth.instance.currentUser?.uid}", isEqualTo: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;
                  if (chatRoomSnapshot.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'No users found\nPlease search for a user on home screen',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: tPrimaryFamily, fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              'Go Back To Home',
                              style: TextStyle(fontFamily: tPrimaryFamily, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (chatRoomSnapshot.docs.isNotEmpty) {
                    print(chatRoomSnapshot.docs.length);
                    return ListView.builder(
                      itemCount: chatRoomSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data() as Map<String, dynamic>,
                        );
                        Map<String, dynamic> participants = chatRoomModel.participants!;
                        List<String> participantKeys = participants.keys.toList();
                        participantKeys.remove(FirebaseAuth.instance.currentUser?.uid);
                        return FutureBuilder(
                          future: FirebaseHelper.getUserModelById(participantKeys[0]),
                          builder: (context, userData) {
                            if (userData.connectionState == ConnectionState.done) {
                              UserModel targetUser = userData.data as UserModel;
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: tPrimaryColor,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: tWhiteColor,
                                        child: SvgPicture.asset(tPersonSvg, height: 35),
                                      ),
                                      trailing: const Icon(Icons.keyboard_arrow_right),
                                      title: Text(
                                        targetUser.fullName.toString(),
                                        style: const TextStyle(fontFamily: tPrimaryFamily),
                                      ),
                                      subtitle: Text(
                                        chatRoomModel.lastMessage.toString(),
                                        style: const TextStyle(fontFamily: tPrimaryFamily, fontSize: 12),
                                      ),
                                      onTap: () {
                                        Get.to(
                                          () => ChatRoomScreen(
                                            targetUser: targetUser,
                                            chatRoom: chatRoomModel,
                                            firebaseUser: FirebaseAuth.instance.currentUser!,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            } else {
                              return Center(
                                child: LoadingAnimationWidget.halfTriangleDot(color: Colors.black38, size: 40),
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                  return Container();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.hasError.toString(), style: TextStyle(fontFamily: tPrimaryFamily, fontSize: 14)),
                  );
                } else {
                  return const Center(
                    //TODO:snapshot.data.docs.isNotEmpty condition should be checked with snapshot.hasData
                    child: Text(
                      'No users found',
                      style: TextStyle(fontFamily: tPrimaryFamily, fontSize: 14),
                    ),
                  );
                }
              } else {
                return Lottie.asset(
                  tLoadingRocketLottie,
                  height: 100,
                  width: 100,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
