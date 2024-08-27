import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/app_image.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/utils/platform_utils.dart';
import 'package:vietqr_admin/commons/widget/box_layout.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';
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

class _InvoiceManageScreenState extends State<InvoiceManageScreen>
    with SingleTickerProviderStateMixin {
  Invoice type = Invoice.LIST;
  late InvoiceViewModel _model;
  late AnimationController _controller;
  ValueNotifier<bool> isCloseNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    type = widget.type;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: AppColor.WHITE,
    //   body: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Container(
    //         height: 60,
    //         color: AppColor.BLUE_BGR,
    //         padding: const EdgeInsets.only(left: 20),
    //         width: MediaQuery.of(context).size.width,
    //         child: Row(
    //           children: [
    //             InkWell(
    //               onTap: () {
    //                 isCloseNotifier.value = !isCloseNotifier.value;
    //                 isCloseNotifier.value
    //                     ? _controller.forward()
    //                     : _controller.reverse();
    //                 // bool isClose = !PlatformUtils.instance
    //                 //     .isCloseMenu(MediaQuery.of(context).size.width);
    //                 // if (isClose) {
    //                 //   Scaffold.of(context).openDrawer();
    //                 // }
    //               },
    //               child: BoxLayout(
    //                 width: 40,
    //                 height: 40,
    //                 borderRadius: 100,
    //                 alignment: Alignment.center,
    //                 padding: const EdgeInsets.all(0),
    //                 bgColor: AppColor.WHITE,
    //                 border: Border.all(color: AppColor.BLACK, width: 1),
    //                 child: AnimatedIcon(
    //                     icon: AnimatedIcons.close_menu,
    //                     progress: _controller,
    //                     size: 20,
    //                     color: Theme.of(context).hintColor),
    //               ),
    //             ),
    //             const SizedBox(
    //               width: 20,
    //             ),
    //             SizedBox(
    //               height: 40,
    //               width: 100,
    //               child: Image.asset(
    //                 AppImages.icVietQrAdmin,
    //                 height: 40,
    //                 fit: BoxFit.fitHeight,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Expanded(
    //           child: Container(
    //         color: AppColor.TRANSPARENT,
    //         child: Row(
    //           children: [
    //             ValueListenableBuilder<bool>(
    //               valueListenable: isCloseNotifier,
    //               builder: (context, value, child) {
    //                 return AnimatedContainer(
    //                   duration: const Duration(milliseconds: 300),
    //                   width: value ? 0 : 250,
    //                   child: SingleChildScrollView(
    //                     physics: const NeverScrollableScrollPhysics(),
    //                     scrollDirection: Axis.horizontal,
    //                     child: MenuLeft(
    //                       currentType: MenuType.INVOICE,
    //                       subMenuInvoice: [
    //                         ItemDropDownMenu(
    //                           title: 'Danh sách hoá đơn',
    //                           isSelect: type == Invoice.LIST,
    //                           onTap: () => onTapMenu(Invoice.LIST),
    //                         ),
    //                         ItemDropDownMenu(
    //                           title: 'Tạo mới hoá đơn',
    //                           isSelect: type == Invoice.CREATE,
    //                           onTap: () => onTapMenu(Invoice.CREATE),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 );
    //               },
    //             ),
    //             Expanded(
    //               child: Container(),
    //             )
    //           ],
    //         ),
    //       ))
    //     ],
    //   ),
    // );
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
      child: _buildBody(),
    );
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
