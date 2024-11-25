import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/common/notification/send_method.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/functions.dart';
import 'package:riu_society/utils/widgets/material_button.dart';
import 'package:riu_society/utils/widgets/simple_textfield.dart';

class CreateNotification extends StatelessWidget {
  CreateNotification({super.key});
  final TextEditingController titleC = TextEditingController();
  final TextEditingController descriptionC = TextEditingController();
  final userUid = FirebaseAuth.instance.currentUser!.uid;
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
              'Send New Notification',
              style: AppTextStyle.mediumBlack18,
            ),
            SizedBox(
              height: sizeh * 0.018,
            ),
            SimpleTextField(
              controller: titleC,
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
                controller: descriptionC,
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
                    sendNotiification(titleC.text, descriptionC.text);
                  },
                  text: Text(
                    'Send',
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

  sendNotiification(String title, String description) {
    if (title.isEmpty || description.isEmpty) {
      return snackbar(
          'All fields required', 'Enter data in all fields to continue');
    }

    try {
      EasyLoading.show();
      FirebaseFirestore.instance
          .collection('notifications')
          .add({
        'time_stamp': DateTime.now(),
        'title': titleC.text,
        'description': descriptionC.text,
      }).then((value) {
        SendMethod.eventNotification(title, description);
        titleC.clear();
        descriptionC.clear();
        Get.back();
        EasyLoading.dismiss();
      });
    } on Exception {
      EasyLoading.dismiss();
      snackbar('Error',
          'Error while sending notification please try again or check your internet connection');
    }
  }
}
