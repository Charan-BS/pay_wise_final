import 'package:get/get.dart';
import 'package:paywise_android/src/features/payment/models/payment_model.dart';
import 'package:paywise_android/src/repository/payment_repository/payment_repository.dart';

import '../models/payment_room_model.dart';

class PaymentController extends GetxController {
  static PaymentController get instance => Get.find();
  final userRepo = Get.put(PaymentRepository());

  Future<void> createPayment(PaymentModel paymentModel, PaymentRoomModel paymentRoomModel) async {
    userRepo.createPaymentDocument(paymentModel, paymentRoomModel);
  }

  Future<void> updatePaymentButtonState(PaymentModel? paymentModel, PaymentRoomModel? paymentRoomModel) async {
    userRepo.updateButtonState(paymentModel, paymentRoomModel);
  }
}
