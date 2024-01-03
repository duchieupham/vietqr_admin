import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/active_fee_dto.dart';
import 'package:vietqr_admin/models/active_fee_total_static.dart';

class ActiveFeeRepository {
  const ActiveFeeRepository();

  Future<ActiveFeeDTO> getListActiveFee(String month) async {
    ActiveFeeDTO dto = ActiveFeeDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/merchant/service-fee/transaction?month=$month';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        dto = ActiveFeeDTO.fromJson(data);
        return dto;
      }
      return dto;
    } catch (e) {
      LOG.error(e.toString());
      return dto;
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
