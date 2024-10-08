// ignore_for_file: constant_identifier_names

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/models/DTO/data_filter_dto.dart';
import 'package:vietqr_admin/models/DTO/invoice_excel_dto.dart';
import 'package:vietqr_admin/models/DTO/invoice_info_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
import 'package:vietqr_admin/models/DTO/response_message_dto.dart';

import '../commons/constants/utils/log.dart';
import '../models/DAO/index.dart';
import '../models/DTO/bank_detail_dto.dart';
import '../models/DTO/bank_invoice_dto.dart';
import '../models/DTO/invocie_merchant_dto.dart';
import '../models/DTO/invoice_detail_dto.dart';
import '../models/DTO/invoice_detail_qr_dto.dart';
import '../models/DTO/invoice_dto.dart';
import '../models/DTO/service_item_dto.dart';

enum PageInvoice { LIST, DETAIL, EDIT }

enum InvoiceType {
  NONE,
  EMPTY,
  GET_INVOICE_DETAIL,
  REQUEST_PAYMENT,
}

enum PageUnpaidInvoice { LIST, DETAIL }

class InvoiceStatus extends BaseModel {
  InvoiceType _request = InvoiceType.NONE;
  InvoiceType get request => _request;

  void setInvoiceState(
      {required ViewStatus status, required InvoiceType request}) {
    _request = request;
    setState(status);
  }
}

class InvoiceViewModel extends InvoiceStatus {
  TextEditingController vatTextController = TextEditingController();
  // PageController pageController = PageController(initialPage: 0);

  late InvoiceDAO _dao;
  InvoiceDTO? invoiceDTO;
  UnpaidInvoiceDTO? unpaidInvoiceDTO;
  MerchantData? merchantData;
  MerchantDTO? merchantDTO;
  BankInvoiceDTO? bankDTO;
  BankDetailDTO? bankDetail;
  List<ServiceItemDTO>? listService = [];
  ServiceItemDTO? serviceItemDTO;
  ResponseMessageDTO? responseMsg;
  PaymentRequestDTO? paymentRequestDTO;
  String bankId = '';

  InvoiceDetailQrDTO? detailQrDTO;
  UnpaidInvoiceDetailQrDTO? unpaidDetailQrDTO;
  InvoiceDetailDTO? invoiceDetailDTO;
  InvoiceInfoDTO? invoiceInfo;
  List<InvoiceInfoItem>? listInvoiceItem = [];
  List<InvoiceItemDetailDTO> listInvoiceDetailItem = [];
  List<SelectInvoiceItem> listSelectInvoice = [];

  //Gợp hóa đơn
  List<SelectUnpaidInvoiceItem> listUnpaidSelectInvoice = [];
  SelectUnpaidInvoiceItem? currentSelectUnpaidInvoiceItem;

  List<PaymentRequestDTO> listPaymentRequest = [];
  List<UnpaidInvoiceItem> listUnpaidInvoiceItem = [];
  PaymentUnpaidRequestDTO paymentUnpaidRequest =
      PaymentUnpaidRequestDTO(bankIdRecharge: '', invoiceIds: []);
  InvoiceExcelDTO? invoiceExcelDTO;

  //list các item invoice đc chọn để gạch nợ
  List<SelectInvoiceItemDebt> listSelectInvoiceItemDebt = [];
  List<SelectTransactionItemDebt> listSelectTransactionItemDebt = [];
  List<InvoiceItemDebtRequestDTO> listInvoiceItemDebtRequest = [];
  List<TransactionInvoiceDebtRequestDTO> listTransactionInvoiceDebtRequest = [];
  List<TransactionMapInvoiceDTO> listTransactionInvoice = [];

  int totalUnpaidInvoice = 0;
  MerchantItem? selectMerchantItem;
  BankItem? selectBank;

  late DateTime selectedDate = getMonth();
  DataFilter valueFilterTime = const DataFilter(id: 9, name: 'Tất cả');

  List<DataFilter> listFilterTime = [
    const DataFilter(id: 9, name: 'Tất cả'),
    const DataFilter(id: 0, name: 'Tùy chọn')
  ];

  List<DataFilter> listFilterByTime = [
    const DataFilter(id: 1, name: '7 ngày gần nhất'),
    const DataFilter(id: 2, name: 'Hôm nay'),
    const DataFilter(id: 3, name: '1 tháng gần đây'),
    const DataFilter(id: 4, name: '3 tháng gần đây'),
    const DataFilter(id: 5, name: 'Khoảng thời gian'),
  ];

  int type = 0;
  int serviceType = 1;
  int subMenuType = 0;
  int? valueStatus = 0;
  int? filterByDate = 1;
  int pagingPage = 1;
  int pagingUnpaidInvoicePage = 1;
  int pagingTransItemPage = 1;
  String? selectInvoiceId;

  int totalAmount = 0;
  int totalVat = 0;
  int totalAmountVat = 0;

  int totalEditAmount = 0;
  int totalEditVat = 0;
  int totalEditAmountVat = 0;
  int totalTransaction = 0;
  int totalInvoiceItemDetail = 0;

  int currentPagePopupUnpaid = 0;
  String? currentInvoiceId;

  List<DropdownMenuItem<int>> listMenuDropInvoice() {
    List<DropdownMenuItem<int>> items = [
      const DropdownMenuItem<int>(
          value: 0,
          child: Text(
            "Mã hóa đơn",
            style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
          )),
      const DropdownMenuItem<int>(
          value: 1,
          child: Text(
            "TK ngân hàng",
            style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
          )),
      const DropdownMenuItem<int>(
          value: 2,
          child: Text(
            "TK VietQR",
            style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
          )),
      const DropdownMenuItem<int>(
          value: 3,
          child: Text(
            "Đại lý",
            style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
          )),
      const DropdownMenuItem<int>(
          value: 4,
          child: Text(
            "Trạng thái HĐ",
            style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
          )),
    ];

    return items;
  }

