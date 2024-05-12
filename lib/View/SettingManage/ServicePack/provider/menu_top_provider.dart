import 'package:flutter/material.dart';

class MenuTopProvider with ChangeNotifier {
  int _page = 0;
  int get page => _page;

  changePage(int value) {
    _page = value;
    notifyListeners();
  }
}
