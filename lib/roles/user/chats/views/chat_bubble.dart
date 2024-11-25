import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/bubble_const.dart';

Widget chatBubbleWidget(DocumentSnapshot docs) {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  DateTime dateTime = docs['createdAT'] == null
      ? DateTime.parse(DateTime.now().toString())
      : DateTime.parse(docs['createdAT'].toDate().toString());
  return Directionality(
    textDirection:
        docs['uid'] == userID ? TextDirection.rtl : TextDirection.ltr,
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Flexible(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: docs['uid'] == userID
                          ? AppColors.secondary.withOpacity(0.5)
                          : AppColors.grey.withOpacity(0.5),
                      borderRadius:
                          docs['uid'] == userID ? kfriendBuble : kuserBuble),
                  child: Text(
                    docs['msg'],
                    style: AppTextStyle.regularBlack14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Directionality(
              textDirection:
                  docs['uid'] == userID ? TextDirection.ltr : TextDirection.ltr,
              child: Text(
                intl.DateFormat('EE h:mm a').format(dateTime),
                style:
                    AppTextStyle.regularBlack10.copyWith(color: AppColors.grey),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
