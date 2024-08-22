
class UserInfo {
  final String id;
  final String address;
  final String fullName;
  final bool status;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String nationalId;
  final String phoneNo;
  final String oldNationalId;
  final String nationalDate;
  final int gender;

  UserInfo({
    required this.id,
    required this.address,
    required this.fullName,
    required this.status,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.nationalId,
    required this.phoneNo,
    required this.oldNationalId,
    required this.nationalDate,
    required this.gender,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      address: json['address'],
      fullName: json['fullName'],
      status: json['status'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['email'],
      nationalId: json['nationalId'],
      phoneNo: json['phoneNo'],
      oldNationalId: json['oldNationalId'],
      nationalDate: json['nationalDate'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'nationalId': nationalId,
      'oldNationalId': oldNationalId,
      'nationalDate': nationalDate,
      'gender': gender,
    };
  }
}

class BankInfo {
  final String bankAccount;
  final String bankAccountName;
  final bool status;
  final bool mmsActive;
  final String phoneAuthenticated;
  final String nationalId;
  final String bankShortName;
  final int fromDate;
  final int toDate;
  final int activeService;

  BankInfo({
    required this.bankAccount,
    required this.bankAccountName,
    required this.status,
    required this.mmsActive,
    required this.phoneAuthenticated,
    required this.nationalId,
    required this.bankShortName,
    required this.fromDate,
    required this.toDate,
    required this.activeService,
  });

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      bankAccount: json['bankAccount'],
      bankAccountName: json['bankAccountName'],
      status: json['status'],
      mmsActive: json['mmsActive'],
      phoneAuthenticated: json['phoneAuthenticated'],
      nationalId: json['nationalId'],
      bankShortName: json['bankShortName'],
      fromDate: json['fromDate'],
      toDate: json['toDate'],
      activeService: json['activeService'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankAccount': bankAccount,
      'bankAccountName': bankAccountName,
      'status': status,
      'mmsActive': mmsActive,
      'phoneAuthenticated': phoneAuthenticated,
      'nationalId': nationalId,
      'bankShortName': bankShortName,
      'fromDate': fromDate,
      'toDate': toDate,
      'activeService': activeService,
    };
  }
}

class SocialMedia {
  final String platform;
  final String chatId;
  final int accountConnected;

  SocialMedia({
    required this.platform,
    required this.chatId,
    required this.accountConnected,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      platform: json['platform'],
      chatId: json['chatId'],
      accountConnected: json['accountConnected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'chatId': chatId,
      'accountConnected': accountConnected,
    };
  }
}

class UserDetailDTO {
  final UserInfo userInfo;
  final List<BankInfo> bankInfo;
  final List<BankInfo> bankShareInfo;
  final List<SocialMedia> socalMedia;
  final int balance;
  final int score;

  UserDetailDTO({
    required this.userInfo,
    required this.bankInfo,
    required this.bankShareInfo,
    required this.socalMedia,
    required this.balance,
    required this.score,
  });

  factory UserDetailDTO.fromJson(Map<String, dynamic> json) {
    return UserDetailDTO(
      userInfo: UserInfo.fromJson(json['userInfo']),
      bankInfo:
          (json['bankInfo'] as List).map((e) => BankInfo.fromJson(e)).toList(),
      bankShareInfo: (json['bankShareInfo'] as List)
          .map((e) => BankInfo.fromJson(e))
          .toList(),
      socalMedia: (json['socalMedia'] as List)
          .map((e) => SocialMedia.fromJson(e))
          .toList(),
      balance: json['balance'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userInfo': userInfo.toJson(),
      'bankInfo': bankInfo.map((e) => e.toJson()).toList(),
      'bankShareInfo': bankShareInfo.map((e) => e.toJson()).toList(),
      'socalMedia': socalMedia.map((e) => e.toJson()).toList(),
      'balance': balance,
      'score': score,
    };
  }
}
