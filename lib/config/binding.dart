import 'package:get/get.dart';
import 'package:retail_system/controllers/app_controller.dart';
import 'package:retail_system/controllers/config_controller.dart';
import 'package:retail_system/controllers/home_controller.dart';
import 'package:retail_system/controllers/login_controller.dart';
import 'package:retail_system/controllers/network_log_controller.dart';

class Binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AppController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => NetworkLogController());
    Get.lazyPut(() => ConfigController());
    Get.lazyPut(() => HomeController());
  }
}