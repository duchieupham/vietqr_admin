import 'package:vietqr_admin/models/DTO/key_dto.dart';

class ResponseMessageDTO {
  final String status;
  final String message;
  const ResponseMessageDTO({this.status = '', this.message = ''});

  factory ResponseMessageDTO.fromJson(Map<String, dynamic> json) {
    return ResponseMessageDTO(
      status: json['status'] ?? '',
      message: json['message'] ?? 0,
    );
  }
}

class ResponseDataDTO {
  final String status;
  final KeyDTO data;

  const ResponseDataDTO({this.status = '', required this.data});

  factory ResponseDataDTO.fromJson(Map<String, dynamic> json) {
    final KeyDTO data = KeyDTO.fromJson(json['data']);
    return ResponseDataDTO(
      status: json['status'] ?? '',
      data: data,
    );
  }
}
