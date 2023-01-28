import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:retail_system/config/app_color.dart';

class AppThemes {
  late Map<AppTheme, ThemeData> appThemeData;

  AppThemes(BuildContext context) {
    appThemeData = {
      AppTheme.lightTheme: ThemeData(
        toggleableActiveColor: AppColor.primaryColor.shade700,
        brightness: Brightness.light,
        primarySwatch: AppColor.primaryColor,
        primaryColor: AppColor.primaryColor,
        // fontFamily: fontFamily,
        cardColor: Colors.white,
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColor.primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColor.primaryColor).copyWith(
          secondary: AppColor.primaryColor.shade700,
          brightness: Brightness.light,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
            foregroundColor: MaterialStateProperty.resolveWith((state) => Colors.black),
            overlayColor: MaterialStateProperty.resolveWith((state) => Colors.black.withOpacity(0.1)),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColor.primaryColor,
          selectionHandleColor: AppColor.primaryColor.shade700,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColor.grayLight),
          labelStyle: const TextStyle(color: AppColor.textFieldLight),
          iconColor: AppColor.textFieldLight,

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColor.textFieldBorderLight, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColor.textFieldBorderLight, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColor.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColor.red, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColor.textFieldBorderLight, width: 1),
          ),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 16.sp, color: Colors.black),
          bodyText2: TextStyle(fontSize: 14.sp, color: Colors.black),
          headline1: TextStyle(fontSize: 96.sp, color: Colors.black),
          headline2: TextStyle(fontSize: 60.sp, color: Colors.black),
          headline3: TextStyle(fontSize: 48.sp, color: Colors.black),
          headline4: TextStyle(fontSize: 34.sp, color: Colors.black),
          headline5: TextStyle(fontSize: 24.sp, color: Colors.black),
          headline6: TextStyle(fontSize: 20.sp, color: Colors.black),
          subtitle1: TextStyle(fontSize: 16.sp, color: Colors.black),
          subtitle2:  TextStyle(fontSize: 14.sp, color: Colors.black),
          caption:  TextStyle(fontSize: 12.sp, color: Colors.black),
          overline:  TextStyle(fontSize: 10.sp, color: Colors.black),
          button: Theme.of(context).textTheme.button!.copyWith(fontSize: 16.sp),

        ),
      ),
      AppTheme.darkTheme: ThemeData(
        toggleableActiveColor: AppColor.primaryColor.shade700,
        brightness: Brightness.dark,
        primarySwatch: AppColor.primaryColor,
        primaryColor: AppColor.primaryColor,
        // fontFamily: fontFamily,
        cardColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xFF212121),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF181818),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: const Color(0xffC5C4D8),
          showUnselectedLabels: true,
          selectedItemColor: AppColor.primaryColor,
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColor.primaryColor).copyWith(
          secondary: AppColor.primaryColor.shade700,
          brightness: Brightness.dark,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
            foregroundColor: MaterialStateProperty.resolveWith((state) => Colors.black),
            overlayColor: MaterialStateProperty.resolveWith((state) => Colors.black.withOpacity(0.1)),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColor.primaryColor,
          selectionHandleColor: AppColor.primaryColor.shade700,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppColor.textFieldDark),
          labelStyle: const TextStyle(color: AppColor.textFieldDark),
          iconColor: AppColor.textFieldDark,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColor.textFieldBorderDark, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColor.textFieldBorderDark, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColor.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColor.red, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColor.textFieldBorderDark, width: 1),
          ),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 16.sp, color: Colors.white),
          bodyText2: TextStyle(fontSize: 14.sp, color: Colors.white),
          headline1: TextStyle(fontSize: 96.sp, color: Colors.white),
          headline2: TextStyle(fontSize: 60.sp, color: Colors.white),
          headline3: TextStyle(fontSize: 48.sp, color: Colors.white),
          headline4: TextStyle(fontSize: 34.sp, color: Colors.white),
          headline5: TextStyle(fontSize: 24.sp, color: Colors.white),
          headline6: TextStyle(fontSize: 20.sp, color: Colors.white),
          subtitle1: TextStyle(fontSize: 16.sp, color: Colors.white),
          subtitle2:  TextStyle(fontSize: 14.sp, color: Colors.white),
          caption:  TextStyle(fontSize: 12.sp, color: Colors.white),
          overline:  TextStyle(fontSize: 10.sp, color: Colors.white),
          button: Theme.of(context).textTheme.button!.copyWith(fontSize: 16.sp),

        ),

      ),
    };
  }
}

enum AppTheme { lightTheme, darkTheme }
