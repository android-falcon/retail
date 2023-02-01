import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:retail_system/config/constant.dart';

class CustomIconText extends StatelessWidget {
  final String icon;
  final String label;
  final TextStyle? style;
  final bool bold;

  const CustomIconText({
    Key? key,
    this.icon = "",
    this.label = "",
    this.style,
    this.bold = false,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            SvgPicture.asset(icon),
          ],
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            label,
            style: style ?? (bold ? kStyleTextTitle.copyWith(fontWeight: FontWeight.bold) : kStyleTextTitle),
          ),
        ),
      ],
    );
  }
}
