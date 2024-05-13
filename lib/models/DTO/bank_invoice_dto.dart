import 'dart:convert';

class BankInvoiceDTO {
  List<BankItem> items;

  BankInvoiceDTO({required this.items});

  factory BankInvoiceDTO.fromJson(Map<String, dynamic> json) {
    return BankInvoiceDTO(
      items:
          List<BankItem>.from(json['items'].map((x) => BankItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toJson())),
    };
  }
}

class BankItem {
  String bankId;
  String merchantId;
  String userBankName;
  String phoneNo;
  String email;
  String bankShortName;
  String bankAccount;
  String connectionType;
  String feePackage;

  BankItem({
    required this.bankId,
    required this.merchantId,
    required this.userBankName,
    required this.phoneNo,
    required this.email,
    required this.bankShortName,
    required this.bankAccount,
    required this.connectionType,
    required this.feePackage,
  });

  factory BankItem.fromJson(Map<String, dynamic> json) {
    return BankItem(
      bankId: json['bankId'],
      merchantId: json['merchantId'],
      userBankName: json['userBankName'],
      phoneNo: json['phoneNo'],
      email: json['email'],
      bankShortName: json['bankShortName'],
      bankAccount: json['bankAccount'],
      connectionType: json['connectionType'],
      feePackage: json['feePackage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankId': bankId,
      'merchantId': merchantId,
      'userBankName': userBankName,
      'phoneNo': phoneNo,
      'email': email,
      'bankShortName': bankShortName,
      'bankAccount': bankAccount,
      'connectionType': connectionType,
      'feePackage': feePackage,
    };
  }
}
