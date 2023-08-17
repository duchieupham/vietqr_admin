import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/models/account_information_dto.dart';
import 'package:vietqr_admin/service/shared_references/account_helper.dart';
import 'package:vietqr_admin/service/shared_references/user_information_helper.dart';

import '../../../commons/utils/log.dart';

class LoginRepository {
  // static final codeLoginController = BehaviorSubject<CodeLoginDTO>();

  const LoginRepository();

  Future<bool> login(Map<String, dynamic> param) async {
    bool result = false;
    try {
      String url = '${EnvConfig.getBaseUrl()}accounts-admin';

      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200) {
        String token = response.body;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        print('--------------------------------$decodedToken');
        AccountInformationDTO accountInformationDTO =
            AccountInformationDTO.fromJson(decodedToken);
        await AccountHelper.instance.setFcmToken('');
        await AccountHelper.instance.setToken(token);
        await UserInformationHelper.instance
            .setAdminId(accountInformationDTO.adminId);
        await UserInformationHelper.instance
            .setAccountInformation(accountInformationDTO);
        result = true;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
