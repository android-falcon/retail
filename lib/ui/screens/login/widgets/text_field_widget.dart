import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/constant.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final TextAlign textAlign;
  final String? hintText;
  final String? helperText;
  final Widget? icon;
  final bool enabled;
  final Widget? label;
  final bool enableInteractiveSelection;
  bool obscureText;
  final bool isPass;
  final TextDirection? textDirection;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onChanged;
  final String? Function(String? value)? onSaved;
  final String? Function(String? value)? onFieldSubmitted;
  final void Function()? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final Color? textColor;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final double? borderRaduis;
  final double? borderWidth;
  final String? initialValue;
  final Widget? suffixIcon;

  TextFieldWidget({
    super.key,
    this.controller,
    this.suffixIcon,
    this.focusNode,
    this.borderRaduis,
    this.borderWidth,
    this.textColor,
    this.fillColor,
    this.keyboardType,
    this.maxLines,
    this.label,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.icon,
    this.hintText,
    this.helperText,
    this.contentPadding,
    this.enabled = true,
    this.enableInteractiveSelection = true,
    this.obscureText = false,
    this.isPass = false,
    this.textDirection,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.onTap,
    this.margin,
    this.padding,
    this.inputFormatters,
    this.initialValue,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _visiblePassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(vertical: 8.h),
      padding: widget.padding,
      child: TextFormField(
        initialValue: widget.initialValue,
        // style: Theme.of(context).textTheme.bodyText2!.copyWith(color: widget.textColor),
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        maxLength: widget.maxLength,
        textAlign: widget.textAlign,

        style: kStyleTextTitle,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintText,
          label: widget.label,
          helperText: widget.helperText,
          contentPadding: widget.contentPadding ?? (widget.icon != null ? EdgeInsets.zero : EdgeInsetsDirectional.only(start: 8.w, end: 20.w)),
          hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: widget.textColor),
          prefixIcon: widget.icon != null
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0.h),
                  child: widget.icon,
                )
              : null,
          suffixIcon: widget.suffixIcon ??
              (widget.isPass
                  ? InkWell(
                      borderRadius: BorderRadius.circular(30.r),
                      child: Icon(
                        _visiblePassword ? Icons.visibility : Icons.visibility_off,
                        size: 14,
                      ),
                      onTap: () {
                        setState(() {
                          _visiblePassword = !_visiblePassword;
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                    )
                  : null),
          counterStyle: const TextStyle(fontSize: 0, color: Colors.transparent),
          errorMaxLines: 3,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.white, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.white, width: 0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.white, width: 0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide:  const BorderSide(color: Colors.white, width: 0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.white, width: 0),
          ),
        ),
        enabled: widget.enabled,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        focusNode: widget.focusNode ?? (widget.enableInteractiveSelection ? null : AlwaysDisabledFocusNode()),
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText,
        textDirection: widget.textDirection,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onSaved: widget.onSaved,
        onFieldSubmitted: widget.onFieldSubmitted,
        onTap: widget.onTap,
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
