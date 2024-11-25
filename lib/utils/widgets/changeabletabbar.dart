import 'package:flutter/material.dart';
import '../app_textstyle.dart';
import '../app_colors.dart';

class ChangeAbleTabar extends StatelessWidget {
  const ChangeAbleTabar(
      {super.key,
      required this.firstText,
      required this.secondText,
      required this.firstOnTap,
      required this.secondOnTap,
      required this.value});

  final String firstText;
  final String secondText;
  final VoidCallback firstOnTap;
  final VoidCallback secondOnTap;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: firstOnTap,
              child: Container(
                alignment: Alignment.center,
                height: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: value ? AppColors.black : AppColors.white),
                padding: const EdgeInsets.symmetric(
                  horizontal: 37,
                ),
                child: Text(
                  firstText,
                  style: value ? AppTextStyle.regularWhite14 : AppTextStyle.regularBlack14,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: secondOnTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 37,
                ),
                alignment: Alignment.center,
                height: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: value ? AppColors.white : AppColors.black),
                child: Text(
                  secondText,
                  style: value ? AppTextStyle.regularBlack14 : AppTextStyle.regularWhite14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
