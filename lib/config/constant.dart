import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/enum/enum_company_type.dart';
import 'package:retail_system/config/shared_prefs_client.dart';
import 'package:retail_system/models/all_data_model.dart';

class Constant {
  static final kStyleTextDefault = TextStyle(fontWeight: FontWeight.normal, fontSize: 16.sp, color: AppColor.tertiaryColor);
  static final kStyleTextTitle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20.sp, color: AppColor.tertiaryColor);
  static final kStyleTextLarge = TextStyle(fontWeight: FontWeight.bold, fontSize: 28.sp, color: AppColor.tertiaryColor);
  static final kStyleTextTextField = TextStyle(fontWeight: FontWeight.normal, fontSize: 24.sp);
  static final kStyleHeaderTable = TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: AppColor.red);
  static const kStyleTextButton = TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
  static final kStyleTextTable = TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColor.tertiaryColor);
  static final kStyleDataTable = TextStyle(fontSize: 16.sp, color: AppColor.tertiaryColor);
  static final kStyleButtonPayment = TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp);
  static const kStyleLargePrinter = TextStyle(fontWeight: FontWeight.bold, fontSize: 34);
  static const kStyleTitlePrinter = TextStyle(fontWeight: FontWeight.bold, fontSize: 25);
  static const kStyleDataPrinter = TextStyle(fontSize: 20);
  static const kStyleSmallPrinter = TextStyle(fontSize: 16);
  static final kStyleForceQuestion = TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp);

  static PackageInfo packageInfo = PackageInfo(appName: '', packageName: '', version: '', buildNumber: '');
  static AllDataModel allDataModel = AllDataModel.fromJson({});

  static final sharedPrefsClient = SharedPrefsClient();
  static const companyType = EnumCompanyType.falcons;

  static const fractionDigits = 3;
  static const dateFormat = 'yyyy-MM-dd';
  static const timeFormat = 'HH:mm a';

  static String kAssetLogo = "";
  static String kAssetSplash = "";
  static String kAssetBackgroundLogin = "";
  static String kAssetMore = "";
  static String kAssetArrow = "";
  static String kAssetDate = "";
  static String kAssetTime = "";
  static String kAssetHoldItems = "";
  static String kAssetVoidAll = "";
  static String kAssetCreditCard = "";
  static String kAssetSpeedItems = "";
  static String kAssetCash = "";
  static String kAssetArrowBottom = "";
  static String kAssetDelete = "";
  static String kAssetEdit = "";
  static String kAssetSearch = "";
  static String kAssetWait = "";
  static String kAssetSettings = "";
  static String kAssetReservation = "";
  static String kAssetReplacing = "";
  static String kAssetReturnItem = "";
  static String kAssetDeleteTheLast = "";
  static String kAssetReceipts = "";
  static String kAssetPayments = "";
  static String kAssetOpenCash = "";
  static String kAssetCloseCash = "";
  static String kAssetEndCash = "";
  static String kAssetReprintInvoice = "";
  static String kAssetReplaceItem = "";
  static String kAssetItemInfo = "";
  static String kAssetSave = "";
  static String kAssetSaveInvoice = "";
  static String kAssetPaymentMethods = "";
  static String kAssetCustomerPayments = "";
  static String kAssetLogout = "";
  static String kAssetsWelcome = "";
  static String kAssetExit = "";
  static String kAssetPhoto = "";

  static loadAssets() {
    switch (companyType) {
      case EnumCompanyType.falcons:
        kAssetLogo = "assets/images/logo.png";
        kAssetSplash = "assets/images/splash.png";
        kAssetBackgroundLogin = "assets/images/background_login.png";
        kAssetMore = "assets/images/more.svg";
        kAssetArrow = "assets/images/arrow.svg";
        kAssetDate = "assets/images/date.svg";
        kAssetTime = "assets/images/time.svg";
        kAssetHoldItems = "assets/images/hold_items.svg";
        kAssetVoidAll = "assets/images/void_all.svg";
        kAssetCreditCard = "assets/images/credit_card.svg";
        kAssetSpeedItems = "assets/images/speed_items.svg";
        kAssetCash = "assets/images/cash.svg";
        kAssetArrowBottom = "assets/images/arrow_bottom.svg";
        kAssetDelete = "assets/images/delete.svg";
        kAssetEdit = "assets/images/edit.svg";
        kAssetSearch = "assets/images/search.svg";
        kAssetWait = "assets/images/wait.svg";
        kAssetSettings = "assets/images/settings.svg";
        kAssetReservation = "assets/images/reservation.svg";
        kAssetReplacing = "assets/images/replacing.svg";
        kAssetReturnItem = "assets/images/return_item.svg";
        kAssetDeleteTheLast = "assets/images/delete_the_last.svg";
        kAssetReceipts = "assets/images/receipts.svg";
        kAssetPayments = "assets/images/payments.svg";
        kAssetOpenCash = "assets/images/open_cash.svg";
        kAssetCloseCash = "assets/images/close_cash.svg";
        kAssetEndCash = "assets/images/end_cash.svg";
        kAssetReprintInvoice = "assets/images/reprint_invoice.svg";
        kAssetReplaceItem = "assets/images/replace_item.svg";
        kAssetItemInfo = "assets/images/item_info.svg";
        kAssetSave = "assets/images/save.svg";
        kAssetSaveInvoice = "assets/images/save_invoice.svg";
        kAssetPaymentMethods = "assets/images/payment_methods.svg";
        kAssetCustomerPayments = "assets/images/customer_payments.svg";
        kAssetLogout = "assets/images/logout.svg";
        kAssetsWelcome = "assets/images/welcome.png";
        kAssetExit = "assets/images/exit.svg";
        kAssetPhoto = "assets/images/photo.svg";
        break;
    }
  }

  static loadColor() {
    switch (companyType) {
      case EnumCompanyType.falcons:
        AppColor.primaryColor = const MaterialColor(
          0xFF31AFB4,
          <int, Color>{
            50: Color(0xFF31AFB4),
            100: Color(0xFF31AFB4),
            200: Color(0xFF31AFB4),
            300: Color(0xFF31AFB4),
            350: Color(0xFF31AFB4),
            400: Color(0xFF31AFB4),
            500: Color(0xFF31AFB4),
            600: Color(0xFF31AFB4),
            700: Color(0xFF31AFB4),
            800: Color(0xFF31AFB4),
            850: Color(0xFF31AFB4),
            900: Color(0xFF31AFB4),
          },
        );
        AppColor.accentColor = const MaterialColor(
          0xFFC6E8EA,
          <int, Color>{
            50: Color(0xFFC6E8EA),
            100: Color(0xFFC6E8EA),
            200: Color(0xFFC6E8EA),
            300: Color(0xFFC6E8EA),
            350: Color(0xFFC6E8EA),
            400: Color(0xFFC6E8EA),
            500: Color(0xFFC6E8EA),
            600: Color(0xFFC6E8EA),
            700: Color(0xFFC6E8EA),
            800: Color(0xFFC6E8EA),
            850: Color(0xFFC6E8EA),
            900: Color(0xFFC6E8EA),
          },
        );
        AppColor.tertiaryColor = const MaterialColor(
          0xFF1E3354,
          <int, Color>{
            50: Color(0xFF1E3354),
            100: Color(0xFF1E3354),
            200: Color(0xFF1E3354),
            300: Color(0xFF1E3354),
            350: Color(0xFF1E3354),
            400: Color(0xFF1E3354),
            500: Color(0xFF1E3354),
            600: Color(0xFF1E3354),
            700: Color(0xFF1E3354),
            800: Color(0xFF1E3354),
            850: Color(0xFF1E3354),
            900: Color(0xFF1E3354),
          },
        );
        break;
    }
  }
}
