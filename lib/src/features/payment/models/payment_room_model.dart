class PaymentRoomModel {
  String? paymentRoomId;
  Map<String, dynamic>? participants;

  PaymentRoomModel({this.paymentRoomId, this.participants});

  PaymentRoomModel.fromMap(Map<String, dynamic> map) {
    paymentRoomId = map["paymentRoomId"];
    participants = map["participants"];
  }

  Map<String, dynamic> toMap() {
    return {
      "paymentRoomId": paymentRoomId,
      "participants": participants,
    };
  }
}
