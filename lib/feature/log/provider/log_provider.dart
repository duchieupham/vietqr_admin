import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';

class LogProvider with ChangeNotifier {
  DateTime _dateTime = DateTime.now();
  DateTime get currentDate => _dateTime;
  String get dateTime => TimeUtils.instance.formatDateToString(_dateTime);
  StreamSubscription? _subscription;
  init() {
    _subscription = eventBus.on<ResetDateLog>().listen((data) {
      resetDate();
    });
  }

  void changeDate(DateTime value) {
    _dateTime = value;
    notifyListeners();
  }

  void resetDate() {
    _dateTime = DateTime.now();
    notifyListeners();
  }
}
