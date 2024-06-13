import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/models/DAO/SystemDAO.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
import 'package:vietqr_admin/models/DTO/user_system_dto.dart';

class SystemViewModel extends BaseModel {
  late SystemDAO _dao;
  List<UserSystemDTO>? listUser = [];
  MetaDataDTO? metaDataDTO;

  SystemViewModel() {
    _dao = SystemDAO();
    listUser = [];
  }

  Future<void> getListUser(
      {int page = 1, required int type, String value = ''}) async {
    try {
      setState(ViewStatus.Loading);
      listUser = await _dao.getListUser(page: page, type: type, value: value);
      metaDataDTO = _dao.metaDataDTO;
      setState(ViewStatus.Completed);
    } catch (e) {
      LOG.error(e.toString());
      setState(ViewStatus.Error);
    }
  }
}
