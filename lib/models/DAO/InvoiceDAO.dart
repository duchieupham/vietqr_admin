import 'dart:convert';

import 'package:vietqr_admin/models/DAO/BaseDAO.dart';

import '../../commons/constants/utils/base_api.dart';
import '../../commons/constants/utils/log.dart';
import '../DTO/bank_invoice_dto.dart';
import '../DTO/invocie_merchant_dto.dart';
import '../DTO/metadata_dto.dart';

class InvoiceDAO extends BaseDAO {
  Future<MerchantDTO?> getMerchant({
    required int page,
    int? size,
    required String value,
  }) async {
    try {
      String url =
          'https://dev.vietqr.org/vqr/mock/api/invoice/merchant-list?&type=1&value=$value&page=$page&size=${size ?? 20}';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        return MerchantDTO.fromJson(data['data']);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<BankInvoiceDTO?> getBankList({
    String? merchantId,
    required int page,
    int? size,
    required String value,
  }) async {
    try {
      String url =
          'https://dev.vietqr.org/vqr/mock/api/invoice/bank-account-list?merchantId=${merchantId ?? ''}&page=$page&size=${size ?? 20}&type=1&value=$value';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        return BankInvoiceDTO.fromJson(data['data']);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }
}
