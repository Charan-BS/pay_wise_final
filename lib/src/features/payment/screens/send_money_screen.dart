import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:paywise_android/main.dart';
import 'package:paywise_android/src/api/notification_services.dart';
import 'package:paywise_android/src/common_widgets/auth_field.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/features/payment/controllers/payment_controller.dart';
import 'package:paywise_android/src/features/payment/models/payment_model.dart';
import 'package:paywise_android/src/features/payment/screens/transaction_status_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../utils/helper/helper_controller.dart';
import '../../../utils/themes/elevated_button_theme.dart';
import '../../authentication/models/user_model.dart';
import '../models/payment_room_model.dart';
import 'package:http/http.dart' as http;

class SendMoneyScreen extends StatefulWidget {
  final UserModel targetUser;
  final PaymentRoomModel paymentRoomModel;
  const SendMoneyScreen({super.key, required this.targetUser, required this.paymentRoomModel});
  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _razorpay = Razorpay();
  String? deviceToken;
  String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  String contentType = 'application/json; charset=UTF-8';
  final controller = Get.put(PaymentController());
  final pTitle = TextEditingController();
  final pAmount = TextEditingController();
  final isLoading = false.obs;
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print(value);
      deviceToken = value;
    });
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    PaymentModel paymentModel = PaymentModel(
      id: uuid.v1(),
      projectName: pTitle.text.toString(),
      receiverToken: widget.targetUser.deviceToken,
      senderToken: deviceToken,
      paymentId: response.paymentId,
      paymentTime: DateTime.now(),
      amount: pAmount.text.toString(),
      senderName: currentUser?.displayName,
      receiverName: widget.targetUser.fullName,
      senderId: currentUser?.uid,
      receiverId: widget.targetUser.id,
      senderMessage: 'Amount has been deposited.\nOnce the work is submitted click on Release amount',
      receiverMessage: 'Amount has been deposited by ${currentUser?.displayName}.\nYou can start working',
      isButtonEnabled: true,
    );
    await controller.createPayment(paymentModel, widget.paymentRoomModel);
    Get.offAll(
      () => TransactionStatusScreen(
        transactionStatus: 'Payment Successful',
        orderId: response.paymentId,
        color: Colors.green.withOpacity(0.9),
        lottie: tSuccessLottie,
        repeat: false,
      ),
    );
    //Send notification
    var data = {
      'to': widget.targetUser.deviceToken,
      'notification': {
        'title': 'Payment received successfully',
        'body': 'Amount of ${pAmount.text.toString()} received.',
        "sound": "jetsons_doorbell.mp3",
      },
      'android': {
        'notification': {
          'notification_count': 23,
        },
      },
    };
    await dotenv.load(fileName: ".env");
    await http.post(Uri.parse(fcmUrl), body: jsonEncode(data), headers: {
      'Content-Type': contentType,
      'Authorization': dotenv.env['authorizationKey'].toString(),
    }).then((value) {
      print('success');
      print(value.body.toString());
    }).onError((error, stackTrace) {
      return Helper.errorSnackBar(title: 'Error', message: error.toString());
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Helper.errorSnackBar(title: "Payment Error", message: "Description: ${response.message}");
    Get.to(
      () => TransactionStatusScreen(
        transactionStatus: 'Payment Failed',
        orderId: response.message,
        color: Colors.redAccent.withOpacity(0.8),
        lottie: tFailureLottie,
        repeat: false,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: tPrimaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.chevron_left),
          color: Colors.black,
          iconSize: 30,
        ),
        backgroundColor: tWhiteColor,
        title: const Center(child: Text('MAKE YOUR PAYMENT', style: TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor))),
      ),
      body: Theme(
        data: ThemeData(elevatedButtonTheme: ElevatedButtonCustomTheme.lightElevatedButtonTheme),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  //heading images and title
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      SvgPicture.asset(tMakePaymentSvg, height: 100),
                      const SizedBox(height: 12),
                      const Text(
                        'Please keep title clear and simple',
                        style: TextStyle(fontFamily: tPrimaryFamily, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                  const SizedBox(height: 12),
                  //name of project
                  TextFormField(
                    validator: (value) => Helper.validateNotEmpty(value),
                    controller: pTitle,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(tDefaultSize - 8),
                      hintText: 'Title of the project',
                      prefixIcon: Icon(Icons.work, color: Colors.green),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: tBlueColor)),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),
                  //amount
                  TextFormField(
                    validator: (value) {
                      return Helper.validateAmount(value);
                    },
                    controller: pAmount,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(tDefaultSize - 8),
                      hintText: 'Amount',
                      prefixIcon: Icon(Icons.currency_rupee, color: Colors.green),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: tBlueColor)),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(tWhiteColor),
                        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10)),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Center(child: LoadingAnimationWidget.discreteCircle(color: Colors.green, size: 30));
                            },
                          );
                          int amount = int.parse(pAmount.text) * 100;
                          final email = FirebaseAuth.instance.currentUser?.email;
                          await makePayment(amount, email);
                        }
                      },
                      icon: const Icon(Icons.send_rounded, color: Colors.green),
                      label: Text('Send Money to ${widget.targetUser.fullName ?? 'Receiver'}',
                          style: const TextStyle(fontFamily: tPrimaryFamily, color: tDarkColor, fontWeight: FontWeight.bold)),
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

  Future<void> makePayment(int amount, String? email) async {
    try {
      await dotenv.load(fileName: ".env");
      var options = {
        'key': dotenv.env['razorPayKey'],
        'amount': amount,
        'name': 'PayWise pvt ltd',
        'description': pTitle.text.toString(),
        'timeout': 120,
        'prefill': {'email': email}
      };
      _razorpay.open(options);
    } catch (e) {
      Helper.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
