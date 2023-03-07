import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/config/enum/enum_report_type.dart';
import 'package:retail_system/config/validation.dart';
import 'package:retail_system/controllers/report_controller.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class ReportScreen extends GetResponsiveView {
  final EnumReportType type;

  ReportScreen({super.key, required this.type});

  final _controller = ReportController.to;

  @override
  StatelessElement createElement() {
    _controller.init(type);
    return super.createElement();
  }

  _buildWidget() {
    return CustomWidget(
      appBar: AppBar(
        title: Text(type.name.tr),
      ),
      child: GetBuilder<ReportController>(
        builder: (controller) => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    controller: _controller.controllerFromDate,
                    label: Text('From Date'.tr),
                    textDirection: TextDirection.ltr,
                    readOnly: true,
                    validator: (value) {
                      return Validation.isRequired(value);
                    },
                    onTap: () async {
                      _controller.selectFromDate();

                    },
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    controller: _controller.controllerToDate,
                    label: Text('To Date'.tr),
                    textDirection: TextDirection.ltr,
                    readOnly: true,
                    validator: (value) {
                      return Validation.isRequired(value);
                    },
                    onTap: () async {
                      _controller.selectToDate();

                    },
                  ),
                ),
                CustomButton(
                  margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  fixed: true,
                  onPressed: () {
                    _controller.init(type);
                  },
                  child: Text('Submit'.tr),
                ),
              ],
            ),
            Expanded(child: _controller.buildWidget),
          ],
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
