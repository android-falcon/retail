import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/constant.dart';

class ConfigController extends GetxController {
  static ConfigController get to => Get.isRegistered<ConfigController>() ? Get.find<ConfigController>() : Get.put(ConfigController());

  final TextEditingController controllerBaseUrl = TextEditingController(text: Constant.sharedPrefsClient.baseUrl);
  final TextEditingController controllerPosNo = TextEditingController(text: '${Constant.sharedPrefsClient.posNo}');
  final TextEditingController controllerCashNo = TextEditingController(text: '${Constant.sharedPrefsClient.cashNo}');
  final TextEditingController controllerStoreNo = TextEditingController(text: '${Constant.sharedPrefsClient.storeNo}');
  final TextEditingController controllerInVocNo = TextEditingController(text: '${Constant.sharedPrefsClient.inVocNo}');
  final TextEditingController controllerReturnVocNo = TextEditingController(text: '${Constant.sharedPrefsClient.returnVocNo}');
  final TextEditingController controllerOutVocNo = TextEditingController(text: '${Constant.sharedPrefsClient.payInOutNo}');

  save() {
    Constant.sharedPrefsClient.clearData();
    Constant.sharedPrefsClient.baseUrl = controllerBaseUrl.text;
    Constant.sharedPrefsClient.posNo = controllerPosNo.text.isEmpty ? 0 : int.parse(controllerPosNo.text);
    Constant.sharedPrefsClient.cashNo = controllerCashNo.text.isEmpty ? 0 : int.parse(controllerCashNo.text);
    Constant.sharedPrefsClient.storeNo = controllerStoreNo.text.isEmpty ? 0 : int.parse(controllerStoreNo.text);
    Constant.sharedPrefsClient.inVocNo = controllerInVocNo.text.isEmpty ? 0 : int.parse(controllerInVocNo.text);
    Constant.sharedPrefsClient.returnVocNo = controllerReturnVocNo.text.isEmpty ? 0 : int.parse(controllerReturnVocNo.text);
    Constant.sharedPrefsClient.payInOutNo = controllerOutVocNo.text.isEmpty ? 0 : int.parse(controllerOutVocNo.text);
    Get.back();
  }

  cancel() {
    Get.back();
  }
}
