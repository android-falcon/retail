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
    SchedulerBinding.instance.addPostFrameCallback((_) => RestApi.getData());
  }

  signIn() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (controllerUsername.text.isEmpty && controllerPassword.text == "Falcons@admin") {
      controllerPassword.text = '';
      Get.to(() => ConfigScreen())!.then((value) {
        RestApi.restDio.options.baseUrl = sharedPrefsClient.baseUrl;
        RestApi.getData();
      });
    } else if (controllerUsername.text.isEmpty && controllerPassword.text == "NetworkLog@admin") {
      controllerPassword.text = '';
      Get.to(() => NetworkLogScreen());
    } else if (formKey.currentState!.validate()) {
      var indexEmployee = allDataModel.employees.indexWhere((element) => element.username == controllerUsername.text && element.password == controllerPassword.text && !element.isKitchenUser);
      if (indexEmployee != -1) {
        sharedPrefsClient.employee = allDataModel.employees[indexEmployee];
        sharedPrefsClient.dailyClose = allDataModel.posClose;
        if (allDataModel.companyConfig.isEmpty) {
          allDataModel.companyConfig.add(CompanyConfigModel.fromJson({}));
        }
        var indexPointOfSales = allDataModel.pointOfSalesModel.indexWhere((element) => element.posNo == sharedPrefsClient.posNo);
        if (indexPointOfSales != -1) {
          sharedPrefsClient.orderNo = allDataModel.pointOfSalesModel[indexPointOfSales].orderNo;
        }
        Get.offAll(() => HomeScreen());
      } else {
        Utils.showSnackbar('Login Failed'.tr, 'Incorrect username or password'.tr);
      }
    }
  }
}
