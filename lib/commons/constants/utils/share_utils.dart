import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:intl/intl.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/models/DTO/bank_system_dto.dart';
import 'package:vietqr_admin/models/DTO/invoice_dto.dart';
import 'package:vietqr_admin/models/DTO/user_recharge_dto.dart';

import '../../utils/log.dart';

class ShareUtils {
  const ShareUtils._privateConsrtructor();

  static const ShareUtils _instance = ShareUtils._privateConsrtructor();

  static ShareUtils get instance => _instance;

  Future<void> saveImageToGallery(
      GlobalKey globalKey, String bankAccount) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      await WebImageDownloader.downloadImageFromUInt8List(
          uInt8List: pngBytes, name: 'VietQr-$bankAccount');
      // await ImageGallerySaver.saveImage(
      //   pngBytes,
      //   quality: 100,
      // );
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  String getTextRechargeItem(RechargeItem dto) {
    String formattedDateTimePaid = dto.timePaid.toString().isNotEmpty
        ? DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(dto.timePaid * 1000))
        : '-';
    String formattedDateTimeCreated = dto.timeCreated.toString().isNotEmpty
        ? DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(dto.timeCreated * 1000))
        : '-';
    String result = '';
    String amount = '';
    String timePaid = '';
    String billNumber = '';
    String service = '';
    if (dto.paymentType == 0) {
      service = 'Nạp tiền VQR';
    } else if (dto.paymentType == 1) {
      service = 'Nạp tiền điện thoại';
    } else {
      service = 'Phần mềm VietQR';
    }

    String fullName = '';
    String phoneNo = '';
    String additionData = '';
    bool hasData2 = false;
    if (dto.additionData2 != null || dto.additionData2.isNotEmpty) {
      hasData2 = true;
    }
    String timeCreate = '';

    if (dto.amount != 0) {
      amount =
          '\nTổng tiền: ${StringUtils.formatNumberWithOutVND(dto.amount.toString())}';
    }
    if (dto.timePaid != 0) {
      timePaid = '\nThời gian thanh toán: $formattedDateTimePaid';
    }
    if (dto.billNumber.isNotEmpty) {
      billNumber = '\nMã hoá đơn: ${dto.billNumber}';
    }
    if (service.isNotEmpty) {
      service = '\nDịch vụ: $service';
    }
    if (dto.fullName.isNotEmpty) {
      fullName = '\nNgười thực hiện: ${dto.fullName}';
    }
    if (dto.phoneNo.isNotEmpty) {
      phoneNo = '\nSĐT: ${dto.phoneNo}';
    }
    if (dto.additionData.isNotEmpty && hasData2) {
      additionData =
          '\nThông tin thêm: ${dto.additionData} - ${dto.additionData2}';
    } else if (dto.additionData.isNotEmpty && !hasData2) {
      additionData = '\nThông tin thêm: ${dto.additionData}';
    }
    if (dto.timeCreated != 0) {
      timeCreate = '\nThời gian tạo: $formattedDateTimeCreated';
    }

    result =
        '$timePaid $amount $billNumber $service $fullName $phoneNo $additionData $timeCreate\nBy VIETQR.VN';

    return result;
  }

  String getTextSharing(InvoiceItem dto) {
    String formattedDateTimePaid = dto.timePaid.toString().isNotEmpty
        ? DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(dto.timePaid * 1000))
        : '-';
    String formattedDateTimeCreated = dto.timeCreated.toString().isNotEmpty
        ? DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(dto.timeCreated * 1000))
        : '-';
    String result = '';
    String vso = '';
    String amount = '';
    String timePaid = '';
    String merchant = '';
    String billNumber = '';
    String invoiceName = '';
    String userName = '';
    String bankAccount = '';
    String vietQrBank = '';
    String timeCreate = '';
    String email = '';
    if (dto.vso.isNotEmpty) {
      vso = 'VSO: ${dto.vso}';
    }
    if (dto.email.isNotEmpty) {
      email = '\nEmail: ${dto.email}';
    }
    if (dto.amount != 0) {
      amount =
          '\nTổng tiền: ${StringUtils.formatNumberWithOutVND(dto.amount.toString())}';
    }
    if (dto.timePaid != 0) {
      timePaid = '\nThời gian thanh toán: $formattedDateTimePaid';
    }
    if (dto.midName.isNotEmpty) {
      merchant = 'Đại lý: ${dto.midName}';
    }
    if (dto.billNumber.isNotEmpty) {
      billNumber = '\nMã hoá đơn: ${dto.billNumber}';
    }
    if (dto.invoiceName.isNotEmpty) {
      invoiceName = '\nHoá đơn: ${dto.invoiceName}';
    }
    if (dto.fullName.isNotEmpty) {
      userName = '\nKH thanh toán: ${dto.fullName}';
    }
    if (dto.bankAccount.isNotEmpty && dto.bankShortName.isNotEmpty) {
      bankAccount = '\nTK ngân hàng: ${dto.bankAccount} - ${dto.bankShortName}';
    }
    if (dto.fullName.isNotEmpty) {
      vietQrBank = '\nTài khoản VietQR: ${dto.phoneNo}';
    }
    if (dto.timeCreated != 0) {
      timeCreate = '\nThời gian tạo: $formattedDateTimeCreated';
    }

    result =
        '$invoiceName $amount $merchant $timePaid $vso $billNumber $userName $bankAccount $vietQrBank $email $timeCreate\nBy VIETQR.VN';

    return result;
  }

  String getBankSharing(BankSystemItem dto) {
    String formattedDateTimePaid = dto.validFeeTo.toString().isNotEmpty
        ? DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(dto.validFeeTo * 1000))
        : '-';
    String result = '';
    String bankAccount = '';
    String bankAccountName = '';
    String bankShortName = '';
    String phoneAuthenticated = '';
    String mmsActive = '';
    String status = '';
    String validFeeTo = '';
    String nationalId = '';
    String phoneNo = '';
    String email = '';
    String vso = '';

    if (dto.bankAccount.isNotEmpty) {
      bankAccount = 'Số tài khoản: ${dto.bankAccount}';
    }
    if (dto.bankAccountName.isNotEmpty) {
      bankAccountName = '\nChủ tài khoản: ${dto.bankAccountName}';
    }
    if (dto.bankShortName.isNotEmpty) {
      bankShortName = '\nNgân hàng: ${dto.bankShortName}';
    }
    if (dto.phoneAuthenticated.isNotEmpty) {
      phoneAuthenticated = '\nSĐT xác thực: ${dto.phoneAuthenticated}';
    }
    mmsActive = '\nLuồng: ${dto.mmsActive ? 'TF' : 'MF'}';
    if (dto.nationalId.isNotEmpty) {
      nationalId = '\nCCCD / MST: ${dto.nationalId}';
    }
    if (dto.validFeeTo != 0) {
      validFeeTo = '\nThời hạn đến: $formattedDateTimePaid';
    }
    if (dto.vso.isNotEmpty) {
      vso = '\nVSO: ${dto.vso}';
    }
    if (dto.phoneNo.isNotEmpty) {
      phoneNo = '\nTK VietQR: ${dto.phoneNo}';
    }
    if (dto.email.isNotEmpty) {
      email = '\nEmail: ${dto.email}';
    }
    status = '\nTrạng thái: ${dto.status ? 'Đã liên kết' : 'Chưa liên kết'}';

    result =
        '$bankAccount $bankAccountName $bankShortName $phoneAuthenticated $mmsActive $nationalId $validFeeTo $vso $phoneNo $email $status';

    return result;
  }
}
