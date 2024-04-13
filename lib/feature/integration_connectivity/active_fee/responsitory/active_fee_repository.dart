import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';

import '../../../../models/DTO/active_fee_dto.dart';
import '../../../../models/DTO/active_fee_total_static.dart';

class ActiveFeeRepository {
  const ActiveFeeRepository();

  Future<List<ActiveFeeDTO>> getListActiveFee(String month) async {
    List<ActiveFeeDTO> result = [];
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/merchant/service-fee/transaction?month=$month';
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

  Future<ActiveFeeStaticDto> getTotalStatic(String month) async {
    ActiveFeeStaticDto result = const ActiveFeeStaticDto();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/bank/service-fee/total?month=$month';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = ActiveFeeStaticDto.fromJson(data);
        return result;
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }
}
