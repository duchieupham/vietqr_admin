import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/numeral.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/commons/constants/env/env_config.dart';

class MenuProvider with ChangeNotifier {
  int _environment = Numeral.ENV_GO_LIVE;

  int get environment => _environment;

  int _initPage = 0;
  int initMenuPage = 0;

  int get initPage => _initPage;

  bool _isShowMenuLink = true;

  bool get showMenuLink => _isShowMenuLink;

  bool _isShowMenu = true;

  bool get showMenu => _isShowMenu;

  MenuType _menuHomeType = MenuType.VNPT_EPAY;

  MenuType get menuHomeType => _menuHomeType;

  SubMenuType _subMenuType = SubMenuType.OTHER;

  SubMenuType get subMenuType => _subMenuType;

  void updateENV(int value) {
    _environment = value;
    notifyListeners();
  }

  void updateShowMenu(bool value) {
    _isShowMenu = value;
    notifyListeners();
  }

  void updateShowMenuLink(bool value) {
    _isShowMenuLink = value;
    notifyListeners();
  }

  void selectSubMenu(SubMenuType value) {
    _subMenuType = value;
    if (value == SubMenuType.RUN_CALLBACK) {
      EnvConfig.instance.updateEnv(EnvType.DEV);
      _environment = Numeral.ENV_TEST;
    }
    changeSubPage(value);
  }

  void changeSubPage(SubMenuType value) {
    switch (value) {
      case SubMenuType.LIST_CONNECT:
      case SubMenuType.SURPLUS:
        _initPage = 0;
        break;
      case SubMenuType.TOP_UP_PHONE:
      case SubMenuType.NEW_CONNECT:
        _initPage = 1;
        break;
      case SubMenuType.RUN_CALLBACK:
        _initPage = 2;
        break;
      case SubMenuType.ACTIVE_FEE:
        _initPage = 3;
        break;
      case SubMenuType.ANNUAL_FEE:
        _initPage = 4;
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
    if (value == MenuType.VNPT_EPAY) {
      EnvConfig.instance.updateEnv(EnvType.GOLIVE);
      updateENV(1);
    }
    _menuHomeType = value;
    changePage(value);
    notifyListeners();
  }

  void changePage(MenuType value) {
    if (value == MenuType.VNPT_EPAY) {
      initMenuPage = 0;
    } else if (value == MenuType.SERVICE_CONNECT) {
      initMenuPage = 1;
    } else if (value == MenuType.INTEGRATION_CONNECTIVITY) {
      initMenuPage = 2;
    } else if (value == MenuType.SERVICE_PACK) {
      initMenuPage = 3;
    } else if (value == MenuType.SERVICE_FEE) {
      initMenuPage = 4;
    } else if (value == MenuType.TRANSACTION) {
      initMenuPage = 5;
    } else if (value == MenuType.MERCHANT_FEE) {
      initMenuPage = 6;
    } else if (value == MenuType.SYSTEM_TRANSACTION) {
      initMenuPage = 7;
    } else if (value == MenuType.LOG) {
      initMenuPage = 8;
    } else if (value == MenuType.CONFIG) {
      initMenuPage = 9;
    } else if (value == MenuType.ACCOUNT_BANK) {
      initMenuPage = 10;
    } else if (value == MenuType.POST) {
      initMenuPage = 11;
    } else if (value == MenuType.PUSH_NOTIFICATION) {
      initMenuPage = 12;
    } else if (value == MenuType.USER) {
      initMenuPage = 13;
    }
  }
}
