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
      vat: json['vat'].toDouble(),
      vatAmount: json['vatAmount'],
      invoiceId: json['invoiceId'],
    );
  }
}
