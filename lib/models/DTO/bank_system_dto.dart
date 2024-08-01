class BankSystemDTO {
  final String bankAccount;
  final String bankAccountName;
  final String bankShortName;
  final String phoneAuthenticated;
  final bool mmsActive;
  final bool status;
  final int validFeeTo;
  final String nationalId;
  final String phoneNo;
  final String email;
  final String vso;

  BankSystemDTO({
    required this.bankAccount,
    required this.bankAccountName,
    required this.bankShortName,
    required this.phoneAuthenticated,
    required this.status,
    required this.mmsActive,
    required this.validFeeTo,
    required this.nationalId,
    required this.phoneNo,
    required this.email,
    required this.vso,
  });

  // Convert a UserSystemDTO object to a Map
  Map<String, dynamic> toJson() {
    return {
      'bankAccount': bankAccount,
      'bankAccountName': bankAccountName,
      'bankShortName': bankShortName,
      'phoneAuthenticated': phoneAuthenticated,
      'status': status,
      'mmsActive': mmsActive,
      'validFeeTo': validFeeTo,
      'nationalId': nationalId,
      'phoneNo': phoneNo,
      'email': email,
      'vso': vso,
    };
  }

  // Convert a Map to a UserSystemDTO object
  factory BankSystemDTO.fromJson(Map<String, dynamic> json) {
    return BankSystemDTO(
      bankAccount: json['bankAccount'],
      bankAccountName: json['bankAccountName'],
      bankShortName: json['bankShortName'],
      phoneAuthenticated: json['phoneAuthenticated'],
      status: json['status'],
      mmsActive: json['mmsActive'],
      validFeeTo: json['validFeeTo'],
      nationalId: json['nationalId'],
      phoneNo: json['phoneNo'],
      email: json['email'],
      vso: json['vso'],
    );
  }
}
