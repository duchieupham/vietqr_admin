// To parse this JSON data, do
//
//     final callBackDto = callBackDtoFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';

List<CallBackDTO> callBackDtoFromJson(String str) => List<CallBackDTO>.from(
    json.decode(str).map((x) => CallBackDTO.fromJson(x)));

String callBackDtoToJson(List<CallBackDTO> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CallBackDTO {
  final int? status;
  final int? time;
  final String? bankId;
  final String? bankAccount;
  final String? amount;
  final String? transType;
  final String? traceId;
  final String? orderId;
  final String? sign;
  final String? referenceNumber;
  final String? id;
  final int? type;
  final String? content;
  final int? timePaid;
  final String? referenceId;

  CallBackDTO({
    this.status,
    this.time,
    this.bankId,
    this.bankAccount,
    this.amount,
    this.transType,
    this.traceId,
    this.orderId,
    this.sign,
    this.referenceNumber,
    this.id,
    this.type,
    this.content,
    this.timePaid,
    this.referenceId,
  });

  String get getContent {
    if (content != null && content!.isNotEmpty) {
      if (content!.contains('VQR')) {
        return 'VQRxxxxxxxxx';
      }
    }
    return '';
  }

  // (0: chờ thanh toán; 1: thành công; 2: đã huỷ)
  String get getStatus {
    if (status != null) {
      if (status == 1) {
        return 'Thành công';
      } else if (status == 0) {
        return 'Chờ thanh toán';
      } else if (status == 2) {
        return 'Đã huỷ';
      } else {
        return '';
      }
    }
    return '';
  }

  String get createdTime => TimeUtils.instance.formatTimeDateFromInt(time ?? 0);

  factory CallBackDTO.fromJson(Map<String, dynamic> json) => CallBackDTO(
        status: json["status"],
        time: json["time"],
        bankId: json["bankId"],
        bankAccount: json["bankAccount"],
        amount: json["amount"],
        transType: json["transType"],
        traceId: json["traceId"],
        orderId: json["orderId"],
        sign: json["sign"],
        referenceNumber: json["referenceNumber"],
        id: json["id"],
        type: json["type"],
        content: json["content"],
        timePaid: json["timePaid"],
        referenceId: json["referenceId"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "time": time,
        "bankId": bankId,
        "bankAccount": bankAccount,
        "amount": amount,
        "transType": transType,
        "traceId": traceId,
        "orderId": orderId,
        "sign": sign,
        "referenceNumber": referenceNumber,
        "id": id,
        "type": type,
        "content": content,
        "timePaid": timePaid,
        "referenceId": referenceId,
      };
}
