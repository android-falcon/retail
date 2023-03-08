import 'package:get/get.dart';
import 'package:retail_system/controllers/app_controller.dart';
import 'package:retail_system/controllers/config_controller.dart';
import 'package:retail_system/controllers/history_pay_in_out_controller.dart';
import 'package:retail_system/controllers/home_controller.dart';
import 'package:retail_system/controllers/login_controller.dart';
import 'package:retail_system/controllers/more_controller.dart';
import 'package:retail_system/controllers/network_log_controller.dart';
import 'package:retail_system/controllers/refund_controller.dart';
import 'package:retail_system/controllers/report_controller.dart';
import 'package:retail_system/controllers/search_item_controller.dart';

class Binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AppController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => NetworkLogController());
    Get.lazyPut(() => ConfigController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MoreController());
    Get.lazyPut(() => ReportController());
    Get.lazyPut(() => HistoryPayInOutController());
    Get.lazyPut(() => RefundController());
    Get.lazyPut(() => SearchItemController());
  }
}