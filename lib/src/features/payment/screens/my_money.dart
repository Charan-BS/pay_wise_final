import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/features/payment/models/payment_message.dart';
import 'package:paywise_android/src/features/payment/models/payment_message_room.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/colors.dart';

class MyMoney extends StatelessWidget {
  const MyMoney({super.key});

  Future openEmailClient() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'charanbskollur@gmail.com',
      query: 'subject=Define%20your%20Complaint%20here',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: tDarkColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Center(
          child: Text(
            'Status of your money',
            style: TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor),
          ),
        ),
        backgroundColor: tPrimaryColor,
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.help_outline_sharp,
              color: tDarkColor,
            ),
            onSelected: (dynamic v) {},
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<Object>> list = [];
              list.add(PopupMenuItem(
                value: 1,
                child: const Text('Help !', style: TextStyle(color: tDarkColor, fontFamily: tPrimaryFamily)),
                onTap: () => openEmailClient(),
              ));
              return list;
            },
          )
        ],
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("PaymentMessageRooms")
              .where(
                "participants.${FirebaseAuth.instance.currentUser?.uid}",
                isEqualTo: true,
              )
              .snapshots(),
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
                                ),
                              );
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
                                    child: Text(
                                      formattedDate,
                                      style: const TextStyle(color: Colors.grey, fontFamily: tPrimaryFamily),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(paymentMessage.msg!,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: tPrimaryFamily,
                                        )),
                                    tileColor: paymentMessage.isProcessed ? Colors.green.withOpacity(0.4) : tPrimaryColor,
                                    trailing: Text(
                                      '\u{20B9}${paymentMessage.amount}',
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: tPrimaryFamily),
                                    ),
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                  //TODO:ssnapshot.data.docs.isNotEmpty condition should be checked with snapshot.hasData
                  child: Text('No users found'),
                );
              }
            } else {
              return const Center(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                ),
              );
            }
          },
        ),
      )),
    );
  }
}
