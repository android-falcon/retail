import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/config/enum/enum_invoice_kind.dart';
import 'package:retail_system/config/utils.dart';
import 'package:retail_system/database/network_table.dart';
import 'package:retail_system/models/all_data_model.dart';
import 'package:retail_system/models/api_response.dart';
import 'package:retail_system/models/cart_model.dart';
import 'package:retail_system/models/cash_last_serials_model.dart';
import 'package:retail_system/models/end_cash_model.dart';
import 'package:retail_system/models/get_pay_in_out_model.dart';
import 'package:retail_system/networks/api_url.dart';

class RestApi {
  static final Map<String, dynamic> _headers = {
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'application/json',
  };

  static final dio.Dio restDio = dio.Dio(dio.BaseOptions(
    baseUrl: sharedPrefsClient.baseUrl,
    connectTimeout: 30000,
    receiveTimeout: 30000,
  ));

  static void _traceError(dio.DioError e) {
    String trace = '════════════════════════════════════════ \n'
        '╔╣ Dio [ERROR] info ==> \n'
        '╟ BASE_URL: ${e.requestOptions.baseUrl}\n'
        '╟ PATH: ${e.requestOptions.path}\n'
        '╟ Method: ${e.requestOptions.method}\n'
        '╟ Params: ${e.requestOptions.queryParameters}\n'
        '╟ Body: ${e.requestOptions.data}\n'
        '╟ Header: ${e.requestOptions.headers}\n'
        '╟ statusCode: ${e.response == null ? '' : e.response!.statusCode}\n'
        '╟ RESPONSE: ${e.response == null ? '' : e.response!.data} \n'
        '╟ stackTrace: ${e.stackTrace} \n'
        '╚ [END] ════════════════════════════════════════╝';
    developer.log(trace);
  }

  static void _traceCatch(e) {
    String trace = '════════════════════════════════════════ \n'
        '╔╣ Dio [Catch] info ==> \n'
        '╟ Runtime Type: ${e.runtimeType}\n'
        '╟ Catch: ${e.toString()}\n'
        '╚ [END] ════════════════════════════════════════╝';
    developer.log(trace);
  }

  static void _networkLog(dio.Response response) {
    String trace = '════════════════════════════════════════ \n'
        '╔╣ Dio [RESPONSE] info ==> \n'
        '╟ BASE_URL: ${response.requestOptions.baseUrl}\n'
        '╟ PATH: ${response.requestOptions.path}\n'
        '╟ Method: ${response.requestOptions.method}\n'
        '╟ Params: ${response.requestOptions.queryParameters}\n'
        '╟ Body: ${response.requestOptions.data}\n'
        '╟ Header: ${response.requestOptions.headers}\n'
        '╟ statusCode: ${response.statusCode}\n'
        '╟ RESPONSE: ${jsonEncode(response.data)} \n'
        '╚ [END] ════════════════════════════════════════╝';
    developer.log(trace);
  }

  static Future<dio.Response<dynamic>> _post(String path, {dynamic data, Map<String, dynamic>? headers, Map<String, dynamic>? queryParameters}) {
    Map<String, dynamic> requestHeads;

    if (headers == null) {
      requestHeads = _headers;
    } else {
      requestHeads = headers;
    }
    requestHeads.addAll({'Authorization': "Bearer "});
    requestHeads.addAll({"DeviceDate": DateTime.now().toIso8601String()});

    restDio.options.headers = requestHeads;
    return restDio.post(path, data: data, queryParameters: queryParameters);
  }

  static Future<dio.Response<dynamic>> _get(String path, {Map<String, dynamic>? headers, Map<String, dynamic>? queryParameters}) {
    Map<String, dynamic> requestHeads;

    if (headers == null) {
      requestHeads = _headers;
    } else {
      requestHeads = headers;
    }
    requestHeads.addAll({'Authorization': "Bearer "});
    requestHeads.addAll({"DeviceDate": DateTime.now().toIso8601String()});

    restDio.options.headers = requestHeads;
    return restDio.get(path, queryParameters: queryParameters);
  }

  static Future<ApiResponse<T>> _executeRequest<T>({required Future<dio.Response> method, Function? fromJsonModel}) async {
    try {
      final response = await method;
      ApiResponse<T> apiResponse = await _responseHandler(response, fromJsonModel);
      _networkLog(response);
      return apiResponse;
    } on dio.DioError catch (e) {
      _traceError(e);
      ApiResponse<T> apiResponse = await _responseHandler(e.response, fromJsonModel);
      return apiResponse;
    } catch (e) {
      _traceCatch(e);
      ApiResponse<T> apiResponse = ApiResponse<T>.fromJson({}, fromJsonModel);
      return apiResponse;
    }
  }

