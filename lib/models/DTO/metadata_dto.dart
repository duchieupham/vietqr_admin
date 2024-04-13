class MetaDataDTO {
  int? page;
  int? size;
  int? total;
  int? totalElement;

  MetaDataDTO({this.page, this.size, this.total, this.totalElement});

  factory MetaDataDTO.fromJson(dynamic json) {
    return MetaDataDTO(
      page: json['page'],
      size: json['size'],
      total: json['totalPage'],
      totalElement: json['totalElement'],
    );
  }
}
