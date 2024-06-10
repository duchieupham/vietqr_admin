import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:intl/intl.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/models/DTO/invoice_dto.dart';

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
      vso = '\VSO: ${dto.vso}';
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
      merchant = '\nĐại lý: ${dto.midName}';
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
        '$vso $amount $timePaid $merchant $billNumber $invoiceName $userName $bankAccount $vietQrBank $email $timeCreate\nBy VietQR VN';

    return result;
  }
}
