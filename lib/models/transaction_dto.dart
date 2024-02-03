import 'dart:ui';

import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class TransactionDTO {
  final String id;
  final String orderId;
  final String referenceNumber;
  final String bankId;
  final String bankAccount;
  final int amount;
  final String transType;
  final int timePaid;
  final int timeCreated;
  final String content;
  final int type;
  final int status;
  const TransactionDTO(
      {this.id = '',
      this.status = 0,
      this.bankAccount = '',
      this.bankId = '',
      this.content = '',
      this.amount = 0,
      this.transType = '',
      this.timeCreated = 0,
      this.timePaid = 0,
      this.orderId = '',
      this.type = 0,
      this.referenceNumber = ''});

  factory TransactionDTO.fromJson(Map<String, dynamic> json) {
    return TransactionDTO(
      id: json['id'] ?? '',
      status: json['status'] ?? 0,
      bankAccount: json['bankAccount'] ?? '',
      bankId: json['bankId'] ?? '',
      content: json['content'] ?? '',
      amount: json['amount'] ?? 0,
      transType: json['transType'] ?? '',
      type: json['type'] ?? 0,
      timeCreated: json['timeCreated'] ?? 0,
      timePaid: json['timePaid'] ?? 0,
      orderId: json['orderId'] ?? '',
      referenceNumber: json['referenceNumber'] ?? '',
    );
  }

  String getStatus() {
    if (status == 0) {
      return 'Chờ thanh toán';
    } else if (status == 1) {
      return 'Thành công';
    } else {
      return 'Đã huỷ';
    }
  }

  Color getStatusColor() {
    if (status == 0) {
      return AppColor.ORANGE;
    } else if (status == 1) {
      return AppColor.BLUE_TEXT;
    } else {
      return AppColor.BLACK;
    }
  }

  Color getAmountColor() {
    // if (status == 0) {
    //   return DefaultTheme.ORANGE;
    // } else

    if (transType == 'C') {
      if (status == 0) {
        return AppColor.ORANGE;
      } else if (status == 1) {
        if (type == 0 || type == 1 || type == 4 || type == 5) {
          return AppColor.GREEN;
        } else if (type == 2) {
          return AppColor.BLUE_TEXT;
        }
        return AppColor.BLUE_TEXT;
      } else {
        return AppColor.GREY_TEXT;
      }
    } else {
      return AppColor.RED_TEXT;
    }
  }
}
