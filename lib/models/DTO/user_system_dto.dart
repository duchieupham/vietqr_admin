class UserSystemDTO {
  final String id;
  final String address;
  final String birthDate;
  final String email;
  final bool status;
  final int gender;
  final int balance;
  final int score;
  final String firstName;
  final String middleName;
  final String lastName;
  final String fullName;
  final String userIp;
  final String phoneNo;
  final String registerPlatform;
  final String nationalDate;
  final String nationalId;
  final String oldNationalId;
  final String userIdDetail;
  final int getTimeRegister;

  UserSystemDTO({
    required this.id,
    required this.address,
    required this.birthDate,
    required this.email,
    required this.status,
    required this.gender,
    required this.balance,
    required this.score,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.fullName,
    required this.userIp,
    required this.phoneNo,
    required this.registerPlatform,
    required this.nationalDate,
    required this.nationalId,
    required this.oldNationalId,
    required this.userIdDetail,
    required this.getTimeRegister,
  });

  // Convert a UserSystemDTO object to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'birthDate': birthDate,
      'email': email,
      'status': status,
      'gender': gender,
      'balance': balance,
      'score': score,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'fullName': fullName,
      'userIp': userIp,
      'phoneNo': phoneNo,
      'registerPlatform': registerPlatform,
      'nationalDate': nationalDate,
      'nationalId': nationalId,
      'oldNationalId': oldNationalId,
      'userIdDetail': userIdDetail,
      'getTimeRegister': getTimeRegister,
    };
  }

  // Convert a Map to a UserSystemDTO object
  factory UserSystemDTO.fromJson(Map<String, dynamic> json) {
    return UserSystemDTO(
      id: json['id'],
      address: json['address'],
      birthDate: json['birthDate'],
      email: json['email'],
      status: json['status'],
      gender: json['gender'],
      balance: json['balance'],
      score: json['score'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      userIp: json['userIp'],
      phoneNo: json['phoneNo'],
      registerPlatform: json['registerPlatform'],
      nationalDate: json['nationalDate'],
      nationalId: json['nationalId'],
      oldNationalId: json['oldNationalId'],
      userIdDetail: json['userIdDetail'],
      getTimeRegister: json['getTimeRegister'],
    );
  }
}
