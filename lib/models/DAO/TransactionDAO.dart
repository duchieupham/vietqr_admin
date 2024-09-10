import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/DAO/BaseDAO.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
import 'package:vietqr_admin/models/DTO/transaction_dto.dart';
import 'package:vietqr_admin/models/DTO/transaction_log_dto.dart';

class TransactionDAO extends BaseDAO {
  Future<dynamic> getListTransaction(Map<String, dynamic> param) async {
    List<TransactionDTO> result = [];
    try {
      // String url =
      //     '${EnvConfig.instance.getBaseUrl()}admin/transactions/v2?type=${param['type']}&value=${param['value']}&from=${param['from']}&to=${param['to']}&offset=${param['offset']}';
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/transactions/v2?type=${param['type']}&value=${param['value']}&from=${param['from']}&to=${param['to']}&offset=${param['offset']}';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        return TransactionDTO.fromJson(data['data']);
      }

      return result;
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  // Future<TransactionDetailDTO> getDetailTransaction(String id) async {
  //   TransactionDetailDTO result = const TransactionDetailDTO();
  //   try {
  //     String url = '${EnvConfig.instance.getBaseUrl()}admin/transaction?id=$id';

  //     final response = await BaseAPIClient.getAPI(
  //       url: url,
  //       type: AuthenticationType.SYSTEM,
  //     );
  //     var data = jsonDecode(response.body);
  //     if (data != null) {
  //       result = TransactionDetailDTO.fromJson(data);
  //       return result;
  //     }
  //     return result;
  //   } catch (e) {
  //     LOG.error(e.toString());
  //   }
  //   return result;
  // }

  // Future<List<TransactionLogDTO>> getListLogTransaction(String id) async {
  //   List<TransactionLogDTO> result = [];
  //   try {
  //     String url =
  //         '${EnvConfig.instance.getBaseUrl()}admin/transaction/log?id=$id';

  //     final response = await BaseAPIClient.getAPI(
  //       url: url,
  //       type: AuthenticationType.SYSTEM,
  //     );
  //     var data = jsonDecode(response.body);
  //     if (data != null) {
  //       result = data
  //           .map<TransactionLogDTO>((json) => TransactionLogDTO.fromJson(json))
  //           .toList();
  //       return result;
  //     }
  //     return result;
  //   } catch (e) {
  //     LOG.error(e.toString());
  //   }
  //   return result;
  // }
}
