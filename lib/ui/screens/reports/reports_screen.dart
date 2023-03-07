import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/config/enum/enum_report_type.dart';
import 'package:retail_system/ui/screens/reports/report_screen.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class ReportsScreen extends GetResponsiveView {
  ReportsScreen({super.key});

  _buildWidget(){
    return CustomWidget(
      appBar: AppBar(
        title: Text('Reports'.tr),
      ),
      child: CustomSingleChildScrollView(
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          children: [
            Padding(
              padding: EdgeInsets.all(2.w),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ReportScreen(type: EnumReportType.cashReport));
                },
                child: Card(
                  color: AppColor.grayLight,
                  shadowColor: AppColor.grayLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 2.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          size: 50.sp,
                        ),
                        Center(
                          child: Text(
                            'Cash Report'.tr,
                            style: kStyleTextTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2.w),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ReportScreen(type: EnumReportType.cashInOutReport));
                },
                child: Card(
                  color: AppColor.grayLight,
                  shadowColor: AppColor.grayLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 2.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.money,
                          size: 50.sp,
                        ),
                        Center(
                          child: Text(
                            'Cash In / Out Report'.tr,
                            style: kStyleTextTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2.w),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ReportScreen(type: EnumReportType.soldQtyReport));
                },
                child: Card(
                  color: AppColor.grayLight,
                  shadowColor: AppColor.grayLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 2.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.money,
                          size: 50.sp,
                        ),
                        Center(
                          child: Text(
                            'Sold Qty Report'.tr,
                            style: kStyleTextTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
