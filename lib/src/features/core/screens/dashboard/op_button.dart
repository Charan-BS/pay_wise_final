import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paywise_android/src/constants/colors.dart';
import 'package:paywise_android/src/constants/constants.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({super.key, required this.optionSvg, required this.optionTitle, required this.onTap});
  final String optionTitle;
  final String optionSvg;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      child: Column(
        children: [
          CircleAvatar(backgroundColor: Colors.blue[50], radius: 35, child: SvgPicture.asset(optionSvg, height: 27)),
          const SizedBox(height: 5),
          Text(optionTitle,
              style: const TextStyle(
                color: tDarkColor,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }
}
