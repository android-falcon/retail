import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/config/enum/enum_credit_card_type.dart';
import 'package:retail_system/config/enum/enum_discount_type.dart';
import 'package:retail_system/config/enum/enum_invoice_kind.dart';
import 'package:retail_system/config/enum/enum_order_type.dart';
import 'package:retail_system/config/enum/enum_payment_method_type.dart';
import 'package:retail_system/config/text_input_formatters.dart';
import 'package:retail_system/config/utils.dart';
import 'package:retail_system/config/validation.dart';
import 'package:retail_system/models/all_data/item_model.dart';
import 'package:retail_system/models/all_data/void_reason_model.dart';
import 'package:retail_system/models/cart_model.dart';
import 'package:retail_system/models/last_invoice.dart';
import 'package:retail_system/networks/rest_api.dart';
import 'package:retail_system/printer/printer.dart';
import 'package:retail_system/ui/screens/search_item/search_item_screen.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';
import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

  final cart = CartModel.init(orderType: EnumOrderType.takeAway).obs;
  final TextEditingController controllerSearch = TextEditingController();
  final FocusNode focusNodeSearch = FocusNode();
  final showLastInvoice = false.obs;

  refreshTime() {
    Timer.periodic(const Duration(minutes: 1), (Timer t) => update());
  }

  @override
  void onInit() {
    super.onInit();
    refreshTime();
  }

  Future<bool> onWillPop() async {
    var result = Utils.showAreYouSureDialog(title: 'Close System'.tr);
    return result;
  }

  searchItem() {
    controllerSearch.text = '';
    Get.to(() => SearchItemScreen())?.then((value) {
      if (value != null) {
        addItem(barcode: '$value');
      }
    });
  }

  addItem({required String barcode}) {
    if (barcode.isEmpty) {
      Utils.showSnackbar('Please fill search field'.tr, '');
    } else {
      var indexItem = allDataModel.items.indexWhere((element) => element.itemBarcodes.firstWhereOrNull((element) => element.barcode == barcode) != null);
      // var indexItem = allDataModel.items.indexWhere((element) => element.itemBarcode == barcode);
      if (indexItem == -1) {
        Utils.showSnackbar('Item not found'.tr, '');
        controllerSearch.text = '';
      } else {
        var indexCartItem = cart.value.items.lastIndexWhere((element) => element.id == allDataModel.items[indexItem].id);
        if (indexCartItem == -1) {
          cart.value.items.add(CartItemModel(
            uuid: const Uuid().v1(),
            parentUuid: '',
            orderType: EnumOrderType.takeAway,
            id: allDataModel.items[indexItem].id,
            categoryId: allDataModel.items[indexItem].category.id,
            taxType: allDataModel.items[indexItem].taxTypeId,
            taxPercent: allDataModel.items[indexItem].taxPercent.percent,
            name: allDataModel.items[indexItem].menuName,
            qty: 1,
            price: cart.value.deliveryCompanyId == 0 ? allDataModel.items[indexItem].price : allDataModel.items[indexItem].companyPrice,
            priceChange: cart.value.deliveryCompanyId == 0 ? allDataModel.items[indexItem].price : allDataModel.items[indexItem].companyPrice,
            total: cart.value.deliveryCompanyId == 0 ? allDataModel.items[indexItem].price : allDataModel.items[indexItem].companyPrice,
            tax: 0,
            discountAvailable: allDataModel.items[indexItem].discountAvailable == 1,
            openPrice: allDataModel.items[indexItem].openPrice == 1,
            rowSerial: cart.value.items.length + 1,
          ));
        } else {
          cart.value.items[indexCartItem].qty += 1;
        }
        cart.value = Utils.calculateOrder(cart: cart.value);
        controllerSearch.text = "";
        update();
      }
    }
    FocusScope.of(Get.context!).requestFocus(focusNodeSearch);
  }

  holdItems() async {
    if (cart.value.items.isEmpty) {
      showHoldItems();
    } else {
      var result = await showAddParkDialog();
      if (result['caption'].isNotEmpty) {
        cart.value.parkName = result['caption'];
        cart.value.parkColor = result['color'];
        var park = sharedPrefsClient.park;
        park.add(cart.value);
        sharedPrefsClient.park = park;
        cart.value = CartModel.init(orderType: EnumOrderType.takeAway);
        cart.value = Utils.calculateOrder(cart: cart.value);
        update();
      }
    }
  }

  voidAllItem() async {
    if (await Utils.checkPermission(sharedPrefsClient.employee.hasVoidAllPermission)) {
      if (cart.value.items.isEmpty) {
        Utils.showSnackbar('There must be items'.tr);
      } else {
        VoidReasonModel? result;
        if (allDataModel.companyConfig[0].useVoidReason) {
          result = await showVoidReasonDialog();
        } else {
          var areYouSure = await Utils.showAreYouSureDialog(title: 'Void All'.tr);
          if (areYouSure) {
            result = VoidReasonModel.fromJson({});
          }
        }
        if (result != null) {
          RestApi.saveVoidAllItems(items: cart.value.items, reason: result.reasonName);

          cart.value.items = [];
          cart.value.deliveryCharge = 0;
          cart.value.discount = 0;
          cart.value = Utils.calculateOrder(cart: cart.value);
          update();
        }
      }
    }
  }

  voidItem({required int index}) async {
    if (await Utils.checkPermission(sharedPrefsClient.employee.hasVoidPermission)) {
      VoidReasonModel? result;
      if (allDataModel.companyConfig[0].useVoidReason) {
        result = await showVoidReasonDialog();
      } else {
        var areYouSure = await Utils.showAreYouSureDialog(title: 'Void Item'.tr);
        if (areYouSure) {
          result = VoidReasonModel.fromJson({});
        }
      }
      if (result != null) {
        RestApi.saveVoidItem(item: cart.value.items[index], reason: result.reasonName);
        cart.value.items.removeWhere((element) => element.parentUuid == cart.value.items[index].uuid);
        cart.value.items.removeAt(index);
        if (cart.value.items.isEmpty) {
          cart.value.deliveryCharge = 0;
          cart.value.discount = 0;
        } else if (cart.value.items.every((element) => !element.discountAvailable)) {
          cart.value.discount = 0;
        }
        cart.value = Utils.calculateOrder(cart: cart.value);
        update();
      }
    }
  }

  editItem({required int indexItem}) async {
    GlobalKey<FormState> keyForm = GlobalKey<FormState>();
    EnumDiscountType type = cart.value.items[indexItem].lineDiscountType;
    TextEditingController controllerQty = TextEditingController(text: cart.value.items[indexItem].qty.toStringAsFixed(fractionDigits).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), ''));
    TextEditingController controllerPrice = TextEditingController(text: cart.value.items[indexItem].priceChange.toStringAsFixed(fractionDigits).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), ''));
    TextEditingController controllerLineDiscount = TextEditingController(text: cart.value.items[indexItem].lineDiscount.toStringAsFixed(fractionDigits).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), ''));
    TextEditingController controllerSelected = controllerQty;
    var result = await Get.dialog(
      CustomDialog(
        builder: (context, setState, constraints) => Form(
          key: keyForm,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  children: [
                    CustomTextField(
                      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
                      controller: controllerQty,
                      label: Text('Qty'.tr),
                      fillColor: Colors.white,
                      maxLines: 1,
                      inputFormatters: [
                        EnglishDigitsTextInputFormatter(decimal: true),
                      ],
                      enableInteractiveSelection: false,
                      keyboardType: const TextInputType.numberWithOptions(),
                      borderColor: controllerSelected == controllerQty ? AppColor.primaryColor : null,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        controllerSelected = controllerQty;
                        setState(() {});
                      },
                      validator: (value) {
                        return Validation.qty(value, minQty: 0);
                      },
                    ),
                    CustomTextField(
                      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
                      controller: controllerPrice,
                      label: Text('Price'.tr),
                      fillColor: Colors.white,
                      maxLines: 1,
                      inputFormatters: [
                        EnglishDigitsTextInputFormatter(decimal: true),
                      ],
                      enableInteractiveSelection: false,
                      keyboardType: const TextInputType.numberWithOptions(),
                      borderColor: controllerSelected == controllerPrice ? AppColor.primaryColor : null,
                      onTap: () async {
                        if (await Utils.checkPermission(sharedPrefsClient.employee.hasPriceChangePermission)) {
                          if (cart.value.items[indexItem].openPrice) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            controllerSelected = controllerPrice;
                            setState(() {});
                          } else {
                            Utils.showSnackbar('Price change is not available for this item'.tr);
                          }
                        }
                      },
                      validator: (value) {
                        return Validation.priceChange(value);
                      },
                    ),
                    CustomTextField(
                      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
                      controller: controllerLineDiscount,
                      label: Text('${'Line Discount'.tr} ${EnumDiscountType.value == type ? '(${controllerPrice.text})' : '(%)'}'),
                      fillColor: Colors.white,
                      maxLines: 1,
                      inputFormatters: [
                        EnglishDigitsTextInputFormatter(decimal: true),
                      ],
                      enableInteractiveSelection: false,
                      keyboardType: const TextInputType.numberWithOptions(),
                      borderColor: controllerSelected == controllerLineDiscount ? AppColor.primaryColor : null,
                      onTap: () async {
                        if (await Utils.checkPermission(sharedPrefsClient.employee.hasLineDiscPermission)) {
                          if (cart.value.items[indexItem].discountAvailable) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            controllerSelected = controllerLineDiscount;
                            setState(() {});
                          } else {
                            Utils.showSnackbar('Line discount is not available for this item'.tr);
                          }
                        }
                      },
                      validator: (value) {
                        return Validation.discount(type, value, double.parse(controllerPrice.text));
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Percentage'.tr),
                      value: type == EnumDiscountType.percentage,
                      onChanged: (value) {
                        type = value! ? EnumDiscountType.percentage : EnumDiscountType.value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              Utils.numPadWidget(
                controllerSelected,
                setState,
                decimal: true,
                onSubmit: () {
                  if (keyForm.currentState!.validate()) {
                    Get.back(result: true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    if (result != null && result == true) {
      cart.value.items[indexItem].qty = double.parse(controllerQty.text);
      cart.value.items[indexItem].price = double.parse(controllerPrice.text);
      cart.value.items[indexItem].lineDiscount = double.parse(controllerLineDiscount.text);
      cart.value.items[indexItem].lineDiscountType = type;
    }
    cart.value = Utils.calculateOrder(cart: cart.value);
    update();
  }

  discountOrder() async {
    GlobalKey<FormState> keyForm = GlobalKey<FormState>();
    EnumDiscountType type = cart.value.discountType;
    TextEditingController controllerDiscount = TextEditingController(text: cart.value.discount.toStringAsFixed(fractionDigits).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), ''));
    TextEditingController controllerSelected = controllerDiscount;
    var result = await Get.dialog(
      CustomDialog(
        builder: (context, setState, constraints) => Form(
          key: keyForm,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  children: [
                    CustomTextField(
                      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
                      controller: controllerDiscount,
                      label: Text('${'Discount'.tr} ${EnumDiscountType.value == type ? '(${cart.value.total.toStringAsFixed(3)})' : '(%)'}'),
                      fillColor: Colors.white,
                      maxLines: 1,
                      inputFormatters: [
                        EnglishDigitsTextInputFormatter(decimal: true),
                      ],
                      enableInteractiveSelection: false,
                      keyboardType: const TextInputType.numberWithOptions(),
                      borderColor: controllerSelected == controllerDiscount ? AppColor.primaryColor : null,
                      onTap: () async {
                        if (await Utils.checkPermission(sharedPrefsClient.employee.hasLineDiscPermission)) {
                          if (cart.value.items.any((element) => element.discountAvailable)) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            controllerSelected = controllerDiscount;
                            setState(() {});
                          } else {
                            Utils.showSnackbar('No items accept discount in order'.tr);
                          }
                        }
                      },
                      validator: (value) {
                        return Validation.discount(type, value, cart.value.total);
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Percentage'.tr),
                      value: type == EnumDiscountType.percentage,
                      onChanged: (value) {
                        type = value! ? EnumDiscountType.percentage : EnumDiscountType.value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              Utils.numPadWidget(
                controllerSelected,
                setState,
                decimal: true,
                onSubmit: () {
                  if (keyForm.currentState!.validate()) {
                    Get.back(result: true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    if (result != null && result == true) {
      cart.value.discount = double.parse(controllerDiscount.text);
      cart.value.discountType = type;
    }
    cart.value = Utils.calculateOrder(cart: cart.value);
    update();
  }

  double _calculateRemaining() {
    return cart.value.amountDue - (cart.value.cash + cart.value.credit + cart.value.cheque + cart.value.gift + cart.value.coupon + cart.value.point);
  }

  Future<Map<dynamic, dynamic>> showAddParkDialog() async {
    GlobalKey<FormState> keyForm = GlobalKey<FormState>();
    TextEditingController controllerCaption = TextEditingController();
    Color? parkColor;
    await Get.dialog(
      CustomDialog(
        borderRadius: BorderRadius.circular(20.r),
        width: 250.w,
        builder: (context, setState, constraints) => Padding(
          padding: EdgeInsets.all(16.sp),
          child: Form(
            key: keyForm,
            child: Column(
              children: [
                Wrap(
                  children: [
                    CustomSelectColor(
                      value: Colors.green,
                      gropeValue: parkColor,
                      onTap: () {
                        parkColor = Colors.green;
                        setState(() {});
                      },
                    ),
                    CustomSelectColor(
                      value: Colors.red,
                      gropeValue: parkColor,
                      onTap: () {
                        parkColor = Colors.red;
                        setState(() {});
                      },
                    ),
                    CustomSelectColor(
                      value: Colors.blue,
                      gropeValue: parkColor,
                      onTap: () {
                        parkColor = Colors.blue;
                        setState(() {});
                      },
                    ),
                    CustomSelectColor(
                      value: Colors.yellow,
                      gropeValue: parkColor,
                      onTap: () {
                        parkColor = Colors.yellow;
                        setState(() {});
                      },
                    ),
                    CustomSelectColor(
                      value: Colors.orange,
                      gropeValue: parkColor,
                      onTap: () {
                        parkColor = Colors.orange;
                        setState(() {});
                      },
                    ),
                    CustomSelectColor(
                      value: Colors.pink,
                      gropeValue: parkColor,
                      onTap: () {
                        parkColor = Colors.pink;
                        setState(() {});
                      },
                    ),
                    CustomSelectColor(
                      value: Colors.purple,
                      gropeValue: parkColor,
                      onTap: () {
                        parkColor = Colors.purple;
                        setState(() {});
                      },
                    ),
                    CustomSelectColor(
                      value: Colors.tealAccent,
                      gropeValue: parkColor,
                      onTap: () {
                        parkColor = Colors.tealAccent;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                const Divider(thickness: 2),
                SizedBox(height: 20.h),
                CustomTextField(
                  borderColor: AppColor.primaryColor,
                  controller: controllerCaption,
                  label: Text('Hold Caption'.tr),
                  fillColor: Colors.white,
                  validator: (value) {
                    return Validation.isRequired(value);
                  },
                ),
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      fixed: true,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      backgroundColor: AppColor.primaryColor,
                      onPressed: () {
                        if (keyForm.currentState!.validate()) {
                          Get.back();
                        }
                      },
                      child: Text('Add'.tr),
                    ),
                    CustomButton(
                      fixed: true,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Cancel'.tr),
                      onPressed: () {
                        controllerCaption.text = '';
                        Get.back();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
    return {'caption': controllerCaption.text, 'color': parkColor ?? Colors.white};
  }

  showHoldItems() {
    var holdItems = sharedPrefsClient.park;
    Get.dialog(
      CustomDialog(
        builder: (context, setState, constraints) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              Container(
                height: 250.h,
                margin: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.sp),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              'Caption'.tr,
                              style: kStyleTextTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Total'.tr,
                              style: kStyleTextTable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: holdItems.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            cart.value = holdItems[index];
                            holdItems.removeAt(index);
                            sharedPrefsClient.park = holdItems;
                            Get.back();
                            update();
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.sp),
                            color: holdItems[index].parkColor,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    holdItems[index].parkName,
                                    style: kStyleDataTable,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    holdItems[index].amountDue.toStringAsFixed(fractionDigits),
                                    style: kStyleDataTable,
                                    maxLines: 1,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    backgroundColor: AppColor.red,
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
                    fixed: true,
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Exit'.tr,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  speedItems() {
    List<ItemModel> items = allDataModel.items.where((element) => element.isSpeedItem == 1).toList();
    if (items.isNotEmpty) {
      Get.dialog(
        CustomDialog(
          enableScroll: false,
          builder: (context, setState, constraints) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.primaryColor),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: CustomSingleChildScrollView(
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        children: items
                            .map((e) => Padding(
                                  padding: EdgeInsets.all(8.sp),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.back();
                                      addItem(barcode: e.itemBarcodes.first.barcode);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12.sp),
                                      decoration: BoxDecoration(color: AppColor.grayLight, borderRadius: BorderRadius.all(Radius.circular(10.r))),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${e.menuName}\n',
                                            style: kStyleTextTitle,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${'Price'} : ${e.price.toStringAsFixed(fractionDigits)}',
                                            style: kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                CustomButton(
                  backgroundColor: AppColor.red,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
                  fixed: true,
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Exit'.tr,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      Utils.showSnackbar('There are no speed items'.tr);
    }
  }

  Future<VoidReasonModel?> showVoidReasonDialog() async {
    int? selectedVoidReasonId;
    await Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: CustomDialog(
          builder: (context, setState, constraints) => Column(
            children: [
              Text(
                'Void Reason'.tr,
                style: kStyleTextLarge,
              ),
              const Divider(thickness: 2),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allDataModel.voidReason.length,
                itemBuilder: (context, index) => RadioListTile(
                  title: Text(
                    allDataModel.voidReason[index].reasonName,
                    style: kStyleForceQuestion,
                  ),
                  value: allDataModel.voidReason[index].id,
                  groupValue: selectedVoidReasonId,
                  onChanged: (value) {
                    selectedVoidReasonId = value as int;
                    setState(() {});
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    fixed: true,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    backgroundColor: AppColor.primaryColor,
                    onPressed: () {
                      selectedVoidReasonId = null;
                      Get.back();
                    },
                    child: Text('Cancel'.tr),
                  ),
                  CustomButton(
                    fixed: true,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    backgroundColor: AppColor.primaryColor,
                    onPressed: () {
                      if (selectedVoidReasonId == null) {
                        Utils.showSnackbar('Please select void reason'.tr);
                      } else {
                        Get.back();
                      }
                    },
                    child: Text('Save'.tr),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    return selectedVoidReasonId == null ? null : allDataModel.voidReason.firstWhere((element) => element.id == selectedVoidReasonId);
  }

  paymentMethodDialog({required EnumPaymentMethodType type}) {
    if (cart.value.items.isNotEmpty) {
      double remaining = _calculateRemaining();
      Get.dialog(
        CustomDialog(
          builder: (context, setState, constraints) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              children: [
                Text(
                  '${'Date'.tr} : ${intl.DateFormat(dateFormat).format(sharedPrefsClient.dailyClose)}',
                  style: kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${'Remaining'.tr} : ${remaining.toStringAsFixed(fractionDigits)}',
                  style: kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 35.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                        onPressed: () async {
                          var result = await paymentDialog(
                            balance: remaining + cart.value.cash,
                            received: cart.value.cash,
                            enableReturnValue: true,
                          );
                          cart.value.cash = result['received'];
                          remaining = _calculateRemaining();
                          setState(() {});
                          // if (remaining == 0) {
                          //   _showFinishDialog();
                          // }
                        },
                        child: Text('${'Cash'.tr} : ${cart.value.cash.toStringAsFixed(fractionDigits)}'),
                      ),
                    ),
                    if (type == EnumPaymentMethodType.otherPayment)
                      Expanded(
                        child: CustomButton(
                          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                          onPressed: () async {
                            var result = await paymentDialog(
                              balance: remaining + cart.value.credit,
                              received: cart.value.credit,
                              enableReturnValue: false,
                              controllerCreditCard: TextEditingController(text: cart.value.creditCardNumber),
                              paymentCompany: cart.value.payCompanyId == 0 ? null : cart.value.payCompanyId,
                            );
                            cart.value.credit = result['received'];
                            cart.value.creditCardNumber = result['credit_card'];
                            cart.value.creditCardType = result['credit_card_type'];
                            cart.value.payCompanyId = result['payment_company'];
                            remaining = _calculateRemaining();
                            setState(() {});
                            // if (remaining == 0) {
                            //   _showFinishDialog();
                            // }
                          },
                          child: Text('${'Credit Card'.tr} : ${cart.value.credit.toStringAsFixed(fractionDigits)}'),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.only(top: 8.w, left: 14.w, right: 14.w, bottom: 16.w),
                  decoration: BoxDecoration(
                    color: AppColor.accentColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      CustomIconText(
                        bold: true,
                        label: '${'Total'.tr} : ${cart.value.total.toStringAsFixed(fractionDigits)}',
                      ),
                      // CustomIconText(
                      //   bold: true,
                      //   label: '${'Delivery charge'.tr} : ${cart.value.deliveryCharge.toStringAsFixed(fractionDigits)}',
                      // ),
                      CustomIconText(
                        bold: true,
                        label: '${'Line discount'.tr} : ${cart.value.totalLineDiscount.toStringAsFixed(fractionDigits)}',
                      ),
                      CustomIconText(
                        bold: true,
                        label: '${'Discount'.tr} : ${cart.value.totalDiscount.toStringAsFixed(fractionDigits)}',
                      ),
                      CustomIconText(
                        bold: true,
                        label: '${'Sub total'.tr} : ${cart.value.subTotal.toStringAsFixed(fractionDigits)}',
                      ),
                      // CustomIconText(
                      //   bold: true,
                      //   label: '${'Service'.tr} : ${cart.value.service.toStringAsFixed(fractionDigits)}',
                      // ),
                      CustomIconText(
                        bold: true,
                        label: '${'Tax'.tr} : ${cart.value.tax.toStringAsFixed(fractionDigits)}',
                      ),
                      CustomIconText(
                        bold: true,
                        label: '${'Amount Due'.tr} : ${cart.value.amountDue.toStringAsFixed(fractionDigits)}',
                      ),
                      const Divider(),
                      CustomIconText(
                        bold: true,
                        label: '${'Total Due'.tr} : ${cart.value.amountDue.toStringAsFixed(fractionDigits)}',
                      ),
                      CustomIconText(
                        bold: true,
                        label: '${'Total received'.tr} : ${(cart.value.cash + cart.value.credit + cart.value.cheque + cart.value.gift + cart.value.coupon + cart.value.point).toStringAsFixed(fractionDigits)}',
                      ),
                      CustomIconText(
                        bold: true,
                        label: '${'Balance'.tr} : ${remaining.toStringAsFixed(fractionDigits)}',
                      ),
                      SizedBox(height: 20.h),
                      CustomButton(
                        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
                        backgroundColor: Colors.white,
                        fixed: true,
                        onPressed: () {
                          if (remaining == 0) {
                            for (int i = 0; i < cart.value.items.length; i++) {
                              cart.value.items[i].rowSerial = i + 1;
                            }
                            RestApi.invoice(cart: cart.value, invoiceKind: EnumInvoiceKind.invoicePay);
                            sharedPrefsClient.lastInvoice = LastInvoice(invoiceNo: sharedPrefsClient.inVocNo, total: cart.value.amountDue);
                            sharedPrefsClient.inVocNo++;
                            Get.back();
                            Printer.printInvoicesDialog(cart: cart.value, showPrintButton: false, invNo: '${sharedPrefsClient.inVocNo - 1}').then((value) {
                              cart.value = CartModel.init(orderType: EnumOrderType.takeAway);
                              update();
                            });
                          } else {
                            Utils.showSnackbar('The remainder should be 0'.tr);
                          }
                        },
                        child: Text(
                          'Save'.tr,
                          style: TextStyle(color: AppColor.tertiaryColor),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      Utils.showSnackbar('Please add items'.tr);
    }
  }

  paymentDialog({TextEditingController? controllerReceived, required double balance, required double received, bool enableReturnValue = false, TextEditingController? controllerCreditCard, int? paymentCompany}) async {
    GlobalKey<FormState> keyForm = GlobalKey<FormState>();
    if (controllerCreditCard != null && received == 0) {
      controllerReceived ??= TextEditingController(text: balance.toStringAsFixed(fractionDigits));
    } else {
      controllerReceived ??= TextEditingController(text: received.toStringAsFixed(fractionDigits));
    }

    if (controllerReceived.text.endsWith('.000')) {
      controllerReceived.text = controllerReceived.text.replaceFirst('.000', '');
    }
    EnumCreditCardType selectedCreditCard = EnumCreditCardType.visa;
    int? selectedPaymentCompany;
    if (paymentCompany != null) {
      selectedPaymentCompany = paymentCompany;
    }
    TextEditingController controllerSelected = controllerReceived;
    var result = await Get.dialog(
      CustomDialog(
        builder: (context, setState, constraints) => Form(
          key: keyForm,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        controllerReceived!.text = balance.toStringAsFixed(fractionDigits);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.sp),
                        child: Text(
                          '${'Balance'.tr} : ${balance.toStringAsFixed(fractionDigits)}',
                          style: kStyleTextLarge,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (controllerCreditCard != null)
                      Column(
                        children: [
                          CustomDropDown(
                            isExpanded: true,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            hint: 'Payment Company'.tr,
                            items: allDataModel.paymentCompanyModel
                                .map((e) => DropdownMenuItem(
                                      value: e.id,
                                      child: Text(e.coName),
                                    ))
                                .toList(),
                            selectItem: selectedPaymentCompany,
                            onChanged: (value) {
                              selectedPaymentCompany = value as int;
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Flexible(
                                child: RadioListTile(
                                  value: EnumCreditCardType.visa,
                                  groupValue: selectedCreditCard,
                                  dense: true,
                                  title: Text('Visa'.tr),
                                  onChanged: (value) {
                                    selectedCreditCard = value as EnumCreditCardType;
                                    setState(() {});
                                  },
                                ),
                              ),
                              Flexible(
                                child: RadioListTile(
                                  value: EnumCreditCardType.mastercard,
                                  groupValue: selectedCreditCard,
                                  dense: true,
                                  title: Text('Master card'.tr),
                                  onChanged: (value) {
                                    selectedCreditCard = value as EnumCreditCardType;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            margin: EdgeInsets.symmetric(horizontal: 10.h),
                            controller: controllerReceived,
                            label: Text('Received'.tr),
                            fillColor: Colors.white,
                            maxLines: 1,
                            inputFormatters: [
                              EnglishDigitsTextInputFormatter(decimal: true),
                            ],
                            enableInteractiveSelection: false,
                            keyboardType: const TextInputType.numberWithOptions(),
                            borderColor: controllerSelected == controllerReceived ? AppColor.primaryColor : null,
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              controllerSelected = controllerReceived!;
                              setState(() {});
                            },
                            validator: (value) {
                              if (!enableReturnValue) {
                                if (double.parse(value!) > double.parse(balance.toStringAsFixed(fractionDigits))) {
                                  return '${'The entered value cannot be greater than the balance'.tr} (${balance.toStringAsFixed(fractionDigits)})';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        if (controllerCreditCard != null)
                          Expanded(
                            child: CustomTextField(
                              margin: EdgeInsets.symmetric(horizontal: 10.h),
                              controller: controllerCreditCard,
                              label: Text('Card Number'.tr),
                              fillColor: Colors.white,
                              maxLines: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CardNumberFormatter(),
                              ],
                              enableInteractiveSelection: false,
                              keyboardType: const TextInputType.numberWithOptions(),
                              borderColor: controllerSelected == controllerCreditCard ? AppColor.primaryColor : null,
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                controllerSelected = controllerCreditCard;
                                setState(() {});
                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Utils.numPadWidget(
                controllerSelected,
                setState,
                decimal: false,
                card: controllerSelected == controllerCreditCard,
                onSubmit: () {
                  if (keyForm.currentState!.validate()) {
                    if (controllerCreditCard != null && selectedPaymentCompany == null && controllerReceived!.text != '0') {
                      Utils.showSnackbar('', 'Please select a payment company'.tr);
                    } else {
                      Get.back(result: controllerReceived!.text);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
    double _received = result == null ? received : double.parse(result);
    if ((_received - double.parse(balance.toStringAsFixed(3))) == 0) {
      _received = balance;
    } else if (enableReturnValue && _received > balance) {
      await Get.dialog(
        CustomDialog(
          builder: (context, setState, constraints) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 80.h),
                  child: Text(
                    '${'Please return this value'.tr} :    ${(_received - balance).toStringAsFixed(3)}',
                    style: kStyleTextTitle,
                  ),
                ),
                CustomButton(
                  fixed: true,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
                  child: Text(
                    'Done'.tr,
                    style: kStyleButtonPayment,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      );
      _received = balance;
    }
    return {
      "received": _received,
      "credit_card": controllerCreditCard?.text ?? "",
      "credit_card_type": selectedCreditCard.name,
      'payment_company': selectedPaymentCompany ?? 0,
    };
  }
}
