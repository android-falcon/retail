import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSelectColor extends StatefulWidget {
  final Color value;
  final Color? gropeValue;
  final void Function()? onTap;

  const CustomSelectColor({Key? key, required this.value, this.gropeValue, this.onTap}) : super(key: key);

  @override
  State<CustomSelectColor> createState() => _CustomSelectColorState();
}

class _CustomSelectColorState extends State<CustomSelectColor> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 60,
        height: 60,
        margin: EdgeInsets.all(8.sp),
        padding: EdgeInsets.all(4.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          color: widget.value,
        ),
        child: widget.value != widget.gropeValue ? null : const Icon(Icons.check),
      ),
    );
  }
}
