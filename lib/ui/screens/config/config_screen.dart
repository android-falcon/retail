import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/controllers/config_controller.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class ConfigScreen extends GetResponsiveView {
  ConfigScreen({super.key});

  final _controller = ConfigController.to;

  _buildWidget() {
    return CustomWidget(
      alignment: Alignment.topCenter,
      child: CustomSingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: _controller.controllerBaseUrl,
              label: Text('Base URL'.tr),
            ),
            CustomTextField(
              controller: _controller.controllerPosNo,
              label: Text('POS No'.tr),
            ),
            CustomTextField(
              controller: _controller.controllerCashNo,
              label: Text('Cash No'.tr),
            ),
            CustomTextField(
              controller: _controller.controllerStoreNo,
              label: Text('Store No'.tr),
            ),
            CustomTextField(
              controller: _controller.controllerInVocNo,
              label: Text('In Voc No'.tr),
            ),
            CustomTextField(
              controller: _controller.controllerReturnVocNo,
              label: Text('Return Voc No'.tr),
            ),
            CustomTextField(
              controller: _controller.controllerOutVocNo,
              label: Text('Pay In Out No'.tr),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      onPressed: () {
                        _controller.save();
                      },
                      child: Text(
                        'Save'.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      backgroundColor: AppColor.red,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      onPressed: () {
                        _controller.cancel();
                      },
                      child: Text(
                        'Cancel'.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget desktop() {
    return _buildWidget();
  }

  @override
  Widget tablet() {
    return _buildWidget();
  }

  @override
  Widget phone() {
    return _buildWidget();
  }

  @override
  Widget watch() {
    return _buildWidget();
  }
}
