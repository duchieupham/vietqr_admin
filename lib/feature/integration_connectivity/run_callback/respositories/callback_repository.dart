import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/models/api_service_dto.dart';
import 'package:vietqr_admin/models/bank_account_dto.dart';
import 'package:vietqr_admin/models/callback_dto.dart';
import 'package:vietqr_admin/models/customer_dto.dart';
import 'package:vietqr_admin/models/ecomerce_dto.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';
import 'package:vietqr_admin/service/shared_references/account_helper.dart';

class CallBackRepository {
  CallBackRepository();

  final String baseUrl = EnvConfig.instance.getBaseUrl();

  Future<List<CallBackDTO>> getTrans(
      String bankId, String customerSyncId, int offset) async {
    List<CallBackDTO> result = [];
    try {
      String url =
          '${baseUrl}admin/transactions/customer-sync?bankId=$bankId&customerSyncId=$customerSyncId&offset=$offset';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<CallBackDTO>((json) => CallBackDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<CustomerDTO>> getListCustomer() async {
    List<CustomerDTO> result = [];
    try {
      String url = '${baseUrl}admin/customer-sync';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<CustomerDTO>((json) => CustomerDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<BankAccountDTO>> getListBank(String id) async {
    List<BankAccountDTO> result = [];
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/account-bank/list?customerSyncId=$id&offset=0';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<BankAccountDTO>((json) => BankAccountDTO.fromJson(json))
              .toList();
          return result;
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ApiServiceDTO> getInfoApiService(String id) async {
    ApiServiceDTO result = const ApiServiceDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/information?id=$id';

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
          '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/information?id=$id';

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

  Future<bool> getToken(String userName, String password) async {
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}token_generate';

      Map<String, String>? result = {};
      result['Authorization'] =
          'Basic ${StringUtils.instance.authBase64(userName, password)}';

      print(
          '-------------------------------------------------- ${StringUtils.instance.authBase64(userName, password)}');
      result['Content-Type'] = 'application/json';
      result['Accept'] = '*/*';

      final response = await BaseAPIClient.postAPI(
          url: url, type: AuthenticationType.CUSTOM, body: {}, header: result);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        await AccountHelper.instance.setTokenFree(data['access_token']);
        return true;
      } else {
        await AccountHelper.instance.setTokenFree('');
        return false;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<ResponseMessageDTO> runCallback(Map<String, dynamic> body) async {
    ResponseMessageDTO dto = const ResponseMessageDTO();

    try {
      String url =
          'https://dev.vietqr.org/vqr/bank/api/test/transaction-callback';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: body,
      );
      var data = jsonDecode(response.body);
      dto = ResponseMessageDTO.fromJson(data);
    } catch (e) {
      LOG.error(e.toString());
    }
    return dto;
  }
}
