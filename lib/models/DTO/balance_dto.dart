class BalanceDTO {
  final String cashBalance;
  final String bonusBalance;
  final String holdingBalance;
  final String availableBalance;

  BalanceDTO({
    this.cashBalance = '',
    this.bonusBalance = '',
    this.holdingBalance = '',
    this.availableBalance = '',
  });

  factory BalanceDTO.fromJson(Map<String, dynamic> json) {
    return BalanceDTO(
      cashBalance: json['cashBalance'] ?? '',
      bonusBalance: json['bonusBalance'] ?? '',
      holdingBalance: json['holdingBalance'] ?? '',
      availableBalance: json['availableBalance'] ?? '',
    );
  }
}
