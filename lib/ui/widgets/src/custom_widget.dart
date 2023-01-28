import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Widget? child;
  final Widget? drawer;
  final AlignmentGeometry alignment;
  final PreferredSizeWidget? appBar;

  const CustomWidget({super.key, this.backgroundColor, this.child, this.drawer, this.appBar, this.alignment = Alignment.center});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      drawer: drawer,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Align(
            alignment: alignment,
            child: child,
          ),
        ),
      ),
    );
  }
}
