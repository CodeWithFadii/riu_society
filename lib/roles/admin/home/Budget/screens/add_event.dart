import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/Budget/controller/budget_controller.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/widgets/material_button.dart';
import 'package:riu_society/utils/widgets/simple_textfield.dart';

Widget addEvent(BudgetController budgetC) {
  final TextEditingController titleC = TextEditingController();
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Create Event',
            style: AppTextStyle.mediumBlack18,
          ),
          const SizedBox(
            height: 12,
          ),
          SimpleTextField(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            height: 44,
            borderRadius: 10,
            width: double.infinity,
            controller: titleC,
            hint: 'Create Event',
            hintstyle: AppTextStyle.regularBlack14.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(
            height: 12,
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
                height: 15,
                width: 15,
              ),
              const SizedBox(
                width: 10,
              ),
              MaterialButtonWidget(
                onPressed: () {
                  budgetC.addEvent(titleC);
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