  List<DropdownMenuItem<int>> listMenuDropStatus() {
    List<DropdownMenuItem<int>> items = [
      const DropdownMenuItem<int>(
          value: 0,
          child: Text(
            "Chờ thanh toán",
            style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
          )),
      const DropdownMenuItem<int>(
          value: 1,
          child: Text(
            "Đã thanh toán",
            style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
          )),
    ];

    return items;
  }

  List<DropdownMenuItem<int>> listMenuDropMerchant() {
    List<DropdownMenuItem<int>> items = [
      const DropdownMenuItem<int>(
          value: 0,
          child: Text(
            "Tên đại lý",
            style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
          )),
      const DropdownMenuItem<int>(
          value: 1,
          child: Text(
            "Mã VSO",
            style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
          )),
    ];

    return items;
  }

  bool? isInsert;
  bool hasReachedMax = false;
  bool hasReachedTransMax = false;

  MetaDataDTO? metadata;
  MetaDataDTO? metaUnpaidInvoice;
  MetaDataDTO? metaTransactionItem;
  MetaDataDTO? createMetaData;

  PageInvoice pageType = PageInvoice.LIST;
  PageUnpaidInvoice pageUnpaidType = PageUnpaidInvoice.LIST;

  InvoiceViewModel() {
    _dao = InvoiceDAO();
  }

  init() {
    selectedDate = getMonth();
    valueFilterTime = const DataFilter(id: 9, name: 'Tất cả');
    notifyListeners();
  }

  clear() {
    listService = [];
    merchantDTO = null;
    bankDTO = null;
    selectMerchantItem = null;
    selectBank = null;
    bankDetail = null;
    detailQrDTO = null;
    totalAmount = 0;
    totalVat = 0;
    totalAmountVat = 0;
    vatTextController.clear();
  }

  void selectDateTime(DateTime value) async {
    selectedDate = value;
    notifyListeners();
  }

  void updateFilterTime(DataFilter value) {
    valueFilterTime = value;
    notifyListeners();
  }

  void updateInvoiceDTO(InvoiceDTO invoiceDTO) {
    this.invoiceDTO = invoiceDTO;
    notifyListeners();
  }

  void onChangePage(PageInvoice page) {
    pageType = page;
    notifyListeners();
  }

  void onChangePageUnpaid(PageUnpaidInvoice page) {
    pageUnpaidType = page;
    notifyListeners();
  }

  void updateSelectInvoiceId(String selectInvoiceId) {
    this.selectInvoiceId = selectInvoiceId;
    notifyListeners();
  }

  void updateCurrentSelectUnpaid(
      SelectUnpaidInvoiceItem? selectUnpaidInvoiceId) {
    currentSelectUnpaidInvoiceItem = selectUnpaidInvoiceId;
    notifyListeners();
  }

  void updatePagePopupUnpaid(int currentPage) {
    currentPagePopupUnpaid = currentPage;
    notifyListeners();
  }

  void updateCurrentInvoiceId(String invoiceId) {
    currentInvoiceId = invoiceId;
    notifyListeners();
  }

  void updateEmail(String phoneNo, String newEmail) {
    final listMerchant = merchantData!.items.map(
      (e) {
        if (e.vietQrAccount == phoneNo) {
          return e.copyWith(email: newEmail);
        }
        return e;
      },
    ).toList();
    merchantData!.items = listMerchant;
    notifyListeners();
  }

  void selectServiceType(int value) async {
    serviceType = value;
    isInsert = null;
    notifyListeners();
  }

  void clearDebt() {
    listSelectTransactionItemDebt = [];
    listInvoiceItemDebtRequest = [];
    listSelectInvoiceItemDebt = [];
    listTransactionInvoiceDebtRequest = [];
    totalInvoiceItemDetail = 0;
    totalTransaction = 0;
    notifyListeners();
  }

  void selectMerchant(MerchantItem item) {
    selectMerchantItem = item;

    selectBank = null;
    bankDetail = null;

    notifyListeners();
  }

  void clearSelectMerchant() {
    selectMerchantItem = null;
    notifyListeners();
  }

  void clearItem() {
    listService = [];
    totalAmount = 0;
    totalVat = 0;
    totalAmountVat = 0;
    bankDetail = null;
  }

  void bankSelect(BankItem item) async {
    selectBank = item;
    if (selectBank != null) {
      await getBankDetail();
    }

    notifyListeners();
  }

  void changeType(int value) {
    type = value;
    selectMerchantItem = null;
    selectBank = null;
    bankDetail = null;
    notifyListeners();
  }

  void updateBankIdRecharge(String id) {
    paymentUnpaidRequest.bankIdRecharge = id;
    notifyListeners();
  }

  void clearPaymentUnpaidRequest() {
    paymentUnpaidRequest =
        PaymentUnpaidRequestDTO(bankIdRecharge: '', invoiceIds: []);
    notifyListeners();
  }

  void changeTypeInvoice(int selectType) {
    subMenuType = selectType;
    notifyListeners();
  }

  void changeStatus(int? selectType) {
    valueStatus = selectType;
    notifyListeners();
  }

  void onEditInvoiceName(String? text) {
    invoiceInfo!.invoiceName = text!;
    notifyListeners();
  }

