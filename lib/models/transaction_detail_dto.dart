import 'dart:ui';

import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class TransactionDetailDTO {
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
  final int status;
  final String sign;
  final String traceId;
  final int type;
  final String userBankName;
  final String nationalId;
  final String phoneAuthenticated;
  final bool sync;
  final String bankCode;
  final String bankShortName;
  final String bankName;
  final String imgId;
  final int flow;
  const TransactionDetailDTO(
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
      this.referenceNumber = '',
      this.userBankName = '',
      this.flow = 0,
      this.bankShortName = '',
      this.bankCode = '',
      this.imgId = '',
      this.phoneAuthenticated = '',
      this.nationalId = '',
      this.type = 0,
      this.bankName = '',
      this.sign = '',
      this.sync = false,
      this.traceId = ''});

  factory TransactionDetailDTO.fromJson(Map<String, dynamic> json) {
    return TransactionDetailDTO(
      id: json['id'] ?? '',
      status: json['status'] ?? 0,
      bankAccount: json['bankAccount'] ?? '',
      bankId: json['bankId'] ?? '',
      content: json['content'] ?? '',
      amount: json['amount'] ?? 0,
      transType: json['transType'] ?? '',
      timeCreated: json['timeCreated'] ?? 0,
      timePaid: json['timePaid'] ?? 0,
      orderId: json['orderId'] ?? '',
      referenceNumber: json['referenceNumber'] ?? '',
      userBankName: json['userBankName'] ?? '',
      flow: json['flow'] ?? 0,
      bankShortName: json['bankShortName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      imgId: json['imgId'] ?? '',
      phoneAuthenticated: json['phoneAuthenticated'] ?? '',
      nationalId: json['nationalId'] ?? '',
      type: json['type'] ?? 0,
      bankName: json['bankName'] ?? '',
      sign: json['sign'] ?? '',
      sync: json['sync'] ?? false,
      traceId: json['traceId'] ?? '',
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
    if (status == 0) {
      return AppColor.ORANGE;
    } else if (transType == 'C') {
      return AppColor.BLUE_TEXT;
    } else {
      return AppColor.RED_TEXT;
    }
  }

  String getTypeTrace() {
    if (type == 5) {
      return 'Giao dịch nạp tiền VQR vào hệ thống';
    } else if (type == 2) {
      return 'Giao dịch ngoài hệ thống VietQR';
    } else if (type == 4) {
      return 'Giao dịch đồng bộ RPA';
    } else {
      return 'Giao dịch từ hệ thống VietQR';
    }
  }
}
