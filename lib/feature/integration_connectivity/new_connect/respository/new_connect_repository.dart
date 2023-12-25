import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/utils/log.dart';
import 'package:vietqr_admin/models/generate_username_pass_dto.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';

class NewConnectRepository {
  const NewConnectRepository();

  Future getToken(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/check-token';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      var data = jsonDecode(response.body);
      result = ResponseMessageDTO.fromJson(data);
      return result;
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future getPassSystem(Map<String, dynamic> param) async {
    GenerateUserNamePassDto result = const GenerateUserNamePassDto();
    try {
      String url =
          'https://api.vietqr.org/vqr/api/customer-sync/account/generate';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = GenerateUserNamePassDto.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future addCustomerSync(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO();
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}admin/customer-sync';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      var data = jsonDecode(response.body);
      result = ResponseMessageDTO.fromJson(data);
      return result;
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
