import 'package:intl/intl.dart';
import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/models/DAO/SystemTransactionDAO.dart';
import 'package:vietqr_admin/models/DTO/system_transaction_dto.dart';

import '../commons/constants/utils/log.dart';
import '../models/DTO/metadata_dto.dart';

class SystemTransactionViewModel extends BaseModel {
  late SysTemTransactionDAO _dao;
  SystemTransactionDTO? systemTransactionDTO;
  int? type = 0;
  int? filterByDate = 0;
  MetaDataDTO? metadata;

  SystemTransactionViewModel() {
    _dao = SysTemTransactionDAO();
  }

  void changeType(int? selectType) {
    type = selectType;
    notifyListeners();
  }

  void changeTime(int? selectTime) {
    filterByDate = selectTime;
    notifyListeners();
  }

  DateTime getPreviousDay() {
    DateTime now = DateTime.now();
    int newMonth = now.month;
    int newYear = now.year;
    int newDay = now.day - 1;

    if (newMonth < 1) {
      newMonth = 12; // Set month to December
      newYear--; // Decrement year
    }

    return DateTime(newYear, newMonth, newDay);
  }

  DateTime getPreviousYear() {
    DateTime now = DateTime.now();
    int newYear = now.year;

    return DateTime(newYear);
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

  Future<void> filterListSystemTransaction({
    required DateTime time,
    required int page,
    int? size,
  }) async {
    try {
      String formattedDate = '';
      if (filterByDate == 0) {
        formattedDate = DateFormat('yyyy-MM').format(time);
      } else {
        formattedDate = DateFormat('yyyy').format(time);
      }
      setState(ViewStatus.Loading);
      systemTransactionDTO = await _dao.filterSystemTransactionList(
        time: formattedDate,
        type: type!,
        page: page,
        filterBy: filterByDate!,
      );
      metadata = _dao.metaDataDTO;
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }
}
