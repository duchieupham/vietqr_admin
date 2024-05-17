import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
import 'package:vietqr_admin/models/DTO/qr_box_dto.dart';

import '../models/DAO/QrBoxDAO.dart';

class QrBoxViewModel extends BaseModel {
  late QrBoxDAO _dao;
  List<QrBoxDTO>? qrBoxList = [];

  MetaDataDTO? metadata;

  QrBoxViewModel() {
    _dao = QrBoxDAO();
  }

  Future<bool?> createQrBox(QrBoxDTO dto,
      {String? note, int? amount, String? content}) async {
    try {
      setState(ViewStatus.Loading);
      bool? result = await _dao.createQrBox(dto,
          amount: amount, content: content, note: note);
      setState(ViewStatus.Completed);
      return result;
    } catch (e) {
      setState(ViewStatus.Error);
    }
    return false;
  }

  Future<void> getListQrBox(
      {int? page, required int type, String? value}) async {
    try {
      setState(ViewStatus.Loading);
      qrBoxList = await _dao.getQrBoxList(
          page: page ?? 1, type: type, value: value ?? '');
      metadata = _dao.metaDataDTO;
      Future.delayed(const Duration(milliseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error);
    }
  }
}
