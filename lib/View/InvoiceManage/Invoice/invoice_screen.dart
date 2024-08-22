import 'package:clipboard/clipboard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/views/invoice_detail_screen.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/filter_invoice_button.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/filter_invoice_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/list_invoice_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/popup_payment_request_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/InvoiceCreate/widgets/popup_excel_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/invoice_manage_screen.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/utils/share_utils.dart';
import 'package:vietqr_admin/commons/widget/button.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/models/DTO/invoice_dto.dart';
import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/constants/enum/view_status.dart';
import '../../../commons/constants/utils/custom_scroll.dart';
import '../../../commons/constants/utils/string_utils.dart';
import '../../../commons/widget/box_layout.dart';
import '../../../commons/widget/dialog_pick_month.dart';
import '../../../commons/widget/dialog_widget.dart';
import '../../../commons/widget/separator_widget.dart';
import '../../../main.dart';
import '../../../models/DTO/metadata_dto.dart';
import '../InvoiceCreate/widgets/popup_select_widget.dart';
import '../widgets/item_invoice_widget.dart';
import '../widgets/title_invoice_widget.dart';
import 'views/invoice_edit_screen.dart';

// ignore: constant_identifier_names

enum Actions {
  copy,
  qr,
  edit,
  exportExcel,
  delete,
}

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late ScrollController controller1;
  late ScrollController controller2;

  final controller3 = ScrollController();
  final controller4 = ScrollController();
  final controllerHorizontal = ScrollController();

  bool isScrollingDown1 = false;
  bool isScrollingDown2 = false;
  bool isScrollingHorizontal = false;

  String? selectInvoiceId;

  int? type = 9;
  int pageSize = 20;

  String? status = '';

  late InvoiceViewModel _model;

  List<FilterInvoice> listFilter = [
    FilterInvoice(title: 'Hóa đơn', type: 0),
    FilterInvoice(title: 'Đại lý', type: 1),
  ];

  FilterInvoice filtetSelect = FilterInvoice(title: 'Hóa đơn', type: 0);

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    initData();
  }

  void initData() {
    _model.init();
    _model.onChangePage(PageInvoice.LIST);

    _model.filterListInvoice(page: 1, filter: '');

    // controller1 = ScrollController();
    // controller2 = ScrollController();
    // controller1.addListener(() {
    //   if (!isScrollingDown2) {
    //     isScrollingDown1 = true;
    //     controller2.jumpTo(controller1.offset);
    //   }
    //   isScrollingDown1 = false;
    // });

    // controller2.addListener(() {
    //   if (!isScrollingDown1) {
    //     isScrollingDown2 = true;
    //     controller1.jumpTo(controller2.offset);
    //   }
    //   isScrollingDown2 = false;
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onShowPopup(InvoiceItem dto) async {
    return await showDialog(
      context: context,
      // builder: (context) => PopupQrCodeInvoice(invoiceId: dto.invoiceId),
      builder: (context) => PopupPaymentRequestWidget(
        dto: dto,
        onPop: (id) {
          _model.onChangePage(PageInvoice.DETAIL);
          selectInvoiceId = id;
          setState(() {});
        },
      ),
    );
  }

  void onShowPopupExcel(String invoiceId) async {
    return await showDialog(
      context: context,
      builder: (context) => PopupExcelInvoice(
        invoiceId: invoiceId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      body: ScopedModel<InvoiceViewModel>(
        model: _model,
        child: ScopedModelDescendant<InvoiceViewModel>(
          builder: (context, child, model) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerWidget(),
                  const Divider(
                    color: AppColor.GREY_DADADA,
                  ),
                  if (model.pageType == PageInvoice.LIST) ...[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Text(
                            //   "Tìm kiếm thông tin hoá đơn ",
                            //   style: TextStyle(
                            //       fontSize: 13, fontWeight: FontWeight.bold),
                            // ),
                            // const SizedBox(height: 10),

                            // const SizedBox(height: 20),
                            // const MySeparator(
                            //   color: AppColor.GREY_DADADA,
                            // ),
                            // const SizedBox(height: 20),
                            const Text(
                              "Danh sách hoá đơn",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColor.WHITE,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.BLACK.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 1),
                                      )
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _filter(),
                                    FilterInvoiceWidget(),
                                    // _filterWidget(),
                                    ListInvoiceWidget(
                                      onShowPopup: onShowPopup,
                                      onEdit: (dto) {
                                        setState(() {
                                          selectInvoiceId = dto.invoiceId;
                                        });
                                        _model.onChangePage(PageInvoice.EDIT);
                                      },
                                    ),
                                    const MySeparator(
                                        color: AppColor.GREY_DADADA),
                                    _pagingWidget()
                                  ],
                                ),
                              ),
                            ),
                            // const SizedBox(height: 20),
                            // statisticInvoice(),
                            // const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    // _buildListInvoice(),
                    // const SizedBox(height: 10),
                    // _pagingWidget(),
                    // const SizedBox(height: 10),
                  ] else if (model.pageType == PageInvoice.DETAIL) ...[
                    Expanded(
                      child: InvoiceDetailScreen(
                          callback: () {
                            _model.onChangePage(PageInvoice.LIST);

                            _model.filterListInvoice(
                                page: model.metadata != null
                                    ? model.metadata!.page!
                                    : 1);
                          },
                          onEdit: () {
                            _model.onChangePage(PageInvoice.EDIT);

                            // setState(() {
                            //   pageType = PageInvoice.EDIT;
                            // });
                          },
                          invoiceId: selectInvoiceId!),
                    ),
                  ] else ...[
                    Expanded(
                      child: InvoiceEditScreen(
                        invoiceId: selectInvoiceId!,
                        onEdit: () async {
                          bool? result = await _model.editInvoice();
                          if (result!) {
                            _model.onChangePage(PageInvoice.LIST);
                            _model.filterListInvoice(
                                page: model.metadata != null
                                    ? model.metadata!.page!
                                    : 1);
                          }
                        },
                        callback: () {
                          _model.onChangePage(PageInvoice.LIST);
                          _model.filterListInvoice(
                              page: model.metadata != null
                                  ? model.metadata!.page!
                                  : 1);
                        },
                      ),
                    ),
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _filter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColor.GREY_DADADA))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...listFilter.map(
                (e) {
                  bool isSelect = filtetSelect.type == e.type;
                  return FilterInvoiceButton(
                    text: e.title,
                    isSelect: isSelect,
                    onTap: () {
                      setState(() {
                        filtetSelect = e;
                      });
                    },
                  );
                },
              )
            ],
          ),
          MButtonWidget(
            onTap: () {
              context.go('/create-invoice');
            },
            title: 'Tạo mới hoá đơn',
            isEnable: true,
            margin: EdgeInsets.zero,
            width: 150,
            colorEnableBgr: AppColor.WHITE,
            colorEnableText: AppColor.BLUE_TEXT,
            border: Border.all(color: AppColor.BLUE_TEXT),
            radius: 10,
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildListInvoice() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading) {
          return const Expanded(child: Center(child: Text('Đang tải...')));
        }
        if (model.status == ViewStatus.Error &&
            model.request != InvoiceType.REQUEST_PAYMENT) {
          return const SizedBox.shrink();
        }
        // List<InvoiceItem>? list = model.invoiceDTO?.items;
        InvoiceDTO? invoiceDTO = model.invoiceDTO;

        List<Widget> buildItemList(
            List<InvoiceItem>? list, MetaDataDTO metadata) {
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
                    ItemInvoiceWidget(
                      dto: e,
                      index: calculatedIndex,
                    ));
              })
              .values
              .toList();
        }

        MetaDataDTO metadata = model.metadata!;
        return invoiceDTO != null
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: invoiceDTO.items.isNotEmpty
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width - 220,
                          child: Stack(
                            children: [
                              Scrollbar(
                                thumbVisibility: true,
                                controller: controllerHorizontal,
                                child: SingleChildScrollView(
                                  controller: controllerHorizontal,
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    controller: controller1,
                                    child: SizedBox(
                                      width: 1960,
                                      child: Column(
                                        children: [
                                          const TitleItemInvoiceWidget(
                                            width: 0,
                                          ),
                                          ...buildItemList(
                                              invoiceDTO.items, metadata)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                // width: 1890,
                                width: 1960,
                                child: Row(
                                  children: [
                                    const Expanded(child: SizedBox()),
                                    Scrollbar(
                                      controller: controller2,
                                      thumbVisibility: true,
                                      child: SingleChildScrollView(
                                        controller: controller2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColor.WHITE,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: AppColor.GREY_BORDER
                                                      .withOpacity(0.8),
                                                  blurRadius: 5,
                                                  spreadRadius: 1,
                                                  offset: const Offset(0, 0)),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: AppColor.BLUE_TEXT
                                                        .withOpacity(0.3)),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        height: 50,
                                                        width: 100,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColor
                                                                    .GREY_TEXT
                                                                    .withOpacity(
                                                                        0.3))),
                                                        child: const Text(
                                                          'Trạng thái',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: AppColor
                                                                  .BLACK,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                    Container(
                                                        height: 50,
                                                        width: 100,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border(
                                                          top: BorderSide(
                                                              color: AppColor
                                                                  .GREY_TEXT
                                                                  .withOpacity(
                                                                      0.3)),
                                                          bottom: BorderSide(
                                                              color: AppColor
                                                                  .GREY_TEXT
                                                                  .withOpacity(
                                                                      0.3)),
                                                          right: BorderSide(
                                                              color: AppColor
                                                                  .GREY_TEXT
                                                                  .withOpacity(
                                                                      0.3)),
                                                        )),
                                                        child: const Text(
                                                          'Thao tác',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: AppColor
                                                                  .BLACK,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              ...invoiceDTO.items.map(
                                                (e) {
                                                  return _rightItem(e);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: Text("Không có hóa đơn"),
                        ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _rightItem(InvoiceItem e) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(
                    left:
                        BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                    bottom:
                        BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                    right: BorderSide(
                        color: AppColor.GREY_TEXT.withOpacity(0.3)))),
            height: 50,
            width: 100,
            child: SelectionArea(
                child: Text(
              e.status == 0
                  ? 'Chờ TT'
                  : e.status == 1
                      ? 'Đã TT'
                      : 'Chưa TT hết',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: e.status == 0
                    ? AppColor.ORANGE_DARK
                    : e.status == 1
                        ? AppColor.GREEN
                        : AppColor.GREEN_STATUS,
              ),
            )),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                // left: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                bottom: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                right: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
              ),
            ),
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
                      setState(() {
                        selectInvoiceId = e.invoiceId;
                      });
                      _model.onChangePage(PageInvoice.DETAIL);
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
                        onShowPopup(e);
                        break;
                      case Actions.edit:
                        setState(() {
                          selectInvoiceId = e.invoiceId;
                        });
                        _model.onChangePage(PageInvoice.EDIT);
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
                              _model.filterListInvoice(
                                page: 1,
                              );
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

  Widget statisticInvoice() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        return model.invoiceDTO != null
            ? Scrollbar(
                controller: controller3,
                child: SingleChildScrollView(
                  controller: controller3,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            bottom: BorderSide(color: AppColor.GREY_DADADA),
                          )),
                          height: 40,
                          width: 980,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: const Text(
                                  'Tháng',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: const Text(
                                  'HĐ chưa TT',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 250,
                                child: const Text(
                                  'Số tiền chưa TT (VND)',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: const Text(
                                  'HĐ đã TT',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 250,
                                child: const Text(
                                  'Số tiền đã TT (VND)',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: const Text(
                                  'HĐ lệch TT',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 120,
                                // child: Text(
                                //   DateFormat('MM/yyyy').format(selectDate!),
                                //   style: const TextStyle(fontSize: 13),
                                //   textAlign: TextAlign.left,
                                // ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: Text(
                                  '${model.invoiceDTO!.extraData.pendingCount}',
                                  style: const TextStyle(fontSize: 13),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 250,
                                child: Text(
                                  StringUtils.formatNumberWithOutVND(model
                                      .invoiceDTO!.extraData.pendingAmount),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColor.ORANGE_DARK,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: Text(
                                  '${model.invoiceDTO!.extraData.completeCount}',
                                  style: const TextStyle(fontSize: 13),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 250,
                                child: Text(
                                  StringUtils.formatNumberWithOutVND(model
                                      .invoiceDTO!.extraData.completeAmount),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.GREEN),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: Text(
                                  '${model.invoiceDTO!.extraData.unFullyPaidCount}',
                                  style: const TextStyle(fontSize: 13),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _headerWidget() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
          // width: MediaQuery.of(context).size.width *
          //     (model.pageType == PageInvoice.LIST ? 0.22 : 0.33),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Quản lý hoá đơn",
                style: TextStyle(fontSize: 13),
              ),
              const Text(
                "   /   ",
                style: TextStyle(fontSize: 13),
              ),
              model.pageType == PageInvoice.LIST
                  ? const Text(
                      "Danh sách hoá đơn",
                      style: TextStyle(fontSize: 13),
                    )
                  : InkWell(
                      onTap: () {
                        _model.onChangePage(PageInvoice.LIST);

                        _model.filterListInvoice(page: 1);
                      },
                      child: const Text(
                        'Danh sách hoá đơn',
                        style: TextStyle(
                            color: AppColor.BLUE_TEXT,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColor.BLUE_TEXT),
                      ),
                    ),
              if (model.pageType == PageInvoice.DETAIL) ...[
                const Text(
                  "   /   ",
                  style: TextStyle(fontSize: 13),
                ),
                const Text(
                  "Chi tiết hoá đơn",
                  style: TextStyle(fontSize: 13),
                ),
              ] else if (model.pageType == PageInvoice.EDIT) ...[
                const Text(
                  "   /   ",
                  style: TextStyle(fontSize: 13),
                ),
                const Text(
                  "Chỉnh sửa hoá đơn",
                  style: TextStyle(fontSize: 13),
                ),
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _pagingWidget() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        bool isPaging = false;
        if (model.status == ViewStatus.Loading ||
            model.status == ViewStatus.Error) {
          return const SizedBox.shrink();
        }

        MetaDataDTO paging = model.metadata!;
        if (paging.page! != paging.totalPage!) {
          isPaging = true;
        }
        double indexTotal =
            paging.page != 1 ? ((pageSize * paging.page!) / 2) + 1 : 1;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Số hàng:',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(width: 15),
              Container(
                  width: 50,
                  height: 25,
                  padding: const EdgeInsets.fromLTRB(5, 2, 7, 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.GREY_TEXT.withOpacity(0.3)),
                  child: DropdownButton<int>(
                    isExpanded: true,
                    isDense: true,
                    value: pageSize,
                    borderRadius: BorderRadius.circular(10),
                    // dropdownColor: AppColor.WHITE,
                    underline: const SizedBox.shrink(),
                    iconSize: 12,
                    elevation: 16,
                    dropdownColor: Colors.white,

                    icon: const RotatedBox(
                      quarterTurns: 5,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor.GREY_TEXT,
                        size: 10,
                      ),
                    ),
                    items: <int>[20, 50, 100]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    selectedItemBuilder: (BuildContext context) {
                      return [20, 50, 100].map<Widget>((int item) {
                        return Text(
                          item.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        );
                      }).toList();
                    },
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          pageSize = value;
                        });
                      }
                    },
                  )),
              const SizedBox(width: 30),
              Text(
                '$indexTotal-${pageSize * paging.page!} của ${paging.total}',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(width: 15),
              InkWell(
                onTap: () async {
                  if (paging.page != 1) {
                    await model.filterListInvoice(
                      page: paging.page! - 1,
                    );
                  }
                },
                child: Icon(
                  Icons.keyboard_arrow_left_rounded,
                  size: 25,
                  color: paging.page != 1
                      ? AppColor.BLACK
                      : AppColor.GREY_TEXT.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () async {
                  if (isPaging) {
                    await model.filterListInvoice(
                      page: paging.page! + 1,
                    );
                  }
                },
                child: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: 25,
                  color: isPaging
                      ? AppColor.BLACK
                      : AppColor.GREY_TEXT.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 22),
            ],
          ),
        );
      },
    );
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
}

class FilterInvoice {
  String title;
  int type;

  FilterInvoice({required this.title, required this.type});
}
