import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/features/core/screens/dashboard/dashboard.dart';

class TransactionStatusScreen extends StatelessWidget {
  final String transactionStatus;
  final String? orderId;
  final String lottie;
  final bool? repeat;
  final Color color;

  const TransactionStatusScreen({
    super.key,
    required this.transactionStatus,
    required this.orderId,
    required this.color,
    required this.lottie,
    required this.repeat,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Lottie.asset(lottie, height: 400, width: 400, repeat: repeat),
                Text('PAYMENT SUCCESSFULL',
                    style: const TextStyle(fontFamily: tPrimaryFamily, fontWeight: FontWeight.bold, fontSize: 40, color: tWhiteColor), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                SelectableText(
                  'Reference : $orderId',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                      padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.symmetric(vertical: 15, horizontal: 30))),
                  onPressed: () {
                    Get.offAll(() => const DashBoard());
                  },
                  child: const Text('GO TO HOME SCREEN'),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'You can manage your money in release or refund section',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: tPrimaryFamily, fontSize: 20, color: tWhiteColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
