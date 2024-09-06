import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/page_payment_request_merchant_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/page_payment_request_widget.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class PopupPaymentRequestMerchantWidget extends StatefulWidget {
  final String merchantId;
  final Function(String) onPop;
  const PopupPaymentRequestMerchantWidget(
      {super.key, required this.onPop, required this.merchantId});

  @override
  State<PopupPaymentRequestMerchantWidget> createState() =>
      _PopupPaymentRequestMerchantWidgetState();
}

class _PopupPaymentRequestMerchantWidgetState
    extends State<PopupPaymentRequestMerchantWidget> {
  late InvoiceViewModel _model;
  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: ScopedModel<InvoiceViewModel>(
          model: _model,
          child: ScopedModelDescendant<InvoiceViewModel>(
            builder: (context, child, model) {
              // return PageView(
              //   controller: _model.pageController,
              //   physics: const NeverScrollableScrollPhysics(),
              //   onPageChanged: (value) {
              //     _model.updatePagePopupUnpaid(value);
              //   },
              //   children: [
              //     PagePaymentRequestMerchantWidget(
              //       onPop: widget.onPop,
              //       merchantId: widget.merchantId,
              //     ),
              //     PagePaymentRequestWidget(onPop: widget.onPop)
              //   ],
              // );
              return PageView.builder(
                controller: _model.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) {
                  _model.updatePagePopupUnpaid(value);
                },
                itemCount: 2, // Number of pages
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return PagePaymentRequestMerchantWidget(
                        onPop: widget.onPop,
                        merchantId: widget.merchantId,
                      );
                    case 1:
                      return PagePaymentRequestWidget(onPop: widget.onPop);
                    default:
                      return const SizedBox
                          .shrink(); // Return an empty widget if index is out of range
                  }
                },
              );
            },
          )),
    );
  }
}
