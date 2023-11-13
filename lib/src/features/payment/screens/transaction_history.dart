import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../models/payment_message.dart';
import '../models/payment_message_room.dart';
import 'package:get/get.dart';

class TransactionHistory extends StatelessWidget {
  Future openEmailClient() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'charanbskollur@gmail.com',
      query: 'subject=Define%20your%20Problem%20here',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email';
    }
  }

  const TransactionHistory({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.chevron_left),
          color: Colors.black,
          iconSize: 30,
        ),
        backgroundColor: tWhiteColor,
        title: const Center(child: Text('History', style: TextStyle(fontSize: 18, fontFamily: tPrimaryFamily, color: tDarkColor))),
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
                    'Help',
                    style: TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor),
                  ),
                  onTap: () => openEmailClient(),
                ),
              );
              return list;
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("PaymentMessageRooms").where("participants.${FirebaseAuth.instance.currentUser?.uid}", isEqualTo: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot paymentMessageRoomSnapshot = snapshot.data as QuerySnapshot;
                if (paymentMessageRoomSnapshot.docs.isEmpty) {
                  return const Center(child: Text('No Transactions found'));
                }
                return ListView.builder(
                    itemCount: paymentMessageRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      PaymentMessageRoomModel paymentMessageRoomModel = PaymentMessageRoomModel.fromMap(paymentMessageRoomSnapshot.docs[index].data() as Map<String, dynamic>);
                      Map<String, dynamic> participants = paymentMessageRoomModel.participants!;
                      List<String> participantKeys = participants.keys.toList();
                      participantKeys.remove(FirebaseAuth.instance.currentUser?.uid);
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("PaymentMessageRooms")
                            .doc(paymentMessageRoomModel.paymentMessageRoomId)
                            .collection("paymentMessage")
                            .orderBy("paymentTime", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.active) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                            if (dataSnapshot.docs.isEmpty) {
                              return const Center(
                                  child: Text(
                                'No Transactions found',
                                style: TextStyle(fontFamily: tPrimaryFamily),
                              ));
                            }
                            List<Widget> paymentWidgets = [];
                            for (var paymentDocument in dataSnapshot.docs) {
                              PaymentMessage paymentMessage = PaymentMessage.fromMap(paymentDocument.data() as Map<String, dynamic>);
                              final timestamp = paymentDocument['paymentTime'] as Timestamp;
                              final formattedDate = DateFormat('dd MMMM yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch));
                              paymentWidgets.add(Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Text(formattedDate, style: const TextStyle(color: Colors.grey, fontFamily: tPrimaryFamily)),
                                  ),
                                  ListTile(
                                    title: (FirebaseAuth.instance.currentUser!.uid == paymentMessage.senderId)
                                        ? Text(
                                            'To: ${paymentMessage.receiverName}',
                                            style: const TextStyle(fontFamily: tPrimaryFamily),
                                          )
                                        : Text(
                                            'From: ${paymentMessage.senderName}',
                                            style: const TextStyle(fontFamily: tPrimaryFamily),
                                          ),
                                    subtitle: SelectableText(paymentMessage.paymentId ?? 'No reference',
                                        style: const TextStyle(
                                          color: Colors.brown,
                                          fontFamily: tPrimaryFamily,
                                        )),
                                    tileColor: paymentMessage.isProcessed ? Colors.green.withOpacity(0.4) : tPrimaryColor,
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        paymentMessage.isProcessed
                                            ? Text('\u{20B9}${paymentMessage.amount} success',
                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: tPrimaryFamily))
                                            : Text('\u{20B9}${paymentMessage.amount} pending',
                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: tPrimaryFamily)),
                                        const SizedBox(height: 10),
                                        Text('ACTION: ${paymentMessage.action!}', style: const TextStyle(color: Colors.black, fontFamily: tPrimaryFamily)),
                                      ],
                                    ),
                                  )
                                ],
                              ));
                            }
                            return Column(
                              children: paymentWidgets,
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.hasError.toString(),
                  ),
                );
              } else {
                return const Center(
                  //TODO:snapshot.data.docs.isNotEmpty condition should be checked with snapshot.hasData
                  child: Text('No users found'),
                );
              }
            } else {
              return const Center(
                child: Center(child: CircularProgressIndicator(color: Colors.blue)),
              );
            }
          },
        ),
      ),
    );
  }
}
