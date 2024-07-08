// class ConnectDTO {
//   final String id;
//   final String ip;
//   final int active;
//   final String merchant;
//   final String port;
//   final String platform;
//   final String url;

//   const ConnectDTO(
//       {this.id = '',
//       this.active = 0,
//       this.ip = '',
//       this.platform = '',
//       this.merchant = '',
//       this.port = '',
//       this.url = ''});

//   factory ConnectDTO.fromJson(Map<String, dynamic> json) {
//     return ConnectDTO(
//       id: json['id'] ?? '',
//       active: json['active'] ?? 0,
//       ip: json['ip'] ?? '',
//       merchant: json['merchant'] ?? '',
//       platform: json['platform'] ?? '',
//       port: json['port'] ?? '',
//       url: json['url'] ?? '',
//     );
//   }
// }

class MetaData {
  final int page;
  final int size;
  final int totalPage;
  final int totalElement;

  const MetaData({
    this.page = 0,
    this.size = 0,
    this.totalPage = 0,
    this.totalElement = 0,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      page: json['page'] ?? 0,
      size: json['size'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
      totalElement: json['totalElement'] ?? 0,
    );
  }
}

class ConnectDTO {
  final String id;
  final String ip;
  final int active;
  final String merchant;
  final String port;
  final String platform;
  final String url;
  final MetaData metadata;

  const ConnectDTO({
    this.id = '',
    this.active = 0,
    this.ip = '',
    this.platform = '',
    this.merchant = '',
    this.port = '',
    this.url = '',
    required this.metadata,
  });

  factory ConnectDTO.fromJson(Map<String, dynamic> json, MetaData metadata) {
    return ConnectDTO(
      id: json['id'] ?? '',
      active: json['active'] ?? 0,
      ip: json['ip'] ?? '',
      merchant: json['merchant'] ?? '',
      platform: json['platform'] ?? '',
      port: json['port'] ?? '',
      url: json['url'] ?? '',
      metadata: metadata,
    );
  }
}
