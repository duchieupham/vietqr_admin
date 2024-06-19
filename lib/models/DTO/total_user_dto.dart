class TotalUserDTO {
  final int totalUsers;
  final int totalUserRegisterToday;

  TotalUserDTO({
    required this.totalUsers,
    required this.totalUserRegisterToday,
  });

  factory TotalUserDTO.fromJson(Map<String, dynamic> json) {
    return TotalUserDTO(
      totalUsers: json['totalUsers'],
      totalUserRegisterToday: json['totalUserRegisterToday'],
    );
  }
}
