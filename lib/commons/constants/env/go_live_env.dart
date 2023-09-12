// import 'package:firebase_core/firebase_core.dart';

import 'package:vietqr_admin/commons/constants/env/evn.dart';

class GoLiveEnv implements Env {
  @override
  String getBankUrl() {
    return 'https://api-sandbox.mbbank.com.vn/';
  }

  @override
  String getBaseUrl() {
    return 'https://api.vietqr.org/vqr/api/';
  }

  @override
  String getUrl() {
    return 'http://112.78.1.220:8084/vqr/';
  }

  // @override
  // FirebaseOptions getFirebaseCongig() {
  //   return const FirebaseOptions(
  //     apiKey: 'AIzaSyCns_zmKTZ2O66TK-loHlvbWPvoAA3Ffu0',
  //     appId: '1:723381873229:web:5fb20affd823d725fbca04',
  //     messagingSenderId: '723381873229',
  //     projectId: 'bns-stagging',
  //   );
  // }
}