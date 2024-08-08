import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/repositories/info_connect_repository.dart';
import 'package:vietqr_admin/models/DTO/bank_name_search_dto.dart';

import '../../../../models/DTO/bank_name_information_dto.dart';

class NewConnectProvider with ChangeNotifier {
  String _urlConnect = '';
  bool _urlError = false;
  bool get urlError => _urlError;

  String get urlConnect => _urlConnect;
  String _suffixConnect = '';

  String get suffixConnect => _suffixConnect;
  String _ipConnect = '';

  String get ipConnect => _ipConnect;

  String _portConnect = '';

  String get portConnect => _portConnect;

  String _username = '';

  String get username => _username;
  bool _errorUsername = false;

  bool get errorUsername => _errorUsername;

  String _password = '';

  String get password => _password;
  bool _errorPassword = false;

  bool get errorPassword => _errorPassword;

  String _customerName = '';

  String get customerName => _customerName;
  bool _errorCustomerName = false;

  bool get errorCustomerName => _errorCustomerName;

  String _merchant = '';

  String get merchant => _merchant;
  bool _errorMerchant = false;

  bool get errorMerchant => _errorMerchant;

  String _bankAccount = '';

  String get bankAccount => _bankAccount;
  bool _errorBankAccount = false;

  bool get errorBankAccount => _errorBankAccount;

  String _address = '';

  String get address => _address;
  bool _errorAddress = false;

  bool get errorAddress => _errorAddress;

  String _userBankName = '';

  String get userBankName => _userBankName;
  bool _errorUserBankName = false;

  bool get errorUserBankName => _errorUserBankName;

  TextEditingController accountName = TextEditingController();

  int valueTypeConnect = 0;

  changeTypeConnect(int type) {
    valueTypeConnect = type;
    notifyListeners();
  }

  void updateMerchant(String value) {
    _merchant = value;
    if (_merchant.isNotEmpty) {
      _errorMerchant = false;
    } else {
      _errorMerchant = true;
    }
    notifyListeners();
  }

  InfoConnectRepository infoConnectRepository = const InfoConnectRepository();

  Timer? _debounce;

  onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      updateBankAccount(query);
    });
  }

  void updateBankAccount(String value,
      {String cai = '', String code = ''}) async {
    _bankAccount = value;
    _errorBankAccount = false;
    if (_bankAccount.isNotEmpty) {
      _errorBankAccount = true;
    } else {
      _errorBankAccount = false;
    }
    if (_bankAccount.isNotEmpty && _bankAccount.length > 5) {
      String transferType = '';
      String caiValue = '';
      String bankCode = '';
      // BankTypeDTO? bankTypeDTO = _addBankProvider.bankTypeDTO;
      if (cai.isNotEmpty && code.isNotEmpty) {
        caiValue = cai;
        bankCode = code;
        if (bankCode == 'MB') {
          transferType = 'INHOUSE';
        } else {
          transferType = 'NAPAS';
        }

        BankNameSearchDTO bankNameSearchDTO = BankNameSearchDTO(
          accountNumber: value,
          accountType: 'ACCOUNT',
          transferType: transferType,
          bankCode: caiValue,
        );
        BankNameInformationDTO bankNameInformationDTO =
            await infoConnectRepository
                .searchBankNameNewConnectProvider(bankNameSearchDTO);
        if (bankNameInformationDTO.accountName.isNotEmpty) {
          updateUserBankName(bankNameInformationDTO.accountName);
          _errorBankAccount = false;
        } else {
          updateUserBankName('Không xác định');
          _errorBankAccount = true;
        }
      }

      // _bloc.add(SearchBankEvent(dto: bankNameSearchDTO));
    }
    // if (_bankAccount.length > 8) {
    //   BankNameInformationDTO bankNameInformationDTO =
    //       await infoConnectRepository.searchBankName(_bankAccount);

    // }
    notifyListeners();
  }

  void updateAddress(String value) {
    _address = value;
    if (_address.isNotEmpty) {
      _errorAddress = false;
    } else {
      _errorAddress = true;
    }
  }

  bool isAllowedUrl(String url) {
    List<String> allowedUrls = [
      'dev.vietqr.org',
      'api.vietqr.org',
      '112.78.1.209',
      '112.78.1.220',
    ];

    return allowedUrls.contains(url);
  }

  void updateUrlConnect(String value) {
    if (isAllowedUrl(value)) {
      _urlConnect = value;
    }
    _urlError = isAllowedUrl(value);
    notifyListeners();
  }

  void updateUserBankName(String value) {
    _userBankName = value;
    accountName.text = value.trim();
    if (_userBankName.isNotEmpty) {
      _errorUserBankName = false;
    } else {
      _errorUserBankName = true;
    }
    notifyListeners();
  }

  void updateSuffixConnect(String value) {
    _suffixConnect = value;
  }

  void updateIpConnect(String value) {
    if (isAllowedUrl(value)) {
      _ipConnect = value;
    }
    _urlError = isAllowedUrl(value);

    notifyListeners();
  }

  void updatePortConnect(String value) {
    _portConnect = value;
  }

  void updateUsername(String value) {
    _username = value;
    if (_username.isNotEmpty) {
      _errorUsername = false;
    } else {
      _errorUsername = true;
    }
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    if (_password.isNotEmpty) {
      _errorPassword = false;
    } else {
      _errorPassword = true;
    }
    notifyListeners();
  }

  void updateCustomerName(String value) {
    _customerName = value;
    if (_customerName.isNotEmpty) {
      _errorCustomerName = false;
    } else {
      _errorCustomerName = true;
    }
  }

  checkValidate() {
    if (_customerName.isEmpty) {
      _errorCustomerName = true;
    }
    if (_password.isEmpty) {
      _errorPassword = true;
    }
    if (_username.isEmpty) {
      _errorUsername = true;
    }
    if (_userBankName.isEmpty) {
      _errorUserBankName = true;
    }
    if (_address.isEmpty) {
      _errorAddress = true;
    }
    if (_bankAccount.isEmpty) {
      _errorBankAccount = true;
    }
    if (_merchant.isEmpty) {
      _errorMerchant = true;
    }
    if (_urlConnect.isEmpty) {
      _urlError = true;
    }
    notifyListeners();
  }

  bool isValidate() {
    if (_customerName.isNotEmpty &&
        _password.isNotEmpty &&
        _username.isNotEmpty &&
        _userBankName.isNotEmpty &&
        _address.isNotEmpty &&
        _bankAccount.isNotEmpty &&
        _merchant.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  String getUrl() {
    String suffix = '';
    String url = '';
    if (suffixConnect.isNotEmpty) {
      if (suffixConnect[suffixConnect.length - 1] == '/') {
        suffix = suffixConnect.substring(0, suffixConnect.length - 1);
      } else {
        suffix = suffixConnect;
      }
    }
    if (urlConnect.isNotEmpty) {
      url = urlConnect;
    } else if (ipConnect.isNotEmpty) {
      url = 'http://$ipConnect:$portConnect';
    }

    if (suffix.isNotEmpty) {
      url = '$url/$suffix';
    }
    return url;
  }
}
