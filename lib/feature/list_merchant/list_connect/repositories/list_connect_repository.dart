import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';

import '../../../../models/DTO/connect.dto.dart';
import '../../../../models/DTO/response_message_dto.dart';

class ListConnectRepository {
  const ListConnectRepository();

  // Future<List<ConnectDTO>> getListConnect(int type) async {
  //   List<ConnectDTO> result = [];
  //   try {
  //     String url =
  //         '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/sorted?type=$type';

  //     final response = await BaseAPIClient.getAPI(
  //       url: url,
  //       type: AuthenticationType.SYSTEM,
  //     );
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       if (data != null) {
  //         result = data
  //             .map<ConnectDTO>((json) => ConnectDTO.fromJson(json))
  //             .toList();
  //         return result;
  //       }
  //     }
  //   } catch (e) {
  //     LOG.error(e.toString());
  //   }
  //   return result;
  // }

  Future<List<ConnectDTO>> getListConnect(
      int type, int size, int page, String value) async {
    List<ConnectDTO> result = [];
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/sorted?type=$type&page=$page&size=$size&value=$value';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          var metadata = MetaData.fromJson(data['metadata']);
          result = (data['data'] as List)
              .map<ConnectDTO>((json) => ConnectDTO.fromJson(json, metadata))
              .toList();
          return result;
        }
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
          '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/status';

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
}
