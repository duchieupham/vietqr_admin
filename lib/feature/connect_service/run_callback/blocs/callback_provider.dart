import 'package:flutter/material.dart';
import 'package:vietqr_admin/models/bank_account_dto.dart';
import 'package:vietqr_admin/models/callback_dto.dart';
import 'package:vietqr_admin/models/customer_dto.dart';

class CallbackProvider with ChangeNotifier {
  CustomerDTO customerDTO = const CustomerDTO();
  BankAccountDTO bankAccountDTO = const BankAccountDTO();
  CallBackDTO callBackDTO = CallBackDTO();

  updateCallbackDTO(value) {
    callBackDTO = value;
    notifyListeners();
  }

  updateCustomer(value) {
    customerDTO = value;
    notifyListeners();
  }

  updateBankAccount(value) {
    bankAccountDTO = value;
    notifyListeners();
  }
}
