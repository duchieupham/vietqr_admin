import 'dart:convert';

import 'package:vietqr_admin/models/DAO/BaseDAO.dart';

import '../../commons/constants/utils/base_api.dart';
import '../../commons/constants/utils/log.dart';
import '../DTO/invoice_dto.dart';
import '../DTO/metadata_dto.dart';

class InvoiceDAO extends BaseDAO {
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
}
