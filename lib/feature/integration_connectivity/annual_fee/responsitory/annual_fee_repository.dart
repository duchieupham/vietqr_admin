import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/annual_fee_dto.dart';

class AnnualFeeRepository {
  const AnnualFeeRepository();

  Future<List<AnnualFeeDTO>> getAnnualFeeList() async {
    List<AnnualFeeDTO> result = [];
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/merchant/service-fee/annual';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = data
            .map<AnnualFeeDTO>((json) => AnnualFeeDTO.fromJson(json))
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
