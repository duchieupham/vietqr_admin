import 'package:flutter/material.dart';

import '../../../../models/DTO/merchant_fee_dto.dart';

class InsertBankAccountFeeProvider with ChangeNotifier {
  MerchantFee _valueRadio = const MerchantFee();
  MerchantFee get valueRadio => _valueRadio;

  MerchantBankAccount _valueSubItem = const MerchantBankAccount();
  MerchantBankAccount get valueSubItem => _valueSubItem;

  final List<MerchantBankAccount> _listValueSubItem = [];
  List<MerchantBankAccount> get listValueSubItem => _listValueSubItem;

  changeValueRatio(MerchantFee merchantFee) {
    _valueRadio = merchantFee;
    _valueSubItem = const MerchantBankAccount();
    notifyListeners();
  }

  changeValueSubItem(MerchantBankAccount valueSubItem) {
    _valueRadio = const MerchantFee();
    _valueSubItem = valueSubItem;

    notifyListeners();
  }
}
