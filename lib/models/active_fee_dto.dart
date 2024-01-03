class ActiveFeeDTO {
  final int totalTrans;
  final int totalAmount;
  final int totalUnpaid;
  final int totalPaid;
  late List<ActiveFeeItemDTO>? list;

  ActiveFeeDTO({
    this.totalTrans = 0,
    this.totalAmount = 0,
    this.totalUnpaid = 0,
    this.totalPaid = 0,
    this.list,
  });

  factory ActiveFeeDTO.fromJson(Map<String, dynamic> data) {
    return ActiveFeeDTO(
      totalTrans: data['totalTrans'] ?? 0,
      totalAmount: data['totalAmount'] ?? 0,
      totalUnpaid: data['totalUnpaid'] ?? 0,
      totalPaid: data['totalPaid'] ?? 0,
      list: data['list']
          .map<ActiveFeeItemDTO>((json) => ActiveFeeItemDTO.fromJson(json))
          .toList(),
    );
  }
}

class ActiveFeeItemDTO {
  final String customerSyncId;
  final String merchant;
  final int totalPayment;
  final int status;
  late List<ActiveFeeBankDTO>? bankAccounts;

  ActiveFeeItemDTO({
    this.customerSyncId = '',
    this.merchant = '',
    this.totalPayment = 0,
    this.status = 0,
    this.bankAccounts,
  });

  factory ActiveFeeItemDTO.fromJson(Map<String, dynamic> data) {
    return ActiveFeeItemDTO(
      customerSyncId: data['customerSyncId'] ?? '',
      merchant: data['merchant'] ?? '',
      status: data['status'] ?? 0,
      totalPayment: data['totalPayment'] ?? 0,
      bankAccounts: data['bankAccounts']
          .map<ActiveFeeBankDTO>(
              (json) => ActiveFeeBankDTO.fromJson(json, data['merchant'] ?? ''))
          .toList(),
    );
  }
}

class ActiveFeeBankDTO {
  final String bankId;
  final String bankAccount;
  final String bankCode;
  final String merchant;
  final String bankShortName;
  late List<FeeDTO>? fees;

  ActiveFeeBankDTO(
      {this.bankId = '',
      this.bankAccount = '',
      this.bankCode = '',
      this.bankShortName = '',
      this.merchant = '',
      this.fees});

  factory ActiveFeeBankDTO.fromJson(
      Map<String, dynamic> json, String merchant) {
    return ActiveFeeBankDTO(
        bankId: json['bankId'] ?? '',
        bankAccount: json['bankAccount'] ?? '',
        bankCode: json['bankCode'] ?? '',
        merchant: merchant,
        bankShortName: json['bankShortName'] ?? '',
        fees:
            json['fees'].map<FeeDTO>((json) => FeeDTO.fromJson(json)).toList());
  }
}

class FeeDTO {
  final String accountBankFeeId;
  final String serviceFeeId;
  final String shortName;
  final int totalTrans;
  final int totalAmount;
  final double vat;
  final int totalPayment;
  final int status;
  final int countingTransType;
  final int discountAmount;
  FeeDTO(
      {this.accountBankFeeId = '',
      this.serviceFeeId = '',
      this.shortName = '',
      this.totalTrans = 0,
      this.totalAmount = 0,
      this.countingTransType = 0,
      this.discountAmount = 0,
      this.vat = 0.0,
      this.totalPayment = 0,
      this.status = 0});

  factory FeeDTO.fromJson(Map<String, dynamic> json) {
    return FeeDTO(
      accountBankFeeId: json['accountBankFeeId'] ?? '',
      serviceFeeId: json['serviceFeeId'] ?? '',
      shortName: json['shortName'] ?? '',
      totalTrans: json['totalTrans'] ?? 0,
      countingTransType: json['countingTransType'] ?? 0,
      totalAmount: json['totalAmount'] ?? 0,
      discountAmount: json['discountAmount'] ?? 0,
      totalPayment: json['totalPayment'] ?? 0,
      status: json['status'] ?? 0,
      vat: json['vat'] ?? 0.0,
    );
  }
}
