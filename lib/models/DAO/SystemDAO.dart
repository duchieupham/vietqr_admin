import 'dart:convert';

import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/DAO/BaseDAO.dart';
import 'package:vietqr_admin/models/DTO/create_user_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
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

  Future<bool?> createUser(CreateUserDTO dto) async {
    try {
      String url = 'https://dev.vietqr.org/vqr/mock/admin/create';
      final response = await BaseAPIClient.postAPI(
        body: dto.toJson(),
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }
}
