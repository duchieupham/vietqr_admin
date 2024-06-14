import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/DAO/BaseDAO.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
import 'package:vietqr_admin/models/DTO/user_detail_dto.dart';
import 'package:vietqr_admin/models/DTO/user_system_dto.dart';

class SystemDAO extends BaseDAO {
  Future<List<UserSystemDTO>> getListUser({
    required int page,
    int? size,
    required int type,
    required String value,
  }) async {
    List<UserSystemDTO> result = [];
    try {
      String url =
          'https://dev.vietqr.org/vqr/mock/api/admin-list-users?page=$page&size=${size ?? 20}&type=$type&value=$value';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        result = data['data']
            .map<UserSystemDTO>((x) => UserSystemDTO.fromJson(x))
            .toList();
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return [];
  }

  Future<UserDetailDTO?> getUserDetail(String userId) async {
    try {
      String url =
          'https://dev.vietqr.org/vqr/mock/api/user-detail?userId=$userId';
      // String url =
      //     '${EnvConfig.instance.getBaseUrl()}invoice/detail/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return UserDetailDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error("Failed to fetch Invoice detail: ${e.toString()}");
    }
    return null;
  }
}
