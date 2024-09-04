class KeyDTO {
  final String otp;
  final int duration;
  final int validFrom;
  final int validTo;
  final String key;

  KeyDTO(
      {required this.otp,
      required this.duration,
      required this.validFrom,
      required this.validTo,
      required this.key});

  factory KeyDTO.fromJson(Map<String, dynamic> json) {
    return KeyDTO(
        otp: json['otp'] ?? '',
        duration: json['duration'] ?? 0,
        validFrom: json['validFrom'] ?? 0,
        validTo: json['validTo'] ?? 0,
        key: json['key'] ?? '');
  }
}

class ResponseActiveKeyDTO {
  final String key;
  final int status;
  final int duration;
  final int createAt;
  final String userId;
  final String fullName;
  final String email;
  final String phoneNo;
  final String bankId;
  final String bankAccount;
  final String bankName;
  final String userBankName;
  final String bankShortName;
  final int validFeeFrom;
  final int validFeeTo;
  final bool validKey;

  ResponseActiveKeyDTO(
      {required this.key,
      required this.status,
      required this.duration,
      required this.createAt,
      required this.userId,
      required this.fullName,
      required this.email,
      required this.phoneNo,
      required this.bankId,
      required this.bankAccount,
      required this.bankName,
      required this.userBankName,
      required this.bankShortName,
      required this.validFeeFrom,
      required this.validFeeTo,
      required this.validKey});

  factory ResponseActiveKeyDTO.fromJson(Map<String, dynamic> json) {
    return ResponseActiveKeyDTO(
      key: json['key'],
      status: json['status'],
      duration: json['duration'],
      createAt: json['createAt'],
      userId: json['userId'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNo: json['phoneNo'],
      bankId: json['bankId'],
      bankAccount: json['bankAccount'],
      bankName: json['bankName'],
      userBankName: json['userBankName'],
      bankShortName: json['bankShortName'],
      validFeeFrom: json['validFeeFrom'],
      validFeeTo: json['validFeeTo'],
      validKey: json['validKey'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['status'] = status;
    data['duration'] = duration;
    data['createAt'] = createAt;
    data['userId'] = userId;
    data['fullName'] = fullName;
    data['email'] = email;
    data['phoneNo'] = phoneNo;
    data['bankId'] = bankId;
    data['bankAccount'] = bankAccount;
    data['bankName'] = bankName;
    data['userBankName'] = userBankName;
    data['bankShortName'] = bankShortName;
    data['validFeeFrom'] = validFeeFrom;
    data['validFeeTo'] = validFeeTo;
    data['validKey'] = validKey;
    return data;
  }
}
