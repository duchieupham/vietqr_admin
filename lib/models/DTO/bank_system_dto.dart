class BankSystemDTO {
  List<BankSystemItem> items;
  BankSystemExtraData extraData;

  BankSystemDTO({required this.items, required this.extraData});

  factory BankSystemDTO.fromJson(Map<String, dynamic> json) {
    return BankSystemDTO(
      items: List<BankSystemItem>.from(
          json['items'].map((x) => BankSystemItem.fromJson(x))),
      extraData: BankSystemExtraData.fromJson(json['extraData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toJson())),
      'extraData': extraData.toJson(),
    };
  }
}

class BankSystemItem {
  final String bankId;
  final String bankAccount;
  final String bankAccountName;
  final String bankShortName;
  final String phoneAuthenticated;
  final bool mmsActive;
  final bool status;
  final int validFeeTo;
  final int validFrom;
  final int timeCreate;
  final String nationalId;
  final String phoneNo;
  final String email;
  final String vso;
  final String bankCode;
  final int bankTypeStatus;
  final bool validService;
  final bool authenticated;

  BankSystemItem({
    required this.bankId,
    required this.bankAccount,
    required this.bankAccountName,
    required this.bankShortName,
    required this.phoneAuthenticated,
    required this.status,
    required this.mmsActive,
    required this.validFeeTo,
    required this.validFrom,
    required this.timeCreate,
    required this.nationalId,
    required this.phoneNo,
    required this.email,
    required this.vso,
    required this.bankCode,
    required this.bankTypeStatus,
    required this.validService,
    required this.authenticated,
  });

  // Convert a UserSystemDTO object to a Map
  Map<String, dynamic> toJson() {
    return {
      'bankId': bankId,
      'bankAccount': bankAccount,
      'bankAccountName': bankAccountName,
      'bankShortName': bankShortName,
      'phoneAuthenticated': phoneAuthenticated,
      'status': status,
      'mmsActive': mmsActive,
      'validFeeTo': validFeeTo,
      'validFrom': validFrom,
      'timeCreate': timeCreate,
      'nationalId': nationalId,
      'phoneNo': phoneNo,
      'email': email,
      'vso': vso,
      'bankCode': bankCode,
      'bankTypeStatus': bankTypeStatus,
      'validService': validService,
      'authenticated': authenticated,
    };
  }

  // Convert a Map to a UserSystemDTO object
  factory BankSystemItem.fromJson(Map<String, dynamic> json) {
    return BankSystemItem(
      bankId: json['bankId'],
      bankAccount: json['bankAccount'],
      bankAccountName: json['bankAccountName'],
      bankShortName: json['bankShortName'],
      phoneAuthenticated: json['phoneAuthenticated'],
      status: json['status'],
      mmsActive: json['mmsActive'],
      validFeeTo: json['validFeeTo'],
      validFrom: json['validFrom'],
      timeCreate: json['timeCreate'],
      nationalId: json['nationalId'],
      phoneNo: json['phoneNo'],
      email: json['email'],
      vso: json['vso'],
      bankCode: json['bankCode'],
      bankTypeStatus: json['bankTypeStatus'],
      validService: json['validService'],
      authenticated: json['authenticated'],
    );
  }
}

class BankSystemExtraData {
  int overdueCount;
  int nearlyExpireCount;
  int validCount;
  int notRegisteredCount;

  BankSystemExtraData(
      {required this.overdueCount,
      required this.nearlyExpireCount,
      required this.validCount,
      required this.notRegisteredCount});
  factory BankSystemExtraData.fromJson(Map<String, dynamic> json) {
    return BankSystemExtraData(
      overdueCount: json['overdueCount'],
      nearlyExpireCount: json['nearlyExpireCount'],
      validCount: json['validCount'],
      notRegisteredCount: json['notRegisteredCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overdueCount': overdueCount,
      'nearlyExpireCount': nearlyExpireCount,
      'validCount': validCount,
      'notRegisteredCount': notRegisteredCount,
    };
  }
}
