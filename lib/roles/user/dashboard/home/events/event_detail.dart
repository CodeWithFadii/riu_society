import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/admin/home/events/models/event_model.dart';
import 'package:riu_society/roles/user/profile/controller/profile_controller.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/functions.dart';
import 'package:riu_society/utils/widgets/material_button.dart';

class EventDetail extends StatelessWidget {
  EventDetail({super.key, required this.event});
  final EventModel event;
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  final ProfileController profileC = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width * 1;
    final sizeh = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Event Detail',
          style: AppTextStyle.regularWhite18,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  child: Container(
                    width: double.infinity,
                    height: sizeh * 0.3,
                    color: AppColors.lightGrey,
                    child: Image.network(
                      event.image ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: sizeh * 0.010,
                    ),
                    Wrap(
                      spacing: 11,
                      direction: Axis.vertical,
                      children: [
                        Text(
                          event.title ?? '',
                          style: AppTextStyle.boldBlack18,
                        ),
                        Wrap(
                          spacing: 15,
                          children: [
                            Wrap(
                              spacing: 10,
                              children: [
                                const Icon(
                                  Iconsax.calendar_add,
                                ),
                                Text(
                                  event.date ?? '',
                                  style: AppTextStyle.regularBlack16,
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 10,
                              children: [
                                const Icon(
                                  Iconsax.dollar_square,
                                ),
                                Text(
                                  event.fee!.isEmpty
                                      ? 'Free'
                                      : 'Rs. ${event.fee}',
                                  style: AppTextStyle.regularBlack16,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 10,
                          children: [
                            const Icon(
                              Iconsax.location,
                            ),
                            SizedBox(
                              width: sizew * 0.8,
                              child: Text(
                                '${event.address} (${event.city})',
                                style: AppTextStyle.regularBlack16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Description (${event.communityName})',
                          style: AppTextStyle.boldBlack18,
                        ),
                        SizedBox(
                          width: sizew * 0.89,
                          child: Text(
                            event.description ?? '',
                            style: AppTextStyle.regularBlack16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: MaterialButtonWidget(
                        onPressed: () async {
                          if (profileC.status.value == 'pending') {
                            Get.back();
                            return rawSackbar(
                                'Your profile is not approved by the admin yet, so you cannot participate');
                          }
                          if (profileC.status.value == 'rejected') {
                            Get.back();
                            return rawSackbar(
                                'Your profile is rejected by the admin, so you cannot participate');
                          }

                          if (event.participants!.contains(userUid)) {
                            await removeEvent(event.id!);
                            profileC.getProfile();
                          } else {
                            await attendEvent(event.id!);
                            profileC.getProfile();
                          }
                        },
                        height: 50,
                        text: Text(
                          event.participants!.contains(userUid)
                              ? 'Walked Out Event'
                              : 'Attend Event',
                          style: AppTextStyle.regularWhite16,
                        ),
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future attendEvent(String docID) async {
    try {
      EasyLoading.show();
      await FirebaseFirestore.instance.collection('events').doc(docID).update({
        'participants': FieldValue.arrayUnion([userUid]),
      }).then((value) {
        FirebaseFirestore.instance.collection('users').doc(userUid).update({
          'events': FieldValue.arrayUnion([docID]),
        });
      }).then((value) {
        EasyLoading.dismiss();
        Get.back();
        rawSackbar('You are successfully added to attendies');
      });
    } on Exception {
      snackbar('Error while partcipating',
          'Check your internet connection or try again');
      EasyLoading.dismiss();
    }
  }

  Future removeEvent(String docID) async {
    try {
      EasyLoading.show();
      await FirebaseFirestore.instance.collection('events').doc(docID).update({
        'participants': FieldValue.arrayRemove([userUid]),
      }).then((value) {
        FirebaseFirestore.instance.collection('users').doc(userUid).update({
          'events': FieldValue.arrayRemove([docID]),
        });
      }).then((value) {
        EasyLoading.dismiss();
        Get.back();
        rawSackbar('You are successfully removed from attendies');
      });
    } on Exception {
      snackbar('Error while partcipating',
          'Check your internet connection or try again');
      EasyLoading.dismiss();
    }
  }
}
