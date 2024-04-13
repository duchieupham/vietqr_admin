class SynthesisReportDTO {
  final String time;

  final int totalTrans;
  final int totalAmount;
  final int totalTransC;
  final int totalTransD;
  final int totalCredit;
  final int totalDebit;

  const SynthesisReportDTO(
      {this.time = '',
      this.totalAmount = 0,
      this.totalCredit = 0,
      this.totalDebit = 0,
      this.totalTrans = 0,
      this.totalTransC = 0,
      this.totalTransD = 0});

  factory SynthesisReportDTO.fromJson(Map<String, dynamic> json) {
    return SynthesisReportDTO(
      time: json['time'] ?? 'false',
      totalAmount: json['totalAmount'] ?? 0,
      totalCredit: json['totalCredit'] ?? 0,
      totalDebit: json['totalDebit'] ?? 0,
      totalTrans: json['totalTrans'] ?? 0,
      totalTransC: json['totalTransC'] ?? 0,
      totalTransD: json['totalTransD'] ?? 0,
    );
  }
}
