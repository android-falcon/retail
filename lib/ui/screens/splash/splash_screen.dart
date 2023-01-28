import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/ui/screens/login/login_screen.dart';
import 'package:retail_system/ui/screens/splash/splash_widgets.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class SplashScreen extends GetResponsiveView {
  SplashScreen({super.key});

  _buildWidget() {
    return CustomWidget(
      child: CustomSingleChildScrollView(
        child: Column(
          children: [
            Text(
              'WELCOME TO\nFalcons Point Of Sale'.tr,
              style: kStyleTextLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 22.h),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'.tr,
              style: kStyleTextDefault,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 47.h),
            Image.asset(
              kAssetSplash,
              width: 378.w,
              height: 232.h,
            ),
            SizedBox(height: 75.h),
            CustomButton(
              margin: EdgeInsets.symmetric(horizontal: 180.w),
              child: Text('Get Started'.tr),
              onPressed: () {
                Get.to(() => LoginScreen());
              },
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
