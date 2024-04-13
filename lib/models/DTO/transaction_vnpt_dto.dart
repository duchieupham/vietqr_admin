import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class TransactionVNPTDTO {
  final String fullName;
  final String userId;
  final String phoneNo;
  final String amount;
  final String billNumber;
  final int paymentMethod;
  final int timeCreated;
  final int timePaid;
  final int status;
  final String phoneNorc;
  final String id;
  final String content;

  const TransactionVNPTDTO(
      {this.id = '',
      this.fullName = '',
      this.status = 0,
      this.userId = '',
      this.paymentMethod = 0,
      this.phoneNo = '',
      this.timePaid = 0,
      this.timeCreated = 0,
      this.content = '',
      this.amount = '',
      this.billNumber = '',
      this.phoneNorc = ''});

  factory TransactionVNPTDTO.fromJson(Map<String, dynamic> json) {
    return TransactionVNPTDTO(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      status: json['status'] ?? 0,
      userId: json['userId'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 0,
      phoneNo: json['phoneNo'] ?? '',
      timePaid: json['timePaid'] ?? 0,
      timeCreated: json['timeCreated'] ?? 0,
      content: json['content'] ?? '',
      amount: json['amount'] ?? '',
      billNumber: json['billNumber'] ?? '',
      phoneNorc: json['phoneNorc'] ?? '',
    );
  }

  Color getStatusColor() {
    if (status == 0) {
      return AppColor.ORANGE;
    } else if (status == 1) {
      return AppColor.BLUE_TEXT;
    } else if (status == 3) {
      return AppColor.RED_TEXT;
    } else {
      return AppColor.BLACK;
    }
  }

  String getStatusText() {
    if (status == 0) {
      return 'Chờ thanh toán';
    } else if (status == 1) {
      return 'Thành công';
    } else if (status == 3) {
      return 'Thất bại';
    } else {
      return 'Đã huỷ';
    }
  }
}
