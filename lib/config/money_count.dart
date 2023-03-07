import 'package:flutter/material.dart';
import 'package:retail_system/config/constant.dart';

class MoneyCount {
  String name;
  String icon;
  double value;
  double rate;
  TextEditingController qty;

  MoneyCount({
    required this.name,
    required this.qty,
    this.icon = '',
    this.value = 0,
    this.rate = 1,
  });

  static init() {
    moneyCount = allDataModel.currencies
        .map((e) => MoneyCount(
              name: '${e.currVal} ${e.currName}',
              value: e.currVal,
              rate: e.currRate,
              icon: e.currPic,
              qty: TextEditingController(text: '0'),
            ))
        .toList();
  }

  static clear() {
    moneyCount = [];
  }

  static List<MoneyCount> moneyCount = [];
}
