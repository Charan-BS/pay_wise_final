import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/features/core/screens/profile/about_us.dart';
import '../../../../constants/constants.dart';

class CarouselImage extends StatelessWidget {
  static List<Image> cList = [
    Image.asset(tCarouselImage1),
    Image.asset(tCarouselImage2),
    Image.asset(tCarouselImage3),
  ];
  const CarouselImage({super.key});
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: cList.length,
      options: CarouselOptions(viewportFraction: 1),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return GestureDetector(
          onTap: () => Get.to(() => const AboutUs()),
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            // padding: const EdgeInsets.only(top: 5),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   border: Border.all(color: Colors.white, width: 1),
            // ),
            // alignment: Alignment.center,
            child: ClipRRect(child: cList[index]),
          ),
        );
      },
    );
  }
}
