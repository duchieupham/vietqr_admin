import 'package:flutter/material.dart';

class FormCreateProvider with ChangeNotifier {
  List<GDItem> listTypeGD = [
    const GDItem(title: 'Tất cả', id: 0),
    const GDItem(title: 'Chỉ GD có đối soát', id: 0)
  ];
  GDItem _typeGD = const GDItem(title: 'Tất cả', id: 0);
  GDItem get typeGD => _typeGD;

  TextEditingController packCodeCtrl = TextEditingController();
  TextEditingController packNameCtrl = TextEditingController();
  TextEditingController activeFeeCtrl = TextEditingController();
  TextEditingController annualFeeCtrl = TextEditingController();
  TextEditingController monthlyCycleCtrl = TextEditingController();
  TextEditingController transFeeCtrl = TextEditingController();
  TextEditingController percentFeeCtrl = TextEditingController();
  TextEditingController vatCtrl = TextEditingController();
  TextEditingController desCtrl = TextEditingController();

  void updateTypeGd(GDItem value) {
    _typeGD = value;
    notifyListeners();
  }

  bool isValidForm() {
    if (packCodeCtrl.text.isEmpty ||
        packNameCtrl.text.isEmpty ||
        activeFeeCtrl.text.isEmpty ||
        annualFeeCtrl.text.isEmpty ||
        monthlyCycleCtrl.text.isEmpty ||
        transFeeCtrl.text.isEmpty ||
        percentFeeCtrl.text.isEmpty ||
        desCtrl.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  clearForm() {
    packCodeCtrl.clear();
    packNameCtrl.clear();
    activeFeeCtrl.clear();
    annualFeeCtrl.clear();
    monthlyCycleCtrl.clear();
    transFeeCtrl.clear();
    percentFeeCtrl.clear();
    desCtrl.clear();
    vatCtrl.clear();
    _typeGD = const GDItem(title: 'Tất cả', id: 0);
    notifyListeners();
  }
}

class GDItem {
  final String title;
  final int id;
  const GDItem({this.id = 0, this.title = ''});
}
