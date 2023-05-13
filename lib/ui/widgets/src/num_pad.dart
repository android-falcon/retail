import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class NumPad extends StatelessWidget {
  final TextEditingController? controller;
  void Function()? onPressed1;
  void Function()? onPressed2;
  void Function()? onPressed3;
  void Function()? onPressed4;
  void Function()? onPressed5;
  void Function()? onPressed6;
  void Function()? onPressed7;
  void Function()? onPressed8;
  void Function()? onPressed9;
  void Function()? onPressedDot;
  void Function()? onPressed0;
  void Function()? onPressedDelete;
  void Function()? onClear;
  void Function()? onSubmit;
  void Function()? onExit;
  final EdgeInsetsGeometry marginButton;
  final EdgeInsetsGeometry paddingButton;

  NumPad({
    Key? key,
    this.controller,
    this.onPressed1,
    this.onPressed2,
    this.onPressed3,
    this.onPressed4,
    this.onPressed5,
    this.onPressed6,
    this.onPressed7,
    this.onPressed8,
    this.onPressed9,
    this.onPressedDot,
    this.onPressed0,
    this.onPressedDelete,
    this.onClear,
    this.onSubmit,
    this.onExit,
    this.marginButton = EdgeInsets.zero,
    this.paddingButton = const EdgeInsets.symmetric( vertical: 24),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primaryColor,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  margin: marginButton,
                  padding: paddingButton,
                  borderRadius: 0,
                  onPressed: onPressed1,
                  child: const Text('1'),
                ),
              ),
              Expanded(
                child: CustomButton(
                  margin: marginButton,
                  padding: paddingButton,
                  borderRadius: 0,
                  onPressed: onPressed2,
                  child: const Text('2'),
                ),
              ),
              Expanded(
                child: CustomButton(
                  margin: marginButton,
                  padding: paddingButton,
                  borderRadius: 0,
                  onPressed: onPressed3,
                  child: const Text('3'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  margin: marginButton,
                  padding: paddingButton,
                  borderRadius: 0,
                  onPressed: onPressed4,
                  child: const Text('4'),
                ),
              ),
              Expanded(
                child: CustomButton(
                  margin: marginButton,
                  padding: paddingButton,
                  borderRadius: 0,
                  onPressed: onPressed5,
                  child: const Text('5'),
                ),
              ),
              Expanded(
                child: CustomButton(
                  margin: marginButton,
                  padding: paddingButton,
                  borderRadius: 0,
                  onPressed: onPressed6,
                  child: const Text('6'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  margin: marginButton,
                  padding: paddingButton,
                  borderRadius: 0,
                  onPressed: onPressed7,
                  child: const Text('7'),
                ),
              ),
              Expanded(
                child: CustomButton(
                  margin: marginButton,
                  padding: paddingButton,
                  borderRadius: 0,
                  onPressed: onPressed8,
                  child: const Text('8'),
                ),
              ),
              Expanded(
                child: CustomButton(
                  margin: marginButton,
                  padding: paddingButton,
                  borderRadius: 0,
                  onPressed: onPressed9,
                  child: const Text('9'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  margin: marginButton,
                  padding: paddingButton,
                  borderRadius: 0,
                  onPressed: onPressed0,
                  child: const Text('0'),
                ),
              ),
              Expanded(
                child: CustomButton(
                  margin: marginButton,
                  padding: paddingButton,
                  borderRadius: 0,
                  onPressed: onPressedDot,
                  child: const Text('.'),
                ),
              ),
              Expanded(
                child: CustomButton(
                  margin: marginButton,
                  padding: paddingButton,
                  borderRadius: 0,
                  onPressed: onPressedDelete,
                  child: const Icon(
                    Icons.backspace_outlined,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (onExit != null)
                Expanded(
                  child: CustomButton(
                    margin: marginButton,
                    padding: paddingButton,
                    borderRadius: 0,
                    backgroundColor: AppColor.red,
                    onPressed: onExit,
                    child: Text(
                      'Exit'.tr,
                      style: Constant.kStyleTextButton,
                    ),
                  ),
                ),
              if (onClear != null)
                Expanded(
                  child: CustomButton(
                    margin: marginButton,
                    padding: paddingButton,
                    borderRadius: 0,
                    backgroundColor: AppColor.blue,
                    onPressed: onClear,
                    child: Text(
                      'Clear'.tr,
                      style: Constant.kStyleTextButton,
                    ),
                  ),
                ),
              if (onSubmit != null)
                Expanded(
                  child: CustomButton(
                    margin: marginButton,
                    padding: paddingButton,
                    borderRadius: 0,
                    backgroundColor: AppColor.green,
                    onPressed: onSubmit,
                    child: Text(
                      'Save'.tr,
                      style: Constant.kStyleTextButton,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
