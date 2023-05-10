import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/config/enum/enum_credit_card_type.dart';
import 'package:retail_system/config/enum/enum_report_type.dart';
import 'package:retail_system/database/network_table.dart';
import 'package:retail_system/models/report_sold_qty_model.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class ReportController extends GetxController {
  static ReportController get to => Get.isRegistered<ReportController>() ? Get.find<ReportController>() : Get.put(ReportController());

  final TextEditingController controllerFromDate = TextEditingController();
  final TextEditingController controllerToDate = TextEditingController();
  Widget buildWidget = Container();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    controllerFromDate.text = intl.DateFormat(dateFormat).format(sharedPrefsClient.dailyClose);
    controllerToDate.text = intl.DateFormat(dateFormat).format(sharedPrefsClient.dailyClose);
  }

  selectToDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: controllerToDate.text.isNotEmpty ? intl.DateFormat(dateFormat).parse(controllerToDate.text) : DateTime.now(),
      firstDate: DateTime(2000),
      //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = intl.DateFormat(dateFormat).format(pickedDate);
      controllerToDate.text = formattedDate; //set output date to TextField value.
    }
  }

  selectFromDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: controllerFromDate.text.isNotEmpty ? intl.DateFormat(dateFormat).parse(controllerFromDate.text) : DateTime.now(),
      firstDate: DateTime(2000),
      //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = intl.DateFormat(dateFormat).format(pickedDate);
      controllerFromDate.text = formattedDate; //set output date to TextField value.
    }
  }

  init(EnumReportType type) async {
    switch (type) {
      case EnumReportType.cashReport:
        List<NetworkTableModel> data = await NetworkTable.queryRowsReports(
          types: ['INVOICE', 'PAY_IN_OUT'],
          fromDate: intl.DateFormat(dateFormat).parse(controllerFromDate.text).millisecondsSinceEpoch,
          toDate: intl.DateFormat(dateFormat).parse(controllerToDate.text).millisecondsSinceEpoch,
        );
        double cash = 0;
        double creditCard = 0;
        double visa = 0;
        double payIn = 0;
        double payOut = 0;
        for (var element in data) {
          if (element.type == 'PAY_IN_OUT') {
            var body = jsonDecode(element.body);
            if (body['PosNo'] == sharedPrefsClient.posNo && body['CashNo'] == sharedPrefsClient.cashNo) {
              if (body['VoucherType'] == 1) {
                payIn += body['VoucherValue'];
              } else if (body['VoucherType'] == 2) {
                payOut += body['VoucherValue'];
              }
            }
          } else if (element.type == 'INVOICE') {
            var body = jsonDecode(element.body);
            if (body['InvoiceMaster']['PosNo'] == sharedPrefsClient.posNo && body['InvoiceMaster']['CashNo'] == sharedPrefsClient.cashNo) {
              if (body['InvoiceMaster']['InvKind'] == 0) {
                cash += body['InvoiceMaster']['CashVal'];
                creditCard += body['InvoiceMaster']['CardsVal'];
                if (body['InvoiceMaster']['Card1Name'] == EnumCreditCardType.visa.name) {
                  visa += body['InvoiceMaster']['CardsVal'];
                }
              } else if (body['InvoiceMaster']['InvKind'] == 1) {
                cash -= body['InvoiceMaster']['CashVal'];
                creditCard -= body['InvoiceMaster']['CardsVal'];
                if (body['InvoiceMaster']['Card1Name'] == EnumCreditCardType.visa.name) {
                  visa -= body['InvoiceMaster']['CardsVal'];
                }
              }
            }
          }
        }
        buildWidget = Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          child: SingleChildScrollView(
            child: CustomDataTable(
              minWidth: 564.w,
              showCheckboxColumn: true,
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text('Cash'.tr)),
                    DataCell(Text(cash.toStringAsFixed(3))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Credit Card'.tr)),
                    DataCell(Text(creditCard.toStringAsFixed(3))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('***visa'.tr)),
                    DataCell(Text(visa.toStringAsFixed(3))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Pay In'.tr)),
                    DataCell(Text(payIn.toStringAsFixed(3))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Pay Out'.tr)),
                    DataCell(Text(payOut.toStringAsFixed(3))),
                  ],
                ),
              ],
              columns: [
                DataColumn(label: Text('Description'.tr)),
                DataColumn(label: Text('Value'.tr)),
              ],
            ),
          ),
        );
        break;
      case EnumReportType.cashInOutReport:
        List<NetworkTableModel> data = await NetworkTable.queryRowsReports(
          types: ['PAY_IN_OUT'],
          fromDate: intl.DateFormat(dateFormat).parse(controllerFromDate.text).millisecondsSinceEpoch,
          toDate: intl.DateFormat(dateFormat).parse(controllerToDate.text).millisecondsSinceEpoch,
        );
        buildWidget = Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          child: SingleChildScrollView(
            child: CustomDataTable(
              minWidth: 564.w,
              showCheckboxColumn: true,
              rows: data.map((e) {
                var body = jsonDecode(e.body);
                return DataRow(
                  cells: [
                    DataCell(Text(body['VoucherDate'].split('T').first)),
                    DataCell(Text(body['VoucherType'] == 1 ? 'Cash In'.tr : 'Cash Out'.tr)),
                    DataCell(Text(allDataModel.cashInOutTypesModel.firstWhereOrNull((element) => element.id == body['DescId'])?.description ?? '')),
                    DataCell(Text('${body['PosNo']}')),
                    DataCell(Text('${body['CashNo']}')),
                    DataCell(Text(body['VoucherTime'])),
                    DataCell(Text(allDataModel.employees.firstWhereOrNull((element) => element.id == body['UserId'])?.empName ?? '')),
                    DataCell(Text(body['VoucherValue'].toStringAsFixed(3))),
                    DataCell(Text(body['Remark'])),
                  ],
                );
              }).toList(),
              columns: [
                DataColumn(label: Text('Date'.tr)),
                DataColumn(label: Text('Type'.tr)),
                DataColumn(label: Text('Description'.tr)),
                DataColumn(label: Text('Pos No'.tr)),
                DataColumn(label: Text('Cash No'.tr)),
                DataColumn(label: Text('Time'.tr)),
                DataColumn(label: Text('Employee'.tr)),
                DataColumn(label: Text('Value'.tr)),
                DataColumn(label: Text('Remark'.tr)),
              ],
            ),
          ),
        );
        break;
      case EnumReportType.soldQtyReport:
        List<NetworkTableModel> data = await NetworkTable.queryRowsReports(
          types: ['INVOICE'],
          fromDate: intl.DateFormat(dateFormat).parse(controllerFromDate.text).millisecondsSinceEpoch,
          toDate: intl.DateFormat(dateFormat).parse(controllerToDate.text).millisecondsSinceEpoch,
        );
        List<ReportSoldQtyModel> items = [];
        for (var element in data) {
          var body = jsonDecode(element.body);
          if (body['InvoiceMaster']['PosNo'] == sharedPrefsClient.posNo && body['InvoiceMaster']['CashNo'] == sharedPrefsClient.cashNo) {
            for (var invoiceDetails in body['InvoiceDetails']) {
              var indexItem = items.indexWhere((e) => e.itemId == invoiceDetails['ItemId']);
              if (indexItem != -1) {
                if (body['InvoiceMaster']['InvKind'] == 0) {
                  items[indexItem].soldQty += invoiceDetails['Qty'];
                  items[indexItem].disc += invoiceDetails['InvDisc'] + invoiceDetails['LineDisc'];
                  items[indexItem].serviceValue += invoiceDetails['ServiceVal'];
                  items[indexItem].itemTax += invoiceDetails['ItemTaxVal'];
                  items[indexItem].totalNoTaxAndService +=
                      invoiceDetails['NetTotal'] - (invoiceDetails['ItemTaxVal'] - invoiceDetails['ServiceVal'] - invoiceDetails['ServiceTax']);
                  items[indexItem].totalNoTax += invoiceDetails['NetTotal'] - invoiceDetails['ItemTaxVal'];
                  items[indexItem].netTotal += invoiceDetails['NetTotal'];
                } else if (body['InvoiceMaster']['InvKind'] == 1) {
                  items[indexItem].soldQty -= invoiceDetails['Qty'];
                  items[indexItem].disc -= invoiceDetails['InvDisc'] + invoiceDetails['LineDisc'];
                  items[indexItem].serviceValue -= invoiceDetails['ServiceVal'];
                  items[indexItem].itemTax -= invoiceDetails['ItemTaxVal'];
                  items[indexItem].totalNoTaxAndService -=
                      invoiceDetails['NetTotal'] - (invoiceDetails['ItemTaxVal'] - invoiceDetails['ServiceVal'] - invoiceDetails['ServiceTax']);
                  items[indexItem].totalNoTax -= invoiceDetails['NetTotal'] - invoiceDetails['ItemTaxVal'];
                  items[indexItem].netTotal -= invoiceDetails['NetTotal'];
                }
              } else {
                var itemInAllData = allDataModel.items.firstWhereOrNull((e) => e.id == invoiceDetails['ItemId']);
                if (body['InvoiceMaster']['InvKind'] == 0) {
                  items.add(ReportSoldQtyModel(
                    itemId: invoiceDetails['ItemId'],
                    itemName: itemInAllData?.menuName ?? '',
                    categoryName: itemInAllData?.category.categoryName ?? '',
                    soldQty: invoiceDetails['Qty'],
                    disc: invoiceDetails['InvDisc'] + invoiceDetails['LineDisc'],
                    serviceValue: invoiceDetails['ServiceVal'],
                    itemTax: invoiceDetails['ItemTaxVal'],
                    totalNoTaxAndService: invoiceDetails['NetTotal'] - (invoiceDetails['ItemTaxVal'] - invoiceDetails['ServiceVal'] - invoiceDetails['ServiceTax']),
                    totalNoTax: invoiceDetails['NetTotal'] - invoiceDetails['ItemTaxVal'],
                    netTotal: invoiceDetails['NetTotal'],
                  ));
                } else if (body['InvoiceMaster']['InvKind'] == 1) {
                  items.add(ReportSoldQtyModel(
                    itemId: invoiceDetails['ItemId'],
                    itemName: itemInAllData?.menuName ?? '',
                    categoryName: itemInAllData?.category.categoryName ?? '',
                    soldQty: invoiceDetails['Qty'] * -1,
                    disc: (invoiceDetails['InvDisc'] + invoiceDetails['LineDisc']) * -1,
                    serviceValue: invoiceDetails['ServiceVal'] * -1,
                    itemTax: invoiceDetails['ItemTaxVal'] * -1,
                    totalNoTaxAndService: (invoiceDetails['NetTotal'] - (invoiceDetails['ItemTaxVal'] - invoiceDetails['ServiceVal'] - invoiceDetails['ServiceTax'])) * -1,
                    totalNoTax: (invoiceDetails['NetTotal'] - invoiceDetails['ItemTaxVal']) * -1,
                    netTotal: invoiceDetails['NetTotal'] * -1,
                  ));
                }
              }
            }
          }
        }
        double soldQty = 0;
        double disc = 0;
        double serviceValue = 0;
        double itemTax = 0;
        double totalNoTaxAndService = 0;
        double totalNoTax = 0;
        double netTotal = 0;
        for (var item in items) {
          soldQty += item.soldQty;
          disc += item.disc;
          serviceValue += item.serviceValue;
          itemTax += item.itemTax;
          totalNoTaxAndService += item.totalNoTaxAndService;
          totalNoTax += item.totalNoTax;
          netTotal += item.netTotal;
        }
        buildWidget = Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          child: SingleChildScrollView(
            child: CustomDataTable(
              minWidth: 564.w,
              showCheckboxColumn: true,
              rows: [
                ...items
                    .where((e) => e.soldQty != 0)
                    .map((e) => DataRow(
                          cells: [
                            DataCell(Text(e.itemName)),
                            DataCell(Text(e.categoryName)),
                            DataCell(Text(e.soldQty.toStringAsFixed(3))),
                            DataCell(Text(e.disc.toStringAsFixed(3))),
                            DataCell(Text(e.serviceValue.toStringAsFixed(3))),
                            DataCell(Text(e.itemTax.toStringAsFixed(3))),
                            DataCell(Text(e.totalNoTaxAndService.toStringAsFixed(3))),
                            DataCell(Text(e.totalNoTax.toStringAsFixed(3))),
                            DataCell(Text(e.netTotal.toStringAsFixed(3))),
                          ],
                        ))
                    .toList(),
                DataRow(
                  cells: [
                    const DataCell(Text('')),
                    DataCell(Text(
                      'Totals'.tr,
                      style: kStyleHeaderTable,
                    )),
                    DataCell(Text(soldQty.toStringAsFixed(3))),
                    DataCell(Text(disc.toStringAsFixed(3))),
                    DataCell(Text(serviceValue.toStringAsFixed(3))),
                    DataCell(Text(itemTax.toStringAsFixed(3))),
                    DataCell(Text(totalNoTaxAndService.toStringAsFixed(3))),
                    DataCell(Text(totalNoTax.toStringAsFixed(3))),
                    DataCell(Text(netTotal.toStringAsFixed(3))),
                  ],
                )
              ],
              columns: [
                DataColumn(label: Text('Item Name'.tr)),
                DataColumn(label: Text('Category Name'.tr)),
                DataColumn(label: Text('Sold Qty'.tr)),
                DataColumn(label: Text('Disc'.tr)),
                DataColumn(label: Text('Service Value'.tr)),
                DataColumn(label: Text('Item Tax'.tr)),
                DataColumn(label: Text('Total No Tax and Service'.tr)),
                DataColumn(label: Text('Total No Tax'.tr)),
                DataColumn(label: Text('Net Total'.tr)),
              ],
            ),
          ),
        );
        break;
      default:
        buildWidget = Container();
        break;
    }
    update();
  }
}
