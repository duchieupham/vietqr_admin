class InvoiceExcelDTO {
  final CustomerDetails customerDetails;
  final List<Transaction> transactions;

  InvoiceExcelDTO({required this.customerDetails, required this.transactions});

  factory InvoiceExcelDTO.fromJson(Map<String, dynamic> json) {
    return InvoiceExcelDTO(
      customerDetails: CustomerDetails.fromJson(json['customerDetails']),
      transactions: List<Transaction>.from(
        json['transactions'].map((x) => Transaction.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerDetails': customerDetails.toJson(),
      'transactions': transactions.map((x) => x.toJson()).toList(),
    };
  }
}

class CustomerDetails {
  final String bankAccount;
  final String bankShortName;
  final String userBankName;
  final int fixFee;
  final int recordType;
  final double vat;
  final double percentFee;
  final String title;
  final bool mmsActive;

  CustomerDetails({
    required this.bankAccount,
    required this.bankShortName,
    required this.userBankName,
    required this.fixFee,
    required this.recordType,
    required this.vat,
    required this.percentFee,
    required this.title,
    required this.mmsActive,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      bankAccount: json['bankAccount'],
      bankShortName: json['bankShortName'],
      userBankName: json['userBankName'],
      fixFee: json['fixFee'],
      recordType: json['recordType'],
      vat: json['vat'],
      percentFee: json['percentFee'],
      title: json['title'],
      mmsActive: json['mmsActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankAccount': bankAccount,
      'bankShortName': bankShortName,
      'userBankName': userBankName,
      'fixFee': fixFee,
      'recordType': recordType,
      'vat': vat,
      'percentFee': percentFee,
      'title': title,
      'mmsActive': mmsActive,
    };
  }
}

class Transaction {
  final String invoiceItemId;
  final String time;
  final int totalAmount;
  final int totalCount;
  final int creditAmount;
  final int creditCount;
  final int debitAmount;
  final int debitCount;
  final int controlAmount;
  final int controlCount;

  Transaction({
    required this.invoiceItemId,
    required this.time,
    required this.totalAmount,
    required this.totalCount,
    required this.creditAmount,
    required this.creditCount,
    required this.debitAmount,
    required this.debitCount,
    required this.controlAmount,
    required this.controlCount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      invoiceItemId: json['invoiceItemId'],
      time: json['time'],
      totalAmount: json['totalAmount'],
      totalCount: json['totalCount'],
      creditAmount: json['creditAmount'],
      creditCount: json['creditCount'],
      debitAmount: json['debitAmount'],
      debitCount: json['debitCount'],
      controlAmount: json['controlAmount'],
      controlCount: json['controlCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceItemId': invoiceItemId,
      'time': time,
      'totalAmount': totalAmount,
      'totalCount': totalCount,
      'creditAmount': creditAmount,
      'creditCount': creditCount,
      'debitAmount': debitAmount,
      'debitCount': debitCount,
      'controlAmount': controlAmount,
      'controlCount': controlCount,
    };
  }
}
