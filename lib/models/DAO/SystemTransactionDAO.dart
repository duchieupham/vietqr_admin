import 'dart:convert';

import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/DAO/BaseDAO.dart';
import 'package:http/http.dart' as http;
import 'package:vietqr_admin/models/DTO/system_transaction_dto.dart';
import '../../commons/constants/env/env_config.dart';
import '../../commons/constants/utils/base_api.dart';
import '../DTO/merchant_dto.dart';
import '../DTO/metadata_dto.dart';

class SysTemTransactionDAO extends BaseDAO {
  Future<SystemTransactionDTO?> filterSystemTransactionList({
    required String time,
    required int type,
    required int page,
    int? size,
    required int filterBy,
  }) async {
    try {
      String url =
          'https://dev.vietqr.org/stt/api/trans-admin/statistic?time=$time&filterBy=$filterBy&page=$page&size=${size ?? 20}';
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
        return SystemTransactionDTO.fromJson(data['data']);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }
}
