import 'package:get/get.dart';
import 'package:retail_system/config/utils.dart';
import 'package:retail_system/models/get_pay_in_out_model.dart';
import 'package:retail_system/networks/rest_api.dart';

class HistoryPayInOutController extends GetxController {
  static HistoryPayInOutController get to => Get.isRegistered<HistoryPayInOutController>() ? Get.find<HistoryPayInOutController>() : Get.put(HistoryPayInOutController());

  final data = <GetPayInOutModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    data.value = await RestApi.getPayInOut();
    update();
  }

  deletePayInOut({required GetPayInOutModel model}) async {
    var result = await Utils.showAreYouSureDialog(title: 'Delete pay In / Out'.tr);
    if (result) {
      RestApi.deletePayInOut(model: model);
      data.remove(model);
      update();
    }
  }
}
