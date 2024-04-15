import 'dart:convert';

import 'package:vietqr_admin/models/DAO/BaseDAO.dart';
import 'package:vietqr_admin/models/DTO/annual_fee_after_dto.dart';
import 'package:vietqr_admin/models/DTO/service_fee_dto.dart';

import '../../commons/constants/utils/base_api.dart';
import '../../commons/constants/utils/log.dart';
import '../DTO/metadata_dto.dart';

class AnnualDAO extends BaseDAO {
  Future<AnnualFeeAfterDTO?> filterAnnualFeeAfterList({
    required String time,
    required int page,
    int? size,
    required int filterBy,
    required String value,
  }) async {
    // List<MerchantDTO> list = [];
    try {
      String url =
          'https://dev.vietqr.org/vqr/mock/api/annual-fee/statistic?page=$page&size=${size ?? 20}&filterBy=$filterBy&value=$value&time=$time';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        return AnnualFeeAfterDTO.fromJson(data['data']);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }
}
