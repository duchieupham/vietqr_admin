class ServicePackDTO {
  final SubServicePackDTO? item;
  final List<SubServicePackDTO>? subItems;
  const ServicePackDTO({
    this.item,
    this.subItems,
  });

  factory ServicePackDTO.fromJson(Map<String, dynamic> json) {
    return ServicePackDTO(
      item: SubServicePackDTO.fromJson(json['item']),
      subItems: json['subItems']
          .map<SubServicePackDTO>((json) => SubServicePackDTO.fromJson(json))
          .toList(),
    );
  }
}

class SubServicePackDTO {
  final String shortName;
  final String name;
  final String description;
  final int activeFee;
  final int annualFee;
  final int monthlyCycle;
  final int transFee;
  final double percentFee;
  final bool sub;
  final bool active;
  final String refId;
  final String id;
  final double vat;
  final int countingTransType;
  const SubServicePackDTO(
      {this.name = '',
      this.description = '',
      this.activeFee = 0,
      this.annualFee = 0,
      this.monthlyCycle = 0,
      this.percentFee = 0.0,
      this.refId = '',
      this.shortName = '',
      this.sub = false,
      this.active = false,
      this.id = '',
      this.transFee = 0,
      this.countingTransType = 0,
      this.vat = 0.0});

  factory SubServicePackDTO.fromJson(Map<String, dynamic> json) {
    return SubServicePackDTO(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      activeFee: json['activeFee'] ?? 0,
      annualFee: json['annualFee'] ?? 0,
      monthlyCycle: json['monthlyCycle'] ?? 0,
      percentFee: json['percentFee'] ?? 0.0,
      vat: json['vat'] ?? 0.0,
      refId: json['refId'] ?? '',
      shortName: json['shortName'] ?? '',
      sub: json['sub'] ?? false,
      transFee: json['transFee'] ?? 0,
      active: json['active'] ?? false,
      id: json['id'] ?? '',
      countingTransType: json['countingTransType'] ?? 0,
    );
  }
}
