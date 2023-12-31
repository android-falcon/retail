import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/config/enum/enum_payment_method_type.dart';
import 'package:retail_system/config/utils.dart';
import 'package:retail_system/controllers/home_controller.dart';
import 'package:retail_system/ui/screens/more/more_screen.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class HomeScreen extends GetResponsiveView {
  HomeScreen({super.key});

  final _controller = HomeController.to;

  _buildWidget() {
    return WillPopScope(
      onWillPop: () async => _controller.onWillPop(),
      child: CustomWidget(
        appBar: CustomAppBar(
          title: Image.asset(
            Constant.kAssetLogo,
            width: 50,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: IconButton(
                onPressed: () {
                  Get.to(() => MoreScreen())?.then(
                    (value) {
                      _controller.update();
                    },
                  );
                },
                icon: SvgPicture.asset(Constant.kAssetMore),
              ),
            ),
          ],
        ),
        alignment: Alignment.topCenter,
        child: GetBuilder<HomeController>(
          builder: (controller) => CustomSingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CustomIconText(
                              icon: Constant.kAssetArrow,
                              bold: true,
                              expanded: false,
                              label: '${'Voucher No'.tr} : ${Constant.sharedPrefsClient.inVocNo}',
                            ),
                          ),
                          Flexible(
                            child: CustomIconText(
                              icon: Constant.kAssetArrow,
                              bold: true,
                              expanded: false,
                              label: Constant.sharedPrefsClient.employee.empName,
                            ),
                          ),
                        ],
                      ),
                      CustomIconText(
                        icon: Constant.kAssetDate,
                        label: '${'Date'.tr} : ${DateFormat(Constant.dateFormat).format(Constant.sharedPrefsClient.dailyClose)}',
                      ),
                      CustomIconText(
                        icon: Constant.kAssetTime,
                        label: '${'Time'.tr} : ${DateFormat(Constant.timeFormat).format(DateTime.now())}',
                      ),
                      Row(
                        children: [
                          CustomButton(
                            fixed: true,
                            child: Text('Add Item'.tr),
                            onPressed: () {
                              _controller.addItem(barcode: _controller.controllerSearch.text);
                            },
                          ),
                          SizedBox(width: 9.w),
                          Expanded(
                            child: CustomTextField(
                              controller: _controller.controllerSearch,
                              focusNode: _controller.focusNodeSearch,
                              autofocus: true,
                              borderColor: AppColor.primaryColor,
                              hintText: 'Search for item'.tr,
                              maxLines: 1,
                              keyboardType: TextInputType.none,
                              icon: SvgPicture.asset(
                                Constant.kAssetSearch,
                                color: AppColor.gray2,
                              ),
                              suffixIcon: CustomButton(
                                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                                fixed: true,
                                child: Text('Search'.tr),
                                onPressed: () {
                                  _controller.searchItem();
                                },
                              ),
                              onFieldSubmitted: (value) {
                                FocusScope.of(Get.context!).requestFocus(FocusNode());
                                _controller.addItem(barcode: _controller.controllerSearch.text);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 250.h,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
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
                              style: Constant.kStyleTextTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Unit'.tr,
                              style: Constant.kStyleTextTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Qty'.tr,
                              style: Constant.kStyleTextTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Price'.tr,
                              style: Constant.kStyleTextTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Disc'.tr,
                              style: Constant.kStyleTextTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Net Price'.tr,
                              style: Constant.kStyleTextTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 4,
                            child: Container(),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _controller.cart.value.items.length,
                          itemBuilder: (context, index) => Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Text(
                                  _controller.cart.value.items[index].name,
                                  style: Constant.kStyleDataTable,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Unit',
                                  style: Constant.kStyleDataTable,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  _controller.cart.value.items[index].qty.toStringAsFixed(Constant.fractionDigits),
                                  style: Constant.kStyleDataTable,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  _controller.cart.value.items[index].priceChange.toStringAsFixed(Constant.fractionDigits),
                                  style: Constant.kStyleDataTable,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  _controller.cart.value.items[index].totalLineDiscount.toStringAsFixed(Constant.fractionDigits),
                                  style: Constant.kStyleDataTable,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  _controller.cart.value.items[index].total.toStringAsFixed(Constant.fractionDigits),
                                  style: Constant.kStyleDataTable,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: IconButton(
                                        onPressed: () {
                                          _controller.voidItem(index: index);
                                        },
                                        padding: EdgeInsets.zero,
                                        icon: SvgPicture.asset(Constant.kAssetDelete, height: 20.h),
                                        splashRadius: 25.r,
                                      ),
                                    ),
                                    Flexible(
                                      child: IconButton(
                                        onPressed: () {
                                          _controller.editItem(indexItem: index);
                                        },
                                        padding: EdgeInsets.zero,
                                        icon: SvgPicture.asset(Constant.kAssetEdit, height: 20.h),
                                        splashRadius: 25.r,
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
                          onPressed: () {
                            _controller.holdItems();
                          },
                          label: Text('Hold Items'.tr),
                          icon: SvgPicture.asset(Constant.kAssetHoldItems),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomButtonOutline(
                          onPressed: () {
                            _controller.voidAllItem();
                          },
                          label: Text('Void All'.tr),
                          icon: SvgPicture.asset(Constant.kAssetVoidAll),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomButtonOutline(
                          onPressed: () {
                            _controller.speedItems();
                          },
                          label: Text('Speed Items'.tr),
                          icon: SvgPicture.asset(Constant.kAssetSpeedItems),
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 4.h, bottom: 16.h),
                      padding: EdgeInsets.only(top: 8.h, left: 14.w, right: 14.w, bottom: 16.h),
                      decoration: BoxDecoration(
                        color: AppColor.accentColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${'Current bill'.tr} : ',
                            style: Constant.kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomIconText(
                                  icon: Constant.kAssetArrow,
                                  label: '${'No of Items'.tr} : ${_controller.cart.value.items.length}',
                                ),
                              ),
                              Expanded(
                                child: CustomIconText(
                                  icon: Constant.kAssetArrow,
                                  label: '${'Line Disc'.tr} : ${_controller.cart.value.totalLineDiscount.toStringAsFixed(Constant.fractionDigits)}',
                                ),
                              ),
                              Expanded(
                                child: CustomIconText(
                                  icon: Constant.kAssetArrow,
                                  bold: true,
                                  label: '${'Total'.tr} : ${_controller.cart.value.total.toStringAsFixed(Constant.fractionDigits)}',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    _controller.discountOrder();
                                  },
                                  child: CustomIconText(
                                    icon: Constant.kAssetArrow,
                                    label: '${'Disc'.tr} : ${_controller.cart.value.totalDiscount.toStringAsFixed(Constant.fractionDigits)}',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CustomIconText(
                                  icon: Constant.kAssetArrow,
                                  label: '${'Tax'.tr} : ${_controller.cart.value.tax.toStringAsFixed(Constant.fractionDigits)}',
                                ),
                              ),
                              Expanded(
                                child: CustomIconText(
                                  icon: Constant.kAssetArrow,
                                  bold: true,
                                  style: Constant.kStyleTextTitle.copyWith(fontWeight: FontWeight.bold, fontSize: 23.sp, color: AppColor.blue2),
                                  label: '${'Net Total'.tr} : ${_controller.cart.value.amountDue.toStringAsFixed(Constant.fractionDigits)}',
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
                        child: GestureDetector(
                          onTap: () {
                            _controller.showLastInvoice.value = !_controller.showLastInvoice.value;
                            _controller.update();
                          },
                          child: SvgPicture.asset(Constant.kAssetArrowBottom),
                        ),
                      ),
                    )
                  ],
                ),
                if (_controller.showLastInvoice.value)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    padding: EdgeInsets.only(top: 8.h, left: 14.w, right: 14.w, bottom: 8.h),
                    decoration: BoxDecoration(
                      color: AppColor.accentColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${'Last Invoice'.tr} : ',
                          style: Constant.kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: CustomIconText(
                                expanded: false,
                                icon: Constant.kAssetArrow,
                                label: '${'Invoice No'.tr} : ${Constant.sharedPrefsClient.lastInvoice.invoiceNo}',
                              ),
                            ),
                            Flexible(
                              child: CustomIconText(
                                expanded: false,
                                icon: Constant.kAssetArrow,
                                label: '${'Total'.tr} : ${Constant.sharedPrefsClient.lastInvoice.total.toStringAsFixed(Constant.fractionDigits)}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  padding: EdgeInsets.only(top: 8.h, left: 14.w, right: 14.w, bottom: 8.h),
                  decoration: BoxDecoration(
                    color: AppColor.accentColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${'Payment Methods'.tr} : ',
                        style: Constant.kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButtonIcon(
                              margin: EdgeInsets.symmetric(horizontal: 40.w),
                              backgroundColor: Colors.white,
                              icon: SvgPicture.asset(Constant.kAssetCreditCard),
                              label: Text(
                                'Other Payment Methods'.tr,
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                _controller.paymentMethodDialog(type: EnumPaymentMethodType.otherPayment);
                              },
                            ),
                          ),
                          Expanded(
                            child: CustomButtonIcon(
                              margin: EdgeInsets.symmetric(horizontal: 40.w),
                              backgroundColor: Colors.white,
                              icon: SvgPicture.asset(Constant.kAssetCash),
                              label: Text('Cash'.tr),
                              onPressed: () {
                                _controller.paymentMethodDialog(type: EnumPaymentMethodType.cash);
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
