import '../../main.dart';

class AccountHelper {
  const AccountHelper._privateConstructor();

  static const AccountHelper _instance = AccountHelper._privateConstructor();

  static AccountHelper get instance => _instance;

  Future<void> initialAccountHelper() async {
    await sharedPrefs.setString('TOKEN', '');
    await sharedPrefs.setString('FCM_TOKEN', '');
  }

  Future<void> setToken(String value) async {
    await sharedPrefs.setString('TOKEN', value);
  }

  String getToken() {
    return sharedPrefs.getString('TOKEN') ?? '';
  }

  Future<void> setFcmToken(String token) async {
    await sharedPrefs.setString('FCM_TOKEN', token);
  }

  Future<void> setTokenFree(String value) async {
    await sharedPrefs.setString('TOKEN_FREE', value);
  }

  String getTokenFree() {
    return sharedPrefs.getString('TOKEN_FREE')!;
  }
}
