import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/home/home.dart';
import 'package:riu_society/roles/common/auth/views/login.dart';
import 'package:riu_society/roles/common/auth/views/verify_email.dart';
import 'package:riu_society/roles/common/notification/fcm_service.dart';
import 'package:riu_society/roles/user/dashboard/dashboard.dart';
import 'package:riu_society/roles/user/profile/view/create_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

String uuid = '';
String name = '';

class _SplashScreenState extends State<SplashScreen> {
  Future<String> getRole() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? currentUser = auth.currentUser;
    if (currentUser == null) return '';
    uuid = currentUser.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('users').doc(currentUser.uid).get();
    if (snapshot.exists) {
      //updating token of user and saving in firestore
      final String? token = await FirebaseService.firebaseMessaging.getToken();
      await firestore.collection('users').doc(currentUser.uid).update({
        'fcm_token': token,
      });
      //to notify only users for new events
      if (snapshot.data()?['role'] != 'admin') {
        print('subscribed');
        await FirebaseService.firebaseMessaging.subscribeToTopic('events');
      }
      String role = snapshot.data()?['role'] ?? '';
      name = snapshot.data()?['name'] ?? '';
      return role;
    } else {
      return '';
    }
  }

  timer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String role = await getRole();
    var userVerified = await checkEmailVerification();
    var duration = const Duration(seconds: 2);
    var isLogged = prefs.getBool('isLogged');
    bool social = prefs.getBool('social') ?? false;

    return Timer(
      duration,
      () async {
        isLogged == true
            ? role == 'admin' || role == 'sub-admin'
                ? await Get.offAll(() => const AdminHome())
                : userVerified || social
                    ? role == ''
                        ? await Get.offAll(() => CreateProfile())
                        : await Get.offAll(() => const Dashboard())
                    : await Get.offAll(() => const VerifyEmail())
            : await Get.offAll(() => Login());
      },
    );
  }

  // Check if user's email is verified...

  Future checkEmailVerification() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    bool isVerified = user.emailVerified;
    return isVerified;
  }

  @override
  void initState() {
    super.initState();
    timer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            "assets/images/rs_logo.png",
            width: 250,
          ),
        ),
      ),
    );
  }
}
