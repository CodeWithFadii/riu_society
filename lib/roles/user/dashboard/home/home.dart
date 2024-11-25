import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/user/dashboard/home/events/all_events.dart';
import 'package:riu_society/roles/user/dashboard/home/events/search_event.dart';
import 'package:riu_society/roles/user/dashboard/home/user_notifications.dart';
import 'package:riu_society/roles/user/profile/controller/profile_controller.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/widgets/event_widget.dart';
import 'package:riu_society/utils/widgets/simple_textfield.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final TextEditingController searchC = TextEditingController();
  final ProfileController profileC = Get.put(ProfileController());
  final Stream<QuerySnapshot<Map<String, dynamic>>> eventStream =
      FirebaseFirestore.instance
          .collection('events')
          .orderBy('time_stamp')
          .snapshots();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 580,
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      height: 380,
                      width: width,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      color: AppColors.primary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 55,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/rs_logo_white.png',
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => UserNotifications());
                                },
                                child: const Icon(
                                  Icons.notifications,
                                  size: 26,
                                  color: AppColors.white,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Obx(() => Text(
                                'Hello, ${profileC.name.value}'.capitalize!,
                                style: AppTextStyle.regularBlack14
                                    .copyWith(color: AppColors.lightGrey),
                              )),
                          Text(
                            'Discover Amazing Events',
                            style: AppTextStyle.boldBlack20
                                .copyWith(color: AppColors.lightGrey),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Stack(
                            children: [
                              SimpleTextField(
                                width: width,
                                controller: searchC,
                                hint: 'Find events by community name...',
                                trailing: Iconsax.search_normal,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(() => const SearchEvent());
                                  },
                                  child: Container(
                                    height: 60,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Popular Events',
                                style: AppTextStyle.boldBlack16
                                    .copyWith(color: AppColors.lightGrey),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => AllEvents());
                                },
                                child: Text(
                                  'View All',
                                  style: AppTextStyle.regularBlack14
                                      .copyWith(color: AppColors.secondary),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 270,
                    width: width,
                    child: StreamBuilder(
                      stream: eventStream,
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Please check your internet connection\nand try again!',
                              style: AppTextStyle.regularBlack14,
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(left: 14),
                          itemCount: snapshot.data!.docs.length <= 5
                              ? snapshot.data!.docs.length
                              : 5,
                          itemBuilder: (context, index) {
                            var docs = snapshot.data!.docs[index];
                            return EventWidget(doc: docs);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  Text(
                    'Campus Map',
                    style: AppTextStyle.boldBlack18
                        .copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(
                    Iconsax.map,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            Container(
              width: width,
              height: 250,
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/campus_map.jpg',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
