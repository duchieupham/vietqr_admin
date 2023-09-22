import 'dart:async';

import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietqr_admin/models/connect.dto.dart';

class Session {
  static final Session _singleton = Session._privateConstructor();

  Session._privateConstructor();

  static Future<Session> get load async {
    await _singleton.init();
    return _singleton;
  }

  late SharedPreferences sharedPrefs;
  static Session get instance => _singleton;
  final _initSession = AsyncMemoizer();
  Future init() => _initSession.runOnce(_init);

  Future _init() async {
    // muốn khởi tạo những gì khi mới vào app sẽ viết ở đây
  }

  String _transactionId = '';
  String get transactionId => _transactionId;

  void updateTransactionId(String value) {
    _transactionId = value;
  }

  ConnectDTO _connectDTO = const ConnectDTO();
  ConnectDTO get connectDTO => _connectDTO;
  void updateConnectDTO(ConnectDTO value) {
    _connectDTO = value;
  }
}
