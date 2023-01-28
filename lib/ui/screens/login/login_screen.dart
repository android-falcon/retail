import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/controllers/login_controller.dart';
import 'package:retail_system/ui/screens/login/login_widgets.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class LoginScreen extends GetResponsiveView<LoginController> {
  LoginScreen({super.key});

  final _controller = LoginController.to;

  _buildWidget() {
    return GetBuilder<LoginController>(
      builder: (controller) {
        return CustomWidget(
          child: CustomSingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
            child: Form(
              key: _controller.formKey,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    kAssetBackgroundLogin,
                    width: Get.width,
                    height: Get.height,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    child: Column(
                      children: [
                        Text(
                          'Welcome to Falcons Pos'.tr,
                          style: kStyleTextLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 22.h),
                        TextFieldWidget(
                          controller: controller.controllerUsername,
                          label: Text('Username'.tr),
                        ),
                        TextFieldWidget(
                          controller: controller.controllerPassword,
                          label: Text('Password'.tr),
                          isPass: true,
                          obscureText: true,
                        ),
                        SizedBox(height: 30.h),
                        CustomButton(
                          child: Text('Sign In'.tr),
                          onPressed: () {
                            _controller.signIn();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
