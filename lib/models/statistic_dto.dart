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
      totalCashIn: json['totalCashIn'] ?? '',
      totalCashOut: json['totalCashOut'] ?? '',
      totalTransC: json['totalTransC'] ?? '',
      totalTransD: json['totalTransD'] ?? '',
      totalTrans: json['totalTrans'] ?? '',
    );
  }
}
