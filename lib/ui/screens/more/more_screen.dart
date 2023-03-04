import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class MoreScreen extends GetResponsiveView {
  MoreScreen({super.key});

  final List<Map<String, dynamic>> _options = [
    {
      'label': 'Close cash'.tr,
      'icon': kAssetCloseCash,
      'onTap': () {},
    },
    {
      'label': 'Reprint an invoice'.tr,
      'icon': kAssetReprintInvoice,
      'onTap': () {},
    },
    {
      'label': 'Logout'.tr,
      'icon': kAssetLogout,
      'onTap': () {},
    },
  ];

  _buildWidget() {
    return CustomWidget(
      alignment: Alignment.topCenter,
      appBar: CustomAppBar(
        title: Text(
          '${'Action Number'.tr} : ',
          style: kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor.accentColor,
      ),
      child: CustomSingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 40.h),
              color: AppColor.accentColor,
              child: CustomIconText(
                icon: kAssetSettings,
                bold: true,
                label: '${'Transactions on the invoice'.tr} :',
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _options.length,
              itemBuilder: (context, index) => Material(
                color: index % 2 == 0 ? null : AppColor.accentColor,
                child: InkWell(
                  onTap: _options[index]['onTap'],
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: CustomIconText(
                      icon: _options[index]['icon'],
                      label: _options[index]['label'],
                    ),
                  ),
                ),
              ),
            )
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
