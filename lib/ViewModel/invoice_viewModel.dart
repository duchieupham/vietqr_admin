import 'package:intl/intl.dart';
import 'package:vietqr_admin/ViewModel/base_model.dart';

import '../commons/constants/enum/view_status.dart';
import '../commons/constants/utils/log.dart';
import '../models/DAO/index.dart';
import '../models/DTO/invoice_dto.dart';
import '../models/DTO/metadata_dto.dart';

class InvoiceViewModel extends BaseModel {
  late InvoiceDAO _dao;
  InvoiceDTO? invoiceDTO;
  int type = 0;
  int? value = 9;
  int? valueStatus = 0;
  int? filterByDate = 1;
  MetaDataDTO? metadata;

  InvoiceViewModel() {
    _dao = InvoiceDAO();
  }

  void changeType(int value) {
    type = value;
    notifyListeners();
  }

  void changeTypeInvoice(int? selectType) {
    value = selectType;
    notifyListeners();
  }

  void changeStatus(int? selectType) {
    valueStatus = selectType;
    notifyListeners();
  }

  DateTime getPreviousMonth() {
    DateTime now = DateTime.now();
    int newMonth = now.month - 1;
    int newYear = now.year;

    if (newMonth < 1) {
      newMonth = 12; // Set month to December
      newYear--; // Decrement year
    }

    return DateTime(newYear, newMonth);
  }

  Future<void> filterListInvoice({
    required DateTime time,
    required int page,
    int? size,
  }) async {
    try {
      String formattedDate = '';
      formattedDate = DateFormat('yyyy-MM').format(time);
      setState(ViewStatus.Loading);
      invoiceDTO = await _dao.filterInvoiceList(
          type: value!, time: formattedDate, page: page, value: value!);
      metadata = _dao.metaDataDTO;
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }
}
