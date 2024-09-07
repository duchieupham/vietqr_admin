import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:vietqr_admin/View/InvoiceCreateManage/InvoiceCreate/widgets/invoice_create_screen.dart';
import 'package:vietqr_admin/View/InvoiceManage/invoice_manage_screen.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/app_image.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/commons/utils/platform_utils.dart';
import 'package:vietqr_admin/commons/widget/box_layout.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/commons/widget/item_menu_dropdown.dart';
import 'package:vietqr_admin/commons/widget/menu_left.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';

class InvoiceCreateManageScreen extends StatefulWidget {
  const InvoiceCreateManageScreen({super.key});

  @override
  State<InvoiceCreateManageScreen> createState() =>
      _InvoiceCreateManageScreenState();
}

class _InvoiceCreateManageScreenState extends State<InvoiceCreateManageScreen>
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
      drawer: const MenuLeft(
        currentType: MenuType.INVOICE_CREATE,
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
                // if (type == Invoice.LIST)
                //   HeaderInvoiceList(
                //     onCreateInvoice: () {
                //       html.window.history
                //           .pushState(null, '/invoice', '/create-invoice');
                //       setState(() {
                //         type = Invoice.CREATE;
                //       });
                //     },
                //   )
                // else
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
                        child: const SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: MenuLeft(
                            currentType: MenuType.INVOICE_CREATE,
                            subMenuInvoice: [
                              // ItemDropDownMenu(
                              //   title: 'Tạo mới hoá đơn',
                              //   isSelect: type == Invoice.CREATE,
                              //   onTap: () => onTapMenu(Invoice.CREATE),
                              // ),
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

  // void onTapMenu(Invoice value) {
  //   if (value == Invoice.LIST) {
  //     html.window.history.pushState(null, '/invoice', '/invoice-list');
  //     setState(() {
  //       type = value;
  //     });
  //   }
  //   // else if (value == Invoice.CREATE) {
  //   //   html.window.history.pushState(null, '/invoice', '/create-invoice');
  //   //   setState(() {
  //   //     type = value;
  //   //   });
  //   // }
  // }

  Widget _buildBody() {
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
              // onTapMenu(Invoice.LIST);
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
