import 'package:flutter/material.dart';
import 'package:paywise_android/src/constants/constants.dart';

class FormHeaderWidget extends StatelessWidget {
  final Color? imageColor;
  final double imageHeight;
  final double? heightBetween;
  final String image, title, subTitle;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;
  const FormHeaderWidget({
    Key? key,
    this.imageColor,
    this.heightBetween,
    required this.image,
    required this.title,
    required this.subTitle,
    this.imageHeight = 0.2,
    this.textAlign,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Hero(tag: 'authImage', child: Image(image: AssetImage(image), color: imageColor, height: size.height * imageHeight)),
      SizedBox(height: heightBetween),
      Text(title, style: const TextStyle(fontFamily: tFatFace, fontSize: 30)),
      Align(child: Text(subTitle, textAlign: TextAlign.center, style: const TextStyle(fontFamily: tFatFace, fontSize: 20))),
    ]);
  }
}
