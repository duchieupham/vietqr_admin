// ignore_for_file: constant_identifier_names

enum MenuType {
  USER,
  ACCOUNT_BANK,
  SERVICE_CONNECT,
  PUSH_NOTIFICATION,
  POST,
  INTEGRATION_CONNECTIVITY,
  TRANSACTION,
  LOG,
  VNPT_EPAY,
  SERVICE_PACK,
  CONFIG,
  LOGOUT,
  OTHER,
}

enum SubMenuType {
  LIST_CONNECT,
  NEW_CONNECT,
  RUN_CALLBACK,
  SURPLUS,
  TOP_UP_PHONE,
  ACTIVE_FEE,
  ANNUAL_FEE,
  LARK_WEB_HOOK,
  OTHER,
}

extension PageSubMenu on SubMenuType {
  int get pageNumber {
    switch (this) {
      case SubMenuType.LIST_CONNECT:
      case SubMenuType.LARK_WEB_HOOK:
      case SubMenuType.NEW_CONNECT:
      case SubMenuType.SURPLUS:
        return 0;
      case SubMenuType.TOP_UP_PHONE:
      case SubMenuType.RUN_CALLBACK:
        return 1;
      case SubMenuType.ACTIVE_FEE:
        return 3;
      case SubMenuType.ANNUAL_FEE:
        return 4;
      default:
        return 0;
    }
  }
}
