import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/views/invoice_detail_screen.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/filter_invoice_button.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/filter_invoice_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/list_invoice_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/list_merchant_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/popup_payment_request_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/InvoiceCreate/widgets/popup_excel_widget.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/utils/share_utils.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/models/DTO/invoice_dto.dart';
import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/constants/enum/view_status.dart';
import '../../../commons/constants/utils/string_utils.dart';
import '../../../commons/widget/separator_widget.dart';
import '../../../models/DTO/metadata_dto.dart';
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
  TextEditingController textEditingController = TextEditingController();

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

  FilterInvoice filterSelect = FilterInvoice(title: 'Hóa đơn', type: 0);

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    initData();
  }

  void initData() {
    _model.init();
    _model.onChangePage(PageInvoice.LIST);

    _model.filterListInvoice(
      size: pageSize,
      page: 1,
      filterType: filterSelect.type,
      search: textEditingController.text,
    );
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
                            const Text(
                              "Danh sách hoá đơn",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: Container(
                                width: 1980,
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
                                    FilterInvoiceWidget(
                                      onCall: (subType) {
                                        textEditingController =
                                            TextEditingController();
                                        model.filterListInvoice(
                                          size: pageSize,
                                          page: 1,
                                          subType: subType,
                                          filterType: filterSelect.type,
                                          search: '',
                                        );
                                      },
                                      pageSize: pageSize,
                                      filterBy: filterSelect.type,
                                      controller: textEditingController,
                                    ),
                                    // _filterWidget(),
                                    if (filterSelect.type == 0)
                                      ListInvoiceWidget(
                                        onShowPopup: onShowPopup,
                                        onEdit: (dto) {
                                          setState(() {
                                            selectInvoiceId = dto.invoiceId;
                                          });
                                          _model.onChangePage(PageInvoice.EDIT);
                                        },
                                        onDetail: (invoiceId) {
                                          setState(() {
                                            selectInvoiceId = invoiceId;
                                          });
                                          _model
                                              .onChangePage(PageInvoice.DETAIL);
                                        },
                                      )
                                    else
                                      const ListMerchantWidget(),
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
                  ] else if (model.pageType == PageInvoice.DETAIL) ...[
                    Expanded(
                      child: InvoiceDetailScreen(
                          callback: () {
                            _model.onChangePage(PageInvoice.LIST);

                            _model.filterListInvoice(
                              size: pageSize,
                              page: model.metadata != null
                                  ? model.metadata!.page!
                                  : 1,
                              filterType: filterSelect.type,
                              search: textEditingController.text,
                            );
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
                              size: pageSize,
                              page: model.metadata != null
                                  ? model.metadata!.page!
                                  : 1,
                              filterType: filterSelect.type,
                              search: textEditingController.text,
                            );
                          }
                        },
                        callback: () {
                          _model.onChangePage(PageInvoice.LIST);
                          _model.filterListInvoice(
                            size: pageSize,
                            page: model.metadata != null
                                ? model.metadata!.page!
                                : 1,
                            filterType: filterSelect.type,
                            search: textEditingController.text,
                          );
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
                  bool isSelect = filterSelect.type == e.type;
                  return FilterInvoiceButton(
                    text: e.title,
                    isSelect: isSelect,
                    onTap: () {
                      setState(() {
                        filterSelect = e;
                        textEditingController = TextEditingController();
                      });

                      _model.filterListInvoice(
                        size: pageSize,
                        page: 1,
                        filterType: e.type,
                        search: '',
                      );
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

  Widget _headerWidget() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
          // width: MediaQuery.of(context).size.width *
          //     (model.pageType == PageInvoice.LIST ? 0.22 : 0.33),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                              size: pageSize,
                              page: _model.metadata != null
                                  ? _model.metadata!.page!
                                  : 1,
                              filterType: filterSelect.type,
                              search: textEditingController.text,
                            );
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
              ScopedModelDescendant<InvoiceViewModel>(
                builder: (context, child, model) {
                  int pendingCount = 0;
                  int completeCount = 0;
                  int pendingAmount = 0;
                  int completeAmount = 0;

                  if (filterSelect.type == 0 && model.invoiceDTO != null) {
                    pendingCount = model.invoiceDTO!.extraData.pendingCount;
                    completeCount = model.invoiceDTO!.extraData.completeCount;
                    pendingAmount = model.invoiceDTO!.extraData.pendingAmount;
                    completeAmount = model.invoiceDTO!.extraData.completeAmount;
                  } else if (filterSelect.type == 1 &&
                      model.merchantData != null) {
                    pendingCount = model.merchantData!.extraData.pendingCount;
                    completeCount = model.merchantData!.extraData.completeCount;
                    pendingAmount = model.merchantData!.extraData.pendingAmount;
                    completeAmount =
                        model.merchantData!.extraData.completeAmount;
                  }
                  return Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  'HĐ chưa TT:',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                pendingCount.toString(),
                                style: const TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  'Số tiền chưa TT:',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                StringUtils.formatNumberWithOutVND(
                                    pendingAmount),
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.ORANGE_DARK),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(width: 35),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  'HĐ đã TT:',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                completeCount.toString(),
                                style: const TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  'Số tiền đã TT:',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                StringUtils.formatNumberWithOutVND(
                                    completeAmount),
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.GREEN),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  );
                },
              ),
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
            model.status == ViewStatus.Error ||
            model.metadata == null) {
          return const SizedBox.shrink();
        }

        MetaDataDTO paging = model.metadata!;
        if (paging.page! != paging.totalPage!) {
          isPaging = true;
        }
        double indexTotal =
            paging.page != 1 ? ((pageSize * paging.page!) / 2) + 1 : 1;
        int totalOfCurrentPage = (pageSize * paging.page!) > paging.total!
            ? paging.total!
            : pageSize * paging.page!;
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
                        onTap: () {
                          model.filterListInvoice(
                            size: value,
                            page: paging.page!,
                            filterType: filterSelect.type,
                            search: textEditingController.text,
                          );
                        },
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
                '$indexTotal-$totalOfCurrentPage của ${paging.total}',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(width: 15),
              InkWell(
                onTap: () async {
                  if (paging.page != 1) {
                    await model.filterListInvoice(
                      size: pageSize,
                      page: paging.page! - 1,
                      filterType: filterSelect.type,
                      search: textEditingController.text,
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
                      size: pageSize,
                      page: paging.page! + 1,
                      filterType: filterSelect.type,
                      search: textEditingController.text,
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
