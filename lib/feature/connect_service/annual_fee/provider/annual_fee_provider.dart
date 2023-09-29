import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';

class AnnualFeeProvider with ChangeNotifier {
  List<FilterAnnualFee> listFilter = [
    const FilterAnnualFee(id: 9, title: 'Tất cả'),
    const FilterAnnualFee(id: 0, title: 'Tháng'),
  ];

  FilterAnnualFee _valueFilter = const FilterAnnualFee(id: 9, title: 'Tất cả');
  FilterAnnualFee get valueFilter => _valueFilter;

  DateTime _dateTime = DateTime.now();
  DateTime get currentDate => _dateTime;
  String get dateTime => TimeUtils.instance.formatDateToString(_dateTime);

  void changeDate(DateTime value) {
    _dateTime = value;
    notifyListeners();
  }

  updateFilter(FilterAnnualFee value) {
    _valueFilter = value;
    notifyListeners();
  }
}

class FilterAnnualFee {
  final String title;
  final int id;
  const FilterAnnualFee({required this.id, required this.title});
}
