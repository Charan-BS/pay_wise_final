import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paywise_android/src/constants/colors.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/constants/text_strings.dart';
import 'package:paywise_android/src/features/core/screens/bank_details/update_bank_details_screen.dart';
import 'package:paywise_android/src/features/core/screens/profile/privacy_policy.dart';
import 'package:paywise_android/src/features/core/screens/profile/profile_menu.dart';
import 'package:paywise_android/src/features/core/screens/profile/update_profile.dart';
import 'package:paywise_android/src/repository/authentication_repository/authentication_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common_widgets/custom_warning_dialogue.dart';
import '../../../../constants/assets_constants.dart';
import '../../../../constants/sizes.dart';
import 'about_us.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  Future openEmailClient() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'charanbskollur@gmail.com',
      query: 'subject=Feedback%20for%20App',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: tPrimaryColor,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: tDarkColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Center(child: SvgPicture.asset(AssetsConstants.appLogo, height: 30)),
          backgroundColor: Colors.white,
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.more_vert_outlined, color: tDarkColor),
              onSelected: (dynamic v) => openEmailClient(),
              itemBuilder: (BuildContext context) {
                List<PopupMenuEntry<Object>> list = [];
                list.add(
                  const PopupMenuItem(
                    value: 1,
                    child: Text(tSendFeedBack, style: TextStyle(color: tDarkColor, fontFamily: tPrimaryFamily)),
                  ),
                );
                return list;
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(tDashboardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tPrivacy.toUpperCase(), style: const TextStyle(fontFamily: tPrimaryFamily)),
                    const SizedBox(height: 22),
                    //Edit profile
                    ProfileMenu(
                      svgData: tEditProfileSvg,
                      title: "Edit profile",
                      subTitle: "Make changes",
                      onTap: () => Get.to(() => const UpdateProfile()),
                    ),
                    const SizedBox(height: 22),
                    ProfileMenu(
                      svgData: tEditBankSvg,
                      title: "Edit Bank Details",
                      subTitle: "Password protected",
                      onTap: () => Get.to(() => const UpdateBankDetails()),
                    ),
                    const SizedBox(height: 22),
                    ProfileMenu(
                      svgData: tPrivacySvg,
                      title: "Privacy policy",
                      subTitle: "Read about terms and conditions",
                      onTap: () => Get.to(() => const PrivacyPolicy()),
                    ),
                    const SizedBox(height: 22),
                    ProfileMenu(
                      svgData: tAboutSvg,
                      title: "About us",
                      subTitle: "Know more",
                      onTap: () => Get.to(() => const AboutUs()),
                    ),
                    const SizedBox(height: 22),
                    ProfileMenu(
                      svgData: tLogoutSvg,
                      title: "Log out",
                      subTitle: "Log out from PayWise",
                      onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomWarningDialog(
                            iconData: Icons.warning,
                            leftButton: 'Cancel',
                            leftButtonOnTap: () => Get.back(),
                            rightButton: 'Logout',
                            rightButtonOnTap: () async => await AuthenticationRepository.instance.logout(),
                            warningMessage: 'Are you sure about logging out',
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 22),
                    ProfileMenu(
                      svgData: tRateUsSvg,
                      title: "Rate us on play store",
                      subTitle: "Your ⭐⭐⭐⭐ is valuable for us",
                      onTap: () => {
                        //TODO:call opening play store function
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
