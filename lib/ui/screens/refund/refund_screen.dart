import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/config/enum/enum_invoice_kind.dart';
import 'package:retail_system/config/text_input_formatters.dart';
import 'package:retail_system/config/utils.dart';
import 'package:retail_system/config/validation.dart';
import 'package:retail_system/controllers/refund_controller.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class RefundScreen extends GetResponsiveView {
  RefundScreen({super.key});

  final _controller = RefundController.to;

  _buildWidget() {
    return CustomWidget(
      alignment: Alignment.topCenter,
      appBar: AppBar(
        title: Text('Refund'.tr),
      ),
      child: GetBuilder<RefundController>(
        builder: (controller) => CustomSingleChildScrollView(
          child: Form(
            key: _controller.keyForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconText(
                  icon: kAssetArrow,
                  bold: true,
                  expanded: false,
                  label: '${'Cashier  No'.tr} : ${sharedPrefsClient.cashNo}',
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        controller: _controller.controllerInvoiceNo,
                        label: Text('Invoice No'.tr),
                        maxLines: 1,
                        inputFormatters: [
                          EnglishDigitsTextInputFormatter(decimal: false),
                        ],
                        keyboardType: const TextInputType.numberWithOptions(),
                        validator: (value) => Validation.isRequired(value),
                      ),
                    ),
                    Expanded(
                      child: CustomTextField(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        controller: _controller.controllerPosNo,
                        label: Text('POS No'.tr),
                        maxLines: 1,
                        inputFormatters: [
                          EnglishDigitsTextInputFormatter(decimal: false),
                        ],
                        keyboardType: const TextInputType.numberWithOptions(),
                        validator: (value) => Validation.isRequired(value),
                      ),
                    ),
                    CustomButton(
                      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                      fixed: true,
                      child: Text('Search'.tr),
                      onPressed: () {
                        _controller.searchInvoice();
                      },
                    ),
                  ],
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
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Unit'.tr,
                              style: kStyleTextTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Qty'.tr,
                              style: kStyleTextTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Price'.tr,
                              style: kStyleTextTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Disc'.tr,
                              style: kStyleTextTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Ret Qty'.tr,
                              style: kStyleTextTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Net Price'.tr,
                              style: kStyleTextTable.copyWith(color: AppColor.blue2),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _controller.refundModel.value?.items.length ?? 0,
                          itemBuilder: (context, index) => Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Text(
                                  _controller.refundModel.value!.items[index].name,
                                  style: kStyleDataTable,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Unit',
                                  style: kStyleDataTable,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  _controller.refundModel.value!.items[index].qty.toStringAsFixed(fractionDigits),
                                  style: kStyleDataTable,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  _controller.refundModel.value!.items[index].returnedPrice.toStringAsFixed(fractionDigits),
                                  style: kStyleDataTable,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  _controller.refundModel.value!.items[index].totalLineDiscount.toStringAsFixed(fractionDigits),
                                  style: kStyleDataTable,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () async {
                                    _controller.changeRetQty(index: index);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(4.sp),
                                    child: Text(
                                      _controller.refundModel.value!.items[index].returnedQty.toStringAsFixed(fractionDigits),
                                      style: kStyleDataTable,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  _controller.refundModel.value!.items[index].returnedTotal.toStringAsFixed(fractionDigits),
                                  style: kStyleDataTable,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                      Row(
                        children: [
                          Expanded(
                            child: CustomIconText(
                              icon: kAssetArrow,
                              label: '${'Disc'.tr} : ${_controller.refundModel.value?.totalDiscount.toStringAsFixed(fractionDigits)}',
                            ),
                          ),
                          Expanded(
                            child: CustomIconText(
                              icon: kAssetArrow,
                              style: kStyleTextTitle.copyWith(fontWeight: FontWeight.bold, fontSize: 23.sp, color: AppColor.blue2),
                              label: '${'Return'.tr} : ${_controller.refundModel.value?.items.fold(0.0, (previousValue, element) => (previousValue) + element.returnedTotal).toStringAsFixed(3)}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: CustomButton(
                    margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                    fixed: true,
                    onPressed: _controller.refundModel.value == null
                        ? null
                        : () async {
                            _controller.saveRefund();
                          },
                    child: Text('Save'.tr),
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
