class KeyDTO {
  final String otp;
  final int duration;
  final int validFrom;
  final int validTo;
  final String key;

  KeyDTO(
      {required this.otp,
      required this.duration,
      required this.validFrom,
      required this.validTo,
      required this.key});

  factory KeyDTO.fromJson(Map<String, dynamic> json) {
    return KeyDTO(
        otp: json['otp'] ?? '',
        duration: json['duration'] ?? 0,
        validFrom: json['validFrom'] ?? 0,
        validTo: json['validTo'] ?? 0,
        key: json['key'] ?? '');
  }
}
