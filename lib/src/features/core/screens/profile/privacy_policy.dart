import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paywise_android/src/constants/constants.dart';

import '../../../../constants/assets_constants.dart';
import '../../../../constants/colors.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: tDarkColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(child: SvgPicture.asset(AssetsConstants.appLogo, height: 30)),
        backgroundColor: Colors.white,
      ),
      backgroundColor: tPrimaryColor,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: const Text(
            tPrivacyPolicy,
          ),
        ),
      ),
    );
  }
}
