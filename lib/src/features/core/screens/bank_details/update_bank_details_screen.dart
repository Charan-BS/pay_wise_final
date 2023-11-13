import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/features/core/controllers/bank_update_controller.dart';
import 'package:paywise_android/src/features/core/models/bank_model.dart';
import '../../../../common_widgets/auth_field.dart';
import '../../../../common_widgets/button_loading_widget.dart';
import '../../../../utils/helper/helper_controller.dart';
import '../../../../utils/themes/elevated_button_theme.dart';

class UpdateBankDetails extends StatelessWidget {
  const UpdateBankDetails({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BankUpdateController());
    GlobalKey<FormState> bankFormKey = GlobalKey<FormState>();
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
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: FutureBuilder(
                future: controller.getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      BankModel bank = snapshot.data as BankModel;
                      //TextEditingControllers
                      final acNo = TextEditingController(text: bank.accountNumber);
                      final ifsc = TextEditingController(text: bank.ifscCode);
                      final bankName = TextEditingController(text: bank.bankName);
                      final acHolder = TextEditingController(text: bank.accountHolderName);
                      return Column(
                        children: [
                          SvgPicture.asset(tEditBankSvg, height: 100),
                          const SizedBox(height: 10),
                          const Text(tEditBank, style: TextStyle(fontFamily: tPrimaryFamily, fontSize: 20)),
                          Form(
                            key: bankFormKey,
                            child: Column(
                              children: [
                                const SizedBox(height: tDefaultSize),
                                AuthField(
                                  color: Colors.green,
                                  controller: acNo,
                                  validator: (value) => Helper.validateAccountNumber(value, value),
                                  hintText: tAcNo,
                                  iconData: Icons.security_outlined,
                                  labelText: tAcNo,
                                  isEnabled: true,
                                ),
                                const SizedBox(height: tDefaultSize),
                                AuthField(
                                  color: Colors.green,
                                  controller: ifsc,
                                  validator: (value) => Helper.validateNotEmpty(value),
                                  hintText: tIfsc,
                                  iconData: Icons.code,
                                  labelText: tIfsc,
                                  isEnabled: true,
                                ),
                                const SizedBox(height: tDefaultSize),
                                AuthField(
                                  color: Colors.green,
                                  controller: bankName,
                                  validator: (value) => Helper.validateNotEmpty(value),
                                  hintText: tBankName,
                                  iconData: Icons.assured_workload,
                                  labelText: tBankName,
                                  isEnabled: true,
                                ),
                                const SizedBox(height: tDefaultSize),
                                AuthField(
                                  color: Colors.green,
                                  controller: acHolder,
                                  validator: (value) => Helper.validateNotEmpty(value),
                                  hintText: tAccountName,
                                  iconData: Icons.person_pin,
                                  labelText: tAccountName,
                                  isEnabled: true,
                                ),
                                const SizedBox(height: tDefaultSize),
                                SizedBox(
                                  child: Obx(
                                    () => ElevatedButton.icon(
                                      onPressed: () async {
                                        if (bankFormKey.currentState!.validate()) {
                                          await controller.updateBankRecord(
                                            userGlobalId,
                                            acNo.text.trim(),
                                            ifsc.text.trim(),
                                            bankName.text.trim(),
                                            acHolder.text.trim(),
                                          );
                                        }
                                      },
                                      icon: controller.isLoading.value
                                          ? const SizedBox()
                                          : Container(
                                              margin: const EdgeInsets.only(left: 20),
                                              child: const Icon(
                                                Icons.system_update_alt_sharp,
                                              ),
                                            ),
                                      label: controller.isLoading.value
                                          ? const ButtonLoadingWidget()
                                          : Container(
                                              margin: const EdgeInsets.only(right: 20),
                                              child: Text(
                                                tUpdate.toUpperCase(),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.hasError.toString(), style: const TextStyle(fontFamily: tPrimaryFamily));
                    } else {
                      return const Center(child: Text('Something went wrong'));
                    }
                  } else {
                    return Center(child: LoadingAnimationWidget.discreteCircle(color: Colors.green, size: 30));
                  }
                }),
          ),
        ),
      ),
    );
  }
}
