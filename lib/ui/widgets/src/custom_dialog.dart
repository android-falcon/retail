import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef CustomDialogBuilder = Widget Function(BuildContext context, StateSetter setState, BoxConstraints constraints);

class CustomDialog extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final bool enableScroll;
  final CustomDialogBuilder builder;
  final GestureTapCallback? gestureDetectorOnTap;

  const CustomDialog({Key? key, this.width, this.height, required this.builder, this.borderRadius, this.gestureDetectorOnTap, this.enableScroll = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: StatefulBuilder(
        builder: (context, setState) => GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            gestureDetectorOnTap;
            setState(() {});
          },
          child: Container(
            width: width ?? 0.95.sw,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius ?? BorderRadius.zero,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => enableScroll
                  ? SingleChildScrollView(
                      child: builder(context, setState, constraints),
                    )
                  : builder(context, setState, constraints),
            ),
          ),
        ),
      ),
    );
  }
}
