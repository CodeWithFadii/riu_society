import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/admin/home/events/models/event_model.dart';
import 'package:riu_society/roles/user/dashboard/home/events/event_detail.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';

class EventWidget extends StatelessWidget {
  const EventWidget(
      {super.key,
      required this.doc,
      this.margin,
      this.boxShadow,});
  final DocumentSnapshot doc;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    EventModel model = EventModel(
        image: doc['image'],
        title: doc['title'],
        description: doc['description'],
        date: doc['date'],
        fee: doc['fee'],
        city: doc['city'],
        address: doc['location'],
        participants: List.from(doc['participants']),
        communityId: doc['community_id'],
        communityName: doc['community_name'],
        id: doc.id);
    return GestureDetector(
      onTap: () {
        Get.to(() => EventDetail(
              event: model,
            ));
      },
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: margin ?? const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: boxShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(doc['image'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              doc['title'],
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTextStyle.boldBlack16,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Iconsax.calendar,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  doc['date'],
                  style: AppTextStyle.regularBlack14.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Iconsax.location,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    doc['location'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.regularBlack14.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: AppColors.grey,
                ),
                const Icon(
                  Iconsax.dollar_square,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  doc['fee'] == '' ? 'Free' : doc['fee'],
                  style: AppTextStyle.regularBlack14.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
