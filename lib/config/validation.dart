import 'package:get/get.dart';
import 'package:retail_system/config/enum/enum_discount_type.dart';
import 'package:retail_system/config/utils.dart';

class Validation {
  static String? qty(value, {double? minQty, double? maxQty}) {
    if (Utils.isEmpty(value)) {
      return 'This field is required'.tr;
    } else if (minQty != null && double.parse(value) < minQty) {
      return '${'Quantity must be greater than or equal to'.tr} $minQty';
    } else if (maxQty != null && double.parse(value) > maxQty) {
      return '${'Quantity must be less than or equal to'.tr} $maxQty';
    }
    return null;
  }

  static String? discount(type, value, price) {
    if (Utils.isEmpty(value)) {
      return 'This field is required'.tr;
    } else {
      if (EnumDiscountType.value == type) {
        if (double.parse(value) > price) {
          return 'The discount cannot be greater than the price of an item'.tr;
        }
      } else {
        if (double.parse(value) > 100) {
          return 'Discount cannot be more than %100'.tr;
        }
      }
    }
    return null;
  }

  static String? priceChange(value) {
    if (double.parse(value) < 0) {
      return 'The item price cannot be less than zero'.tr;
    }
    return null;
  }

  static String? isEmail(String? email) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    if (Utils.isEmpty(email)) {
      return "This is required".tr;
    } else if (!regExp.hasMatch(email!)) {
      return "Please enter valid email".tr;
    }
    return null;
  }

  static String? isPassword(String? password) {
    if (Utils.isEmpty(password)) {
      return "This is required".tr;
    } else if (password!.length < 6) {
      return "Please enter valid password".tr;
    }
    return null;
  }

  static String? isConfirmPassword(String? password, String? confirmPassword) {
    if (password != confirmPassword) {
      return "Password does not match".tr;
    }
    return null;
  }

  static String? isRequired(String? text) {
    if (Utils.isEmpty(text)) {
      return "This is required".tr;
    }
    return null;
  }

  static String? isPhone(String? text) {
    try {
      // RegExp regExp = RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)');
      if (Utils.isEmpty(text)) {
        return "This is required".tr;
      }
      // else if (!regExp.hasMatch(text!)) {
      //   return "Please enter valid phone".tr;
      // }
      return null;
    } catch (e) {
      return "Please enter valid phone".tr;
    }
  }
}
