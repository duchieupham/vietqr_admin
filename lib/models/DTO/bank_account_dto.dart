class BankAccountDTO {
  final String customerSyncId;
  final String bankId;
  final String userId;
  final String bankAccount;
  final int flow;
  final String bankTypeId;
  final String bankShortName;
  final String nationalId;
  final String phoneAuthenticated;
  final String bankCode;
  final String imgId;
  final bool authenticated;
  final String accountCustomerId;
  final String customerBankName;
  const BankAccountDTO(
      {this.accountCustomerId = '',
      this.bankCode = '',
      this.imgId = '',
      this.bankAccount = '',
      this.bankShortName = '',
      this.userId = '',
      this.bankId = '',
      this.nationalId = '',
      this.authenticated = false,
      this.phoneAuthenticated = '',
      this.bankTypeId = '',
      this.customerBankName = '',
      this.customerSyncId = '',
      this.flow = 0});

  factory BankAccountDTO.fromJson(Map<String, dynamic> json) {
    return BankAccountDTO(
      accountCustomerId: json['accountCustomerId'] ?? '',
      bankCode: json['bankCode'] ?? '',
      imgId: json['imgId'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      userId: json['userId'] ?? '',
      bankId: json['bankId'] ?? '',
      nationalId: json['nationalId'] ?? '',
      authenticated: json['authenticated'] ?? false,
      phoneAuthenticated: json['phoneAuthenticated'] ?? '',
      bankTypeId: json['bankTypeId'] ?? '',
      customerBankName: json['customerBankName'] ?? '',
      customerSyncId: json['customerSyncId'] ?? '',
      flow: json['flow'] ?? 0,
    );
  }
}
