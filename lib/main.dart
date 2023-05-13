import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/app_themes.dart';
import 'package:retail_system/config/binding.dart';
import 'package:retail_system/config/app_http_overrides.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/config/translations.dart';
import 'package:retail_system/config/utils.dart';
import 'package:retail_system/controllers/app_controller.dart';
import 'package:retail_system/ui/screens/splash/splash_screen.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Constant.sharedPrefsClient.init();
  HttpOverrides.global = AppHttpOverrides();
  runApp(const RetailSystem());
}

class RetailSystem extends StatefulWidget {
  const RetailSystem({super.key});

  @override
  State<RetailSystem> createState() => _RetailSystemState();
}

class _RetailSystemState extends State<RetailSystem> {
  final AppController _controller = AppController.to;

  @override
  void initState() {
    super.initState();
    Constant.loadAssets();
    Constant.loadColor();
    Utils.packageInfo().then((value) {
      Constant.packageInfo = value;
    });
    Wakelock.enable();
    if (Constant.sharedPrefsClient.language == "") {
      if (Get.deviceLocale == null) {
        Constant.sharedPrefsClient.language = 'ar';
      } else {
        String language = Get.deviceLocale!.languageCode;
        if (language != 'en' && language != 'ar') {
          Constant.sharedPrefsClient.language = 'ar';
        } else {
          Constant.sharedPrefsClient.language = language;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(580, 910),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: Binding(),
        translations: Translation(),
        locale: Locale(Constant.sharedPrefsClient.language),
        fallbackLocale: const Locale('en'),
        theme: AppThemes(context).appThemeData[AppTheme.lightTheme],
        darkTheme: AppThemes(context).appThemeData[AppTheme.darkTheme],
        themeMode: ThemeMode.light,
        showSemanticsDebugger: false,
        home: SplashScreen(),
      ),
    );
  }
}
