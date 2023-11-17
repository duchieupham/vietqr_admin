import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';

class ActiveFeeProvider with ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  DateTime _dateTime = DateTime.now();
  DateTime get currentDate => _dateTime;
  String get dateTime => TimeUtils.instance.formatDateToString(_dateTime);

  int _status = 0;
  int get status => _status;

  List<int> years = [];
  int _year = DateTime.now().year;
  int get year => _year;

  void changeStatus(int value) {
    _status = value;
    notifyListeners();
  }

  void updateYear(int value) {
    _year = value;
    notifyListeners();
  }

  void updateCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void changeDate(DateTime value) {
    _dateTime = value;
    notifyListeners();
  }

  void getListYear() {
    years.clear();
    int intiYear = 2022;
    int currentYear = DateTime.now().year;

    int yearGap = currentYear - intiYear;
    if (yearGap == 1) {
      years = [intiYear, currentYear];
    } else {
      if (yearGap > 1) {
        for (int i = 0; i <= yearGap; i++) {
          years.add(intiYear + i);
        }
      }
    }
  }
}
