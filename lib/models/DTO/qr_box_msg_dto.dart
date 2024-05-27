class QRBoxMsgDTO {
  final String homePage;
  final String message1;
  final String message2;

  QRBoxMsgDTO({
    required this.homePage,
    required this.message1,
    required this.message2,
  });

  factory QRBoxMsgDTO.fromJson(Map<String, dynamic> json) {
    return QRBoxMsgDTO(
      homePage: json['homePage'],
      message1: json['message1'],
      message2: json['message2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'homePage': homePage,
      'message1': message1,
      'message2': message2,
    };
  }
}
