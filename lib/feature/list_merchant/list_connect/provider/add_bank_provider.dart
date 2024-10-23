import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:vietqr_admin/feature/dashboard/bank/repositories/bank_type_repository.dart';
import 'package:vietqr_admin/models/DTO/bank_type_dto.dart';
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

  BankTypeDTO? selectBankType;
  List<BankTypeDTO> listBankTypes = [];

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
          await infoConnectRepository.searchBankName(
              _bankAccount, selectBankType!.bankCode, selectBankType!.caiValue);

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

  void clearBankAndUserName() {
    _bankAccount = '';
    _userBankName = '';
    notifyListeners();
  }

  void updateUserBankName(String value) {
    _userBankName = value.trim();
  }

  void updateBankType(BankTypeDTO? bankType) {
    selectBankType = bankType;
    notifyListeners();
  }

  void getListBankType() async {
    BankTypeRepository bankTypeRepository = const BankTypeRepository();
    listBankTypes = await bankTypeRepository.getBankTypes();
    notifyListeners();
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
