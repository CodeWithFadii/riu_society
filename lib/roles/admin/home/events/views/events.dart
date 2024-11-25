import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/admin/home/events/models/event_model.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'event_details.dart';

Widget eventsWidget(context) {
  final sizew = MediaQuery.of(context).size.width * 1;
  late final Stream<QuerySnapshot> events =
      FirebaseFirestore.instance.collection('events').snapshots();
  return StreamBuilder<QuerySnapshot>(
    stream: events,
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
            return Expanded(
              child: Center(
                child: Text(
                  'Please check your internet connection\nand try again!',
                  style: AppTextStyle.regularBlack14,
                ),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Expanded(
              child: Center(
                child: Text(
                  'No Event Found',
                  style: AppTextStyle.regularBlack14,
                ),
              ),
            );
          }
          final docs = snapshot.data!.docs;
          return Expanded(
            child: ListView.builder(
              itemCount: docs.length,
              padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
              physics: const BouncingScrollPhysics(),
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () {
                    EventModel model = EventModel(
                        image: docs[index]['image'],
                        title: docs[index]['title'],
                        city: docs[index]['city'],
                        description: docs[index]['description'],
                        date: docs[index]['date'],
                        fee: docs[index]['fee'],
                        address: docs[index]['location'],
                        communityId: docs[index]['community_id'],
                        communityName: docs[index]['community_name'],
                        id: docs[index].id);
                    Get.to(() => EventDetails(event: model));
                  },
                  child: Container(
                    height: 81,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: sizew * 0.040,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                height: 58,
                                width: 65,
                                child: Image.network(
                                  docs[index]['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Wrap(
                              spacing: 5,
                              direction: Axis.vertical,
                              children: [
                                SizedBox(
                                  width: sizew * 0.5,
                                  child: Text(
                                    docs[index]['title'],
                                    style: AppTextStyle.boldBlack16.copyWith(
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                Text(
                                  docs[index]['date'],
                                  style: TextStyle(color: AppColors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(
                          Iconsax.more_square,
                          color: AppColors.black,
                          size: sizew * 0.07,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
      }
    },
  );
}
