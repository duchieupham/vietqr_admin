class ConnectDTO {
  final String id;
  final String ip;
  final int active;
  final String port;
  final String platform;
  final String url;
  const ConnectDTO(
      {this.id = '',
      this.active = 0,
      this.ip = '',
      this.platform = '',
      this.port = '',
      this.url = ''});

  factory ConnectDTO.fromJson(Map<String, dynamic> json) {
    return ConnectDTO(
      id: json['id'] ?? '',
      active: json['active'] ?? 0,
      ip: json['ip'] ?? '',
      platform: json['platform'] ?? '',
      port: json['port'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
