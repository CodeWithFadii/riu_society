import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/user/forum/model/forum_model.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import '../../roles/user/forum/controllers/forum_controller.dart';

class ForumWidget extends StatelessWidget {
  ForumWidget({
    super.key,
    required this.forum,
    required this.controller,
    this.sortForum,
  });
  final ForumModel forum;
  final ForumModel? sortForum;
  final ForumController controller;
  final userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(3, 4), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(forum.image),
                    onBackgroundImageError: (object, stackTrace) {
                      const Icon(Icons.man);
                    },
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        //name
                        forum.name.capitalize!,
                        style: AppTextStyle.mediumBlack14,
                      ),
                      Text(
                        //communityName
                        forum.communityName,
                        style: AppTextStyle.regularBlack12
                            .copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                '${forum.title}:'.capitalize!,
                style: AppTextStyle.boldBlack16,
              ),
              const SizedBox(height: 8),
              Text(
                forum.dscription,
                style: AppTextStyle.regularBlack14,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.handelLikes(forum);
                      if (sortForum!.likes.contains(userUid)) {
                        sortForum!.likes.remove(userUid);
                      } else if (sortForum!.dislikes.contains(userUid)) {
                        sortForum!.dislikes.remove(userUid);
                        sortForum!.likes.add(userUid);
                      } else {
                        sortForum!.likes.add(userUid);
                      }
                    },
                    child: Icon(Iconsax.arrow_square_up,
                        size: 32,
                        color: forum.likes.contains(userUid)
                            ? AppColors.secondary
                            : AppColors.grey),
                  ),
                  Text(
                    forum.likes.length.toString(),
                    style: AppTextStyle.mediumBlack12
                        .copyWith(color: AppColors.grey),
                  ),
                ],
              ),
              const SizedBox(
                width: 14,
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.handelDisLikes(forum);
                      if (sortForum!.dislikes.contains(userUid)) {
                        sortForum!.dislikes.remove(userUid);
                      } else if (sortForum!.likes.contains(userUid)) {
                        sortForum!.likes.remove(userUid);
                        sortForum!.dislikes.add(userUid);
                      } else {
                        sortForum!.dislikes.add(userUid);
                      }
                    },
                    child: Icon(Iconsax.arrow_square_down4,
                        size: 32,
                        color: forum.dislikes.contains(userUid)
                            ? AppColors.secondary
                            : AppColors.grey),
                  ),
                  Text(
                    forum.dislikes.length.toString(),
                    style: AppTextStyle.mediumBlack12
                        .copyWith(color: AppColors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
