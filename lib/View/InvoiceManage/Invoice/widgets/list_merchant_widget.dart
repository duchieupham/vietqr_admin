import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/popup_payment_request_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/InvoiceCreate/widgets/popup_excel_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/widgets/item_invoice_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/widgets/item_merchant.dart';
import 'package:vietqr_admin/View/InvoiceManage/widgets/title_invoice_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/widgets/title_merchant.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/measure_size.dart';
import 'package:vietqr_admin/commons/constants/utils/share_utils.dart';
import 'package:vietqr_admin/commons/widget/box_layout.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/invoice_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';

enum Actions {
  payment,
  sendMail,
}

class ListMerchantWidget extends StatefulWidget {
  const ListMerchantWidget({super.key});

  @override
  State<ListMerchantWidget> createState() => _ListMerchantWidgetState();
}

class _ListMerchantWidgetState extends State<ListMerchantWidget> {
  late LinkedScrollControllerGroup _linkedScrollControllerGroup;
  late ScrollController _horizontal;
  late ScrollController _vertical;
  late ScrollController _vertical2;
  ValueNotifier<double> widthTable = ValueNotifier<double>(0.0);

  late InvoiceViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();

    _linkedScrollControllerGroup = LinkedScrollControllerGroup();

    _vertical = _linkedScrollControllerGroup.addAndGet();
    _vertical2 = _linkedScrollControllerGroup.addAndGet();

    _horizontal = ScrollController();
  }

  @override
  void dispose() {
    _vertical.dispose();
    _vertical2.dispose();
    _horizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        // if (model.status == ViewStatus.Loading) {
        //   return const Expanded(child: Center(child: Text('Đang tải...')));
        // }
        if (model.status == ViewStatus.Error &&
            model.request != InvoiceType.REQUEST_PAYMENT) {
          return const SizedBox.shrink();
        }
        // List<InvoiceItem>? list = model.invoiceDTO?.items;
        // InvoiceDTO? invoiceDTO = model.invoiceDTO;
        // MetaDataDTO metadata = model.metadata!;
        List<Widget> buildItemList(
            List<ItemMerchant>? list, MetaDataDTO metadata) {
          if (list == null || list.isEmpty) {
            return [];
          }

          int itemsPerPage = 20;
          return list
              .asMap()
              .map((index, e) {
                int calculatedIndex =
                    index + ((metadata.page! - 1) * itemsPerPage);
                return MapEntry(
                    index,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItemMerchantWidget(
                          dto: e,
                          index: calculatedIndex,
                        ),
                        if (index + 1 != list.length)
                          const SizedBox(
                              width: 1760,
                              child: MySeparator(color: AppColor.GREY_DADADA)),
                      ],
                    ));
              })
              .values
              .toList();
        }

        return Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned.fill(
                    // right: 100,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: RawScrollbar(
                        thumbVisibility: true,
                        controller: _horizontal,
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            controller: _horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleItemMerchantWidget(
                                    width: constraints.maxWidth),
                                if (model.status == ViewStatus.Loading)
                                  Expanded(
                                    child: Container(
                                      color: AppColor.BLUE_CARD,
                                    ),
                                  )
                                else if (model.merchantData != null)
                                  Expanded(
                                      child: ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(context)
                                        .copyWith(scrollbars: false),
                                    child: SingleChildScrollView(
                                      controller: _vertical,
                                      physics: const ClampingScrollPhysics(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...buildItemList(
                                              model.merchantData!.items,
                                              model.metadata!)
                                        ],
                                      ),
                                    ),
                                  ))
                                else
                                  const SizedBox.shrink()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.WHITE,
                          boxShadow: [
                            BoxShadow(
                                color: AppColor.BLACK.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: const Offset(-1, 0)),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              width: 200,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColor.BLUE_TEXT.withOpacity(0.3),
                              ),
                              child: const Text(
                                'Thao tác',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColor.BLACK,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  List<PopupMenuEntry<Actions>> _buildMenuItems(int status) {
    List<PopupMenuEntry<Actions>> items = [
      const PopupMenuItem<Actions>(
        value: Actions.sendMail,
        child: Text('Gửi TT qua email'),
      ),
      const PopupMenuItem<Actions>(
        value: Actions.payment,
        child: Text('Thanh toán'),
      ),
    ];

    return items;
  }

  void onCopy({required InvoiceItem dto}) async {
    await FlutterClipboard.copy(ShareUtils.instance.getTextSharing(dto)).then(
      (value) => Fluttertoast.showToast(
        msg: 'Đã sao chép',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Colors.black,
        fontSize: 15,
        webBgColor: 'rgba(255, 255, 255)',
        webPosition: 'center',
      ),
    );
  }

  void onShowPopupExcel(String invoiceId) async {
    showDialog(
      context: context,
      builder: (context) => PopupExcelInvoice(
        invoiceId: invoiceId,
      ),
    );
  }
}
