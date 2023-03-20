import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/models/all_data/item_model.dart';

class SearchItemController extends GetxController {
  static SearchItemController get to => Get.isRegistered<SearchItemController>() ? Get.find<SearchItemController>() : Get.put(SearchItemController());

  final controllerItemCode = TextEditingController();
  final controllerItemName = TextEditingController();
  final controllerItemNameE = TextEditingController();

  final checkItemCode = false.obs;
  final checkItemName = false.obs;
  final checkItemNameE = false.obs;
  final checkGroup = false.obs;
  final checkUnit = false.obs;
  final checkMinaColor = false.obs;

  final dropDownSelectGroup = Rxn<int>();
  final dropDownSelectUnit = Rxn<int>();
  final dropDownSelectMinaColor = Rxn<int>();

  final resultItems = <ItemModel>[].obs;

  searchItems() {
    resultItems.value = allDataModel.items.where((element) {
      if(!checkItemCode.value && !checkItemName.value && !checkItemNameE.value && !checkGroup.value){
        return true;
      }
      bool resultSearch = false;
      if (checkItemCode.value) {
        if (element.itemBarcodes.firstWhereOrNull((element) => element.barcode == controllerItemCode.text) != null) {
          resultSearch = true;
        } else {
          return false;
        }
      }
      if (checkItemName.value) {
        if (element.menuName.contains(controllerItemName.text)) {
          resultSearch = true;
        } else {
          return false;
        }
      }
      if (checkItemNameE.value) {
        if (element.menuName.contains(controllerItemNameE.text)) {
          resultSearch = true;
        } else {
          return false;
        }
      }
      if (checkGroup.value) {
        if (dropDownSelectGroup.value != null && element.category.id == dropDownSelectGroup.value) {
          resultSearch = true;
        } else {
          return false;
        }
      }
      // if (checkUnit.value && dropDownSelectUnit.value != null) {
      //   if (element.unit.id == dropDownSelectUnit.value) {
      //     return true;
      //   }
      // }
      // if (checkMinaColor.value && dropDownSelectMinaColor.value != null) {
      //   if (element.unit.id == dropDownSelectMinaColor.value) {
      //     return true;
      //   }
      // }
      return resultSearch;
    }).toList();
    update();
  }
}
