import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/common/auth/views/login.dart';
import 'package:riu_society/roles/user/profile/controller/create_profile_controller.dart';
import 'package:riu_society/utils/widgets/select_community.dart';
import 'package:riu_society/utils/widgets/select_departmen.dart';
import 'package:riu_society/utils/widgets/simple_textfield.dart';
import '../../../../utils/app_textstyle.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/widgets/material_button.dart';

// ignore: must_be_immutable
class CreateProfile extends StatelessWidget {
  CreateProfile({super.key});

  final CreateProfileController profileC = Get.put(CreateProfileController());

  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Get.offAll(() => Login());
          },
        ),
        title: Text(
          'Create Profile',
          style: AppTextStyle.regularWhite18,
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GestureDetector(
                      onTap: (() async {
                        await profileC.getProfileImage();
                      }),
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 100,
                        color: AppColors.lightGrey,
                        child: profileC.profileImage.value.path == ''
                            ? Icon(
                                Icons.camera_alt,
                                color: AppColors.grey,
                                size: 32,
                              )
                            : Image.file(
                                File(profileC.profileImage.value.path),
                                fit: BoxFit.cover,
                                
                                width: double.infinity,
                                height: double.infinity,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SimpleTextField(
                    borderRadius: 10,
                    controller: profileC.nameC,
                    width: double.infinity,
                    hint: 'Full Name*',
                    hintstyle: AppTextStyle.regularBlack16.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Student',
                        style: profileC.student.value
                            ? AppTextStyle.mediumBlack16
                            : AppTextStyle.mediumBlack16
                                .copyWith(color: AppColors.grey),
                      ),
                      Checkbox(
                          value: profileC.student.value,
                          onChanged: (value) {
                            profileC.student(true);
                          }),
                      const SizedBox(width: 8),
                      Text(
                        'Teacher',
                        style: !profileC.student.value
                            ? AppTextStyle.mediumBlack16
                            : AppTextStyle.mediumBlack16
                                .copyWith(color: AppColors.grey),
                      ),
                      Checkbox(
                          value: !profileC.student.value,
                          onChanged: (value) {
                            profileC.student(false);
                          }),
                    ],
                  ),
                  const SizedBox(height: 7),
                  profileC.student.value
                      ? SimpleTextField(
                          borderRadius: 10,
                          controller: profileC.rollnoC,
                          width: double.infinity,
                          hint: 'Roll No.',
                          hintstyle: AppTextStyle.regularBlack16.copyWith(
                            color: AppColors.grey,
                          ),
                        )
                      : Container(),
                  profileC.student.value
                      ? const SizedBox(height: 16)
                      : Container(),


                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return SelectDepartment();
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      width: sizew,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        profileC.department.isNotEmpty
                            ? profileC.department['name'].toString().capitalize!
                            : 'Tap to Select Department*',
                        style: AppTextStyle.regularBlack16.copyWith(
                          color: profileC.department.isNotEmpty
                              ? AppColors.black
                              : AppColors.grey,
                        ),
                      ),
                    ),
                  ),


                  
                  const SizedBox(height: 16),
                  SimpleTextField(
                    borderRadius: 10,
                    controller: profileC.phoneC,
                    width: double.infinity,
                    hint: 'Mobile Number',
                    hintstyle: AppTextStyle.regularBlack16.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return SelectSociety();
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      width: sizew,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        profileC.community.isNotEmpty
                            ? profileC.community['name'].toString().capitalize!
                            : 'Tap to Select Society*',
                        style: AppTextStyle.regularBlack16.copyWith(
                          color: profileC.community.isNotEmpty
                              ? AppColors.black
                              : AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GestureDetector(
                      onTap: (() async {
                        await profileC.getCardImage();
                      }),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 200,
                        color: AppColors.lightGrey,
                        child: profileC.cardImage.value.path == ''
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.gallery,
                                    color: AppColors.grey,
                                    size: 34,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'University Card Image',
                                    style: AppTextStyle.regularBlack14.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  Text(
                                    '(Front Side)',
                                    style: AppTextStyle.regularBlack12.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              )
                            : Image.file(
                                File(profileC.cardImage.value.path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: sizew * 0.8,
                    child: Text(
                      'Note: Your account will be submitted to the admin for verification, so make sure to submit correct information.',
                      style: AppTextStyle.mediumBlack14.copyWith(height: 1.2),
                    ),
                  ),
                  const SizedBox(height: 25),
                  MaterialButtonWidget(
                    onPressed: () {
                      profileC.createProfile(
                        fullName: profileC.nameC.text,
                        department: profileC.department,
                        phone: profileC.phoneC.text,
                        rollno: profileC.rollnoC.text,
                        community: profileC.community,
                        image: profileC.profileImage.value,
                        card: profileC.cardImage.value,
                      );
                    },
                    height: 50,
                    width: 170,
                    text: Text(
                      'Create',
                      style: AppTextStyle.regularWhite16,
                    ),
                    color: AppColors.black,
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
