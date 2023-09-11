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
    if (value == SubMenuType.LIST_CONNECT) {
      _initPage = 0;
    } else if (value == SubMenuType.NEW_CONNECT) {
      _initPage = 1;
    } else if (value == SubMenuType.RUN_CALLBACK) {
      _initPage = 2;
    } else if (value == SubMenuType.SURPLUS) {
      _initPage = 3;
    }
  }

  void selectMenu(MenuType value) {
    _menuHomeType = value;
    changePage(value);
    notifyListeners();
  }

  void changePage(MenuType value, {bool isFirst = false}) {
    if (value == MenuType.USER) {
      if (isFirst) {}
      initMenuPage = 0;
    } else if (value == MenuType.ACCOUNT_BANK) {
      initMenuPage = 1;
    } else if (value == MenuType.SERVICE_CONNECT) {
      if (isFirst) {
        selectSubMenu(SubMenuType.LIST_CONNECT);
      }
      initMenuPage = 2;
    } else if (value == MenuType.PUSH_NOTIFICATION) {
      initMenuPage = 3;
    } else if (value == MenuType.POST) {
      initMenuPage = 4;
    } else if (value == MenuType.VNPT_EPAY) {
      if (isFirst) {
        selectSubMenu(SubMenuType.SURPLUS);
      }
      initMenuPage = 5;
    }
  }
}
