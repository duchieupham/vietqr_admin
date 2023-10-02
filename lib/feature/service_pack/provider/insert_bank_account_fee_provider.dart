import 'package:flutter/material.dart';
import 'package:vietqr_admin/models/service_fee_dto.dart';

class InsertBankAccountFeeProvider with ChangeNotifier {
  MerchantFee _valueRadio = const MerchantFee();
  MerchantFee get valueRadio => _valueRadio;

  MerchantBankAccount _valueSubItem = const MerchantBankAccount();
  MerchantBankAccount get valueSubItem => _valueSubItem;

  changeValueRatio(MerchantFee merchantFee) {
    _valueRadio = merchantFee;
    notifyListeners();
  }

  changeValueSubItem(MerchantBankAccount valueSubItem) {
    _valueRadio = const MerchantFee();
    _valueSubItem = valueSubItem;
    notifyListeners();
  }
}
