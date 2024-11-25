import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riu_society/roles/common/auth/controllers/auth_controller.dart';
import 'package:riu_society/roles/common/auth/views/login.dart';
import 'package:riu_society/roles/user/profile/view/create_profile.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

bool isEmailVerified = false;
bool canResend = false;
int sec = 30;

class _VerifyEmailState extends State<VerifyEmail> {
  AuthController authC = Get.put(AuthController());
  Timer? timer;
  int start = 20;

  //SIGN OUT METHOD
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogged", false);
    print('signout');
  }

  @override
  void initState() {
    super.initState();
    startTimer();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (timer) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (e) {
      print(e);
    }
  }

  Future checkEmailVerified() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    await FirebaseAuth.instance.currentUser!.reload();

    if (!mounted) return;
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          setState(() {
            if (!mounted) return;
            timer.cancel();
          });
        } else {
          if (!mounted) return;
          setState(() {
            start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return (isEmailVerified)
        ? CreateProfile()
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.07,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/rs_logo.png',
                      height: 220,
                      width: 220,
                    ),
                  ),
                  Text(
                    'Confirm Your Email Address',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grey,
                    ),
                  ),
                  Text(
                    'Check your mailbox!',
                    style: TextStyle(color: AppColors.grey),
                  ),
                  SizedBox(
                    height: Get.height * 0.25,
                  ),
                  SizedBox(
                    height: 50,
                    width: width * 0.47,
                    child: ElevatedButton(
                      onPressed: () {
                        if (start == 0) {
                          sendVerificationEmail();
                          setState(() {
                            start = 20;
                            startTimer();
                          });
                          print('email resent');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            (start == 0) ? AppColors.primary : AppColors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Resend Email',
                        style: AppTextStyle.boldBlack14
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${start}s',
                    style: TextStyle(color: AppColors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      signOut();
                      Get.offAll(() => Login());
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
