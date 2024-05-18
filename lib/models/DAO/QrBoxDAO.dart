import 'dart:convert';

import 'package:vietqr_admin/models/DAO/BaseDAO.dart';
import 'package:vietqr_admin/models/DTO/bank_type_dto.dart';
import 'package:vietqr_admin/models/DTO/qr_box_dto.dart';

import '../../commons/constants/utils/base_api.dart';
import '../../commons/constants/utils/log.dart';
import '../DTO/metadata_dto.dart';

class QrBoxDAO extends BaseDAO {
  Future<bool?> activeQrBox(
      {String? boxAddress,
      String? qrCertificate,
      String? bankAccount,
      String? terminalName}) async {
    try {
      Map<String, dynamic> params = {};
      params['boxAddress'] = boxAddress;
      params['qrCertificate'] = qrCertificate;
      params['bankCode'] = 'MB';
      params['bankAccount'] = bankAccount;
      params['terminalName'] = terminalName;

      String url = 'https://api.vietqr.org/vqr/api/tid-internal/sync';
      final response = await BaseAPIClient.postAPI(
        body: params,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<List<BankTypeDTO>?> getBanks() async {
    List<BankTypeDTO> result = [];

    try {
      String url = 'https://api.vietqr.org/vqr/api/bank-type';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        result = data.map<BankTypeDTO>((e) => BankTypeDTO.fromJson(e)).toList();
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<bool?> createQrBox(QrBoxDTO dto,
      {String? note, int? amount, String? content}) async {
    try {
      Map<String, dynamic> param() {
        return {
          "bankAccount": dto.bankAccount,
          "bankName": "",
          "bankCode": "MB",
          "bankShortName": dto.bankShortName,
          "userBankName": dto.userBankName,
          "note": note,
          "amount": amount,
          "content": content,
          "imgId": "",
          "qrCode": "",
          "boxCode": dto.boxCode,
          "orderId": "",
          "terminalCode": dto.terminalCode,
          "terminalName": dto.terminalName,
        };
      }

      String url = 'https://api.vietqr.org/vqr/api/tid/dynamic-qr';
      final response = await BaseAPIClient.postAPI(
        body: param(),
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error("Failed to fetch Create QR Box: ${e.toString()}");
    }
    return false;
  }

  Future<List<QrBoxDTO>?> getQrBoxList({
    required int page,
    int? size,
    required int type,
    required String value,
  }) async {
    List<QrBoxDTO> result = [];
    try {
      String url =
          'https://api.vietqr.org/vqr/api/tid-internal/list?page=$page&size=${size ?? 20}&type=$type&value=$value';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        result =
            data['data'].map<QrBoxDTO>((e) => QrBoxDTO.fromJson(e)).toList();
        return result;
      }
    } catch (e) {
      LOG.error("Failed to fetch QR Box List: ${e.toString()}");
    }
    return [];
  }
}
