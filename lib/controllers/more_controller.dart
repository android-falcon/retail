import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/config/enum/enum_in_out_type.dart';
import 'package:retail_system/config/enum/enum_invoice_kind.dart';
import 'package:retail_system/config/money_count.dart';
import 'package:retail_system/config/text_input_formatters.dart';
import 'package:retail_system/config/utils.dart';
import 'package:retail_system/config/validation.dart';
import 'package:retail_system/models/cart_model.dart';
import 'package:retail_system/models/end_cash_model.dart';
import 'package:retail_system/models/printer_image_model.dart';
import 'package:retail_system/networks/rest_api.dart';
import 'package:retail_system/printer/printer.dart';
import 'package:retail_system/ui/screens/history_pay_in_out/history_pay_in_out_screen.dart';
import 'package:retail_system/ui/screens/login/login_screen.dart';
import 'package:retail_system/ui/screens/refund/refund_screen.dart';
import 'package:retail_system/ui/screens/reports/reports_screen.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';
import 'package:screenshot/screenshot.dart';

class MoreController extends GetxController {
  static MoreController get to => Get.isRegistered<MoreController>() ? Get.find<MoreController>() : Get.put(MoreController());

  List<Map<String, dynamic>> options = [];

  @override
  void onInit() {
    super.onInit();
    options = [
      {
        'label': 'Pay In'.tr,
        'icon': Constant.kAssetCloseCash,
        'onTap': () async {
          _showInOutDialog(type: EnumInOutType.payIn);
        },
      },
      {
        'label': 'Pay Out'.tr,
        'icon': Constant.kAssetCloseCash,
        'onTap': () async {
          _showInOutDialog(type: EnumInOutType.payOut);
        },
      },
      {
        'label': 'History pay In / Out'.tr,
        'icon': Constant.kAssetCloseCash,
        'onTap': () async {
          Get.to(() => HistoryPayInOutScreen());
        },
      },
      {
        'label': 'End cash'.tr,
        'icon': Constant.kAssetCloseCash,
        'onTap': () async {
          endCash();
        },
      },
      {
        'label': 'Daily close'.tr,
        'icon': Constant.kAssetCloseCash,
        'onTap': () async {
          dailyClose();
        },
      },
      {
        'label': 'Refund'.tr,
        'icon': Constant.kAssetReprintInvoice,
        'onTap': () {
          refund();
        },
      },
      {
        'label': 'Reprint an invoice'.tr,
        'icon': Constant.kAssetReprintInvoice,
        'onTap': () {
          _showReprintInvoiceDialog();
        },
      },
      {
        'label': 'Reports'.tr,
        'icon': Constant.kAssetReprintInvoice,
        'onTap': () {
          reports();
        },
      },
      {
        'label': 'Refresh data'.tr,
        'icon': Constant.kAssetReprintInvoice,
        'onTap': () {
          refreshData();
        },
      },
      {
        'label': 'Logout'.tr,
        'icon': Constant.kAssetLogout,
        'onTap': () {
          logout();
        },
      },
    ];
  }

  reports() async {
    if (await Utils.checkPermission(Constant.sharedPrefsClient.employee.isMaster)) {
      Get.to(() => ReportsScreen());
    }
  }

  dailyClose() async {
    if (await Utils.checkPermission(Constant.sharedPrefsClient.employee.hasReportsPermission)) {
      _showDailyCloseDialog();
    }
  }

  refreshData() {
    RestApi.getData();
    RestApi.getCashLastSerials();
  }

  refund() async {
    if (await Utils.checkPermission(Constant.sharedPrefsClient.employee.hasRefundPermission)) {
      Get.to(() => RefundScreen());
    }
  }

  endCash() async {
    if (await Utils.checkPermission(Constant.sharedPrefsClient.employee.hasSeeEndCashPermission)) {
      EndCashModel? model = await RestApi.getEndCash();
      if (model != null) {
        _showEndCashDialog(endCash: model);
      }
    }
  }

