import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';

class ActiveFeeProvider with ChangeNotifier {
  List<FilterActiveFee> listFilter = [
    const FilterActiveFee(id: 9, title: 'Tất cả'),
    const FilterActiveFee(id: 0, title: 'Tháng'),
  ];

  FilterActiveFee _valueFilter = const FilterActiveFee(id: 9, title: 'Tất cả');
  FilterActiveFee get valueFilter => _valueFilter;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  DateTime _dateTime = DateTime.now();
  DateTime get currentDate => _dateTime;
  String get dateTime => TimeUtils.instance.formatDateToString(_dateTime);

  void updateCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void changeDate(DateTime value) {
    _dateTime = value;
    notifyListeners();
  }

  updateFilter(FilterActiveFee value) {
    _valueFilter = value;
    notifyListeners();
  }
}

class FilterActiveFee {
  final String title;
  final int id;
  const FilterActiveFee({required this.id, required this.title});
}
