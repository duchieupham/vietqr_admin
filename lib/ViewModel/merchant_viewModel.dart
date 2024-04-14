import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/models/DTO/merchant_dto.dart';

import '../commons/constants/utils/log.dart';
import '../models/DAO/MerchantDAO.dart';

class MerchantViewModel extends BaseModel {
  late MerchantDAO _dao;
  List<MerchantDTO>? listMerchant;
  int? type = 0;

  MerchantViewModel() {
    _dao = MerchantDAO();
  }

  void changeType(int? selectType) {
    type = selectType;
    notifyListeners();
  }

  Future<void> filterListMerchant({
    required String time,
    required int type,
    required int page,
    int? size,
    required int filterBy,
    required String value,
  }) async {
    try {
      setState(ViewStatus.Loading);
      listMerchant = await _dao.filterMerchantList(
          time: time, type: type, page: page, filterBy: filterBy, value: value);
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }
}
