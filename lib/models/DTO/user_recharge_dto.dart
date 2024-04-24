import 'dart:convert';

class UserRechargeDTO {
  final List<RechargeItem> items;
  final RechargeExtra extraData;

  UserRechargeDTO({
    required this.items,
    required this.extraData,
  });

  factory UserRechargeDTO.fromJson(Map<String, dynamic> json) {
    return UserRechargeDTO(
      items: List<RechargeItem>.from(
          json['items'].map((x) => RechargeItem.fromJson(x))),
      extraData: RechargeExtra.fromJson(json['extraData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toJson())),
      'extraData': extraData.toJson(),
    };
  }
}

class RechargeItem {
  final String id;
  final int amount;
  final String billNumber;
  final int status;
  final int timeCreated;
  final int timePaid;
  final String transType;
  final int paymentType;
  final String additionData;
  final String additionData2;
  final String userId;
  final String fullName;
  final String phoneNo;

  RechargeItem({
    required this.id,
    required this.amount,
    required this.billNumber,
    required this.status,
    required this.timeCreated,
    required this.timePaid,
    required this.transType,
    required this.paymentType,
    required this.additionData,
    required this.additionData2,
    required this.userId,
    required this.fullName,
    required this.phoneNo,
  });

  factory RechargeItem.fromJson(Map<String, dynamic> json) {
    return RechargeItem(
      id: json['id'],
      amount: json['amount'],
      billNumber: json['billNumber'],
      status: json['status'],
      timeCreated: json['timeCreated'],
      timePaid: json['timePaid'],
      transType: json['transType'],
      paymentType: json['paymentType'],
      additionData: json['additionData'],
      additionData2: json['additionData2'],
      userId: json['userId'],
      fullName: json['fullName'],
      phoneNo: json['phoneNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'billNumber': billNumber,
      'status': status,
      'timeCreated': timeCreated,
      'timePaid': timePaid,
      'transType': transType,
      'paymentType': paymentType,
      'additionData': additionData,
      'additionData2': additionData2,
      'userId': userId,
      'fullName': fullName,
      'phoneNo': phoneNo,
    };
  }
}

class RechargeExtra {
  final String time;
  final int total;

  RechargeExtra({
    required this.time,
    required this.total,
  });

  factory RechargeExtra.fromJson(Map<String, dynamic> json) {
    return RechargeExtra(
      time: json['time'],
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'total': total,
    };
  }
}
