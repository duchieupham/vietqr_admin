import 'dart:convert';

class CreateUserDTO {
  final String phoneNo;
  final String password;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String address;
  final String gender;
  final String nationalId;
  final String oldNationalId;
  final String nationalDate;

  CreateUserDTO({
    required this.phoneNo,
    required this.password,
    required this.email,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.address,
    required this.gender,
    required this.nationalId,
    required this.oldNationalId,
    required this.nationalDate,
  });

  // Convert a CreateUserDTO object to a Map
  Map<String, dynamic> toJson() {
    return {
      'phoneNo': phoneNo,
      'password': password,
      'email': email,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'address': address,
      'gender': gender,
      'nationalId': nationalId,
      'oldNationalId': oldNationalId,
      'nationalDate': nationalDate,
    };
  }

  // Convert a Map to a CreateUserDTO object
  factory CreateUserDTO.fromJson(Map<String, dynamic> json) {
    return CreateUserDTO(
      phoneNo: json['phoneNo'],
      password: json['password'],
      email: json['email'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      address: json['address'],
      gender: json['gender'],
      nationalId: json['nationalId'],
      oldNationalId: json['oldNationalId'],
      nationalDate: json['nationalDate'],
    );
  }
}
