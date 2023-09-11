import 'package:flutter/material.dart';

class ConnectInfoProvider with ChangeNotifier {
  bool _showPassUser = false;
  bool get showPassUser => _showPassUser;

  bool _showPassSystem = false;
  bool get showPassSystem => _showPassSystem;

  void updateShowPassUser(bool value) {
    _showPassUser = value;
    notifyListeners();
  }

  void updateShowPassSystem(bool value) {
    _showPassSystem = value;
    notifyListeners();
  }
}
