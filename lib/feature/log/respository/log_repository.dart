import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/utils/log.dart';

class LogRepository {
  const LogRepository();

  Future<List<String>> getLog(String date) async {
    List<String> result = [];
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/log-reader?date=$date';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data.isEmpty) {
        return result;
      }
      result = (data as List).map((item) => item as String).toList();
      return result;
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