  void onEditDescription(String? text) {
    invoiceInfo!.description = text!;
    notifyListeners();
  }

  void removeInvoiceItem(InvoiceInfoItem? item) {
    listInvoiceItem?.removeWhere(
        (element) => element.invoiceItemId == item?.invoiceItemId);
    notifyListeners();
  }

  void confirmEditInvoiceItem(InvoiceInfoItem? item) {
    int? index = listInvoiceItem
        ?.indexWhere((e) => e.invoiceItemId == item!.invoiceItemId);
    totalEditAmount -= listInvoiceItem![index!].totalAmount;
    totalEditVat -= listInvoiceItem![index].vatAmount;
    totalEditAmountVat -= listInvoiceItem![index].totalAmountAfterVat;
    totalEditAmount += item!.totalAmount;
    totalEditVat += item.vatAmount;
    totalEditAmountVat += item.totalAmountAfterVat;
    listInvoiceItem![index] = item;
    notifyListeners();
  }

  void editVatInvoiceInfo(String? text) {
    vatTextController.value = TextEditingValue(
      text: text!,
      selection: TextSelection.collapsed(offset: text.length),
    );
    double vat = double.parse(
        text.isNotEmpty ? text : invoiceInfo!.userInformation.vat.toString());
    if (listInvoiceItem!.isNotEmpty) {
      double vatTotal = totalEditAmount * vat / 100;
      totalEditVat = vatTotal.round();
      totalEditAmountVat = totalEditAmount + totalEditVat;
      for (var item in listInvoiceItem!) {
        item.vat = double.parse(vat.toString());
        double vatAmount = item.totalAmount * vat / 100;
        item.vatAmount = vatAmount.toInt();
        item.totalAmountAfterVat = item.totalAmount + item.vatAmount;
      }
    }
    notifyListeners();
  }

  void onChangeVat(String? text) {
    vatTextController.value = TextEditingValue(
      text: text!,
      selection: TextSelection.collapsed(offset: text.length),
    );
    double vat =
        double.parse(text.isNotEmpty ? text : bankDetail!.vat.toString());
    if (listService!.isNotEmpty) {
      double vatTotal = totalAmount * vat / 100;
      totalVat = vatTotal.round();
      totalAmountVat = totalAmount + totalVat;
      for (var item in listService!) {
        item.vat = double.parse(vat.toString());
        double vatAmount = item.totalAmount * vat / 100;
        item.vatAmount = vatAmount.toInt();
        item.amountAfterVat = item.totalAmount + item.vatAmount;
      }
    }
    notifyListeners();
  }

  void deleteService(ServiceItemDTO? item) {
    listService?.removeWhere((e) => e.itemId == item?.itemId);
    totalAmount -= item!.totalAmount;
    totalVat -= item.vatAmount;
    totalAmountVat -= item.amountAfterVat;
    notifyListeners();
  }

  void editService(ServiceItemDTO? item) {
    if (item != null) {
      int? index = listService?.indexWhere((e) => e.itemId == item.itemId);
      totalAmount -= listService![index!].totalAmount;
      totalVat -= listService![index].vatAmount;
      totalAmountVat -= listService![index].amountAfterVat;
      totalAmount += item.totalAmount;
      totalVat += item.vatAmount;
      totalAmountVat += item.amountAfterVat;

      listService![index] = item;
    }

    notifyListeners();
  }

  void confirmService(ServiceItemDTO? item, {required bool isUpdatePage}) {
    if (!isUpdatePage) {
      bool hasId = listService!.any((e) => e.itemId == item?.itemId);
      if (hasId == false) {
        listService?.insert(listService!.length, item!);
        totalAmount += item!.totalAmount;
        totalVat += item.vatAmount;
        totalAmountVat += item.amountAfterVat;
        serviceItemDTO = null;
        isInsert = true;
      } else {
        isInsert = false;
      }
    } else {
      InvoiceInfoItem invoiceInfoItem = InvoiceInfoItem(
          invoiceItemId: item!.itemId,
          invoiceItemName: item.content,
          unit: item.unit,
          quantity: item.quantity,
          amount: item.amount,
          totalAmount: totalAmount,
          vat: item.vat,
          vatAmount: item.vatAmount,
          totalAmountAfterVat: item.amountAfterVat,
          timeProcess: item.timeProcess,
          type: item.type);
      bool hasId = listInvoiceItem!
          .any((e) => e.invoiceItemId == invoiceInfoItem.invoiceItemId);
      if (hasId == false) {
        listInvoiceItem?.insert(listInvoiceItem!.length, invoiceInfoItem);
        totalEditAmount += invoiceInfoItem.totalAmount;
        totalEditVat += invoiceInfoItem.vatAmount;
        totalEditAmountVat += invoiceInfoItem.totalAmountAfterVat;
        serviceItemDTO = null;
        isInsert = true;
      } else {
        isInsert = false;
      }
    }

    notifyListeners();
  }

  void resetConfirmService() {
    serviceItemDTO = null;
    isInsert = null;
    responseMsg = null;
    notifyListeners();
  }

  void clearTotalUnpaidInvoice() {
    totalUnpaidInvoice = 0;
    notifyListeners();
  }

  void selectPayment(int index) {
    for (var e in invoiceDetailDTO!.paymentRequestDTOS) {
      e.isChecked = false;
    }
    invoiceDetailDTO!.paymentRequestDTOS[index].isChecked = true;
    notifyListeners();
  }

