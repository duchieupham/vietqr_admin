import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/View/InvoiceManage/UserRecharge/user_recharge_screen.dart';
import 'package:vietqr_admin/View/InvoiceManage/widgets/header_invoice_list.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/app_image.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/utils/platform_utils.dart';
import 'package:vietqr_admin/commons/widget/box_layout.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';
import 'dart:html' as html;

import '../../commons/constants/enum/type_menu_home.dart';
import '../../commons/widget/item_menu_dropdown.dart';
import '../../commons/widget/menu_left.dart';
import 'Invoice/invoice_screen.dart';

// ignore: constant_identifier_names
enum Invoice { LIST, RECHARGE_TRANS }

class InvoiceManageScreen extends StatefulWidget {
  final Invoice type;
  const InvoiceManageScreen({super.key, required this.type});

  @override
  State<InvoiceManageScreen> createState() => _InvoiceManageScreenState();
}

class _InvoiceManageScreenState extends State<InvoiceManageScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
    bool isClose =
        !PlatformUtils.instance.isCloseMenu(MediaQuery.of(context).size.width);
    if (isClose) {
      _controller.forward();
    } else {
      isCloseNotifier.value ? _controller.forward() : _controller.reverse();
    }
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuLeft(
        currentType: MenuType.INVOICE,
        subMenuInvoice: [
          ItemDropDownMenu(
            title: 'Danh sách hoá đơn',
            isSelect: type == Invoice.LIST,
            onTap: () => onTapMenu(Invoice.LIST),
          ),
          ItemDropDownMenu(
            title: 'Thu phí thường niên',
            isSelect: type == Invoice.RECHARGE_TRANS,
            onTap: () => onTapMenu(Invoice.RECHARGE_TRANS),
          ),
        ],
      ),
      backgroundColor: AppColor.WHITE,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            color: AppColor.BLUE_BGR,
            padding: const EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                SizedBox(
                  width: 250,
                  height: 60,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (!isClose) {
                            isCloseNotifier.value = !isCloseNotifier.value;
                            isCloseNotifier.value
                                ? _controller.forward()
                                : _controller.reverse();
                          } else {
                            _scaffoldKey.currentState?.openDrawer();
                          }

                          // bool isClose = !PlatformUtils.instance
                          //     .isCloseMenu(MediaQuery.of(context).size.width);
                          // if (isClose) {
                          //
                          // }
                        },
                        child: BoxLayout(
                          width: 40,
                          height: 40,
                          borderRadius: 100,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(0),
                          bgColor: AppColor.WHITE,
                          border: Border.all(color: AppColor.BLACK, width: 1),
                          child: AnimatedIcon(
                              icon: AnimatedIcons.close_menu,
                              progress: _controller,
                              size: 20,
                              color: Theme.of(context).hintColor),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: Image.asset(
                          AppImages.icVietQrAdmin,
                          height: 40,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ],
                  ),
                ),
                if (type == Invoice.LIST)
                  HeaderInvoiceList(
                    onCreateInvoice: () {
                      html.window.history
                          .pushState(null, '/invoice', '/user-recharge');
                      setState(() {
                        type = Invoice.RECHARGE_TRANS;
                      });
                    },
                  )
                else
                  const Spacer(),
                SizedBox(
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Môi trường', style: TextStyle(fontSize: 10)),
                      Consumer<MenuProvider>(
                        builder: (context, provider, child) {
                          return Text(
                            provider.environment == 0 ? 'Test' : 'Live',
                            style: const TextStyle(
                                color: AppColor.BLUE_TEXT,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Tooltip(
                  message: 'Cài đặt môi trường',
                  child: Consumer<MenuProvider>(
                    builder: (context, provider, child) {
                      return InkWell(
                        onTap: () {
                          context.go('/setting-env');
                        },
                        child: BoxLayout(
                          width: 40,
                          height: 40,
                          borderRadius: 100,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(0),
                          bgColor: AppColor.WHITE,
                          border: Border.all(color: AppColor.BLACK, width: 1),
                          child: const Icon(
                            Icons.settings,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    AppImages.icAvatarDefault,
                    width: 40,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            color: AppColor.TRANSPARENT,
            child: Row(
              children: [
                if (!isClose)
                  ValueListenableBuilder<bool>(
                    valueListenable: isCloseNotifier,
                    builder: (context, value, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: value ? 0 : 250,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: MenuLeft(
                            currentType: MenuType.INVOICE,
                            subMenuInvoice: [
                              ItemDropDownMenu(
                                title: 'Thu phí giao dịch',
                                isSelect: type == Invoice.LIST,
                                onTap: () => onTapMenu(Invoice.LIST),
                              ),
                              ItemDropDownMenu(
                                title: 'Thu phí thường niên',
                                isSelect: type == Invoice.RECHARGE_TRANS,
                                onTap: () => onTapMenu(Invoice.RECHARGE_TRANS),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                Expanded(
                  child: _buildBody(),
                )
              ],
            ),
          ))
        ],
      ),
    );
    // return FrameViewWidget(
    //   title: const SizedBox(),
    //   menu: MenuLeft(
    //     currentType: MenuType.INVOICE,
    //     subMenuInvoice: [
    //       ItemDropDownMenu(
    //         title: 'Danh sách hoá đơn',
    //         isSelect: type == Invoice.LIST,
    //         onTap: () => onTapMenu(Invoice.LIST),
    //       ),
    //       ItemDropDownMenu(
    //         title: 'Tạo mới hoá đơn',
    //         isSelect: type == Invoice.CREATE,
    //         onTap: () => onTapMenu(Invoice.CREATE),
    //       ),
    //     ],
    //   ),
    //   child: _buildBody(),
    // );
  }

  void onTapMenu(Invoice value) {
    if (value == Invoice.LIST) {
      html.window.history.pushState(null, '/invoice', '/invoice-list');
      setState(() {
        type = value;
      });
    } else if (value == Invoice.RECHARGE_TRANS) {
      html.window.history.pushState(null, '/invoice', '/user-recharge');
      type = value;
    }
    setState(() {});
    // else if (value == Invoice.CREATE) {
    //   html.window.history.pushState(null, '/invoice', '/create-invoice');
    //   setState(() {
    //     type = value;
    //   });
    // }
  }

  Widget _buildBody() {
    if (type == Invoice.LIST) {
      return const InvoiceScreen();
    } else {
      return const UserRechargeScreen();
    }
    // if (type == Invoice.LIST) {
    //   return const InvoiceScreen();
    // }
    // else {
    //   return CreateInvoiceScreen(
    //     onCreate: (invoice, desciption, fileName, bytes) async {
    //       // File? file = File(filePath);
    //       // File? compressedFile = FileUtils.instance.compressImage(file);
    //       await _model
    //           .createInvoice(
    //               invoiceName: invoice,
    //               description: desciption,
    //               fileName: fileName,
    //               bytes: bytes)
    //           .then(
    //         (value) {
    //           if (value == true) {
    //             toastification.show(
    //               context: context,
    //               type: ToastificationType.success,
    //               style: ToastificationStyle.flat,
    //               title: const Text(
    //                 'Tạo hóa đơn thành công',
    //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //               ),
    //               showProgressBar: false,
    //               alignment: Alignment.topRight,
    //               autoCloseDuration: const Duration(seconds: 5),
    //               boxShadow: highModeShadow,
    //               dragToClose: true,
    //               pauseOnHover: true,
    //             );
    //             onTapMenu(Invoice.LIST);
    //           } else {
    //             DialogWidget.instance.openMsgDialog(
    //                 title: "Không thể tạo hoá đơn",
    //                 msg:
    //                     'Hoá đơn chứa danh mục hàng hoá\nđã tồn tại trong hoá đơn khác.');
    //           }
    //         },
    //       );
    //     },
    //   );
    // }
  }
}
