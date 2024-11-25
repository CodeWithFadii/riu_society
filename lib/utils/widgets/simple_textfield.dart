import 'package:flutter/material.dart';
import 'package:riu_society/utils/app_colors.dart';

class SimpleTextField extends StatelessWidget {
  const SimpleTextField({
    Key? key,
    required this.width,
    this.hint,
    required this.controller,
    this.inputType,
    this.inputAction,
    this.leading,
    this.trailing,
    this.obsecure,
    this.onTrailingTap,
    this.height,
    this.hintstyle,
    this.maxlines = 1,
    this.borderRadius = 100,
    this.padding,
    this.readOnly,
    this.maxLength,
    this.onChanged,
    this.autoFocus = false,
  }) : super(key: key);

  final double width;
  final double? height;
  final String? hint;
  final TextEditingController controller;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final IconData? leading;
  final IconData? trailing;
  final Function()? onTrailingTap;
  final Function(String)? onChanged;
  final bool? obsecure;
  final TextStyle? hintstyle;
  final int maxlines;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool? readOnly;
  final int? maxLength;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      width: width,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          leading != null
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    leading,
                    color: AppColors.grey,
                  ),
                )
              : Container(),
          Expanded(
            child: TextField(
              readOnly: readOnly ?? false,
              autofocus: autoFocus,
              maxLines: maxlines,
              keyboardType: inputType,
              obscureText: obsecure ?? false,
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 16, color: AppColors.primary),
              textInputAction: inputAction,
              maxLength: maxLength,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                counterText: '',
                hintStyle: hintstyle,
                contentPadding: const EdgeInsets.only(bottom: 0, top: -16),
              ),
            ),
          ),
          trailing != null
              ? GestureDetector(
                  onTap: onTrailingTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      trailing,
                      color: AppColors.grey,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