  static Future<String> _errorMessageHandler(dio.Response response) async {
    final message = response.data is Map ? response.data["message"] : "ErrorMessage";
    return message;
  }

  static Future<ApiResponse<T>> _responseHandler<T>(dio.Response? response, Function? fromJsonModel) async {
    int statusCode = response?.statusCode ?? 600;
    if (statusCode == 200 && response != null && response.data != null) {
      statusCode = response.data['code'];
    }
    switch (statusCode) {
      case 200:
      case 201:
      case 204:
        return ApiResponse<T>.fromJson(response!.data, fromJsonModel);
      case 400:
        final String errorHandler = response!.data == null ? 'BadRequestException' : await _errorMessageHandler(response);
        return ApiResponse<T>.fromError(statusCode, errorHandler);
      case 401:
        final String errorHandler = response!.data == null ? 'Unauthorized' : await _errorMessageHandler(response);
        return ApiResponse<T>.fromError(statusCode, errorHandler);
      case 403:
        final String errorHandler = response!.data == null ? 'Forbidden' : await _errorMessageHandler(response);
        return ApiResponse<T>.fromError(statusCode, errorHandler);
      case 404:
        final String errorHandler = response!.data == null ? 'NotFoundException' : await _errorMessageHandler(response);
        return ApiResponse<T>.fromError(statusCode, errorHandler);
      case 406:
        final String errorHandler = response!.data == null ? 'Not Acceptable' : await _errorMessageHandler(response);
        return ApiResponse<T>.fromError(statusCode, errorHandler);
      case 412:
        final String errorHandler = response!.data == null ? 'PreconditionFailed' : await _errorMessageHandler(response);
        return ApiResponse<T>.fromError(statusCode, errorHandler);
      case 422:
        final String errorHandler = response!.data == null ? 'UnprocessableEntity' : await _errorMessageHandler(response);
        return ApiResponse<T>.fromError(statusCode, errorHandler);
      case 500:
        final String errorHandler = response!.data == null ? 'ServerException' : await _errorMessageHandler(response);
        return ApiResponse<T>.fromError(statusCode, errorHandler);
      case 600:
        const String errorHandler = 'SocketException'; // 'There is no Internet!'
        return ApiResponse<T>.fromError(statusCode, errorHandler);
      default:
        final String errorHandler = response!.data == null ? 'SocketException' : await _errorMessageHandler(response); // 'There is no Internet!'
        return ApiResponse<T>.fromError(statusCode, errorHandler);
    }
  }

