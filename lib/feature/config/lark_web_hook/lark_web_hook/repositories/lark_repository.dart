import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';
import 'package:vietqr_admin/models/web_hook_dto.dart';

class LarkRepository {
  const LarkRepository();

  Future<List<WebHookDTO>> getListWebhook() async {
    List<WebHookDTO> result = [];
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}lark-partner';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<WebHookDTO>((json) => WebHookDTO.fromJson(json))
              .toList();
          return result;
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future insertWebhook(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO();
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}lark-partner';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future updateData(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO();
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}lark-partner/update';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future updateStatus(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}lark-partner/status/update';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future removeWebhook(String id) async {
    ResponseMessageDTO result = const ResponseMessageDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}lark-partner/remove?id=$id';

      final response = await BaseAPIClient.deleteAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: null,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
