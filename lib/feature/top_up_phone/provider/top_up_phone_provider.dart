import 'package:flutter/material.dart';

class TopUpPhoneProvider with ChangeNotifier {
  List<FilterStatus> listStatusFilter = [
    const FilterStatus(id: 9, title: 'Tất cả'),
    const FilterStatus(id: 0, title: 'Chờ thanh toán'),
    const FilterStatus(id: 1, title: 'Thành công'),
    const FilterStatus(id: 2, title: 'Đã huỷ'),
  ];

  FilterStatus _valueStatusFilter = const FilterStatus(id: 9, title: 'Tất cả');
  FilterStatus get valueStatusFilter => _valueStatusFilter;
  //
  // List<FilterTime> listTimeFilter = [
  //   const FilterTime(id: 0, title: 'Tất cả'),
  //   const FilterTime(id: 1, title: 'Khoảng thời gian'),
  // ];
  // FilterTime _valueTimeFilter = const FilterTime(id: 0, title: 'Tất cả');
  // FilterTime get valueTimeFilter => _valueTimeFilter;

  List<int> listPage = [0, 1];
  int _currentPage = 0;
  int get currentPage => _currentPage;

  void changeFilter(FilterStatus value) {
    _valueStatusFilter = value;
    _currentPage = 0;
    listPage = [0, 1];
    notifyListeners();
  }

  resetFilter() {
    _valueStatusFilter = const FilterStatus(id: 9, title: 'Tất cả');
    _currentPage = 0;
    listPage = [0, 1];
    notifyListeners();
  }

  choosePage(int page) {
    _currentPage = page;
    if (listPage.last == page) {
      listPage.add(listPage.last + 1);
    }
    notifyListeners();
  }
}

class FilterStatus {
  final String title;
  final int id;
  const FilterStatus({required this.id, required this.title});
}

class FilterTime {
  final String title;
  final int id;
  const FilterTime({required this.id, required this.title});
}
