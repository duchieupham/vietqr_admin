import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  List<FilterTransaction> listFilter = [
    const FilterTransaction(id: 9, title: 'Tất cả'),
    const FilterTransaction(id: 0, title: 'Số tài khoản'),
    const FilterTransaction(id: 1, title: 'Mã giao dịch'),
    const FilterTransaction(id: 2, title: 'Order ID'),
    const FilterTransaction(id: 3, title: 'Nội dung')
  ];

  FilterTransaction _valueFilter =
      const FilterTransaction(id: 9, title: 'Tất cả');
  FilterTransaction get valueFilter => _valueFilter;

  List<FilterTimeTransaction> listTimeFilter = [
    const FilterTimeTransaction(id: 0, title: 'Tất cả'),
    const FilterTimeTransaction(id: 1, title: 'Khoảng thời gian'),
  ];
  FilterTimeTransaction _valueTimeFilter =
      const FilterTimeTransaction(id: 0, title: 'Tất cả');
  FilterTimeTransaction get valueTimeFilter => _valueTimeFilter;
  DateTime _toDate = DateTime.now();
  DateTime get toDate => _toDate;

  DateTime _formDate = DateTime.now();
  DateTime get fromDate => _formDate;

  String _keywordSearch = '';
  String get keywordSearch => _keywordSearch;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  resetFilter() {
    _valueFilter = const FilterTransaction(id: 9, title: 'Tất cả');
    _valueTimeFilter = const FilterTimeTransaction(id: 0, title: 'Tất cả');
    notifyListeners();
  }

  void changeFilter(FilterTransaction value) {
    _valueFilter = value;
    if (_valueFilter.id == 9) {
      _valueTimeFilter = const FilterTimeTransaction(id: 0, title: 'Tất cả');
    }
    notifyListeners();
  }

  void changeTimeFilter(FilterTimeTransaction value) {
    _valueTimeFilter = value;
    notifyListeners();
  }

  updateKeyword(String value) {
    _keywordSearch = value;
  }

  void updateFromDate(DateTime value) {
    _formDate = value;
    notifyListeners();
  }

  void updateToDate(DateTime value) {
    _toDate = value;
    notifyListeners();
  }

  void updateCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }
}

class FilterTransaction {
  final String title;
  final int id;
  const FilterTransaction({required this.id, required this.title});
}

class FilterTimeTransaction {
  final String title;
  final int id;
  const FilterTimeTransaction({required this.id, required this.title});
}
