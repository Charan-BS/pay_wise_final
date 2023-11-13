import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/features/payment/models/payment_model.dart';
import '../../features/payment/models/payment_room_model.dart';
import '../../utils/helper/helper_controller.dart';

class PaymentRepository extends GetxController {
  final _db = FirebaseFirestore.instance;
  Future<void> createPaymentDocument(PaymentModel payment, PaymentRoomModel? paymentRoomModel) async {
    _db.collection("PaymentRooms").doc(paymentRoomModel?.paymentRoomId).collection("payments").doc(payment.id).set(payment.toMap()).whenComplete(() => Helper.successSnackBar(
          title: "Payment Successful",
          message: "Now you can manage your money inside Release Refund section.",
        ));
  }

  Future<void> updateButtonState(PaymentModel? paymentModel, PaymentRoomModel? paymentRoomModel) async {
    try {
      await _db.collection("PaymentRooms").doc(paymentRoomModel?.paymentRoomId).collection("payments").doc(paymentModel?.id).update({
        "isButtonEnabled": false,
      });
    } catch (e) {
      print("Error updating button state: $e");
    }
  }
}
