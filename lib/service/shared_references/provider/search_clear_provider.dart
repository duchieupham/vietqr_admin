import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/enum/check_type.dart';

class SearchClearProvider extends ValueNotifier {
  SearchClearProvider(super.value);

  void updateClearSearch(bool check) {
    value = check;
  }
}

class SearchProvider with ChangeNotifier {
  TypeAddMember _typeMember = TypeAddMember.MORE;

  TypeAddMember get typeMember => _typeMember;

  void updateExisted(value) {
    _typeMember = value;
    notifyListeners();
  }
}
