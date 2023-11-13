class PaymentMessageRoomModel {
  String? paymentMessageRoomId;
  Map<String, dynamic>? participants;
  PaymentMessageRoomModel({this.paymentMessageRoomId, this.participants});

  PaymentMessageRoomModel.fromMap(Map<String, dynamic> map) {
    paymentMessageRoomId = map["paymentMessageRoomId"];
    participants = map["participants"];
  }

  Map<String, dynamic> toMap() {
    return {
      "paymentMessageRoomId": paymentMessageRoomId,
      "participants": participants,
    };
  }
}
