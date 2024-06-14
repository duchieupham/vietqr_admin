class UserDetailDTO {
  List<UserInfo>? userInfo;
  List<BankInfo>? bankInfo;
  List<BankShareInfo>? bankShareInfo;
  List<SocialMedia>? socialMedia;
  int? balance;
  int? score;

  UserDetailDTO(
      {this.userInfo,
      this.bankInfo,
      this.bankShareInfo,
      this.socialMedia,
      this.balance = 0,
      this.score = 0});

  factory UserDetailDTO.fromJson(Map<String, dynamic> json) {
    return UserDetailDTO(
      userInfo: json['userInfo'] != null
          ? List<UserInfo>.from(
              json['userInfo'].map((x) => UserInfo.fromJson(x)))
          : null,
      bankInfo: json['bankInfo'] != null
          ? List<BankInfo>.from(
              json['bankInfo'].map((x) => BankInfo.fromJson(x)))
          : null,
      bankShareInfo: json['bankShareInfo'] != null
          ? List<BankShareInfo>.from(
              json['bankShareInfo'].map((x) => BankShareInfo.fromJson(x)))
          : null,
      socialMedia: json['socalMedia'] != null
          ? List<SocialMedia>.from(
              json['socalMedia'].map((x) => SocialMedia.fromJson(x)))
          : null,
      balance: json['balance'] ?? 0,
      score: json['score'] ?? 0,
    );
  }
}

class UserInfo {
  String bankAccount;
  String bankAccountName;
  int status;
  String email;
  String nationalId;
  String nationalDate;
  String oldNationalId;
  int gender;
  String address;

  UserInfo({
    required this.bankAccount,
    required this.bankAccountName,
    required this.status,
    required this.email,
    required this.nationalId,
    required this.nationalDate,
    required this.oldNationalId,
    required this.gender,
    required this.address,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      bankAccount: json['bankAccount'],
      bankAccountName: json['bankAccountName'],
      status: json['status'],
      email: json['email'],
      nationalId: json['national_id'],
      nationalDate: json['national_date'],
      oldNationalId: json['old_national_id'],
      gender: json['gender'],
      address: json['address'],
    );
  }
}

class BankInfo {
  String bankAccount;
  String bankShortName;
  String bankAccountName;
  int bankTypeId;
  String fullName;
  String nationalId;
  String phoneAuthenticated;
  int isAuthenticated;
  int activeService;
  int validFeeFrom;
  int validFeeTo;
  int mmsActive;

  BankInfo({
    required this.bankAccount,
    required this.bankAccountName,
    required this.bankShortName,
    required this.bankTypeId,
    required this.fullName,
    required this.nationalId,
    required this.phoneAuthenticated,
    required this.isAuthenticated,
    required this.activeService,
    required this.validFeeFrom,
    required this.validFeeTo,
    required this.mmsActive,
  });

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      bankAccount: json['bankAccount'],
      bankShortName: json['bank_short_name'],
      mmsActive: json['mmsActive'],
      bankAccountName: json['bankAccountName'],
      bankTypeId: json['bank_type_id'],
      fullName: json['fullName'],
      nationalId: json['national_id'],
      phoneAuthenticated: json['phone_authenticated'],
      isAuthenticated: json['is_authenticated'],
      activeService: json['activeService'],
      validFeeFrom: json['valid_fee_from'],
      validFeeTo: json['valid_fee_to'],
    );
  }
}

class BankShareInfo {
  String bankAccount;
  String bankShortName;
  String bankAccountName;
  int bankTypeId;
  String fullName;
  String nationalId;
  String phoneAuthenticated;
  int isAuthenticated;
  int activeService;
  int validFeeFrom;
  int validFeeTo;
  int mmsActive;

  BankShareInfo({
    required this.bankAccount,
    required this.bankAccountName,
    required this.bankShortName,
    required this.bankTypeId,
    required this.fullName,
    required this.nationalId,
    required this.phoneAuthenticated,
    required this.isAuthenticated,
    required this.activeService,
    required this.validFeeFrom,
    required this.validFeeTo,
    required this.mmsActive,
  });

  factory BankShareInfo.fromJson(Map<String, dynamic> json) {
    return BankShareInfo(
      bankAccount: json['bankAccount'],
      bankShortName: json['bank_short_name'],
      mmsActive: json['mmsActive'],
      bankAccountName: json['bankAccountName'],
      bankTypeId: json['bank_type_id'],
      fullName: json['fullName'],
      nationalId: json['national_id'],
      phoneAuthenticated: json['phone_authenticated'],
      isAuthenticated: json['is_authenticated'],
      activeService: json['activeService'],
      validFeeFrom: json['valid_fee_from'],
      validFeeTo: json['valid_fee_to'],
    );
  }
}

class SocialMedia {
  String platform;
  int accountConnected;
  String chatId;

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
}
