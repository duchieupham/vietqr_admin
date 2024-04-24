import 'package:intl/intl.dart';
import 'package:vietqr_admin/ViewModel/base_model.dart';

import '../commons/constants/enum/view_status.dart';
import '../commons/constants/utils/log.dart';
import '../models/DAO/UserRechargeDAO.dart';
import '../models/DTO/data_filter_dto.dart';
import '../models/DTO/metadata_dto.dart';
import '../models/DTO/user_recharge_dto.dart';

class UserRechargeViewModel extends BaseModel {
  late UserRechargeDAO _dao;
  UserRechargeDTO? dto;
  int? type = 9;
  int? filterBy = 9;
  String _from = '';
  String _to = '';
  String value = '';
  MetaDataDTO? metadata;

  List<DataFilter> listFilterByTime = [
    const DataFilter(id: 1, name: '7 ngày gần nhất'),
    const DataFilter(id: 2, name: '30 ngày gần nhất'),
    const DataFilter(id: 3, name: 'Tháng'),
  ];

  DataFilter filterByTime = const DataFilter(id: 1, name: '7 ngày gần nhất');

  UserRechargeViewModel() {
    _dao = UserRechargeDAO();
  }

  DateTime getPreviousMonth() {
    DateTime now = DateTime.now();
    int newMonth = now.month - 1;
    int newYear = now.year;

    if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }

    return DateTime(newYear, newMonth);
  }

  void changeType({int? selectType}) {
    type = selectType;
    notifyListeners();
  }

  void changeFilterBy({int? selectFilterBy}) {
    filterBy = selectFilterBy;
    notifyListeners();
  }

  void changeFilterByTime({DataFilter? filter}) {
    filterByTime = filter!;
    notifyListeners();
  }

  void getSelectMoth(DateTime date) {
    DateTime firstDay = DateTime(date.year, date.month, 1);
    DateTime lastDay = DateTime(date.year, date.month + 1, 0);
    _from = DateFormat('yyyy-MM-dd 00:00:00').format(firstDay);
    _to = DateFormat('yyyy-MM-dd 23:59:59').format(lastDay);
  }

  Future<void> filterUserRecharge({
    required int page,
    required String value,
  }) async {
    try {
      setState(ViewStatus.Loading);
      DateTime now = DateTime.now();
      switch (filterByTime.id) {
        case 1:
          DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));
          DateTime sevenDaysAgoWithExactTime =
              DateTime(sevenDaysAgo.year, sevenDaysAgo.month, sevenDaysAgo.day);
          _from = DateFormat('yyyy-MM-dd 00:00:00')
              .format(sevenDaysAgoWithExactTime);
          _to = DateFormat('yyyy-MM-dd 23:59:59').format(now);
          break;
        case 2:
          DateTime previousMonth = DateTime(now.year, now.month - 1, 1);
          DateTime lastDayOfMonth =
              DateTime(now.year, previousMonth.month + 1, 0);
          _from = DateFormat('yyyy-MM-dd 00:00:00').format(previousMonth);
          _to = DateFormat('yyyy-MM-dd 23:59:59').format(lastDayOfMonth);
          break;
        default:
          break;
      }
      dto = await _dao.filterRechargeList(
          from: _from,
          to: _to,
          type: value.isEmpty ? 9 : type!,
          page: page,
          filterBy: filterBy!,
          value: value.isNotEmpty ? value : '');
      metadata = _dao.metaDataDTO;

      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }
}
