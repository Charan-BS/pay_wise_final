import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../constants/constants.dart';

class ProfileMenu extends StatelessWidget {
  final String svgData;
  final String title;
  final String subTitle;
  final Function() onTap;
  const ProfileMenu({super.key, required this.svgData, required this.title, required this.subTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  CircleAvatar(
                      radius: 28,
                      backgroundColor: tWhiteColor,
                      child: SvgPicture.asset(
                        svgData,
                        width: 45,
                        fit: BoxFit.fitHeight,
                      )),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(color: tDarkColor, fontSize: 18, fontFamily: tPrimaryFamily)),
                      const SizedBox(height: 4),
                      Text(subTitle, style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: tPrimaryFamily))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
