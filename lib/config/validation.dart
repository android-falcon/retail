import 'package:get/get.dart';
import 'package:retail_system/config/utils.dart';

class Validation {
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
