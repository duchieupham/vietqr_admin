import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/numeral.dart';

class ListConnectProvider with ChangeNotifier {
  int _environment = Numeral.ENV_TEST;
  int get environment => _environment;

  void updateENV(int value) {
    _environment = value;
    notifyListeners();
  }
}
