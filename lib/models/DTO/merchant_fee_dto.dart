
class MerchantFee {
  final String customerSyncId;
  final String merchant;
  final List<MerchantBankAccount>? bankAccounts;

  const MerchantFee({
    this.bankAccounts,
    this.merchant = '',
    this.customerSyncId = '',
  });

  factory MerchantFee.fromJson(Map<String, dynamic> json) {
    return MerchantFee(
      merchant: json['merchant'] ?? '',
      customerSyncId: json['customerSyncId'] ?? 0,
      bankAccounts: json['bankAccounts']
          .map<MerchantBankAccount>(
              (json) => MerchantBankAccount.fromJson(json))
          .toList(),
    );
  }
}

class MerchantBankAccount {
  final String bankId;
  final String bankAccount;
  final String bankCode;
  final String bankShortName;
  final String userBankName;
  final String bankName;
  final String imgId;

  const MerchantBankAccount({
    this.bankAccount = '',
    this.userBankName = '',
    this.bankName = '',
    this.bankCode = '',
    this.imgId = '',
    this.bankShortName = '',
    this.bankId = '',
  });

  factory MerchantBankAccount.fromJson(Map<String, dynamic> json) {
    return MerchantBankAccount(
      bankAccount: json['bankAccount'] ?? '',
      userBankName: json['userBankName'] ?? 0,
      bankName: json['bankName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      imgId: json['imgId'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      bankId: json['bankId'] ?? '',
    );
  }
}
