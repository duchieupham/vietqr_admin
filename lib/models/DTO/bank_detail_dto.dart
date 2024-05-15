import 'dart:convert';

class BankDetailDTO {
  String bankId;
  String merchantId;
  String userBankName;
  String bankShortName;
  String bankAccount;
  String phoneNo;
  String email;
  String connectionType;
  String feePackage;
  double vat;
  double transFee1;
  double transFee2;
  int transRecord;

  BankDetailDTO({
    required this.bankId,
    required this.merchantId,
    required this.userBankName,
    required this.bankShortName,
    required this.bankAccount,
    required this.phoneNo,
    required this.email,
    required this.connectionType,
    required this.feePackage,
    required this.vat,
    required this.transFee1,
    required this.transFee2,
    required this.transRecord,
  });

  factory BankDetailDTO.fromJson(Map<String, dynamic> json) {
    return BankDetailDTO(
      bankId: json['bankId'],
      merchantId: json['merchantId'],
      userBankName: json['userBankName'],
      bankAccount: json['bankAccount'],
      bankShortName: json['bankShortName'],
      phoneNo: json['phoneNo'],
      email: json['email'],
      connectionType: json['connectionType'],
      feePackage: json['feePackage'],
      vat: json['vat'].toDouble(),
      transFee1: json['transFee1'].toDouble(),
      transFee2: json['transFee2'].toDouble(),
      transRecord: json['transRecord'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'bankId': bankId,
  //     'merchantId': merchantId,
  //     'userBankName': userBankName,
  //     'phoneNo': phoneNo,
  //     'email': email,
  //     'connectionType': connectionType,
  //     'feePackage': feePackage,
  //     'vat': vat,
  //   };
  // }
}
