import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/models/active_fee_dto.dart';

class ActiveFeeProvider with ChangeNotifier {
  List<FilterActiveFee> listFilter = [
    const FilterActiveFee(id: 9, title: 'Tất cả'),
    const FilterActiveFee(id: 0, title: 'Tháng'),
  ];

  FilterActiveFee _valueFilter = const FilterActiveFee(id: 9, title: 'Tất cả');
  FilterActiveFee get valueFilter => _valueFilter;

  List<FilterActiveFee> listFilterType = [
    const FilterActiveFee(id: 0, title: 'Merchant'),
    const FilterActiveFee(id: 1, title: 'BankAccount'),
  ];
  FilterActiveFee _valueFilterType =
      const FilterActiveFee(id: 0, title: 'Merchant');

  FilterActiveFee get valueFilterType => _valueFilterType;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  DateTime _dateTime = DateTime.now();
  DateTime get currentDate => _dateTime;
  String get dateTime => TimeUtils.instance.formatDateToString(_dateTime);

  List<ActiveFeeDTO> _listActiveFeeDTO = [];
  List<ActiveFeeDTO> get listActiveFeeDTO => _listActiveFeeDTO;

  List<ActiveFeeBankDTO> _bankAccounts = [];
  List<ActiveFeeBankDTO> get bankAccounts => _bankAccounts;

  void updateCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  updateListData(List<ActiveFeeDTO> list) {
    _listActiveFeeDTO = list;
    notifyListeners();

    List<ActiveFeeBankDTO> listBank = [];
    for (var element in list) {
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
