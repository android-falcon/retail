import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/controllers/history_pay_in_out_controller.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class HistoryPayInOutScreen extends GetResponsiveView {
  HistoryPayInOutScreen({super.key});

  final _controller = HistoryPayInOutController.to;

  @override
  StatelessElement createElement() {
    _controller.init();
    return super.createElement();
  }

  _buildWidget() {
    return CustomWidget(
      alignment: Alignment.topCenter,
      appBar: AppBar(
        title: Text('History pay In / Out'.tr),
      ),
      child: GetBuilder<HistoryPayInOutController>(
        builder: (controller) => CustomSingleChildScrollView(
          child: CustomDataTable(
            minWidth: 564.w,
            showCheckboxColumn: true,
            rows: _controller.data.map((e) {
              return DataRow(
                cells: [
                  DataCell(
                    const Icon(Icons.delete),
                    onTap: () async {
                      _controller.deletePayInOut(model: e);
                    },
                  ),
                  DataCell(Text(intl.DateFormat(Constant.dateFormat).format(e.voucherDate))),
                  DataCell(Text(e.voucherType == 1 ? 'Cash In'.tr : 'Cash Out'.tr)),
                  DataCell(Text(Constant.allDataModel.cashInOutTypesModel.firstWhereOrNull((element) => element.id == e.descId)?.description ?? '')),
                  DataCell(Text('${e.posNo}')),
                  DataCell(Text('${e.cashNo}')),
                  DataCell(Text(e.voucherTime)),
                  DataCell(Text(Constant.allDataModel.employees.firstWhereOrNull((element) => element.id == e.userId)?.empName ?? '')),
                  DataCell(Text(e.voucherValue.toStringAsFixed(3))),
                  DataCell(Text(e.remark)),
                ],
              );
            }).toList(),
            columns: [
              DataColumn(label: Text('Action'.tr)),
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
      ),
    );
  }

  @override
  Widget desktop() {
    return _buildWidget();
  }

  @override
  Widget tablet() {
    return _buildWidget();
  }

  @override
  Widget phone() {
    return _buildWidget();
  }

  @override
  Widget watch() {
    return _buildWidget();
  }
}
