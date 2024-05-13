import 'package:intl/intl.dart';
import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';

import '../commons/constants/enum/view_status.dart';
import '../commons/constants/utils/log.dart';
import '../models/DAO/index.dart';
import '../models/DTO/bank_invoice_dto.dart';
import '../models/DTO/invocie_merchant_dto.dart';
import '../models/DTO/invoice_dto.dart';
import '../models/DTO/metadata_dto.dart';

class InvoiceViewModel extends BaseModel {
  late InvoiceDAO _dao;
  InvoiceDTO? invoiceDTO;
  MerchantDTO? merchantDTO;
  BankInvoiceDTO? bankDTO;

  MerchantItem? selectMerchantItem;
  BankItem? selectBank;
  int type = 0;
  int? value = 9;
  int? valueStatus = 0;
  int? filterByDate = 1;
  MetaDataDTO? metadata;
  MetaDataDTO? createMetaData;

  InvoiceViewModel() {
    _dao = InvoiceDAO();
    merchantDTO = null;
    selectMerchantItem = null;
  }

  clear() {
    merchantDTO = null;
    bankDTO = null;
    selectMerchantItem = null;
    selectBank = null;
  }

  void selectMerchant(MerchantItem item) {
    selectMerchantItem = item;
    selectBank = null;
    notifyListeners();
  }

  void bankSelect(BankItem item) {
    selectBank = item;
    notifyListeners();
  }

  void changeType(int value) {
    type = value;
    selectMerchantItem = null;
    selectBank = null;
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

  Future<void> filterListInvoice({
    required DateTime time,
    required int page,
    int? size,
  }) async {
    try {
      String formattedDate = '';
      formattedDate = DateFormat('yyyy-MM').format(time);
      setState(ViewStatus.Loading);
      invoiceDTO = await _dao.filterInvoiceList(
          type: value!, time: formattedDate, page: page, value: value!);
      metadata = _dao.metaDataDTO;
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> getMerchant(String? value, {int? page}) async {
    try {
      setState(ViewStatus.Loading);
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
}
