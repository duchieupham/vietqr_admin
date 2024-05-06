import 'package:intl/intl.dart';
import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/models/DTO/merchant_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';

import '../commons/constants/utils/log.dart';
import '../models/DAO/MerchantDAO.dart';

class MerchantViewModel extends BaseModel {
  late MerchantDAO _dao;
  MerchantDTO? merchantDTO;
  int? type = 0;
  int? filterByDate = 0;
  MetaDataDTO? metadata;

  MerchantViewModel() {
    _dao = MerchantDAO();
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

  Future<void> filterListMerchant({
    required DateTime time,
    required int page,
    int? size,
    required String value,
  }) async {
    try {
      String formattedDate = '';
      if (filterByDate == 0) {
        formattedDate = DateFormat('yyyy-MM-dd').format(time);
      } else {
        formattedDate = DateFormat('yyyy-MM').format(time);
      }
      setState(ViewStatus.Loading);
      merchantDTO = await _dao.filterMerchantList(
          time: formattedDate,
          type: value.isEmpty ? 9 : type!,
          page: page,
          filterBy: filterByDate!,
          value: value);
      metadata = _dao.metaDataDTO;
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }
}
