import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/widgets/simple_textfield.dart';
import '../../../../utils/widgets/material_button.dart';

Widget createCummunityWidget(context) {
  var controller = TextEditingController();

  final sizew = MediaQuery.of(context).size.width * 1;
  final sizeh = MediaQuery.of(context).size.height * 1;
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: sizew * 0.050, vertical: sizeh * 0.026),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Create New Community',
            style: AppTextStyle.mediumBlack18,
          ),
          SizedBox(
            height: sizeh * 0.018,
          ),
          SimpleTextField(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            height: 44,
            borderRadius: 10,
            width: double.infinity,
            controller: controller,
            hint: 'Community Name',
            hintstyle: AppTextStyle.regularBlack14.copyWith(
              color: AppColors.grey,
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
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                    firestore.collection('societies').add(
                      {
                        'name': controller.text,
                        'members_count': 0,
                      },
                    );
                    Get.back();
                  }
                },
                text: Text(
                  'Create',
                  style: AppTextStyle.regularWhite14,
                ),
                color: AppColors.black,
              )
            ],
          )
        ],
      ),
    ),
  );
}
