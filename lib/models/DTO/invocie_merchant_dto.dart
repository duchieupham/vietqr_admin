
class MerchantDTO {
  List<MerchantItem> items;

  MerchantDTO({required this.items});

  factory MerchantDTO.fromJson(Map<String, dynamic> json) {
    return MerchantDTO(
      items: List<MerchantItem>.from(
          json['data'].map((x) => MerchantItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': List<dynamic>.from(items.map((x) => x.toJson())),
    };
  }
}

class MerchantItem {
  String merchantId;
  String merchantName;
  String vsoCode;
  int numberOfBank;
  String platform;

  MerchantItem({
    required this.merchantId,
    required this.merchantName,
    required this.vsoCode,
    required this.numberOfBank,
    required this.platform,
  });

  factory MerchantItem.fromJson(Map<String, dynamic> json) {
    return MerchantItem(
      merchantId: json['merchantId'],
      merchantName: json['merchantName'],
      vsoCode: json['vsoCode'],
      numberOfBank: json['numberOfBank'],
      platform: json['platform'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'merchantName': merchantName,
      'vsoCode': vsoCode,
      'numberOfBank': numberOfBank,
      'platform': platform,
    };
  }
}
