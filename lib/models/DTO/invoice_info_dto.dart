import 'package:vietqr_admin/models/DTO/invoice_detail_dto.dart';

class UserInformation {
  final String merchantId;
  final String merchantName;
  final String bankShortName;
  final String bankId;
  final String bankAccount;
  final String userBankName;
  final String phoneNo;
  final String email;
  final String connectionType;
  final String feePackage;
  final double vat;

  UserInformation({
    required this.merchantId,
    required this.merchantName,
    required this.bankShortName,
    required this.bankId,
    required this.bankAccount,
    required this.userBankName,
    required this.phoneNo,
    required this.email,
    required this.connectionType,
    required this.feePackage,
    required this.vat,
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
      merchantId: json['merchantId'],
      merchantName: json['merchantName'],
      bankShortName: json['bankShortName'],
      bankId: json['bankId'],
      bankAccount: json['bankAccount'],
      userBankName: json['userBankName'],
      phoneNo: json['phoneNo'],
      email: json['email'] ?? '',
      connectionType: json['connectionType'],
      feePackage: json['feePackage'],
      vat: json['vat'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'merchantName': merchantName,
      'bankShortName': bankShortName,
      'bankId': bankId,
      'bankAccount': bankAccount,
      'userBankName': userBankName,
      'phoneNo': phoneNo,
      'email': email,
      'connectionType': connectionType,
      'feePackage': feePackage,
      'vat': vat,
    };
  }
}

class InvoiceInfoItem {
  String invoiceItemId;
  String invoiceItemName;
  String unit;
  String timeProcess;
  int quantity;
  int amount;
  int totalAmount;
  double vat;
  int vatAmount;
  int totalAmountAfterVat;
  int? type;

  InvoiceInfoItem({
    required this.invoiceItemId,
    required this.invoiceItemName,
    required this.unit,
    required this.quantity,
    required this.amount,
    required this.totalAmount,
    required this.vat,
    required this.vatAmount,
    required this.totalAmountAfterVat,
    required this.timeProcess,
    this.type,
  });

  factory InvoiceInfoItem.fromJson(Map<String, dynamic> json) {
    return InvoiceInfoItem(
      invoiceItemId: json['invoiceItemId'],
      invoiceItemName: json['invoiceItemName'],
      unit: json['unit'],
      quantity: json['quantity'],
      amount: json['amount'],
      totalAmount: json['totalAmount'],
      vat: json['vat'].toDouble(),
      vatAmount: json['vatAmount'],
      totalAmountAfterVat: json['totalAmountAfterVat'],
      timeProcess: json['timeProcess'],
      type: json['type'],
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
      'timeProcess': timeProcess,
      'type': type,
    };
  }
}

class InvoiceInfoDTO {
  final String invoiceId;
  String invoiceName;
  String description;
  final int totalAmount;
  final int vatAmount;
  final int totalAfterVat;
  final UserInformation userInformation;
  final List<InvoiceInfoItem> invoiceItems;
  List<PaymentRequestDTO> paymentRequestDTOS;

  InvoiceInfoDTO({
    required this.invoiceId,
    required this.invoiceName,
    required this.description,
    required this.totalAmount,
    required this.vatAmount,
    required this.totalAfterVat,
    required this.userInformation,
    required this.invoiceItems,
    required this.paymentRequestDTOS,
  });

  factory InvoiceInfoDTO.fromJson(Map<String, dynamic> json) {
    var items = json['invoiceItems'] as List;
    List<InvoiceInfoItem> invoiceItemsList =
        items.map((i) => InvoiceInfoItem.fromJson(i)).toList();
    var paymentLst = json['paymentRequestDTOS'] as List;
    List<PaymentRequestDTO> listPayment =
        paymentLst.map((e) => PaymentRequestDTO.fromJson(e)).toList();

    return InvoiceInfoDTO(
      invoiceId: json['invoiceId'],
      invoiceName: json['invoiceName'],
      description: json['description'],
      totalAmount: json['totalAmount'].toDouble(),
      vatAmount: json['vatAmount'].toDouble(),
      totalAfterVat: json['totalAfterVat'].toDouble(),
      userInformation: UserInformation.fromJson(json['userInformation']),
      invoiceItems: invoiceItemsList,
      paymentRequestDTOS: listPayment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
      'invoiceName': invoiceName,
      'description': description,
      'totalAmount': totalAmount,
      'vatAmount': vatAmount,
      'totalAfterVat': totalAfterVat,
      'userInformation': userInformation.toJson(),
      'invoiceItems': invoiceItems.map((i) => i.toJson()).toList(),
      'paymentRequestDTOS': paymentRequestDTOS.map((e) => e.toJson()).toList(),
    };
  }
}
