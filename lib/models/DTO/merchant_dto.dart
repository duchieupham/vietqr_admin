class MerchantDTO {
  final int midId;
  final int credit;
  final int debit;
  final bool recon;
  final int total;

  MerchantDTO({
    required this.midId,
    required this.credit,
    required this.debit,
    required this.recon,
    required this.total,
  });

  factory MerchantDTO.fromJson(Map<String, dynamic> json) {
    return MerchantDTO(
      midId: json['midId'],
      credit: json['credit'],
      debit: json['debit'],
      recon: json['recon'],
      total: json['total'],
    );
  }
}
