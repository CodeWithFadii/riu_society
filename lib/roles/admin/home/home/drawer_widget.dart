import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/admin/home/budget/screens/events_screen.dart';
import 'package:riu_society/roles/admin/home/all_users/screens/all_users.dart';
import 'package:riu_society/roles/admin/home/notifications/notification_screen.dart';
import 'package:riu_society/roles/admin/home/tasks/screens/sub_admin_tasks.dart';
import 'package:riu_society/roles/admin/home/tasks/screens/tasks_screen.dart';
import 'package:riu_society/roles/admin/sub_admin/admin_messages.dart';
import 'package:riu_society/roles/admin/sub_admin/campus_map.dart';
import 'package:riu_society/roles/admin/sub_admin/sub_admins.dart';
import 'package:riu_society/roles/common/auth/controllers/auth_controller.dart';
import 'package:riu_society/roles/common/auth/views/login.dart';
import 'package:riu_society/roles/user/forum/views/forum.dart';
import 'package:riu_society/roles/user/profile/controller/create_profile_controller.dart';
import 'package:riu_society/roles/user/profile/controller/profile_controller.dart';
import 'package:riu_society/roles/user/profile/view/edit_profile.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/widgets/drawer_list_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerAdmin extends StatelessWidget {
  DrawerAdmin({
    super.key,
  });

  final List<IconData> iconList = [
    Icons.assessment_outlined,
    Iconsax.message,
    Icons.account_box_outlined,
    Icons.verified_user_outlined,
    Icons.task_outlined,
    Iconsax.note_14,
    Icons.notifications_active_outlined,
    Icons.logout
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: AppColors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(17)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/images/rs_logo.png',
                    height: 60,
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.black,
                      size: 30,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              //both have access
              DrawerListTile(
                onTap: () {
                  Get.to(() => EventsScreen());
                },
                title: 'Budget Planning',
                icon: iconList[0],
              ),

              //only admin have access
              DrawerListTile(
                onTap: () {
                  Get.to(() => const AllUsers());
                },
                title: 'Users',
                icon: iconList[2],
              ),
              //only admin have access
              DrawerListTile(
                onTap: () {
                  Get.to(() => SubAdmins());
                },
                title: 'Sub Admins',
                icon: iconList[3],
              ),
              //both can access
              DrawerListTile(
                onTap: () {
                  Get.to(() => TasksScreen());
                },
                title: 'Tasks',
                icon: iconList[4],
              ),
              DrawerListTile(
                onTap: () {
                  Get.to(() => Forum(
                        admin: true,
                      ));
                },
                title: 'Forums',
                icon: iconList[5],
              ),
              DrawerListTile(
                onTap: () {
                  Get.to(() => NotificationScreen());
                },
                title: 'Notifications',
                icon: iconList[6],
              ),
              const Spacer(),
              const Divider(
                color: AppColors.black,
              ),
              DrawerListTile(
                onTap: () async {
                  await AuthController().signOut();
                  Get.offAll(() => Login());
                },
                title: 'Logout',
                icon: iconList[7],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DrawerSubAdmin extends StatelessWidget {
  DrawerSubAdmin(
      {super.key,
      required this.doc,
      required this.taskCount,
      required this.notificationLength,
      required this.pref});
  final DocumentSnapshot doc;
  final int taskCount;
  final SharedPreferences pref;
  final int notificationLength;
  final CreateProfileController createprofileC =
      Get.put(CreateProfileController());
  final ProfileController profileC = Get.put(ProfileController());
  final List<IconData> iconList = [
    Icons.assessment_outlined,
    Iconsax.message,
    Icons.account_box_outlined,
    Icons.verified_user_outlined,
    Icons.task_outlined,
    Iconsax.note_14,
    Iconsax.map,
    Icons.notifications_active_outlined,
    Icons.logout
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: AppColors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(17)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 45),
                  Image.asset(
                    'assets/images/rs_logo.png',
                    height: 45,
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 38,
                    backgroundImage: NetworkImage(doc['image']),
                    backgroundColor: AppColors.secondary,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${doc['name']}'.capitalize!,
                            style: AppTextStyle.boldBlack18,
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () async {
                              Get.to(() => EditProfile());
                              await profileC.getProfile();
                              await profileC.getEditValue();
                            },
                            child: const Icon(
                              Iconsax.edit,
                              size: 18,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        doc['student']
                            ? '${doc['department']}🧑‍🎓 '
                            : '${doc['department']}🧑‍🏫 ',
                        style: AppTextStyle.regularBlack14
                            .copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              //both have access
              DrawerListTile(
                onTap: () {
                  Get.to(() => EventsScreen());
                },
                title: 'Budget Planning',
                icon: iconList[0],
              ),
              //only sub-admin have access
              DrawerListTile(
                onTap: () {
                  Get.to(() => AdminMessages());
                },
                title: 'Messages',
                icon: iconList[1],
              ),
              DrawerListTile(
                onTap: () {
                  Get.to(() => Forum());
                },
                title: 'Forums',
                icon: iconList[5],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => NotificationScreen(
                          admin: false,
                          pref: pref,
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: AppColors.white),
                    child: Row(
                      children: [
                        Icon(iconList[7], color: AppColors.black),
                        const SizedBox(width: 15),
                        Text(
                          'Notifications',
                          style: AppTextStyle.mediumBlack16
                              .copyWith(color: AppColors.black),
                        ),
                        const Spacer(),
                        Text(
                          pref.getInt('notification_length') != null
                              ? notificationLength >
                                      pref
                                          .getInt('notification_length')!
                                          .toInt()
                                  ? 'New'
                                  : ''
                              : '',
                          style: AppTextStyle.boldBlack14
                              .copyWith(color: Colors.red),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              DrawerListTile(
                onTap: () async {
                  Get.to(() => const CampusMap());
                },
                title: 'Campus Map',
                icon: iconList[6],
              ),
              //both can access
              DrawerListTile(
                onTap: () {
                  Get.to(() => SubAdminTasks());
                },
                title: 'Tasks',
                trailingText: taskCount.toString(),
                trailing: taskCount == 0 ? false : true,
                icon: iconList[4],
              ),

              const Spacer(),
              const Divider(
                color: AppColors.black,
              ),
              DrawerListTile(
                onTap: () async {
                  await AuthController().signOut();
                  Get.offAll(() => Login());
                },
                title: 'Logout',
                icon: iconList[8],
              )
            ],
          ),
        ),
      ),
    );
  }
}
