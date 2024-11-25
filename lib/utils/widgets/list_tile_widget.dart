import 'package:flutter/material.dart';
import '../app_textstyle.dart';
import '../app_colors.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    Key? key,
    this.name,
    this.department,
    this.image,
    this.trailing,
  }) : super(key: key);

  final String? name;
  final String? department;
  final String? image;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width * 1;
    return Container(
      height: 81,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: AppColors.lightGrey, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            spacing: sizew * 0.050,
            children: [
              CircleAvatar(
                  radius: 30, backgroundImage: NetworkImage(image ?? '')),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    SizedBox(
                      width: sizew * 0.43,
                      child: Text(
                        name ?? '',
                        style: AppTextStyle.boldBlack14
                            .copyWith(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Text(
                      department ?? '',
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing ?? const SizedBox(),
        ],
      ),
    );
  }
}
