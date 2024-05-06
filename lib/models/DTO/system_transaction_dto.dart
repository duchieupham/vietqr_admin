class SystemTransactionDTO {
  final List<SystemTransactionData> data;
  final SysTransExtraData extraData;

  SystemTransactionDTO({required this.data, required this.extraData});

  factory SystemTransactionDTO.fromJson(Map<String, dynamic> json) {
    return SystemTransactionDTO(
      data: List<SystemTransactionData>.from(
          json['items'].map((x) => SystemTransactionData.fromJson(x))),
      extraData: SysTransExtraData.fromJson(json['extraData']),
    );
  }
}

class SystemTransactionData {
  final String time;
  final int credit;
  final int creCount;
  final int deCount;
  final int reCount;
  final int toCount;
  final int debit;
  final int recon;
  final int total;

  SystemTransactionData({
    required this.time,
    required this.credit,
    required this.creCount,
    required this.deCount,
    required this.reCount,
    required this.toCount,
    required this.debit,
    required this.recon,
    required this.total,
  });

  factory SystemTransactionData.fromJson(Map<String, dynamic> json) {
    return SystemTransactionData(
      time: json['time'],
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

class SysTransExtraData {
  final int creCountTotal;
  final int creditTotal;
  final int deCountTotal;
  final int debitTotal;
  final int recCountTotal;
  final int recTotal;
  final int totalCount;
  final int totalTrans;

  SysTransExtraData({
    required this.creCountTotal,
    required this.creditTotal,
    required this.deCountTotal,
    required this.debitTotal,
    required this.recCountTotal,
    required this.recTotal,
    required this.totalCount,
    required this.totalTrans,
  });

  factory SysTransExtraData.fromJson(Map<String, dynamic> json) {
    return SysTransExtraData(
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
