import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/admin/home/all_users/models/user_model.dart';
import 'package:riu_society/roles/common/notification/send_method.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';

class UserDetailsWidget extends StatelessWidget {
  const UserDetailsWidget({
    super.key,
    required this.user,
    required this.isParticipant,
  });
  final UserModel user;
  final bool isParticipant;
  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width * 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.image!,
                ),
                radius: 30,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name}'.capitalize!,
                    style: AppTextStyle.boldBlack16,
                  ),
                  Text(
                    user.department!,
                    style: AppTextStyle.regularWhite14
                        .copyWith(color: AppColors.grey),
                  ),
                ],
              )
            ],
          ),
          listTileWidget('Email:', user.email!),
          user.student!
              ? listTileWidget('Roll No.:', user.rollno!)
              : Container(),
          listTileWidget('Phone No::', user.phoneNo!),
          listTileWidget('Community:', user.community!),
          const SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID Card Image:',
                style: AppTextStyle.boldBlack16,
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.black,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    user.cardImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          !isParticipant
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.id)
                            .update(
                          {'status': 'rejected'},
                        ).then((value) {
                          SendMethod.sendNotification(
                              'Admin Rejected your profile',
                              'Update your profile and send request to admin for approvel again',
                              user.fcmToken!);
                          Get.back();
                        });
                      },
                      elevation: 0,
                      color: AppColors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Text(
                            'Reject',
                            style: AppTextStyle.mediumBlack14
                                .copyWith(color: AppColors.secondary),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Iconsax.close_square,
                            color: AppColors.secondary,
                            size: sizew * 0.06,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    MaterialButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.id)
                            .update(
                          {'status': 'approved'},
                        ).then((value) => Get.back());
                      },
                      elevation: 0,
                      color: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Text(
                            'Accept',
                            style: AppTextStyle.mediumBlack14,
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Iconsax.tick_square,
                            color: AppColors.black,
                            size: sizew * 0.06,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  Widget listTileWidget(String leading, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Text(
            leading,
            style: AppTextStyle.boldBlack16,
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: AppTextStyle.regularWhite14.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
