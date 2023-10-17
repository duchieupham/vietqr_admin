import 'package:flutter/material.dart';

class LarkProvider with ChangeNotifier {
  bool _showAddForm = false;
  bool get showAddForm => _showAddForm;

  void updateShowForm(bool value) {
    _showAddForm = value;
    notifyListeners();
  }
}
