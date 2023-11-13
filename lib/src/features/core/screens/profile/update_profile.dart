import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:paywise_android/src/common_widgets/auth_field.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/features/authentication/controllers/login_controller.dart';
import 'package:paywise_android/src/features/authentication/models/user_model.dart';
import 'package:paywise_android/src/features/core/controllers/profile_controller.dart';

import '../../../../common_widgets/button_loading_widget.dart';
import '../../../../utils/helper/helper_controller.dart';
import '../../../../utils/themes/elevated_button_theme.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({super.key});
  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());
    final loginController = Get.put(LoginController());
    GlobalKey<FormState> updateFullNameKey = GlobalKey<FormState>();
    GlobalKey<FormState> updatePasswordKey = GlobalKey<FormState>();
    final passwordResetController = TextEditingController();
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
      ),
      body: Theme(
        data: ThemeData(elevatedButtonTheme: ElevatedButtonCustomTheme.lightElevatedButtonTheme),
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: FutureBuilder(
            future: profileController.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data as UserModel;
                  final id = TextEditingController(text: user.id);
                  //Controllers
                  final emailController = TextEditingController(text: user.email);
                  final fullNameController = TextEditingController(text: user.fullName);
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SvgPicture.asset(tEditProfileSvg, height: 100),
                        const SizedBox(height: 20),
                        const Text(tEditProfile, style: TextStyle(fontFamily: tPrimaryFamily, fontSize: 30)),
                        Form(
                          key: updateFullNameKey,
                          child: Column(
                            children: [
                              const SizedBox(height: tDefaultSize),
                              //Email Field
                              AuthField(
                                color: Colors.green,
                                controller: emailController,
                                validator: (value) => Helper.validateEmail(value),
                                hintText: tEmail,
                                iconData: Icons.email_outlined,
                                labelText: tEmail,
                                isEnabled: false,
                              ),
                              const SizedBox(height: tDefaultSize),
                              //Full Name Field
                              AuthField(
                                color: Colors.green,
                                controller: fullNameController,
                                validator: (value) => Helper.validateName(value.toString()),
                                hintText: tFullName,
                                iconData: Icons.person,
                                labelText: tFullName,
                                isEnabled: true,
                              ),
                              const SizedBox(height: tDefaultSize),
                              //Update button
                              SizedBox(
                                child: Obx(
                                  () => ElevatedButton.icon(
                                    onPressed: () async {
                                      if (updateFullNameKey.currentState!.validate()) {
                                        await profileController.updateRecord(
                                          emailController.text.trim(),
                                          fullNameController.text.trim(),
                                          id.text,
                                        );
                                      }
                                    },
                                    icon: profileController.isLoading.value
                                        ? const SizedBox()
                                        : Container(margin: const EdgeInsets.symmetric(horizontal: 10), child: const Icon(Icons.update_outlined)),
                                    label: profileController.isLoading.value
                                        ? const ButtonLoadingWidget()
                                        : Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Text(
                                              tUpdateFullName.toUpperCase(),
                                              style: const TextStyle(fontFamily: tPrimaryFamily, fontWeight: FontWeight.bold),
                                            )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: tDefaultSize),
                            ],
                          ),
                        ),
                        Form(
                          key: updatePasswordKey,
                          child: Column(
                            children: [
                              const Text(
                                tEditPassword,
                                style: TextStyle(fontFamily: tPrimaryFamily, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                tEditPasswordSubtitle,
                                style: TextStyle(fontFamily: tPrimaryFamily),
                              ),
                              const SizedBox(height: 20),
                              AuthField(
                                color: Colors.green,
                                validator: (value) => Helper.validateEmail(value),
                                controller: passwordResetController,
                                hintText: 'Enter Email Id here',
                                iconData: Icons.fingerprint_sharp,
                                labelText: 'Email Id',
                                isEnabled: true,
                              ),
                              const SizedBox(height: tDefaultSize),
                              SizedBox(
                                child: Obx(
                                  () => ElevatedButton.icon(
                                    onPressed: () async {
                                      if (updatePasswordKey.currentState!.validate()) {
                                        loginController.sendPasswordReset(passwordResetController.text.trim());
                                      }
                                    },
                                    icon: loginController.isLoading.value
                                        ? const SizedBox()
                                        : Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 10),
                                            child: const Icon(Icons.fingerprint),
                                          ),
                                    label: loginController.isLoading.value
                                        ? const ButtonLoadingWidget()
                                        : Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Text(
                                              tUpdatePassword.toUpperCase(),
                                              style: const TextStyle(fontFamily: tPrimaryFamily, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text('Something went wrong'));
                }
              } else {
                return Center(child: LoadingAnimationWidget.discreteCircle(color: Colors.green, size: 30));
              }
            },
          ),
        ),
      ),
    );
  }
}
