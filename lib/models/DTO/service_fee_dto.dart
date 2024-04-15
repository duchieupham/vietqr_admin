import 'dart:convert';

class ServiceFeeDTO {
  List<ServiceItems> items;
  ServiceData extraData;

  ServiceFeeDTO({required this.items, required this.extraData});

  factory ServiceFeeDTO.fromJson(Map<String, dynamic> json) {
    return ServiceFeeDTO(
      items: List<ServiceItems>.from(
          json['items'].map((x) => ServiceItems.fromJson(x))),
      extraData: ServiceData.fromJson(json['extraData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toJson())),
      'extraData': extraData.toJson(),
    };
  }
}

class ServiceItems {
  String vso;
  int timePaid;
  String mid;
  String name;
  String nationalId;
  int fee;
  // int service;
  List<String> packageFeeCode;
  List<String> packageFeeName;
  List<String> platformPackage;
  int status;

  ServiceItems({
    required this.vso,
    required this.timePaid,
    required this.mid,
    required this.name,
    required this.nationalId,
    required this.fee,
    // required this.service,
    required this.packageFeeCode,
    required this.packageFeeName,
    required this.platformPackage,
    required this.status,
  });

  factory ServiceItems.fromJson(Map<String, dynamic> json) {
    return ServiceItems(
      vso: json['vso'],
      timePaid: json['timePaid'],
      mid: json['mid'],
      name: json['name'],
      nationalId: json['nationalId'],
      fee: json['fee'],
      // service: json['service'],
      packageFeeCode: List<String>.from(json['packageFeeCode']),
      packageFeeName: List<String>.from(json['packageFeeName']),
      platformPackage: List<String>.from(json['platformPackage']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vso': vso,
      'timePaid': timePaid,
      'mid': mid,
      'name': name,
      'nationalId': nationalId,
      'fee': fee,
      // 'service': service,
      'packageFeeCode': List<dynamic>.from(packageFeeCode.map((x) => x)),
      'packageFeeName': List<dynamic>.from(packageFeeName.map((x) => x)),
      'platformPackage': List<dynamic>.from(platformPackage.map((x) => x)),
      'status': status,
    };
  }
}

class ServiceData {
  int transFee;
  int pendingFee;
  int completeFee;

  ServiceData(
      {required this.transFee,
      required this.pendingFee,
      required this.completeFee});

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      transFee: json['transFee'],
      pendingFee: json['pendingFee'],
      completeFee: json['completeFee'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transFee': transFee,
      'pendingFee': pendingFee,
      'completeFee': completeFee,
    };
  }
}
