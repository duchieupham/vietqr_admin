import 'package:flutter/material.dart';

import '../../../models/DTO/service_pack_dto.dart';

class ServicePackProvider with ChangeNotifier {
  List<ServicePackDTO> _listServicePack = [];
  List<ServicePackDTO> get listServicePack => _listServicePack;

  List<Map<String, dynamic>> _itemHasExpand = [];
  List<Map<String, dynamic>> get itemHasExpand => _itemHasExpand;

  List<Map<String, dynamic>> _itemHasFormInsert = [];
  List<Map<String, dynamic>> get itemHasFormInsert => _itemHasFormInsert;

  init(List<ServicePackDTO> value) {
    _listServicePack = value;
    _itemHasExpand.clear();
    _itemHasFormInsert.clear();
    for (ServicePackDTO item in value) {
      addDataShowFormInsert(item.item!);
      if (item.subItems?.isNotEmpty ?? false) {
        addDataExpandListSub(item.item!);
      }
    }
  }

  void updateListServicePack(List<ServicePackDTO> value) {
    _listServicePack = value;
    for (ServicePackDTO item in value) {
      if (item.subItems?.isNotEmpty ?? false) {
        addDataExpandListSub(item.item!);
      }
    }
    notifyListeners();
  }

  addDataShowFormInsert(SubServicePackDTO item) {
    Map<String, dynamic> paramFormInsert = {};
    paramFormInsert['itemId'] = item.id;
    paramFormInsert['showFormInsert'] = false;
    _itemHasFormInsert.add(paramFormInsert);
  }

  addDataExpandListSub(SubServicePackDTO item) {
    Map<String, dynamic> param = {};
    param['itemId'] = item.id;
    param['expand'] = false;

    if (_itemHasExpand.isEmpty) {
      _itemHasExpand.add(param);
    } else {
      if (!_itemHasExpand.map((item) => item['itemId']).contains(item.id)) {
        _itemHasExpand.add(param);
      }

      // for (Map<String, dynamic> data in _itemHasExpand) {
      //   if (data['itemId'] != item.id) {
      //     _itemHasExpand.add(param);
      //   }
      // }
    }
  }

  expandListSubItem(SubServicePackDTO item) {
    for (Map<String, dynamic> value in _itemHasExpand) {
      if (value['itemId'] == item.id) {
        value['expand'] = !value['expand'];
      }
    }
    notifyListeners();
  }

  bool showListSubItem(SubServicePackDTO item) {
    for (Map<String, dynamic> value in _itemHasExpand) {
      if (value['itemId'] == item.id) {
        if (value['expand']) {
          return true;
        }
      }
    }
    return false;
  }

  bool checkShowFromInsert(SubServicePackDTO item) {
    for (Map<String, dynamic> value in _itemHasFormInsert) {
      if (value['itemId'] == item.id) {
        if (value['showFormInsert']) {
          return true;
        }
      }
    }
    return false;
  }

  showFromInsert(String itemId) {
    for (Map<String, dynamic> value in _itemHasFormInsert) {
      if (value['itemId'] == itemId) {
        value['showFormInsert'] = !value['showFormInsert'];
      }
    }
    notifyListeners();
  }
}
