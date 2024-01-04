import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/bank_account_dto.dart';
import 'package:vietqr_admin/models/bank_account_sync_dto.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';
import 'package:vietqr_admin/models/service_charge_dto.dart';
import 'package:vietqr_admin/models/synthesis_report_dto.dart';
import 'package:vietqr_admin/models/transaction_merchant_dto.dart';

class MerchantRepository {
  const MerchantRepository();

  Future<ResponseMessageDTO> updateNote(Map<String, dynamic> param) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.instance.getBaseUrl()}transactions/note';
      final response = await BaseAPIClient.postAPI(
          url: url, type: AuthenticationType.SYSTEM, body: param);
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }

  Future<List<ServiceChargeDTO>> getMerchantFee(
      String customerSyncId, String year, int status) async {
    List<ServiceChargeDTO> result = [];
    try {
      final String url =
          '${EnvConfig.instance.getBaseUrl()}bank/service-fee?merchantId=$customerSyncId&status=$status&year=$year';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<ServiceChargeDTO>((json) => ServiceChargeDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<TransactionMerchantDTO>> getListTransactionByUser(
      Map<String, dynamic> param) async {
    List<TransactionMerchantDTO> result = [];
    try {
      final String url =
          '${EnvConfig.instance.getBaseUrl()}user/transactions?userId=${param['userId']}&type=${param['type']}&value=${param['value']}&from=${param['from']}&to=${param['to']}&offset=${param['offset']}';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<TransactionMerchantDTO>(
                (json) => TransactionMerchantDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<TransactionMerchantDTO>> getListTransactionByMerchant(
      Map<String, dynamic> param) async {
    List<TransactionMerchantDTO> result = [];
    try {
      final String url =
          '${EnvConfig.instance.getBaseUrl()}merchant/transactions?merchantId=${param['merchantId']}&type=${param['type']}&value=${param['value']}&from=${param['from']}&to=${param['to']}&offset=${param['offset']}';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<TransactionMerchantDTO>(
                (json) => TransactionMerchantDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<SynthesisReportDTO>> getListSynthesisReport(
      int type, String time, String id) async {
    List<SynthesisReportDTO> result = [];
    try {
      final String url =
          '${EnvConfig.instance.getBaseUrl()}transactions/merchant/statistic?type=$type&id=$id&time=$time';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<SynthesisReportDTO>(
                (json) => SynthesisReportDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<BankAccountDTO>> getListBank(String id) async {
    List<BankAccountDTO> result = [];
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/account-bank/list?customerSyncId=$id&offset=0';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<BankAccountDTO>((json) => BankAccountDTO.fromJson(json))
              .toList();
          return result;
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<BankAccountSync>> getListBankSync(String customerSyncId) async {
    List<BankAccountSync> result = [];
    try {
      final String url =
          '${EnvConfig.instance.getBaseUrl()}admin/account-bank/list?customerSyncId=$customerSyncId&offset=0';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<BankAccountSync>((json) => BankAccountSync.fromJsonApi(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
