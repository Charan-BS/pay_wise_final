import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:paywise_android/src/constants/constants.dart';
import '../../../../api/notification_services.dart';
import '../../../../common_widgets/auth_field.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../../../../utils/helper/helper_controller.dart';
import '../../../../utils/themes/elevated_button_theme.dart';
import '../../controllers/signup_controller.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});
  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  NotificationServices notificationServices = NotificationServices();
  String? deviceToken;
  @override
  void initState() {
    super.initState();
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print(value);
      deviceToken = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final auth = AuthenticationRepository.instance;
    GlobalKey<FormState> bankFormKey = GlobalKey<FormState>();
    return Scaffold(
      body: Theme(
        data: ThemeData(elevatedButtonTheme: ElevatedButtonCustomTheme.lightElevatedButtonTheme),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(Icons.assured_workload_outlined, color: Colors.green, size: 60),
                  const Text(tEditBank, style: TextStyle(fontFamily: tFatFace, fontSize: 30), textAlign: TextAlign.center),
                  const Text(tEditBankDetails, style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                  Form(
                    key: bankFormKey,
                    child: Column(
                      children: [
                        const SizedBox(height: tDefaultSize),
                        //Account number
                        AuthField(
                          controller: controller.acNo,
                          validator: (value) {
                            return Helper.validateAccountNumber(value, controller.rAcNo.text);
                          },
                          hintText: tAcNo,
                          iconData: Icons.bar_chart,
                          labelText: tAcNo,
                          isEnabled: true,
                        ),
                        const SizedBox(height: tDefaultSize),
                        //Re-Enter Account number
                        AuthField(
                          controller: controller.rAcNo,
                          validator: (value) {
                            return Helper.validateAccountNumber(value, controller.rAcNo.text);
                          },
                          hintText: tReEnterAcNo,
                          iconData: Icons.stacked_bar_chart_sharp,
                          labelText: tReEnterAcNo,
                          isEnabled: true,
                        ),
                        const SizedBox(height: tDefaultSize),
                        //Ifsc code
                        AuthField(
                          controller: controller.ifsc,
                          validator: (value) {
                            return Helper.validateNotEmpty(value);
                          },
                          hintText: tIfsc,
                          iconData: Icons.code,
                          labelText: tIfsc,
                          isEnabled: true,
                        ),
                        const SizedBox(height: tDefaultSize),
                        //Bank name
                        AuthField(
                          controller: controller.bankName,
                          validator: (value) {
                            return Helper.validateNotEmpty(value);
                          },
                          hintText: tBankName,
                          iconData: Icons.assured_workload,
                          labelText: tBankName,
                          isEnabled: true,
                        ),
                        const SizedBox(height: tDefaultSize),
                        //Account holder name
                        AuthField(
                          controller: controller.acHolder,
                          validator: (value) {
                            return Helper.validateNotEmpty(value);
                          },
                          hintText: tAccountName,
                          iconData: Icons.person_2_rounded,
                          labelText: tAccountName,
                          isEnabled: true,
                        ),
                        const SizedBox(height: tDefaultSize),
                        //Update button
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (bankFormKey.currentState!.validate()) {
                                  await controller.createUser(
                                    controller.email.text.trim(),
                                    controller.password.text.trim(),
                                    controller.fullName.text.trim(),
                                    deviceToken,
                                  );
                                  FirebaseAuth.instance.currentUser?.reload();
                                  final user = FirebaseAuth.instance.currentUser;
                                  auth.setInitialScreen(user);
                                }
                              },
                              label: controller.isLoading.value ? const Text(tLoading, style: TextStyle(fontSize: 15)) : const Text(tSignUP, style: TextStyle(fontSize: 15)),
                              icon: controller.isLoading.value
                                  ? LoadingAnimationWidget.discreteCircle(color: Colors.green, size: 20)
                                  : const Icon(Icons.check_circle, color: Colors.green),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
