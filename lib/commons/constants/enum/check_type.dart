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
