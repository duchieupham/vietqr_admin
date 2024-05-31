import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

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
    const FilterTimeTransaction(id: 1, title: 'Hôm nay'),
    const FilterTimeTransaction(id: 2, title: '7 ngày gần nhất'),
    const FilterTimeTransaction(id: 3, title: '30 ngày gần nhất'),
    const FilterTimeTransaction(id: 4, title: '3 tháng gần nhất'),
    const FilterTimeTransaction(id: 5, title: 'Khoảng thời gian'),
  ];
  FilterTimeTransaction _valueTimeFilter =
      const FilterTimeTransaction(id: 2, title: '7 ngày gần nhất');
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
    DateTime now = DateTime.now();
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    if (value.id == TypeTimeFilter.PERIOD.id) {
      DateTime endDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (value.id == TypeTimeFilter.TODAY.id) {
      DateTime endDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (value.id == TypeTimeFilter.SEVEN_LAST_DAY.id) {
      DateTime endDate = fromDate.subtract(const Duration(days: 7));

      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(endDate);
      updateToDate(fromDate);
    } else if (value.id == TypeTimeFilter.THIRTY_LAST_DAY.id) {
      DateTime endDate = fromDate.subtract(const Duration(days: 30));

      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(endDate);
      updateToDate(fromDate);
    } else if (value.id == TypeTimeFilter.THREE_MONTH_LAST_DAY.id) {
      // DateTime endDate = Jiffy(fromDate).subtract(months: 3).dateTime;
      DateTime endDate =
          Jiffy.parseFromDateTime(fromDate).subtract(months: 3).dateTime;
      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(endDate);
      updateToDate(fromDate);
    }
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

enum TypeTimeFilter {
  ALL,
  TODAY,
  SEVEN_LAST_DAY,
  THIRTY_LAST_DAY,
  THREE_MONTH_LAST_DAY,
  PERIOD,
  NONE
}

extension TypeTimeFilterExt on TypeTimeFilter {
  int get id {
    switch (this) {
      case TypeTimeFilter.ALL:
        return 0;
      case TypeTimeFilter.TODAY:
        return 1;
      case TypeTimeFilter.SEVEN_LAST_DAY:
        return 2;
      case TypeTimeFilter.THIRTY_LAST_DAY:
        return 3;
      case TypeTimeFilter.THREE_MONTH_LAST_DAY:
        return 4;
      case TypeTimeFilter.PERIOD:
        return 5;
      default:
        return 0;
    }
  }
}

enum TypeFilter {
  ALL,
  BANK_NUMBER,
  TRANS_CODE,
  ORDER_ID,
  CONTENT,
  CODE_SALE,
  NONE
}

extension TypeFilterExt on int {
  TypeFilter get type {
    switch (this) {
      case 9:
        return TypeFilter.ALL;
      case 0:
        return TypeFilter.BANK_NUMBER;
      case 1:
        return TypeFilter.TRANS_CODE;
      case 2:
        return TypeFilter.ORDER_ID;
      case 3:
        return TypeFilter.CONTENT;
      case 4:
        return TypeFilter.CODE_SALE;
      default:
        return TypeFilter.NONE;
    }
  }
}
