import 'package:get/get.dart';

class NetworkLogController extends GetxController {
  static NetworkLogController get to => Get.isRegistered<NetworkLogController>() ? Get.find<NetworkLogController>() : Get.put(NetworkLogController());

}
