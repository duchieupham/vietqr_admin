import 'package:intl/intl.dart';
import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/models/DTO/service_fee_dto.dart';

import '../commons/constants/enum/view_status.dart';
import '../commons/constants/utils/log.dart';
import '../models/DAO/ServiceDAO.dart';
import '../models/DTO/metadata_dto.dart';

class ServiceFeeViewModel extends BaseModel {
  late ServiceDAO _dao;
  ServiceFeeDTO? serviceFeeDTO;
  String? value = 'Tất cả';
  int? filterByDate = 0;
  MetaDataDTO? metadata;

  ServiceFeeViewModel() {
    _dao = ServiceDAO();
  }

  void changeType(String? selectType) {
    value = selectType;
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

  Future<void> filterListServiceFee({
    required DateTime time,
    required int page,
    int? size,
  }) async {
    try {
      String formattedDate = '';
      if (filterByDate == 0) {
        formattedDate = DateFormat('yyyy-MM-dd').format(time);
      } else {
        formattedDate = DateFormat('yyyy-MM').format(time);
      }
      setState(ViewStatus.Loading);
      serviceFeeDTO = await _dao.filterServiceList(
          time: formattedDate,
          page: page,
          filterBy: filterByDate!,
          value: value!);
      metadata = _dao.metaDataDTO;
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }
}
