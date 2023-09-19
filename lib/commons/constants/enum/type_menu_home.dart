// ignore_for_file: constant_identifier_names

enum MenuType {
  USER,
  ACCOUNT_BANK,
  SERVICE_CONNECT,
  PUSH_NOTIFICATION,
  POST,
  TRANSACTION,
  LOG,
  VNPT_EPAY,
  LOGOUT,
  OTHER,
}

enum SubMenuType {
  LIST_CONNECT,
  NEW_CONNECT,
  RUN_CALLBACK,
  SURPLUS,
  OTHER,
}

extension PageSubMenu on SubMenuType {
  int get pageNumber {
    switch (this) {
      case SubMenuType.LIST_CONNECT:
      case SubMenuType.SURPLUS:
        return 0;
      case SubMenuType.NEW_CONNECT:
        return 1;
      case SubMenuType.RUN_CALLBACK:
        return 2;
      default:
        return 0;
    }
  }
}
