import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/admin/home/notifications/create_notification.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key, this.admin = true, this.pref});
  final bool admin;
  final SharedPreferences? pref;
  static final userUid = FirebaseAuth.instance.currentUser!.uid;

  final Stream<QuerySnapshot> stream = FirebaseFirestore.instance
      .collection('notifications')
      .orderBy('time_stamp', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Notifications',
          style: AppTextStyle.regularWhite18,
        ),
        actions: [
          admin
              ? IconButton(
                  onPressed: () {
                    Get.dialog(CreateNotification());
                  },
                  icon: const Icon(
                    Iconsax.add_square,
                    size: 28,
                  ),
                )
              : Container()
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: SizedBox(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Please check your internet connection\nand try again!',
                            style: AppTextStyle.regularBlack14,
                          ),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No Notification Found',
                            style: AppTextStyle.regularBlack14,
                          ),
                        );
                      }
                  }

                  if (!admin) {
                    pref!.setInt(
                        'notification_length', snapshot.data!.docs.length);
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            top: 14, left: 14, right: 14, bottom: 14),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: const Offset(
                                  3, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${doc['title']}'.capitalize!,
                                  style: AppTextStyle.boldBlack14,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  doc['description'],
                                  style: AppTextStyle.regularBlack14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
