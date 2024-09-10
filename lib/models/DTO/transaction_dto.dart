import 'dart:ui';

import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class TransactionDTO {
  List<TransactionItem> items;

  TransactionDTO({
    required this.items,
  });

  factory TransactionDTO.fromJson(Map<String, dynamic> json) {
    return TransactionDTO(
      items: List<TransactionItem>.from(
          json['items'].map((x) => TransactionItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toJson())),
    };
  }
}

class TransactionItem {
  final String bankId;
  final String bankAccount;
  final String bankShortName;
  final int amount;
  final String userBankName;
  final int timePaid;
  final String referenceNumber;
  final String orderId;
  final String terminalCode;
  final String transType;
  final int timeCreated;
  final int status;
  final String note;
  final String id;
  final int type;
  final String content;

  TransactionItem(
      {required this.bankId,
      required this.bankAccount,
      required this.bankShortName,
      required this.amount,
      required this.userBankName,
      required this.timePaid,
      required this.referenceNumber,
      required this.orderId,
      required this.terminalCode,
      required this.transType,
      required this.timeCreated,
      required this.status,
      required this.note,
      required this.id,
      required this.type,
      required this.content});

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      bankId: json['bankId'],
      bankAccount: json['bankAccount'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      amount: json['amount'],
      userBankName: json['userBankName'] ?? '',
      timePaid: json['timePaid'],
      referenceNumber: json['referenceNumber'],
      orderId: json['orderId'] ?? '',
      terminalCode: json['terminalCode'] ?? '',
      transType: json['transType'],
      timeCreated: json['timeCreated'],
      status: json['status'],
      note: json['note'],
      id: json['id'],
      type: json['type'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bankId'] = bankId;
    data['bankAccount'] = bankAccount;
    data['bankShortName'] = bankShortName;
    data['amount'] = amount;
    data['userBankName'] = userBankName;
    data['timePaid'] = timePaid;
    data['referenceNumber'] = referenceNumber;
    data['orderId'] = orderId;
    data['terminalCode'] = terminalCode;
    data['transType'] = transType;
    data['timeCreated'] = timeCreated;
    data['status'] = status;
    data['note'] = note;
    data['id'] = id;
    data['type'] = type;
    data['content'] = content;
    return data;
  }

  TransactionItem copyWith({
    String? bankId,
    String? bankAccount,
    String? bankShortName,
    int? amount,
    String? userBankName,
    int? timePaid,
    String? referenceNumber,
    String? orderId,
    String? terminalCode,
    String? transType,
    int? timeCreated,
    int? status,
    String? note,
    String? id,
    int? type,
    String? content,
  }) {
    return TransactionItem(
      bankId: bankId ?? this.bankId,
      bankAccount: bankAccount ?? this.bankAccount,
      bankShortName: bankShortName ?? this.bankShortName,
      amount: amount ?? this.amount,
      userBankName: userBankName ?? this.userBankName,
      timePaid: timePaid ?? this.timePaid,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      orderId: orderId ?? this.orderId,
      terminalCode: terminalCode ?? this.terminalCode,
      transType: transType ?? this.transType,
      timeCreated: timeCreated ?? this.timeCreated,
      status: status ?? this.status,
      note: note ?? this.note,
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
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

// class TransactionDTO {
//   final String id;
//   final String orderId;
//   final String referenceNumber;
//   final String bankId;
//   final String bankAccount;
//   final int amount;
//   final String transType;
//   final int timePaid;
//   final int timeCreated;
//   final String content;
//   final int type;
//   final int status;
//   const TransactionDTO(
//       {this.id = '',
//       this.status = 0,
//       this.bankAccount = '',
//       this.bankId = '',
//       this.content = '',
//       this.amount = 0,
//       this.transType = '',
//       this.timeCreated = 0,
//       this.timePaid = 0,
//       this.orderId = '',
//       this.type = 0,
//       this.referenceNumber = ''});

//   factory TransactionDTO.fromJson(Map<String, dynamic> json) {
//     return TransactionDTO(
//       id: json['id'] ?? '',
//       status: json['status'] ?? 0,
//       bankAccount: json['bankAccount'] ?? '',
//       bankId: json['bankId'] ?? '',
//       content: json['content'] ?? '',
//       amount: json['amount'] ?? 0,
//       transType: json['transType'] ?? '',
//       type: json['type'] ?? 0,
//       timeCreated: json['timeCreated'] ?? 0,
//       timePaid: json['timePaid'] ?? 0,
//       orderId: json['orderId'] ?? '',
//       referenceNumber: json['referenceNumber'] ?? '',
//     );
//   }

//   String getStatus() {
//     if (status == 0) {
//       return 'Chờ thanh toán';
//     } else if (status == 1) {
//       return 'Thành công';
//     } else {
//       return 'Đã huỷ';
//     }
//   }

//   Color getStatusColor() {
//     if (status == 0) {
//       return AppColor.ORANGE;
//     } else if (status == 1) {
//       return AppColor.BLUE_TEXT;
//     } else {
//       return AppColor.BLACK;
//     }
//   }

//   Color getAmountColor() {
//     // if (status == 0) {
//     //   return DefaultTheme.ORANGE;
//     // } else

//     if (transType == 'C') {
//       if (status == 0) {
//         return AppColor.ORANGE;
//       } else if (status == 1) {
//         if (type == 0 || type == 1 || type == 4 || type == 5) {
//           return AppColor.GREEN;
//         } else if (type == 2) {
//           return AppColor.BLUE_TEXT;
//         }
//         return AppColor.BLUE_TEXT;
//       } else {
//         return AppColor.GREY_TEXT;
//       }
//     } else {
//       return AppColor.RED_TEXT;
//     }
//   }
// }
