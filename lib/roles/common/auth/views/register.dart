import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/common/auth/controllers/auth_controller.dart';
import 'package:riu_society/roles/user/dashboard/dashboard.dart';
import 'package:riu_society/roles/user/profile/view/create_profile.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/functions.dart';
import 'package:riu_society/utils/widgets/app_button.dart';
import 'package:riu_society/utils/widgets/app_textfield.dart';

class Register extends StatelessWidget {
  Register({super.key});
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.07,
            ),
            Image.asset(
              'assets/images/rs_logo.png',
              height: 60,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Please enter your email address\nand create password',
              textAlign: TextAlign.center,
              style:
                  AppTextStyle.regularBlack16.copyWith(color: AppColors.grey),
            ),
            SizedBox(
              height: height * 0.07,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextField(
                    width: width,
                    controller: emailC,
                    leading: Iconsax.sms,
                    inputType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next,
                    hint: 'Enter your Email',
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Obx(() {
                    return AppTextField(
                      width: width,
                      controller: passC,
                      obsecure: authController.hideRegisterPass.value,
                      leading: Iconsax.lock,
                      trailing: authController.hideRegisterPass.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.done,
                      hint: 'Create Password',
                      onTrailingTap: () {
                        authController.hideRegisterPass.value =
                            !authController.hideRegisterPass.value;
                      },
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 22,
                  ),
                  AppButton(
                    width: width * 0.6,
                    height: 65,
                    text: 'Sign Up',
                    onTap: () async {
                      if (emailC.text.isEmpty || passC.text.isEmpty) {
                        snackbar('Warning!', 'Both fields are required.');
                        return;
                      }
                      if (!GetUtils.isEmail(emailC.text)) {
                        snackbar('Warning!', 'Enter a valid email address.');
                        return;
                      }
                      if (passC.text.length < 6) {
                        snackbar('Warning!',
                            'Password must contain at least 6 characters.');
                        return;
                      }
                      await authController.signUp(
                        emailC.text,
                        passC.text,
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTextStyle.regularBlack14
                            .copyWith(color: AppColors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          'Login',
                          style: AppTextStyle.boldBlack14
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 2,
                          color: AppColors.lightGrey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Sign in with',
                          style: AppTextStyle.regularBlack14
                              .copyWith(color: AppColors.grey),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 2,
                          color: AppColors.lightGrey,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      UserCredential? credientials =
                          await authController.signInWithGoogle();
                      if (credientials != null) return;
                      User? currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser == null) return;
                      CollectionReference<Map<String, dynamic>> users =
                          FirebaseFirestore.instance.collection('users');
                      DocumentSnapshot<Map<String, dynamic>> snapshot =
                          await users.doc(currentUser.uid).get();
                      EasyLoading.dismiss();
                      (snapshot.exists)
                          ? Get.offAll(() => const Dashboard())
                          : Get.offAll(() => CreateProfile());
                    },
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      margin: const EdgeInsets.only(bottom: 20),
                      width: width,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            height: 36,
                          ),
                          Text(
                            'Google',
                            style: AppTextStyle.mediumBlack18,
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
