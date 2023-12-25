import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';

class MenuConnectivityProvider with ChangeNotifier {
  int _initPage = 0;

  int get initPage => _initPage;

  void changeSubPage(SubMenuType value) {
    switch (value) {
      case SubMenuType.NEW_CONNECT:
        _initPage = 0;
        break;
      case SubMenuType.RUN_CALLBACK:
        _initPage = 1;
        break;

      default:
        _initPage = 0;
        break;
    }
    notifyListeners();
  }
}
