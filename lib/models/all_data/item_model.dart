// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

import 'dart:convert';

import 'package:retail_system/models/all_data/category_model.dart';
import 'package:retail_system/models/all_data/family_model.dart';

List<ItemModel> itemModelFromJson(String str) => List<ItemModel>.from(json.decode(str).map((x) => ItemModel.fromJson(x)));

String itemModelToJson(List<ItemModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemModel {
  ItemModel({
    required this.id,
    required this.itemBarcode,
    required this.category,
    required this.menuName,
    required this.family,
    required this.price,
    this.companyPrice = 0,
    required this.inMealPrice,
    required this.taxTypeId,
    required this.taxPercent,
    required this.secondaryName,
    required this.kitchenAlias,
    required this.itemStatus,
    required this.itemType,
    required this.description,
    required this.unit,
    required this.unitId,
    required this.wastagePercent,
    required this.discountAvailable,
    required this.pointAvailable,
    required this.openPrice,
    required this.sortOrder,
    required this.showInMenu,
    required this.itemPicture,
    required this.isSpeedItem,
    required this.itemBarcodes,
  });

  int id;
  String itemBarcode;
  CategoryModel category;
  String menuName;
  FamilyModel family;
  double price;
  double companyPrice;
  double inMealPrice;
  int taxTypeId;
  TaxPercent taxPercent;
  String secondaryName;
  String kitchenAlias;
  int itemStatus;
  dynamic itemType;
  String description;
  dynamic unit;
  int unitId;
  dynamic wastagePercent;
  int discountAvailable;
  String pointAvailable;
  int openPrice;
  int sortOrder;
  int showInMenu;
  String itemPicture;
  int isSpeedItem;
  List<ItemBarcode> itemBarcodes;

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: (json['item'] == null ? json["Id"] : json['item']["Id"]) ?? 0,
        itemBarcode: (json['item'] == null ? json["ITEM_BARCODE"] : json['item']["ITEM_BARCODE"])  ?? "",
        category: CategoryModel.fromJson((json['item'] == null ? json["Category"] : json['item']["Category"])  ?? {}),
        menuName: (json['item'] == null ? json["MENU_NAME"] : json['item']["MENU_NAME"])  ?? "",
        family: FamilyModel.fromJson((json['item'] == null ? json["Family"] : json['item']["Family"])  ?? {}),
        price:(json['item'] == null ? json["PRICE"]?.toDouble() : json['item']["PRICE"]?.toDouble()) ?? 0,
        inMealPrice:(json['item'] == null ? json["InMealPrice"] : json['item']["InMealPrice"]) ?.toDouble() ?? 0,
        taxTypeId:(json['item'] == null ? json["TaxTypeId"] : json['item']["TaxTypeId"])  ?? 0,
        taxPercent: TaxPercent.fromJson((json['item'] == null ? json["TaxPerc"] : json['item']["TaxPerc"])  ?? {}),
        secondaryName:(json['item'] == null ? json["SECONDARY_NAME"] : json['item']["SECONDARY_NAME"])  ?? "",
        kitchenAlias:(json['item'] == null ? json["KITCHEN_ALIAS"] : json['item']["KITCHEN_ALIAS"])  ?? "",
        itemStatus:(json['item'] == null ? json["Item_STATUS"] : json['item']["Item_STATUS"])  ?? 0,
        itemType:(json['item'] == null ? json["ITEM_TYPE"] : json['item']["ITEM_TYPE"]) ,
        description:(json['item'] == null ? json["DESCRIPTION"] : json['item']["DESCRIPTION"])  ?? "",
        wastagePercent:(json['item'] == null ? json["WASTAGE_PERCENT"] : json['item']["WASTAGE_PERCENT"]) ,
        discountAvailable:(json['item'] == null ? json["DISCOUNT_AVAILABLE"] : json['item']["DISCOUNT_AVAILABLE"])  ?? 0,
        pointAvailable:(json['item'] == null ? json["POINT_AVAILABLE"] : json['item']["POINT_AVAILABLE"])  ?? "",
        openPrice:(json['item'] == null ? json["OPEN_PRICE"] : json['item']["OPEN_PRICE"])  ?? 0,
        sortOrder:(json['item'] == null ? json["SortOrder"] : json['item']["SortOrder"])  ?? 0,
        showInMenu:(json['item'] == null ? json["SHOW_IN_MENU"] : json['item']["SHOW_IN_MENU"])  ?? 0,
        itemPicture:(json['item'] == null ? json["ITEM_PICTURE"] : json['item']["ITEM_PICTURE"])  ?? "",
        unit:(json['item'] == null ? json["Unit"] : json['item']["Unit"]) ,
        unitId:(json['item'] == null ? json["UnitId"] : json['item']["UnitId"])  ?? 0,
        isSpeedItem:(json['item'] == null ? json["IsSpeedItem"] : json['item']["IsSpeedItem"]) ?? 0,
        itemBarcodes: json["ItemBarcodes"] == null ? [] : List<ItemBarcode>.from(json["ItemBarcodes"].map((x) => ItemBarcode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "item": {
          "Id": id,
          "ITEM_BARCODE": itemBarcode,
          "Category": category.toJson(),
          "MENU_NAME": menuName,
          "Family": family.toJson(),
          "PRICE": price,
          "InMealPrice": inMealPrice,
          "TaxTypeId": taxTypeId,
          "TaxPerc": taxPercent.toJson(),
          "SECONDARY_NAME": secondaryName,
          "KITCHEN_ALIAS": kitchenAlias,
          "Item_STATUS": itemStatus,
          "ITEM_TYPE": itemType,
          "DESCRIPTION": description,
          "WASTAGE_PERCENT": wastagePercent,
          "DISCOUNT_AVAILABLE": discountAvailable,
          "POINT_AVAILABLE": pointAvailable,
          "OPEN_PRICE": openPrice,
          "SortOrder": sortOrder,
          "SHOW_IN_MENU": showInMenu,
          "ITEM_PICTURE": itemPicture,
          "Unit": unit,
          "UnitId": unitId,
          "IsSpeedItem": isSpeedItem,
        },
        "ItemBarcodes": List<dynamic>.from(itemBarcodes.map((x) => x.toJson())),
      };
}

class TaxPercent {
  TaxPercent({
    required this.id,
    required this.percent,
  });

  int id;
  double percent;

  factory TaxPercent.fromJson(Map<String, dynamic> json) => TaxPercent(
        id: json["Id"] ?? 0,
        percent: json["TaxPercent"]?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "TaxPercent": percent,
      };
}

class ItemBarcode {
  ItemBarcode({
    required this.itemId,
    required this.barcode,
  });

  int itemId;
  String barcode;

  factory ItemBarcode.fromJson(Map<String, dynamic> json) => ItemBarcode(
        itemId: json["ItemId"] ?? 0,
        barcode: json["Barcode"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ItemId": itemId,
        "Barcode": barcode,
      };
}
