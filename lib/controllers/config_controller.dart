import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/constant.dart';

class ConfigController extends GetxController {
  static ConfigController get to => Get.isRegistered<ConfigController>() ? Get.find<ConfigController>() : Get.put(ConfigController());

  final TextEditingController controllerBaseUrl = TextEditingController(text: sharedPrefsClient.baseUrl);
  final TextEditingController controllerPosNo = TextEditingController(text: '${sharedPrefsClient.posNo}');
  final TextEditingController controllerCashNo = TextEditingController(text: '${sharedPrefsClient.cashNo}');
  final TextEditingController controllerStoreNo = TextEditingController(text: '${sharedPrefsClient.storeNo}');
  final TextEditingController controllerInVocNo = TextEditingController(text: '${sharedPrefsClient.inVocNo}');
  final TextEditingController controllerReturnVocNo = TextEditingController(text: '${sharedPrefsClient.returnVocNo}');
  final TextEditingController controllerOutVocNo = TextEditingController(text: '${sharedPrefsClient.payInOutNo}');

  save() {
    sharedPrefsClient.clearData();
    sharedPrefsClient.baseUrl = controllerBaseUrl.text;
    sharedPrefsClient.posNo = controllerPosNo.text.isEmpty ? 0 : int.parse(controllerPosNo.text);
    sharedPrefsClient.cashNo = controllerCashNo.text.isEmpty ? 0 : int.parse(controllerCashNo.text);
    sharedPrefsClient.storeNo = controllerStoreNo.text.isEmpty ? 0 : int.parse(controllerStoreNo.text);
    sharedPrefsClient.inVocNo = controllerInVocNo.text.isEmpty ? 0 : int.parse(controllerInVocNo.text);
    sharedPrefsClient.returnVocNo = controllerReturnVocNo.text.isEmpty ? 0 : int.parse(controllerReturnVocNo.text);
    sharedPrefsClient.payInOutNo = controllerOutVocNo.text.isEmpty ? 0 : int.parse(controllerOutVocNo.text);
    Get.back();
  }

  cancel() {
    Get.back();
  }
}
