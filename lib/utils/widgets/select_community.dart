import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/events/controllers/create_event_controller.dart';
import 'package:riu_society/roles/user/profile/controller/create_profile_controller.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';

class SelectSociety extends StatelessWidget {
  SelectSociety({
    super.key,
    this.eventSide = false,
    this.eventC,
  });
  final bool eventSide;
  final CreateEventController? eventC;
  final CreateProfileController profileC = Get.put(CreateProfileController());
  final Stream<QuerySnapshot> communities =
      FirebaseFirestore.instance.collection('societies').snapshots();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ),
              Text(
                'Tap to Select',
                style: AppTextStyle.mediumBlack14,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.check),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: communities,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
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
                      return Text(
                        'No Community Found',
                        style: AppTextStyle.regularBlack14,
                      );
                    }
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (eventSide) {
                              eventC!.community.value = {
                                'id': docs[index].id,
                                'name': docs[index]['name'],
                              };
                            } else {
                              profileC.community.value = {
                                'id': docs[index].id,
                                'name': docs[index]['name'],
                              };
                            }
                          },
                          child: Obx(() {
                            return Container(
                              height: 55,
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: eventSide
                                    ? !eventC!.community
                                            .containsValue(docs[index].id)
                                        ? AppColors.white
                                        : AppColors.secondary
                                    : !profileC.community
                                            .containsValue(docs[index].id)
                                        ? AppColors.white
                                        : AppColors.secondary,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: eventSide
                                      ? !eventC!.community
                                              .containsValue(docs[index].id)
                                          ? AppColors.primary
                                          : AppColors.secondary
                                      : !profileC.community
                                              .containsValue(docs[index].id)
                                          ? AppColors.primary
                                          : AppColors.secondary,
                                ),
                              ),
                              child: Text(
                                docs[index]['name'].toString().capitalize!,
                                style: AppTextStyle.regularBlack14,
                              ),
                            );
                          }),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
