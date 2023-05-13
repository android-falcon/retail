import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/config/enum/enum_discount_type.dart';
import 'package:retail_system/config/enum/enum_invoice_kind.dart';
import 'package:retail_system/config/enum/enum_order_type.dart';
import 'package:retail_system/config/validation.dart';
import 'package:retail_system/models/all_data/category_model.dart';
import 'package:retail_system/models/all_data/employee_model.dart';
import 'package:retail_system/models/all_data/item_model.dart';
import 'package:retail_system/models/cart_model.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class Utils {
  static Future<PackageInfo> packageInfo() async => await PackageInfo.fromPlatform();

  static bool isNotEmpty(String? s) => s != null && s.isNotEmpty;

  static bool isEmpty(String? s) => s == null || s.isEmpty;

  static showLoadingDialog([String? text]) {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: CustomLoadingDialog(
          title: text ?? 'Loading ...',
        ),
      ),
      barrierDismissible: false,
      useSafeArea: false,
    );
  }

  static showSnackbar([String? title, String? message]) {
    hideLoadingDialog();
    Get.snackbar(
      title ?? '',
      message ?? '',
      duration: const Duration(seconds: 2),
      backgroundColor: AppColor.gray.withOpacity(0.5),
      margin: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
    );
  }

  static void hideLoadingDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  static CartModel calculateOrder({required CartModel cart, EnumInvoiceKind invoiceKind = EnumInvoiceKind.invoicePay}) {
    if (allDataModel.companyConfig.first.taxCalcMethod == 0) {
      // خاضع
      switch (invoiceKind) {
        case EnumInvoiceKind.invoicePay:
          for (var element in cart.items) {
            element.total = element.priceChange * element.qty;
            element.totalLineDiscount = (element.lineDiscountType == EnumDiscountType.percentage ? element.priceChange * (element.lineDiscount / 100) : element.lineDiscount) * element.qty;
          }
          break;
        case EnumInvoiceKind.invoiceReturn:
          for (var element in cart.items) {
            element.returnedTotal = element.priceChange * element.returnedQty;
            element.total = element.priceChange * element.returnedQty;
            element.totalLineDiscount = (element.lineDiscountType == EnumDiscountType.percentage ? element.priceChange * (element.lineDiscount / 100) : element.lineDiscount) * element.returnedQty;
          }
          break;
      }
      cart.total = cart.items.fold(0.0, (sum, item) => sum + item.total);
      cart.totalLineDiscount = cart.items.fold(0.0, (sum, item) => sum + item.totalLineDiscount);
      cart.totalDiscount = cart.discountType == EnumDiscountType.percentage ? (cart.total - cart.totalLineDiscount) * (cart.discount / 100) : cart.discount;
      cart.subTotal = cart.total - cart.totalDiscount - cart.totalLineDiscount;
      cart.service = cart.orderType == EnumOrderType.takeAway ? 0 : cart.subTotal * (allDataModel.companyConfig.first.servicePerc / 100);
      cart.serviceTax = cart.orderType == EnumOrderType.takeAway ? 0 : cart.service * (allDataModel.companyConfig.first.serviceTaxPerc / 100);
      double totalDiscountAvailableItem = cart.items.fold(0.0, (sum, item) => sum + (item.discountAvailable ? (item.total - item.totalLineDiscount) : 0));
      for (var element in cart.items) {
        if (element.discountAvailable) {
          element.discount = cart.totalDiscount * ((element.total - element.totalLineDiscount) / totalDiscountAvailableItem);
        } else {
          element.discount = 0;
        }
        element.tax = element.taxType == 2 ? 0 : (element.total - element.totalLineDiscount - element.discount) * (element.taxPercent / 100);
        element.service = cart.service * ((element.total - element.totalLineDiscount - element.discount) / cart.subTotal);
        element.serviceTax = element.service * (allDataModel.companyConfig.first.serviceTaxPerc / 100);
      }

      cart.itemsTax = cart.items.fold(0.0, (sum, item) => sum + item.tax);
      cart.tax = cart.itemsTax + cart.serviceTax;
      cart.amountDue = cart.subTotal + cart.deliveryCharge + cart.service + cart.tax;
      cart.returnedTotal = cart.subTotal + cart.deliveryCharge + cart.service + cart.tax;
    } else {
      // شامل
      switch (invoiceKind) {
        case EnumInvoiceKind.invoicePay:
          for (var element in cart.items) {
            element.total = (element.priceChange / (1 + (element.taxPercent / 100))) * element.qty;
            element.totalLineDiscount = (element.lineDiscountType == EnumDiscountType.percentage ? (element.priceChange / (1 + (element.taxPercent / 100))) * (element.lineDiscount / 100) : element.lineDiscount) * element.qty;
          }
          break;
        case EnumInvoiceKind.invoiceReturn:
          for (var element in cart.items) {
            element.returnedTotal = ((element.priceChange / (1 + (element.taxPercent / 100))) * element.returnedQty);
            element.total = ((element.priceChange / (1 + (element.taxPercent / 100)))  ) * element.returnedQty;
            element.totalLineDiscount = (element.lineDiscountType == EnumDiscountType.percentage ? (element.priceChange / (1 + (element.taxPercent / 100))) * (element.lineDiscount / 100) : element.lineDiscount) * element.returnedQty;
          }
          break;
      }
      cart.total = cart.items.fold(0.0, (sum, item) => sum + item.total);
      cart.totalLineDiscount = cart.items.fold(0.0, (sum, item) => sum + item.totalLineDiscount);
      cart.totalDiscount = cart.discountType == EnumDiscountType.percentage ? (cart.total - cart.totalLineDiscount) * (cart.discount / 100) : cart.discount;
      cart.subTotal = cart.total - cart.totalDiscount - cart.totalLineDiscount;
      cart.service = cart.orderType == EnumOrderType.takeAway ? 0 : cart.subTotal * (allDataModel.companyConfig.first.servicePerc / 100);
      cart.serviceTax = cart.orderType == EnumOrderType.takeAway ? 0 : cart.service * (allDataModel.companyConfig.first.serviceTaxPerc / 100);
      double totalDiscountAvailableItem = cart.items.fold(0.0, (sum, item) => sum + (item.discountAvailable ? (item.total - item.totalLineDiscount) : 0));
      for (var element in cart.items) {
        if (element.discountAvailable) {
          element.discount = cart.totalDiscount * ((element.total - element.totalLineDiscount) / totalDiscountAvailableItem);
        } else {
          element.discount = 0;
        }
        element.tax = element.taxType == 2 ? 0 : (element.total - element.totalLineDiscount - element.discount) * (element.taxPercent / 100);
        element.service = cart.service * ((element.total - element.totalLineDiscount - element.discount) / cart.subTotal);
        element.serviceTax = element.service * (allDataModel.companyConfig.first.serviceTaxPerc / 100);
      }

      cart.itemsTax = cart.items.fold(0.0, (sum, item) => sum + item.tax);
      cart.tax = cart.itemsTax + cart.serviceTax;
      cart.amountDue = cart.subTotal + cart.deliveryCharge + cart.service + cart.tax;
      cart.returnedTotal = cart.subTotal + cart.deliveryCharge + cart.service + cart.tax;
    }
    return cart;
  }

  static void loadSorting() {
    for (var sortItem in sharedPrefsClient.sorting.items) {
      var oldIndex = allDataModel.items.indexWhere((element) => element.id == sortItem.id);
      var newIndex = sortItem.index;
      if (oldIndex != -1) {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final ItemModel item = allDataModel.items.removeAt(oldIndex);
        allDataModel.items.insert(newIndex, item);
      }
    }
    for (var sortCategory in sharedPrefsClient.sorting.categories) {
      var oldIndex = allDataModel.categories.indexWhere((element) => element.id == sortCategory.id);
      var newIndex = sortCategory.index;
      if (oldIndex != -1) {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final CategoryModel item = allDataModel.categories.removeAt(oldIndex);
        allDataModel.categories.insert(newIndex, item);
      }
    }
  }

  static Future<bool> showAreYouSureDialog({required String title}) async {
    var result = await Get.defaultDialog(
      title: title,
      content: Text('Are you sure?'.tr),
      textCancel: 'Cancel'.tr,
      textConfirm: 'Confirm'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(result: true);
      },
      barrierDismissible: true,
    );
    return result ?? false;
  }

  static Future<bool> checkGPS() async {
    bool serviceEnabled;
    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Location().requestService();
      if (serviceEnabled) {
        await Future.delayed(const Duration(milliseconds: 200));
        return checkGPS();
      } else {
        return false;
      }
    } else {
      geolocator.LocationPermission permission;
      permission = await geolocator.Geolocator.checkPermission();
      if (permission == geolocator.LocationPermission.denied) {
        permission = await geolocator.Geolocator.requestPermission();
        if (permission == geolocator.LocationPermission.always || permission == geolocator.LocationPermission.whileInUse) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    }
  }

  static Future<List<String>> pickImages({bool allowMultiple = true}) async {
    List<PlatformFile>? files = [];
    List<String> listBase64 = [];
    try {
      var _files = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple,
        type: FileType.image,
        onFileLoading: (FilePickerStatus status) => log(status.toString()),
      );
      files = _files?.files;
    } on PlatformException catch (e) {
      log('Unsupported operation' + e.toString());
    } catch (e) {
      log(e.toString());
    }
    if (files != null) {
      for (var item in files) {
        var file = File(item.path!).readAsBytesSync();
        listBase64.add(base64Encode(file));
      }
    }
    return listBase64;
  }

  static Future<bool> checkPermission(hasPermission) async {
    var permission = false;
    if (hasPermission) {
      permission = true;
    } else {
      EmployeeModel? employee = await Utils.showLoginDialog();
      if (employee != null) {
        if (employee.hasVoidPermission) {
          permission = true;
        } else {
          Utils.showSnackbar('The account you are logged in with does not have permission'.tr);
        }
      }
    }
    return permission;
  }

  static Future<EmployeeModel?> showLoginDialog() async {
    final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
    final TextEditingController controllerUsername = TextEditingController();
    final TextEditingController controllerPassword = TextEditingController();
    var result = await Get.dialog(
      CustomDialog(
        gestureDetectorOnTap: () {},
        builder: (context, setState, constraints) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: keyForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextField(
                      controller: controllerUsername,
                      label: Text('Username'.tr),
                      maxLines: 1,
                      validator: (value) {
                        return Validation.isRequired(value);
                      },
                    ),
                    CustomTextField(
                      controller: controllerPassword,
                      label: Text('Password'.tr),
                      obscureText: true,
                      isPass: true,
                      maxLines: 1,
                      validator: (value) {
                        return Validation.isRequired(value);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 50.w),
                        Expanded(
                          child: CustomButton(
                            fixed: true,
                            backgroundColor: AppColor.red,
                            child: Text(
                              'Exit'.tr,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: CustomButton(
                            fixed: true,
                            child: Text('Ok'.tr),
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (keyForm.currentState!.validate()) {
                                var indexEmployee = allDataModel.employees.indexWhere((element) => element.username == controllerUsername.text && element.password == controllerPassword.text && !element.isKitchenUser);
                                if (indexEmployee != -1) {
                                  Get.back(result: allDataModel.employees[indexEmployee]);
                                } else {
                                  Utils.showSnackbar('Incorrect username or password'.tr);
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 50.w),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
    return result;
  }

  static Widget numPadWidget(
    TextEditingController? controller,
    void Function(Function()) setState, {
    bool decimal = true,
    bool card = false,
    Function()? onClear,
    Function()? onSubmit,
    Function()? onExit,
  }) {
    void addNumber(TextEditingController? controller, int number) {
      if (controller != null) {
        if (card) {
          controller.text += '$number';
        } else {
          if (controller.text.contains('.')) {
            var split = controller.text.split('.');
            if (split[1].length < 3) {
              controller.text += '$number';
            }
          } else {
            controller.text += '$number';
            controller.text = '${int.parse(controller.text)}';
          }
        }
      }
    }

    return NumPad(
      controller: controller,
      onClear: onClear,
      onSubmit: onSubmit,
      onExit: onExit ??
          () {
            Get.back();
          },
      onPressed1: () {
        addNumber(controller, 1);
        setState(() {});
      },
      onPressed2: () {
        addNumber(controller, 2);
        setState(() {});
      },
      onPressed3: () {
        addNumber(controller, 3);
        setState(() {});
      },
      onPressed4: () {
        addNumber(controller, 4);
        setState(() {});
      },
      onPressed5: () {
        addNumber(controller, 5);
        setState(() {});
      },
      onPressed6: () {
        addNumber(controller, 6);
        setState(() {});
      },
      onPressed7: () {
        addNumber(controller, 7);
        setState(() {});
      },
      onPressed8: () {
        addNumber(controller, 8);
        setState(() {});
      },
      onPressed9: () {
        addNumber(controller, 9);
        setState(() {});
      },
      onPressedDot: () {
        if (decimal) {
          if (controller != null) {
            if (!controller.text.contains('.')) {
              controller.text += '.';
            }
          }
          setState(() {});
        }
      },
      onPressed0: () {
        addNumber(controller, 0);
        setState(() {});
      },
      onPressedDelete: () {
        if (controller != null) {
          if (controller.text.length > 1 || card) {
            var split = controller.text.split('');
            split.removeLast();
            controller.text = split.join();
          } else {
            controller.text = '0';
          }
        }
        setState(() {});
      },
    );
  }
}
