import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSingleChildScrollView extends StatelessWidget {
  final EdgeInsets? padding;
  final Widget? child;

  const CustomSingleChildScrollView({
    super.key,
    this.padding,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding ?? EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        child: child,
      ),
    );
  }
}
