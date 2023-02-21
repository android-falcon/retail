import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:retail_system/config/app_color.dart';
import 'package:retail_system/config/constant.dart';
import 'package:retail_system/config/enum/enum_credit_card_type.dart';
import 'package:retail_system/config/text_input_formatters.dart';
import 'package:retail_system/config/utils.dart';
import 'package:retail_system/config/validation.dart';
import 'package:retail_system/ui/widgets/custom_widget.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

  final TextEditingController controllerSearch = TextEditingController();

  addItem() {}

  deleteItem() {}

  editItem() {}

  double _calculateRemaining() {
    return cart.amountDue - (cart.cash + cart.credit + cart.cheque + cart.gift + cart.coupon + cart.point);
  }

  paymentMethodDialog() {
    double remaining = _calculateRemaining();
    Get.dialog(
      CustomDialog(
        builder: (context, setState, constraints) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              Text(
                '${'Date'.tr} : ${intl.DateFormat(dateFormat).format(sharedPrefsClient.dailyClose)}',
                style: kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${'Remaining'.tr} : ${remaining.toStringAsFixed(fractionDigits)}',
                style: kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 35.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () async {
                        var result = await paymentDialog(
                          balance: remaining + cart.cash,
                          received: cart.cash,
                          enableReturnValue: true,
                        );
                        cart.cash = result['received'];
                        remaining = _calculateRemaining();
                        setState(() {});
                        // if (remaining == 0) {
                        //   _showFinishDialog();
                        // }
                      },
                      child: Text('${'Cash'.tr} : ${cart.cash.toStringAsFixed(fractionDigits)}'),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: CustomButton(
                      onPressed: () async {
                        var result = await paymentDialog(
                          balance: remaining + cart.credit,
                          received: cart.credit,
                          enableReturnValue: false,
                          controllerCreditCard: TextEditingController(text: cart.creditCardNumber),
                          paymentCompany: cart.payCompanyId == 0 ? null : cart.payCompanyId,
                        );
                        cart.credit = result['received'];
                        cart.creditCardNumber = result['credit_card'];
                        cart.creditCardType = result['credit_card_type'];
                        cart.payCompanyId = result['payment_company'];
                        remaining = _calculateRemaining();
                        setState(() {});
                        // if (remaining == 0) {
                        //   _showFinishDialog();
                        // }
                      },
                      child: Text('${'Credit Card'.tr} : ${cart.credit.toStringAsFixed(fractionDigits)}'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.only(top: 8.w, left: 14.w, right: 14.w, bottom: 16.w),
                decoration: BoxDecoration(
                  color: AppColor.accentColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    CustomIconText(
                      bold: true,
                      label: '${'Total'.tr} : ${cart.total.toStringAsFixed(fractionDigits)}',
                    ),
                    CustomIconText(
                      bold: true,
                      label: '${'Delivery charge'.tr} : ${cart.deliveryCharge.toStringAsFixed(fractionDigits)}',
                    ),
                    CustomIconText(
                      bold: true,
                      label: '${'Line discount'.tr} : ${cart.totalLineDiscount.toStringAsFixed(fractionDigits)}',
                    ),
                    CustomIconText(
                      bold: true,
                      label: '${'Discount'.tr} : ${cart.totalDiscount.toStringAsFixed(fractionDigits)}',
                    ),
                    CustomIconText(
                      bold: true,
                      label: '${'Sub total'.tr} : ${cart.subTotal.toStringAsFixed(fractionDigits)}',
                    ),
                    CustomIconText(
                      bold: true,
                      label: '${'Service'.tr} : ${cart.service.toStringAsFixed(fractionDigits)}',
                    ),
                    CustomIconText(
                      bold: true,
                      label: '${'Tax'.tr} : ${cart.tax.toStringAsFixed(fractionDigits)}',
                    ),
                    CustomIconText(
                      bold: true,
                      label: '${'Amount Due'.tr} : ${cart.amountDue.toStringAsFixed(fractionDigits)}',
                    ),
                    const Divider(),
                    CustomIconText(
                      bold: true,
                      label: '${'Total Due'.tr} : ${cart.amountDue.toStringAsFixed(fractionDigits)}',
                    ),
                    CustomIconText(
                      bold: true,
                      label: '${'Total received'.tr} : ${(cart.cash + cart.credit + cart.cheque + cart.gift + cart.coupon + cart.point).toStringAsFixed(fractionDigits)}',
                    ),
                    CustomIconText(
                      bold: true,
                      label: '${'Balance'.tr} : ${remaining.toStringAsFixed(fractionDigits)}',
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
                      backgroundColor: Colors.white,
                      fixed: true,
                      onPressed: () {
                        if (remaining == 0) {
                          // finish
                        }
                        Get.back();
                      },
                      child: Text(
                        'Save'.tr,
                        style: TextStyle(color: AppColor.tertiaryColor),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  paymentDialog({TextEditingController? controllerReceived, required double balance, required double received, bool enableReturnValue = false, TextEditingController? controllerCreditCard, int? paymentCompany}) async {
    GlobalKey<FormState> keyForm = GlobalKey<FormState>();
    if (controllerCreditCard != null && received == 0) {
      controllerReceived ??= TextEditingController(text: balance.toStringAsFixed(fractionDigits));
    } else {
      controllerReceived ??= TextEditingController(text: received.toStringAsFixed(fractionDigits));
    }

    if (controllerReceived.text.endsWith('.000')) {
      controllerReceived.text = controllerReceived.text.replaceFirst('.000', '');
    }
    EnumCreditCardType selectedCreditCard = EnumCreditCardType.visa;
    int? selectedPaymentCompany;
    if (paymentCompany != null) {
      selectedPaymentCompany = paymentCompany;
    }
    TextEditingController controllerSelected = controllerReceived;
    var result = await Get.dialog(
      CustomDialog(
        builder: (context, setState, constraints) => Form(
          key: keyForm,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        controllerReceived!.text = balance.toStringAsFixed(fractionDigits);
                      },
                      child: Text(
                        '${'Balance'.tr} : ${balance.toStringAsFixed(fractionDigits)}',
                        style: kStyleTextTitle.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (controllerCreditCard != null)
                      Column(
                        children: [
                          CustomDropDown(
                            isExpanded: true,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            hint: 'Payment Company'.tr,
                            items: allDataModel.paymentCompanyModel
                                .map((e) => DropdownMenuItem(
                                      value: e.id,
                                      child: Text(e.coName),
                                    ))
                                .toList(),
                            selectItem: selectedPaymentCompany,
                            onChanged: (value) {
                              selectedPaymentCompany = value as int;
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Flexible(
                                child: RadioListTile(
                                  value: EnumCreditCardType.visa,
                                  groupValue: selectedCreditCard,
                                  dense: true,
                                  title: Text('Visa'.tr),
                                  onChanged: (value) {
                                    selectedCreditCard = value as EnumCreditCardType;
                                    setState(() {});
                                  },
                                ),
                              ),
                              Flexible(
                                child: RadioListTile(
                                  value: EnumCreditCardType.mastercard,
                                  groupValue: selectedCreditCard,
                                  dense: true,
                                  title: Text('Master card'.tr),
                                  onChanged: (value) {
                                    selectedCreditCard = value as EnumCreditCardType;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            margin: EdgeInsets.symmetric(horizontal: 10.h),
                            controller: controllerReceived,
                            label: Text('Received'.tr),
                            fillColor: Colors.white,
                            maxLines: 1,
                            inputFormatters: [
                              EnglishDigitsTextInputFormatter(decimal: true),
                            ],
                            enableInteractiveSelection: false,
                            keyboardType: const TextInputType.numberWithOptions(),
                            borderColor: controllerSelected == controllerReceived ? AppColor.primaryColor : null,
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              controllerSelected = controllerReceived!;
                              setState(() {});
                            },
                            validator: (value) {
                              if (!enableReturnValue) {
                                if (double.parse(value!) > double.parse(balance.toStringAsFixed(fractionDigits))) {
                                  return '${'The entered value cannot be greater than the balance'.tr} (${balance.toStringAsFixed(fractionDigits)})';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        if (controllerCreditCard != null)
                          Expanded(
                            child: CustomTextField(
                              margin: EdgeInsets.symmetric(horizontal: 10.h),
                              controller: controllerCreditCard,
                              label: Text('Card Number'.tr),
                              fillColor: Colors.white,
                              maxLines: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CardNumberFormatter(),
                              ],
                              enableInteractiveSelection: false,
                              keyboardType: const TextInputType.numberWithOptions(),
                              borderColor: controllerSelected == controllerCreditCard ? AppColor.primaryColor : null,
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                controllerSelected = controllerCreditCard;
                                setState(() {});
                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Utils.numPadWidget(
                controllerSelected,
                setState,
                decimal: false,
                onSubmit: () {
                  if (keyForm.currentState!.validate()) {
                    if (controllerCreditCard != null && selectedPaymentCompany == null && controllerReceived!.text != '0') {
                      Utils.showSnackbar('', 'Please select a payment company'.tr);
                    } else {
                      Get.back(result: controllerReceived!.text);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    double _received = result == null ? received : double.parse(result);
    if ((_received - double.parse(balance.toStringAsFixed(3))) == 0) {
      _received = balance;
    } else if (enableReturnValue && _received > balance) {
      await Get.dialog(
        CustomDialog(
          builder: (context, setState, constraints) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 80.h),
                  child: Text(
                    '${'Please return this value'.tr} :    ${(_received - balance).toStringAsFixed(3)}',
                    style: kStyleTextTitle,
                  ),
                ),
                CustomButton(
                  fixed: true,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
                  child: Text(
                    'Done'.tr,
                    style: kStyleButtonPayment,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
      _received = balance;
    }
    return {"received": _received, "credit_card": controllerCreditCard?.text ?? "", "credit_card_type": selectedCreditCard.name, 'payment_company': selectedPaymentCompany};
  }
}
