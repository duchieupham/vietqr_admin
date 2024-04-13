class TransactionLogDTO {
  final String id;
  final String transactionId;
  final String status;
  final String message;
  final String urlCallback;
  final int time;

  const TransactionLogDTO({
    this.id = '',
    this.transactionId = '',
    this.status = '',
    this.urlCallback = '',
    this.time = 0,
    this.message = '',
  });

  factory TransactionLogDTO.fromJson(Map<String, dynamic> json) {
    return TransactionLogDTO(
      id: json['id'] ?? '',
      transactionId: json['transactionId'] ?? '',
      status: json['status'] ?? '',
      urlCallback: json['urlCallback'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? 0,
    );
  }
}
