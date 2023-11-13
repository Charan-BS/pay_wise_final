import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/constants/image_strings.dart';
import 'package:paywise_android/src/features/chat/screens/chat_home_screen.dart';
import 'package:paywise_android/src/features/payment/screens/my_money.dart';
import 'package:paywise_android/src/features/payment/screens/release_or_request/release_or_request_screen.dart';

import 'op_button.dart';

class OptionList extends StatelessWidget {
  const OptionList({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OptionButton(
                optionSvg: tSendMoneySvg,
                optionTitle: 'Send Money',
                onTap: () => Get.to(() => const ChatHomeScreen()),
              ),
              OptionButton(
                optionSvg: tReleaseRefundSvg,
                optionTitle: 'Release Refund',
                onTap: () {
                  Get.to(() => const ReleaseOrRequestScreen());
                },
              ),
              OptionButton(
                optionSvg: tMyMoneySvg,
                optionTitle: 'My Money',
                onTap: () {
                  Get.to(() => const MyMoney());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
