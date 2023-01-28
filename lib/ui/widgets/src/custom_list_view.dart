import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListView extends StatelessWidget {
  final EdgeInsets? padding;
  final List<Widget> children;

  const CustomListView({
    super.key,
    this.padding,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding ?? EdgeInsets.all(16.0.w),
      children: children,
    );
  }
}
