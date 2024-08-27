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

// ignore: constant_identifier_names
enum PageInvoice { LIST, DETAIL, EDIT }

enum InvoiceType {
  NONE,
  EMPTY,
  GET_INVOICE_DETAIL,
  REQUEST_PAYMENT,
}

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

  late InvoiceDAO _dao;
  InvoiceDTO? invoiceDTO;
  MerchantData? merchantData;
  MerchantDTO? merchantDTO;
  BankInvoiceDTO? bankDTO;
  BankDetailDTO? bankDetail;
  List<ServiceItemDTO>? listService = [];
  ServiceItemDTO? serviceItemDTO;
  ResponseMessageDTO? responseMsg;

  InvoiceDetailQrDTO? detailQrDTO;
  InvoiceDetailDTO? invoiceDetailDTO;
  InvoiceInfoDTO? invoiceInfo;
  List<InvoiceInfoItem>? listInvoiceItem = [];
  List<InvoiceItemDetailDTO> listInvoiceDetailItem = [];
  List<SelectInvoiceItem> listSelectInvoice = [];
  List<PaymentRequestDTO> listPaymentRequest = [];
  InvoiceExcelDTO? invoiceExcelDTO;

  MerchantItem? selectMerchantItem;
  BankItem? selectBank;

  late DateTime selectedDate = getMonth();
  DataFilter valueFilterTime = const DataFilter(id: 9, name: 'Tất cả');

  List<DataFilter> listFilterTime = [
    const DataFilter(id: 9, name: 'Tất cả'),
    const DataFilter(id: 0, name: 'Tùy chọn')
  ];

  int type = 0;
  int serviceType = 1;
  int subMenuType = 0;
  int? valueStatus = 0;
  int? filterByDate = 1;
  int pagingPage = 1;

  int totalAmount = 0;
  int totalVat = 0;
  int totalAmountVat = 0;

  int totalEditAmount = 0;
  int totalEditVat = 0;
  int totalEditAmountVat = 0;

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

  MetaDataDTO? metadata;
  MetaDataDTO? createMetaData;

  PageInvoice pageType = PageInvoice.LIST;

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

  void onChangePage(PageInvoice page) {
    pageType = page;
    notifyListeners();
  }

  void selectServiceType(int value) async {
    serviceType = value;
    isInsert = null;
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

  void selectPayment(int index) {
    for (var e in invoiceDetailDTO!.paymentRequestDTOS) {
      e.isChecked = false;
    }
    invoiceDetailDTO!.paymentRequestDTOS[index].isChecked = true;
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

  void appliedAllItem(bool value) {
    for (var e in listSelectInvoice) {
      e.isSelect = value;
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

  Future<void> getInvoiceDetail(String id) async {
    try {
      // setState(ViewStatus.Empty);
      setInvoiceState(
          status: ViewStatus.Loading, request: InvoiceType.GET_INVOICE_DETAIL);

      invoiceDetailDTO = await _dao.getInvoiceDetail(id);
      if (invoiceDetailDTO != null) {
        listInvoiceDetailItem = invoiceDetailDTO!.invoiceItemDetailDTOS;
        listSelectInvoice =
            mapToSelectInvoiceItems(invoiceDetailDTO!.invoiceItemDetailDTOS);
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
      if (result is InvoiceDTO) {
        invoiceDTO = result;
      } else {
        merchantData = result;
      }
      metadata = _dao.metaDataDTO;
      await Future.delayed(const Duration(milliseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
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
}

class SelectInvoiceItem {
  bool? isSelect;
  final InvoiceItemDetailDTO invoiceItem;

  SelectInvoiceItem({
    this.isSelect,
    required this.invoiceItem,
  });
}
