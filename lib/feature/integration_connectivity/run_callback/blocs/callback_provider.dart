import 'package:flutter/material.dart';

import '../../../../models/DTO/bank_account_dto.dart';
import '../../../../models/DTO/callback_dto.dart';
import '../../../../models/DTO/customer_dto.dart';

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
