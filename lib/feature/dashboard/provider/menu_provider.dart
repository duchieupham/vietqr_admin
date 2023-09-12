import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';

class MenuProvider with ChangeNotifier {
  int _initPage = 0;
  int initMenuPage = 0;

  int get initPage => _initPage;

  bool _isShowMenuLink = false;

  bool get showMenuLink => _isShowMenuLink;

  void updateShowMenuLink(bool value) {
    _isShowMenuLink = value;
    notifyListeners();
  }

  MenuType _menuHomeType = MenuType.USER;

  MenuType get menuHomeType => _menuHomeType;

  SubMenuType _subMenuType = SubMenuType.OTHER;

  SubMenuType get subMenuType => _subMenuType;

  void selectSubMenu(SubMenuType value) {
    _subMenuType = value;
    changeSubPage(value);
    notifyListeners();
  }

  void changeSubPage(SubMenuType value) {
    switch (value) {
      case SubMenuType.LIST_CONNECT:
      case SubMenuType.SURPLUS:
        _initPage = 0;
        break;
      case SubMenuType.NEW_CONNECT:
        _initPage = 1;
        break;
      case SubMenuType.RUN_CALLBACK:
        _initPage = 2;
        break;
      default:
        _initPage = 0;
        break;
    }
    notifyListeners();
  }

  void selectMenu(MenuType value) {
    if (value != _menuHomeType) {
      _initPage = 0;
    }
    _menuHomeType = value;
    changePage(value);
    notifyListeners();
  }

  void changePage(MenuType value) {
    if (value == MenuType.USER) {
      initMenuPage = 0;
    } else if (value == MenuType.ACCOUNT_BANK) {
      initMenuPage = 1;
    } else if (value == MenuType.SERVICE_CONNECT) {
      initMenuPage = 2;
    } else if (value == MenuType.PUSH_NOTIFICATION) {
      initMenuPage = 3;
    } else if (value == MenuType.POST) {
      initMenuPage = 4;
    } else if (value == MenuType.VNPT_EPAY) {
      initMenuPage = 5;
    }
  }
}
