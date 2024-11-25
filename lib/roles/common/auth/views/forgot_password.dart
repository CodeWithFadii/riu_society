import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/common/auth/controllers/auth_controller.dart';
import 'package:riu_society/roles/common/auth/views/login.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/functions.dart';
import 'package:riu_society/utils/widgets/app_button.dart';
import 'package:riu_society/utils/widgets/app_textfield.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final TextEditingController emailC = TextEditingController();

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
              'Please enter your email to get link for new password',
              textAlign: TextAlign.center,
              style: AppTextStyle.regularBlack16.copyWith(color: AppColors.grey),
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
                    inputAction: TextInputAction.done,
                    hint: 'Enter your email',
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  SizedBox(
                    height: height * 0.07,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    width: width * 0.6,
                    height: 65,
                    text: 'Send',
                    onTap: () {
                      if (emailC.text.isEmpty) {
                        snackbar('Warning!', 'Email address is required.');
                        return;
                      }
                      if (!GetUtils.isEmail(emailC.text)) {
                        snackbar('Warning!', 'Enter a valid email address.');
                        return;
                      }
                      AuthController().resetPassword(emailC.text);
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Know your password? ',
                        style: AppTextStyle.regularBlack14.copyWith(color: AppColors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => Login());
                        },
                        child: Text(
                          'Login',
                          style: AppTextStyle.boldBlack14.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
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
