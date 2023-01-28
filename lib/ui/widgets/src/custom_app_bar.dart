import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;

  const CustomAppBar({super.key, this.backgroundColor, this.title, this.leading, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      actions: actions,
      leading: leading,
      title: title,
      centerTitle: true,
      // automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
