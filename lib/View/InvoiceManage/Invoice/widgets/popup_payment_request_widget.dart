import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/popup_qr_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/InvoiceCreate/widgets/item_title_widget.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/invoice_detail_dto.dart';
import 'package:vietqr_admin/models/DTO/invoice_dto.dart';

import 'bank_account_item.dart';

class PopupPaymentRequestWidget extends StatefulWidget {
  final InvoiceItem dto;
  final Function(String) onPop;
  const PopupPaymentRequestWidget(
      {super.key, required this.dto, required this.onPop});

  @override
  State<PopupPaymentRequestWidget> createState() =>
      _PopupPaymentRequestWidgetState();
}

class _PopupPaymentRequestWidgetState extends State<PopupPaymentRequestWidget> {
  late InvoiceViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    _model.getInvoiceDetail(widget.dto.invoiceId);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          color: AppColor.WHITE,
          width: 1150,
          height: 750,
          padding: const EdgeInsets.all(20),
          child: ScopedModel<InvoiceViewModel>(
              model: _model,
              child: ScopedModelDescendant<InvoiceViewModel>(
                builder: (context, child, model) {
                  bool isEnable = false;
                  if (model.listSelectInvoice.isNotEmpty) {
                    isEnable =
                        model.listSelectInvoice.any((x) => x.isSelect == true);
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
                            'Tạo mã VietQR để yêu cầu thanh toán',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          _buildInvoiceDetailWidget(),
                          const MySeparator(color: AppColor.GREY_DADADA),
                          const SizedBox(height: 30),
                          const Text(
                            'Danh mục hàng hoá / dịch vụ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          _buildInvoiceWidget(),
                          const SizedBox(height: 50),
                          if (model.invoiceDetailDTO != null)
                            _buildReqPayment(
                                model.invoiceDetailDTO!.paymentRequestDTOS,
                                isEnable),
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
      ),
    );
  }

  Widget _buildReqPayment(List<PaymentRequestDTO> listReq, bool isEnable) {
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
                height: 50,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SelectBankRecieveItem(
                        dto: listReq[index],
                        onChange: (value) {
                          _model.selectPayment(index);
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
                  final result = await _model.requestPayment(
                      invoiceId: widget.dto.invoiceId);
                  if (result != null) {
                    if (!mounted) return;
                    Navigator.of(context).pop();
                    await showDialog(
                      context: context,
                      builder: (context) => PopupQrCodeInvoice(
                        onPop: widget.onPop,
                        invoiceId: result.invoiceId,
                      ),
                    );
                  }
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildInvoiceWidget() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading &&
            model.request == InvoiceType.GET_INVOICE_DETAIL) {
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }
        if (model.invoiceDetailDTO == null ||
            model.listInvoiceDetailItem.isEmpty) {
          return const SizedBox.shrink();
        }

        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Container(
                width: 700,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
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
                            value: model.isAllApplied,
                            onChanged: (value) {
                              model.appliedAllItem(value!);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                    color:
                                        AppColor.GREY_TEXT.withOpacity(0.3))),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Tất cả',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
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
                        title: 'Nội dung hoá đơn thanh toán',
                        height: 50,
                        width: 250,
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
                        title: 'Trạng thái',
                        height: 50,
                        width: 120,
                        alignment: Alignment.centerLeft,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              Expanded(
                  child: SizedBox(
                width: 700,
                child: ListView.separated(
                  separatorBuilder: (context, index) => Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: AppColor.GREY_DADADA, width: 1)))),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    bool isAlreadyPay =
                        model.listInvoiceDetailItem[index].status == 1;
                    return _invoiceItemWidget(
                        index: index,
                        dto: model.listSelectInvoice[index],
                        isAlreadyPay: isAlreadyPay);
                  },
                  itemCount: model.listSelectInvoice.length,
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _invoiceItemWidget(
      {required int index,
      required SelectInvoiceItem dto,
      required bool isAlreadyPay}) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          isAlreadyPay == false
              ? Container(
                  alignment: Alignment.centerLeft,
                  width: 100,
                  height: 50,
                  child: Checkbox(
                    activeColor: AppColor.BLUE_TEXT,
                    value: dto.isSelect,
                    onChanged: (value) {
                      _model.appliedInvoiceItem(value!, index);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                            color: AppColor.GREY_TEXT.withOpacity(0.3))),
                  ),
                )
              : Container(
                  alignment: Alignment.centerLeft,
                  width: 100,
                  height: 50,
                  child: Checkbox(
                    activeColor: AppColor.ITEM_MENU_SELECTED,
                    checkColor: AppColor.BLUE_TEXT,
                    value: true,
                    onChanged: (value) {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                            color: AppColor.GREY_TEXT.withOpacity(0.3))),
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
            width: 250,
            padding: const EdgeInsets.only(right: 4),
            child: SelectionArea(
              child: Text(
                dto.invoiceItem.invoiceItemName,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberWithOutVND(
                    dto.invoiceItem.totalAmountAfterVat),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                dto.invoiceItem.status == 0
                    ? 'Chưa thanh toán'
                    : 'Đã thanh toán',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: dto.invoiceItem.status == 0
                        ? AppColor.ORANGE
                        : AppColor.GREEN),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceDetailWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        _itemTitleWidget(),
        _invoiceDetailWidget(),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _invoiceDetailWidget() {
    Color color = AppColor.WHITE;
    String status = '';
    switch (widget.dto.status) {
      case 0:
        status = 'Chưa thanh toán';
        color = AppColor.ORANGE_DARK;
        break;
      case 1:
        status = 'Đã thanh toán';
        color = AppColor.GREEN;

        break;
      case 3:
        status = 'Chưa TT hết';
        color = AppColor.GREEN_2D9D92;

        break;
      default:
        status;
        break;
    }
    return Container(
      color: AppColor.WHITE,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 260,
            padding: const EdgeInsets.only(right: 4),
            child: SelectionArea(
              child: Text(
                widget.dto.invoiceName,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                widget.dto.billNumber,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatAmount(widget.dto.amount),
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.GREEN_2D9D92,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                widget.dto.vso.isNotEmpty ? widget.dto.vso : '-',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatAmount(3500000),
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.ORANGE_DARK,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatAmount(3500000),
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.GREEN,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                status,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12, color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTitleWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: AppColor.WHITE,
          border: Border(
              bottom: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
      child: Row(
        children: const [
          BuildItemlTitle(
              title: 'Hoá đơn',
              textAlign: TextAlign.center,
              width: 260,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Mã hoá đơn',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Tổng tiền (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'VSO',
              height: 50,
              width: 100,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Chưa TT (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Đã TT (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Trạng thái',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
