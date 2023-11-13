import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paywise_android/src/constants/constants.dart';

class CommonAppBar {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.appLogo,
        height: 30,
      ),
      centerTitle: true,
    );
  }
}
