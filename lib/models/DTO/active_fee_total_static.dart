class ActiveFeeStaticDto {
  final int totalTrans;
  final int totalPayment;
  final int totalPaymentUnpaid;
  final int totalPaymentPaid;

  const ActiveFeeStaticDto({
    this.totalTrans = 0,
    this.totalPayment = 0,
    this.totalPaymentUnpaid = 0,
    this.totalPaymentPaid = 0,
  });

  factory ActiveFeeStaticDto.fromJson(Map<String, dynamic> json) {
    return ActiveFeeStaticDto(
      totalTrans: json['totalTrans'] ?? 0,
      totalPayment: json['totalPayment'] ?? 0,
      totalPaymentUnpaid: json['totalPaymentUnpaid'] ?? 0,
      totalPaymentPaid: json['totalPaymentPaid'] ?? 0,
    );
  }
}
