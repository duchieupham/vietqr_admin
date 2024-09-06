import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/DTO/bank_name_search_dto.dart';

import '../../../../models/DTO/api_service_dto.dart';
import '../../../../models/DTO/bank_account_dto.dart';
import '../../../../models/DTO/bank_name_information_dto.dart';
import '../../../../models/DTO/ecomerce_dto.dart';
import '../../../../models/DTO/response_message_dto.dart';
import '../../../../models/DTO/statistic_dto.dart';

class InfoConnectRepository {
  const InfoConnectRepository();

  Future<ApiServiceDTO> getInfoApiService(String id) async {
    ApiServiceDTO result = const ApiServiceDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/information?id=$id';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ApiServiceDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<EcomerceDTO> getInfoEcomerce(String id) async {
    EcomerceDTO result = const EcomerceDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/information?id=$id';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = EcomerceDTO.fromJson(data);
        return result;
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

  // Future<BankNameInformationDTO> searchBankName(String accountNumber) async {
  //   BankNameInformationDTO result = const BankNameInformationDTO();
  //   try {
  //     String url =
  //         'https://api.vietqr.org/vqr/bank/api/account/info/970422/$accountNumber/ACCOUNT/INHOUSE';

  //     final response = await BaseAPIClient.getAPI(
  //       url: url,
  //       type: AuthenticationType.SYSTEM,
  //     );
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       if (data != null) {
  //         result = BankNameInformationDTO.fromJson(data);
  //         return result;
  //       }
  //     }
  //   } catch (e) {
  //     LOG.error(e.toString());
  //   }
  //   return result;
  // }

  Future<BankNameInformationDTO> searchBankNameNewConnectProvider(
      BankNameSearchDTO dto) async {
    String generateCheckSum(
        String bankCode, String accountType, String accountNumber) {
      String key = "VietQRAccesskey";
      String toHash = bankCode + accountType + accountNumber + key;
      // Tạo hash MD5
      var bytes = utf8.encode(toHash);
      var digest = md5.convert(bytes);
      return digest.toString();
    }

    String checkSum =
        generateCheckSum(dto.bankCode, dto.accountType, dto.accountNumber);

    BankNameInformationDTO result = const BankNameInformationDTO(
      accountName: '',
      customerName: '',
      customerShortName: '',
    );
    try {
      String url = 'https://api.vietqr.org/vqr/bank/api/account/info';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: {
          'bankCode': dto.bankCode,
          'accountNumber': dto.accountNumber,
          'accountType': dto.accountType,
          'transferType': dto.transferType,
          'checkSum': checkSum,
        },
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = BankNameInformationDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<BankNameInformationDTO> searchBankName(String accountNumber) async {
    String transferType = 'INHOUSE';
    String accountType = 'ACCOUNT';
    String bankCode = '970422';
    String generateCheckSum(
        String bankCode, String accountType, String accountNumber) {
      String key = "VietQRAccesskey";
      String toHash = bankCode + accountType + accountNumber + key;
      // Tạo hash MD5
      var bytes = utf8.encode(toHash);
      var digest = md5.convert(bytes);
      return digest.toString();
    }

    String checkSum = generateCheckSum(bankCode, accountType, accountNumber);

    BankNameInformationDTO result = const BankNameInformationDTO(
      accountName: '',
      customerName: '',
      customerShortName: '',
    );

    // BankNameInformationDTO result = const BankNameInformationDTO();
    try {
      String url = 'https://api.vietqr.org/vqr/bank/api/account/info';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: {
          'bankCode': bankCode,
          'accountNumber': accountNumber,
          'accountType': accountType,
          'transferType': transferType,
          'checkSum': checkSum,
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = BankNameInformationDTO.fromJson(data);
          return result;
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> addBankConnect(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO();
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}admin/customer-bank';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
          return result;
        }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> removeBankConnect(
      Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO();
    try {
      String url = '${EnvConfig.instance.getBaseUrl()}admin/customer-bank';

      final response = await BaseAPIClient.deleteAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
          return result;
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> updateMerchantConnect(
      Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/customer-sync/information';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
          return result;
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<StatisticDTO> getStatistic(Map<String, dynamic> param) async {
    StatisticDTO result = const StatisticDTO();
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}admin/transactions/statistic?type=${param['type']}&customerSyncId=${param['customerSyncId']}&month=${param['month']}';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = StatisticDTO.fromJson(data);
          return result;
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
