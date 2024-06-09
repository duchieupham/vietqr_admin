import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceManage/InvoiceCreate/widgets/item_title_widget.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/bank_detail_dto.dart';
import 'package:vietqr_admin/models/DTO/invoice_info_dto.dart';

class PopupEditInvoiceWidget extends StatefulWidget {
  final String bankId;
  final InvoiceInfoItem invoiceItem;
  const PopupEditInvoiceWidget(
      {super.key, required this.bankId, required this.invoiceItem});

  @override
  State<PopupEditInvoiceWidget> createState() => _PopupEditInvoiceWidgetState();
}

class _PopupEditInvoiceWidgetState extends State<PopupEditInvoiceWidget> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  bool hasInputAmount = false;
  double? totalAmount;
  double? vatAmount;
  String? amountInput;
  final controller1 = ScrollController();
  final controller2 = ScrollController();

  late InvoiceViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    _model.getBankDetail(id: widget.bankId);
    // _model.resetConfirmService();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   initData();
    // });
  }

  void confirmEdit({required Function(InvoiceInfoItem) onEdit}) {
    InvoiceInfoItem? item;
    if (widget.invoiceItem.type == 9) {
      item = InvoiceInfoItem(
          timeProcess: widget.invoiceItem.timeProcess,
          invoiceItemId: widget.invoiceItem.invoiceItemId,
          invoiceItemName: _contentController.text.isNotEmpty
              ? _contentController.text
              : widget.invoiceItem.invoiceItemName,
          unit: _unitController.text.isNotEmpty
              ? _unitController.text
              : widget.invoiceItem.unit,
          quantity: _quantityController.text.isNotEmpty
              ? int.parse(_quantityController.text)
              : widget.invoiceItem.quantity,
          amount: amountInput != null
              ? int.parse(amountInput!)
              : widget.invoiceItem.amount,
          totalAmount: totalAmount!.round(),
          vat: widget.invoiceItem.vat,
          vatAmount: vatAmount!.round(),
          totalAmountAfterVat: (totalAmount! + vatAmount!).round(),
          type: widget.invoiceItem.type);
    } else {
      item = InvoiceInfoItem(
          timeProcess: widget.invoiceItem.timeProcess,
          invoiceItemId: widget.invoiceItem.invoiceItemId,
          invoiceItemName: widget.invoiceItem.invoiceItemName,
          unit: widget.invoiceItem.unit,
          quantity: widget.invoiceItem.quantity,
          amount: int.parse(amountInput!),
          totalAmount: totalAmount!.round(),
          vat: widget.invoiceItem.vat,
          vatAmount: vatAmount!.round(),
          totalAmountAfterVat: (totalAmount! + vatAmount!).round(),
          type: widget.invoiceItem.type);
    }

    onEdit(item);
  }

  String extractDateString(String itemName) {
    RegExp regExp = RegExp(r'(0[1-9]|1[0-2])/\d{4}');
    Match? match = regExp.firstMatch(itemName);
    if (match != null) {
      return match.group(0)!;
    } else {
      return "No date found";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          color: AppColor.WHITE,
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.75,
          child: ScopedModel<InvoiceViewModel>(
              model: _model,
              child: ScopedModelDescendant<InvoiceViewModel>(
                builder: (context, child, model) {
                  bool hasSelect = false;
                  if (widget.invoiceItem.type == 9) {
                    if (_amountController.text.isNotEmpty ||
                        _contentController.text.isNotEmpty ||
                        _unitController.text.isNotEmpty ||
                        _quantityController.text.isNotEmpty) {
                      hasSelect = true;
                    }
                  } else {
                    if (_amountController.text.isNotEmpty) {
                      hasSelect = true;
                    }
                  }
                  if (model.status == ViewStatus.Empty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (model.bankDetail == null) {
                    return const SizedBox.shrink();
                  }

                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chỉnh sửa danh mục hàng hoá / dịch vụ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 50),
                            const Text(
                              'Thông tin khách hàng thanh toán',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 45),
                            Scrollbar(
                              controller: controller1,
                              child: SingleChildScrollView(
                                controller: controller1,
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: [
                                    _itemTitleWidget(false),
                                    _buildBankItem(
                                        dto: model.bankDetail,
                                        textAmount:
                                            model.vatTextController.text),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const MySeparator(
                              color: AppColor.GREY_DADADA,
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Thông tin hàng hoá / dịch vụ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),
                            _serivceWidget(widget.invoiceItem),
                            const SizedBox(height: 45),
                            Scrollbar(
                              controller: controller2,
                              child: SingleChildScrollView(
                                controller: controller2,
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: [
                                    _itemTitleWidget(true),
                                    _buildItem(),
                                  ],
                                ),
                              ),
                            ),
                            // const Spacer(),
                            const SizedBox(height: 20),
                            Container(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: hasSelect == true
                                    ? () {
                                        confirmEdit(
                                          onEdit: (item) {
                                            Navigator.of(context).pop();
                                            model.confirmEditInvoiceItem(item);
                                          },
                                        );
                                      }
                                    : null,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.18,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: hasSelect == true
                                          ? AppColor.BLUE_TEXT
                                          : AppColor.GREY_DADADA,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Text(
                                      'Xác nhận',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: hasSelect == true
                                              ? AppColor.WHITE
                                              : AppColor.BLACK),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 20,
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
                      ),
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }

  Widget _buildItem() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.WHITE,
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 200,
            padding: const EdgeInsets.only(right: 8),
            color: widget.invoiceItem.type == 9
                ? AppColor.WHITE
                : AppColor.GREY_DADADA,
            child: widget.invoiceItem.type == 9
                ? TextField(
                    onChanged: (value) {
                      _contentController.value = TextEditingValue(
                        text: value,
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                      setState(() {});
                    },
                    controller: _contentController,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.only(top: 15),
                      border: InputBorder.none,
                      hintText: widget.invoiceItem.invoiceItemName,
                      hintStyle: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                  )
                : SelectionArea(
                    child: Text(
                      widget.invoiceItem.invoiceItemName,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            color: widget.invoiceItem.type == 9
                ? AppColor.WHITE
                : AppColor.GREY_DADADA,
            child: widget.invoiceItem.type == 9
                ? TextField(
                    onChanged: (value) {
                      _unitController.value = TextEditingValue(
                        text: value,
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                      setState(() {});
                    },
                    controller: _unitController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.only(top: 15),
                      border: InputBorder.none,
                      hintText: widget.invoiceItem.unit,
                      hintStyle: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                  )
                : SelectionArea(
                    child: Text(
                      widget.invoiceItem.unit,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 130,
            color: widget.invoiceItem.type == 9
                ? AppColor.WHITE
                : AppColor.GREY_DADADA,
            child: widget.invoiceItem.type == 9
                ? TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        totalAmount = double.parse(amountInput ??
                                widget.invoiceItem.amount.toString()) *
                            int.parse(value);
                        vatAmount = totalAmount! *
                            double.parse(
                                widget.invoiceItem.vat.round().toString()) /
                            100;
                      } else {
                        totalAmount = double.parse(amountInput ??
                                widget.invoiceItem.amount.toString()) *
                            1;
                        vatAmount = totalAmount! *
                            double.parse(
                                widget.invoiceItem.vat.round().toString()) /
                            100;
                      }
                      _quantityController.value = TextEditingValue(
                        text: value,
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                      hasInputAmount = true;
                      setState(() {});
                    },
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.only(top: 15),
                      border: InputBorder.none,
                      hintText: widget.invoiceItem.quantity.toString(),
                      hintStyle: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                  )
                : SelectionArea(
                    child: Text(
                      widget.invoiceItem.quantity.toString(),
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 130,
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                String text = value.replaceAll(',', '');
                if (text.isNotEmpty) {
                  final formatter = NumberFormat('#,###');
                  String newText = formatter.format(int.parse(text));
                  _amountController.value = TextEditingValue(
                    text: newText,
                    selection: TextSelection.collapsed(offset: newText.length),
                  );

                  amountInput = text;
                  totalAmount = double.parse(amountInput!) *
                      (widget.invoiceItem.type == 9
                          ? int.parse(_quantityController.text.isNotEmpty
                              ? _quantityController.text
                              : widget.invoiceItem.quantity.toString())
                          : widget.invoiceItem.quantity);
                  vatAmount = totalAmount! *
                      double.parse(widget.invoiceItem.vat.toString()) /
                      100;
                  hasInputAmount = true;
                } else {
                  hasInputAmount = false;
                }
                setState(() {});
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 15),
                border: InputBorder.none,
                hintText: StringUtils.formatNumberWithOutVND(
                    widget.invoiceItem.amount),
                hintStyle: TextStyle(
                    fontSize: 12,
                    color: widget.invoiceItem.type == 9
                        ? AppColor.GREY_TEXT
                        : AppColor.BLACK),
                suffixIcon: widget.invoiceItem.type == 9
                    ? const SizedBox.shrink()
                    : const IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20,
                          color: AppColor.BLUE_TEXT,
                        ),
                        onPressed: null,
                      ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 130,
            color: AppColor.GREY_DADADA,
            child: SelectionArea(
              child: Text(
                hasInputAmount == true
                    ? StringUtils.formatNumberWithOutVND(totalAmount)
                    : StringUtils.formatNumberWithOutVND(
                        widget.invoiceItem.totalAmount),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 80,
            color: AppColor.GREY_DADADA,
            child: SelectionArea(
              child: Text(
                widget.invoiceItem.vat.toString(),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            color: AppColor.GREY_DADADA,
            child: SelectionArea(
              child: Text(
                hasInputAmount == true
                    ? StringUtils.formatNumberWithOutVND(vatAmount?.round())
                    : StringUtils.formatNumberWithOutVND(
                        widget.invoiceItem.vatAmount),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 115,
            color: AppColor.GREY_DADADA,
            child: SelectionArea(
              child: Text(
                hasInputAmount == true
                    ? StringUtils.formatNumberWithOutVND(
                        (totalAmount! + vatAmount!).round())
                    : StringUtils.formatNumberWithOutVND(
                        widget.invoiceItem.totalAmountAfterVat),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _serivceWidget(InvoiceInfoItem item) {
    String invoiceType = '';
    switch (item.type) {
      case 0:
        invoiceType = 'Phí thường niên / duy trì';
        break;
      case 1:
        invoiceType = 'Phí giao dịch';
        break;
      case 9:
        invoiceType = 'Phí khác';
        break;
      default:
        invoiceType;
        break;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loại hàng hoá / dịch vụ*',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 250,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColor.GREY_DADADA,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                invoiceType,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        const SizedBox(width: 30),
        if (widget.invoiceItem.type != 9)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thời gian*',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 280,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: AppColor.GREY_DADADA,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Tháng', style: TextStyle(fontSize: 15)),
                    const SizedBox(width: 20),
                    const SizedBox(
                      height: 40,
                      child: VerticalDivider(
                        thickness: 1,
                        color: AppColor.GREY_DADADA,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 4),
                      width: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(extractDateString(item.invoiceItemName),
                              style: const TextStyle(fontSize: 15)),
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColor.BLACK,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBankItem({BankDetailDTO? dto, String? textAmount}) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.WHITE,
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dto!.bankAccount,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dto.bankShortName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
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
              child: Text(
                dto.userBankName,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 130,
            child: SelectionArea(
              child: Text(
                dto.connectionType,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 130,
            child: SelectionArea(
              child: Text(
                dto.feePackage,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 130,
            child: SelectionArea(
              child: Text(
                dto.transFee1.toString(),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 130,
            child: SelectionArea(
              child: Text(
                dto.transFee2.toString(),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 110,
            child: SelectionArea(
              child: Text(
                textAmount!.isNotEmpty ? textAmount : dto.vat.toString(),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                dto.transRecord == 0 ? 'Chỉ GD đối soát' : 'Tất cả GD',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTitleWidget(bool isServiceItem) {
    return Container(
      // padding: const EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: AppColor.WHITE,
          border: Border(
              bottom: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
      child: Row(
        children: isServiceItem == false
            ? const [
                BuildItemlTitle(
                    title: 'Số tài khoản',
                    textAlign: TextAlign.left,
                    width: 120,
                    height: 50,
                    alignment: Alignment.centerLeft),
                BuildItemlTitle(
                    title: 'Chủ tài khoản',
                    height: 50,
                    width: 150,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
                SizedBox(width: 10),
                BuildItemlTitle(
                    title: 'Luồng kết nối',
                    height: 50,
                    width: 130,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
                BuildItemlTitle(
                    title: 'Gói dịch vụ',
                    height: 50,
                    width: 130,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
                BuildItemlTitle(
                    title: 'Phí/GD (VND)',
                    height: 50,
                    width: 130,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
                BuildItemlTitle(
                    title: 'Phí/GD (%)',
                    height: 50,
                    width: 130,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
                BuildItemlTitle(
                    title: 'VAT(%)',
                    height: 50,
                    width: 110,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
                BuildItemlTitle(
                    title: 'Ghi nhận GD',
                    height: 50,
                    width: 120,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
              ]
            : const [
                BuildItemlTitle(
                    title: 'Nội dung hoá đơn thanh toán',
                    textAlign: TextAlign.left,
                    width: 200,
                    height: 50,
                    alignment: Alignment.centerLeft),
                BuildItemlTitle(
                    title: 'Đơn vị tính',
                    textAlign: TextAlign.left,
                    width: 120,
                    height: 50,
                    alignment: Alignment.centerLeft),
                BuildItemlTitle(
                    title: 'Số lượng',
                    textAlign: TextAlign.left,
                    width: 130,
                    height: 50,
                    alignment: Alignment.centerLeft),
                SizedBox(width: 10),
                BuildItemlTitle(
                    title: 'Đơn giá (VND)',
                    textAlign: TextAlign.left,
                    width: 130,
                    height: 50,
                    alignment: Alignment.centerLeft),
                BuildItemlTitle(
                    title: 'Thành tiền (VND)',
                    textAlign: TextAlign.left,
                    width: 130,
                    height: 50,
                    alignment: Alignment.centerLeft),
                BuildItemlTitle(
                    title: '% VAT',
                    textAlign: TextAlign.left,
                    width: 80,
                    height: 50,
                    alignment: Alignment.centerLeft),
                BuildItemlTitle(
                    title: 'VAT (VND)',
                    textAlign: TextAlign.left,
                    width: 120,
                    height: 50,
                    alignment: Alignment.centerLeft),
                BuildItemlTitle(
                    title: 'Tổng tiền (VND)',
                    textAlign: TextAlign.left,
                    width: 115,
                    height: 50,
                    alignment: Alignment.centerLeft),
              ],
      ),
    );
  }
}
