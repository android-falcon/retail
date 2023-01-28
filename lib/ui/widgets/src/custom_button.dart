import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomButton extends StatelessWidget {
  Widget? child;
  Color? backgroundColor;
  EdgeInsetsGeometry? padding;
  void Function()? onPressed;
  void Function()? onLongPress;
  EdgeInsetsGeometry? margin;
  double? width;
  bool? fixed;
  BorderSide? side;
  double? borderRadius;

  CustomButton({
    super.key,
    this.child,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.width,
    this.fixed = false,
    this.onPressed,
    this.side,
    this.onLongPress,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: 8.h),
      width: fixed! ? width : double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // textStyle: kStyleTextDefault,
          onPrimary: Colors.white,
          primary: backgroundColor,
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
            side: side ?? BorderSide.none,
          ),
          elevation: 0.0,
          shadowColor: Colors.transparent,
          textStyle: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}
