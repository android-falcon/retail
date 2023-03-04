import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/config/enum/enum_invoice_kind.dart';
import 'package:retail_system/config/utils.dart';
import 'package:retail_system/database/network_table.dart';
import 'package:retail_system/models/all_data_model.dart';
import 'package:retail_system/models/api_response.dart';
import 'package:retail_system/models/cart_model.dart';
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

  static Future<void> invoice({required CartModel cart, required EnumInvoiceKind invoiceKind}) async {
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
    } on dio.DioError catch (e) {
      _traceError(e);
      //Utils.showSnackbar('Please try again'.tr, '${e.response?.data ?? ''}');
    } catch (e) {
      _traceCatch(e);
      //Utils.showSnackbar('Please try again'.tr);
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
}
