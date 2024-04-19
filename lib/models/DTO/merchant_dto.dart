class MerchantDTO {
  final List<MerchantData> data;
  final ExtraData extraData;

  MerchantDTO({required this.data, required this.extraData});

  factory MerchantDTO.fromJson(Map<String, dynamic> json) {
    List<MerchantData> merchantDataList = [];
    if (json['items'] != null && json['items'].isNotEmpty) {
      merchantDataList = List<MerchantData>.from(
          json['items'].map((x) => MerchantData.fromJson(x)));
    }

    return MerchantDTO(
      data: merchantDataList,
      extraData: ExtraData.fromJson(json['extraData']),
    );
  }
}

class MerchantData {
  String? mid;
  String? name;
  String? vso;
  String? nationalId;
  int? credit;
  int? creCount;
  int? deCount;
  int? reCount;
  int? toCount;
  int? debit;
  int? recon;
  int? total;

  MerchantData({
    this.mid,
    this.name,
    this.vso,
    this.nationalId,
    this.credit,
    this.creCount,
    this.deCount,
    this.reCount,
    this.toCount,
    this.debit,
    this.recon,
    this.total,
  });

  factory MerchantData.fromJson(Map<String, dynamic> json) {
    return MerchantData(
      mid: json['mid'],
      name: json['name'],
      vso: json['vso'],
      nationalId: json['nationalId'],
      credit: json['credit'],
      creCount: json['creCount'],
      deCount: json['deCount'],
      reCount: json['reCount'],
      toCount: json['toCount'],
      debit: json['debit'],
      recon: json['recon'],
      total: json['total'],
    );
  }
}

class ExtraData {
  int creCountTotal;
  int creditTotal;
  int deCountTotal;
  int debitTotal;
  int recCountTotal;
  int recTotal;
  int totalCount;
  int totalTrans;

  ExtraData({
    required this.creCountTotal,
    required this.creditTotal,
    required this.deCountTotal,
    required this.debitTotal,
    required this.recCountTotal,
    required this.recTotal,
    required this.totalCount,
    required this.totalTrans,
  });

  factory ExtraData.fromJson(Map<String, dynamic> json) {
    return ExtraData(
      creCountTotal: json['creCountTotal'] ?? 0,
      creditTotal: json['creditTotal'] ?? 0,
      deCountTotal: json['deCountTotal'] ?? 0,
      debitTotal: json['debitTotal'] ?? 0,
      recCountTotal: json['recCountTotal'] ?? 0,
      recTotal: json['recTotal'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalTrans: json['totalTrans'] ?? 0,
    );
  }
}
