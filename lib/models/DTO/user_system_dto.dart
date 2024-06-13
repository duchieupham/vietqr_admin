class UserSystemDTO {
  String id;
  String address;
  String birthDate;
  String email;
  String fullName;
  int gender;
  int status;
  String userIp;
  String phoneNo;
  String registerPlatform;

  UserSystemDTO({
    required this.id,
    required this.address,
    required this.birthDate,
    required this.email,
    required this.fullName,
    required this.gender,
    required this.status,
    required this.userIp,
    required this.phoneNo,
    required this.registerPlatform,
  });

  // Factory method to create an instance from JSON
  factory UserSystemDTO.fromJson(Map<String, dynamic> json) {
    return UserSystemDTO(
      id: json['id'],
      address: json['address'] ?? '-',
      birthDate: json['birthDate'] ?? '-',
      email: json['email'] ?? '-',
      fullName: json['fullName'],
      gender: json['gender'],
      status: json['status'],
      userIp: json['userIp'],
      phoneNo: json['phoneNo'],
      registerPlatform: json['registerPlatform'] ?? '-',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'birthDate': birthDate,
      'email': email,
      'fullName': fullName,
      'gender': gender,
      'status': status,
      'userIp': userIp,
      'phoneNo': phoneNo,
      'registerPlatform': registerPlatform,
    };
  }
}
