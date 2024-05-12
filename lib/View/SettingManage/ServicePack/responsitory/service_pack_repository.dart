import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';

import '../../../../commons/utils/log.dart';
import '../../../../models/DTO/response_message_dto.dart';
import '../../../../models/DTO/merchant_fee_dto.dart';
import '../../../../models/DTO/service_pack_dto.dart';

class ServicePackRepository {
  const ServicePackRepository();

  Future<List<ServicePackDTO>> getServicePackList() async {
    List<ServicePackDTO> result = [];
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}admin/service-fee';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = data
            .map<ServicePackDTO>((json) => ServicePackDTO.fromJson(json))
            .toList();
        return result;
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }

  Future<ResponseMessageDTO> insertServicePack(
      Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO();
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}admin/service-fee';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = ResponseMessageDTO.fromJson(data);
        return result;
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }

  Future<List<MerchantFee>> getListMerChantBankAccount() async {
    List<MerchantFee> result = [];
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/service-mapping';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = data
            .map<MerchantFee>((json) => MerchantFee.fromJson(json))
            .toList();
        return result;
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }

  Future<ResponseMessageDTO> insertBankAccountFee(
      Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO();
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}admin/bank/service-fee';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = ResponseMessageDTO.fromJson(data);
        return result;
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }
}
