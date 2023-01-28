import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retail_system/ui/screens/tocopyfrom/_widgets.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class Screen extends GetResponsiveView {
  Screen({super.key});

  _buildWidget(){
    return CustomWidget(
      child: CustomSingleChildScrollView(
        child: Container(),
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
