class StatisticDTO {
  final int totalCashIn;
  final int totalCashOut;
  final int totalTransC;
  final int totalTransD;
  final int totalTrans;

  const StatisticDTO({
    this.totalCashIn = 0,
    this.totalCashOut = 0,
    this.totalTransC = 0,
    this.totalTransD = 0,
    this.totalTrans = 0,
  });

  factory StatisticDTO.fromJson(Map<String, dynamic> json) {
    return StatisticDTO(
      totalCashIn: json['totalCashIn'] ?? 0,
      totalCashOut: json['totalCashOut'] ?? 0,
      totalTransC: json['totalTransC'] ?? 0,
      totalTransD: json['totalTransD'] ?? 0,
      totalTrans: json['totalTrans'] ?? 0,
    );
  }
}
