import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/utils/log.dart';
import 'package:vietqr_admin/models/DAO/BaseDAO.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
import 'package:vietqr_admin/models/DTO/response_message_dto.dart';

import '../../../../models/DTO/transaction_detail_dto.dart';
import '../../../../models/DTO/transaction_dto.dart';
import '../../../../models/DTO/transaction_log_dto.dart';

class TransactionRepository extends BaseDAO {
  TransactionRepository();

  Future<dynamic> filterListTransaction(
      {required int page,
      required int size,
      required int type,
      required String value,
      required String from,
      required String to}) async {
    try {
      String url = '';
      if (type == 9) {
        // if(from.isEmpty && to.isEmpty){
        //   url =
        //     '${EnvConfig.instance.getBaseUrl()}admin/transactions/v2?page=$page&type=$type&value=&from=&to=&size=$size';
        // }else{
        //   url =
        //    '${EnvConfig.instance.getBaseUrl()}admin/transactions/v2?page=$page&type=$type&value=&from=$from&to=$to&size=$size}';
        // }
        url =
            '${EnvConfig.instance.getBaseUrl()}admin/transactions/v2?page=$page&type=$type&value=&from=&to=&size=$size';
      } else {
        url =
            '${EnvConfig.instance.getBaseUrl()}admin/transactions/v2?page=$page&type=$type&value=$value&from=$from&to=$to&size=$size';
      }

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        return TransactionDTO.fromJson(data['data']);
      } else {
        var data = jsonDecode(response.body);
        return ResponseMessageDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error("Failed to fetch invoice data: ${e.toString()}");
    }
    return null;
  }

  Future<List<TransactionDTO>> getListTransaction(
      Map<String, dynamic> param) async {
    List<TransactionDTO> result = [];
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/transactions?type=${param['type']}&value=${param['value']}&from=${param['from']}&to=${param['to']}&offset=${param['offset']}';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = data
            .map<TransactionDTO>((json) => TransactionDTO.fromJson(json))
            .toList();
        return result;
      }

      return result;
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<TransactionDetailDTO> getDetailTransaction(String id) async {
    TransactionDetailDTO result = const TransactionDetailDTO();
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}admin/transaction?id=$id';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = TransactionDetailDTO.fromJson(data);
        return result;
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<TransactionLogDTO>> getListLogTransaction(String id) async {
    List<TransactionLogDTO> result = [];
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/transaction/log?id=$id';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = data
            .map<TransactionLogDTO>((json) => TransactionLogDTO.fromJson(json))
            .toList();
        return result;
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
