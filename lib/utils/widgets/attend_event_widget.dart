import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/admin/home/events/models/event_model.dart';
import 'package:riu_society/roles/user/dashboard/home/events/event_detail.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';

class AttendEventWidget extends StatelessWidget {
  const AttendEventWidget({
    super.key,
    required this.event,
  });
  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => EventDetail(event: event));
      },
      child: Container(
        width: 190,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  //image
                  image: NetworkImage(event.image!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              //title
              event.title!,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTextStyle.boldBlack14,
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
                  //date
                  event.date!,
                  style: AppTextStyle.regularBlack14.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              children: [
                const Icon(
                  Iconsax.location,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  //city
                  event.city!,
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
