import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return ScopedModel<InvoiceViewModel>(
      model: _model,
      child: ScopedModelDescendant<InvoiceViewModel>(
        builder: (context, child, model) {
          if (model.pageUnpaidType == PageUnpaidInvoice.LIST) {
            return Material(
              color: AppColor.TRANSPARENT,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: PagePaymentRequestMerchantWidget(
                onPop: widget.onPop,
                merchantId: widget.merchantId,
              ),
            );
          } else {
            // return AlertDialog(
            //     color: AppColor.TRANSPARENT,
            //     child: PagePaymentRequestWidget(onPop: widget.onPop));
            if (model.currentSelectUnpaidInvoiceItem != null) {
              return Material(
                color: AppColor.TRANSPARENT,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: PagePaymentRequestWidget(
                  onPop: widget.onPop,
                  dto: model.currentSelectUnpaidInvoiceItem!,
                ),
              );
            } else
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
// PagePaymentRequestMerchantWidget(
//                     onPop: widget.onPop,
//                     merchantId: widget.merchantId,
//                   ),
//                   PagePaymentRequestWidget(onPop: widget.onPop)