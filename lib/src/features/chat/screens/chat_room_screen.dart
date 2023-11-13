import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:paywise_android/src/features/authentication/models/user_model.dart';
import 'package:paywise_android/src/features/chat/controller/chat_controller.dart';
import 'package:paywise_android/src/features/chat/models/chat_room_model.dart';
import 'package:paywise_android/src/features/payment/screens/send_money_screen.dart';
import '../../../../main.dart';
import '../../../constants/constants.dart';
import '../../payment/models/payment_room_model.dart';
import '../models/message_model.dart';

class ChatRoomScreen extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatRoom;
  final User firebaseUser;

  const ChatRoomScreen({
    super.key,
    required this.targetUser,
    required this.chatRoom,
    required this.firebaseUser,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();
    if (msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.firebaseUser.uid,
        createdOn: DateTime.now(),
        text: msg,
        seen: false,
      );
      FirebaseFirestore.instance.collection("ChatRooms").doc(widget.chatRoom.chatroomId).collection("messages").doc(newMessage.messageId).set(newMessage.toMap());
      widget.chatRoom.lastMessage = msg;
      FirebaseFirestore.instance.collection("ChatRooms").doc(widget.chatRoom.chatroomId).set(widget.chatRoom.toMap());
      print('Message sent');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
          color: Colors.black,
          iconSize: 30,
        ),
        backgroundColor: tWhiteColor,
        title: Row(
          children: [
            CircleAvatar(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.greenAccent,
                child: SvgPicture.asset(tPersonSvg, height: 35),
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.targetUser.fullName ?? 'Not fetched', style: const TextStyle(fontSize: 18, fontFamily: tPrimaryFamily, color: tDarkColor)),
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert_outlined, color: tDarkColor),
            onSelected: (dynamic v) {},
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<Object>> list = [];
              list.add(
                PopupMenuItem(
                  value: 1,
                  child: const Text(
                    'More features',
                    style: TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor),
                  ),
                  onTap: () => Fluttertoast.showToast(msg: "Coming soon!"),
                ),
              );
              return list;
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            //Message container
            Expanded(
              flex: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                color: Colors.white.withOpacity(0.1),
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection("ChatRooms").doc(widget.chatRoom.chatroomId).collection("messages").orderBy("createdOn", descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                        return ListView.builder(
                          itemCount: dataSnapshot.docs.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);
                            return Row(
                              mainAxisAlignment: (currentMessage.sender == widget.firebaseUser.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: (currentMessage.sender == widget.firebaseUser.uid) ? Colors.greenAccent : Colors.amberAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(currentMessage.text.toString(), style: const TextStyle(color: tDarkColor, fontFamily: tPrimaryFamily)),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'An error occurred! Please check your internet connection',
                            style: TextStyle(fontFamily: tPrimaryFamily),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'Start communicating by saying hi',
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
            //Send money button
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Obx(
                () => OutlinedButton.icon(
                  onPressed: () async {
                    PaymentRoomModel? paymentRoomModel = await controller.getPaymentRoomModel(widget.targetUser);
                    if (paymentRoomModel != null) {
                      Get.to(() => SendMoneyScreen(targetUser: widget.targetUser, paymentRoomModel: paymentRoomModel));
                    }
                  },
                  label: controller.isLoading.value
                      ? LoadingAnimationWidget.twistingDots(leftDotColor: Colors.red, rightDotColor: Colors.yellow, size: 30)
                      : const Text(
                          'SEND MONEY',
                          style: TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor, fontWeight: FontWeight.bold),
                        ),
                  icon: controller.isLoading.value ? const SizedBox() : const Icon(Icons.currency_rupee, color: tDarkColor, size: 30),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(tPrimaryColor!),
                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10)),
                      elevation: MaterialStateProperty.resolveWith((states) => 5)),
                ),
              ),
            ),
            //Enter message TextFormField
            Container(
              color: tPrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Message",
                        hintStyle: TextStyle(fontFamily: tPrimaryFamily, color: Colors.grey),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(Icons.send_sharp, color: Theme.of(context).primaryColor, size: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
