import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/constants.dart';

class SearchListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function() onTap;
  final Widget widget;
  const SearchListTile({super.key, required this.title, required this.subTitle, required this.onTap, required this.widget});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(fontFamily: tPrimaryFamily),
      ),
      subtitle: Text(
        subTitle,
        style: const TextStyle(fontFamily: tPrimaryFamily),
      ),
      tileColor: tPrimaryColor,
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: tWhiteColor,
        child: SvgPicture.asset(tPersonSvg, height: 35),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
    );
  }
}
