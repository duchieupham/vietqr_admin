import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/views/invoice_detail_screen.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/popup_payment_request_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/InvoiceCreate/widgets/popup_excel_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/invoice_manage_screen.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/utils/share_utils.dart';
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
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accController = TextEditingController();

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
  String? status = '';

  DateTime? selectDate;
  late InvoiceViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    _model.onChangePage(PageInvoice.LIST);
    selectDate = _model.getMonth();
    _model.filterListInvoice(time: selectDate!, page: 1, filter: '');

    controller1 = ScrollController();
    controller2 = ScrollController();
    controller1.addListener(() {
      if (!isScrollingDown2) {
        isScrollingDown1 = true;
        controller2.jumpTo(controller1.offset);
      }
      isScrollingDown1 = false;
    });

    controller2.addListener(() {
      if (!isScrollingDown1) {
        isScrollingDown2 = true;
        controller1.jumpTo(controller2.offset);
      }
      isScrollingDown2 = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _invoiceController.clear();
    _accController.clear();
    _bankController.clear();
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

  String? textInput() {
    switch (type) {
      case 0:
        return _model.selectMerchantItem?.merchantId;
      case 1:
        return _invoiceController.text;

      case 2:
        return _bankController.text;

      case 3:
        return _accController.text;
      case 4:
        return status;
      default:
        break;
    }
    return '';
  }

  void onSelectMerchant({String? id}) async {
    return await showDialog(
      context: context,
      builder: (context) =>
          PopupSelectTypeWidget(type: 0, merchantId: id ?? '', isGetList: true),
    );
  }

  void _onPickMonth(DateTime dateTime) async {
    DateTime? result = await showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
            child: DialogPickDate(
              dateTime: dateTime,
            ),
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        selectDate = result;
      });
      _model.filterListInvoice(
          time: selectDate!, page: 1, filter: textInput()!);
    } else {
      selectDate = _model.getMonth();
    }
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
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tìm kiếm thông tin hoá đơn ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _filterWidget(),
                          const SizedBox(height: 20),
                          const MySeparator(
                            color: AppColor.GREY_DADADA,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Danh sách hoá đơn",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          statisticInvoice(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    _buildListInvoice(),
                    const SizedBox(height: 10),
                    _pagingWidget(),
                    const SizedBox(height: 10),
                  ] else if (model.pageType == PageInvoice.DETAIL) ...[
                    Expanded(
                      child: InvoiceDetailScreen(
                          callback: () {
                            _model.onChangePage(PageInvoice.LIST);
                            // setState(() {
                            //   pageType = PageInvoice.LIST;
                            // });
                            _model.filterListInvoice(
                                time: selectDate!,
                                page: 1,
                                filter: textInput()!);
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
                                time: selectDate!,
                                page: 1,
                                filter: textInput()!);
                          }
                        },
                        callback: () {
                          _model.onChangePage(PageInvoice.LIST);
                          _model.filterListInvoice(
                              time: selectDate!, page: 1, filter: textInput()!);
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
                                      width: 2000,
                                      child: Column(
                                        children: [
                                          const TitleItemInvoiceWidget(),
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
                                width: 2000,
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
                                                  children: [
                                                    Container(
                                                        height: 50,
                                                        width: 130,
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
                                                        width: 110,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColor
                                                                    .GREY_TEXT
                                                                    .withOpacity(
                                                                        0.3))),
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
            width: 130,
            child: SelectionArea(
                child: Text(
              e.status == 0
                  ? 'Chờ thanh toán'
                  : e.status == 1
                      ? 'Đã thanh toán'
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
                left: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                bottom: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                right: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
              ),
            ),
            height: 50,
            width: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                PopupMenuButton<Actions>(
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
                                  time: selectDate!,
                                  page: 1,
                                  filter: textInput()!);
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
                                child: Text(
                                  DateFormat('MM/yyyy').format(selectDate!),
                                  style: const TextStyle(fontSize: 13),
                                  textAlign: TextAlign.left,
                                ),
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

                        _model.filterListInvoice(
                            time: selectDate!, page: 1, filter: textInput()!);
                      },
                      child: const Text(
                        'Danh sách hoá đơn',
                        style: TextStyle(
                            color: AppColor.BLUE_TEXT,
                            fontSize: 13,
                            decoration: TextDecoration.underline),
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

  Widget _filterWidget() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        return Scrollbar(
          controller: controller4,
          child: SingleChildScrollView(
            controller: controller4,
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tìm kiếm theo",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 40,
                        width: model.value == 9 ? 250 : 500,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColor.GREY_DADADA)),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 220,
                              child: DropdownButton<int>(
                                isExpanded: true,
                                value: model.value,
                                underline: const SizedBox.shrink(),
                                icon: const RotatedBox(
                                  quarterTurns: 5,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem<int>(
                                      value: 9,
                                      child: Text(
                                        "Tất cả (mặc định)",
                                      )),
                                  DropdownMenuItem<int>(
                                      value: 0,
                                      child: Text(
                                        "Đại lý",
                                      )),
                                  DropdownMenuItem<int>(
                                      value: 1,
                                      child: Text(
                                        "Mã hoá đơn",
                                      )),
                                  DropdownMenuItem<int>(
                                      value: 2,
                                      child: Text(
                                        "Số TK ngân hàng",
                                      )),
                                  DropdownMenuItem<int>(
                                      value: 3,
                                      child: Text(
                                        "Tài khoản VietQR",
                                      )),
                                  DropdownMenuItem<int>(
                                      value: 4,
                                      child: Text(
                                        "Trạng thái",
                                      )),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    type = value;
                                  });
                                  model.changeTypeInvoice(value);
                                },
                              ),
                            ),
                            if (model.value != null && model.value == 0)
                              Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(width: 8),
                                    const SizedBox(
                                      height: 40,
                                      child: VerticalDivider(
                                        thickness: 1,
                                        color: AppColor.GREY_DADADA,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await model.getMerchant('',
                                            isGetList: true);
                                        onSelectMerchant();
                                      },
                                      child: SizedBox(
                                        width: 234,
                                        // padding: const EdgeInsets.symmetric(
                                        //     horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              model.selectMerchantItem != null
                                                  ? model.selectMerchantItem!
                                                      .merchantName
                                                  : 'Chọn đại lý',
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: AppColor.GREY_TEXT,
                                                  fontSize: 13),
                                            ),
                                            const Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 20,
                                              color: AppColor.GREY_TEXT,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (model.value != null && model.value == 1)
                              Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(width: 8),
                                    const SizedBox(
                                      height: 40,
                                      child: VerticalDivider(
                                        thickness: 1,
                                        color: AppColor.GREY_DADADA,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 234,
                                      child: TextField(
                                        controller: _invoiceController,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(bottom: 8),
                                          border: InputBorder.none,
                                          hintText: 'Nhập mã hoá đơn',
                                          hintStyle: TextStyle(
                                              fontSize: 13,
                                              color: AppColor.GREY_TEXT),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (model.value != null && model.value == 2)
                              Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(width: 8),
                                    const SizedBox(
                                      height: 40,
                                      child: VerticalDivider(
                                        thickness: 1,
                                        color: AppColor.GREY_DADADA,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 234,
                                      // padding: const EdgeInsets.symmetric(
                                      //     horizontal: 10),
                                      child: TextField(
                                        controller: _bankController,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(bottom: 8),

                                          // contentPadding:
                                          //     EdgeInsets.only(bottom: 0),
                                          border: InputBorder.none,
                                          hintText: 'Nhập số TK ngân hàng',
                                          hintStyle: TextStyle(
                                              fontSize: 13,
                                              color: AppColor.GREY_TEXT),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (model.value != null && model.value == 3)
                              Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(width: 8),
                                    const SizedBox(
                                      height: 40,
                                      child: VerticalDivider(
                                        thickness: 1,
                                        color: AppColor.GREY_DADADA,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 234,
                                      // padding: const EdgeInsets.symmetric(
                                      //     horizontal: 10),
                                      child: TextField(
                                        controller: _accController,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(bottom: 8),

                                          // contentPadding:
                                          //     EdgeInsets.only(bottom: 0),
                                          border: InputBorder.none,
                                          hintText: 'Nhập TK VietQR',
                                          hintStyle: TextStyle(
                                              fontSize: 13,
                                              color: AppColor.GREY_TEXT),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (model.value != null && model.value == 4)
                              Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(width: 8),
                                    const SizedBox(
                                      height: 40,
                                      child: VerticalDivider(
                                        thickness: 1,
                                        color: AppColor.GREY_DADADA,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 234,
                                      height: 40,
                                      // padding: const EdgeInsets.symmetric(
                                      //     horizontal: 10),
                                      child: DropdownButton<int>(
                                        isExpanded: true,
                                        value: model.valueStatus,
                                        underline: const SizedBox.shrink(),
                                        icon: const RotatedBox(
                                          quarterTurns: 5,
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 12,
                                          ),
                                        ),
                                        items: const [
                                          DropdownMenuItem<int>(
                                              value: 0,
                                              child: Text(
                                                "Chờ thanh toán",
                                              )),
                                          DropdownMenuItem<int>(
                                              value: 1,
                                              child: Text(
                                                "Đã thanh toán",
                                              )),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            status = value.toString();
                                          });
                                          model.changeStatus(value);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Thời gian",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 300,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColor.GREY_DADADA)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 60,
                              child: Center(
                                child: Text('Tháng'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const SizedBox(
                              height: 40,
                              child: VerticalDivider(
                                thickness: 1,
                                color: AppColor.GREY_DADADA,
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _onPickMonth(model.getMonth());
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (selectDate == null
                                            ? '${model.getMonth().month}/${model.getMonth().year}'
                                            : '${selectDate?.month}/${selectDate?.year}'),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      const Icon(Icons.calendar_month_outlined)
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
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Thời gian",
                        style: TextStyle(fontSize: 13, color: AppColor.WHITE),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          await model.filterListInvoice(
                              time: selectDate!, page: 1, filter: textInput()!);
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: AppColor.BLUE_TEXT,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                size: 15,
                                color: AppColor.WHITE,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Tìm kiếm",
                                style: TextStyle(
                                    color: AppColor.WHITE, fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: InkWell(
                      onTap: () {
                        context.go('/create-invoice');
                      },
                      child: MButtonWidget(
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
                    ),
                  ),
                ],
              ),
            ),
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

        return paging != null
            ? Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        "Trang ${paging.page}/${paging.totalPage}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 30),
                    InkWell(
                      onTap: () async {
                        if (paging.page != 1) {
                          await model.filterListInvoice(
                            time: selectDate!,
                            page: paging.page! - 1,
                            filter: textInput()!,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: paging.page != 1
                                    ? AppColor.BLACK
                                    : AppColor.GREY_DADADA)),
                        child: Center(
                          child: Icon(
                            Icons.chevron_left_rounded,
                            color: paging.page != 1
                                ? AppColor.BLACK
                                : AppColor.GREY_DADADA,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () async {
                        if (isPaging) {
                          await model.filterListInvoice(
                            time: selectDate!,
                            page: paging.page! + 1,
                            filter: textInput()!,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: isPaging
                                    ? AppColor.BLACK
                                    : AppColor.GREY_DADADA)),
                        child: Center(
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: isPaging
                                ? AppColor.BLACK
                                : AppColor.GREY_DADADA,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink();
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
