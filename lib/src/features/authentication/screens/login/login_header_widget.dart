import 'package:flutter/material.dart';

import '../../../../constants/image_strings.dart';
import '../../../../constants/text_strings.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({Key? key, required this.size}) : super(key: key);
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(tag: 'authImage', child: Image(image: const AssetImage(tAuthImage), height: size.height * 0.25)),
        const Text(tLoginSubTitle, style: TextStyle(fontFamily: tFatFace)),
        const Text(tLoginTitle, style: TextStyle(fontSize: 40, fontFamily: tFatFace)),
      ],
    );
  }
}
