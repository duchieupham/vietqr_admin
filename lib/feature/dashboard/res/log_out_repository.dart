import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/service/shared_references/user_information_helper.dart';

class LogoutRepository {
  const LogoutRepository();

  Future<bool> logout() async {
    bool result = false;
    try {
      final String url = '${EnvConfig.instance.getBaseUrl()}accounts/logout';
      String fcmToken = '';

      final response = await BaseAPIClient.postAPI(
        url: url,
        body: {'fcmToken': fcmToken},
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200) {
        await _resetServices().then((value) => result = true);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<void> _resetServices() async {
    await UserInformationHelper.instance.initialUserInformationHelper();
  }
}
