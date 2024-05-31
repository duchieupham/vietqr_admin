import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';

import '../../../../ViewModel/invoice_viewModel.dart';
import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/widget/separator_widget.dart';
import '../../../../models/DTO/invoice_detail_dto.dart';
import '../../InvoiceCreate/widgets/item_title_widget.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final String invoiceId;
  final Function() callback;
  final Function() onEdit;

  const InvoiceDetailScreen(
      {super.key,
      required this.callback,
      required this.onEdit,
      required this.invoiceId});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late InvoiceViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    _model.getInvoiceDetail(widget.invoiceId);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _model,
      child: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        if (model.invoiceDetailDTO == null) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: widget.callback,
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 15,
                          ),
                        ),
                        const SizedBox(width: 30),
                        const Text(
                          'Chi tiết hoá đơn',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 30),
                        if (_model.invoiceDetailDTO!.status == 0)
                          InkWell(
                            onTap: widget.onEdit,
                            // onTap: () {

                            //   DialogWidget.instance.openMsgDialog(
                            //       title: 'Bảo trì',
                            //       msg:
                            //           'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                            // },
                            child: const Text(
                              'Chỉnh sửa hoá đơn',
                              style: TextStyle(
                                  color: AppColor.BLUE_TEXT,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    width: 500,
                    height: 60,
                    margin: const EdgeInsets.only(top: 30),
                    child: Text(
                      model.invoiceDetailDTO!.invoiceName,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  model.invoiceDetailDTO!.invoiceDescription.isNotEmpty
                      ? Text(
                          model.invoiceDetailDTO!.invoiceDescription,
                          style: const TextStyle(fontSize: 15),
                        )
                      : const SizedBox.shrink(),
                  if (model
                      .invoiceDetailDTO!.customerDetailDTOS.isNotEmpty) ...[
                    const SizedBox(height: 29),
                    const MySeparator(
                      color: AppColor.GREY_DADADA,
                    ),
                    const SizedBox(height: 30),
                    const SizedBox(
                      width: double.infinity,
                      height: 20,
                      child: Text(
                        'Thông tin khách hàng thanh toán',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 1300,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            _itemTitlePaymentInfo(),
                            ...model.invoiceDetailDTO!.customerDetailDTOS
                                .asMap()
                                .map(
                                  (index, e) => MapEntry(
                                    index,
                                    _buildItemPaymentInfo(e, index + 1),
                                  ),
                                )
                                .values
                                
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const MySeparator(
                      color: AppColor.GREY_DADADA,
                    ),
                  ],
                  if (model
                      .invoiceDetailDTO!.feePackageDetailDTOS.isNotEmpty) ...[
                    const SizedBox(height: 30),
                    const SizedBox(
                      width: double.infinity,
                      height: 20,
                      child: Text(
                        'Thông tin gói dịch vụ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 920,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            _itemTitleServiceInfo(),
                            ...model.invoiceDetailDTO!.feePackageDetailDTOS
                                .asMap()
                                .map(
                                  (index, e) => MapEntry(
                                    index,
                                    _buildItemServiceInfo(e, index + 1),
                                  ),
                                )
                                .values
                                
                            // _buildItemServiceInfo(),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                  const SizedBox(
                    width: double.infinity,
                    height: 20,
                    child: Text(
                      'Danh mục hàng hoá / dịch vụ',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    // width: statusNum == 0 ? 1360 : 1270,
                    width: _model.invoiceDetailDTO!.status == 0 ? 1360 : 1270,
                    // width: 1270,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          _itemTitleListService(),
                          // _buildItemListService(),
                          ...model.invoiceDetailDTO!.invoiceItemDetailDTOS
                              .asMap()
                              .map(
                                (index, e) => MapEntry(
                                  index,
                                  _buildItemListService(e, index + 1),
                                ),
                              )
                              .values
                              
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _bottomData(model.invoiceDetailDTO!))
            ],
          ),
        );
      },
    );
  }

  Widget _itemTitlePaymentInfo() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
        ),
      ),
      child: const Row(
        children: [
          BuildItemlTitle(
              title: 'STT',
              textAlign: TextAlign.center,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'VSO',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Đại lý',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Nền tảng',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'TK ngân hàng',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Chủ TK',
              height: 50,
              width: 200,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Luồng kết nối',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Tài khoản VietQR',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Email',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItemPaymentInfo(CustomerDetailDTO dto, int index) {
    return Container(
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
                dto.vso.isNotEmpty ? dto.vso : '-',
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
              child: Text(
                dto.merchantName.isNotEmpty ? dto.merchantName : '-',
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
              child: Text(
                dto.platform.isNotEmpty ? dto.platform : '-',
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
              child: Text(
                '${dto.bankAccount}\n${dto.bankShortName}',
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
            width: 200,
            child: SelectionArea(
              child: Text(
                dto.userBankName,
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
              child: Text(
                dto.connectionType,
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
              child: Text(
                dto.phoneNo,
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
              child: Text(
                dto.email.isNotEmpty ? dto.email : '-',
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

  Widget _itemTitleServiceInfo() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
        ),
      ),
      child: const Row(
        children: [
          BuildItemlTitle(
              title: 'STT',
              textAlign: TextAlign.center,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Gói dịch vụ',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Phí duy trì (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Phí giao dịch (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Phí giao dịch (%)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'VAT(%)',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Ghi nhận GD',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItemServiceInfo(FeePackageDetailDTO dto, index) {
    return Container(
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
                dto.feePackage,
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
              child: Text(
                StringUtils.formatNumberWithOutVND(dto.annualFee),
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
              child: Text(
                StringUtils.formatNumberWithOutVND(dto.fixFee),
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
              child: Text(
                StringUtils.formatNumberWithOutVND(dto.percentFee),
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
            child: const SelectionArea(
              child: Text(
                '8',
                // textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
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
                dto.recordType == 0 ? 'Chỉ GD đối soát' : 'Tất cả GD',
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

  Widget _itemTitleListService() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
        ),
      ),
      child: const Row(
        children: [
          BuildItemlTitle(
              title: 'STT',
              textAlign: TextAlign.center,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Nội dung hoá đơn thanh toán',
              height: 50,
              width: 250,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Đơn vị tính',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Số lượng',
              height: 50,
              width: 100,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Đơn giá (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Thành tiền (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: '% VAT',
              height: 50,
              width: 100,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'VAT (VND)',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Tổng tiền (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          // if (_model.invoiceDetailDTO!.status == 0)
          //   const BuildItemlTitle(
          //       title: 'Thao tác',
          //       height: 50,
          //       width: 90,
          //       alignment: Alignment.centerLeft,
          //       textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItemListService(InvoiceItemDetailDTO dto, int index) {
    return Container(
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
            width: 250,
            child: SelectionArea(
              child: Text(
                dto.invoiceItemName,
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
                dto.unit.isEmpty ? '-' : dto.unit,
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
            width: 100,
            child: SelectionArea(
              child: Text(
                dto.quantity.toString(),
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
              child: Text(
                StringUtils.formatNumberWithOutVND(dto.amount),
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
              child: Text(
                StringUtils.formatNumberWithOutVND(dto.totalAmount),

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
            width: 100,
            child: SelectionArea(
              child: Text(
                dto.vat.toString(),
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
                StringUtils.formatNumberWithOutVND(dto.vatAmount),

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
              child: Text(
                StringUtils.formatNumberWithOutVND(dto.totalAmountAfterVat),

                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // if (_model.invoiceDetailDTO!.status == 0)
          //   Container(
          //     alignment: Alignment.center,
          //     height: 50,
          //     width: 90,
          //     child: SelectionArea(
          //       child: Row(
          //         children: [
          //           InkWell(
          //             onTap: widget.onEdit,
          //             // onTap: () {
          //             //   DialogWidget.instance.openMsgDialog(
          //             //       title: 'Bảo trì',
          //             //       msg:
          //             //           'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
          //             // },
          //             child: Container(
          //               width: 30,
          //               height: 30,
          //               decoration: BoxDecoration(
          //                 color: AppColor.BLUE_TEXT.withOpacity(0.3),
          //                 shape: BoxShape.circle,
          //               ),
          //               child: const Icon(
          //                 Icons.edit,
          //                 size: 12,
          //                 color: AppColor.BLUE_TEXT,
          //               ),
          //             ),
          //           ),
          //           const SizedBox(width: 10),
          //           InkWell(
          //             onTap: () {
          //               DialogWidget.instance.openMsgDialog(
          //                   title: 'Bảo trì',
          //                   msg:
          //                       'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
          //             },
          //             child: Container(
          //               width: 30,
          //               height: 30,
          //               decoration: BoxDecoration(
          //                 color: AppColor.RED_TEXT.withOpacity(0.3),
          //                 shape: BoxShape.circle,
          //               ),
          //               child: const Icon(
          //                 Icons.delete_forever,
          //                 size: 12,
          //                 color: AppColor.RED_TEXT,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _bottomData(InvoiceDetailDTO dto) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColor.GREY_DADADA, width: 1),
          ),
          color: AppColor.WHITE),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30),
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tổng tiền hàng',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Text(
                  StringUtils.formatNumber(dto.totalAmount),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30),
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'VAT',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Text(
                  StringUtils.formatNumber(dto.vatAmount),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30),
            width: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tổng tiền thanh toán (bao gồm VAT)',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Text(
                  StringUtils.formatNumber(dto.totalAmountAfterVat),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: dto.status == 0 ? AppColor.ORANGE : AppColor.GREEN,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Trạng thái',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dto.status == 0 ? 'Chưa thanh toán' : 'Đã thanh toán',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dto.status == 0 ? AppColor.ORANGE : AppColor.GREEN,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
