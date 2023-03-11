import 'package:get_storage/get_storage.dart';
import 'package:retail_system/config/sorting_model.dart';
import 'package:retail_system/models/all_data/employee_model.dart';
import 'package:retail_system/models/all_data_model.dart';
import 'package:retail_system/models/cart_model.dart';
import 'package:retail_system/models/last_invoice.dart';

class SharedPrefsClient {
  static const String _storageName = "MyPref";

  static final GetStorage _storage = GetStorage(_storageName);

  init() async {
    await GetStorage.init(_storageName);
  }

  void clearData() {
    isLogin = false;
    employee = null;
    allData = null;
    baseUrl = '';
    inVocNo = 1;
    payInOutNo = 1;
    posNo = 0;
    cashNo = 0;
    storeNo = 0;
  }

  String get deviceToken => _storage.read(keyDeviceToken) ?? "";

  set deviceToken(String value) {
    _storage.write(keyDeviceToken, value);
  }

  bool get isLogin => _storage.read(keyIsLogin) ?? false;

  set isLogin(bool value) {
    _storage.write(keyIsLogin, value);
  }

  String get language => _storage.read(keyLanguage) ?? "";

  set language(String value) {
    _storage.write(keyLanguage, value);
  }

  bool get isGMS => _storage.read(keyIsGMS) ?? true;

  set isGMS(bool value) {
    _storage.write(keyIsGMS, value);
  }

  List<CartModel> get park => List<CartModel>.from((_storage.read(keyPark) ?? []).map((e) => CartModel.fromJson(e)));

  set park(List<CartModel> value) {
    _storage.write(keyPark, List<dynamic>.from(value.map((e) => e.toJson())));
  }

  EmployeeModel get employee => EmployeeModel.fromJson(_storage.read(keyEmployee) ?? {});

  set employee(EmployeeModel? value) {
    _storage.write(keyEmployee, value?.toJson());
  }

  AllDataModel get allData => AllDataModel.fromJson(_storage.read(keyAllData) ?? {});

  set allData(AllDataModel? value) {
    _storage.write(keyAllData, value?.toJson());
  }

  DateTime get dailyClose => DateTime.tryParse(_storage.read(keyDailyClose) ?? '') ?? DateTime.now();

  set dailyClose(DateTime value) {
    _storage.write(keyDailyClose, value.toIso8601String());
  }

  SortingModel get sorting => SortingModel.fromJson(_storage.read(keySorting) ?? {});

  set sorting(SortingModel? value) {
    _storage.write(keySorting, value?.toJson());
  }

  String get baseUrl => _storage.read(keyBaseUrl) ?? "";

  set baseUrl(String value) {
    _storage.write(keyBaseUrl, value);
  }

  int get orderNo => _storage.read(keyOrderNo) ?? 1;

  set orderNo(int value) {
    _storage.write(keyOrderNo, value);
  }

  int get inVocNo => _storage.read(keyInVocNo) ?? 1;

  set inVocNo(int value) {
    _storage.write(keyInVocNo, value);
  }

  int get payInOutNo => _storage.read(keyPayInOutNoNo) ?? 1;

  set payInOutNo(int value) {
    _storage.write(keyPayInOutNoNo, value);
  }

  int get posNo => _storage.read(keyPosNo) ?? 0;

  set posNo(int value) {
    _storage.write(keyPosNo, value);
  }

  int get cashNo => _storage.read(keyCashNo) ?? 0;

  set cashNo(int value) {
    _storage.write(keyCashNo, value);
  }

  int get storeNo => _storage.read(keyStoreNo) ?? 0;

  set storeNo(int value) {
    _storage.write(keyStoreNo, value);
  }

  LastInvoice get lastInvoice => LastInvoice.fromJson(_storage.read(keyLastInvoice) ?? {});

  set lastInvoice(LastInvoice value) {
    _storage.write(keyLastInvoice, value.toJson());
  }
}

const String keyDeviceToken = "key_device_token";
const String keyIsLogin = "key_is_login";
const String keyLanguage = "key_language";
const String keyIsGMS = "key_is_gms";
const String keyPark = "key_park";
const String keyEmployee = "key_employee";
const String keyAllData = "key_all_data";
const String keyDailyClose = "key_daily_close";
const String keySorting = "key_sorting";
const String keyBaseUrl = "key_base_url";
const String keyInVocNo = "key_in_voc_no";
const String keyOrderNo = "key_order_no";
const String keyPayInOutNoNo = "key_pay_in_out_no";
const String keyPosNo = "key_pos_no";
const String keyCashNo = "key_cash_no";
const String keyStoreNo = "key_store_no";
const String keyLastInvoice = "key_last_invoice";
