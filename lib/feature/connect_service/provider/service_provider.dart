import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/numeral.dart';

class ServiceProvider with ChangeNotifier {
  int _environment = Numeral.ENV_TEST;

  int get environment => _environment;

  int pageIndex = 0;

  void selectedPage(int value) {
    pageIndex = value;
    notifyListeners();
  }

  void updateENV(int value) {
    _environment = value;
    notifyListeners();
  }
}
