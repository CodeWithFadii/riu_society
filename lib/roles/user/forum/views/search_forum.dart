import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/user/forum/model/forum_model.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/widgets/forum_widget.dart';
import 'package:riu_society/utils/widgets/simple_textfield.dart';
import '../controllers/forum_controller.dart';

class SearchForum extends StatelessWidget {
  const SearchForum({super.key, required this.forumC});

  final ForumController forumC;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Search Post',
          style: AppTextStyle.mediumBlack18.copyWith(color: AppColors.white),
        ),
      ),
      body: Obx(
        () {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 16, left: 14, right: 14),
                child: SimpleTextField(
                  autoFocus: true,
                  width: double.infinity,
                  controller: forumC.searchC.value,
                  hint: 'Find Post By Community Name...',
                  trailing: Iconsax.search_normal,
                ),
              ),
              Expanded(
                child: StreamBuilder<List<ForumModel>>(
                  stream: forumC.searchedPosts(),
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
                    if (snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                        'No Posts Available',
                        style: AppTextStyle.mediumBlack16,
                      ));
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 20, left: 16, right: 16),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ForumWidget(
                          controller: forumC,
                          forum: snapshot.data![index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
