class QRCodeTDTO {
  final String bankCode;
  final String bankname;
  final String bankAccount;
  final String userBankName;
  final String amount;
  final String content;
  final String qrCode;
  final String imgId;

  const QRCodeTDTO({
    this.content = '',
    this.amount = '',
    this.bankCode = '',
    this.bankname = '',
    this.bankAccount = '',
    this.userBankName = '',
    this.qrCode = '',
    this.imgId = '',
  });

  factory QRCodeTDTO.fromJson(Map<String, dynamic> json) {
    return QRCodeTDTO(
      content: json['content'] ?? '',
      amount: json['amount'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankname: json['bankName'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      userBankName: json['userBankName'] ?? '',
      qrCode: json['qrCode'] ?? '',
      imgId: json['imgId'] ?? '',
    );
  }
}
