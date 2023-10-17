class WebHookDTO {
  final String partnerName;
  final String webhook;
  final String description;
  final bool active;
  final String id;
  const WebHookDTO(
      {this.id = '',
      this.active = false,
      this.description = '',
      this.partnerName = '',
      this.webhook = ''});

  factory WebHookDTO.fromJson(Map<String, dynamic> json) {
    return WebHookDTO(
      id: json['id'] ?? '',
      active: json['active'] ?? false,
      description: json['description'] ?? '',
      partnerName: json['partnerName'] ?? '',
      webhook: json['webhook'] ?? '',
    );
  }
}
