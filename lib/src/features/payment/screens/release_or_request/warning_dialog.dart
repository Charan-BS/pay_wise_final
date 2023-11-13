import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:paywise_android/src/constants/constants.dart';

import '../../../../common_widgets/button_loading_widget.dart';
import '../../controllers/payment_item_controller.dart';

class WarningDialog extends StatelessWidget {
  final IconData iconData;
  final String warningMessage;
  final String rightButton;
  final String leftButton;
  final Callback rightButtonOnTap;
  final Callback leftButtonOnTap;
  const WarningDialog({
    super.key,
    required this.iconData,
    required this.rightButton,
    required this.leftButton,
    required this.leftButtonOnTap,
    required this.rightButtonOnTap,
    required this.warningMessage,
  });

  @override
  Widget build(BuildContext context) {
    final paymentItemController = Get.put(PaymentItemController());
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, color: Colors.orange, size: 50.0),
            const SizedBox(height: 10.0),
            const Text('CONFIRM', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, fontFamily: tPrimaryFamily)),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                warningMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0, fontFamily: tPrimaryFamily),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: leftButtonOnTap,
                  child: Text(leftButton, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontFamily: tPrimaryFamily)),
                ),
                Obx(
                  () => OutlinedButton(
                    onPressed: rightButtonOnTap,
                    child: paymentItemController.isLoading.value
                        ? const ButtonLoadingWidget()
                        : Text(
                            rightButton,
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: tPrimaryFamily),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
