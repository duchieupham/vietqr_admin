import 'dart:convert';

import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/DAO/BaseDAO.dart';
import 'package:http/http.dart' as http;
import '../../commons/constants/env/env_config.dart';
import '../../commons/constants/utils/base_api.dart';
import '../DTO/merchant_dto.dart';

class MerchantDAO extends BaseDAO {
  Future<MerchantDTO?> filterMerchantList(
      {required String time,
      required int type,
      required String page,
      required String size}) async {
    try {
      String url =
          'https://dev.vietqr.org/vqr/mock/api/mid/statistic?time=$time&type=$type&page=$page&size=$size';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return MerchantDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }
}
