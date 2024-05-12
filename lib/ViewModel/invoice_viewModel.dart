import 'package:vietqr_admin/ViewModel/base_model.dart';

import '../models/DAO/index.dart';

class InvoiceViewModel extends BaseModel {
  late InvoiceDAO _dao;
  int type = 0;

  InvoiceViewModel() {
    _dao = InvoiceDAO();
  }

  void changeType(int value) {
    type = value;
    notifyListeners();
  }
}