  void changePayment(int index) {
    for (var e in invoiceDetailDTO!.paymentRequestDTOS) {
      e.isChecked = false;
    }
    invoiceDetailDTO!.paymentRequestDTOS[index].isChecked = true;
    paymentRequestDTO = invoiceDetailDTO!.paymentRequestDTOS
        .where(
          (e) => e.isChecked == true,
        )
        .first;
    notifyListeners();
  }

  void changeBankId(
      int index, String fromDate, String toDate, int page, int size) {
    for (var e in invoiceDetailDTO!.paymentRequestDTOS) {
      e.isChecked = false;
    }
    invoiceDetailDTO!.paymentRequestDTOS[index].isChecked = true;
    bankId = invoiceDetailDTO!.paymentRequestDTOS[index].bankId;
    listTransactionInvoiceDebtRequest = [];
    getTransactionInvoiceDebt(
        bankId: bankId,
        fromDate: fromDate,
        toDate: toDate,
        page: page,
        size: size);
    notifyListeners();
  }

  void selectPaymentRequest(int index) {
    for (var e in listPaymentRequest) {
      e.isChecked = false;
    }
    listPaymentRequest[index].isChecked = true;
    notifyListeners();
  }

  void appliedInvoiceItem(bool value, int index) {
    listSelectInvoice[index].isSelect = value;
    notifyListeners();
  }

  void appliedUnpaidInvoiceItem(bool value, int index) {
    listUnpaidSelectInvoice[index].isSelect = value;
    if (value) {
      //Thêm hóa đơn chưa thanh toán để thanh toán
      paymentUnpaidRequest.invoiceIds
          .add(listUnpaidSelectInvoice[index].unpaidInvoiceItem.invoiceId);
      //cập nhật tổng tiền
      totalUnpaidInvoice +=
          listUnpaidSelectInvoice[index].unpaidInvoiceItem.pendingAmount;
    } else {
      //Xóa hóa đơn chưa thanh toán để thanh toán
      paymentUnpaidRequest.invoiceIds
          .remove(listUnpaidSelectInvoice[index].unpaidInvoiceItem.invoiceId);
      //cập nhật tổng tiền
      totalUnpaidInvoice -=
          listUnpaidSelectInvoice[index].unpaidInvoiceItem.pendingAmount;
    }

    notifyListeners();
  }

  void appliedInvoiceItemDebt(bool value, int index) {
    listSelectInvoiceItemDebt[index].isSelect = value;
    if (value) {
      //Thêm hóa đơn để gạch nợ
      listInvoiceItemDebtRequest.add(InvoiceItemDebtRequestDTO(
          id: listSelectInvoiceItemDebt[index].invoiceItem.invoiceItemId,
          totalAfterVat: listSelectInvoiceItemDebt[index]
              .invoiceItem
              .totalAmountAfterVat
              .toDouble()));
      //cập nhật tổng tiền
      totalInvoiceItemDetail +=
          listSelectInvoiceItemDebt[index].invoiceItem.totalAmountAfterVat;
    } else {
      //Xóa hóa đơn gạch nợ
      listInvoiceItemDebtRequest.removeWhere(
        (element) =>
            element.id ==
            listSelectInvoiceItemDebt[index].invoiceItem.invoiceItemId,
      );
      //cập nhật tổng tiền
      totalInvoiceItemDetail -=
          listSelectInvoiceItemDebt[index].invoiceItem.totalAmountAfterVat;
    }
    notifyListeners();
  }

  void appliedTransationItemDebt(bool value, int index) {
    listSelectTransactionItemDebt[index].isSelect = value;
    if (value) {
      //Thêm GD để gạch nợ
      listTransactionInvoiceDebtRequest.add(
        TransactionInvoiceDebtRequestDTO(
          id: listSelectTransactionItemDebt[index]
              .transactionItem
              .transactionId,
          amount: listSelectTransactionItemDebt[index]
              .transactionItem
              .amount
              .toDouble(),
        ),
      );
      //cập nhật tổng tiền
      totalTransaction +=
          listSelectTransactionItemDebt[index].transactionItem.amount;
    } else {
      //Xóa GD
      listTransactionInvoiceDebtRequest.removeWhere(
        (element) =>
            element.id ==
            listSelectTransactionItemDebt[index].transactionItem.transactionId,
      );
      //cập nhật tổng tiền
      totalTransaction -=
          listSelectTransactionItemDebt[index].transactionItem.amount;
    }
    notifyListeners();
  }

  void appliedAllItem(bool value) {
    for (var e in listSelectInvoice) {
      e.isSelect = value;
    }
    notifyListeners();
  }

  void appliedAllUnpaidItem(bool value) {
    paymentUnpaidRequest.invoiceIds = [];
    totalUnpaidInvoice = 0;
    for (var e in listUnpaidSelectInvoice) {
      e.isSelect = value;
      if (value) {
        paymentUnpaidRequest.invoiceIds.add(e.unpaidInvoiceItem.invoiceId);
        totalUnpaidInvoice += e.unpaidInvoiceItem.pendingAmount;
      }
    }
    notifyListeners();
  }

  void appliedAllItemDebt(bool value) {
    totalInvoiceItemDetail = 0;
    //clear list
    listInvoiceItemDebtRequest = [];
    for (var e in listSelectInvoiceItemDebt) {
      e.isSelect = value;
      if (value && e.invoiceItem.status == 0) {
        listInvoiceItemDebtRequest.add(
          InvoiceItemDebtRequestDTO(
            id: e.invoiceItem.invoiceItemId,
            totalAfterVat: e.invoiceItem.totalAmountAfterVat.toDouble(),
          ),
        );
        totalInvoiceItemDetail += e.invoiceItem.totalAmountAfterVat;
      }
    }
    notifyListeners();
  }

