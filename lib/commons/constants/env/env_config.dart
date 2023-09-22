// ignore_for_file: constant_identifier_names

import 'package:vietqr_admin/commons/constants/env/dev_evn.dart';
import 'package:vietqr_admin/commons/constants/env/go_live_env.dart';

class EnvConfig {
  const EnvConfig._privateConstructor();

  static const EnvConfig _instance = EnvConfig._privateConstructor();

  static EnvConfig get instance => _instance;
  static EnvType _currentEnv = EnvType.GOLIVE;

  static EnvType get currentEnv => _currentEnv;

  String getBaseUrl() {
    if (_currentEnv == EnvType.GOLIVE) {
      return GoLiveEnv().getBaseUrl();
    } else {
      return DevEnv().getBaseUrl();
    }
  }

  void updateEnv(EnvType type) {
    _currentEnv = type;
  }
}

enum EnvType {
  GOLIVE,
  DEV,
}
