import 'package:flutter/material.dart';
import 'package:riu_society/utils/app_textstyle.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    this.containerColor,
    this.iconColor,
    this.trailing = false,
    this.trailingText = '',
  });
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  final Color? containerColor;
  final Color? iconColor;
  final bool? trailing;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25), color: containerColor),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 15),
              Text(
                title,
                style: AppTextStyle.mediumBlack16.copyWith(color: iconColor),
              ),
              const Spacer(),
              trailing!
                  ? Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        trailingText!,
                        style: AppTextStyle.regularWhite14,
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
