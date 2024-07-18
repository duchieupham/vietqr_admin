class BankAccountSync {
  final int flow;
  final String bankAccount;
  final String customerSyncId;
  final String serviceFeeId;
  final String bankId;
  final String bankCode;
  final String bankShortName;
  final String userId;
  final String bankTypeId;
  final String nationalId;
  final String phoneAuthenticated;
  final String imgId;
  final bool authenticated;
  final String accountCustomerId;
  final String customerBankName;
  final String serviceFeeName;
  final String address;

  const BankAccountSync({
    this.flow = 0,
    this.bankAccount = '',
    this.customerSyncId = '',
    this.serviceFeeId = '',
    this.bankId = '',
    this.userId = '',
    this.bankCode = '',
    this.bankShortName = '',
    this.imgId = '',
    this.authenticated = false,
    this.nationalId = '',
    this.bankTypeId = '',
    this.accountCustomerId = '',
    this.customerBankName = '',
    this.phoneAuthenticated = '',
    this.serviceFeeName = '',
    this.address = '',
  });

  factory BankAccountSync.fromJsonApi(Map<String, dynamic> json) {
    return BankAccountSync(
      flow: json['flow'] ?? 0,
      bankAccount: json['bankAccount'] ?? '',
      customerSyncId: json['customerSyncId'] ?? '',
      serviceFeeId: json['serviceFeeId'] ?? '',
      bankId: json['bankId'] ?? '',
      userId: json['userId'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      imgId: json['imgId'] ?? '',
      authenticated: json['authenticated'] ?? false,
      nationalId: json['nationalId'] ?? '',
      bankTypeId: json['bankTypeId'] ?? '',
      accountCustomerId: json['accountCustomerId'] ?? '',
      customerBankName: json['customerBankName'] ?? '',
      phoneAuthenticated: json['phoneAuthenticated'] ?? '',
      serviceFeeName: json['serviceFeeName'] ?? '',
      address: json['address'] ?? '',
    );
  }
}
