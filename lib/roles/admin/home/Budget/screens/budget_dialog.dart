import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/Budget/controller/budget_controller.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/widgets/material_button.dart';
import 'package:riu_society/utils/widgets/simple_textfield.dart';

Widget entityDialog(BudgetController budgetC, String docID,
    {String? entityId, bool edit = false}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Entity Title',
            style: AppTextStyle.mediumBlack18,
          ),
          const SizedBox(
            height: 15,
          ),
          SimpleTextField(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            height: 44,
            borderRadius: 10,
            width: double.infinity,
            controller: budgetC.titleC,
            hint: 'Entity Title',
            hintstyle: AppTextStyle.regularBlack14.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SimpleTextField(
            inputType: TextInputType.phone,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            height: 44,
            borderRadius: 10,
            width: double.infinity,
            controller: budgetC.priceC,
            hint: 'Entity Price',
            hintstyle: AppTextStyle.regularBlack14.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
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
                width: 15,
              ),
              MaterialButtonWidget(
                onPressed: () {
                  edit
                      ? budgetC.editEntity(docID, entityId!)
                      : budgetC.addEntity(docID);
                },
                text: Text(
                  edit ? 'Update' : 'Add',
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
