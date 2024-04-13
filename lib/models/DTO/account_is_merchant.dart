class AccountIsMerchantDTO {
  final String customerSyncId;
  final String merchantName;
  final String ip;
  final String port;
  final String callBackVietQRAPI;
  final bool isActive;
  final String url;
  final bool? isMasterMerchant;
  final String accountId;
  final String refId;
  final String platform;

  const AccountIsMerchantDTO({
     this.customerSyncId = '',
    this.merchantName ='',
     this.ip ='',
     this.port ='',
     this.callBackVietQRAPI = '',
     this.isActive = false,
     this.url = '',
     this.isMasterMerchant,
    this.accountId ='',
    this.platform = '', this.refId = '',
  });

  factory AccountIsMerchantDTO.fromJson(Map<String, dynamic> json) {
    return AccountIsMerchantDTO(
      customerSyncId: json['customerSyncId'] ?? '',
      merchantName: json['merchantName'] ?? '',
      ip: json['ip'] ?? '',
      port: json['port'] ?? '',
      callBackVietQRAPI: json['callBackVietQRAPI'] ?? '',
      isActive: json['isActive'] ?? false,
      url: json['url'] ?? '',
      isMasterMerchant: json['isMasterMerchant'],
      accountId: json['accountId'] ?? '',
      refId: json['refId'] ?? '',
      platform: json['platform'] ?? '',
    );
  }


}
