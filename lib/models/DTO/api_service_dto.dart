class ApiServiceDTO {
  final String id;
  final String ip;
  final int active;
  final String port;
  final String platform;
  final String url;
  final String suffix;
  final String accountCustomerId;
  final String systemUsername;
  final String systemPassword;
  final String customerUsername;
  final String customerPassword;
  final String merchant;
  const ApiServiceDTO(
      {this.id = '',
      this.active = 0,
      this.ip = '',
      this.platform = '',
      this.port = '',
      this.url = '',
      this.accountCustomerId = '',
      this.customerPassword = '',
      this.customerUsername = '',
      this.suffix = '',
      this.systemPassword = '',
      this.systemUsername = '',
      this.merchant = ''});

  factory ApiServiceDTO.fromJson(Map<String, dynamic> json) {
    return ApiServiceDTO(
      id: json['id'] ?? '',
      active: json['active'] ?? 0,
      ip: json['ip'] ?? '',
      platform: json['platform'] ?? '',
      port: json['port'] ?? '',
      url: json['url'] ?? '',
      accountCustomerId: json['accountCustomerId'] ?? '',
      customerPassword: json['customerPassword'] ?? '',
      customerUsername: json['customerUsername'] ?? '',
      suffix: json['suffix'] ?? '',
      systemPassword: json['systemPassword'] ?? '',
      systemUsername: json['systemUsername'] ?? '',
      merchant: json['merchant'] ?? '',
    );
  }
}
