import 'package:vietqr_admin/commons/constants/env/dev_evn.dart';
import 'package:vietqr_admin/commons/constants/env/evn.dart';
import 'package:vietqr_admin/commons/constants/env/stg_env.dart';

class EnvConfig {
  static final Env _env = (getEnv() == EnvType.STG) ? StgEnv() : DevEnv();

  static String getBaseUrl() {
    return _env.getBaseUrl();
  }

  // static FirebaseOptions getFirebaseConfig() {
  //   return _env.getFirebaseCongig();
  // }

  static EnvType getEnv() {
    // const EnvType env = EnvType.STG;
    const EnvType env = EnvType.DEV;
    return env;
  }
}

enum EnvType {
  STG,
  DEV,
}
