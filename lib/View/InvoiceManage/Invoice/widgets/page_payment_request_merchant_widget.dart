import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/popup_unpaid_qr_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/InvoiceCreate/widgets/item_title_widget.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/models/DTO/invoice_detail_dto.dart';

import 'bank_account_item.dart';

class PagePaymentRequestMerchantWidget extends StatefulWidget {
  final String merchantId;
  final Function(String) onPop;
  const PagePaymentRequestMerchantWidget({
    super.key,
    required this.onPop,
    required this.merchantId,
  });

  @override
  State<PagePaymentRequestMerchantWidget> createState() =>
      _PagePaymentRequestMerchantWidgetState();
}

class _PagePaymentRequestMerchantWidgetState
    extends State<PagePaymentRequestMerchantWidget> {
  late InvoiceViewModel _model;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    // _model.getInvoiceDetail(widget.dto.invoiceId);
    _model.getUnpaidInvoiceList(
        page: 1, size: 20, merchantId: widget.merchantId);
    _model.getListRequestPayment();
    // ignore: unnecessary_null_comparison

    _model.clearTotalUnpaidInvoice();
  }

  @override
  void dispose() {
    super.dispose();
    _model.pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: AppColor.WHITE,
        width: 1150,
        height: 750,
        padding: const EdgeInsets.all(20),
        child: ScopedModel<InvoiceViewModel>(
            model: _model,
            child: ScopedModelDescendant<InvoiceViewModel>(
              builder: (context, child, model) {
                for (var e in _model.listPaymentRequest) {
                  if (e.isChecked) _model.updateBankIdRecharge(e.bankId);
                }
                bool isEnable = false;
                if (model.listUnpaidSelectInvoice.isNotEmpty) {
                  isEnable = model.listUnpaidSelectInvoice
                          .any((x) => x.isSelect == true) &&
                      model.paymentUnpaidRequest.invoiceIds.isNotEmpty &&
                      model.listPaymentRequest.any(
                        (x) => x.isChecked == true,
                      );
                }
                if (model.unpaidInvoiceDTO?.items == null) {
                  return const SizedBox.shrink();
                }
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tạo mã VietQR để yêu cầu thanh toán',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Danh sách hóa đơn chưa thanh toán',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        _buildUnpaidInvoiceWidget(),
                        const SizedBox(
                          height: 50,
                        ),
                        _buildTotal(),
                        const SizedBox(height: 50),
                        // ignore: unnecessary_null_comparison
                        if (model.listPaymentRequest != null)
                          _buildReqPayment(model.listPaymentRequest, isEnable),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                );
              },
            )),
      ),
    );
  }

  Widget _buildTotal() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        return Row(
          children: [
            const Text(
              'Tổng tiền (VND):',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              StringUtils.formatNumberWithOutVND(model.totalUnpaidInvoice),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColor.GREEN),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  Widget _buildReqPayment(List<PaymentRequestDTO> listReq, bool isEnable) {
    return ScopedModelDescendant<InvoiceViewModel>(
        builder: (context, child, model) {
      return Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tài khoản nhận tiền',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return SelectBankRecieveItem(
                          dto: listReq[index],
                          onChange: (value) {
                            _model.selectPaymentRequest(index);
                            for (var e in listReq) {
                              if (e.isChecked) {
                                _model.updateBankIdRecharge(e.bankId);
                              }
                            }
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 20),
                      itemCount: listReq.length),
                ),
              ],
            ),
          ),
          MButtonWidget(
            colorDisableBgr: AppColor.GREY_DADADA,
            width: 350,
            height: 50,
            title: 'Yêu cầu thanh toán',
            isEnable: isEnable,
            margin: EdgeInsets.zero,
            onTap: isEnable
                ? () async {
                    final result = await _model.requestPaymentV2(
                        request: _model.paymentUnpaidRequest);
                    if (result != null) {
                      if (!mounted) return;
                      Navigator.of(context).pop();
                      await showDialog(
                        context: context,
                        builder: (context) => PopupUnpaidQrCodeInvoice(
                          onPop: widget.onPop,
                        ),
                      );
                    }
                  }
                : null,
          ),
        ],
      );
    });
  }

  Widget _buildUnpaidInvoiceWidget() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading) {
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }
        if (model.unpaidInvoiceDTO?.items == null) {
          return const SizedBox.shrink();
        }
        bool isAllApplied = model.listUnpaidSelectInvoice
            .every((element) => element.isSelect == true);
        return Expanded(
          child: CustomScrollView(
            controller: scrollController,
            shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                child: RepaintBoundary(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: AppColor.GREY_DADADA, width: 1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 100,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Checkbox(
                                    activeColor: AppColor.BLUE_TEXT,
                                    value: isAllApplied,
                                    onChanged: (value) {
                                      model.appliedAllUnpaidItem(value!);
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: BorderSide(
                                            color: AppColor.GREY_TEXT
                                                .withOpacity(0.3))),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Tất cả',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            const BuildItemlTitle(
                                title: 'STT',
                                textAlign: TextAlign.center,
                                width: 50,
                                height: 50,
                                alignment: Alignment.centerLeft),
                            const BuildItemlTitle(
                                title: 'Hóa đơn',
                                textAlign: TextAlign.center,
                                width: 200,
                                height: 50,
                                alignment: Alignment.centerLeft),
                            const BuildItemlTitle(
                                title: 'Mã hóa đơn',
                                height: 50,
                                width: 150,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(right: 4),
                                textAlign: TextAlign.center),
                            const BuildItemlTitle(
                                title: 'Tổng tiền (VND)',
                                height: 50,
                                width: 150,
                                alignment: Alignment.centerLeft,
                                textAlign: TextAlign.center),
                            const BuildItemlTitle(
                                title: 'VSO',
                                height: 50,
                                width: 120,
                                alignment: Alignment.centerLeft,
                                textAlign: TextAlign.center),
                            const BuildItemlTitle(
                                title: 'Chưa TT(VND)',
                                height: 50,
                                width: 150,
                                alignment: Alignment.centerLeft,
                                textAlign: TextAlign.center),
                            const BuildItemlTitle(
                                title: 'Đã TT(VND)',
                                height: 50,
                                width: 100,
                                alignment: Alignment.centerLeft,
                                textAlign: TextAlign.center),
                            const BuildItemlTitle(
                                title: 'Thao tác',
                                height: 50,
                                width: 80,
                                alignment: Alignment.centerLeft,
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: AppColor.GREY_DADADA, width: 1),
                        ),
                      ),
                      child: _invoiceItemWidget(
                        index: index,
                        dto: model.listUnpaidSelectInvoice[index],
                      ),
                    );
                  },
                  childCount: model.listUnpaidSelectInvoice.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _invoiceItemWidget({
    required int index,
    required SelectUnpaidInvoiceItem dto,
  }) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: 100,
            height: 50,
            child: Checkbox(
              activeColor: AppColor.BLUE_TEXT,
              value: dto.isSelect,
              onChanged: (value) {
                _model.appliedUnpaidInvoiceItem(value!, index);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3))),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                (index + 1).toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 200,
            padding: const EdgeInsets.only(right: 4),
            child: SelectionArea(
              child: Text(
                dto.unpaidInvoiceItem.invoiceName,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          //mã hóa đơn
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            padding: const EdgeInsets.only(right: 4),
            child: SelectionArea(
              child: Text(
                dto.unpaidInvoiceItem.billNumber,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          //tổng tiền
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberWithOutVND(
                    dto.unpaidInvoiceItem.pendingAmount),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColor.GREEN),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          //vso
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                dto.unpaidInvoiceItem.vso,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          //chưa TT
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberWithOutVND(
                    dto.unpaidInvoiceItem.pendingAmount),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColor.ORANGE),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          //đã TT
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberWithOutVND(
                    dto.unpaidInvoiceItem.completeAmount),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColor.GREEN),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 80,
            child: InkWell(
              onTap: () {
                _model.currentInvoiceId = dto.unpaidInvoiceItem.invoiceId;
                _model.pageController.nextPage(
                    duration: const Duration(microseconds: 150),
                    curve: Curves.easeOutBack);
              },
              child: const Text(
                'Chi tiết',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.BLUE_TEXT,
                    // decorationColor: AppColor.BLUE_TEXT,
                    color: AppColor.BLUE_TEXT),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
