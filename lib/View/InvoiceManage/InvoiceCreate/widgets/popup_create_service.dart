import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';

import '../../../../ViewModel/invoice_viewModel.dart';
import '../../../../commons/constants/utils/string_utils.dart';
import '../../../../commons/widget/dialog_pick_month.dart';
import '../../../../main.dart';
import '../../../../models/DTO/bank_detail_dto.dart';
import '../../../../models/DTO/service_item_dto.dart';
import 'item_title_widget.dart';

class PopupCreateServiceWidget extends StatefulWidget {
  final bool isEdit;
  final ServiceItemDTO? dto;
  const PopupCreateServiceWidget({super.key, required this.isEdit, this.dto});

  @override
  State<PopupCreateServiceWidget> createState() =>
      _PopupCreateServiceWidgetState();
}

class _PopupCreateServiceWidgetState extends State<PopupCreateServiceWidget> {
  late InvoiceViewModel _model;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  bool hasInputAmount = false;
  double? totalAmount;
  double? vatAmount;
  String? amountInput;
  final _horizontal = ScrollController();
  final _horizontal2 = ScrollController();

  DateTime? selectDate;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    _model.resetConfirmService();
    _model.selectServiceType(1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  void initData() {
    if (widget.isEdit == true && widget.dto != null) {
      if (_amountController.text.isEmpty) {
        _amountController.text =
            StringUtils.formatNumberWithOutVND(widget.dto!.amount);
        amountInput = _amountController.text.replaceAll(',', '');
      }
      if (_contentController.text.isEmpty) {
        _contentController.text = widget.dto!.content;
      }
      if (_quantityController.text.isEmpty) {
        _quantityController.text = widget.dto!.quantity.toString();
      }
      if (_unitController.text.isEmpty) {
        _unitController.text = widget.dto!.unit;
      }
      totalAmount = double.parse(widget.dto!.totalAmount.toString());
      vatAmount = double.parse(widget.dto!.vatAmount.toString());
    }
  }

  void _onPickMonth(DateTime dateTime) async {
    DateTime result = await showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
            child: DialogPickDate(
              dateTime: dateTime,
            ),
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        selectDate = result;
      });
      await _model.getService(time: DateFormat('yyyy-MM').format(result));
    } else {
      selectDate = null;
    }
  }

  void onConfirmService(bool hasSelect,
      {required ServiceItemDTO dto,
      required int serviceType,
      required Function(ServiceItemDTO) confirmService}) {
    ServiceItemDTO item;
    if (hasSelect && widget.isEdit == false) {
      if (_amountController.text.isNotEmpty) {
        setState(() {
          amountInput = _amountController.text.replaceAll(',', '');
          totalAmount = double.parse(amountInput!) * dto.quantity;
          vatAmount = totalAmount! * double.parse(dto.vat.toString()) / 100;
        });
      }
      if (serviceType != 9) {
        item = ServiceItemDTO(
            itemId: dto.itemId,
            content: dto.content,
            time: dto.time,
            unit: dto.unit,
            quantity: dto.quantity,
            amount: _amountController.text.isNotEmpty
                ? int.parse(amountInput!)
                : dto.amount,
            totalAmount: _amountController.text.isNotEmpty
                ? totalAmount!.round()
                : dto.totalAmount,
            vat: dto.vat,
            vatAmount: _amountController.text.isNotEmpty
                ? vatAmount!.round()
                : dto.vatAmount,
            amountAfterVat: _amountController.text.isNotEmpty
                ? (totalAmount! + vatAmount!).round()
                : dto.amountAfterVat,
            timeProcess: dto.timeProcess,
            type: dto.type);
        // model.confirmService(item);
      } else {
        totalAmount =
            double.parse(amountInput!) * int.parse(_quantityController.text);
        vatAmount = totalAmount! * int.parse(dto.vat.toString()) / 100;

        item = ServiceItemDTO(
            itemId: dto.itemId,
            time: dto.time,
            content: _contentController.text,
            unit: _unitController.text,
            quantity: int.parse(_quantityController.text),
            amount: int.parse(amountInput!),
            totalAmount: totalAmount!.round(),
            vat: dto.vat,
            vatAmount: vatAmount!.round(),
            amountAfterVat: (totalAmount! + vatAmount!).round(),
            timeProcess: dto.timeProcess,
            type: dto.type);
      }
      confirmService(item);
    } else {
      item = ServiceItemDTO(
          itemId: dto.itemId,
          time: dto.time,
          content: _contentController.text,
          unit: _unitController.text,
          quantity: int.parse(_quantityController.text),
          amount: int.parse(amountInput!),
          totalAmount: totalAmount!.round(),
          vat: dto.vat,
          vatAmount: vatAmount!.round(),
          amountAfterVat: (totalAmount! + vatAmount!).round(),
          timeProcess: dto.timeProcess,
          type: dto.type);
      confirmService(item);
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
          width: 1070,
          height: 700,
          child: ScopedModel<InvoiceViewModel>(
              model: _model,
              child: ScopedModelDescendant<InvoiceViewModel>(
                builder: (context, child, model) {
                  bool hasSelect = false;
                  if (model.serviceType == 9) {
                    if (_amountController.text.isNotEmpty &&
                        _contentController.text.isNotEmpty &&
                        _unitController.text.isNotEmpty &&
                        _quantityController.text.isNotEmpty &&
                        model.serviceItemDTO != null) {
                      hasSelect = true;
                    }
                  } else {
                    if (model.serviceItemDTO != null) {
                      hasSelect = true;
                    }
                  }
                  if (model.isInsert != null && model.isInsert == true) {
                    Navigator.of(context).pop();
                  }

                  return Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.isEdit == true ? 'Chỉnh sửa' : 'Thêm mới'} danh mục hàng hoá / dịch vụ',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 50),
                          Column(),
                          const Text(
                            'Thông tin khách hàng thanh toán',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 45),
                          Scrollbar(
                            controller: _horizontal,
                            child: SingleChildScrollView(
                              controller: _horizontal,
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: [
                                  _itemTitleWidget(false),
                                  _buildBankItem(
                                      dto: model.bankDetail,
                                      textAmount: model.vatTextController.text),
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
                          _serivceSelectWidget(),
                          const SizedBox(height: 45),
                          if (widget.isEdit == true) ...[
                            Scrollbar(
                              controller: _horizontal2,
                              child: SingleChildScrollView(
                                controller: _horizontal2,
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: [
                                    _itemTitleWidget(true),
                                    _buildItem(
                                        item: widget.dto,
                                        type: widget.dto?.type)
                                  ],
                                ),
                              ),
                            ),
                          ] else ...[
                            if (model.status == ViewStatus.Loading) ...[
                              const CircularProgressIndicator(),
                            ] else if (model.serviceItemDTO != null) ...[
                              Scrollbar(
                                controller: _horizontal2,
                                child: SingleChildScrollView(
                                  controller: _horizontal2,
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    children: [
                                      _itemTitleWidget(true),
                                      model.serviceItemDTO?.type ==
                                              model.serviceType
                                          ? _buildItem(
                                              item: model.serviceItemDTO,
                                              type: model.serviceType)
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              )
                            ] else
                              const SizedBox.shrink(),
                          ],
                          const Spacer(),
                          Visibility(
                              visible: model.isInsert == null
                                  ? false
                                  : !model.isInsert!,
                              child: const Center(
                                child: Text(
                                  'Dịch vụ này đã được thêm!',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.RED_TEXT),
                                ),
                              )),
                          const SizedBox(height: 20),
                          Container(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                onConfirmService(
                                  hasSelect,
                                  dto: widget.isEdit == true
                                      ? widget.dto!
                                      : model.serviceItemDTO!,
                                  serviceType: widget.isEdit == true
                                      ? widget.dto!.type
                                      : model.serviceType,
                                  confirmService: (item) async {
                                    if (widget.isEdit == true) {
                                      model.editService(item);
                                      Navigator.of(context).pop();
                                    } else {
                                      model.confirmService(item);
                                    }
                                  },
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.18,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: hasSelect == true
                                        ? AppColor.BLUE_TEXT
                                        : (widget.isEdit == true
                                            ? AppColor.BLUE_TEXT
                                            : AppColor.GREY_DADADA),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text(
                                    'Xác nhận',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: hasSelect == true
                                            ? AppColor.WHITE
                                            : (widget.isEdit == true
                                                ? AppColor.WHITE
                                                : AppColor.BLACK)),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
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

  Widget _serivceSelectWidget() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 350,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 100,
                    height: 20,
                    child: Text(
                      'Loại hàng hoá / dịch vụ*',
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
                        color: AppColor.GREY_DADADA,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: widget.isEdit == true
                            ? widget.dto?.type
                            : model.serviceType,
                        underline: const SizedBox.shrink(),
                        icon: const RotatedBox(
                          quarterTurns: 5,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem<int>(
                              value: 1,
                              child: Text(
                                "Phí giao dịch",
                              )),
                          DropdownMenuItem<int>(
                              value: 0,
                              child: Text(
                                "Phí thường niên / duy trì",
                              )),
                          DropdownMenuItem<int>(
                              value: 9,
                              child: Text(
                                "Phí khác",
                              )),
                        ],
                        onChanged: widget.isEdit == false
                            ? (value) async {
                                model.selectServiceType(value!);
                                if (value == 9) {
                                  await model.getService();
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 30),
            widget.isEdit == false && model.serviceType != 9
                ? SizedBox(
                    width: 250,
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 100,
                          height: 20,
                          child: Text(
                            'Thời gian*',
                            style: TextStyle(fontSize: 15),
                          ),
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
                              const Text('Tháng',
                                  style: TextStyle(fontSize: 15)),
                              const SizedBox(width: 20),
                              const SizedBox(
                                height: 40,
                                child: VerticalDivider(
                                  thickness: 1,
                                  color: AppColor.GREY_DADADA,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _onPickMonth(model.getPreviousMonth());
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 4),
                                  width: 140,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          selectDate == null
                                              ? 'Chọn tháng'
                                              : DateFormat('MM-yyyy')
                                                  .format(selectDate!),
                                          style: const TextStyle(fontSize: 15)),
                                      const Icon(
                                        Icons.calendar_month_outlined,
                                        color: AppColor.BLACK,
                                        size: 15,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : (widget.isEdit == true
                    ? SizedBox(
                        width: 250,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 100,
                              height: 20,
                              child: Text(
                                'Thời gian*',
                                style: TextStyle(fontSize: 15),
                              ),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Tháng',
                                      style: TextStyle(fontSize: 15)),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.dto!.time,
                                            style:
                                                const TextStyle(fontSize: 15)),
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
                      )
                    : const SizedBox.shrink()),
          ],
        );
      },
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

  Widget _buildItem({required ServiceItemDTO? item, int? type}) {
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
            color: type == 9 ? AppColor.WHITE : AppColor.GREY_DADADA,
            child: type == 9
                ? TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.only(top: 15),
                      border: InputBorder.none,
                      hintText: widget.dto != null
                          ? widget.dto?.content
                          : 'Nhập nội dung',
                      hintStyle: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                  )
                : SelectionArea(
                    child: Text(
                      item!.content,
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
            color: type == 9 ? AppColor.WHITE : AppColor.GREY_DADADA,
            child: type == 9
                ? TextField(
                    controller: _unitController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.only(top: 15),
                      border: InputBorder.none,
                      hintText:
                          widget.dto != null ? widget.dto?.unit : 'Nhập đơn vị',
                      hintStyle: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                  )
                : SelectionArea(
                    child: Text(
                      item!.unit,
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
            color: type == 9 ? AppColor.WHITE : AppColor.GREY_DADADA,
            child: type == 9
                ? TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        totalAmount =
                            double.parse(amountInput ?? '0') * int.parse(value);
                        vatAmount = totalAmount! *
                            double.parse(item!.vat.round().toString()) /
                            100;
                      } else {
                        totalAmount = double.parse(amountInput ?? '0') * 1;
                        vatAmount = totalAmount! *
                            double.parse(item!.vat.round().toString()) /
                            100;
                      }
                      hasInputAmount = true;
                      setState(() {});
                    },
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.only(top: 15),
                      border: InputBorder.none,
                      hintText: widget.dto != null
                          ? widget.dto?.quantity.toString()
                          : 'Nhập số lượng',
                      hintStyle: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                  )
                : SelectionArea(
                    child: Text(
                      item!.quantity.toString(),
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
                      (type == 9
                          ? int.parse(_quantityController.text.isNotEmpty
                              ? _quantityController.text
                              : '1')
                          : item!.quantity);
                  vatAmount =
                      totalAmount! * double.parse(item!.vat.toString()) / 100;
                  hasInputAmount = true;
                } else {
                  hasInputAmount = false;
                }
                setState(() {});
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 15),
                border: InputBorder.none,
                hintText: type == 9
                    ? widget.dto != null
                        ? StringUtils.formatNumberWithOutVND(widget.dto?.amount)
                        : 'Nhập đơn giá'
                    : StringUtils.formatNumberWithOutVND(item!.amount),
                hintStyle: TextStyle(
                    fontSize: 12,
                    color: type == 9 ? AppColor.GREY_TEXT : AppColor.BLACK),
                suffixIcon: type == 9
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
                    : StringUtils.formatNumberWithOutVND(item?.totalAmount),
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
                item!.vat.toString(),
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
                    : StringUtils.formatNumberWithOutVND(item.vatAmount),
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
                    : StringUtils.formatNumberWithOutVND(item.amountAfterVat),
                textAlign: TextAlign.left,
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