  void appliedAllTransactionDebt(bool value) {
    //clear list
    listTransactionInvoiceDebtRequest = [];
    for (var e in listSelectTransactionItemDebt) {
      e.isSelect = value;
      if (value) {
        listTransactionInvoiceDebtRequest.add(
          TransactionInvoiceDebtRequestDTO(
            id: e.transactionItem.transactionId,
            amount: e.transactionItem.amount.toDouble(),
          ),
        );
        // totalUnpaidInvoice += e.unpaidInvoiceItem.pendingAmount;
      }
    }
    notifyListeners();
  }

  // void appliedInvoiceItem(bool value, int index) {
  //   listSelectInvoice[index].isSelect = value;
  //   checkIfAllSelected();
  //   notifyListeners();
  // }

  // void appliedAllItem(bool value) {
  //   isAllApplied = value;
  //   for (var e in listSelectInvoice) {
  //     if (e.invoiceItem.status == 1) {
  //       e.isSelect = false;
  //     } else {
  //       e.isSelect = value;
  //     }
  //   }
  //   notifyListeners();
  // }

  // void checkIfAllSelected() {
  //   isAllApplied = listSelectInvoice
  //       .every((item) => item.isSelect || item.invoiceItem.status == 1);
  // }

  DateTime getMonth() {
    DateTime now = DateTime.now();
    int newMonth = now.month;
    int newYear = now.year;

    if (newMonth < 1) {
      newMonth = 12; // Set month to December
      newYear--; // Decrement year
    }

    return DateTime(newYear, newMonth);
  }

  DateTime getPreviousMonth() {
    DateTime now = DateTime.now();
    int newMonth = now.month - 1;
    int newYear = now.year;

    if (newMonth < 1) {
      newMonth = 12; // Set month to December
      newYear--; // Decrement year
    }

    return DateTime(newYear, newMonth);
  }

