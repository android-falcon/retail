import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/models/all_data/company_config_model.dart';
import 'package:retail_system/networks/rest_api.dart';
import 'package:retail_system/config/utils.dart';
import 'package:retail_system/ui/screens/config/config_screen.dart';
import 'package:retail_system/ui/screens/home/home_screen.dart';
import 'package:retail_system/ui/screens/network_log/network_log_screen.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.isRegistered<LoginController>() ? Get.find<LoginController>() : Get.put(LoginController());

  final formKey = GlobalKey<FormState>();
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      RestApi.getData();
      RestApi.getCashLastSerials();
    });
  }

  signIn() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (controllerUsername.text.isEmpty && controllerPassword.text == "Falcons@admin") {
      controllerPassword.text = '';
      Get.to(() => ConfigScreen())!.then((value) {
        RestApi.restDio.options.baseUrl = Constant.sharedPrefsClient.baseUrl;
        RestApi.getData();
        RestApi.getCashLastSerials();
      });
    } else if (controllerUsername.text.isEmpty && controllerPassword.text == "NetworkLog@admin") {
      controllerPassword.text = '';
      Get.to(() => NetworkLogScreen());
    } else if (formKey.currentState!.validate()) {
      var indexEmployee = Constant.allDataModel.employees.indexWhere((element) => element.username == controllerUsername.text && element.password == controllerPassword.text && !element.isKitchenUser);
      if (indexEmployee != -1) {
        Constant.sharedPrefsClient.employee = Constant.allDataModel.employees[indexEmployee];
        Constant.sharedPrefsClient.dailyClose = Constant.allDataModel.posClose;
        if (Constant.allDataModel.companyConfig.isEmpty) {
          Constant.allDataModel.companyConfig.add(CompanyConfigModel.fromJson({}));
        }
        var indexPointOfSales = Constant.allDataModel.pointOfSalesModel.indexWhere((element) => element.posNo == Constant.sharedPrefsClient.posNo);
        if (indexPointOfSales != -1) {
          Constant.sharedPrefsClient.orderNo = Constant.allDataModel.pointOfSalesModel[indexPointOfSales].orderNo;
        }
        Get.offAll(() => HomeScreen());
      } else {
        Utils.showSnackbar('Login Failed'.tr, 'Incorrect username or password'.tr);
      }
    }
  }
}
