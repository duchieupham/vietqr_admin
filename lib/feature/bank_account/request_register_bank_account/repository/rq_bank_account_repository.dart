import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/account_bank_rq_dto.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';

class RQBankAccountRepository {
  const RQBankAccountRepository();

  Future<List<AccountBankRQDTO>> getListRqBankAccount(int offset) async {
    List<AccountBankRQDTO> result = [];
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}account-bank-request?offset=$offset';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = data
            .map<AccountBankRQDTO>((json) => AccountBankRQDTO.fromJson(json))
            .toList();
        return result;
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }

  Future<ResponseMessageDTO> removeRqBankAccount(String id) async {
    ResponseMessageDTO dto = const ResponseMessageDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}account-bank-request?id=$id';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: null,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        dto = ResponseMessageDTO.fromJson(data);
        return dto;
      } else {
        dto = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
      return dto;
    } catch (e) {
      LOG.error(e.toString());
      dto = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      return dto;
    }
  }
}
