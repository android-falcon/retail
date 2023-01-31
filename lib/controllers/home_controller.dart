import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

  final TextEditingController controllerSearch = TextEditingController();

  addItem() {}

  deleteItem() {}

  editItem() {}
}
