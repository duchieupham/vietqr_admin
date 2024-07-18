class QrBoxDTO {
  String boxId;
  String macAddr;
  String boxCode;
  String merchantName;
  String terminalId;
  String terminalName;
  String terminalCode;
  String bankAccount;
  String bankShortName;
  String userBankName;
  String feePackage;
  String boxAddress;
  String certificate;
  int status;
  int lastChecked;

  QrBoxDTO({
    required this.boxId,
    required this.macAddr,
    required this.boxCode,
    required this.merchantName,
    required this.terminalId,
    required this.terminalName,
    required this.terminalCode,
    required this.bankAccount,
    required this.bankShortName,
    required this.userBankName,
    required this.feePackage,
    required this.boxAddress,
    required this.certificate,
    required this.status,
    required this.lastChecked,
  });

  factory QrBoxDTO.fromJson(Map<String, dynamic> json) {
    return QrBoxDTO(
      boxId: json['boxId'],
      macAddr: json['macAddr'],
      boxCode: json['boxCode'],
      merchantName: json['merchantName'] ?? '',
      terminalId: json['terminalId'] ?? '',
      terminalName: json['terminalName'] ?? '',
      terminalCode: json['terminalCode'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      userBankName: json['userBankName'] ?? '',
      feePackage: json['feePackage'] ?? '',
      boxAddress: json['boxAddress'] ?? '',
      certificate: json['certificate'],
      status: json['status'],
      lastChecked: json['lastChecked'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'boxId': boxId,
      'macAddr': macAddr,
      'boxCode': boxCode,
      'merchantName': merchantName,
      'terminalId': terminalId,
      'terminalName': terminalName,
      'terminalCode': terminalCode,
      'bankAccount': bankAccount,
      'bankShortName': bankShortName,
      'userBankName': userBankName,
      'feePackage': feePackage,
      'boxAddress': boxAddress,
      'certificate': certificate,
      'status': status,
    };
  }
}
