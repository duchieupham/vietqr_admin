import 'dart:convert';

import 'package:vietqr_admin/models/DAO/BaseDAO.dart';

import '../../commons/constants/utils/base_api.dart';
import '../../commons/constants/utils/log.dart';
import '../DTO/metadata_dto.dart';
import '../DTO/user_recharge_dto.dart';

class UserRechargeDAO extends BaseDAO {
  Future<UserRechargeDTO?> filterRechargeList({
    required String from,
    required String to,
    required int type,
    required int page,
    int? size,
    required int filterBy,
    required String value,
  }) async {
    // List<MerchantDTO> list = [];
    try {
      String url =
          'https://api.vietqr.org/vqr/api/admin/transaction-wallet?page=$page&size=${size ?? 20}&from=$from&to=$to&filterBy=$filterBy&type=$type&value=$value';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        return UserRechargeDTO.fromJson(data['data']);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }
}
