import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/features/payment/models/payment_model.dart';
import 'package:paywise_android/src/features/payment/models/payment_room_model.dart';

import '../../controllers/payment_item_controller.dart';

class PaymentListTile extends StatefulWidget {
  final PaymentModel paymentModel;
  final String formattedDate;
  final PaymentRoomModel paymentRoomModel;
  const PaymentListTile({
    required this.paymentModel,
    required this.formattedDate,
    required this.paymentRoomModel,
    super.key,
  });
  @override
  State<PaymentListTile> createState() => _PaymentListTileState();
}

class _PaymentListTileState extends State<PaymentListTile> {
  PaymentItemController paymentItemController = Get.put(PaymentItemController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: Text(widget.formattedDate, style: const TextStyle(color: Colors.grey, fontFamily: tPrimaryFamily)),
        ),
        ListTile(
          title: (FirebaseAuth.instance.currentUser!.uid == widget.paymentModel.senderId)
              ? Text(
                  'To: ${widget.paymentModel.receiverName ?? 'Receiver name is null'}',
                  style: const TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor),
                )
              : Text(
                  'From: ${widget.paymentModel.senderName ?? 'Sender name is null'}',
                  style: const TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor),
                ),
          subtitle: (FirebaseAuth.instance.currentUser!.uid == widget.paymentModel.senderId)
              ? Column(
                  children: [
                    Text(
                      widget.paymentModel.senderMessage ?? 'Sender message is null',
                      style: const TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //REFUND BUTTON
                        OutlinedButton(
                          onPressed: widget.paymentModel.isButtonEnabled
                              ? () async {
                                  paymentItemController.paymentConfirmation(
                                    context: context,
                                    action: "REFUND",
                                    paymentModel: widget.paymentModel,
                                    paymentRoomModel: widget.paymentRoomModel,
                                  );
                                }
                              : null,
                          style: ButtonStyle(
                            backgroundColor: widget.paymentModel.isButtonEnabled
                                ? MaterialStateColor.resolveWith((states) => Colors.white)
                                : MaterialStateColor.resolveWith((states) => Colors.grey),
                            elevation: MaterialStateProperty.resolveWith((states) => 2),
                          ),
                          child: const Text(
                            'REFUND',
                            style: TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor),
                          ),
                        ),
                        // RELEASE BUTTON
                        OutlinedButton(
                          onPressed: widget.paymentModel.isButtonEnabled
                              ? () async {
                                  paymentItemController.paymentConfirmation(
                                    context: context,
                                    action: "RELEASE",
                                    paymentModel: widget.paymentModel,
                                    paymentRoomModel: widget.paymentRoomModel,
                                  );
                                }
                              : null,
                          style: ButtonStyle(
                            backgroundColor: widget.paymentModel.isButtonEnabled
                                ? MaterialStateColor.resolveWith((states) => Colors.white)
                                : MaterialStateColor.resolveWith((states) => Colors.grey),
                            elevation: MaterialStateProperty.resolveWith((states) => 2),
                          ),
                          child: const Text(
                            'RELEASE',
                            style: TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Text(widget.paymentModel.receiverMessage ?? 'Receiver message is null', style: const TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor)),
          tileColor: tPrimaryColor,
          trailing: Text(
            '\u{20B9}${widget.paymentModel.amount}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: tPrimaryFamily),
          ),
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
