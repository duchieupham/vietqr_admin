class InvoiceDTO {
  List<InvoiceItem> items;
  InvoiceExtraData extraData;

  InvoiceDTO({required this.items, required this.extraData});

  factory InvoiceDTO.fromJson(Map<String, dynamic> json) {
    return InvoiceDTO(
      items: List<InvoiceItem>.from(
          json['items'].map((x) => InvoiceItem.fromJson(x))),
      extraData: InvoiceExtraData.fromJson(json['extraData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toJson())),
      'extraData': extraData.toJson(),
    };
  }
}

class InvoiceItem {
  String invoiceId;
  int timePaid;
  String vso;
  String midName;
  String bankAccount;
  String bankShortName;
  int amount;
  String billNumber;
  String invoiceName;
  String fullName;
  String phoneNo;
  String email;
  int timeCreated;
  int status;
  String qrCode;
  int vatAmount;
  double vat;
  int amountNoVat;

  InvoiceItem({
    required this.invoiceId,
    required this.timePaid,
    required this.vso,
    required this.midName,
    required this.amount,
    required this.billNumber,
    required this.invoiceName,
    required this.fullName,
    required this.bankAccount,
    required this.bankShortName,
    required this.phoneNo,
    required this.email,
    required this.timeCreated,
    required this.status,
    required this.amountNoVat,
    required this.qrCode,
    required this.vat,
    required this.vatAmount,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      invoiceId: json['invoiceId'],
      timePaid: json['timePaid'],
      vso: json['vso'],
      midName: json['midName'],
      amount: json['amount'],
      billNumber: json['billNumber'],
      invoiceName: json['invoiceName'],
      fullName: json['fullName'],
      phoneNo: json['phoneNo'],
      bankAccount: json['bankAccount'],
      bankShortName: json['bankShortName'],
      email: json['email'],
      timeCreated: json['timeCreated'],
      status: json['status'],
      amountNoVat: json['amountNoVat'],
      qrCode: json['qrCode'],
      vat: json['vat'],
      vatAmount: json['vatAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
      'timePaid': timePaid,
      'vso': vso,
      'midName': midName,
      'amount': amount,
      'billNumber': billNumber,
      'invoiceName': invoiceName,
      'fullName': fullName,
      'phoneNo': phoneNo,
      'bankAccount': bankAccount,
      'bankShortName': bankShortName,
      'email': email,
      'timeCreated': timeCreated,
      'status': status,
      'amountNoVat': amountNoVat,
      'qrCode': qrCode,
      'vat': vat,
      'vatAmount': vatAmount,
    };
  }
}

class InvoiceExtraData {
  String month;
  int pendingFee;
  int pendingCount;
  int completeFee;
  int completeCount;

  InvoiceExtraData({
    required this.month,
    required this.pendingFee,
    required this.pendingCount,
    required this.completeFee,
    required this.completeCount,
  });

  factory InvoiceExtraData.fromJson(Map<String, dynamic> json) {
    return InvoiceExtraData(
      month: json['month'],
      pendingFee: json['pendingFee'],
      pendingCount: json['pendingCount'],
      completeFee: json['completeFee'],
      completeCount: json['completeCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'pendingFee': pendingFee,
      'pendingCount': pendingCount,
      'completeFee': completeFee,
      'completeCount': completeCount,
    };
  }
}
