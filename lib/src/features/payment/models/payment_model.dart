class PaymentModel {
  String? id;
  String? receiverToken;
  String? senderToken;
  String? amount;
  String? receiverId;
  String? receiverName;
  String? senderId;
  String? senderName;
  String? paymentId;
  DateTime? paymentTime;
  String? senderMessage;
  String? receiverMessage;
  bool isButtonEnabled = true;
  String? projectName;

  PaymentModel({
    this.projectName,
    this.id,
    this.receiverToken,
    this.senderToken,
    this.amount,
    this.receiverId,
    this.receiverName,
    this.senderId,
    this.senderName,
    this.paymentId,
    this.paymentTime,
    this.senderMessage,
    this.receiverMessage,
    required this.isButtonEnabled,
  });

  PaymentModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    receiverToken = map["receiverToken"];
    projectName = map["projectName"];
    senderToken = map["senderToken"];
    amount = map["amount"];
    receiverId = map["receiverId"];
    receiverName = map["receiverName"];
    senderName = map["senderName"];
    paymentId = map["paymentId"];
    paymentTime = map["paymentTime"].toDate();
    senderId = map["senderId"];
    senderMessage = map["senderMessage"];
    receiverMessage = map["receiverMessage"];
    isButtonEnabled = map["isButtonEnabled"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "projectName": projectName,
      "receiverToken": receiverToken,
      "senderToken": senderToken,
      "amount": amount,
      "receiverId": receiverId,
      "receiverName": receiverName,
      "senderName": senderName,
      "paymentId": paymentId,
      "paymentTime": paymentTime,
      "senderId": senderId,
      "senderMessage": senderMessage,
      "receiverMessage": receiverMessage,
      "isButtonEnabled": isButtonEnabled,
    };
  }
}
