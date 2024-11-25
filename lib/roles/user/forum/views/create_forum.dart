import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/user/forum/controllers/forum_controller.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/widgets/material_button.dart';
import 'package:riu_society/utils/widgets/simple_textfield.dart';

class CreateForum extends StatelessWidget {
  CreateForum({super.key, this.admin = false});
  final bool admin;
  final ForumController forumC = Get.find<ForumController>();

  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width * 1;
    final sizeh = MediaQuery.of(context).size.height * 1;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create New Post',
              style: AppTextStyle.mediumBlack18,
            ),
            SizedBox(
              height: sizeh * 0.018,
            ),
            SimpleTextField(
              controller: forumC.titleC,
              width: sizew,
              hint: 'Title',
              hintstyle:
                  AppTextStyle.regularBlack16.copyWith(color: AppColors.grey),
              borderRadius: 10,
            ),
            const SizedBox(height: 10),
            Container(
              constraints: const BoxConstraints(minHeight: 100, maxHeight: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.lightGrey,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: forumC.descriptionC,
                autofocus: false,
                maxLines: null,
                style: const TextStyle(fontSize: 16, color: AppColors.primary),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Description',
                  hintStyle: AppTextStyle.regularBlack16
                      .copyWith(color: AppColors.grey),
                ),
              ),
            ),
            SizedBox(
              height: sizeh * 0.040,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButtonWidget(
                  onPressed: () {
                    Get.back();
                  },
                  text: Text(
                    'Cancel',
                    style: AppTextStyle.regularBlack14,
                  ),
                  color: AppColors.white,
                  height: sizeh * 0.045,
                  width: sizew * 0.25,
                ),
                SizedBox(
                  width: sizew * 0.020,
                ),
                MaterialButtonWidget(
                  onPressed: () async {
                    admin
                        ? await forumC.createAdminForum(
                            forumC.descriptionC.text, forumC.titleC.text)
                        : await forumC.createForum(
                            forumC.descriptionC.text, forumC.titleC.text);
                    Get.back();
                  },
                  text: Text(
                    'Create',
                    style: AppTextStyle.regularWhite14,
                  ),
                  color: AppColors.black,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
