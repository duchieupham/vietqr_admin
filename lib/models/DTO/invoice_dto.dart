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
  int amount;
  String bankShortName;
  String bankAccount;
  double vat;
  int vatAmount;
  int amountNoVat;
  String billNumber;
  String invoiceName;
  String fullName;
  String phoneNo;
  String email;
  int timeCreated;
  int status;

  InvoiceItem({
    required this.invoiceId,
    required this.timePaid,
    required this.vso,
    required this.midName,
    required this.amount,
    required this.bankShortName,
    required this.bankAccount,
    required this.vat,
    required this.vatAmount,
    required this.amountNoVat,
    required this.billNumber,
    required this.invoiceName,
    required this.fullName,
    required this.phoneNo,
    required this.email,
    required this.timeCreated,
    required this.status,
  });

  // Convert from JSON (deserialize)
  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      invoiceId: json['invoiceId'],
      timePaid: json['timePaid'],
      vso: json['vso'],
      midName: json['midName'],
      amount: json['amount'],
      bankShortName: json['bankShortName'],
      bankAccount: json['bankAccount'],
      vat: json['vat'].toDouble(),
      vatAmount: json['vatAmount'],
      amountNoVat: json['amountNoVat'],
      billNumber: json['billNumber'],
      invoiceName: json['invoiceName'],
      fullName: json['fullName'],
      phoneNo: json['phoneNo'],
      email: json['email'],
      timeCreated: json['timeCreated'],
      status: json['status'],
    );
  }

  // Convert to JSON (serialize)
  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
      'timePaid': timePaid,
      'vso': vso,
      'midName': midName,
      'amount': amount,
      'bankShortName': bankShortName,
      'bankAccount': bankAccount,
      'vat': vat,
      'vatAmount': vatAmount,
      'amountNoVat': amountNoVat,
      'billNumber': billNumber,
      'invoiceName': invoiceName,
      'fullName': fullName,
      'phoneNo': phoneNo,
      'email': email,
      'timeCreated': timeCreated,
      'status': status,
    };
  }
}

class InvoiceExtraData {
  String month;
  int pendingAmount;
  int pendingCount;
  int completeAmount;
  int completeCount;
  int unFullyPaidCount;

  InvoiceExtraData({
    required this.month,
    required this.pendingAmount,
    required this.pendingCount,
    required this.completeAmount,
    required this.completeCount,
    required this.unFullyPaidCount,
  });

  factory InvoiceExtraData.fromJson(Map<String, dynamic> json) {
    return InvoiceExtraData(
      month: json['month'],
      pendingAmount: json['pendingAmount'],
      pendingCount: json['pendingCount'],
      completeAmount: json['completeAmount'],
      completeCount: json['completeCount'],
      unFullyPaidCount: json['unFullyPaidCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'pendingAmount': pendingAmount,
      'pendingCount': pendingCount,
      'completeAmount': completeAmount,
      'completeCount': completeCount,
      'unFullyPaidCount': unFullyPaidCount,
    };
  }
}

class MerchantData {
  List<ItemMerchant> items;
  InvoiceExtraData extraData;

  MerchantData({required this.items, required this.extraData});

  // Convert from JSON (deserialize)
  factory MerchantData.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<ItemMerchant> itemsList =
        list.map((i) => ItemMerchant.fromJson(i)).toList();

    return MerchantData(
      items: itemsList,
      extraData: InvoiceExtraData.fromJson(json['extraData']),
    );
  }

  // Convert to JSON (serialize)
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'extraData': extraData.toJson(),
    };
  }
}

class ItemMerchant {
  String invoiceId;
  String vso;
  String merchantName;
  int pendingAmount;
  int completeAmount;
  String vietQrAccount;
  String email;

  ItemMerchant({
    required this.invoiceId,
    required this.vso,
    required this.merchantName,
    required this.pendingAmount,
    required this.completeAmount,
    required this.vietQrAccount,
    required this.email,
  });

  ItemMerchant copyWith({
    String? invoiceId,
    String? vso,
    String? merchantName,
    int? pendingAmount,
    int? completeAmount,
    String? vietQrAccount,
    String? email,
  }) {
    return ItemMerchant(
      invoiceId: invoiceId ?? this.invoiceId,
      vso: vso ?? this.vso,
      merchantName: merchantName ?? this.merchantName,
      pendingAmount: pendingAmount ?? this.pendingAmount,
      completeAmount: completeAmount ?? this.completeAmount,
      vietQrAccount: vietQrAccount ?? this.vietQrAccount,
      email: email ?? this.email,
    );
  }

  // Convert from JSON (deserialize)
  factory ItemMerchant.fromJson(Map<String, dynamic> json) {
    return ItemMerchant(
      invoiceId: json['invoiceId'],
      vso: json['vso'],
      merchantName: json['merchantName'],
      pendingAmount: json['pendingAmount'],
      completeAmount: json['completeAmount'],
      vietQrAccount: json['vietQrAccount'],
      email: json['email'],
    );
  }

  // Convert to JSON (serialize)
  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
      'vso': vso,
      'merchantName': merchantName,
      'pendingAmount': pendingAmount,
      'completeAmount': completeAmount,
      'vietQrAccount': vietQrAccount,
      'email': email,
    };
  }
}

class UnpaidInvoiceDTO {
  List<UnpaidInvoiceItem> items;

  UnpaidInvoiceDTO({required this.items,});

  factory UnpaidInvoiceDTO.fromJson(Map<String, dynamic> json) {
    return UnpaidInvoiceDTO(
      items: List<UnpaidInvoiceItem>.from(
          json['items'].map((x) => UnpaidInvoiceItem.fromJson(x))),
      // extraData: InvoiceExtraData.fromJson(json['extraData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toJson())),
    };
  }
}

class UnpaidInvoiceItem {
  String invoiceId;
  String vso;
  String merchantName;
  int pendingAmount;
  int completeAmount;
  String vietQrAccount;
  String email;

  UnpaidInvoiceItem(
      {required this.invoiceId,
      required this.vso,
      required this.merchantName,
      required this.pendingAmount,
      required this.completeAmount,
      required this.vietQrAccount,
      required this.email});

  factory UnpaidInvoiceItem.fromJson(Map<String, dynamic> json) {
    return UnpaidInvoiceItem(
      invoiceId: json['invoiceId'],
      vso: json['vso'],
      merchantName: json['merchantName'],
      pendingAmount: json['pendingAmount'],
      completeAmount: json['completeAmount'],
      vietQrAccount: json['vietQrAccount'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoiceId'] = invoiceId;
    data['vso'] = vso;
    data['merchantName'] = merchantName;
    data['pendingAmount'] = pendingAmount;
    data['completeAmount'] = completeAmount;
    data['vietQrAccount'] = vietQrAccount;
    data['email'] = email;
    return data;
  }
}
