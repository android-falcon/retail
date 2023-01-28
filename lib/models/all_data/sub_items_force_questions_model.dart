// To parse this JSON data, do
//
//     final itemSubItemsModel = itemSubItemsModelFromJson(jsonString);

import 'dart:convert';

import 'package:retail_system/models/all_data/force_question_sub_item_model.dart';
import 'package:retail_system/models/all_data/item_model.dart';

SubItemsForceQuestionsModel subItemsForceQuestionsModelFromJson(String str) => SubItemsForceQuestionsModel.fromJson(json.decode(str));

String subItemsForceQuestionsModelToJson(SubItemsForceQuestionsModel data) => json.encode(data.toJson());

class SubItemsForceQuestionsModel {
  SubItemsForceQuestionsModel({
    required this.subItemsForceQuestion,
    required this.items,
  });

  ForceQuestionSubItemModel subItemsForceQuestion;
  List<ItemModel> items;

  factory SubItemsForceQuestionsModel.fromJson(Map<String, dynamic> json) => SubItemsForceQuestionsModel(
        subItemsForceQuestion: ForceQuestionSubItemModel.fromJson(json["subItemsForceQuestion"] ?? {}),
        items: json["subItemList"] == null ? [] : List<ItemModel>.from(json["subItemList"].map((e) => ItemModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        "subItemsForceQuestion": subItemsForceQuestion.toJson(),
        "subItemList": List<dynamic>.from(items.map((e) => e.toJson())),
      };
}
