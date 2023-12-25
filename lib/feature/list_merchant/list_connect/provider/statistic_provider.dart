import 'package:flutter/material.dart';

class StatisticProvider with ChangeNotifier {
  List<FilterStatistic> listFilter = [
    const FilterStatistic(id: 9, title: 'Tất cả'),
    const FilterStatistic(id: 0, title: 'Tháng'),
  ];

  FilterStatistic _valueFilter = const FilterStatistic(id: 9, title: 'Tất cả');
  FilterStatistic get valueFilter => _valueFilter;

  DateTime _month = DateTime.now();
  DateTime get month => _month;

  updateFilter(FilterStatistic value) {
    _valueFilter = value;
    notifyListeners();
  }

  updateMonth(DateTime value) {
    _month = value;
    notifyListeners();
  }
}

class FilterStatistic {
  final String title;
  final int id;
  const FilterStatistic({required this.id, required this.title});
}
