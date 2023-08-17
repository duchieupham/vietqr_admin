import 'dart:convert';

import 'package:vietqr_admin/main.dart';
import 'package:vietqr_admin/models/account_information_dto.dart';

class UserInformationHelper {
  const UserInformationHelper._privateConsrtructor();

  static const UserInformationHelper _instance =
      UserInformationHelper._privateConsrtructor();
  static UserInformationHelper get instance => _instance;

  Future<void> initialUserInformationHelper() async {
    const AccountInformationDTO accountInformationDTO = AccountInformationDTO();
    await sharedPrefs.setString('USER_ID', '');
    await sharedPrefs.setString('PHONE_NO', '');
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', accountInformationDTO.toDataString().toString());
  }

  Future<void> setAdminId(String userId) async {
    await sharedPrefs.setString('ADMIN_ID', userId);
  }

  Future<void> setPhoneNo(String phoneNo) async {
    await sharedPrefs.setString('PHONE_NO', phoneNo);
  }

  String getPhoneNo() {
    return sharedPrefs.getString('PHONE_NO')!;
  }

  Future<void> setAccountInformation(AccountInformationDTO dto) async {
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', dto.toDataString().toString());
  }

  AccountInformationDTO getAccountInformation() {
    return AccountInformationDTO.fromJson(
        json.decode(sharedPrefs.getString('ACCOUNT_INFORMATION')!));
  }

  String getAdminId() {
    return sharedPrefs.getString('ADMIN_ID') ?? '';
  }

  Future<void> setImageId(String imgId) async {
    AccountInformationDTO dto = AccountInformationDTO.fromJson(
        json.decode(sharedPrefs.getString('ACCOUNT_INFORMATION')!));
    AccountInformationDTO newDto = AccountInformationDTO(
        adminId: dto.adminId,
        exp: dto.exp,
        role: dto.role,
        iat: dto.iat,
        name: dto.name);
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', newDto.toDataString().toString());
  }
}
