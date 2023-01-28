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
  await sharedPrefsClient.init();
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
    loadAssets();
    loadColor();
    Utils.packageInfo().then((value) {
      packageInfo = value;
    });
    Wakelock.enable();
    if (sharedPrefsClient.language == "") {
      if (Get.deviceLocale == null) {
        sharedPrefsClient.language = 'ar';
      } else {
        String language = Get.deviceLocale!.languageCode;
        if (language != 'en' && language != 'ar') {
          sharedPrefsClient.language = 'ar';
        } else {
          sharedPrefsClient.language = language;
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
        locale: Locale(sharedPrefsClient.language),
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
