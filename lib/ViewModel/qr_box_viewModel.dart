import 'package:flutter/material.dart';
import 'package:vietqr_admin/ViewModel/base_model.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
import 'package:vietqr_admin/models/DTO/qr_box_dto.dart';
import 'package:vietqr_admin/models/DTO/qr_box_msg_dto.dart';

import '../models/DAO/QrBoxDAO.dart';
import '../models/DTO/bank_type_dto.dart';

class QrBoxViewModel extends BaseModel {
  final TextEditingController certController = TextEditingController();
  final TextEditingController storeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController stkController = TextEditingController();

  String? certText = '';
  String? storeText = '';
  String? addressText = '';
  String? stkText = '';

  late QrBoxDAO _dao;
  List<QrBoxDTO>? qrBoxList = [];
  List<BankTypeDTO>? bankList = [];
  QRBoxMsgDTO? qrMsg;

  MetaDataDTO? metadata;

  bool? activeSuccess = false;

  QrBoxViewModel() {
    _dao = QrBoxDAO();
  }

  void changeCertText(String value) {
    certText = value;
    notifyListeners();
  }

  void changeStoreText(String value) {
    storeText = value;
    notifyListeners();
  }

  void changeAddrText(String value) {
    addressText = value;
    notifyListeners();
  }

  void changeStkText(String value) {
    stkText = value;
    notifyListeners();
  }

  Future<void> activeQrBox() async {
    try {
      setState(ViewStatus.Loading);

      bool? result = await _dao.activeQrBox(
        bankAccount: stkText,
        boxAddress: addressText,
        qrCertificate: certText,
        terminalName: storeText,
      );
      activeSuccess = result;
      setState(ViewStatus.Completed);
      notifyListeners();
    } catch (e) {
      setState(ViewStatus.Error);
    }
  }

  Future<void> getBankList() async {
    try {
      setState(ViewStatus.Loading);
      final result = await _dao.getBanks();
      bankList = [
        const BankTypeDTO(
            id: '0',
            bankCode: '',
            bankName: 'Chọn ngân hàng thụ hưởng',
            bankShortName: '',
            imageId: '',
            caiValue: '',
            status: 0),
        ...result!
      ];
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error);
    }
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

  Future<bool?> updateMsg(QRBoxMsgDTO dto) async {
    try {
      setState(ViewStatus.Empty);
      bool? result = await _dao.updateMsg(dto);
      setState(ViewStatus.Completed);
      return result;
    } catch (e) {
      setState(ViewStatus.Error);
    }
    return false;
  }

  Future<void> getQRBoxMsg() async {
    try {
      setState(ViewStatus.Loading);
      final result = await _dao.getMsg();
      if (result != null) {
        qrMsg = result;
      }
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error);
    }
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
