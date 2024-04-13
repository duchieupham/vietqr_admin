class AccountInformationDTO {
  final String adminId;
  final String name;
  final int role;
  final int iat;
  final int exp;

  const AccountInformationDTO(
      {this.name = '',
      this.adminId = '',
      this.exp = 0,
      this.iat = 0,
      this.role = 0});

  factory AccountInformationDTO.fromJsonApi(Map<String, dynamic> json) {
    return AccountInformationDTO(
      name: json['name'] ?? '',
      adminId: json['adminId'] ?? '',
      exp: json['exp'] ?? 0,
      iat: json['iat'] ?? 0,
      role: json['role'] ?? 0,
    );
  }

  factory AccountInformationDTO.fromJson(Map<String, dynamic> json) {
    return AccountInformationDTO(
      name: json['name'] ?? '',
      adminId: json['adminId'] ?? '',
      exp: int.parse(json['exp'] ?? '0'),
      iat: int.parse(json['iat'] ?? '0'),
      role: int.parse(json['role'] ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['adminId'] = adminId;
    data['exp'] = exp;
    data['iat'] = iat;
    data['role'] = role;

    return data;
  }

  Map<String, dynamic> toDataString() {
    final Map<String, dynamic> data = {};
    data['"exp"'] = '"$exp"';
    data['"iat"'] = '"$iat"';
    data['"role"'] = '"$role"';
    data['"adminId"'] = (adminId == '') ? '""' : '"$adminId"';
    data['"name"'] = (name == '') ? '""' : '"$name"';

    return data;
  }
}
