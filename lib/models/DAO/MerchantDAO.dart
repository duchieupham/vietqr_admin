import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/DAO/BaseDAO.dart';
import 'package:http/http.dart' as http;
import '../DTO/merchant_dto.dart';

class MerchantDAO extends BaseDAO {
  Future<MerchantDTO?> filterMerchantList() async {
    try {} on http.ClientException catch (e) {
      LOG.error(e.toString());
    }
  }
}
