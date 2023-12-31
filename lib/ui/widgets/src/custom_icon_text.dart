import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:retail_system/config/constant.dart';

class CustomIconText extends StatelessWidget {
  final String icon;
  final String label;
  final TextStyle? style;
  final bool bold;
  final bool expanded;

  const CustomIconText({
    Key? key,
    this.icon = "",
    this.label = "",
    this.style,
    this.bold = false,
    this.expanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon.isNotEmpty)
          Column(
            children: [
              const SizedBox(height: 10),
              SvgPicture.asset(icon),
            ],
          ),
        SizedBox(width: 5.w),
        expanded
            ? Expanded(
                child: Text(
                  label,
                  style: style ?? (bold ? Constant.kStyleTextTitle.copyWith(fontWeight: FontWeight.bold) : Constant.kStyleTextTitle),
                ),
              )
            : Flexible(
                child: Text(
                  label,
                  style: style ?? (bold ? Constant.kStyleTextTitle.copyWith(fontWeight: FontWeight.bold) : Constant.kStyleTextTitle),
                ),
              ),
      ],
    );
  }
}
