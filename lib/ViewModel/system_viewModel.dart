import 'package:vietqr_admin/View/SystemManage/UserSystem/views/add_user_screen.dart';
import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/DAO/SystemDAO.dart';
import 'package:vietqr_admin/models/DTO/create_user_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
import 'package:vietqr_admin/models/DTO/user_detail_dto.dart';
import 'package:vietqr_admin/models/DTO/user_system_dto.dart';

class SystemViewModel extends BaseModel {
  late SystemDAO _dao;
  List<UserSystemDTO>? listUser = [];
  MetaDataDTO? metaDataDTO;
  UserDetailDTO? userDetailDTO;
  UserInfo? userInfo;
  MetaDataDTO? metadata;
  Gender? selectGender;

  SystemViewModel() {
    _dao = SystemDAO();
    listUser = [];
  }

  void genderUpdate(Gender value) async {
    selectGender = value;
    notifyListeners();
  }

  Future<void> getListUser(
      {int page = 1, required int type, String value = ''}) async {
    try {
      setState(ViewStatus.Loading);
      listUser = await _dao.getListUser(page: page, type: type, value: value);
      metadata = _dao.metaDataDTO;
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<bool?> changePass(String phone, String pass) async {
    try {
      setState(ViewStatus.Loading);
      final result = await _dao.changeUserPassword(phone, pass);
      setState(ViewStatus.Completed);
      return result;
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
    return false;
  }

  Future<void> getUserDetail(String id) async {
    try {
      setState(ViewStatus.Loading);
      userDetailDTO = await _dao.getUserDetail(id);
      if (userDetailDTO != null) {
        userInfo = userDetailDTO!.userInfo;
        selectGender = Gender(
            userInfo!.gender == 0 ? 'Nam' : 'Nữ', userInfo!.gender, false);
      } else {
        userInfo = null;
      }
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<bool?> updateUser(UserInfo dto) async {
    try {
      setState(ViewStatus.Loading);
      final result = await _dao.updateUser(dto);
      setState(ViewStatus.Completed);
      return result;
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }

    return false;
  }

  Future<bool?> createUser(CreateUserDTO dto) async {
    try {
      setState(ViewStatus.Loading);
      final result = await _dao.createUser(dto);
      setState(ViewStatus.Completed);
      return result;
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
    return false;
  }

  Future<bool?> changeLinked(String id, int status) async {
    try {
      setState(ViewStatus.Loading);
      final result = await _dao.changeLinkedUser(id, status);
      setState(ViewStatus.Completed);
      return result;
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
    return false;
  }
}
