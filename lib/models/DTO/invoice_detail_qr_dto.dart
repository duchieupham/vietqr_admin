// ignore_for_file: public_member_api_docs, sort_constructors_first
class InvoiceDetailQrDTO {
  String qrCode;
  int totalAmountAfterVat;
  String invoiceName;
  String midName;
  String vso;
  String bankAccount;
  String bankShortName;
  String invoiceNumber;
  String userBankName;
  int totalAmount;
  String urlLink;
  double vat;
  int vatAmount;
  String invoiceId;

  InvoiceDetailQrDTO({
    required this.qrCode,
    required this.totalAmountAfterVat,
    required this.invoiceName,
    required this.midName,
    required this.vso,
    required this.bankAccount,
    required this.bankShortName,
    required this.invoiceNumber,
    required this.userBankName,
    required this.totalAmount,
    required this.urlLink,
    required this.vat,
    required this.vatAmount,
    required this.invoiceId,
  });

  factory InvoiceDetailQrDTO.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailQrDTO(
      qrCode: json['qrCode'],
      totalAmountAfterVat: json['totalAmountAfterVat'],
      invoiceName: json['invoiceName'],
      midName: json['midName'],
      vso: json['vso'],
      bankAccount: json['bankAccount'],
      bankShortName: json['bankShortName'],
      invoiceNumber: json['invoiceNumber'],
      userBankName: json['userBankName'],
      totalAmount: json['totalAmount'],
      urlLink: json['urlLink'] ?? '',
      vat: json['vat'].toDouble(),
      vatAmount: json['vatAmount'],
      invoiceId: json['invoiceId'],
    );
  }
}

class UnpaidInvoiceDetailQrDTO {
  String qrCode;
  int totalAmountAfterVat;
  String invoiceName;
  String midName;
  String vso;
  String bankAccount;
  String bankShortName;
  String invoiceNumber;
  String userBankName;
  int totalAmount;
  String urlLink;
  int vat;
  int vatAmount;
  String invoiceId;
  int expiredTime;

  UnpaidInvoiceDetailQrDTO({
    required this.qrCode,
    required this.totalAmountAfterVat,
    required this.invoiceName,
    required this.midName,
    required this.vso,
    required this.bankAccount,
    required this.bankShortName,
    required this.invoiceNumber,
    required this.userBankName,
    required this.totalAmount,
    required this.urlLink,
    required this.vat,
    required this.vatAmount,
    required this.invoiceId,
    required this.expiredTime,
  });

  factory UnpaidInvoiceDetailQrDTO.fromJson(Map<String, dynamic> json) {
    return UnpaidInvoiceDetailQrDTO(
      qrCode: json['qrCode'],
      totalAmountAfterVat: json['totalAmountAfterVat'],
      invoiceName: json['invoiceName'],
      midName: json['midName'],
      vso: json['vso'],
      bankAccount: json['bankAccount'],
      bankShortName: json['bankShortName'],
      invoiceNumber: json['invoiceNumber'],
      userBankName: json['userBankName'],
      totalAmount: json['totalAmount'],
      urlLink: json['urlLink'],
      vat: json['vat'],
      vatAmount: json['vatAmount'],
      invoiceId: json['invoiceId'],
      expiredTime: json['expiredTime'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qrCode'] = qrCode;
    data['totalAmountAfterVat'] = totalAmountAfterVat;
    data['invoiceName'] = invoiceName;
    data['midName'] = midName;
    data['vso'] = vso;
    data['bankAccount'] = bankAccount;
    data['bankShortName'] = bankShortName;
    data['invoiceNumber'] = invoiceNumber;
    data['userBankName'] = userBankName;
    data['totalAmount'] = totalAmount;
    data['urlLink'] = urlLink;
    data['vat'] = vat;
    data['vatAmount'] = vatAmount;
    data['invoiceId'] = invoiceId;
    data['expiredTime'] = expiredTime;
    return data;
  }
}
