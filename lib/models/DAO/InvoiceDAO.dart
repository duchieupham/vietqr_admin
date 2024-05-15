import 'dart:convert';

import 'package:vietqr_admin/models/DAO/BaseDAO.dart';

import '../../commons/constants/utils/base_api.dart';
import '../../commons/constants/utils/log.dart';
import '../DTO/bank_detail_dto.dart';
import '../DTO/bank_invoice_dto.dart';
import '../DTO/invocie_merchant_dto.dart';
import '../DTO/invoice_dto.dart';
import '../DTO/metadata_dto.dart';
import '../DTO/service_item_dto.dart';

class InvoiceDAO extends BaseDAO {
  Future<bool?> createInvoice(
      {required String bankId,
      required double? vat,
      required String? merchantId,
      required String invoiceName,
      required String description,
      required List<ServiceItemDTO> list}) async {
    try {
      Map<String, dynamic> params = {};
      params['bankId'] = bankId;
      params['vat'] = vat;

      params['merchantId'] = merchantId ?? '';
      params['invoiceName'] = invoiceName;
      params['description'] = description;
      params['items'] = list.map((e) => e.toJson()).toList();

      String url = 'https://dev.vietqr.org/vqr/api/invoice/create';
      final response = await BaseAPIClient.postAPI(
        body: params,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error("Failed to fetch invoice data: ${e.toString()}");
    }
    return false;
  }

  Future<InvoiceDTO?> filterInvoiceList({
    required String time,
    required int page,
    int? size,
    required int type,
    required int value,
  }) async {
    try {
      String url =
          'https://dev.vietqr.org/vqr/mock/api/invoice/admin-list?page=$page&size=${size ?? 20}&type=$type&value=$value&time=$time';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        return InvoiceDTO.fromJson(data['data']);
      }
    } catch (e) {
      LOG.error("Failed to fetch invoice data: ${e.toString()}");
    }
    return null;
  }

  Future<ServiceItemDTO?> getServiceItem({
    int? type,
    String? bankId,
    String? merchantId,
    String? time,
    double? vat,
  }) async {
    try {
      String url =
          'https://dev.vietqr.org/vqr/mock/api/invoice/invoice-item?bankId=$bankId&merchantId=${merchantId ?? ''}&type=$type&time=$time&vat=$vat';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return ServiceItemDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

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

  Future<BankDetailDTO?> getBankDetail({
    String? merchantId,
    String? bankId,
  }) async {
    try {
      String url =
          'https://dev.vietqr.org/vqr/mock/api/admin/bank-detail?bankId=$bankId&merchantId=${merchantId ?? ''}';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return BankDetailDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }
}
