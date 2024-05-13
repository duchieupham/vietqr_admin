import 'package:flutter/material.dart';
import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';

import '../commons/utils/log.dart';
import '../models/DAO/index.dart';
import '../models/DTO/bank_invoice_dto.dart';
import '../models/DTO/invocie_merchant_dto.dart';

class InvoiceViewModel extends BaseModel {
  late InvoiceDAO _dao;
  MerchantDTO? merchantDTO;
  BankInvoiceDTO? bankDTO;
  MetaDataDTO? metaData;
  MerchantItem? selectMerchantItem;
  BankItem? selectBank;
  int type = 0;

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

  Future<void> getMerchant(String? value, {int? page}) async {
    try {
      setState(ViewStatus.Loading);
      merchantDTO = await _dao.getMerchant(page: page ?? 1, value: value ?? '');
      metaData = _dao.metaDataDTO;
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
      metaData = _dao.metaDataDTO;
      Future.delayed(const Duration(milliseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }
}
