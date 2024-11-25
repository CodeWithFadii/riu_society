import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/common/auth/controllers/auth_controller.dart';
import 'package:riu_society/roles/common/auth/views/login.dart';
import 'package:riu_society/roles/user/profile/controller/profile_controller.dart';
import 'package:riu_society/roles/user/profile/view/chat_admins.dart';
import 'package:riu_society/roles/user/profile/view/edit_profile.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/roles/user/profile/view/society_members.dart';
import 'package:riu_society/utils/functions.dart';
import 'package:riu_society/utils/widgets/attend_event_widget.dart';
import 'package:riu_society/utils/widgets/drawer_list_tile.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  final ProfileController profileC = Get.put(ProfileController());
  final List optionsList = <String>['Refresh', 'Logout'];
  final userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        title: const Text('My Account'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert_outlined),
            itemBuilder: (BuildContext context) {
              return optionsList.map((e) {
                return PopupMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: AppTextStyle.mediumBlack16,
                  ),
                );
              }).toList();
            },
            onSelected: (value) {
              if (value == optionsList[0]) {
                profileC.getProfile();
              }
              if (value == optionsList[1]) {
                AuthController().signOut();
                Get.offAll(() => Login());
              }
            },
          )
        ],
      ),
      body: Obx(
        () {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              profileC.status.value == 'rejected'
                  ? Container(
                      width: width,
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            'Your profile is rejected by the admin, update your profile and send request again.',
                            style: AppTextStyle.regularBlack14,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              if (profileC.status.value == 'rejected') {
                                confirmDefaultDialog('Send Request',
                                    'Are you sure? Do you want to send request to admin for approvel again',
                                    confirm: () {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userUid)
                                      .update({
                                    'status': 'pending',
                                  }).then((value) {
                                    Get.back();
                                    profileC.getProfile();
                                  });
                                });
                              }
                            },
                            child: Text(
                              'Send',
                              style: AppTextStyle.mediumBlack16,
                            ))
                      ]),
                    )
                  : Container(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(profileC.image.value.toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: profileC.image.isEmpty
                          ? const Icon(
                              Iconsax.user,
                              color: AppColors.primary,
                              size: 30,
                            )
                          : null,
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          //name
                          profileC.name.value.capitalize!,
                          style: AppTextStyle.boldBlack18,
                        ),
                        Row(
                          children: [
                            Text(
                              profileC.department.value,
                              style: AppTextStyle.regularBlack14
                                  .copyWith(color: AppColors.grey),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            //Edit profile
                            GestureDetector(
                              onTap: () {
                                profileC.getEditValue();
                                Get.to(() => EditProfile());
                              },
                              child: const Icon(
                                Iconsax.edit,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                          title: 'QR Code',
                          content: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 16),
                            child: Image.network(
                              profileC.qrCode.value,
                              width: 200,
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.qr_code,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.sms,
                      color: AppColors.primary,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      profileC.email.value,
                      style: AppTextStyle.regularBlack14,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.call,
                      color: AppColors.primary,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      profileC.phone.value,
                      style: AppTextStyle.regularBlack14,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 0.5,
                width: width,
                color: AppColors.grey,
              ),
              Container(
                height: 80,
                width: width,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Iconsax.people),
                        const SizedBox(
                          width: 14,
                        ),
                        Obx(
                          () => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileC.societyName.value.capitalize!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.boldBlack16,
                              ),
                              Text(
                                profileC.membersCount.value == 1
                                    ? '${profileC.membersCount} Member'
                                    : '${profileC.membersCount} Members',
                                style: AppTextStyle.regularBlack14
                                    .copyWith(color: AppColors.grey),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    TextButton(
                      onPressed: () async {
                        if (profileC.status.value == 'pending') {
                          Get.back();
                          return rawSackbar(
                              'Your profile is not approved by the admin yet, so you cannot enter.');
                        }
                        if (profileC.status.value == 'rejected') {
                          Get.back();
                          return rawSackbar(
                              'Your profile is rejected by the admin, so you cannot enter.');
                        }
                        if (profileC.societyId.value == 'N/A') {
                          return rawSackbar('Join a society first');
                        }
                        Get.to(
                          () => SocietyMembers(
                            id: profileC.societyId.value,
                          ),
                        );
                      },
                      child: Text(
                        'View',
                        style: AppTextStyle.mediumBlack16
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              DrawerListTile(
                  onTap: () {
                    Get.to(() => ChatAdmins());
                  },
                  containerColor: AppColors.secondary.withOpacity(0.1),
                  title: 'Chat with sub-admins',
                  icon: Iconsax.message),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: profileC.eventsList.isNotEmpty
                    ? Text(
                        'Events to Attend',
                        style: AppTextStyle.boldBlack18,
                      )
                    : Text(
                        'No Events To Attend',
                        style: AppTextStyle.mediumBlack16,
                      ),
              ),
              SizedBox(
                height: 200,
                width: width,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 14),
                  itemCount: profileC.eventsList.length,
                  itemBuilder: (context, index) {
                    return AttendEventWidget(
                      event: profileC.eventsList[index],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
