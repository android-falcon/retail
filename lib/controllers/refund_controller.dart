import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:retail_system/config/enum/enum_invoice_kind.dart';
import 'package:retail_system/config/text_input_formatters.dart';
import 'package:retail_system/config/utils.dart';
import 'package:retail_system/config/validation.dart';
import 'package:retail_system/models/cart_model.dart';
import 'package:retail_system/networks/rest_api.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class RefundController extends GetxController {
  static RefundController get to => Get.isRegistered<RefundController>() ? Get.find<RefundController>() : Get.put(RefundController());

  final keyForm = GlobalKey<FormState>();
  final controllerInvoiceNo = TextEditingController();
  final controllerPosNo = TextEditingController();
  final refundModel = Rxn<CartModel>();

  saveRefund() async {
    var result = await Utils.showAreYouSureDialog(title: 'Refund'.tr);
    if (result) {
      if (refundModel.value!.items.any((element) => element.returnedQty > 0)) {
        refundModel.value!.items.removeWhere((element) => element.returnedQty == 0);
        RestApi.invoice(cart: refundModel.value!, invoiceKind: EnumInvoiceKind.invoiceReturn);
        RestApi.returnInvoiceQty(invNo: int.parse(controllerInvoiceNo.text), refundModel: refundModel.value!);
        Get.back();
      }
    }
  }

  searchInvoice() async {
    if (keyForm.currentState!.validate()) {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
      refundModel.value = await RestApi.getRefundInvoice(invNo: int.parse(controllerInvoiceNo.text));
      refundModel.value = Utils.calculateOrder(cart: refundModel.value!, invoiceKind: EnumInvoiceKind.invoiceReturn);
      update();
    }
  }

  changeRetQty({required int index}) async {
    refundModel.value!.items[index].returnedQty = await _showQtyDialog(
      decimal: false,
      rQty: refundModel.value!.items[index].returnedQty,
      maxQty: refundModel.value!.items[index].qty,
    );
    refundModel.value = Utils.calculateOrder(cart: refundModel.value!, invoiceKind: EnumInvoiceKind.invoiceReturn);
    update();
  }

  Future<double> _showQtyDialog({TextEditingController? controller, double? maxQty, double minQty = 0, required double rQty, bool decimal = true}) async {
    GlobalKey<FormState> keyForm = GlobalKey<FormState>();
    controller ??= TextEditingController(text: '${decimal ? rQty : rQty.toInt()}');
    var qty = await Get.dialog(
      CustomDialog(
        builder: (context, setState, constraints) => Form(
          key: keyForm,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.sp),
                child: CustomTextField(
                  controller: controller,
                  label: Text('${'Qty'.tr} ${maxQty != null ? '($maxQty)' : ''}'),
                  fillColor: Colors.white,
                  maxLines: 1,
                  inputFormatters: [
                    EnglishDigitsTextInputFormatter(decimal: true),
                  ],
                  validator: (value) {
                    return Validation.qty(value, minQty: minQty, maxQty: maxQty);
                  },
                  enableInteractiveSelection: false,
                  keyboardType: const TextInputType.numberWithOptions(),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ),
              Utils.numPadWidget(
                controller,
                setState,
                decimal: decimal,
                onSubmit: () {
                  if (keyForm.currentState!.validate()) {
                    Get.back(result: controller!.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    if (qty == null) {
      return rQty;
    }
    return double.parse(qty);
  }
}
