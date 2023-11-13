import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/features/payment/controllers/payment_controller.dart';
import 'package:paywise_android/src/features/payment/models/payment_message.dart';
import 'package:paywise_android/src/features/payment/models/payment_message_room.dart';
import 'package:paywise_android/src/features/payment/models/payment_room_model.dart';

import '../../../../main.dart';
import '../../../utils/helper/helper_controller.dart';
import '../models/payment_model.dart';
import '../screens/my_money.dart';
import '../screens/release_or_request/warning_dialog.dart';

class PaymentItemController extends GetxController {
  final isLoading = false.obs;
  final controller = Get.put(PaymentController());
  Future<PaymentMessageRoomModel> getPaymentMessageRoomModel(String? targetUserId) async {
    PaymentMessageRoomModel? paymentMessageRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("PaymentMessageRooms")
        .where("participants.${FirebaseAuth.instance.currentUser?.uid}", isEqualTo: true)
        .where("participants.${targetUserId.toString()}", isEqualTo: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data();
      PaymentMessageRoomModel existingPaymentMessageRoom = PaymentMessageRoomModel.fromMap(docData as Map<String, dynamic>);
      paymentMessageRoom = existingPaymentMessageRoom;
    } else {
      PaymentMessageRoomModel newPaymentMessageRoom = PaymentMessageRoomModel(
        paymentMessageRoomId: uuid.v1(),
        participants: {
          targetUserId.toString(): true,
          FirebaseAuth.instance.currentUser?.uid ?? '': true,
        },
      );
      await FirebaseFirestore.instance.collection("PaymentMessageRooms").doc(newPaymentMessageRoom.paymentMessageRoomId).set(newPaymentMessageRoom.toMap());
      PaymentMessageRoomModel().paymentMessageRoomId = newPaymentMessageRoom.paymentMessageRoomId;
      paymentMessageRoom = newPaymentMessageRoom;
    }
    return paymentMessageRoom;
  }

  Future<void> paymentConfirmation({
    required BuildContext context,
    String? action,
    required PaymentModel paymentModel,
    PaymentRoomModel? paymentRoomModel,
  }) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
              iconData: Icons.join_full,
              rightButton: '   YES   ',
              leftButton: '   NO   ',
              rightButtonOnTap: () async {
                if (action == "REFUND" || action == "RELEASE") {
                  isLoading.value = true;
                  PaymentMessageRoomModel paymentMessageRoomModel = await getPaymentMessageRoomModel(paymentModel.receiverId);
                  PaymentMessage paymentMessage = PaymentMessage(
                    senderToken: paymentModel.senderToken,
                    receiverToken: paymentModel.receiverToken,
                    isProcessed: false,
                    paymentMessageId: paymentModel.id,
                    action: action,
                    msg: action == "RELEASE"
                        ? "Amount of ${paymentModel.amount} has been released by ${paymentModel.senderName}.\nThe transaction will process in 1-2 business days."
                        : "Amount of ${paymentModel.amount} has been refunded by ${paymentModel.senderName}.\nThe transaction will process in 1-2 business days.Please contact us if you need any support.",
                    paymentId: paymentModel.paymentId,
                    amount: paymentModel.amount,
                    receiverId: paymentModel.receiverId,
                    senderId: paymentModel.senderId,
                    senderName: paymentModel.senderName,
                    receiverName: paymentModel.receiverName,
                    paymentTime: Timestamp.now(),
                  );
                  await FirebaseFirestore.instance
                      .collection("PaymentMessageRooms")
                      .doc(paymentMessageRoomModel.paymentMessageRoomId)
                      .collection("paymentMessage")
                      .doc(paymentMessage.paymentMessageId)
                      .set(paymentMessage.toMap());
                  controller.updatePaymentButtonState(paymentModel, paymentRoomModel);
                  isLoading.value = false;
                  Get.back();
                  Helper.successSnackBar(title: 'SUCCESS', message: '$action INITIATED SUCCESSFULLY\nCheck the status of your money in My money Section');
                  Get.off(() => const MyMoney());
                }
              },
              leftButtonOnTap: () {
                Navigator.of(context).pop();
              },
              warningMessage: 'DO YOU REALLY WANT TO $action THIS PAYMENT?');
        });
  }
}
