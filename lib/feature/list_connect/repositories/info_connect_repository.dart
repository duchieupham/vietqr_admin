import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/models/api_service_dto.dart';
import 'package:vietqr_admin/models/ecomerce_dto.dart';

import '../../../commons/utils/log.dart';

class InfoConnectRepository {
  const InfoConnectRepository();

  Future<ApiServiceDTO> getInfoApiService(String id) async {
    ApiServiceDTO result = const ApiServiceDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/information?id=$id ';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ApiServiceDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<EcomerceDTO> getInfoEcomerce(String id) async {
    EcomerceDTO result = const EcomerceDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/information?id=$id ';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = EcomerceDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
