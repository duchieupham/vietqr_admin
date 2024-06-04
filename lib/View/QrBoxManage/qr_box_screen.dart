import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'dart:html' as html;

import '../../commons/widget/frame_view_widget.dart';
import '../../commons/widget/item_menu_dropdown.dart';
import '../../commons/widget/menu_left.dart';
import 'ActiveQrBox/active_qr_box.dart';
import 'QrBox/qr_box_list_screen.dart';

// ignore: constant_identifier_names
enum QrBox { LIST, ACTIVE }

class QrBoxScreen extends StatefulWidget {
  final QrBox type;
  const QrBoxScreen({super.key, required this.type});

  @override
  State<QrBoxScreen> createState() => _QrBoxScreenState();
}

class _QrBoxScreenState extends State<QrBoxScreen> {
  QrBox type = QrBox.LIST;
  @override
  void initState() {
    super.initState();
    type = widget.type;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FrameViewWidget(
        title: const SizedBox(),
        menu: MenuLeft(
          currentType: MenuType.QR_BOX,
          subMenuQrBox: [
            ItemDropDownMenu(
              title: 'Danh sách QR Box',
              isSelect: type == QrBox.LIST,
              onTap: () => onTapMenu(QrBox.LIST),
            ),
            ItemDropDownMenu(
              title: 'Kích hoạt QR Box',
              isSelect: type == QrBox.ACTIVE,
              onTap: () => onTapMenu(QrBox.ACTIVE),
            ),
          ],
        ),
        child: _buildBody());
  }

  void onTapMenu(QrBox value) {
    if (value == QrBox.LIST) {
      html.window.history.pushState(null, '/qr-box', '/qr-box');
      type = value;
    } else if (value == QrBox.ACTIVE) {
      html.window.history.pushState(null, '/qr-box', '/active-qr-box');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == QrBox.LIST) {
      return const QrBoxListScreen();
    } else {
      return const ActiveQrBoxScreen();
    }
  }
}
