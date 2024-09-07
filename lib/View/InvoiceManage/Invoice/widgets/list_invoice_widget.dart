import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceCreateManage/InvoiceCreate/widgets/popup_excel_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/widgets/item_invoice_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/widgets/title_invoice_widget.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/share_utils.dart';
import 'package:vietqr_admin/commons/widget/box_layout.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/invoice_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';

enum Actions {
  copy,
  qr,
  edit,
  exportExcel,
  delete,
}

class ListInvoiceWidget extends StatefulWidget {
  final Function(InvoiceItem) onShowPopup;
  final Function(InvoiceItem) onEdit;
  final Function(String) onDetail;
  final int pageSize;

  const ListInvoiceWidget({
    super.key,
    required this.onShowPopup,
    required this.onEdit,
    required this.onDetail,
    required this.pageSize,
  });

  @override
  State<ListInvoiceWidget> createState() => _ListInvoiceWidgetState();
}

class _ListInvoiceWidgetState extends State<ListInvoiceWidget> {
  late LinkedScrollControllerGroup _linkedScrollControllerGroup;
  late ScrollController _horizontal;
  late ScrollController _vertical;
  late ScrollController _vertical2;
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
        if (model.status == ViewStatus.Loading) {
          if (_horizontal.hasClients) _horizontal.jumpTo(0.0);
        }
        if (model.status == ViewStatus.Error &&
            model.request != InvoiceType.REQUEST_PAYMENT) {
          return const SizedBox.shrink();
        }
        // List<InvoiceItem>? list = model.invoiceDTO?.items;
        // InvoiceDTO? invoiceDTO = model.invoiceDTO;
        // MetaDataDTO metadata = model.metadata!;
        List<Widget> buildItemList(
            List<InvoiceItem>? list, MetaDataDTO metadata) {
          if (list == null || list.isEmpty) {
            return [];
          }

          return list
              .asMap()
              .map((index, e) {
                int calculatedIndex =
                    index + ((metadata.page! - 1) * widget.pageSize);
                return MapEntry(
                    index,
                    Column(
                      children: [
                        ItemInvoiceWidget(
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
                    right: 220,
                    child: SizedBox(
                      width: 1760,
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
                                TitleItemInvoiceWidget(
                                    width: constraints.maxWidth),
                                if (model.status == ViewStatus.Loading)
                                  Expanded(
                                    child: Container(
                                      width: constraints.maxWidth,
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(),
                                    ),
                                  )
                                else if (model.invoiceDTO != null)
                                  Expanded(
                                      child: ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(context)
                                        .copyWith(scrollbars: false),
                                    child: SingleChildScrollView(
                                      controller: _vertical,
                                      physics: const ClampingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          ...buildItemList(
                                              model.invoiceDTO!.items,
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
                  SizedBox(
                    width: 1980,
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        // const Spacer(),
                        // SizedBox(width: constraints.maxWidth),
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
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColor.BLUE_TEXT.withOpacity(0.3),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 40,
                                        width: 120,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Trạng thái',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.BLACK,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        height: 40,
                                        width: 100,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Thao tác',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.BLACK,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                              ),
                              if (model.status == ViewStatus.Loading)
                                const SizedBox.shrink()
                              else if (model.invoiceDTO != null)
                                Expanded(
                                    child: SingleChildScrollView(
                                  controller: _vertical2,
                                  physics: const ClampingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      ...model.invoiceDTO!.items.map(
                                        (e) {
                                          return Column(
                                            children: [
                                              _rightItem(e),
                                              // if (index + 1 != list.length)
                                              const SizedBox(
                                                  width: 220,
                                                  child: MySeparator(
                                                      color: AppColor
                                                          .GREY_DADADA)),
                                            ],
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _rightItem(InvoiceItem e) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            // padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            // decoration: BoxDecoration(
            //     border: Border(
            //         left:
            //             BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
            //         bottom:
            //             BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
            //         right: BorderSide(
            //             color: AppColor.GREY_TEXT.withOpacity(0.3)))),
            height: 50,
            width: 120,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: e.status == 0
                    ? AppColor.ORANGE_DARK.withOpacity(0.3)
                    : e.status == 1
                        ? AppColor.GREEN.withOpacity(0.3)
                        : AppColor.GREEN_STATUS.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                e.status == 0
                    ? 'Chờ TT'
                    : e.status == 1
                        ? 'Đã TT'
                        : 'Chưa TT hết',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: e.status == 0
                      ? AppColor.ORANGE_DARK
                      : e.status == 1
                          ? AppColor.GREEN
                          : AppColor.GREEN_STATUS,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            // decoration: BoxDecoration(
            //   border: Border(
            //     // left: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
            //     bottom: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
            //     right: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
            //   ),
            // ),
            height: 50,
            width: 100,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 4),
                Tooltip(
                  message: 'Thông tin hoá đơn',
                  child: InkWell(
                    onTap: () {
                      widget.onDetail(e.invoiceId);
                    },
                    child: BoxLayout(
                      width: 30,
                      height: 30,
                      borderRadius: 100,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(0),
                      bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                      child: const Icon(
                        Icons.info,
                        size: 12,
                        color: AppColor.BLUE_TEXT,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<Actions>(
                  padding: const EdgeInsets.all(0),
                  onSelected: (Actions result) {
                    switch (result) {
                      case Actions.copy:
                        onCopy(dto: e);
                        break;
                      case Actions.qr:
                        widget.onShowPopup(e);
                        break;
                      case Actions.edit:
                        widget.onEdit(e);
                        break;
                      case Actions.exportExcel:
                        onShowPopupExcel(e.invoiceId);
                        break;

                      case Actions.delete:
                        DialogWidget.instance.openMsgDialogQuestion(
                          title: "Hóa đơn",
                          msg: 'Xác nhận xóa hóa đơn!!',
                          onConfirm: () async {
                            Navigator.of(context).pop();
                            bool? result =
                                await _model.deleteInvoice(e.invoiceId);
                            if (result!) {
                              // _model.filterListInvoice(
                              //     time: selectDate!,
                              //     page: 1,
                              //     filter: textInput()!);
                            }
                          },
                        );
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      _buildMenuItems(e.status),
                  icon: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColor.BLUE_TEXT.withOpacity(0.3),
                    ),
                    child: const Icon(
                      size: 18,
                      Icons.more_vert,
                      color: AppColor.BLUE_TEXT,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry<Actions>> _buildMenuItems(int status) {
    List<PopupMenuEntry<Actions>> items = [
      const PopupMenuItem<Actions>(
        value: Actions.copy,
        child: Text('Copy'),
      ),
      const PopupMenuItem<Actions>(
        value: Actions.exportExcel,
        child: Text('Xuất Excel'),
      ),
    ];

    if (status != 1) {
      // Chỉ thêm "Edit" và "Delete" khi status không phải là 1
      items.addAll([
        const PopupMenuItem<Actions>(
          value: Actions.qr,
          child: Text('QR thanh toán'),
        ),
        const PopupMenuItem<Actions>(
          value: Actions.edit,
          child: Text('Chỉnh sửa hoá đơn'),
        ),
        const PopupMenuItem<Actions>(
          value: Actions.delete,
          child: Text('Xoá hoá đơn'),
        ),
      ]);
    }

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
