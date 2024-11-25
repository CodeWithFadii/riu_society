import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';

snackbar(String title, String description, {IconData? icon}) {
  return Get.snackbar(
    title,
    description,
    icon: Icon(icon ?? Icons.warning_rounded, color: Colors.black54),
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 4),
    backgroundColor: AppColors.secondary,
  );
}

rawSackbar(String title) {
  Get.rawSnackbar(
    backgroundColor: AppColors.secondary,
    duration: const Duration(seconds: 4),
    messageText: Center(
      child: Text(
        title,
        style: AppTextStyle.regularBlack16,
      ),
    ),
  );
}

Future<dynamic> confirmDefaultDialog(String title, String description,
    {required VoidCallback confirm}) {
  return Get.defaultDialog(
    title: title,
    content: Text(
      description,
      style: AppTextStyle.mediumBlack16,
      textAlign: TextAlign.center,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text('Cancel', style: AppTextStyle.boldBlack16),
      ),
      TextButton(
        onPressed: confirm,
        child: Text(
          'Confirm',
          style: AppTextStyle.boldBlack16.copyWith(
            color: Colors.red,
          ),
        ),
      ),
    ],
  );
}

formatDate(String? date) {
  DateFormat format = DateFormat.yMMMd();
  DateTime dateTime = DateTime.parse(date!);
  String formattedDate = format.format(dateTime);
  return formattedDate;
}
