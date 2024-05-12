import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:html' as html;

import '../../commons/constants/enum/type_menu_home.dart';
import '../../commons/widget/frame_view_widget.dart';
import '../../commons/widget/item_menu_dropdown.dart';
import '../../commons/widget/menu_left.dart';
import 'InvoiceCreate/invoice_create_screen.dart';

// ignore: constant_identifier_names
enum Invoice { CREATE, LIST }

class InvoiceManageScreen extends StatefulWidget {
  final Invoice type;
  const InvoiceManageScreen({super.key, required this.type});

  @override
  State<InvoiceManageScreen> createState() => _InvoiceManageScreenState();
}

class _InvoiceManageScreenState extends State<InvoiceManageScreen> {
  Invoice type = Invoice.LIST;
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
          currentType: MenuType.INVOICE,
          subMenuTransFee: [
            ItemDropDownMenu(
              title: 'Danh sách hoá đơn',
              isSelect: type == Invoice.LIST,
              onTap: () => onTapMenu(Invoice.LIST),
            ),
            ItemDropDownMenu(
              title: 'Tạo mới hoá đơn',
              isSelect: type == Invoice.CREATE,
              onTap: () => onTapMenu(Invoice.CREATE),
            ),
          ],
        ),
        child: _buildBody());
  }

  void onTapMenu(Invoice value) {
    if (value == Invoice.LIST) {
      html.window.history.pushState(null, '/trans-fee', '/trans-fee');
      type = value;
    } else if (value == Invoice.CREATE) {
      html.window.history.pushState(null, '/trans-fee', '/annual-fee');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == Invoice.LIST) {
      return Container();
    } else {
      return const CreateInvoiceScreen();
    }
  }
}
