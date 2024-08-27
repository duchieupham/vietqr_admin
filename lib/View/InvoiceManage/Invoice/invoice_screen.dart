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
import 'package:vietqr_admin/View/SystemManage/BankSystem/bank_system_screen.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/utils/share_utils.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/models/DTO/data_filter_dto.dart';
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
  bool isHover = false;

  String? selectInvoiceId;

  int? type = 9;
  int pageSize = 20;

  String? status = '';

  late InvoiceViewModel _model;

  List<ChoiceChipItem> listChoiceChips = [
    ChoiceChipItem(title: 'Tất cả', value: 9),
    ChoiceChipItem(title: 'Phí GD', value: 0),
    ChoiceChipItem(title: 'Phí kích hoạt DV', value: 1),
    ChoiceChipItem(title: 'Nạp tiền ĐT', value: 2),
  ];

  int _choiceChipSelected = 9;

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
      invoiceType: _choiceChipSelected,
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
                  _headerWidget(model),
                  const Divider(
                    color: AppColor.GREY_DADADA,
                  ),
                  if (model.pageType == PageInvoice.LIST) ...[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(30, 4, 30, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Loại hóa đơn:",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 4.0,
                                      children: List<Widget>.generate(
                                        4,
                                        (int index) {
                                          return ChoiceChip(
                                            padding: EdgeInsets.zero,
                                            labelPadding: EdgeInsets.zero,
                                            selectedColor: Colors.transparent,
                                            side: const BorderSide(
                                                color: Colors.transparent),
                                            backgroundColor: Colors.transparent,
                                            showCheckmark: false,
                                            label: Container(
                                              decoration: BoxDecoration(
                                                gradient: _choiceChipSelected ==
                                                        listChoiceChips[index]
                                                            .value
                                                    ? VietQRTheme.gradientColor
                                                        .brightBlueLinear
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Row(
                                                children: [
                                                  _choiceChipSelected ==
                                                          listChoiceChips[index]
                                                              .value
                                                      ? Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 4),
                                                          height: 20,
                                                          width: 20,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          child: const Center(
                                                              child: Icon(
                                                            Icons.check,
                                                            color: AppColor
                                                                .BLUE_TEXT,
                                                            size: 15,
                                                          )),
                                                        )
                                                      : const SizedBox.shrink(),
                                                  Text(
                                                    listChoiceChips[index]
                                                        .title,
                                                    style: TextStyle(
                                                      color:
                                                          _choiceChipSelected ==
                                                                  listChoiceChips[
                                                                          index]
                                                                      .value
                                                              ? Colors.white
                                                              : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            selected: _choiceChipSelected ==
                                                listChoiceChips[index].value,
                                            onSelected: (bool selected) {
                                              setState(() {
                                                _choiceChipSelected = (selected
                                                    ? listChoiceChips[index]
                                                        .value
                                                    : null)!;
                                              });
                                              textEditingController.clear();
                                              model.clearSelectMerchant();
                                              model.filterListInvoice(
                                                invoiceType:
                                                    _choiceChipSelected,
                                                size: pageSize,
                                                page: 1,
                                                filterType: filterSelect.type,
                                                search:
                                                    textEditingController.text,
                                              );
                                            },
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'Tìm kiếm theo',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    FilterInvoiceWidget(
                                      invoiceType: _choiceChipSelected,
                                      onCall: (subType) {
                                        textEditingController =
                                            TextEditingController();

                                        model.filterListInvoice(
                                          invoiceType: _choiceChipSelected,
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
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
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
                                    // _filter(),

                                    // _filterWidget(),
                                    if (filterSelect.type == 0)
                                      ListInvoiceWidget(
                                        pageSize: pageSize,
                                        onShowPopup: onShowPopup,
                                        onEdit: (dto) {
                                          setState(() {
                                            selectInvoiceId = dto.invoiceId;
                                          });
                                          _model.onChangePage(PageInvoice.EDIT);
                                          _clearFilter();
                                        },
                                        onDetail: (invoiceId) {
                                          setState(() {
                                            selectInvoiceId = invoiceId;
                                          });
                                          _model
                                              .onChangePage(PageInvoice.DETAIL);
                                          _clearFilter();
                                        },
                                      )
                                    else
                                      ListMerchantWidget(
                                        pageSize: pageSize,
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
                  ] else if (model.pageType == PageInvoice.DETAIL) ...[
                    Expanded(
                      child: InvoiceDetailScreen(
                          callback: () {
                            _model.onChangePage(PageInvoice.LIST);

                            _model.filterListInvoice(
                              invoiceType: _choiceChipSelected,
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
                              invoiceType: _choiceChipSelected,
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
                            invoiceType: _choiceChipSelected,
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

  void _clearFilter() {
    _choiceChipSelected = 9;
    textEditingController.clear();
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
                      _model.changeTypeInvoice(0);

                      _model.filterListInvoice(
                        invoiceType: _choiceChipSelected,
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
        ],
      ),
    );
  }

  Widget _headerWidget(InvoiceViewModel model) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
      // width: MediaQuery.of(context).size.width *
      //     (model.pageType == PageInvoice.LIST ? 0.22 : 0.33),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (model.pageType == PageInvoice.LIST) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Lọc theo:",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
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
                          _choiceChipSelected = 9;
                        });
                        _model.changeTypeInvoice(0);

                        _model.filterListInvoice(
                          invoiceType: _choiceChipSelected,
                          size: pageSize,
                          page: 1,
                          filterType: e.type,
                          search: '',
                        );
                      },
                    );
                  },
                ),
                // const Spacer(),
              ],
            ),
          ] else
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
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      )
                    : InkWell(
                        onTap: () {
                          _model.onChangePage(PageInvoice.LIST);

                          _model.filterListInvoice(
                            invoiceType: _choiceChipSelected,
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
              } else if (filterSelect.type == 1 && model.merchantData != null) {
                pendingCount = model.merchantData!.extraData.pendingCount;
                completeCount = model.merchantData!.extraData.completeCount;
                pendingAmount = model.merchantData!.extraData.pendingAmount;
                completeAmount = model.merchantData!.extraData.completeAmount;
              }
              return Row(
                children: [
                  if (model.pageType == PageInvoice.LIST) ...[
                    PopupMenuButton<DataFilter>(
                      offset: const Offset(-100, 0),
                      padding: const EdgeInsets.all(0),
                      onSelected: (DataFilter result) async {
                        model.updateFilterTime(result);
                        model.selectDateTime(model.getMonth());
                        await model.filterListInvoice(
                          invoiceType: _choiceChipSelected,
                          size: pageSize,
                          page: 1,
                          filterType: filterSelect.type,
                          search: textEditingController.text,
                        );
                      },
                      itemBuilder: (BuildContext context) => _buildMenuItems(
                          model.listFilterTime, model.valueFilterTime),
                      elevation: 4,
                      initialValue: model.valueFilterTime,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      icon: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: isHover
                                ? AppColor.GREY_TEXT.withOpacity(0.1)
                                : AppColor.TRANSPARENT),
                        child: const Row(
                          children: [
                            Icon(Icons.filter_alt,
                                size: 15, color: AppColor.GREY_TEXT),
                            SizedBox(width: 4),
                            Text(
                              'Thời gian',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppColor.GREY_TEXT,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 110,
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
                            width: 110,
                            child: Text(
                              'Số tiền chưa TT:',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          Text(
                            StringUtils.formatNumberWithOutVND(pendingAmount),
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
                            width: 110,
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
                            width: 110,
                            child: Text(
                              'Số tiền đã TT:',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          Text(
                            StringUtils.formatNumberWithOutVND(completeAmount),
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

        int totalOfCurrentPage = (pageSize * paging.page!) > paging.total!
            ? paging.total!
            : pageSize * paging.page!;
        double indexTotal =
            paging.page != 1 ? (totalOfCurrentPage - pageSize) + 1 : 1;
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
                            invoiceType: _choiceChipSelected,
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
                      invoiceType: _choiceChipSelected,
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
                      invoiceType: _choiceChipSelected,
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

  List<PopupMenuEntry<DataFilter>> _buildMenuItems(
      List<DataFilter> value, DataFilter selected) {
    List<PopupMenuEntry<DataFilter>> items = value
        .map(
          (e) => PopupMenuItem<DataFilter>(
            value: e,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: selected.id == e.id
                        ? AppColor.BLUE_TEXT.withOpacity(0.1)
                        : AppColor.TRANSPARENT),
                child: Center(
                  child: Text(
                    e.name,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: selected.id == e.id
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                )),
          ),
        )
        .toList();

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
}

class FilterInvoice {
  String title;
  int type;

  FilterInvoice({required this.title, required this.type});
}
