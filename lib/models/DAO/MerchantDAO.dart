import 'dart:convert';

import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/DAO/BaseDAO.dart';
import '../../commons/constants/utils/base_api.dart';
import '../DTO/merchant_dto.dart';
import '../DTO/metadata_dto.dart';

class MerchantDAO extends BaseDAO {
  Future<MerchantDTO?> filterMerchantList({
    required String time,
    required int type,
    required int page,
    int? size,
    required int filterBy,
    required String value,
  }) async {
    // List<MerchantDTO> list = [];
    try {
      String url =
          'https://dev.vietqr.org/stt/api/mid/statistic?time=$time&type=$type&page=$page&size=${size ?? 20}&filterBy=$filterBy&value=$value';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        // return data['data']
        //     .map<MerchantDTO>((json) => MerchantDTO.fromJson(json))
        //     .toList();
        return MerchantDTO.fromJson(data['data']);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }
}
