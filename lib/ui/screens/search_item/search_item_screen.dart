import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/controllers/search_item_controller.dart';
import 'package:retail_system/ui/screens/tocopyfrom/_widgets.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class SearchItemScreen extends GetResponsiveView {
  SearchItemScreen({super.key});

  final _controller = SearchItemController.to;

  _buildCheckBox({required TextEditingController controller, required RxBool valueCheckbox, required String label}) {
    return Row(
      children: [
        Checkbox(
          value: valueCheckbox.value,
          onChanged: (value) {
            valueCheckbox.value = value!;
            _controller.update();
          },
        ),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: kStyleTextTitle,
          ),
        ),
        Expanded(
          flex: 3,
          child: CustomTextField(
            controller: controller,
          ),
        ),
      ],
    );
  }

  _buildCheckBoxDropDown({required List<DropdownMenuItem<Object>> items, required Rxn<int> dropDownSelect, required RxBool valueCheckbox, required String label}) {
    return Row(
      children: [
        Checkbox(
          value: valueCheckbox.value,
          onChanged: (value) {
            valueCheckbox.value = value!;
            _controller.update();
          },
        ),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: kStyleTextTitle,
          ),
        ),
        Expanded(
          flex: 3,
          child: CustomDropDown(
            width: double.infinity,
            items: items,
            selectItem: dropDownSelect.value,
            onChanged: (value) {
              dropDownSelect.value = value as int;
              _controller.update();
            },
          ),
        ),
      ],
    );
  }

  _buildWidget() {
    return CustomWidget(
      alignment: Alignment.topCenter,
      appBar: AppBar(
        title: Text('Search Item'.tr),
      ),
      child: GetBuilder<SearchItemController>(
        builder: (controller) => CustomSingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildCheckBox(
                      controller: _controller.controllerItemCode,
                      valueCheckbox: _controller.checkItemCode,
                      label: 'Item code'.tr,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _buildCheckBox(
                      controller: _controller.controllerItemName,
                      valueCheckbox: _controller.checkItemName,
                      label: 'Item name'.tr,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: _buildCheckBox(
                      controller: _controller.controllerItemNameE,
                      valueCheckbox: _controller.checkItemNameE,
                      label: 'Item name E'.tr,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _buildCheckBoxDropDown(
                      dropDownSelect: _controller.dropDownSelectGroup,
                      valueCheckbox: _controller.checkGroup,
                      label: 'Group'.tr,
                      items: allDataModel.categories
                          .map((e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(e.categoryName),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: _buildCheckBoxDropDown(
                      dropDownSelect: _controller.dropDownSelectUnit,
                      valueCheckbox: _controller.checkUnit,
                      label: 'Unit'.tr,
                      items: [],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _buildCheckBoxDropDown(
                      dropDownSelect: _controller.dropDownSelectMinaColor,
                      valueCheckbox: _controller.checkMinaColor,
                      label: 'Mina color'.tr,
                      items: [],
                    ),
                  ),
                ],
              ),
              Container(
                height: 150.h,
                margin: EdgeInsets.symmetric(vertical: 16.h),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    _controller.resultItems.isEmpty
                        ? CustomIconText(
                            icon: kAssetPhoto,
                            label: 'Item Photo'.tr,
                          )
                        : Container(),
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
                          flex: 4,
                          child: Text(
                            'Original No'.tr,
                            style: kStyleTextTable,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          flex: 4,
                          child: Text(
                            'New No'.tr,
                            style: kStyleTextTable,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          flex: 6,
                          child: Text(
                            'Item name'.tr,
                            style: kStyleTextTable,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Sale Price'.tr,
                            style: kStyleTextTable,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _controller.resultItems.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Get.back(result: _controller.resultItems[index].itemBarcode);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    _controller.resultItems[index].itemBarcode,
                                    style: kStyleDataTable,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    _controller.resultItems[index].itemBarcode,
                                    style: kStyleDataTable,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    _controller.resultItems[index].menuName,
                                    style: kStyleDataTable,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    _controller.resultItems[index].price.toStringAsFixed(fractionDigits),
                                    style: kStyleDataTable,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                          _controller.searchItems();
                        },
                        label: Text('Search'.tr),
                        icon: SvgPicture.asset(kAssetSearch),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomButtonOutline(
                        onPressed: () {
                          Get.back();
                        },
                        label: Text('Exit'.tr),
                        icon: SvgPicture.asset(kAssetExit),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
