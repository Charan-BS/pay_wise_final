import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paywise_android/src/constants/constants.dart';
import 'package:paywise_android/src/features/authentication/screens/login/login_screen.dart';
import 'package:paywise_android/src/features/authentication/screens/mail_verification/mail_verification.dart';
import 'package:paywise_android/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:paywise_android/src/features/core/screens/dashboard/dashboard.dart';
import 'package:paywise_android/src/repository/authentication_repository/exceptions/t_exceptions.dart';

import '../../utils/helper/helper_controller.dart';
import 'exceptions/login_with_email_and_password.dart';
import 'exceptions/signup_email_password_failure.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  //Variables
  late final Rx<User?> _firebaseUser;
  final _auth = FirebaseAuth.instance;

  //Getters
  User? get firebaseUser => _firebaseUser.value;

  //Loads when app launch from main.dart
  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    FlutterNativeSplash.remove();
    setInitialScreen(_firebaseUser.value);
  }

  //Setting initial screen
  setInitialScreen(User? user) {
    print(user?.uid);
    user == null
        ? Get.offAll(() => const SignUpScreen())
        : user.emailVerified
            ? Get.offAll(() => DashBoard(user: user))
            : Get.offAll(() => const MailVerification());
  }

  /* ------------------------Email Password sign in-------------------------- */

  //Register emailAuth
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      Helper.errorSnackBar(title: "Error", message: ex.message);
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      Helper.errorSnackBar(title: "Error", message: ex.message);
    }
    return null;
  }

  //Login emailAuth
  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      final ex = LogInWithEmailAndPasswordFailure.code(e.code);
      return ex.message;
    } catch (_) {
      const ex = LogInWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }

  //Verification emailAuth
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = TExceptions();
      throw ex.message;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Helper.successSnackBar(title: "Success", message: "Password reset email sent successfully to your mail id");
    } on FirebaseAuthException catch (e) {
      final ex = LogInWithEmailAndPasswordFailure.code(e.code);
      Helper.errorSnackBar(title: "Error", message: ex.message);
    }
  }

  //Logout emailAuth
  Future<void> logout() async {
    try {
      // GoogleSignIn().signOut();
      FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Unable to logout. Try again!';
    }
  }

/* ------------------------Google sign in-------------------------- */
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = TExceptions();
      throw ex.message;
    }
  }
}
