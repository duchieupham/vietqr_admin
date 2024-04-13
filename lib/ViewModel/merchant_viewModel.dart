import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';

import '../models/DAO/MerchantDAO.dart';

class MerchantViewModel extends BaseModel {
  late MerchantDAO _dao;

  MerchantViewModel() {
    _dao = MerchantDAO();
  }

  Future<void> filterListMerchant() async {
    try {
      setState(ViewStatus.Loading);
      
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error);
    }
  }
}
