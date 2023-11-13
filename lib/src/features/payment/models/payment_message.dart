import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMessage {
  String? receiverToken;
  String? senderToken;
  String? paymentMessageId;
  String? amount;
  String? receiverId;
  String? receiverName;
  String? senderId;
  String? senderName;
  String? paymentId;
  Timestamp? paymentTime;
  String? action;
  String? msg;
  bool isProcessed = false;

  PaymentMessage({
    this.receiverToken,
    this.senderToken,
    this.paymentMessageId,
    this.amount,
    this.receiverId,
    this.receiverName,
    this.senderId,
    this.senderName,
    this.paymentId,
    this.paymentTime,
    this.action,
    this.msg,
    required this.isProcessed,
  });

  PaymentMessage.fromMap(Map<String, dynamic> map) {
    receiverToken = map["receiverToken"];
    senderToken = map["senderToken"];
    amount = map["amount"];
    receiverId = map["receiverId"];
    receiverName = map["receiverName"];
    senderId = map["senderId"];
    senderName = map["senderName"];
    paymentId = map["paymentId"];
    paymentTime = map["paymentTime"];
    action = map["action"];
    msg = map["msg"];
    isProcessed = map["isProcessed"];
  }

  Map<String, dynamic> toMap() {
    return {
      "receiverToken": receiverToken,
      "senderToken": senderToken,
      "isProcessed": isProcessed,
      "paymentMessageId": paymentMessageId,
      "amount": amount,
      "receiverId": receiverId,
      "receiverName": receiverName,
      "senderId": senderId,
      "senderName": senderName,
      "paymentId": paymentId,
      "paymentTime": paymentTime,
      "action": action,
      "msg": msg,
    };
  }
}
