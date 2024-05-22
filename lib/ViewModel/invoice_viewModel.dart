import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/models/DTO/invoice_info_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';

import '../commons/constants/enum/view_status.dart';
import '../commons/constants/utils/log.dart';
import '../models/DAO/index.dart';
import '../models/DTO/bank_detail_dto.dart';
import '../models/DTO/bank_invoice_dto.dart';
import '../models/DTO/invocie_merchant_dto.dart';
import '../models/DTO/invoice_detail_dto.dart';
import '../models/DTO/invoice_detail_qr_dto.dart';
import '../models/DTO/invoice_dto.dart';
import '../models/DTO/metadata_dto.dart';
import '../models/DTO/service_item_dto.dart';

class InvoiceViewModel extends BaseModel {
  final TextEditingController vatTextController = TextEditingController();
  late InvoiceDAO _dao;
  InvoiceDTO? invoiceDTO;
  MerchantDTO? merchantDTO;
  BankInvoiceDTO? bankDTO;
  BankDetailDTO? bankDetail;
  List<ServiceItemDTO>? listService = [];
  ServiceItemDTO? serviceItemDTO;

  InvoiceDetailQrDTO? detailQrDTO;
  InvoiceDetailDTO? invoiceDetailDTO;
  InvoiceInfoDTO? invoiceInfo;
  List<InvoiceInfoItem>? listInvoiceItem = [];

  MerchantItem? selectMerchantItem;
  BankItem? selectBank;

  int type = 0;
  int serviceType = 0;
  int? value = 9;
  int? valueStatus = 0;
  int? filterByDate = 1;

  int totalAmount = 0;
  int totalVat = 0;
  int totalAmountVat = 0;

  int totalEditAmount = 0;
  int totalEditVat = 0;
  int totalEditAmountVat = 0;

  bool? isInsert;

  MetaDataDTO? metadata;
  MetaDataDTO? createMetaData;

  InvoiceViewModel() {
    _dao = InvoiceDAO();
  }

  clear() {
    listService = [];
    merchantDTO = null;
    bankDTO = null;
    selectMerchantItem = null;
    selectBank = null;
    bankDetail = null;
    detailQrDTO = null;
    vatTextController.clear();
  }

  void selectServiceType(int value) async {
    serviceType = value;
    // if (value == 9) {
    //   await getService();
    // }
    notifyListeners();
  }

  void selectMerchant(MerchantItem item) {
    selectMerchantItem = item;
    selectBank = null;
    bankDetail = null;
    notifyListeners();
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

  void changeTypeInvoice(int? selectType) {
    value = selectType;
    notifyListeners();
  }

  void changeStatus(int? selectType) {
    valueStatus = selectType;
    notifyListeners();
  }

  void editVatInvoiceInfo(String? text) {
    double vat = double.parse(
        text!.isNotEmpty ? text : invoiceInfo!.userInformation.vat.toString());
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
    double vat =
        double.parse(text!.isNotEmpty ? text : bankDetail!.vat.toString());
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
    int? index = listService?.indexWhere((item) => item.itemId == item.itemId);
    listService![index!] = item!;
    notifyListeners();
  }

  void confirmService(ServiceItemDTO? item) {
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

    notifyListeners();
  }

  void resetConfirmService() {
    serviceItemDTO = null;
    isInsert = null;
    notifyListeners();
  }

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

  Future<void> getInvoiceInfo(String id) async {
    try {
      setState(ViewStatus.Loading);
      invoiceInfo = await _dao.getInvoiceInfo(id);
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

  Future<bool?> createInvoice(
      {required String invoiceName, required String description}) async {
    try {
      setState(ViewStatus.Loading);
      bool? result = await _dao.createInvoice(
          vat: double.parse(bankDetail!.vat.toString()),
          bankId: selectBank!.bankId,
          merchantId: selectMerchantItem != null
              ? selectMerchantItem?.merchantId
              : null,
          invoiceName: invoiceName,
          description: description,
          list: listService!);
      if (result!) {
        setState(ViewStatus.Completed);
      } else {
        setState(ViewStatus.Error);
      }
      print('Create Invoice: ------${result}');
      return result;
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

  Future<void> getInvoiceDetail(String id) async {
    try {
      setState(ViewStatus.Loading);

      invoiceDetailDTO = await _dao.getInvoiceDetail(id);
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> filterListInvoice({
    required DateTime time,
    required int page,
    int? size,
    required String filter,
  }) async {
    try {
      String formattedDate = '';
      formattedDate = DateFormat('yyyy-MM').format(time);
      setState(ViewStatus.Loading);
      invoiceDTO = await _dao.filterInvoiceList(
          type: value!, time: formattedDate, page: page, filter: filter);
      metadata = _dao.metaDataDTO;
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
      serviceItemDTO = await _dao.getServiceItem(
          vat: bankDetail?.vat,
          type: serviceType,
          bankId: bankDetail?.bankId,
          merchantId: type == 0 ? selectMerchantItem?.merchantId : '',
          time: serviceType == 9 ? '' : time);
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
