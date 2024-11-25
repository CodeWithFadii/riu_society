import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/user/forum/controllers/forum_controller.dart';
import 'package:riu_society/roles/user/forum/model/forum_model.dart';
import 'package:riu_society/roles/user/forum/views/create_forum.dart';
import 'package:riu_society/roles/user/profile/controller/profile_controller.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/functions.dart';
import 'package:riu_society/utils/widgets/forum_widget.dart';
import 'package:riu_society/utils/widgets/simple_textfield.dart';
import 'search_forum.dart';

class Forum extends StatelessWidget {
  Forum({super.key, this.admin = false});
  final bool admin;
  final ForumController forumC = Get.put(ForumController());
  final String userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        title: const Text('Community Forum'),
        actions: [
          //checking forum module opened in admin side or not
          IconButton(
            onPressed: () async {
              if (ProfileController().status.value == 'pending') {
                Get.back();
                return rawSackbar(
                    'Your profile is not approved by the admin yet, so you cannot create.');
              }
              if (ProfileController().status.value == 'rejected') {
                Get.back();
                return rawSackbar(
                    'Your profile is rejected by the admin, so you cannot create.');
              }
              Get.dialog(CreateForum(
                admin: admin,
              ));
            },
            icon: const Icon(
              Iconsax.add_square,
              size: 28,
            ),
          )
        ],
      ),
      body: Obx(
        () {
          return StreamBuilder<List<ForumModel>>(
            stream: forumC.sortIndex.value == 2
                ? forumC.getMyPosts()
                : forumC.getAllPosts(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Please check your internet connection\nand try again!',
                    style: AppTextStyle.regularBlack14,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<ForumModel> forumList = forumC.sortIndex.value == 1
                  ? forumC.popularList
                  : snapshot.data!;
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 16, left: 14, right: 14),
                        child: SimpleTextField(
                          width: width,
                          controller: forumC.notWorking,
                          hint: 'Find Post By Community Name...',
                          trailing: Iconsax.search_normal,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() {
                            return SearchForum(
                              forumC: forumC,
                            );
                          });
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: const BoxDecoration(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              forumC.sortIndex(0);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: forumC.sortIndex.value == 0
                                    ? AppColors.secondary.withOpacity(0.6)
                                    : AppColors.secondary.withOpacity(0.2),
                              ),
                              child: Text(
                                'Recent',
                                style: AppTextStyle.regularBlack14,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (forumC.sortIndex.value == 0 ||
                                  forumC.sortIndex.value == 1) {
                                forumC.popularList.value = snapshot.data!;
                                forumC.sortList(forumC.popularList);
                              }
                              forumC.sortIndex(1);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: forumC.sortIndex.value == 1
                                    ? AppColors.secondary.withOpacity(0.6)
                                    : AppColors.secondary.withOpacity(0.2),
                              ),
                              child: Text(
                                'Most Popular',
                                style: AppTextStyle.regularBlack14,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              forumC.sortIndex(2);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: forumC.sortIndex.value == 2
                                    ? AppColors.secondary.withOpacity(0.6)
                                    : AppColors.secondary.withOpacity(0.2),
                              ),
                              child: Text(
                                'My Posts',
                                style: AppTextStyle.regularBlack14,
                              ),
                            ),
                          ),
                          const Icon(Iconsax.document_filter),
                        ],
                      )),
                  snapshot.data!.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: forumList.length,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 20, left: 16, right: 16),
                            itemBuilder: (context, index) {
                              return ForumWidget(
                                forum: forumList[index],
                                controller: forumC,
                                sortForum: forumC.sortIndex.value == 1
                                    ? forumC.popularList[index]
                                    : forumList[index],
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            'No Posts Available',
                            style: AppTextStyle.mediumBlack16,
                          ),
                        ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
