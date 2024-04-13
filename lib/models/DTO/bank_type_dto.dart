class BankTypeDTO {
  final String id;
  final String bankCode;
  final String bankName;
  final String bankShortName;
  final String imageId;
  final String caiValue;
  final int status;

  const BankTypeDTO({
    required this.id,
    required this.bankCode,
    required this.bankName,
    required this.bankShortName,
    required this.imageId,
    required this.caiValue,
    required this.status,
  });

  factory BankTypeDTO.fromJson(Map<String, dynamic> json) {
    return BankTypeDTO(
      id: json['id'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      imageId: json['imageId'] ?? '',
      caiValue: json['caiValue'] ?? '',
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bankCode'] = bankCode;
    data['bankName'] = bankName;
    data['bankShortName'] = bankShortName;
    data['imageId'] = imageId;
    data['caiValue'] = caiValue;
    data['status'] = status;
    return data;
  }
}
