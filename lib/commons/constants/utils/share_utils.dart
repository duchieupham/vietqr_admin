import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader_web/image_downloader_web.dart';

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
}
