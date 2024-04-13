class GenerateUserNamePassDto {
  final String username;
  final String password;
  const GenerateUserNamePassDto({this.username = '', this.password = ''});

  factory GenerateUserNamePassDto.fromJson(Map<String, dynamic> json) {
    return GenerateUserNamePassDto(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
