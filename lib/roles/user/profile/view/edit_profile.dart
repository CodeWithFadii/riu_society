import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/home/home.dart';
import 'package:riu_society/roles/user/dashboard/dashboard.dart';
import 'package:riu_society/roles/user/profile/controller/create_profile_controller.dart';
import 'package:riu_society/roles/user/profile/controller/profile_controller.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/functions.dart';
import 'package:riu_society/utils/widgets/material_button.dart';
import 'package:riu_society/utils/widgets/select_community.dart';
import 'package:riu_society/utils/widgets/select_departmen.dart';
import 'package:riu_society/utils/widgets/simple_textfield.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  final CreateProfileController createprofileC =
      Get.put(CreateProfileController());
  final ProfileController profileC = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Edit Profile',
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
                        await createprofileC.getProfileImage();
                      }),
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 100,
                        color: AppColors.lightGrey,
                        child: createprofileC.profileImage.value.path == ''
                            ? Image.network(
                                profileC.image.value,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Image.file(
                                File(createprofileC.profileImage.value.path),
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
                  const SizedBox(height: 16),
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
                  SimpleTextField(
                    borderRadius: 10,
                    controller: profileC.phoneC,
                    width: double.infinity,
                    hint: 'Mobile Number*',
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
                        createprofileC.department.isNotEmpty
                            ? createprofileC.department['name']
                                .toString()
                                .capitalize!
                            : profileC.department.value,
                        style: AppTextStyle.regularBlack16
                            .copyWith(color: AppColors.black),
                      ),
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
                        createprofileC.community.isNotEmpty
                            ? createprofileC.community['name']
                                .toString()
                                .capitalize!
                            : profileC.societyName.value,
                        style: AppTextStyle.regularBlack16
                            .copyWith(color: AppColors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GestureDetector(
                        onTap: (() async {
                          await createprofileC.getCardImage();
                        }),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 200,
                          color: AppColors.lightGrey,
                          child: createprofileC.cardImage.value.path == ''
                              ? Image.network(
                                  profileC.card.value,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Image.file(
                                  File(createprofileC.cardImage.value.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                        )),
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
                    onPressed: () async {
                      if (profileC.societyName.value == 'N/A' &&
                          createprofileC.community.isEmpty) {
                        return snackbar('Missing Data',
                            'Select a society first to continue');
                      }
                      await createprofileC.updateProfile(
                          fullName: profileC.nameC.text,
                          dep: profileC.department.value,
                          phone: profileC.phoneC.text,
                          communityy: createprofileC.community,
                          image: profileC.image.value,
                          imageCard: profileC.card.value,
                          societyID: profileC.societyId.value,
                          societyName: profileC.societyName.value,
                          rollno: profileC.rollnoC.text.toString(),
                          student: profileC.student.value);
                      profileC.role.value == 'sub-admin'
                          ? Get.offAll(
                              () => const AdminHome(),
                            )
                          : Get.offAll(
                              () => const Dashboard(),
                            );
                    },
                    height: 50,
                    width: 170,
                    text: Text(
                      'Update',
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
