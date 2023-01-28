import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to => Get.isRegistered<AppController>() ? Get.find<AppController>() : Get.put(AppController());

}
