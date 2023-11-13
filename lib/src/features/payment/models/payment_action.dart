import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentAction {
  String? action;
  String? amount;
  String? receiverId;
  String? senderId;
  String? paymentId;
  FieldValue timeStamp;

  PaymentAction({
    required this.amount,
    required this.receiverId,
    required this.senderId,
    required this.paymentId,
    required this.timeStamp,
    required this.action,
  });

  Map<String, dynamic> toMap() {
    return {
      "amount": amount,
      "receiverId": receiverId,
      "senderId": senderId,
      "paymentId": paymentId,
      "timeStamp": timeStamp,
      "action": action,
    };
  }
}