  //
  // static Future<ApiResponse<LoginModel>> login({required String username, required String password}) async {
  //   var body = jsonEncode({
  //     "userName": username,
  //     "password": password,
  //     "deviceToken": sharedPrefsClient.deviceToken,
  //     "platform": "string",
  //     "version": "string",
  //     "language": sharedPrefsClient.language,
  //   });
  //   final request = _post(ApiUrl.LOGIN, data: body);
  //   var response = await _executeRequest<LoginModel>(method: request, fromJsonModel: (Map<String, dynamic> json) => LoginModel.fromJson(json));
  //   return response;
  // }
  static Future<void> getData() async {
    try {
      Utils.showLoadingDialog();
      var queryParameters = {
        'PosNo': sharedPrefsClient.posNo,
      };
      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'GET_DATA',
        status: 3,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.GET_DATA,
        method: 'GET',
        params: jsonEncode(queryParameters),
        body: '',
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      final response = await restDio.get(ApiUrl.GET_DATA, queryParameters: queryParameters);
      _networkLog(response);
      if (response.statusCode == 200) {
        allDataModel = AllDataModel.fromJson(response.data);
        allDataModel.items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        allDataModel.categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        sharedPrefsClient.allData = allDataModel;
      } else {
        allDataModel = sharedPrefsClient.allData;
      }
      Utils.hideLoadingDialog();
      if (networkModel != null) {
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
      Utils.loadSorting();
    } on dio.DioError catch (e) {
      _traceError(e);
      Utils.hideLoadingDialog();
      allDataModel = sharedPrefsClient.allData;
      Utils.loadSorting();
      // Fluttertoast.showToast(msg: 'Please try again'.tr, timeInSecForIosWeb: 3);
    } catch (e) {
      _traceCatch(e);
      Utils.hideLoadingDialog();
      allDataModel = sharedPrefsClient.allData;
      Utils.loadSorting();
      // Fluttertoast.showToast(msg: 'Please try again'.tr, timeInSecForIosWeb: 3);
    }
  }

  static Future<bool> invoice({required CartModel cart, required EnumInvoiceKind invoiceKind}) async {
    try {
      List<Map<String, dynamic>> modifiers = [];
      for (var item in cart.items) {
        int rowSerial = 0;
        modifiers.addAll(item.modifiers.map((e) {
          rowSerial++;
          return e.toInvoice(itemId: item.id, rowSerial: rowSerial, orderType: item.orderType);
        }));
        for (var question in item.questions) {
          modifiers.addAll(question.modifiers.map((e) {
            rowSerial++;
            return e.toInvoice(itemId: item.id, rowSerial: rowSerial, orderType: item.orderType);
          }));
        }
      }
      var body = jsonEncode({
        "InvoiceMaster": invoiceKind == EnumInvoiceKind.invoicePay ? cart.toInvoice() : cart.toReturnInvoice(),
        "InvoiceDetails": List<dynamic>.from(cart.items.map((e) => invoiceKind == EnumInvoiceKind.invoicePay ? e.toInvoice() : e.toReturnInvoice())).toList(),
        "InvoiceModifires": modifiers,
      });
      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'INVOICE',
        status: 1,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.INVOICE,
        method: 'POST',
        params: '',
        body: body,
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      final response = await restDio.post(ApiUrl.INVOICE, data: body);
      _networkLog(response);
      if (networkModel != null) {
        networkModel.status = 2;
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
      return true;
    } on dio.DioError catch (e) {
      _traceError(e);
      return false;
    } catch (e) {
      _traceCatch(e);
      return false;
    }
  }

  static Future<void> saveVoidItem({required CartItemModel item, required String reason}) async {
    try {
      var body = jsonEncode({
        "CoYear": sharedPrefsClient.dailyClose.year,
        "PosNo": sharedPrefsClient.posNo,
        "CashNo": sharedPrefsClient.cashNo,
        "VoidDate": sharedPrefsClient.dailyClose.toIso8601String(),
        "RowNo": item.rowSerial,
        "Reason": reason,
        "ItemID": item.id,
        "Qty": item.qty,
        "UserID": sharedPrefsClient.employee.id,
      });
      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'SAVE_VOID_ITEMS',
        status: 1,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.SAVE_VOID_ITEMS,
        method: 'POST',
        params: '',
        body: body,
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      final response = await restDio.post(ApiUrl.SAVE_VOID_ITEMS, data: body);
      _networkLog(response);
      if (networkModel != null) {
        networkModel.status = 2;
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
    } on dio.DioError catch (e) {
      _traceError(e);
      Utils.showSnackbar('Please try again'.tr, '${e.response?.data ?? ''}');
    } catch (e) {
      _traceCatch(e);
      Utils.showSnackbar('Please try again'.tr);
    }
  }

  static Future<void> saveVoidAllItems({required List<CartItemModel> items, required String reason}) async {
    try {
      var body = jsonEncode(items
          .map((e) => {
                "CoYear": sharedPrefsClient.dailyClose.year,
                "PosNo": sharedPrefsClient.posNo,
                "CashNo": sharedPrefsClient.cashNo,
                "VoidDate": sharedPrefsClient.dailyClose.toIso8601String(),
                "RowNo": e.rowSerial,
                "Reason": reason,
                "ItemID": e.id,
                "Qty": e.qty,
                "UserID": sharedPrefsClient.employee.id,
              })
          .toList());
      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'SAVE_VOID_ALL_ITEMS',
        status: 1,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.SAVE_VOID_ALL_ITEMS,
        method: 'POST',
        params: '',
        body: body,
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      final response = await restDio.post(ApiUrl.SAVE_VOID_ALL_ITEMS, data: body);
      _networkLog(response);
      if (networkModel != null) {
        networkModel.status = 2;
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
    } on dio.DioError catch (e) {
      _traceError(e);
      Utils.showSnackbar('Please try again'.tr, '${e.response?.data ?? ''}');
    } catch (e) {
      _traceCatch(e);
      Utils.showSnackbar('Please try again'.tr);
    }
  }

  static Future<void> posDailyClose({required DateTime closeDate}) async {
    try {
      Utils.showLoadingDialog();
      closeDate = DateFormat(dateFormat).parse(DateFormat(dateFormat).format(closeDate));
      var body = jsonEncode({
        "CoYear": sharedPrefsClient.dailyClose.year,
        "PosNo": sharedPrefsClient.posNo,
        "UserId": sharedPrefsClient.employee.id,
        "CloseDate": closeDate.toIso8601String(),
      });
      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'POS_DAILY_CLOSE',
        status: 3,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.POS_DAILY_CLOSE,
        method: 'POST',
        params: '',
        body: body,
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      final response = await restDio.post(ApiUrl.POS_DAILY_CLOSE, data: body);
      _networkLog(response);
      sharedPrefsClient.dailyClose = closeDate;
      allDataModel.posClose = closeDate;
      sharedPrefsClient.allData = allDataModel;

      Utils.hideLoadingDialog();
      Get.back();
      Utils.showSnackbar('Successfully'.tr);
      if (networkModel != null) {
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
    } on dio.DioError catch (e) {
      _traceError(e);
      Utils.showSnackbar('Please try again'.tr);
    } catch (e) {
      _traceCatch(e);
      Utils.showSnackbar('Please try again'.tr);
    }
  }

  static Future<EndCashModel?> getEndCash() async {
    try {
      Utils.showLoadingDialog();
      var queryParameters = {
        "coYear": sharedPrefsClient.dailyClose.year,
        "PosNo": sharedPrefsClient.posNo,
        "CashNo": sharedPrefsClient.cashNo,
        "UserId": sharedPrefsClient.employee.id,
        "dayDate": sharedPrefsClient.dailyClose.toIso8601String(),
      };
      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'GET_END_CASH',
        status: 3,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.GET_END_CASH,
        method: 'GET',
        params: jsonEncode(queryParameters),
        body: '',
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      final response = await restDio.get(ApiUrl.GET_END_CASH, queryParameters: queryParameters);
      _networkLog(response);
      if (networkModel != null) {
        networkModel.status = 2;
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
      Utils.hideLoadingDialog();
      if (response.statusCode == 200) {
        return EndCashModel.fromJson(response.data);
      } else {
        Utils.showSnackbar('Please try again'.tr);
        return null;
      }
    } on dio.DioError catch (e) {
      _traceError(e);
      Utils.showSnackbar('${e.response?.data ?? 'Please try again'.tr}');
      return null;
    } catch (e) {
      _traceCatch(e);
      Utils.showSnackbar('Please try again'.tr);
      return null;
    }
  }

  static Future<bool> endCash({required double totalCash, required double totalCreditCard, required double totalCredit, required double netTotal}) async {
    try {
      Utils.showLoadingDialog();
      var body = jsonEncode({
        "CoYear": sharedPrefsClient.dailyClose.year,
        "EndCashDate": sharedPrefsClient.dailyClose.toIso8601String(),
        "PosNo": sharedPrefsClient.posNo,
        "CashNo": sharedPrefsClient.cashNo,
        "TotalCash": totalCash,
        "TotalCreditCard": totalCreditCard,
        "TotalCredit": totalCredit,
        "NetTotal": netTotal,
        "UserId": sharedPrefsClient.employee.id,
      });
      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'END_CASH',
        status: 3,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.END_CASH,
        method: 'POST',
        params: '',
        body: body,
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      final response = await restDio.post(ApiUrl.END_CASH, data: body);
      _networkLog(response);
      if (networkModel != null) {
        networkModel.status = 2;
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
      Utils.hideLoadingDialog();
      if (response.statusCode == 200) {
        // Utils.showSnackbar('Successfully'.tr);
        return true;
      } else {
        return false;
      }
    } on dio.DioError catch (e) {
      _traceError(e);
      Utils.showSnackbar('${e.response?.data ?? 'Please try again'.tr}');
      return false;
    } catch (e) {
      _traceCatch(e);
      Utils.showSnackbar('Please try again'.tr);
      return false;
    }
  }

  static Future<void> payInOut({required double value, required int type, String remark = '', required int descId}) async {
    try {
      var body = jsonEncode({
        "CoYear": sharedPrefsClient.dailyClose.year,
        "VoucherType": type,
        "VoucherNo": sharedPrefsClient.payInOutNo,
        "PosNo": sharedPrefsClient.posNo,
        "CashNo": sharedPrefsClient.cashNo,
        "VoucherDate": sharedPrefsClient.dailyClose.toIso8601String(),
        "VoucherTime": DateFormat('HH:mm:ss').format(sharedPrefsClient.dailyClose),
        "VoucherValue": value,
        "Remark": remark,
        "UserId": sharedPrefsClient.employee.id,
        "ShiftId": 0,
        "DescId": descId,
      });
      sharedPrefsClient.payInOutNo++;
      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'PAY_IN_OUT',
        status: 1,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.PAY_IN_OUT,
        method: 'POST',
        params: '',
        body: body,
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      final response = await restDio.post(ApiUrl.PAY_IN_OUT, data: body);
      _networkLog(response);
      if (networkModel != null) {
        networkModel.status = 2;
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
    } on dio.DioError catch (e) {
      _traceError(e);
      Utils.showSnackbar('${e.response?.data ?? 'Please try again'.tr}');
    } catch (e) {
      _traceCatch(e);
      Utils.showSnackbar('Please try again'.tr);
    }
  }

  static Future<List<GetPayInOutModel>> getPayInOut() async {
    try {
      Utils.showLoadingDialog();
      var queryParameters = {
        "Year": sharedPrefsClient.dailyClose.year,
        "PosNo": sharedPrefsClient.posNo,
        "CashNo": sharedPrefsClient.cashNo,
        "POSDATE": sharedPrefsClient.dailyClose.toIso8601String(),
      };

      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'GET_PAY_IN_OUT',
        status: 3,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.GET_PAY_IN_OUT,
        method: 'GET',
        params: jsonEncode(queryParameters),
        body: '',
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      final response = await restDio.get(ApiUrl.GET_PAY_IN_OUT, queryParameters: queryParameters);
      _networkLog(response);
      if (networkModel != null) {
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
      if (response.statusCode == 200) {
        List<GetPayInOutModel> model = List<GetPayInOutModel>.from(response.data.map((x) => GetPayInOutModel.fromJson(x)));
        Utils.hideLoadingDialog();
        return model;
      } else {
        Utils.hideLoadingDialog();
        return [];
      }
    } on dio.DioError catch (e) {
      Utils.hideLoadingDialog();
      _traceError(e);
      Utils.showSnackbar('${e.response?.data ?? 'Please try again'.tr}');
      return [];
    } catch (e) {
      Utils.hideLoadingDialog();
      _traceCatch(e);
      Utils.showSnackbar('Please try again'.tr);
      return [];
    }
  }

  static Future<void> deletePayInOut({required GetPayInOutModel model}) async {
    try {
      var queryParameters = {
        "Year": sharedPrefsClient.dailyClose.year,
        "VoucherType": model.voucherType,
        "VoucherNo": model.voucherNo,
        "PosNo": sharedPrefsClient.posNo,
        "CashNo": sharedPrefsClient.cashNo,
      };
      sharedPrefsClient.payInOutNo++;
      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'DELETE_PAY_IN_OUT',
        status: 1,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.DELETE_PAY_IN_OUT,
        method: 'DELETE',
        params: jsonEncode(queryParameters),
        body: '',
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      List<NetworkTableModel> data = await NetworkTable.queryRowsReports(types: ['PAY_IN_OUT']);
      var payIn = data.firstWhereOrNull((element) {
        var body = jsonDecode(element.body);
        if (body['VoucherNo'] == model.voucherNo && body['PosNo'] == sharedPrefsClient.posNo && body['CashNo'] == sharedPrefsClient.cashNo) {
          return true;
        }
        return false;
      });
      if (payIn != null) {
        developer.log('ana ${payIn.id}');
        await NetworkTable.delete(payIn.id);
      }
      final response = await restDio.delete(ApiUrl.DELETE_PAY_IN_OUT, queryParameters: queryParameters);
      _networkLog(response);
      if (networkModel != null) {
        networkModel.status = 2;
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
    } on dio.DioError catch (e) {
      _traceError(e);
    } catch (e) {
      _traceCatch(e);
    }
  }

  static Future<CartModel?> getRefundInvoice({required int invNo}) async {
    try {
      Utils.showLoadingDialog();
      var queryParameters = {
        "PosNo": sharedPrefsClient.posNo,
        "CashNo": sharedPrefsClient.cashNo,
        "InvNo": invNo,
      };
      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'REFUND_INVOICE',
        status: 3,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.REFUND_INVOICE,
        method: 'GET',
        params: jsonEncode(queryParameters),
        body: '',
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      final response = await restDio.get(ApiUrl.REFUND_INVOICE, queryParameters: queryParameters);
      _networkLog(response);
      if (networkModel != null) {
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
      if (response.statusCode == 200) {
        CartModel refundModel = CartModel.fromJsonServer(response.data);
        Utils.hideLoadingDialog();
        return refundModel;
      } else {
        Utils.hideLoadingDialog();
        return null;
      }
    } on dio.DioError catch (e) {
      Utils.hideLoadingDialog();
      _traceError(e);
      Utils.showSnackbar('${e.response?.data ?? 'Please try again'.tr}');
      return null;
    } catch (e) {
      Utils.hideLoadingDialog();
      _traceCatch(e);
      Utils.showSnackbar('Please try again'.tr);
      return null;
    }
  }

  static Future<bool> returnInvoiceQty({required CartModel refundModel, required int invNo}) async {
    try {
      var queryParameters = {
        'orgInvNo': invNo,
      };
      var body = jsonEncode(List<dynamic>.from(refundModel.items.map((e) => e.toReturnInvoiceQty())));
      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'INVOICE_RETURNED_QTY',
        status: 1,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.INVOICE_RETURNED_QTY,
        method: 'POST',
        params: jsonEncode(queryParameters),
        body: body,
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      final response = await restDio.post(ApiUrl.INVOICE_RETURNED_QTY, data: body, queryParameters: queryParameters);
      _networkLog(response);
      if (networkModel != null) {
        networkModel.status = 2;
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
      return true;
    } on dio.DioError catch (e) {
      _traceError(e);
      return false;
    } catch (e) {
      _traceCatch(e);
      return false;
    }
  }

  static Future<CartModel?> getInvoice({required int invNo}) async {
    try {
      Utils.showLoadingDialog();
      var queryParameters = {
        "coYear": sharedPrefsClient.dailyClose.year,
        "PosNo": sharedPrefsClient.posNo,
        "CashNo": sharedPrefsClient.cashNo,
        "InvNo": invNo,
      };
      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'GET_INVOICE',
        status: 3,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.GET_INVOICE,
        method: 'GET',
        params: jsonEncode(queryParameters),
        body: '',
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      final response = await restDio.get(ApiUrl.GET_INVOICE, queryParameters: queryParameters);
      _networkLog(response);
      if (networkModel != null) {
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
      if (response.statusCode == 200) {
        CartModel model = CartModel.fromJsonServer(response.data);
        Utils.hideLoadingDialog();
        return model;
      } else {
        Utils.hideLoadingDialog();
        return null;
      }
    } on dio.DioError catch (e) {
      Utils.hideLoadingDialog();
      _traceError(e);
      Utils.showSnackbar('${e.response?.data ?? 'Please try again'.tr}');
      return null;
    } catch (e) {
      Utils.hideLoadingDialog();
      _traceCatch(e);
      Utils.showSnackbar('Please try again'.tr);
      return null;
    }
  }

  static Future<void> getCashLastSerials() async {
    try {
      var queryParameters = {
        "PosNo": sharedPrefsClient.posNo,
        "CashNo": sharedPrefsClient.cashNo,
      };
      var networkId = await NetworkTable.insert(NetworkTableModel(
        id: 0,
        type: 'GET_CASH_LAST_SERIALS',
        status: 3,
        baseUrl: restDio.options.baseUrl,
        path: ApiUrl.GET_CASH_LAST_SERIALS,
        method: 'GET',
        params: jsonEncode(queryParameters),
        body: '',
        headers: '',
        countRequest: 1,
        statusCode: 0,
        response: '',
        createdAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        dailyClose: sharedPrefsClient.dailyClose.millisecondsSinceEpoch,
      ));
      var networkModel = await NetworkTable.queryById(id: networkId);
      final response = await restDio.get(ApiUrl.GET_CASH_LAST_SERIALS, queryParameters: queryParameters);
      _networkLog(response);
      if (networkModel != null) {
        networkModel.status = 2;
        networkModel.statusCode = response.statusCode!;
        networkModel.response = response.data is String ? response.data : jsonEncode(response.data);
        networkModel.uploadedAt = DateTime.now().toIso8601String();
        await NetworkTable.update(networkModel);
      }
      if (response.statusCode == 200) {
        var model = CashLastSerialsModel.fromJson(response.data);
        if (sharedPrefsClient.inVocNo <= model.invNo) {
          sharedPrefsClient.inVocNo = model.invNo + 1;
        }
        if (sharedPrefsClient.payInOutNo <= model.cashInOutNo) {
          sharedPrefsClient.payInOutNo = model.cashInOutNo + 1;
        }
      }
    } on dio.DioError catch (e) {
      _traceError(e);
    } catch (e) {
      _traceCatch(e);
    }
  }
}
