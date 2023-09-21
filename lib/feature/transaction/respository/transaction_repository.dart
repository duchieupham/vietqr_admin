import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/utils/log.dart';
import 'package:vietqr_admin/models/transaction_dto.dart';

class TransactionRepository {
  const TransactionRepository();

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
}
