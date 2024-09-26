// ignore_for_file: constant_identifier_names

enum BlocStatus {
  NONE,
  LOADING,
  UNLOADING,
}

enum CallBackType {
  NONE,
  TRANS,
  CUSTOMERS,
  BANKS,
  INFO_CONNECT,
  FREE_TOKEN,
  RUN_CALLBACK,
  ERROR,
  RUN_ERROR,
}

enum CheckType {
  C01,
  C02,
  C03,
  C04,
  C05,
}

enum TypeMoveEvent { LEFT, RIGHT, NONE }

enum TypeAddMember { MORE, ADDED, AWAIT }

extension TypeMemberExt on TypeAddMember {
  int get existed {
    switch (this) {
      case TypeAddMember.MORE:
        return 0;
      case TypeAddMember.ADDED:
        return 1;
      case TypeAddMember.AWAIT:
      default:
        return 2;
    }
  }
}

enum HomeType {
  NONE,
  TOKEN,
  GET_LIST,
  UPLOAD,
  ERROR,
}

enum TokenType {
  NONE,
  InValid,
  Valid,
  MainSystem,
  Internet,
  Expired,
  Logout,
  Logout_failed,
  Fcm_success,
  Fcm_failed,
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
        return 2;
      case TypeTimeFilter.SEVEN_LAST_DAY:
        return 1;
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


