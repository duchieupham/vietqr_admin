import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../../models/DTO/bank_name_information_dto.dart';
import '../repositories/info_connect_repository.dart';

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

  Timer? _debounce;

  onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      updateBankAccount(query);
    });
  }

  void updateBankAccount(String value) async {
    _bankAccount = value;
    _errorAccountName = false;
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
        _errorAccountNumber = false;
      } else {
        updateUserBankName('Không xác định');
        _errorAccountName = true;
      }
    }
    notifyListeners();
  }

  void updateUserBankName(String value) {
    _userBankName = value.trim();
  }

  checkErrorAccountNumber() {
    if (_bankAccount.isNotEmpty) {
      _errorAccountNumber = false;
    } else {
      _errorAccountNumber = true;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
