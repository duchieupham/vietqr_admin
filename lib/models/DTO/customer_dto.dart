class CustomerDTO {
  final String id;
  final String ip;
  final int active;
  final String port;
  final String platform;
  final String url;
  final String merchant;

  const CustomerDTO({
    this.id = '',
    this.active = 0,
    this.ip = '',
    this.platform = '',
    this.port = '',
    this.url = '',
    this.merchant = '',
  });

  factory CustomerDTO.fromJson(Map<String, dynamic> json) {
    return CustomerDTO(
      id: json['id'] ?? '',
      active: json['active'] ?? 0,
      ip: json['ip'] ?? '',
      platform: json['platform'] ?? '',
      port: json['port'] ?? '',
      url: json['url'] ?? '',
      merchant: json['merchant'] ?? '',
    );
  }
}
