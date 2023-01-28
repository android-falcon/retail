import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

typedef SelectedCallBack = Function(String id, bool newSelectState);

class CustomDataTableAdvanced extends StatefulWidget {
  int rowsPerPage;
  AdvancedDataTableSource<dynamic> source;
  List<DataColumn> columns;

  CustomDataTableAdvanced({
    super.key,
    required this.source,
    required this.columns,
    this.rowsPerPage = AdvancedPaginatedDataTable.defaultRowsPerPage,
  });

  @override
  State<CustomDataTableAdvanced> createState() => _CustomDataTableAdvancedState();
}

class _CustomDataTableAdvancedState extends State<CustomDataTableAdvanced> {
  @override
  Widget build(BuildContext context) {
    return AdvancedPaginatedDataTable(
      addEmptyRows: false,
      source: widget.source,
      showHorizontalScrollbarAlways: true,
      showFirstLastButtons: true,
      rowsPerPage: widget.rowsPerPage,
      availableRowsPerPage: const [10, 20, 30, 50],
      onRowsPerPageChanged: (newRowsPerPage) {
        if (newRowsPerPage != null) {
          setState(() {
            widget.rowsPerPage = newRowsPerPage;
          });
        }
      },
      columns: widget.columns,
      getFooterRowText: (startRow, pageSize, totalFilter, totalRowsWithoutFilter) {
        final localizations = MaterialLocalizations.of(context);
        var amountText = localizations.pageRowsInfoTitle(
          startRow,
          pageSize,
          totalFilter ?? totalRowsWithoutFilter,
          false,
        );

        if (totalFilter != null) {
          //Filtered data source show addtional information
          amountText += ' filtered from ($totalRowsWithoutFilter)';
        }

        return amountText;
      },
    );
  }
}

DataCell kActionCell({void Function()? onInfo, void Function()? onEdit, void Function()? onDelete}) => DataCell(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onInfo != null)
            CustomButton(
              backgroundColor: AppColor.gray2,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              fixed: true,
              onPressed: onInfo,
              child: Text(
                'Info'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          if (onEdit != null)
            CustomButton(
              backgroundColor: AppColor.blue,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              fixed: true,
              onPressed: onEdit,
              child: Text(
                'Edit'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          if (onDelete != null)
            CustomButton(
              backgroundColor: AppColor.red,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              fixed: true,
              onPressed: onDelete,
              child: Text(
                'Delete'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
