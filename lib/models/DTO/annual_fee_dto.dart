class AnnualFeeDTO {
  final String customerSyncId;
  final String merchant;
  final int totalPayment;
  final int status;
  late List<AnnualFeeBankDTO>? bankAccounts;

  AnnualFeeDTO({
    this.customerSyncId = '',
    this.merchant = '',
    this.totalPayment = 0,
    this.status = 0,
    this.bankAccounts,
  });

  factory AnnualFeeDTO.fromJson(Map<String, dynamic> json) {
    return AnnualFeeDTO(
      customerSyncId: json['customerSyncId'] ?? '',
      merchant: json['merchant'] ?? '',
      status: json['status'] ?? 0,
      totalPayment: json['totalPayment'] ?? 0,
      bankAccounts: json['bankAccounts']
          .map<AnnualFeeBankDTO>((json) => AnnualFeeBankDTO.fromJson(json))
          .toList(),
    );
  }
}

class AnnualFeeBankDTO {
  final String bankId;
  final String bankAccount;
  final String bankCode;
  final String bankShortName;
  late List<FeeDTO>? fees;

  AnnualFeeBankDTO(
      {this.bankId = '',
      this.bankAccount = '',
      this.bankCode = '',
      this.bankShortName = '',
      this.fees});

  factory AnnualFeeBankDTO.fromJson(Map<String, dynamic> json) {
    return AnnualFeeBankDTO(
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
  final String annualBankId;
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
      this.status = 0,
      this.annualBankId = ''});

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
      annualBankId: json['annualBankId'] ?? 0.0,
    );
  }
}
