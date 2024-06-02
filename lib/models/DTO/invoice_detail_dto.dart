class CustomerDetailDTO {
  String vso;
  String merchantName;
  String platform;
  String bankShortName;
  String bankAccount;
  String userBankName;
  String connectionType;
  String phoneNo;
  String email;

  CustomerDetailDTO({
    required this.vso,
    required this.merchantName,
    required this.platform,
    required this.bankShortName,
    required this.bankAccount,
    required this.userBankName,
    required this.connectionType,
    required this.phoneNo,
    required this.email,
  });

  factory CustomerDetailDTO.fromJson(Map<String, dynamic> json) {
    return CustomerDetailDTO(
      vso: json['vso'],
      merchantName: json['merchantName'],
      platform: json['platform'],
      bankShortName: json['bankShortName'],
      bankAccount: json['bankAccount'],
      userBankName: json['userBankName'],
      connectionType: json['connectionType'],
      phoneNo: json['phoneNo'],
      email: json['email'] ?? '',
    );
  }
}

class FeePackageDetailDTO {
  String feePackage;
  int annualFee;
  int fixFee;
  double percentFee;
  int recordType;
  double vat;

  FeePackageDetailDTO({
    required this.feePackage,
    required this.annualFee,
    required this.fixFee,
    required this.percentFee,
    required this.recordType,
    required this.vat,
  });

  factory FeePackageDetailDTO.fromJson(Map<String, dynamic> json) {
    return FeePackageDetailDTO(
      feePackage: json['feePackage'],
      annualFee: json['annualFee'],
      fixFee: json['fixFee'],
      percentFee: json['percentFee'],
      recordType: json['recordType'],
      vat: json['vat'],
    );
  }
}

class InvoiceItemDetailDTO {
  String invoiceItemId;
  String invoiceItemName;
  String unit;
  int quantity;
  int amount;
  int totalAmount;
  double vat;
  int type;
  int vatAmount;
  int totalAmountAfterVat;
  int status;

  InvoiceItemDetailDTO({
    required this.invoiceItemId,
    required this.invoiceItemName,
    required this.unit,
    required this.quantity,
    required this.amount,
    required this.totalAmount,
    required this.vat,
    required this.type,
    required this.vatAmount,
    required this.totalAmountAfterVat,
    required this.status,
  });

  factory InvoiceItemDetailDTO.fromJson(Map<String, dynamic> json) {
    return InvoiceItemDetailDTO(
      invoiceItemId: json['invoiceItemId'],
      invoiceItemName: json['invoiceItemName'],
      unit: json['unit'],
      quantity: json['quantity'],
      amount: json['amount'],
      totalAmount: json['totalAmount'],
      vat: json['vat'],
      type: json['type'],
      vatAmount: json['vatAmount'],
      totalAmountAfterVat: json['totalAmountAfterVat'],
      status: json['status'],
    );
  }
}

class PaymentRequestDTO {
  String bankId;
  String bankAccount;
  String bankShortName;
  String userBankName;
  bool isChecked;

  PaymentRequestDTO({
    required this.bankId,
    required this.bankAccount,
    required this.bankShortName,
    required this.userBankName,
    required this.isChecked,
  });

  factory PaymentRequestDTO.fromJson(Map<String, dynamic> json) {
    return PaymentRequestDTO(
      bankId: json['bankId'],
      bankAccount: json['bankAccount'],
      bankShortName: json['bankShortName'],
      userBankName: json['userBankName'],
      isChecked: json['isChecked'],
    );
  }
}

class InvoiceDetailDTO {
  List<CustomerDetailDTO> customerDetailDTOS;
  List<FeePackageDetailDTO> feePackageDetailDTOS;
  List<InvoiceItemDetailDTO> invoiceItemDetailDTOS;
  List<PaymentRequestDTO> paymentRequestDTOS;
  String invoiceId;
  String invoiceName;
  String invoiceDescription;
  double vat;
  int vatAmount;
  int totalAmount;
  int totalAmountAfterVat;
  int pendingAmount;
  int completeAmount;
  int status;

  InvoiceDetailDTO({
    required this.customerDetailDTOS,
    required this.feePackageDetailDTOS,
    required this.invoiceItemDetailDTOS,
    required this.paymentRequestDTOS,
    required this.invoiceId,
    required this.invoiceName,
    required this.invoiceDescription,
    required this.vat,
    required this.vatAmount,
    required this.totalAmount,
    required this.totalAmountAfterVat,
    required this.pendingAmount,
    required this.completeAmount,
    required this.status,
  });

  factory InvoiceDetailDTO.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailDTO(
      customerDetailDTOS: (json['customerDetailDTOS'] as List).isNotEmpty
          ? (json['customerDetailDTOS'] as List)
              .map((i) => CustomerDetailDTO.fromJson(i))
              .toList()
          : [],
      feePackageDetailDTOS: (json['feePackageDetailDTOS'] as List).isNotEmpty
          ? (json['feePackageDetailDTOS'] as List)
              .map((i) => FeePackageDetailDTO.fromJson(i))
              .toList()
          : [],
      invoiceItemDetailDTOS: (json['invoiceItemDetailDTOS'] as List).isNotEmpty
          ? (json['invoiceItemDetailDTOS'] as List)
              .map((i) => InvoiceItemDetailDTO.fromJson(i))
              .toList()
          : [],
      paymentRequestDTOS: (json['paymentRequestDTOS'] as List).isNotEmpty
          ? (json['paymentRequestDTOS'] as List)
              .map((i) => PaymentRequestDTO.fromJson(i))
              .toList()
          : [],
      invoiceId: json['invoiceId'],
      invoiceName: json['invoiceName'],
      invoiceDescription: json['invoiceDescription'],
      vat: json['vat'],
      vatAmount: json['vatAmount'],
      totalAmount: json['totalAmount'],
      totalAmountAfterVat: json['totalAmountAfterVat'],
      pendingAmount: json['pendingAmount'] ?? 0,
      completeAmount: json['completeAmount'] ?? 0,
      status: json['status'],
    );
  }
}
