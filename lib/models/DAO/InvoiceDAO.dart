import 'dart:convert';

import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/models/DAO/BaseDAO.dart';
import 'package:vietqr_admin/models/DTO/invoice_excel_dto.dart';
import 'package:vietqr_admin/models/DTO/response_message_dto.dart';

import '../../commons/constants/utils/base_api.dart';
import '../../commons/constants/utils/log.dart';
import '../DTO/bank_detail_dto.dart';
import '../DTO/bank_invoice_dto.dart';
import '../DTO/invocie_merchant_dto.dart';
import '../DTO/invoice_detail_dto.dart';
import '../DTO/invoice_detail_qr_dto.dart';
import '../DTO/invoice_dto.dart';
import '../DTO/invoice_info_dto.dart';
import '../DTO/metadata_dto.dart';
import '../DTO/service_item_dto.dart';

class InvoiceDAO extends BaseDAO {
  Future<bool?> editInvoice(
      {required InvoiceInfoDTO? invoice,
      required double vat,
      String? bankIdRecharge}) async {
    try {
      Map<String, dynamic> param = {};
      param['bankId'] = invoice!.userInformation.bankId;
      param['merchantId'] = invoice.userInformation.merchantId;
      param['invoiceName'] = invoice.invoiceName;
      param['description'] = invoice.description;
      param['vat'] = vat;
      param['items'] = invoice.invoiceItems.map((e) => e.toJson()).toList();
      param['bankIdRecharge'] = bankIdRecharge;

      String url =
          '${EnvConfig.instance.getBaseUrl()}invoice/update/${invoice.invoiceId}';
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

  Future<bool?> delelteInvoice(String invoiceId) async {
    try {
      Map<String, dynamic> param = {};
      param['invoiceId'] = invoiceId;
      String url = '${EnvConfig.instance.getBaseUrl()}invoice/remove';
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

  Future<bool?> exportExcel(String invoiceItemId) async {
    try {
      Map<String, dynamic> param = {};
      param['invoiceItemId'] = invoiceItemId;
      // String url = '${EnvConfig.instance.getBaseUrl()}invoice/remove';
      String url =
          'https://dev.vietqr.org/vqr/api/invoice/export-excel/$invoiceItemId';
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

  Future<InvoiceInfoDTO?> getInvoiceInfo(String invoiceId) async {
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}invoice/edit-detail/$invoiceId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return InvoiceInfoDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<bool?> createInvoice(
      {required String bankId,
      required double? vat,
      required String? merchantId,
      required String invoiceName,
      required String description,
      required String bankIdRecharge,
      required List<ServiceItemDTO> list}) async {
    try {
      Map<String, dynamic> params = {};
      params['bankId'] = bankId;
      params['vat'] = vat;

      params['merchantId'] = merchantId ?? '';
      params['invoiceName'] = invoiceName;
      params['description'] = description;
      params['bankIdRecharge'] = bankIdRecharge;

      params['items'] = list.map((e) => e.toJson()).toList();

      String url = '${EnvConfig.instance.getBaseUrl()}invoice/create';
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

  Future<InvoiceExcelDTO?> getInvoiceExcel(String invoiceId) async {
    try {
      // String url = '${EnvConfig.getBaseUrl()}invoice/detail/$invoiceId';
      String url =
          'https://dev.vietqr.org/vqr/mock/api/invoice/transaction-list?invoiceId=$invoiceId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return InvoiceExcelDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error("Failed to fetch Invoice detail: ${e.toString()}");
    }
    return null;
  }

  Future<InvoiceDetailDTO?> getInvoiceDetail(String invoiceId) async {
    try {
      // String url = 'https://api.vietqr.org/vqr/api/invoice/detail/$invoiceId';
      String url =
          '${EnvConfig.instance.getBaseUrl()}invoice/detail/$invoiceId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return InvoiceDetailDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error("Failed to fetch Invoice detail: ${e.toString()}");
    }
    return null;
  }

  Future<List<PaymentRequestDTO>> getListPaymentRequest() async {
    String url = '${EnvConfig.instance.getBaseUrl()}invoice/setting-recharge';
    final response = await BaseAPIClient.getAPI(
      url: url,
      type: AuthenticationType.SYSTEM,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => PaymentRequestDTO.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load bank account info');
    }
  }

  Future<InvoiceDetailQrDTO?> requestPaymnet({
    required String invoiceId,
    required List<String> itemItemIds,
    String? bankIdRecharge,
  }) async {
    try {
      Map<String, dynamic> param = {};
      param['invoiceId'] = invoiceId;
      param['itemItemIds'] = itemItemIds;
      param['bankIdRecharge'] = bankIdRecharge;

      String url = '${EnvConfig.instance.getBaseUrl()}invoice/request-payment';
      final response = await BaseAPIClient.postAPI(
        body: param,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return InvoiceDetailQrDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error("Failed to request payment: ${e.toString()}");
    }
    return null;
  }

  Future<InvoiceDetailQrDTO?> getDetailQr(String invoiceId) async {
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}invoice/qr-detail/$invoiceId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return InvoiceDetailQrDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error("Failed to fetch QR detail: ${e.toString()}");
    }
    return null;
  }

  Future<InvoiceDTO?> filterInvoiceList({
    required String time,
    required int page,
    int? size,
    required int type,
    required String filter,
  }) async {
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}invoice/admin-list?page=$page&size=${size ?? 20}&type=$type&value=${filter ?? ''}&time=$time';
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

  Future<dynamic> getServiceItem({
    int? type,
    String? bankId,
    String? merchantId,
    String? time,
    double? vat,
  }) async {
    try {
      String url =
          '${EnvConfig.instance.getBaseUrl()}invoice/invoice-item?bankId=$bankId&merchantId=${merchantId ?? ''}&type=$type&time=$time&vat=$vat';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return ServiceItemDTO.fromJson(data);
      } else {
        var data = jsonDecode(response.body);
        return ResponseMessageDTO.fromJson(data);
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
          '${EnvConfig.instance.getBaseUrl()}invoice/merchant-list?&type=1&value=$value&page=$page&size=${size ?? 20}';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        return MerchantDTO.fromJson(data);
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
          '${EnvConfig.instance.getBaseUrl()}invoice/bank-account-list?merchantId=${merchantId ?? ''}&page=$page&size=${size ?? 20}&type=1&value=$value';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        return BankInvoiceDTO.fromJson(data);
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
          '${EnvConfig.instance.getBaseUrl()}admin/bank-detail?bankId=$bankId&merchantId=${merchantId ?? ''}';
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
