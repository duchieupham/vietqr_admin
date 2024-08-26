import 'package:vietqr_admin/View/SystemManage/UserSystem/views/add_user_screen.dart';
import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/DAO/SystemDAO.dart';
import 'package:vietqr_admin/models/DTO/bank_system_dto.dart';
import 'package:vietqr_admin/models/DTO/create_user_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
import 'package:vietqr_admin/models/DTO/response_message_dto.dart';
import 'package:vietqr_admin/models/DTO/total_user_dto.dart';
import 'package:vietqr_admin/models/DTO/user_detail_dto.dart';
import 'package:vietqr_admin/models/DTO/user_system_dto.dart';

class SystemViewModel extends BaseModel {
  late SystemDAO _dao;
  List<UserSystemDTO>? listUser = [];
  List<BankSystemDTO>? listBank = [];
  MetaDataDTO? metaDataDTO;
  UserDetailDTO? userDetailDTO;
  UserInfo? userInfo;
  MetaDataDTO? metadata;
  Gender? selectGender;
  TotalUserDTO? totalUserDTO;
  BankSystemDTO? bankSystemDTO;

  SystemViewModel() {
    _dao = SystemDAO();
    listUser = [];
    listBank = [];
  }

  void genderUpdate(Gender value) async {
    selectGender = value;
    notifyListeners();
  }

  Future<void> getListBank(
      {int page = 1, required int type, String value = ''}) async {
    try {
      setState(ViewStatus.Loading);
      listBank = await _dao.getListBank(page: page, type: type, value: value);
      metadata = _dao.metaDataDTO;
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> filterListBank({
    int page = 1,
    required int size,
    required int type,
    String value = '',
    required int searchType,
  }) async {
    try {
      // String formattedDate = '';
      // formattedDate = valueFilterTime.id == 9
      //     ? ''
      //     : DateFormat('yyyy-MM').format(selectedDate);
      setState(ViewStatus.Loading);
      final result = await _dao.filterBankList(
          page: page,
          size: size,
          type: type,
          value: value,
          searchType: searchType);
      bankSystemDTO = result;
      metadata = _dao.metaDataDTO;
      await Future.delayed(const Duration(milliseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
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

  Future<void> getTotalUsers() async {
    try {
      setState(ViewStatus.Loading_Page);
      totalUserDTO = await _dao.getTotalUsers();
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

  //  Future<ResponseMessageDTO?> checkLog(Map<String, dynamic> param) async {
  //   try {
  //     setState(ViewStatus.Loading);
  //     final result = await _dao.checkLog(param);
  //     setState(ViewStatus.Completed);
  //     return result;
  //   } catch (e) {
  //     LOG.error(e.toString());
  //     setState(ViewStatus.Error);
  //   }
  //   return null;
  // }

  Future<ResponseMessageDTO?> checkLog(Map<String, dynamic> param) async {
    try {
      setState(ViewStatus.Loading);
      final result = await _dao.checkLog(param);
      setState(ViewStatus.Completed);
      return result;
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
      return ResponseMessageDTO(
          status: 'FAILED', message: 'Error occurred: ${e.toString()}');
    }
  }

  Future<dynamic> requestActiveKey(
      {required String bankId,
      required String checkSum,
      required String keyActive}) async {
    try {
      // setState(ViewStatus.Loading);
      Map<String, dynamic> param = {
        'bankId': bankId,
        'checkSum': checkSum,
        'keyActive': keyActive,
      };
      final result = await _dao.requestActiveKey(param);
      return result;
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
      return ResponseMessageDTO(
          status: 'FAILED', message: 'Error occurred: ${e.toString()}');
    }
  }

  Future<ResponseMessageDTO> confirmActiveKey(
      {required String bankId,
      required String checkSum,
      required String keyActive,
      required String otp}) async {
    try {
      // setState(ViewStatus.Loading);
      Map<String, dynamic> param = {
        'bankId': bankId,
        'checkSum': checkSum,
        'keyActive': keyActive,
        'otp': otp,
      };
      final result = await _dao.confirmActiveKey(param);
      if (result.status == 'SUCCESS') {
        if (bankSystemDTO != null) {
          var bankItem = bankSystemDTO!.items
              .where(
                (e) => e.bankId == bankId,
              )
              .first;
          if (bankItem != null) {
            if (bankItem.validService == false) {
              bankItem.copyWith(validService: true);
            }
          }
        }
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
      return ResponseMessageDTO(
          status: 'FAILED', message: 'Error occurred: ${e.toString()}');
    }
  }
}
