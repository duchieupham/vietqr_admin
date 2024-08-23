import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/invoice_excel_dto.dart';
import 'dart:html' as html;

import '../../../../ViewModel/invoice_viewModel.dart';
import '../../../../commons/constants/configurations/theme.dart';
import 'item_title_widget.dart';

class PopupExcelInvoice extends StatefulWidget {
  final String invoiceId;
  const PopupExcelInvoice({super.key, required this.invoiceId});

  @override
  State<PopupExcelInvoice> createState() => _PopupExcelInvoiceState();
}

class _PopupExcelInvoiceState extends State<PopupExcelInvoice> {
  late InvoiceViewModel _model;
  final controller1 = ScrollController();
  final controller2 = ScrollController();

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    _model.getInvoiceExcel(widget.invoiceId);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          color: AppColor.WHITE,
          width: 1200,
          height: 750,
          child: ScopedModel<InvoiceViewModel>(
              model: _model,
              child: ScopedModelDescendant<InvoiceViewModel>(
                  builder: (context, child, model) {
                return Column(
                  children: [
                    Container(
                      width: 1200,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Xuất Excel dữ liệu giao dịch',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1160,
                      height: 690,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          const Text(
                            'Thông tin khách hàng thanh toán',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 1160,
                            child: Scrollbar(
                              controller: controller1,
                              child: SingleChildScrollView(
                                controller: controller1,
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: [
                                    _itemTitleWidget(),
                                    if (model.invoiceExcelDTO != null)
                                      _buildItem(model.invoiceExcelDTO!),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const MySeparator(
                            color: AppColor.GREY_DADADA,
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Thông tin giao dịch',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            // height: 350,
                            width: 1000,
                            child: Scrollbar(
                              controller: controller2,
                              child: SingleChildScrollView(
                                controller: controller2,
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: [
                                    _itemTitleInfoTransactionWidget(),
                                    if (model.invoiceExcelDTO != null &&
                                        model.invoiceExcelDTO!.transactions
                                            .isNotEmpty)
                                      ...model.invoiceExcelDTO!.transactions
                                          .asMap()
                                          .map(
                                            (index, x) {
                                              return MapEntry(
                                                index,
                                                _buildItemInfoTransaction(
                                                  index + 1,
                                                  x,
                                                ),
                                              );
                                            },
                                          )
                                          .values
                                          
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              })),
        ),
      ),
    );
  }

  Widget _itemTitleWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
              top: BorderSide(color: AppColor.GREY_DADADA, width: 1))),
      child: const Row(
        children: [
          BuildItemlTitle(
              title: 'Số tài khoản',
              textAlign: TextAlign.center,
              width: 150,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Chủ tài khoản',
              height: 50,
              width: 220,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Luồng kết nối',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Gói dịch vụ',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Phí/GD (VND)',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Phí/GD (%)',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: '% VAT',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Ghi nhận GD',
              height: 50,
              width: 190,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItem(InvoiceExcelDTO dto) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                '${dto.customerDetails.bankAccount}\n${dto.customerDetails.bankShortName}',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 220,
            child: SelectionArea(
              child: Text(
                dto.customerDetails.userBankName,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
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
                dto.customerDetails.mmsActive ? "VietQR Pro" : "VietQR Plus",
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
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
                dto.customerDetails.title,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
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
                StringUtils.formatNumberWithOutVND(dto.customerDetails.fixFee),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
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
                '${dto.customerDetails.percentFee}',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
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
                '${dto.customerDetails.vat}',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 190,
            child: SelectionArea(
              child: Text(
                dto.customerDetails.recordType == 0
                    ? 'Chỉ GD đối soát'
                    : 'Tất cả GD',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTitleInfoTransactionWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
      )),
      child: const Row(
        children: [
          BuildItemlTitle(
              title: 'STT',
              textAlign: TextAlign.center,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Thời gian',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Tổng GD (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'GD đến (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'GD đi (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'GD đối soát (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Thao tác',
              height: 50,
              width: 200,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItemInfoTransaction(int index, Transaction dto) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                index.toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.time,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${dto.totalCount}',
                    // textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    StringUtils.formatNumberWithOutVND(dto.totalAmount),
                    // textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${dto.creditCount} VND',
                    // textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    StringUtils.formatNumberWithOutVND(dto.creditAmount),
                    // textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${dto.debitCount} VND',
                    // textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    StringUtils.formatNumberWithOutVND(dto.debitAmount),
                    // textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${dto.controlCount} VND',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    StringUtils.formatNumberWithOutVND(dto.controlAmount),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 200,
            child: SelectionArea(
              child: InkWell(
                onTap: () async {
                  String url =
                      '${EnvConfig.instance.getBaseUrl()}invoice/export-excel?invoiceItemId=${dto.invoiceItemId}';
                  html.window.open(url, 'new tab');
                  // await _model.exportExcel(dto.invoiceItemId).then(
                  //   (value) {
                  //     if (value == true) {
                  //       String url =
                  //           '${EnvConfig.instance.getBaseUrl()}invoice/export-excel?invoiceItemId=${dto.invoiceItemId}';
                  //       html.window.open(url, 'new tab');
                  //     }
                  //   },
                  // );
                },
                child: const Row(
                  children: [
                    Text(
                      'Xuất Excel',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.green,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.download,
                      color: Colors.green,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
