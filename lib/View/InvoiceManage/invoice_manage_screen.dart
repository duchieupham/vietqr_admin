
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'dart:html' as html;

import '../../commons/constants/enum/type_menu_home.dart';
import '../../commons/widget/frame_view_widget.dart';
import '../../commons/widget/item_menu_dropdown.dart';
import '../../commons/widget/menu_left.dart';
import 'Invoice/invoice_screen.dart';
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
  late InvoiceViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();

    type = widget.type;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FrameViewWidget(
        title: const SizedBox(),
        menu: MenuLeft(
          currentType: MenuType.INVOICE,
          subMenuInvoice: [
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
      html.window.history.pushState(null, '/invoice', '/invoice-list');
      type = value;
    } else if (value == Invoice.CREATE) {
      html.window.history.pushState(null, '/invoice', '/create-invoice');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == Invoice.LIST) {
      return const InvoiceScreen();
    } else {
      return CreateInvoiceScreen(
        onCreate: (invoice, desciption, fileName, bytes) async {
          // File? file = File(filePath);
          // File? compressedFile = FileUtils.instance.compressImage(file);
          await _model
              .createInvoice(
                  invoiceName: invoice,
                  description: desciption,
                  fileName: fileName,
                  bytes: bytes)
              .then(
            (value) {
              if (value == true) {
                toastification.show(
                  context: context,
                  type: ToastificationType.success,
                  style: ToastificationStyle.flat,
                  title: const Text(
                    'Tạo hóa đơn thành công',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  showProgressBar: false,
                  alignment: Alignment.topRight,
                  autoCloseDuration: const Duration(seconds: 5),
                  boxShadow: highModeShadow,
                  dragToClose: true,
                  pauseOnHover: true,
                );
                onTapMenu(Invoice.LIST);
              } else {
                DialogWidget.instance.openMsgDialog(
                    title: "Không thể tạo hoá đơn",
                    msg:
                        'Hoá đơn chứa danh mục hàng hoá\nđã tồn tại trong hoá đơn khác.');
              }
            },
          );
        },
      );
    }
  }
}
