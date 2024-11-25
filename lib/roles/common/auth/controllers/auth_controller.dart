import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/home/home.dart';
import 'package:riu_society/roles/common/auth/views/login.dart';
import 'package:riu_society/roles/common/auth/views/splash_screen.dart';
import 'package:riu_society/roles/common/auth/views/verify_email.dart';
import 'package:riu_society/roles/user/dashboard/dashboard.dart';
import 'package:riu_society/roles/user/profile/view/create_profile.dart';
import 'package:riu_society/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  RxBool hideRegisterPass = true.obs;
  RxBool hideLoginPass = true.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  String? role;
  get user => _auth.currentUser;

  // SIGN UP METHOD

  Future<void> signUp(String? email, String? password) async {
    EasyLoading.show();
    try {
       await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      EasyLoading.dismiss();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLogged", true);
      Get.offAll(() => const VerifyEmail());
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      snackbar("Something is wrong!", "User may already exist");
    }
  }

  //SIGN IN METHOD

  Future signIn(String? email, String? password) async {
    EasyLoading.show();
    try {
       await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      EasyLoading.dismiss();
      String userRole = await getRole();
      role = userRole;
      update();
      role == 'admin' || role == 'sub-admin'
          ? Get.offAll(() => const AdminHome())
          : (FirebaseAuth.instance.currentUser!.emailVerified == true)
              ? role != ''
                  ? Get.offAll(() => const Dashboard())
                  : Get.offAll(() => CreateProfile())
              : Get.off(() => const VerifyEmail());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLogged", true);
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      snackbar("Something is wrong!", "Please input the correct information");
    }
  }

  Future<String> getRole() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? currentUser = auth.currentUser;
    if (currentUser == null) return '';
    EasyLoading.show();
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('users').doc(currentUser.uid).get();
    EasyLoading.dismiss();
    String role = snapshot.data()?['role'] ?? '';
    name = snapshot.data()?['name'] ?? '';
    return role;
  }

// Google SignIN

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      EasyLoading.show();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLogged", true);
      await prefs.setBool('social', true);
      await FirebaseAuth.instance.signInWithCredential(credential);
      String userRole = await getRole();
      role = userRole;
      role == 'sub-admin'
          ? Get.offAll(() => const AdminHome())
          : role != ''
              ? Get.offAll(() => const Dashboard())
              : Get.offAll(() => CreateProfile());
      EasyLoading.dismiss();
    }
    // Catch
    catch (e) {
      EasyLoading.dismiss();
      snackbar("Something is wrong!",
          "Please try again or check your google account.");
    }
  }

  void resetPassword(String email) async {
    try {
      EasyLoading.show();
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.offAll(() => Login());
      EasyLoading.dismiss();
      snackbar('Email Sent!',
          'We have sent an email with link to reset your password.',
          icon: Icons.check);
    } on FirebaseException catch (e) {
      EasyLoading.dismiss();
      snackbar('Something went wrong!', e.message.toString());
    }
  }

  Future signOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogged", false);
    print('signout');
  }
}
