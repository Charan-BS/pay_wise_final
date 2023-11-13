import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paywise_android/src/constants/constants.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tPrimaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.chevron_left, color: tDarkColor), onPressed: () => Navigator.pop(context)),
        title: Center(child: SvgPicture.asset(AssetsConstants.appLogo, height: 30)),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                const Text('ABOUT US', style: TextStyle(fontFamily: tPrimaryFamily, fontSize: 30)),
                const SizedBox(height: 10),
                Image.asset(tCarouselImage1),
                const SizedBox(height: 10),
                const Text(
                  tAboutUs,
                  style: TextStyle(fontFamily: tPrimaryFamily),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
