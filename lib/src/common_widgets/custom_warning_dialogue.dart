import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:paywise_android/src/constants/constants.dart';

class CustomWarningDialog extends StatelessWidget {
  final IconData iconData;
  final String warningMessage;
  final String rightButton;
  final String leftButton;
  final Callback rightButtonOnTap;
  final Callback leftButtonOnTap;
  const CustomWarningDialog(
      {super.key,
      required this.iconData,
      required this.rightButton,
      required this.leftButton,
      required this.leftButtonOnTap,
      required this.rightButtonOnTap,
      required this.warningMessage});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, color: Colors.orange, size: 50.0),
            const SizedBox(height: 10.0),
            const Text('Warning!', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, fontFamily: tPrimaryFamily)),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(warningMessage, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16.0, fontFamily: tPrimaryFamily)),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: leftButtonOnTap,
                  child: Text(
                    leftButton,
                    style: const TextStyle(fontFamily: tPrimaryFamily),
                  ),
                ),
                TextButton(
                  onPressed: rightButtonOnTap,
                  child: Text(
                    rightButton,
                    style: const TextStyle(
                      fontFamily: tPrimaryFamily,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
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
