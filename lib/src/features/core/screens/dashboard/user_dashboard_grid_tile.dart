import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../constants/constants.dart';
import '../../../authentication/models/user_model.dart';
import '../../../chat/models/chat_room_model.dart';
import '../../../chat/models/firebase_helper.dart';
import '../../../chat/screens/chat_room_screen.dart';

class UserDashboardGridTile extends StatelessWidget {
  final ScrollController? controller;
  const UserDashboardGridTile({super.key, this.controller});
  //it should be required
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
        height: screenHeight * 0.3,
        width: screenWidth * 0.90,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("ChatRooms").where("participants.${FirebaseAuth.instance.currentUser?.uid}", isEqualTo: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;
                if (chatRoomSnapshot.docs.isEmpty) {
                  return const Center(
                    child: Text('No users found'),
                  );
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 1, crossAxisSpacing: 0, childAspectRatio: 1.0),
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: controller,
                  itemCount: chatRoomSnapshot.docs.length,
                  itemBuilder: (context, index) {
                    ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(chatRoomSnapshot.docs[index].data() as Map<String, dynamic>);
                    Map<String, dynamic> participants = chatRoomModel.participants!;
                    List<String> participantKeys = participants.keys.toList();
                    participantKeys.remove(FirebaseAuth.instance.currentUser?.uid);
                    return FutureBuilder(
                        future: FirebaseHelper.getUserModelById(participantKeys[0]),
                        builder: (context, userData) {
                          if (userData.connectionState == ConnectionState.done) {
                            UserModel targetUser = userData.data as UserModel;
                            return GridTile(
                                child: InkWell(
                              onTap: () {
                                Get.to(
                                  () => ChatRoomScreen(
                                    targetUser: targetUser,
                                    chatRoom: chatRoomModel,
                                    firebaseUser: FirebaseAuth.instance.currentUser!,
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: tPrimaryColor,
                                    child: Text(targetUser.fullName?.substring(0, 1).toUpperCase() ?? '*',
                                        style: const TextStyle(color: tDarkColor, fontWeight: FontWeight.w500, fontSize: 20)),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    targetUser.fullName!.length <= 8 ? targetUser.fullName!.toString() : '${targetUser.fullName!.substring(0, 7)}...',
                                    style: const TextStyle(color: tDarkColor),
                                  ),
                                ],
                              ),
                            ));
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        });
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.hasError.toString()));
              } else {
                return const Center(
                  //TODO:snapshot.data.docs.isNotEmpty condition should be checked with snapshot.hasData
                  child: Text('No users found'),
                );
              }
            } else {
              return Container();
            }
          },
        ));
  }
}
