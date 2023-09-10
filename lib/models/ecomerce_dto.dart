class EcomerceDTO {
  final String id;
  final int active;
  final String platform;
  final String url;
  final String phoneNo;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  const EcomerceDTO(
      {this.id = '',
      this.active = 0,
      this.platform = '',
      this.url = '',
      this.phoneNo = '',
      this.email = '',
      this.lastName = '',
      this.middleName = '',
      this.firstName = ''});

  factory EcomerceDTO.fromJson(Map<String, dynamic> json) {
    return EcomerceDTO(
      id: json['id'] ?? '',
      active: json['active'] ?? 0,
      platform: json['platform'] ?? '',
      url: json['url'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',
      lastName: json['lastName'] ?? '',
      middleName: json['middleName'] ?? '',
      firstName: json['firstName'] ?? '',
    );
  }
}
