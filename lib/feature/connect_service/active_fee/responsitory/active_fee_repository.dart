import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/active_fee_dto.dart';

class ActiveFeeRepository {
  const ActiveFeeRepository();

  Future<List<ActiveFeeDTO>> getServicePackList() async {
    List<ActiveFeeDTO> result = [];
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}admin/service-fee';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = data
            .map<ActiveFeeDTO>((json) => ActiveFeeDTO.fromJson(json))
            .toList();
        return result;
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }
}
