import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/controllers/home_controller.dart';
import 'package:retail_system/ui/screens/home/home_widgets.dart';
import 'package:retail_system/ui/screens/more/more_screen.dart';
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
              onPressed: () {
                Get.to(() => MoreScreen());
              },
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
                    label: '${'Date'.tr} : ${DateFormat(dateFormat).format(sharedPrefsClient.dailyClose)}',
                  ),
                  CustomIconText(
                    icon: kAssetTime,
                    label: '${'Time'.tr} : ${DateFormat(timeFormat).format(sharedPrefsClient.dailyClose)}',
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
              height: 250.h,
              margin: EdgeInsets.symmetric(vertical: 16.h),
              padding: EdgeInsets.all(8.w),
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
                  SizedBox(height: 10.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) => Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              'Item Name'.tr,
                              style: kStyleDataTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              'Sold Unit'.tr,
                              style: kStyleDataTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Qty'.tr,
                              style: kStyleDataTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Price'.tr,
                              style: kStyleDataTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              '20%',
                              style: kStyleDataTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Net Price'.tr,
                              style: kStyleDataTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: IconButton(
                                    onPressed: () {
                                      _controller.deleteItem();
                                    },
                                    padding: EdgeInsets.zero,
                                    icon: SvgPicture.asset(kAssetDelete),
                                    splashRadius: 20.r,
                                  ),
                                ),
                                Flexible(
                                  child: IconButton(
                                    onPressed: () {
                                      _controller.editItem();
                                    },
                                    padding: EdgeInsets.zero,
                                    icon: SvgPicture.asset(kAssetEdit),
                                    splashRadius: 20.r,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButtonOutline(
                      onPressed: () {},
                      label: Text('Hold Items'.tr),
                      icon: SvgPicture.asset(kAssetHoldItems),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomButtonOutline(
                      onPressed: () {},
                      label: Text('Void All'.tr),
                      icon: SvgPicture.asset(kAssetVoidAll),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomButtonOutline(
                      onPressed: () {},
                      label: Text('Speed Items'.tr),
                      icon: SvgPicture.asset(kAssetSpeedItems),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.h),
                  padding: EdgeInsets.only(top: 8.w, left: 14.w, right: 14.w, bottom: 16.w),
                  decoration: BoxDecoration(
                    color: AppColor.accentColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${'Current bill'.tr} : ',
                        style:  kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomIconText(
                              icon: kAssetArrow,
                              label: '${'No of Items'.tr} : ',
                            ),
                          ),
                          Expanded(
                            child: CustomIconText(
                              icon: kAssetArrow,
                              label: '${'Line Disc'.tr} : ',
                            ),
                          ),
                          Expanded(
                            child: CustomIconText(
                              icon: kAssetArrow,
                              bold: true,
                              label: '${'Total'.tr} : ',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomIconText(
                              icon: kAssetArrow,
                              label: '${'Disc'.tr} : ',
                            ),
                          ),
                          Expanded(
                            child: CustomIconText(
                              icon: kAssetArrow,
                              label: '${'Tax'.tr} : ',
                            ),
                          ),
                          Expanded(
                            child: CustomIconText(
                              icon: kAssetArrow,
                              bold: true,
                              label: '${'Net Total'.tr} : ',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset(kAssetArrowBottom),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.h),
              padding: EdgeInsets.only(top: 8.w, left: 14.w, right: 14.w, bottom: 16.w),
              decoration: BoxDecoration(
                color: AppColor.accentColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  Text(
                    '${'Payment Methods'.tr} : ',
                    style:  kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButtonIcon(
                          margin: EdgeInsets.symmetric(horizontal: 40.w),
                          backgroundColor: Colors.white,
                          icon: SvgPicture.asset(kAssetCreditCard),
                          label: Text('Other Payment Methods'.tr, textAlign: TextAlign.center,),
                          onPressed: () {

                          },
                        ),
                      ),
                      Expanded(
                        child: CustomButtonIcon(
                          margin: EdgeInsets.symmetric(horizontal: 40.w),
                          backgroundColor: Colors.white,
                          icon: SvgPicture.asset(kAssetCash),
                          label: Text('Cash'.tr),
                          onPressed: () {

                          },
                        ),
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