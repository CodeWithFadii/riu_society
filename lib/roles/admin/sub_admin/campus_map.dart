import 'package:flutter/material.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';

class CampusMap extends StatelessWidget {
  const CampusMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Campus Map',
          style: AppTextStyle.mediumBlack18.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.asset(
            'assets/images/campus_map.jpg',
          ),
        ),
      ),
    );
  }
}
