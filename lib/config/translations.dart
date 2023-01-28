import 'package:get/get.dart';
import 'package:retail_system/config/en.dart';
import 'package:retail_system/config/ar.dart';

class Translation extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en' : en,
    'ar' : ar,
  };
}