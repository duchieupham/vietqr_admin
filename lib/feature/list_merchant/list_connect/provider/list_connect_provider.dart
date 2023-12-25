import 'package:flutter/material.dart';

class ListConnectProvider with ChangeNotifier {
  int _page = 0;
  int get page => _page;

  List<FilterTransaction> listFilter = [
    const FilterTransaction(id: 9, title: 'Tất cả'),
    const FilterTransaction(id: 0, title: 'API Service'),
    const FilterTransaction(id: 1, title: 'Ecommerce'),
  ];
  FilterTransaction _valueFilter =
      const FilterTransaction(id: 9, title: 'Tất cả');

  FilterTransaction get valueFilter => _valueFilter;

  void changeFilter(FilterTransaction value) {
    _valueFilter = value;
    notifyListeners();
  }

  void changePage(int page) {
    _page = page;
    notifyListeners();
  }
}

class FilterTransaction {
  final String title;
  final int id;
  const FilterTransaction({required this.id, required this.title});
}
