import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/features/authentication/models/user_model.dart';
import 'package:paywise_android/src/features/chat/models/chat_room_model.dart';
import 'package:paywise_android/src/features/core/controllers/profile_controller.dart';
import 'package:paywise_android/src/features/core/screens/profile/profile_screen.dart';
import 'package:paywise_android/src/features/core/screens/profile/search_list_tile.dart';
import '../../../chat/screens/chat_room_screen.dart';

class SearchUser extends StatefulWidget {
  final TextEditingController searchController;
  final User? user;
  const SearchUser({super.key, required this.searchController, this.user});
  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: TextField(
          autofocus: true,
          controller: widget.searchController,
          onChanged: (value) {
            setState(() {});
          },
          onSubmitted: (value) {
            setState(() {});
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(tDefaultSize),
              ),
            ),
            hintText: tSearch,
            hintStyle: TextStyle(color: tGreyColor),
            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            prefixIcon: Icon(Icons.search),
          ),
        ),
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: FutureBuilder(
            future: controller.getAllUsers(),
            builder: (context, snapshot) {
              List<Widget> resultUsers = [];
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  if (!snapshot.hasData) {
                    return const Text('No user found');
                  }
                  if (snapshot.hasData) {
                    String userCurrentInput = widget.searchController.text.toLowerCase();
                    for (int index = 0; index < snapshot.data!.length; index++) {
                      final nameGotFromServer = snapshot.data?[index].fullName?.toLowerCase();
                      for (int length = 1; length <= nameGotFromServer!.length; length++) {
                        String serverSubstring = nameGotFromServer.substring(0, length).toLowerCase();
                        if (serverSubstring == userCurrentInput) {
                          UserModel? searchedUser = snapshot.data?[index];
                          resultUsers.add(
                            Column(
                              children: [
                                SearchListTile(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Center(child: LoadingAnimationWidget.discreteCircle(color: Colors.purpleAccent, size: 30));
                                      },
                                    );
                                    ChatRoomModel? chatroomModel = await controller.getChatroomModel(searchedUser!, widget.user);
                                    if (chatroomModel != null) {
                                      Get.off(
                                        () => ChatRoomScreen(
                                          targetUser: searchedUser,
                                          chatRoom: chatroomModel,
                                          firebaseUser: FirebaseAuth.instance.currentUser!,
                                        ),
                                      );
                                    }
                                  },
                                  title: snapshot.data?[index].fullName ?? 'Got fullName null',
                                  subTitle: snapshot.data?[index].email ?? 'Got email null',
                                  widget: controller.isLoading.value ? const Icon(Icons.downloading) : const Icon(Icons.person, size: 40),
                                ),
                                const SizedBox(height: 10)
                              ],
                            ),
                          );
                          break;
                        }
                      }
                    }
                    if (resultUsers.isEmpty) {
                      return const Center(
                        child: Text('No user found', style: TextStyle(fontFamily: tPrimaryFamily)),
                      );
                    }
                    return Column(
                      children: resultUsers,
                    );
                  } else {
                    return const Text(
                      'No user found',
                      style: TextStyle(fontFamily: tPrimaryFamily),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No users found',
                      style: TextStyle(fontFamily: tPrimaryFamily),
                    ),
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
