import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/models/balance_dto.dart';
import 'package:vietqr_admin/models/qr_code_dto.dart';
import 'package:vietqr_admin/models/transaction_vnpt_dto.dart';
import 'package:vietqr_admin/models/vnpt_transaction_static.dart';

import '../../../commons/utils/log.dart';

class TopUpPhoneRepository {
  const TopUpPhoneRepository();

  Future<List<TransactionVNPTDTO>> getListTransactionVNPT(
    int status,
    int offset,
  ) async {
    List<TransactionVNPTDTO> result = [];
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}transaction-wallet/vnpt-epay?status=$status&offset=$offset';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = data
            .map<TransactionVNPTDTO>(
                (json) => TransactionVNPTDTO.fromJson(json))
            .toList();
        return result;
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }

  Future<QRCodeTDTO> createQr(int amount) async {
    QRCodeTDTO result = const QRCodeTDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}epay/request-payment-qr?amount=$amount';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = QRCodeTDTO.fromJson(data);
        return result;
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }

  Future<VNPTTransactionStaticDTO> getTransactionStatic() async {
    VNPTTransactionStaticDTO result = const VNPTTransactionStaticDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}transaction-wallet/vnpt-epay/statistic';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = VNPTTransactionStaticDTO.fromJson(data);
        return result;
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
  }

  Future<BalanceDTO> getBalance() async {
    BalanceDTO result = BalanceDTO();

    try {
      String url = '${EnvConfig.instance.getBaseUrl()}epay/query-balance';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = BalanceDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
