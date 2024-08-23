import 'package:vietqr_admin/ViewModel/base_model.dart';

class RootViewModel extends BaseModel {
  int _pinLength = 0;

  get pinLength => _pinLength;

  RootViewModel();

  void updatePinLength(int length) {
    _pinLength = length;
    notifyListeners();
  }

  void reset() {
    _pinLength = 0;
    notifyListeners();
  }
}
