import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final double minWidth;
  final double? dataRowHeight;
  final double? headingRowHeight;
  final List<DataRow> rows;
  final List<DataColumn> columns;
  final bool showCheckboxColumn;

  const CustomDataTable({
    Key? key,
    this.minWidth = 0.0,
    this.dataRowHeight,
    this.headingRowHeight,
    this.showCheckboxColumn = false,
    required this.rows,
    required this.columns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: DataTable(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(3),
          ),
          showCheckboxColumn: showCheckboxColumn,
          dataRowHeight: dataRowHeight ?? 30,
          headingRowHeight: headingRowHeight ?? 30,
          // columnSpacing: 0,
          headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red),
          dataTextStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.black),
          rows: rows,
          columns: columns,
        ),
      ),
    );
  }
}
