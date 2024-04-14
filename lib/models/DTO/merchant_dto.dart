class MerchantDTO {
  final List<MerchantData> data;
  final ExtraData extraData;

  MerchantDTO({required this.data, required this.extraData});

  factory MerchantDTO.fromJson(Map<String, dynamic> json) {
    return MerchantDTO(
      data: List<MerchantData>.from(
          json['items'].map((x) => MerchantData.fromJson(x))),
      extraData: ExtraData.fromJson(json['extraData']),
    );
  }
}

class MerchantData {
  int mid;
  String name;
  String vso;
  String nationalId;
  int credit;
  int creCount;
  int deCount;
  int reCount;
  int toCount;
  int debit;
  int recon;
  int total;

  MerchantData({
    required this.mid,
    required this.name,
    required this.vso,
    required this.nationalId,
    required this.credit,
    required this.creCount,
    required this.deCount,
    required this.reCount,
    required this.toCount,
    required this.debit,
    required this.recon,
    required this.total,
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
      creCountTotal: json['creCountTotal'],
      creditTotal: json['creditTotal'],
      deCountTotal: json['deCountTotal'],
      debitTotal: json['debitTotal'],
      recCountTotal: json['recCountTotal'],
      recTotal: json['recTotal'],
      totalCount: json['totalCount'],
      totalTrans: json['totalTrans'],
    );
  }
}
