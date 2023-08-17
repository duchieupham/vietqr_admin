// import 'package:firebase_core/firebase_core.dart';

import 'evn.dart';

class DevEnv implements Env {
  @override
  String getBankUrl() {
    return '';
  }

  @override
  String getBaseUrl() {
    return 'https://dev.vietqr.org/vqr/api/';
  }

  // @override
  // FirebaseOptions getFirebaseCongig() {
  //   return const FirebaseOptions(
  //     apiKey: "AIzaSyAjPP6Mc3baFUgEsO8o0-J-qmSVegmw2TQ",
  //     appId: "1:84188087131:web:79177d863a3480e04ed07e",
  //     messagingSenderId: '84188087131',
  //     projectId: 'vietqr-product',
  //   );
  // }
}
