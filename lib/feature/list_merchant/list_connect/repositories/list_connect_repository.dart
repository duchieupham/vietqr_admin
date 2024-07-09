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

  // Future<List<ConnectDTO>> getListConnect(
  //     int type, int size, int page, String value) async {
  //   List<ConnectDTO> result = [];
  //   try {
  //     String url =
  //         '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/sorted?type=$type&page=$page&size=$size&value=$value';

  //     final response = await BaseAPIClient.getAPI(
  //       url: url,
  //       type: AuthenticationType.SYSTEM,
  //     );
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       if (data != null) {
  //         var metadata = MetaData.fromJson(data['metadata']);
  //         result = (data['data'] as List)
  //             .map<ConnectDTO>((json) => ConnectDTO.fromJson(json))
  //             .toList();
  //         // If needed, you can use metadata here
  //         // e.g., print(metadata.totalElement);
  //         return result;
  //       }
  //     }
  //   } catch (e) {
  //     LOG.error(e.toString());
  //   }
  //   return result;
  // }

  Future<ConnectResponse?> getListConnect(
      int type, int size, int page, String value, int typeSearch) async {
    try {
      // String url =
      //     '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/sorted?type=$type&page=$page&size=$size&value=$value';
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/sorted?type=$type&page=$page&size=$size&value=$value&typeSearch=$typeSearch';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          // Log the entire response for debugging
          LOG.info('Response Data: $data');

          MetaData metadata = MetaData.fromJson(data['metadata']);
          // LOG.info(
          //     'Metadata: page=${metadata.page}, size=${metadata.size}, totalPage=${metadata.totalPage}, totalElement=${metadata.totalElement}');

          List<ConnectDTO> connectData = (data['data'] as List)
              .map<ConnectDTO>((json) => ConnectDTO.fromJson(json))
              .toList();

          return ConnectResponse(metadata: metadata, data: connectData);
        }
      } else {
        LOG.error('Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      LOG.error('Exception: ${e.toString()}');
    }
    return null;
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
