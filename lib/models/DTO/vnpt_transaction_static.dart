class VNPTTransactionStaticDTO {
  final int totalTrans;
  final int totalAmount;

  const VNPTTransactionStaticDTO({
    this.totalTrans = 0,
    this.totalAmount = 0,
  });

  factory VNPTTransactionStaticDTO.fromJson(Map<String, dynamic> json) {
    return VNPTTransactionStaticDTO(
      totalTrans: json['totalTrans'] ?? 0,
      totalAmount: json['totalAmount'] ?? 0,
    );
  }
}