  logout() {
    Get.offAll(() => LoginScreen());
  }

  _showReprintInvoiceDialog() async {
    TextEditingController controllerVoucherNo = TextEditingController();
    CartModel? reprintModel;
    bool result = await Get.dialog(
      CustomDialog(
        width: 300.w,
        gestureDetectorOnTap: () {},
        builder: (context, setState, constraints) => Column(
          children: [
            Text(
              'Reprint Invoice'.tr,
              textAlign: TextAlign.end,
              style: Constant.kStyleTextLarge,
            ),
            SizedBox(height: 30.h),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    controller: controllerVoucherNo,
                    label: Text('Voucher No'.tr),
                    maxLines: 1,
                    inputFormatters: [
                      EnglishDigitsTextInputFormatter(decimal: false),
                    ],
                    keyboardType: const TextInputType.numberWithOptions(),
                    validator: (value) => Validation.isRequired(value),
                  ),
                ),
                CustomButton(
                  margin: EdgeInsetsDirectional.only(end: 16.w),
                  fixed: true,
                  child: Text('Show'.tr),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    reprintModel = await RestApi.getInvoice(invNo: int.parse(controllerVoucherNo.text));
                    reprintModel = Utils.calculateOrder(cart: reprintModel!, invoiceKind: EnumInvoiceKind.invoicePay);
                    setState(() {});
                  },
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${'Original Data'.tr} : ',
                    textAlign: TextAlign.center,
                    style: Constant.kStyleTextDefault,
                  ),
                ),
                Expanded(
                  child: Text(
                    reprintModel == null ? '' : DateFormat('yyyy-MM-dd').format(DateTime.parse(reprintModel!.invDate)),
                    style: Constant.kStyleTextDefault,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${'Original Time'.tr} : ',
                    textAlign: TextAlign.center,
                    style: Constant.kStyleTextDefault,
                  ),
                ),
                Expanded(
                  child: Text(
                    reprintModel == null ? '' : DateFormat('hh:mm:ss a').format(DateTime.parse(reprintModel!.invDate)),
                    style: Constant.kStyleTextDefault,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),
            Center(
              child: CustomButton(
                fixed: true,
                backgroundColor: AppColor.green,
                onPressed: reprintModel == null
                    ? null
                    : () async {
                        Get.back(result: true);
                      },
                child: Text(
                  'Print'.tr,
                  style: Constant.kStyleTextButton,
                ),
              ),
            ),
            Utils.numPadWidget(controllerVoucherNo, setState),
          ],
        ),
      ),
      barrierDismissible: false,
    );
    if (result) {
      await Printer.printInvoicesDialog(cart: reprintModel!, reprint: true, invNo: '${reprintModel!.invNo}');
    }
  }

  _showInOutDialog({required EnumInOutType type}) async {
    var indexPrinter = Constant.allDataModel.printers.indexWhere((element) => element.cashNo == Constant.sharedPrefsClient.cashNo);
    PrinterImageModel? printer;
    if (indexPrinter != -1) {
      printer = PrinterImageModel(ipAddress: Constant.allDataModel.printers[indexPrinter].ipAddress, port: Constant.allDataModel.printers[indexPrinter].port);
    }

    GlobalKey<FormState> keyForm = GlobalKey<FormState>();
    TextEditingController controllerManual = TextEditingController(text: '0');
    TextEditingController controllerRemark = TextEditingController();
    TextEditingController? controllerSelectEdit = controllerManual;
    int typeInputCash = 1;
    double moneyCount = 0;
    int? selectDescId;

    bool result = await Get.dialog(
      CustomDialog(
        gestureDetectorOnTap: () {
          controllerSelectEdit = null;
        },
        builder: (context, setState, constraints) {
          moneyCount = MoneyCount.moneyCount.fold(0.0, (previousValue, element) => (previousValue) + ((element.value * element.rate) * double.parse(element.qty.text)));
          return Form(
            key: keyForm,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: Column(
                    children: [
                      Text(
                        type == EnumInOutType.payIn
                            ? 'Pay In'.tr
                            : type == EnumInOutType.payOut
                                ? 'Pay Out'.tr
                                : type == EnumInOutType.cashIn
                                    ? 'Cash In'
                                    : type == EnumInOutType.cashOut
                                        ? 'Cash Out'
                                        : '',
                        style: Constant.kStyleTextLarge,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${'Date'.tr} : ${DateFormat(Constant.dateFormat).format(Constant.sharedPrefsClient.dailyClose)}',
                        style: Constant.kStyleTextTitle,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              value: 1,
                              groupValue: typeInputCash,
                              onChanged: (value) {
                                typeInputCash = value as int;
                                MoneyCount.clear();
                                controllerSelectEdit = controllerManual;
                                setState(() {});
                              },
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                'Manual'.tr,
                                style: Constant.kStyleTextDefault,
                              ),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              value: 2,
                              groupValue: typeInputCash,
                              onChanged: (value) {
                                controllerManual.text = "0";
                                typeInputCash = value as int;
                                MoneyCount.init();
                                controllerSelectEdit = null;
                                setState(() {});
                              },
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                'Money Count'.tr,
                                style: Constant.kStyleTextDefault,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (typeInputCash == 1)
                            Expanded(
                              child: CustomTextField(
                                margin: EdgeInsets.symmetric(horizontal: 8.w),
                                controller: controllerManual,
                                label: Text('Value'.tr),
                                fillColor: Colors.white,
                                maxLines: 1,
                                inputFormatters: [
                                  EnglishDigitsTextInputFormatter(decimal: true),
                                ],
                                validator: (value) {
                                  return Validation.isRequired(value);
                                },
                                enableInteractiveSelection: false,
                                keyboardType: const TextInputType.numberWithOptions(),
                                onTap: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  controllerSelectEdit = controllerManual;
                                },
                              ),
                            ),
                          Expanded(
                            child: CustomTextField(
                              margin: EdgeInsets.symmetric(horizontal: 8.w),
                              controller: controllerRemark,
                              label: Text('Remark'.tr),
                              fillColor: Colors.white,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (typeInputCash == 2)
                  Column(
                    children: [
                      const Divider(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total'.tr,
                              textAlign: TextAlign.center,
                              style: Constant.kStyleTextDefault,
                            ),
                            Text(
                              moneyCount.toStringAsFixed(3),
                              textAlign: TextAlign.center,
                              style: Constant.kStyleTextDefault.copyWith(color: AppColor.red),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(),
                            ),
                            Expanded(
                              child: Text(
                                'Qty'.tr,
                                textAlign: TextAlign.center,
                                style: Constant.kStyleTextDefault,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Total'.tr,
                                textAlign: TextAlign.center,
                                style: Constant.kStyleTextDefault,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: ListView.builder(
                          itemCount: MoneyCount.moneyCount.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        MoneyCount.moneyCount[index].qty.text = '${int.parse(MoneyCount.moneyCount[index].qty.text) + 1}';
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 4.h),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: '${Constant.sharedPrefsClient.baseUrl}${Constant.allDataModel.imagePaths.firstWhereOrNull((element) => element.description == 'Currencies')?.imgPath ?? ''}${MoneyCount.moneyCount[index].icon}',
                                            height: 20.h,
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) => Container(),
                                            errorWidget: (context, url, error) => Container(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              MoneyCount.moneyCount[index].name,
                                              textAlign: TextAlign.center,
                                              style: Constant.kStyleTextDefault,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: CustomTextFieldNum(
                                    enableInteractiveSelection: false,
                                    controller: MoneyCount.moneyCount[index].qty,
                                    fillColor: controllerSelectEdit == MoneyCount.moneyCount[index].qty ? AppColor.primaryColor.withOpacity(0.2) : null,
                                    onTap: () {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      controllerSelectEdit = MoneyCount.moneyCount[index].qty;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    ((MoneyCount.moneyCount[index].value * MoneyCount.moneyCount[index].rate) * double.parse(MoneyCount.moneyCount[index].qty.text)).toStringAsFixed(3),
                                    textAlign: TextAlign.center,
                                    style: Constant.kStyleTextDefault,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                Utils.numPadWidget(
                  controllerSelectEdit,
                  setState,
                  onExit: () async {
                    var result = await Utils.showAreYouSureDialog(title: 'Exit'.tr);
                    if (result) {
                      Get.back(result: false);
                    }
                  },
                  onSubmit: () async {
                    // var result = await Utils.showAreYouSureDialog(title: 'Save'.tr);
                    selectDescId = await _showCashInOutTypeDialog(kindType: type);
                    if (selectDescId != null) {
                      if (typeInputCash == 1 ? double.parse(controllerManual.text) > 0 : moneyCount > 0) {
                        switch (type) {
                          case EnumInOutType.payIn:
                            RestApi.payInOut(
                              value: typeInputCash == 1 ? double.parse(controllerManual.text) : moneyCount,
                              remark: controllerRemark.text,
                              type: 1,
                              descId: selectDescId!,
                            );
                            break;
                          case EnumInOutType.payOut:
                            RestApi.payInOut(
                              value: typeInputCash == 1 ? double.parse(controllerManual.text) : moneyCount,
                              remark: controllerRemark.text,
                              type: 2,
                              descId: selectDescId!,
                            );
                            break;
                          case EnumInOutType.cashIn:
                            break;
                          case EnumInOutType.cashOut:
                            break;
                        }
                        Get.back(result: true);
                      } else {
                        Utils.showSnackbar('The value must be greater than zero'.tr);
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      barrierDismissible: false,
    );

    if (printer != null && result) {
      ScreenshotController screenshotController = ScreenshotController();

      Future.delayed(const Duration(milliseconds: 100)).then((value) async {
        var screenshot = await screenshotController.capture(delay: const Duration(milliseconds: 10));
        printer!.image = screenshot;
        await Printer.payInOut(printerImageModel: printer);
      });

      await Get.dialog(
        CustomDialog(
          width: 450,
          builder: (context, setState, constraints) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                      fixed: true,
                      child: Text('Print'.tr),
                      onPressed: () async {
                        await Printer.payInOut(printerImageModel: printer!);
                      },
                    ),
                    SizedBox(width: 10.w),
                    CustomButton(
                      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                      fixed: true,
                      child: Text('Close'.tr),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
                const Divider(thickness: 2),
                Screenshot(
                  controller: screenshotController,
                  child: SizedBox(
                    width: 450,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                type == EnumInOutType.payIn
                                    ? 'Pay In'.tr
                                    : type == EnumInOutType.payOut
                                        ? 'Pay Out'.tr
                                        : type == EnumInOutType.cashIn
                                            ? 'Cash In'
                                            : type == EnumInOutType.cashOut
                                                ? 'Cash Out'
                                                : '',
                                style: Constant.kStyleLargePrinter,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Divider(color: Colors.black, thickness: 2),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${'Value'.tr} : ${typeInputCash == 1 ? double.parse(controllerManual.text).toStringAsFixed(3) : moneyCount.toStringAsFixed(3)}',
                                    style: Constant.kStyleDataPrinter,
                                  ),
                                  Text(
                                    '${'Remark'.tr} : ${controllerRemark.text}',
                                    style: Constant.kStyleDataPrinter,
                                  ),
                                  Text(
                                    '${'Type'.tr} : ${selectDescId == null ? '' : Constant.allDataModel.cashInOutTypesModel.firstWhereOrNull((element) => element.id == selectDescId)?.description ?? ''}',
                                    style: Constant.kStyleDataPrinter,
                                  ),
                                  Text(
                                    '${'Date'.tr} : ${DateFormat(Constant.dateFormat).format(Constant.sharedPrefsClient.dailyClose)}',
                                    style: Constant.kStyleDataPrinter,
                                  ),
                                  Text(
                                    '${'Time'.tr} : ${DateFormat('HH:mm:ss a').format(DateTime.now())}',
                                    style: Constant.kStyleDataPrinter,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.black, thickness: 2),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        barrierDismissible: false,
      );
    }
  }

  Future<int?> _showCashInOutTypeDialog({required EnumInOutType kindType}) async {
    int kind = 0;
    if (kindType == EnumInOutType.payIn) {
      kind = 0;
    } else if (kindType == EnumInOutType.payOut) {
      kind = 1;
    }
    int? selectedTypeId;
    await Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: CustomDialog(
          builder: (context, setState, constraints) => Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              children: [
                Text(
                  'Cash In / Out Types'.tr,
                  style: Constant.kStyleTextTitle,
                ),
                const Divider(thickness: 2),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Constant.allDataModel.cashInOutTypesModel.length,
                  itemBuilder: (context, index) => kind != Constant.allDataModel.cashInOutTypesModel[index].kind
                      ? Container()
                      : RadioListTile(
                          title: Text(
                            Constant.allDataModel.cashInOutTypesModel[index].description,
                            style: Constant.kStyleForceQuestion,
                          ),
                          value: Constant.allDataModel.cashInOutTypesModel[index].id,
                          groupValue: selectedTypeId,
                          onChanged: (value) {
                            selectedTypeId = value as int;
                            setState(() {});
                          },
                        ),
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        backgroundColor: AppColor.primaryColor,
                        onPressed: () {
                          selectedTypeId = null;
                          Get.back();
                        },
                        child: Text('Cancel'.tr),
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        backgroundColor: AppColor.primaryColor,
                        onPressed: () {
                          if (selectedTypeId == null) {
                            Utils.showSnackbar('Please select cash In / Out Type'.tr);
                          } else {
                            Get.back();
                          }
                        },
                        child: Text('Save'.tr),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
    return selectedTypeId;
  }

  _showEndCashDialog({required EndCashModel endCash}) async {
    var indexPrinter = Constant.allDataModel.printers.indexWhere((element) => element.cashNo == Constant.sharedPrefsClient.cashNo);
    PrinterImageModel? printer;

    if (indexPrinter != -1) {
      printer = PrinterImageModel(ipAddress: Constant.allDataModel.printers[indexPrinter].ipAddress, port: Constant.allDataModel.printers[indexPrinter].port);
    }
    GlobalKey<FormState> keyForm = GlobalKey<FormState>();
    TextEditingController controllerTotalCash = TextEditingController(text: '0');
    TextEditingController controllerTotalCreditCard = TextEditingController(text: '0');
    TextEditingController controllerTotalCredit = TextEditingController(text: '0');
    TextEditingController controllerNetTotal = TextEditingController(text: '0');
    TextEditingController? controllerSelectEdit = controllerTotalCash;

    var result = await Get.dialog(
      CustomDialog(
        gestureDetectorOnTap: () {
          controllerSelectEdit = null;
        },
        builder: (context, setState, constraints) {
          double netTotal = double.parse(controllerTotalCash.text) + double.parse(controllerTotalCreditCard.text) + double.parse(controllerTotalCredit.text);
          controllerNetTotal.text = netTotal.toStringAsFixed(3);
          return Form(
            key: keyForm,
            child: Column(
              children: [
                Text(
                  'End Cash'.tr,
                  style: Constant.kStyleTextLarge,
                ),
                Text(
                  '${'Date'.tr} : ${DateFormat(Constant.dateFormat).format(Constant.sharedPrefsClient.dailyClose)}',
                  style: Constant.kStyleTextLarge,
                ),
                SizedBox(height: 8.h),
                const Divider(
                  thickness: 1,
                  height: 1,
                ),
                Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: controllerTotalCash,
                        label: Text('Total Cash'.tr),
                        fillColor: Colors.white,
                        maxLines: 1,
                        inputFormatters: [
                          EnglishDigitsTextInputFormatter(decimal: true),
                        ],
                        validator: (value) {
                          return Validation.isRequired(value);
                        },
                        borderColor: controllerSelectEdit == controllerTotalCash ? AppColor.primaryColor : null,
                        enableInteractiveSelection: false,
                        keyboardType: const TextInputType.numberWithOptions(),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          controllerSelectEdit = controllerTotalCash;
                          setState(() {});
                        },
                      ),
                      CustomTextField(
                        controller: controllerTotalCreditCard,
                        label: Text('Total Credit Card'.tr),
                        fillColor: Colors.white,
                        maxLines: 1,
                        inputFormatters: [
                          EnglishDigitsTextInputFormatter(decimal: true),
                        ],
                        validator: (value) {
                          return Validation.isRequired(value);
                        },
                        borderColor: controllerSelectEdit == controllerTotalCreditCard ? AppColor.primaryColor : null,
                        enableInteractiveSelection: false,
                        keyboardType: const TextInputType.numberWithOptions(),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          controllerSelectEdit = controllerTotalCreditCard;
                          setState(() {});
                        },
                      ),
                      // CustomTextField(
                      //   controller: _controllerTotalCredit,
                      //   label: Text('Total Credit'.tr),
                      //   fillColor: Colors.white,
                      //   maxLines: 1,
                      //   inputFormatters: [
                      //     EnglishDigitsTextInputFormatter(decimal: true),
                      //   ],
                      //   validator: (value) {
                      //     return Validation.isRequired(value);
                      //   },
                      //   enableInteractiveSelection: false,
                      //   keyboardType: const TextInputType.numberWithOptions(),
                      //   onTap: () {
                      //     FocusScope.of(context).requestFocus(FocusNode());
                      //     _controllerSelectEdit = _controllerTotalCredit;
                      //     setState(() {});
                      //   },
                      // ),
                      CustomTextField(
                        controller: controllerNetTotal,
                        label: Text('Net Total'.tr),
                        fillColor: Colors.white,
                        maxLines: 1,
                        readOnly: true,
                        enabled: false,
                      ),
                    ],
                  ),
                ),
                Utils.numPadWidget(
                  controllerSelectEdit,
                  setState,
                  onExit: () async {
                    var result = await Utils.showAreYouSureDialog(title: 'Exit'.tr);
                    if (result) {
                      Get.back();
                    }
                  },
                  onSubmit: () async {
                    var result = await Utils.showAreYouSureDialog(title: 'Save'.tr);
                    if (result) {
                      var resultEndCash = await RestApi.endCash(
                        totalCash: double.parse(controllerTotalCash.text),
                        totalCreditCard: double.parse(controllerTotalCreditCard.text),
                        totalCredit: double.parse(controllerTotalCredit.text),
                        netTotal: double.parse(controllerNetTotal.text),
                      );
                      log('message $resultEndCash');
                      if (resultEndCash) {
                        Get.back(result: true);
                      }
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
      barrierDismissible: false,
    );
    if (result != null && result && printer != null) {
      ScreenshotController screenshotController = ScreenshotController();

      Future.delayed(const Duration(milliseconds: 100)).then((value) async {
        var screenshot = await screenshotController.capture(delay: const Duration(milliseconds: 10));
        printer!.image = screenshot;
        await Printer.payInOut(printerImageModel: printer);
      });

      await Get.dialog(
        CustomDialog(
          width: 450,
          builder: (context, setState, constraints) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                      fixed: true,
                      child: Text('Print'.tr),
                      onPressed: () async {
                        await Printer.payInOut(printerImageModel: printer!);
                      },
                    ),
                    SizedBox(width: 10.w),
                    CustomButton(
                      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                      fixed: true,
                      child: Text('Close'.tr),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
                const Divider(thickness: 2),
                Screenshot(
                  controller: screenshotController,
                  child: SizedBox(
                    width: 450,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'End Cash'.tr,
                                style: Constant.kStyleLargePrinter,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Divider(color: Colors.black, thickness: 2),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Total Cash'.tr,
                                      style: Constant.kStyleTitlePrinter,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${'Input'.tr} : ${double.parse(controllerTotalCash.text).toStringAsFixed(3)}',
                                        style: Constant.kStyleDataPrinter,
                                      ),
                                      Text(
                                        '${'Actual Value'.tr} : ${endCash.totalCash.toStringAsFixed(3)}',
                                        style: Constant.kStyleDataPrinter,
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      '${'Different'.tr} : ${(double.parse(controllerTotalCash.text) - double.parse(endCash.totalCash.toString())).toStringAsFixed(3)}',
                                      style: Constant.kStyleDataPrinter.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Divider(color: Colors.black, thickness: 2),
                                  Center(
                                    child: Text(
                                      'Total Credit Card'.tr,
                                      style: Constant.kStyleTitlePrinter,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${'Input'.tr} : ${double.parse(controllerTotalCreditCard.text).toStringAsFixed(3)}',
                                        style: Constant.kStyleDataPrinter,
                                      ),
                                      Text(
                                        '${'Actual Value'.tr} : ${endCash.totalCreditCard.toStringAsFixed(3)}',
                                        style: Constant.kStyleDataPrinter,
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      '${'Different'.tr} : ${double.parse(double.parse(controllerTotalCreditCard.text).toStringAsFixed(3)) - double.parse(endCash.totalCreditCard.toStringAsFixed(3))}',
                                      style: Constant.kStyleDataPrinter.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Divider(color: Colors.black, thickness: 2),
                                  Center(
                                    child: Text(
                                      'Net Total'.tr,
                                      style: Constant.kStyleTitlePrinter,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${'Input'.tr} : ${double.parse(controllerNetTotal.text).toStringAsFixed(3)}',
                                        style: Constant.kStyleDataPrinter,
                                      ),
                                      Text(
                                        '${'Actual Value'.tr} : ${endCash.netTotal.toStringAsFixed(3)}',
                                        style: Constant.kStyleDataPrinter,
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      '${'Different'.tr} : ${double.parse(double.parse(controllerNetTotal.text).toStringAsFixed(3)) - double.parse(endCash.netTotal.toStringAsFixed(3))}',
                                      style: Constant.kStyleDataPrinter.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Divider(color: Colors.black, thickness: 2),
                                  Text(
                                    '${'Date'.tr} : ${DateFormat(Constant.dateFormat).format(Constant.sharedPrefsClient.dailyClose)}',
                                    style: Constant.kStyleDataPrinter,
                                  ),
                                  Text(
                                    '${'Time'.tr} : ${DateFormat('HH:mm:ss a').format(DateTime.now())}',
                                    style: Constant.kStyleDataPrinter,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.black, thickness: 2),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        barrierDismissible: false,
      );
    }
  }

  _showDailyCloseDialog() {
    Get.defaultDialog(
      title: 'Are you sure?'.tr,
      titleStyle: Constant.kStyleTextLarge,
      content: Column(
        children: [
          Text(
            '${'Daily close date'.tr} : ${DateFormat(Constant.dateFormat).format(Constant.sharedPrefsClient.dailyClose)}',
            style: Constant.kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            '${'New daily close date'.tr} : ${DateFormat(Constant.dateFormat).format(Constant.sharedPrefsClient.dailyClose.add(const Duration(days: 1)))}',
            style: Constant.kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
        ],
      ),
      textCancel: 'Cancel'.tr,
      textConfirm: 'Confirm'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        if (Constant.sharedPrefsClient.park.isNotEmpty) {
          Utils.showSnackbar('Daily closing cannot be done due to order park'.tr);
        } else {
          await RestApi.posDailyClose(closeDate: Constant.sharedPrefsClient.dailyClose.add(const Duration(days: 1)));
        }
      },
    );
  }
}
