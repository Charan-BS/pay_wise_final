import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paywise_android/src/features/payment/models/payment_model.dart';
import 'package:paywise_android/src/features/payment/screens/release_or_request/payment_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants/constants.dart';
import '../../models/payment_room_model.dart';

class ReleaseOrRequestScreen extends StatelessWidget {
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

  const ReleaseOrRequestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: tDarkColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Center(
          child: Text(
            'Release or Request Money',
            style: TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor),
          ),
        ),
        backgroundColor: tPrimaryColor,
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert_outlined,
              color: tDarkColor,
            ),
            onSelected: (dynamic v) {},
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<Object>> list = [];
              list.add(
                PopupMenuItem(
                  value: 1,
                  child: const Text(
                    'Help !',
                    style: TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor),
                  ),
                  onTap: () {
                    openEmailClient();
                  },
                ),
              );
              return list;
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("PaymentRooms")
                  .where(
                    "participants.${FirebaseAuth.instance.currentUser?.uid}",
                    isEqualTo: true,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot paymentRoomSnapshot = snapshot.data as QuerySnapshot;
                    if (paymentRoomSnapshot.docs.isEmpty) {
                      return const Center(
                          child: Text(
                        'No Transactions found',
                        style: TextStyle(fontFamily: tPrimaryFamily),
                      ));
                    }
                    if (snapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        itemCount: paymentRoomSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          PaymentRoomModel paymentRoomModel = PaymentRoomModel.fromMap(paymentRoomSnapshot.docs[index].data() as Map<String, dynamic>);
                          Map<String, dynamic> participants = paymentRoomModel.participants!;
                          List<String> participantKeys = participants.keys.toList();
                          participantKeys.remove(FirebaseAuth.instance.currentUser?.uid);
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("PaymentRooms")
                                .doc(paymentRoomModel.paymentRoomId)
                                .collection("payments")
                                .orderBy("paymentTime", descending: true)
                                .snapshots(),
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.active) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                                List<Widget> transactionWidgets = [];
                                for (var paymentDocument in dataSnapshot.docs) {
                                  PaymentModel paymentModel = PaymentModel.fromMap(paymentDocument.data() as Map<String, dynamic>);
                                  final timestamp = paymentDocument['paymentTime'] as Timestamp;
                                  final formattedDate = DateFormat('dd MMMM yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch));
                                  transactionWidgets.add(
                                    PaymentListTile(
                                      paymentRoomModel: paymentRoomModel,
                                      paymentModel: paymentModel,
                                      formattedDate: formattedDate,
                                    ),
                                  );
                                }
                                return Column(
                                  children: transactionWidgets,
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                    //To do implemented but returned a container at the end
                    return Container();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.hasError.toString()),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No users found',
                        style: TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor),
                      ),
                    );
                  }
                } else {
                  return const Center(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
// List<QueryDocumentSnapshot> paymentDocuments = dataSnapshot.docs;
//                                 paymentDocuments = paymentDocuments.reversed.toList();
//                                 for (var paymentDocument in paymentDocuments) {
