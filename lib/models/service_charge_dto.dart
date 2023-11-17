class ServiceChargeDTO {
  final String month;
  final String merchantName;
  final int totalTrans;
  final int totalAmount;
  final int totalFee;
  final int totalVatFee;
  final int totalFeeAfterVat;
  final int status;
  final List<BankInfo>? fees;
  ServiceChargeDTO({
    this.month = '',
    this.merchantName = '',
    this.status = 0,
    this.totalTrans = 0,
    this.totalAmount = 0,
    this.totalFee = 0,
    this.totalVatFee = 0,
    this.totalFeeAfterVat = 0,
    this.fees,
  });

  factory ServiceChargeDTO.fromJson(Map<String, dynamic> json) =>
      ServiceChargeDTO(
        month: json["month"] ?? '',
        merchantName: json["merchantName"] ?? '',
        status: json["status"] ?? 0,
        totalTrans: json["totalTrans"] ?? 0,
        totalAmount: json["totalAmount"] ?? 0,
        totalFee: json["totalFee"] ?? 0,
        totalVatFee: json["totalVatFee"] ?? 0,
        totalFeeAfterVat: json["totalFeeAfterVat"] ?? 0,
        fees: json['fees']
            .map<BankInfo>((json) => BankInfo.fromJson(json))
            .toList(),
      );
}

class BankInfo {
  final String bankAccount;
  final String bankCode;
  final String bankShortName;
  final String serviceName;
  final int totalTrans;
  final int totalAmount;
  final int totalFee;
  final double vat;
  final int vatFee;
  final int annualFee;
  final int totalFeeAfterVat;
  final int status;

  BankInfo({
    this.bankAccount = '',
    this.bankCode = '',
    this.bankShortName = '',
    this.totalTrans = 0,
    this.serviceName = '',
    this.totalAmount = 0,
    this.totalFee = 0,
    this.vat = 0.0,
    this.vatFee = 0,
    this.annualFee = 0,
    this.totalFeeAfterVat = 0,
    this.status = 0,
  });

  factory BankInfo.fromJson(Map<String, dynamic> json) => BankInfo(
        bankAccount: json["bankAccount"] ?? '',
        bankCode: json["bankCode"] ?? '',
        bankShortName: json["bankShortName"] ?? '',
        totalTrans: json["totalTrans"] ?? 0,
        serviceName: json["serviceName"] ?? '',
        totalAmount: json["totalAmount"] ?? 0,
        totalFee: json["totalFee"] ?? 0,
        vat: json["vat"] ?? 0.0,
        vatFee: json["vatFee"] ?? 0,
        annualFee: json["annualFee"] ?? 0,
        status: json["status"] ?? 0,
        totalFeeAfterVat: json["totalFeeAfterVat"] ?? 0,
      );
}
