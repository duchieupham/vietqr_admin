import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/popup_edit_invoice_widget.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/models/DTO/invoice_info_dto.dart';

import '../../../../ViewModel/invoice_viewModel.dart';
import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/widget/separator_widget.dart';
import '../../../../models/DTO/invoice_detail_dto.dart';
import '../../InvoiceCreate/widgets/item_title_widget.dart';

class InvoiceEditScreen extends StatefulWidget {
  final Function() callback;
  final Function() onEdit;
  final String invoiceId;
  const InvoiceEditScreen(
      {super.key,
      required this.callback,
      required this.onEdit,
      required this.invoiceId});

  @override
  State<InvoiceEditScreen> createState() => _InvoiceEditScreenState();
}

class _InvoiceEditScreenState extends State<InvoiceEditScreen> {
  // final TextEditingController _vatTextController = TextEditingController();

  final TextEditingController _invoiceTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  late InvoiceViewModel _model;
  final controller1 = ScrollController();
  final controller2 = ScrollController();

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    _model.getInvoiceInfo(widget.invoiceId);
    _model.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _invoiceTextController.clear();
    _descriptionTextController.clear();
  }

  void onShowEditPopup(InvoiceInfoItem item, {String? bankId}) async {
    await showDialog(
      context: context,
      builder: (context) =>
          PopupEditInvoiceWidget(bankId: bankId!, invoiceItem: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<InvoiceViewModel>(
      model: _model,
      child: SizedBox(
          width: context.width,
          height: context.height,
          child: Stack(
            children: [
              _bodyWidget(),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _bottomData(),
              )
            ],
          )),
    );
  }

  Widget _bottomData() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Error || model.invoiceInfo == null) {
          return const SizedBox.shrink();
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColor.GREY_DADADA, width: 1),
              ),
              color: AppColor.WHITE),
          child: Scrollbar(
            controller: controller2,
            child: SingleChildScrollView(
              controller: controller2,
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                              StringUtils.formatNumber(model.totalEditAmount),
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
                              StringUtils.formatNumber(model.totalEditVat),
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
                              StringUtils.formatNumber(
                                  model.totalEditAmountVat),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColor.BLUE_TEXT,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 70),
                  MButtonWidget(
                    onTap: widget.onEdit,
                    title: 'Cập nhật thông tin',
                    isEnable: true,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    width: 350,
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bodyWidget() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (model.status == ViewStatus.Error && model.invoiceInfo == null) {
          return const SizedBox.shrink();
        }

        List<Widget> buildItemList(List<InvoiceInfoItem>? list,
            {required String bankId}) {
          if (list == null || list.isEmpty) {
            return [];
          }

          return list
              .asMap()
              .map((index, e) {
                return MapEntry(
                    index, _buildItemPaymentInfo(e, index, bankId: bankId));
              })
              .values
              .toList();
        }

        InvoiceInfoDTO? invoiceInfo = model.invoiceInfo;
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 120),
            child: Column(
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
                        'Chỉnh sửa hoá đơn',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Thông tin khách hàng thanh toán',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 100,
                              height: 20,
                              child: Text(
                                'Tên hoá đơn*',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 350,
                              height: 40,
                              padding: const EdgeInsets.only(
                                  left: 10, bottom: 8, top: 4),
                              decoration: BoxDecoration(
                                color:
                                    Colors.white, // Changed to white background
                                border: Border.all(
                                  color: Colors.grey, // Gray border
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: TextField(
                                  controller: _invoiceTextController,
                                  onChanged: (value) {
                                    model.onEditInvoiceName(value);
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        invoiceInfo!.invoiceName.isNotEmpty
                                            ? invoiceInfo.invoiceName
                                            : 'Nhập tên hoá đơn tại đây',
                                    hintStyle: const TextStyle(
                                        color: AppColor.GREY_TEXT,
                                        fontSize: 15),
                                    suffixIcon: const IconButton(
                                        onPressed: null,
                                        icon: Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: AppColor.BLUE_TEXT,
                                        )),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 100,
                              height: 20,
                              child: Text(
                                'Mô tả hoá đơn',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 350,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.only(
                                  left: 10, bottom: 8, top: 4),
                              child: Center(
                                child: TextField(
                                  controller: _descriptionTextController,
                                  onChanged: (value) {
                                    model.onEditDescription(value);
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: invoiceInfo.description.isNotEmpty
                                        ? invoiceInfo.description
                                        : 'Nhập thông tin mô tả hoá đơn ở đây',
                                    hintStyle: const TextStyle(
                                        fontSize: 15,
                                        color: AppColor.GREY_TEXT),
                                    suffixIcon: const IconButton(
                                        onPressed: null,
                                        icon: Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: AppColor.BLUE_TEXT,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const MySeparator(
                  color: AppColor.GREY_DADADA,
                ),
                Container(
                  height: 30,
                  width: 250,
                  margin: const EdgeInsets.only(top: 30),
                  child: const Text(
                    'Thông tin khách hàng thanh toán',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 400,
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                              child: Text(
                                'Đối tượng*',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 400,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  color: AppColor.GREY_DADADA),
                              child: Row(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                color: Colors.grey, width: 1))),
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          'Đại lý',
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          invoiceInfo
                                              .userInformation.merchantName,
                                          style: const TextStyle(fontSize: 15),
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      SizedBox(
                        width: 350,
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                              child: Text(
                                'Tài khoản ngân hàng*',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 350,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  color: AppColor.GREY_DADADA),
                              child: SizedBox(
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      '${invoiceInfo.userInformation.bankShortName} - ${invoiceInfo.userInformation.bankAccount}',
                                      style: const TextStyle(fontSize: 15),
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 250,
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                              child: Text(
                                'Chủ tài khoản',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 250,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  color: AppColor.GREY_DADADA),
                              child: SizedBox(
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      invoiceInfo.userInformation.userBankName
                                              .isNotEmpty
                                          ? invoiceInfo
                                              .userInformation.userBankName
                                          : '-',
                                      style: const TextStyle(fontSize: 15),
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      Container(
                        width: 250,
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                              child: Text(
                                'Tài khoản VietQR',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 250,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  color: AppColor.GREY_DADADA),
                              child: SizedBox(
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      invoiceInfo.userInformation.phoneNo,
                                      style: const TextStyle(fontSize: 15),
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      SizedBox(
                        width: 250,
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                              child: Text(
                                'Email',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 250,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  color: AppColor.GREY_DADADA),
                              child: SizedBox(
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      invoiceInfo
                                              .userInformation.email.isNotEmpty
                                          ? invoiceInfo.userInformation.email
                                          : '-',
                                      style: const TextStyle(fontSize: 15),
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 250,
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                              child: Text(
                                'Luồng kết nối',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 250,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  color: AppColor.GREY_DADADA),
                              child: SizedBox(
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      invoiceInfo
                                          .userInformation.connectionType,
                                      style: const TextStyle(fontSize: 15),
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      SizedBox(
                        width: 250,
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                              child: Text(
                                'Gói dịch vụ',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 250,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  color: AppColor.GREY_DADADA),
                              child: SizedBox(
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      invoiceInfo.userInformation.feePackage,
                                      style: const TextStyle(fontSize: 15),
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      SizedBox(
                        width: 250,
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                              child: Text(
                                'VAT (%)',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 250,
                              height: 40,
                              decoration: BoxDecoration(
                                color:
                                    Colors.white, // Changed to white background
                                border: Border.all(
                                  color: Colors.grey, // Gray border
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: TextField(
                                      controller: model.vatTextController,
                                      onChanged: (value) {
                                        model.editVatInvoiceInfo(value);
                                      },
                                      textInputAction: TextInputAction.done,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*')),
                                      ],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: invoiceInfo
                                                    .userInformation.vat !=
                                                null
                                            ? invoiceInfo.userInformation.vat
                                                .toString()
                                            : 'Nhập VAT',
                                        hintStyle: const TextStyle(
                                            color: AppColor.GREY_TEXT,
                                            fontSize: 15),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const MySeparator(
                  color: AppColor.GREY_DADADA,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 20,
                  child: const Text(
                    'Danh mục hàng hoá / dịch vụ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 1360,
                  child: Scrollbar(
                    controller: controller1,
                    child: SingleChildScrollView(
                      controller: controller1,
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          _itemTitlePaymentInfo(),
                          ...buildItemList(invoiceInfo.invoiceItems,
                              bankId: invoiceInfo.userInformation.bankId),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
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
      child: Row(
        children: const [
          BuildItemlTitle(
              title: 'STT',
              textAlign: TextAlign.center,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Nội dung hoá đơn thanh toán',
              height: 50,
              width: 300,
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
              title: 'Thao tác',
              height: 50,
              width: 90,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItemPaymentInfo(InvoiceInfoItem item, int index,
      {required String bankId}) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColor.GREY_DADADA))),
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                (index + 1).toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 300,
            child: SelectionArea(
              child: Text(
                item.invoiceItemName.isNotEmpty ? item.invoiceItemName : '-',
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
                item.unit.isNotEmpty ? item.unit : '-',
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
                item.quantity.toString(),
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
                StringUtils.formatNumberWithOutVND(item.amount),
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
                StringUtils.formatNumberWithOutVND(item.totalAmount),
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
                item.vat.toString(),
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
                StringUtils.formatNumberWithOutVND(item.vatAmount),
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
                StringUtils.formatNumberWithOutVND(item.totalAmountAfterVat),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 50,
            width: 90,
            child: SelectionArea(
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      onShowEditPopup(item, bankId: bankId);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColor.BLUE_TEXT.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 12,
                        color: AppColor.BLUE_TEXT,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      DialogWidget.instance.openMsgDialogQuestion(
                        title: 'Xóa dịch vụ',
                        msg: 'Xác nhận xóa dịch vụ!!',
                        onConfirm: () {
                          _model.removeInvoiceItem(item);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColor.RED_TEXT.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_forever,
                        size: 12,
                        color: AppColor.RED_TEXT,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 18, 30, 10),
      width: MediaQuery.of(context).size.width * 0.32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Quản lý hoá đơn",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "/",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Danh sách hoá đơn",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "/",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Chỉnh sửa hoá đơn",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
