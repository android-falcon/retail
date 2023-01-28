import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/controllers/home_controller.dart';
import 'package:retail_system/ui/screens/home/home_widgets.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class HomeScreen extends GetResponsiveView {
  HomeScreen({super.key});

  final _controller = HomeController.to;

  _buildWidget() {
    return CustomWidget(
      appBar: CustomAppBar(
        title: Image.asset(
          kAssetLogo,
          width: 50,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(kAssetMore),
            ),
          ),
        ],
      ),
      alignment: Alignment.topCenter,
      child: CustomSingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  CustomIconText(
                    icon: kAssetArrow,
                    bold: true,
                    label: '${'Voucher No'.tr} : ${sharedPrefsClient.inVocNo}',
                  ),
                  SizedBox(height: 40.h),
                  CustomIconText(
                    icon: kAssetDate,
                    label: '${'Date'.tr} : ${DateFormat('dd/MM/yyyy').format(sharedPrefsClient.dailyClose)}',
                  ),
                  CustomIconText(
                    icon: kAssetTime,
                    label: '${'Time'.tr} : ${DateFormat('HH:mm a').format(sharedPrefsClient.dailyClose)}',
                  ),
                  SizedBox(height: 27.h),
                  Row(
                    children: [
                      CustomButton(
                        fixed: true,
                        child: Text('Add Item'.tr),
                        onPressed: () {
                          _controller.addItem();
                        },
                      ),
                      SizedBox(width: 9.w),
                      Expanded(
                        child: CustomTextField(
                          controller: _controller.controllerSearch,
                          borderColor: AppColor.primaryColor,
                          hintText: 'Search for item'.tr,
                          icon: SvgPicture.asset(
                            kAssetSearch,
                            color: AppColor.gray2,
                          ),
                          suffixIcon: CustomButton(
                            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                            fixed: true,
                            child: Text('Search'.tr),
                            onPressed: () {
                              _controller.addItem();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.h),
              padding: EdgeInsets.all(8.2),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.primaryColor),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Text(
                          'Item Name'.tr,
                          style: kStyleTextTable,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Sold Unit'.tr,
                          style: kStyleTextTable,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Qty'.tr,
                          style: kStyleTextTable,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Price'.tr,
                          style: kStyleTextTable,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Disc'.tr,
                          style: kStyleTextTable,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          'Net Price'.tr,
                          style: kStyleTextTable,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(),
                      ),
                    ],
                  ),
                ],
              ),
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
