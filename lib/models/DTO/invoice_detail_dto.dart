
class InvoiceDetailDTO {
  List<CustomerDetailDTO> customerDetailDTOS;
  List<FeePackageDetailDTO> feePackageDetailDTOS;
  List<InvoiceItemDetailDTO> invoiceItemDetailDTOS;
  String invoiceId;
  String invoiceName;
  String invoiceDescription;
  double vat;
  int vatAmount;
  int totalAmount;
  int totalAmountAfterVat;
  int status;

  InvoiceDetailDTO({
    required this.customerDetailDTOS,
    required this.feePackageDetailDTOS,
    required this.invoiceItemDetailDTOS,
    required this.invoiceId,
    required this.invoiceName,
    required this.invoiceDescription,
    required this.vat,
    required this.vatAmount,
    required this.totalAmount,
    required this.totalAmountAfterVat,
    required this.status,
  });

  factory InvoiceDetailDTO.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailDTO(
      customerDetailDTOS: List<CustomerDetailDTO>.from(
          json['customerDetailDTOS'].map((x) => CustomerDetailDTO.fromJson(x))),
      feePackageDetailDTOS: List<FeePackageDetailDTO>.from(
          json['feePackageDetailDTOS']
              .map((x) => FeePackageDetailDTO.fromJson(x))),
      invoiceItemDetailDTOS: List<InvoiceItemDetailDTO>.from(
          json['invoiceItemDetailDTOS']
              .map((x) => InvoiceItemDetailDTO.fromJson(x))),
      invoiceId: json['invoiceId'],
      invoiceName: json['invoiceName'],
      invoiceDescription: json['invoiceDescription'] ?? "",
      vat: json['vat'].toDouble(),
      vatAmount: json['vatAmount'],
      totalAmount: json['totalAmount'],
      totalAmountAfterVat: json['totalAmountAfterVat'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerDetailDTOS':
          List<dynamic>.from(customerDetailDTOS.map((x) => x.toJson())),
      'feePackageDetailDTOS':
          List<dynamic>.from(feePackageDetailDTOS.map((x) => x.toJson())),
      'invoiceItemDetailDTOS':
          List<dynamic>.from(invoiceItemDetailDTOS.map((x) => x.toJson())),
      'invoiceId': invoiceId,
      'invoiceName': invoiceName,
      'invoiceDescription': invoiceDescription,
      'vat': vat,
      'vatAmount': vatAmount,
      'totalAmount': totalAmount,
      'totalAmountAfterVat': totalAmountAfterVat,
      'status': status,
    };
  }
}

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

  Map<String, dynamic> toJson() {
    return {
      'vso': vso,
      'merchantName': merchantName,
      'platform': platform,
      'bankShortName': bankShortName,
      'bankAccount': bankAccount,
      'userBankName': userBankName,
      'connectionType': connectionType,
      'phoneNo': phoneNo,
      'email': email,
    };
  }
}

class FeePackageDetailDTO {
  String feePackage;
  int annualFee;
  int fixFee;
  double percentFee;
  int recordType;

  FeePackageDetailDTO({
    required this.feePackage,
    required this.annualFee,
    required this.fixFee,
    required this.percentFee,
    required this.recordType,
  });

  factory FeePackageDetailDTO.fromJson(Map<String, dynamic> json) {
    return FeePackageDetailDTO(
      feePackage: json['feePackage'],
      annualFee: json['annualFee'],
      fixFee: json['fixFee'],
      percentFee: json['percentFee'].toDouble(),
      recordType: json['recordType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feePackage': feePackage,
      'annualFee': annualFee,
      'fixFee': fixFee,
      'percentFee': percentFee,
      'recordType': recordType,
    };
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
  int vatAmount;
  int totalAmountAfterVat;

  InvoiceItemDetailDTO({
    required this.invoiceItemId,
    required this.invoiceItemName,
    required this.unit,
    required this.quantity,
    required this.amount,
    required this.totalAmount,
    required this.vat,
    required this.vatAmount,
    required this.totalAmountAfterVat,
  });

  factory InvoiceItemDetailDTO.fromJson(Map<String, dynamic> json) {
    return InvoiceItemDetailDTO(
      invoiceItemId: json['invoiceItemId'],
      invoiceItemName: json['invoiceItemName'],
      unit: json['unit'],
      quantity: json['quantity'],
      amount: json['amount'],
      totalAmount: json['totalAmount'],
      vat: json['vat'].toDouble(),
      vatAmount: json['vatAmount'],
      totalAmountAfterVat: json['totalAmountAfterVat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceItemId': invoiceItemId,
      'invoiceItemName': invoiceItemName,
      'unit': unit,
      'quantity': quantity,
      'amount': amount,
      'totalAmount': totalAmount,
      'vat': vat,
      'vatAmount': vatAmount,
      'totalAmountAfterVat': totalAmountAfterVat,
    };
  }
}
