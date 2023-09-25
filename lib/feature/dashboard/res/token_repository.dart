import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';

import '../../../commons/utils/log.dart';

class TokenRepository {
  const TokenRepository();

  Future<bool> checkValidToken() async {
    bool result = false;
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}token';
      final response =
          await BaseAPIClient.getAPI(url: url, type: AuthenticationType.SYSTEM);
      if (response.statusCode == 200) {
        result = true;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  //return
  //0: ignore
  //1: success
  //2: maintain
  //3: connection failed
  //4: token expired
  Future<int> checkValidTokenWeb() async {
    int result = 0;
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}token';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      if (response.statusCode == 200) {
        result = 1;
      } else if (response.statusCode == 404 || response.statusCode == 400) {
        result = 2;
      } else if (response.statusCode == 403) {
        result = 4;
      }
    } catch (e) {
      LOG.error(e.toString());
      if (e.toString().contains('Connection failed')) {
        result = 3;
      }
    }
    return result;
  }
}
