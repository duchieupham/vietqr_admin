import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/feature/list_merchant/active_fee/responsitory/active_fee_repository.dart';

import '../../../../models/DTO/active_fee_dto.dart';

class ActiveFeeProvider with ChangeNotifier {
  List<FilterActiveFee> listFilter = [
    const FilterActiveFee(id: 9, title: 'Tất cả'),
    const FilterActiveFee(id: 0, title: 'Tháng'),
  ];

  FilterActiveFee _valueFilter = const FilterActiveFee(id: 9, title: 'Tất cả');
  FilterActiveFee get valueFilter => _valueFilter;

  List<FilterActiveFee> listFilterType = [
    const FilterActiveFee(id: 0, title: 'Merchant'),
    const FilterActiveFee(id: 1, title: 'Số tài khoản'),
  ];
  FilterActiveFee _valueFilterType =
      const FilterActiveFee(id: 1, title: 'Số tài khoản');

  FilterActiveFee get valueFilterType => _valueFilterType;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  DateTime _dateTime = DateTime.now();
  DateTime get currentDate => _dateTime;
  String get dateTime => TimeUtils.instance.formatDateToString(_dateTime);

  List<ActiveFeeItemDTO> _listActiveFeeDTO = [];
  List<ActiveFeeItemDTO> get listActiveFeeDTO => _listActiveFeeDTO;

  List<ActiveFeeBankDTO> _bankAccounts = [];
  List<ActiveFeeBankDTO> get bankAccounts => _bankAccounts;

  ActiveFeeRepository activeFeeRepository = const ActiveFeeRepository();
  String nowMonth = '';

  void updateCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  updateListData(ActiveFeeDTO dto) {
    _listActiveFeeDTO = dto.list ?? [];
    notifyListeners();

    List<ActiveFeeBankDTO> listBank = [];
    for (var element in _listActiveFeeDTO) {
      listBank.addAll(element.bankAccounts!);
      _bankAccounts = listBank;
    }
  }

  void changeDate(DateTime value) {
    _dateTime = value;
    notifyListeners();
  }

  updateFilter(FilterActiveFee value) {
    _valueFilter = value;
    notifyListeners();
  }

  updateFilterType(FilterActiveFee value) {
    _valueFilterType = value;
    notifyListeners();
  }
}

class FilterActiveFee {
  final String title;
  final int id;
  const FilterActiveFee({required this.id, required this.title});
}
