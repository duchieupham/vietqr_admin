
class ServiceItemDTO {
  String itemId;
  String content;
  String unit;
  String time;
  int quantity;
  int amount;
  int totalAmount;
  double vat;
  int vatAmount;
  int amountAfterVat;
  int type;

  ServiceItemDTO({
    required this.itemId,
    required this.content,
    required this.time,
    required this.unit,
    required this.quantity,
    required this.amount,
    required this.totalAmount,
    required this.vat,
    required this.vatAmount,
    required this.amountAfterVat,
    required this.type,
  });

  factory ServiceItemDTO.fromJson(Map<String, dynamic> json) {
    return ServiceItemDTO(
      itemId: json['itemId'],
      content: json['content'],
      time: json['time'],
      unit: json['unit'],
      quantity: json['quantity'],
      amount: json['amount'],
      totalAmount: json['totalAmount'],
      vat: json['vat'].toDouble(),
      vatAmount: json['vatAmount'],
      amountAfterVat: json['amountAfterVat'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'content': content,
      'unit': unit,
      'quantity': quantity,
      'amount': amount,
      'totalAmount': totalAmount,
      'vat': vat,
      'vatAmount': vatAmount,
      'amountAfterVat': amountAfterVat,
      'type': type,
    };
  }
}
