import 'dart:convert';

class AnnualFeeAfterDTO {
  List<AnnualItems> items;
  AnnualData extraData;

  AnnualFeeAfterDTO({required this.items, required this.extraData});

  factory AnnualFeeAfterDTO.fromJson(Map<String, dynamic> json) {
    return AnnualFeeAfterDTO(
      items: List<AnnualItems>.from(
          json['items'].map((x) => AnnualItems.fromJson(x))),
      extraData: AnnualData.fromJson(json['extraData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toJson())),
      'extraData': extraData.toJson(),
    };
  }
}

class AnnualItems {
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

  AnnualItems({
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

  factory AnnualItems.fromJson(Map<String, dynamic> json) {
    return AnnualItems(
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

class AnnualData {
  int transFee;
  int pendingFee;
  int completeFee;

  AnnualData(
      {required this.transFee,
      required this.pendingFee,
      required this.completeFee});

  factory AnnualData.fromJson(Map<String, dynamic> json) {
    return AnnualData(
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
