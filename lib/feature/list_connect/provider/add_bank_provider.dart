import 'package:flutter/material.dart';
import 'package:vietqr_admin/feature/list_connect/repositories/info_connect_repository.dart';
import 'package:vietqr_admin/models/bank_name_information_dto.dart';

class AddBankProvider with ChangeNotifier {
  String _bankAccount = '';
  String get bankAccount => _bankAccount;

  String _userBankName = '';
  String get userBankName => _userBankName;

  bool _errorAccountNumber = false;
  bool get errorAccountNumber => _errorAccountNumber;

  bool _errorAccountName = false;
  bool get errorAccountName => _errorAccountName;

  InfoConnectRepository infoConnectRepository = const InfoConnectRepository();

  void updateBankAccount(String value) async {
    _bankAccount = value;
    if (_bankAccount.isNotEmpty) {
      _errorAccountNumber = false;
    } else {
      _errorAccountNumber = true;
    }

    if (_bankAccount.length > 8) {
      BankNameInformationDTO bankNameInformationDTO =
          await infoConnectRepository.searchBankName(_bankAccount);

      if (bankNameInformationDTO.accountName.isNotEmpty) {
        updateUserBankName(bankNameInformationDTO.accountName);
      } else {
        updateUserBankName('Không xác định');
        _errorAccountName = true;
      }
    }
    notifyListeners();
  }

  void updateUserBankName(String value) {
    _userBankName = value;
  }

  checkErrorAccountNumber() {
    if (_bankAccount.isNotEmpty) {
      _errorAccountNumber = false;
    } else {
      _errorAccountNumber = true;
    }
    notifyListeners();
  }
}