  Future<bool> getFile(String invoiceId) async {
    try {
      final result = await _dao.getFile(invoiceId);
      return result;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool?> attachFile(
      String invoiceId, String fileName, Uint8List byte) async {
    try {
      final result = await _dao.attachFile(invoiceId, fileName, byte);
      if (result.status == 'SUCCESS') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool?> updateInfo(BuildContext context,
      {String bankId = '',
      String? bankAccount,
      String? bankShortName,
      String? email,
      String? vso,
      String? midName}) async {
    try {
      setState(ViewStatus.Empty);
      final result = await _dao.updateInfo(
          bankAccount: bankAccount,
          bankShortName: bankShortName,
          bankId: bankId,
          vso: vso,
          midName: midName,
          email: email);
      setState(ViewStatus.Completed);
      return result;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool?> editInvoice() async {
    try {
      setState(ViewStatus.Empty);
      bool? result = await _dao.editInvoice(
          bankIdRecharge: listPaymentRequest
              .firstWhere((element) => element.isChecked == true)
              .bankId,
          invoice: invoiceInfo,
          vat: vatTextController.text.isNotEmpty
              ? double.parse(vatTextController.text)
              : invoiceInfo!.userInformation.vat);
      if (result!) {
        setState(ViewStatus.Completed);
        return true;
      }
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
    return false;
  }

  Future<void> getInvoiceInfo(String id) async {
    try {
      setState(ViewStatus.Loading);
      invoiceInfo = await _dao.getInvoiceInfo(id);
      listPaymentRequest = invoiceInfo!.paymentRequestDTOS;
      if (invoiceInfo!.invoiceItems.isNotEmpty) {
        listInvoiceItem = invoiceInfo?.invoiceItems;
      }
      totalEditAmount = invoiceInfo!.totalAmount;
      totalEditVat = invoiceInfo!.vatAmount;
      totalEditAmountVat = invoiceInfo!.totalAfterVat;
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> getInvoiceExcel(String id) async {
    try {
      setState(ViewStatus.Loading);
      invoiceExcelDTO = await _dao.getInvoiceExcel(id);
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<bool?> createInvoice(
      {required String invoiceName,
      required String description,
      Uint8List? bytes,
      String fileName = ''}) async {
    try {
      setState(ViewStatus.Loading);
      final result = await _dao.createInvoice(
          bankIdRecharge: listPaymentRequest
              .firstWhere((element) => element.isChecked == true)
              .bankId,
          vat: vatTextController.text.isNotEmpty
              ? double.parse(vatTextController.text)
              : double.parse(bankDetail!.vat.toString()),
          bankId: selectBank!.bankId,
          merchantId: selectMerchantItem?.merchantId,
          invoiceName: invoiceName,
          description: description,
          list: listService!);
      if (result!.status == 'SUCCESS') {
        setState(
          ViewStatus.Completed,
        );
        if (fileName.isNotEmpty) {
          attachFile(result.message, fileName, bytes!);
        }
        return true;
      } else {
        setState(ViewStatus.Error);
        return false;
      }
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
    return false;
  }

  Future<bool?> deleteInvoice(String id) async {
    try {
      setState(ViewStatus.Loading);
      bool? result = await _dao.delelteInvoice(id);
      setState(ViewStatus.Completed);
      return result;
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
    return false;
  }

  Future<bool?> exportExcel(String id) async {
    try {
      setState(ViewStatus.Loading);
      bool? result = await _dao.exportExcel(id);
      setState(ViewStatus.Completed);
      return result;
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
    return false;
  }

  List<SelectInvoiceItem> mapToSelectInvoiceItems(
      List<InvoiceItemDetailDTO> invoiceItems) {
    return invoiceItems
        .map((item) => SelectInvoiceItem(isSelect: true, invoiceItem: item))
        .toList();
  }

  List<SelectInvoiceItemDebt> mapToSelectInvoiceItemsDebt(
      List<InvoiceItemDetailDTO> invoiceItems) {
    return invoiceItems
        .map((item) => SelectInvoiceItemDebt(isSelect: true, invoiceItem: item))
        .toList();
  }

  List<SelectUnpaidInvoiceItem> mapToSelectUnpaidInvoiceItems(
      List<UnpaidInvoiceItem> unpaidInvoiceItems) {
    paymentUnpaidRequest.invoiceIds = [];
    for (var e in unpaidInvoiceItems) {
      paymentUnpaidRequest.invoiceIds.add(e.invoiceId);
    }
    return unpaidInvoiceItems
        .map((item) =>
            SelectUnpaidInvoiceItem(isSelect: true, unpaidInvoiceItem: item))
        .toList();
  }

  Future<void> getInvoiceDetail(String id, {bool isRemoveDebt = false}) async {
    try {
      // setState(ViewStatus.Empty);
      setInvoiceState(
          status: ViewStatus.Loading, request: InvoiceType.GET_INVOICE_DETAIL);

      invoiceDetailDTO = await _dao.getInvoiceDetail(id);
      if (invoiceDetailDTO != null) {
        listInvoiceDetailItem = invoiceDetailDTO!.invoiceItemDetailDTOS;

        listSelectInvoice =
            mapToSelectInvoiceItems(invoiceDetailDTO!.invoiceItemDetailDTOS);

        paymentRequestDTO = invoiceDetailDTO!.paymentRequestDTOS
            .where(
              (e) => e.isChecked == true,
            )
            .first;

        if (isRemoveDebt) {
          listSelectInvoiceItemDebt = mapToSelectInvoiceItemsDebt(
              invoiceDetailDTO!.invoiceItemDetailDTOS);
          totalInvoiceItemDetail = 0;

          if (listSelectInvoiceItemDebt.isNotEmpty) {
            listInvoiceItemDebtRequest.addAll(
              listSelectInvoiceItemDebt
                  .where((item) => item.invoiceItem.status == 0)
                  .map(
                    (item) => InvoiceItemDebtRequestDTO(
                      id: item.invoiceItem.invoiceItemId,
                      totalAfterVat:
                          item.invoiceItem.totalAmountAfterVat.toDouble(),
                    ),
                  )
                  .toList(),
            );

            for (var e in listSelectInvoiceItemDebt) {
              if (e.isSelect != null) {
                if (e.isSelect! && e.invoiceItem.status == 0) {
                  totalInvoiceItemDetail += e.invoiceItem.totalAmountAfterVat;
                }
              }
            }
          }

          bankId = invoiceDetailDTO!.paymentRequestDTOS
              .where(
                (e) => e.isChecked == true,
              )
              .first
              .bankId;
        }
      }
      setInvoiceState(
          status: ViewStatus.Completed,
          request: InvoiceType.GET_INVOICE_DETAIL);
    } catch (e) {
      LOG.error(e.toString());
      setInvoiceState(
          status: ViewStatus.Error, request: InvoiceType.GET_INVOICE_DETAIL);
    }
  }

  Future<void> getListRequestPayment() async {
    try {
      listPaymentRequest = await _dao.getListPaymentRequest();
      notifyListeners();
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  Future<InvoiceDetailQrDTO?> requestPayment(
      {required String invoiceId}) async {
    try {
      setInvoiceState(
          status: ViewStatus.Loading, request: InvoiceType.REQUEST_PAYMENT);
      detailQrDTO = await _dao.requestPaymnet(
        invoiceId: invoiceId,
        itemItemIds: List<String>.from(listSelectInvoice
            .where((e) => e.isSelect == true && e.invoiceItem.status == 0)
            .toList()
            .map(
              (x) => x.invoiceItem.invoiceItemId,
            )),
        bankIdRecharge: invoiceDetailDTO!.paymentRequestDTOS
            .firstWhere((element) => element.isChecked == true)
            .bankId,
      );
      if (detailQrDTO != null) {
        setInvoiceState(
            status: ViewStatus.Completed, request: InvoiceType.REQUEST_PAYMENT);
        return detailQrDTO;
      } else {
        setInvoiceState(
            status: ViewStatus.Error, request: InvoiceType.REQUEST_PAYMENT);
        return null;
      }
    } catch (e) {
      LOG.error(e.toString());
      setInvoiceState(
          status: ViewStatus.Error, request: InvoiceType.REQUEST_PAYMENT);
    }
    return null;
  }

  Future<UnpaidInvoiceDetailQrDTO?> requestPaymentV2(
      {required PaymentUnpaidRequestDTO request}) async {
    try {
      setInvoiceState(
          status: ViewStatus.Loading, request: InvoiceType.REQUEST_PAYMENT);
      unpaidDetailQrDTO = await _dao.requestPaymnetV2(
          invoiceIds: request.invoiceIds,
          bankIdRecharge: request.bankIdRecharge);
      if (unpaidDetailQrDTO != null) {
        setInvoiceState(
            status: ViewStatus.Completed, request: InvoiceType.REQUEST_PAYMENT);
        clearPaymentUnpaidRequest();
        return unpaidDetailQrDTO;
      } else {
        setInvoiceState(
            status: ViewStatus.Error, request: InvoiceType.REQUEST_PAYMENT);
        return null;
      }
    } catch (e) {
      LOG.error(e.toString());
      setInvoiceState(
          status: ViewStatus.Error, request: InvoiceType.REQUEST_PAYMENT);
    }
    return null;
  }

  Future<void> filterListInvoice({
    required int page,
    required int size,
    required int filterType,
    required int invoiceType,
    int? subType,
    required String search,
  }) async {
    try {
      String formattedDate = '';
      formattedDate = valueFilterTime.id == 9
          ? ''
          : DateFormat('yyyy-MM').format(selectedDate);
      setState(ViewStatus.Loading);
      final result = await _dao.filterInvoiceList(
          page: page,
          size: size,
          filterType: filterType,
          subFilterType: subType ?? subMenuType,
          invoiceType: invoiceType,
          time: formattedDate,
          value: search);
      if (result != null) {
        if (result is InvoiceDTO) {
          invoiceDTO = result;
        } else {
          merchantData = result;
        }
      } else {
        setState(ViewStatus.Error);
        return;
      }

      metadata = _dao.metaDataDTO;
      await Future.delayed(const Duration(milliseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> getTransactionInvoiceDebt({
    required String bankId,
    required String fromDate,
    required String toDate,
    required int page,
    required int size,
  }) async {
    try {
      // String formattedDate = '';
      // formattedDate = valueFilterTime.id == 9
      //     ? ''
      //     : DateFormat('yyyy-MM').format(selectedDate);
      setState(ViewStatus.Loading_Transaction_Item_Debt);
      final result = await _dao.getTransactionInvoices(
          bankId, fromDate, toDate, page, size);
      listSelectTransactionItemDebt = [];
      // ignore: unnecessary_null_comparison
      if (result != null) {
        // listTransactionInvoice = result;
        metaTransactionItem = _dao.metaDataDTO;
        listSelectTransactionItemDebt = result
            .map(
              (e) => SelectTransactionItemDebt(
                  transactionItem: e, isSelect: false),
            )
            .toList();

        if (metaTransactionItem != null) {
          if (metaTransactionItem!.total == result.length) {
            hasReachedTransMax = true;
          } else {
            hasReachedTransMax = false;
          }
        }
      } else {
        setState(ViewStatus.Error);
        return;
      }

      metadata = _dao.metaDataDTO;
      await Future.delayed(const Duration(milliseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<bool> mapInvoiceDebt(
      {required String invoiceId,
      required List<InvoiceItemDebtRequestDTO> invoiceItemList,
      required List<TransactionInvoiceDebtRequestDTO> transactionList}) async {
    try {
      final result = await _dao.mapInvoiceDebt(
          invoiceId, invoiceItemList, transactionList);
      // ignore: unnecessary_null_comparison
      if (result != null) {
        if (result.status == 'SUCCESS') {
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
    return false;
  }

  Future<void> getQrDetail(String id) async {
    try {
      setState(ViewStatus.Loading);
      detailQrDTO = await _dao.getDetailQr(id);
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> getService({String? time}) async {
    try {
      setState(ViewStatus.Loading);
      final result = await _dao.getServiceItem(
          vat: bankDetail?.vat,
          type: serviceType,
          bankId: bankDetail?.bankId,
          merchantId: type == 0 ? selectMerchantItem?.merchantId : '',
          time: serviceType == 9 ? '' : time);
      if (result is ServiceItemDTO) {
        serviceItemDTO = result;
        responseMsg = null;
      } else {
        responseMsg = result;
      }
      if (vatTextController.text.isNotEmpty) {
        serviceItemDTO?.vat = double.parse(vatTextController.text);
        double vat = serviceItemDTO!.vat / 100;
        double vatAmount = serviceItemDTO!.totalAmount * vat;
        serviceItemDTO!.vatAmount = vatAmount.round();

        serviceItemDTO?.amountAfterVat =
            serviceItemDTO!.totalAmount + serviceItemDTO!.vatAmount;
      }

      Future.delayed(const Duration(milliseconds: 500));

      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> getMerchant(String? value,
      {int? page, required bool isGetList}) async {
    try {
      if (isGetList == false) {
        setState(ViewStatus.Loading);
      }

      merchantDTO = await _dao.getMerchant(page: page ?? 1, value: value ?? '');
      createMetaData = _dao.metaDataDTO;
      Future.delayed(const Duration(milliseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> getBanks(String? value, {int? page, String? merchantId}) async {
    try {
      setState(ViewStatus.Loading);
      bankDTO = await _dao.getBankList(
          page: page ?? 1, value: value ?? '', merchantId: merchantId);
      createMetaData = _dao.metaDataDTO;
      Future.delayed(const Duration(milliseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> getBankDetail({String? id}) async {
    try {
      setState(id != null ? ViewStatus.Empty : ViewStatus.Loading);
      bankDetail = await _dao.getBankDetail(
          bankId: id ?? selectBank?.bankId,
          merchantId: type == 0 ? selectMerchantItem?.merchantId : '');
      // if (vatTextController.text.isNotEmpty) {
      //   bankDetail?.vat = double.parse(vatTextController.text);
      // }
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<bool> updateEmailMerchant(
      {required String phoneNo, required String newEmail}) async {
    try {
      setState(ViewStatus.Updating);
      final ResponseMessageDTO? data =
          await _dao.updateEmailMerchant(phoneNo, newEmail);
      if (data != null) {
        if (data.status == 'SUCCESS') {
          setState(ViewStatus.Completed);

          // merchantData!.items
          //     .where(
          //       (e) => e.vietQrAccount == phoneNo,
          //     )
          //     .first
          //     .copyWith(email: newEmail);
          // notifyListeners();
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
    return false;
  }

  Future<void> getUnpaidInvoiceList({
    required int page,
    required int size,
    required String merchantId,
  }) async {
    try {
      setState(ViewStatus.Loading_Page_View);
      final result = await _dao.getUnpaidInvoiceList(
          page: page, size: size, merchantId: merchantId);
      listUnpaidInvoiceItem = [];
      if (result is UnpaidInvoiceDTO) {
        unpaidInvoiceDTO = result;
        // ignore: unnecessary_null_comparison
        metaUnpaidInvoice = _dao.metaDataDTO;

        // ignore: unnecessary_null_comparison
        if (unpaidInvoiceDTO!.items != null) {
          if (metaUnpaidInvoice != null) {
            if (metaUnpaidInvoice!.total == unpaidInvoiceDTO!.items.length) {
              hasReachedMax = true;
              listUnpaidInvoiceItem = unpaidInvoiceDTO!.items;
            } else {
              hasReachedMax = false;
              listUnpaidInvoiceItem = unpaidInvoiceDTO!.items;
            }
          }
          listUnpaidSelectInvoice =
              mapToSelectUnpaidInvoiceItems(listUnpaidInvoiceItem);
          totalUnpaidInvoice = 0;

          for (var e in listUnpaidSelectInvoice) {
            if (e.isSelect != null) {
              if (e.isSelect!) {
                totalUnpaidInvoice += e.unpaidInvoiceItem.pendingAmount;
              }
            }
          }
          notifyListeners();
        }
      }

      await Future.delayed(const Duration(milliseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> loadMoreUnpaidInvoiceList({
    required ScrollController scrollController,
    required String merchantId,
  }) async {
    try {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (hasReachedMax) {
          hasReachedMax = true;
          listUnpaidInvoiceItem = List.from(listUnpaidInvoiceItem);
          pagingUnpaidInvoicePage = 1;
        } else {
          // isLoadingMore = true;
          pagingUnpaidInvoicePage++;
          final result = await _dao.getUnpaidInvoiceList(
              page: pagingUnpaidInvoicePage, size: 50, merchantId: merchantId);
          if (result is UnpaidInvoiceDTO) {
            unpaidInvoiceDTO = result;
            // ignore: unnecessary_null_comparison
            metaUnpaidInvoice = _dao.metaDataDTO;
            // ignore: unnecessary_null_comparison
            if (unpaidInvoiceDTO!.items != null) {
              if (metaUnpaidInvoice != null) {
                if (unpaidInvoiceDTO!.items.isEmpty) {
                  hasReachedMax = true;
                  listUnpaidInvoiceItem = List.from(listUnpaidInvoiceItem);
                  pagingUnpaidInvoicePage = 1;
                } else {
                  hasReachedMax = false;
                  listUnpaidInvoiceItem = List.from(listUnpaidInvoiceItem)
                    ..addAll(unpaidInvoiceDTO!.items);
                }
              }

              //map list select
              listUnpaidSelectInvoice =
                  mapToSelectUnpaidInvoiceItems(listUnpaidInvoiceItem);

              //sum of unpaid invoice
              totalUnpaidInvoice = 0;
              for (var e in listUnpaidSelectInvoice) {
                if (e.isSelect != null) {
                  if (e.isSelect!) {
                    totalUnpaidInvoice += e.unpaidInvoiceItem.pendingAmount;
                  }
                }
              }
              notifyListeners();
            }
          }
        }
      }

      await Future.delayed(const Duration(milliseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> loadMoreTransactionInvoiceList({
    required ScrollController scrollController,
    required String bankId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (hasReachedTransMax) {
          hasReachedTransMax = true;
          listSelectTransactionItemDebt =
              List.from(listSelectTransactionItemDebt);
          pagingTransItemPage = 1;
        } else {
          // isLoadingMore = true;
          pagingTransItemPage++;
          final result = await _dao.getTransactionInvoices(
              bankId, fromDate, toDate, pagingTransItemPage, 20);
          // ignore: unnecessary_null_comparison
          if (result != null) {
            // ignore: unnecessary_null_comparison
            metaTransactionItem = _dao.metaDataDTO;
            // ignore: unnecessary_null_comparison
            if (metaTransactionItem != null) {
              if (result.isEmpty) {
                hasReachedTransMax = true;
                listSelectTransactionItemDebt =
                    List.from(listSelectTransactionItemDebt);
                pagingTransItemPage = 1;
              } else {
                hasReachedTransMax = false;
                listSelectTransactionItemDebt =
                    List.from(listSelectTransactionItemDebt)
                      ..addAll(result
                          .map(
                            (e) => SelectTransactionItemDebt(
                                transactionItem: e, isSelect: false),
                          )
                          .toList());
              }
              notifyListeners();
            }
          }
        }
      }

      await Future.delayed(const Duration(milliseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }
}

class SelectInvoiceItem {
  bool? isSelect;
  final InvoiceItemDetailDTO invoiceItem;

  SelectInvoiceItem({
    this.isSelect,
    required this.invoiceItem,
  });
}

class SelectUnpaidInvoiceItem {
  bool? isSelect;
  final UnpaidInvoiceItem unpaidInvoiceItem;

  SelectUnpaidInvoiceItem({
    this.isSelect,
    required this.unpaidInvoiceItem,
  });
}

class SelectInvoiceItemDebt {
  bool? isSelect;
  final InvoiceItemDetailDTO invoiceItem;

  SelectInvoiceItemDebt({
    this.isSelect,
    required this.invoiceItem,
  });
}

class SelectTransactionItemDebt {
  bool? isSelect;
  final TransactionMapInvoiceDTO transactionItem;

  SelectTransactionItemDebt({
    this.isSelect,
    required this.transactionItem,
  });
}
