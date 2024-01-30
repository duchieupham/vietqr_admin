class AccountBankRQDTO {
  final String id;
  final String bankAccount;
  final String userBankName;
  final String bankCode;
  final String nationalId;
  final String phoneAuthenticated;
  final int requestType;
  final String address;
  final int timeCreated;
  final String userId;
  final bool isSync;
  final String firstName;
  final String middleName;
  final String lastName;
  final String phoneNo;

  const AccountBankRQDTO({
    this.id = '',
    this.bankAccount = '',
    this.userBankName = '',
    this.bankCode = '',
    this.nationalId = '',
    this.phoneAuthenticated = '',
    this.requestType = 0,
    this.address = '',
    this.timeCreated = 0,
    this.userId = '',
    this.isSync = false,
    this.phoneNo = '',
    this.firstName = '',
    this.lastName = '',
    this.middleName = '',
  });

  factory AccountBankRQDTO.fromJson(Map<String, dynamic> json) {
    return AccountBankRQDTO(
      id: json['id'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      userBankName: json['userBankName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      nationalId: json['nationalId'] ?? '',
      phoneAuthenticated: json['phoneAuthenticated'] ?? '',
      requestType: json['requestType'] ?? 0,
      address: json['address'],
      timeCreated: json['timeCreated'] ?? 0,
      userId: json['userId'] ?? '',
      isSync: json['isSync'] ?? false,
      phoneNo: json['phoneNo'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      middleName: json['middleName'] ?? '',
    );
  }
}
