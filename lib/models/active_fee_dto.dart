class ActiveFeeDTO {
  final String customerSyncId;
  final String merchant;
  final int totalPayment;
  final int status;
  late List<ActiveFeeBankDTO>? bankAccounts;

  ActiveFeeDTO({
    this.customerSyncId = '',
    this.merchant = '',
    this.totalPayment = 0,
    this.status = 0,
    this.bankAccounts,
  });

  factory ActiveFeeDTO.fromJson(Map<String, dynamic> json) {
    return ActiveFeeDTO(
      customerSyncId: json['customerSyncId'] ?? '',
      merchant: json['merchant'] ?? '',
      status: json['status'] ?? 0,
      totalPayment: json['totalPayment'] ?? 0,
      bankAccounts: json['bankAccounts']
          .map<FeeDTO>((json) => FeeDTO.fromJson(json))
          .toList(),
    );
  }
}

class ActiveFeeBankDTO {
  final String bankId;
  final String bankAccount;
  final String bankCode;
  final String bankShortName;
  late List<FeeDTO>? fees;

  ActiveFeeBankDTO(
      {this.bankId = '',
      this.bankAccount = '',
      this.bankCode = '',
      this.bankShortName = '',
      this.fees});

  factory ActiveFeeBankDTO.fromJson(Map<String, dynamic> json) {
    return ActiveFeeBankDTO(
        bankId: json['bankId'] ?? '',
        bankAccount: json['bankAccount'] ?? '',
        bankCode: json['bankCode'] ?? '',
        bankShortName: json['bankShortName'] ?? '',
        fees:
            json['fees'].map<FeeDTO>((json) => FeeDTO.fromJson(json)).toList());
  }
}

class FeeDTO {
  final String accountBankFeeId;
  final String serviceFeeId;
  final String shortName;
  final int annualFee;
  final int monthlyCycle;
  final String startDate;
  final String endDate;
  final double vat;
  final int totalPayment;
  final int status;
  FeeDTO(
      {this.accountBankFeeId = '',
      this.serviceFeeId = '',
      this.shortName = '',
      this.annualFee = 0,
      this.monthlyCycle = 0,
      this.startDate = '',
      this.endDate = '',
      this.vat = 0.0,
      this.totalPayment = 0,
      this.status = 0});

  factory FeeDTO.fromJson(Map<String, dynamic> json) {
    return FeeDTO(
      accountBankFeeId: json['accountBankFeeId'] ?? '',
      serviceFeeId: json['serviceFeeId'] ?? '',
      shortName: json['shortName'] ?? '',
      annualFee: json['annualFee'] ?? 0,
      monthlyCycle: json['monthlyCycle'] ?? 0,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      totalPayment: json['totalPayment'] ?? 0,
      status: json['status'] ?? 0,
      vat: json['vat'] ?? 0.0,
    );
  }
}
