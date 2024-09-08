import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/DAO/BaseDAO.dart';
import 'package:vietqr_admin/models/DTO/bank_system_dto.dart';
import 'package:vietqr_admin/models/DTO/create_user_dto.dart';
import 'package:vietqr_admin/models/DTO/key_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
import 'package:vietqr_admin/models/DTO/response_message_dto.dart';
import 'package:vietqr_admin/models/DTO/total_user_dto.dart';
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
          '${EnvConfig.instance.getBaseUrl()}account/admin-list-account-user?page=$page&size=${size ?? 20}&type=$type&value=$value';
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

  Future<List<BankSystemDTO>> getListBank({
    required int page,
    int? size,
    required int type,
    required String value,
  }) async {
    List<BankSystemDTO> result = [];
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}list-account-bank?type=$type&value=$value&page=$page&size=${size ?? 20}';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        result = data['data']
            .map<BankSystemDTO>((x) => BankSystemDTO.fromJson(x))
            .toList();
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return [];
  }

  Future<dynamic> filterBankList(
      {required int page,
      required int size,
      required int type,
      required String value,
      required int searchType}) async {
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}new-list-bank-account?type=$type&value=$value&searchType=$searchType&page=$page&size=$size';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        return BankSystemDTO.fromJson(data['data']);
      }
    } catch (e) {
      LOG.error("Failed to fetch invoice data: ${e.toString()}");
    }
    return null;
  }

  Future<bool?> updateUser(UserInfo dto) async {
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/account-update/${dto.id}';
      final response = await BaseAPIClient.putAPI(
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

  Future<TotalUserDTO?> getTotalUsers() async {
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}account/count-registered-today';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return TotalUserDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<UserDetailDTO?> getUserDetail(String userId) async {
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}account/users-details?userId=$userId';
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

  Future<bool?> createUser(CreateUserDTO dto) async {
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}admin/account-create';
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

  Future<dynamic> requestActiveKey(Map<String, dynamic> param) async {
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}account-bank/admin/request-active';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return ResponseDataDTO.fromJson(data);
      } else {
        var data = jsonDecode(response.body);
        return ResponseMessageDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  Future<ResponseMessageDTO> confirmActiveKey(
      Map<String, dynamic> param) async {
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}account-bank/admin/confirm-active';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      return ResponseMessageDTO.fromJson(data);
    } catch (e) {
      LOG.error(e.toString());
    }
    return const ResponseMessageDTO(
        status: 'Failed', message: 'Đã xảy ra lỗi.');
  }

  Future<dynamic> checkActiveKey(String keyActive) async {
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}key/check-active';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: {'keyActive': keyActive},
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ResponseActiveKeyDTO.fromJson(data);
      } else {
        return ResponseMessageDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return const ResponseMessageDTO(
        status: 'Failed', message: 'Đã xảy ra lỗi.');
  }

  Future<bool?> changeLinkedUser(String? userId, int? status) async {
    try {
      Map<String, dynamic> param = {};
      param[''] = status;

      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/account-status/$userId?status=$status';
      final response = await BaseAPIClient.putAPI(
        body: param,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool?> changeUserPassword(String phone, String pass) async {
    try {
      Map<String, dynamic> param = {};
      param['newPassword'] = pass;

      String url =
          '${EnvConfig.instance.getBaseUrl()}password-reset?phoneNo=$phone';
      final response = await BaseAPIClient.postAPI(
        body: param,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  // Future<ResponseMessageDTO> checkLog(Map<String, dynamic> param) async {
  //   ResponseMessageDTO result = const ResponseMessageDTO();
  //   try {
  // String url =
  //     '${EnvConfig.instance.getBaseUrl()}check-log/request_otp_bank';
  //     String url = 'https://api.vietqr.org/vqr/api/check-log/request_otp_bank';

  //     final response = await BaseAPIClient.postAPI(
  //       url: url,
  //       type: AuthenticationType.SYSTEM,
  //       body: param,
  //     );
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       result = ResponseMessageDTO.fromJson(data);
  //     } else {
  //       result = ResponseMessageDTO(
  //           status: 'FAILED', message: 'Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     LOG.error(e.toString());
  //     result = ResponseMessageDTO(status: 'FAILED', message: e.toString());
  //   }
  //   return result;
  // }
  Future<ResponseMessageDTO> checkLog(Map<String, dynamic> param) async {
    try {
      // String url =
      //     'https://api.vietqr.org/vqr/bank/api/check-log/request_otp_bank';
      String url =
          '${EnvConfig.instance.getBaseUrl()}check-log/request_otp_bank';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return ResponseMessageDTO.fromJson(data);
      } else {
        // Nếu mã trạng thái không phải 200, giả định lỗi nằm trong nội dung phản hồi
        var errorData = jsonDecode(response.body);
        return ResponseMessageDTO(
          status: 'FAILED',
          message: errorData['message'] ?? 'Lỗi không xác định',
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      return ResponseMessageDTO(
        status: 'FAILED',
        message: 'Đã có lỗi xảy ra: ${e.toString()}',
      );
    }
  }
}
