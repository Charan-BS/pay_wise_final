import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../authentication/models/user_model.dart';
import '../../payment/models/payment_room_model.dart';

class ChatController extends GetxController {
  final isLoading = false.obs;
  Future<PaymentRoomModel?> getPaymentRoomModel(UserModel targetUser) async {
    isLoading.value = true;
    PaymentRoomModel? paymentRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("PaymentRooms")
        .where("participants.${FirebaseAuth.instance.currentUser?.uid}", isEqualTo: true)
        .where("participants.${targetUser.id}", isEqualTo: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      print("payment room found");
      var docData = snapshot.docs[0].data();
      PaymentRoomModel existingPaymentRoom = PaymentRoomModel.fromMap(docData as Map<String, dynamic>);
      paymentRoom = existingPaymentRoom;
      isLoading.value = false;
    } else {
      print("payment room not found");
      PaymentRoomModel newPaymentRoom = PaymentRoomModel(
        paymentRoomId: uuid.v1(),
        participants: {
          targetUser.id.toString(): true,
          FirebaseAuth.instance.currentUser?.uid ?? '': true,
        },
      );
      await FirebaseFirestore.instance.collection("PaymentRooms").doc(newPaymentRoom.paymentRoomId).set(newPaymentRoom.toMap());
      PaymentRoomModel().paymentRoomId = newPaymentRoom.paymentRoomId;
      paymentRoom = newPaymentRoom;
      isLoading.value = false;
      print("payment room created successfully");
    }
    return paymentRoom;
  }
}
