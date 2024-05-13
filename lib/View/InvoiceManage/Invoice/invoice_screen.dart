import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/models/DTO/invoice_dto.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/constants/enum/view_status.dart';
import '../../../commons/constants/utils/custom_scroll.dart';
import '../../../commons/constants/utils/string_utils.dart';
import '../../../commons/widget/dialog_pick_month.dart';
import '../../../commons/widget/separator_widget.dart';
import '../../../main.dart';
import '../../../models/DTO/metadata_dto.dart';
import '../widgets/item_invoice_widget.dart';
import '../widgets/title_invoice_widget.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late ScrollController controller1;
  late ScrollController controller2;
  bool isScrollingDown1 = false;
  bool isScrollingDown2 = false;

  DateTime? selectDate;
  late InvoiceViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    selectDate = _model.getPreviousMonth();
    _model.filterListInvoice(time: selectDate!, page: 1);

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

  void _onPickMonth(DateTime dateTime) async {
    DateTime result = await showDialog(
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
      _model.filterListInvoice(time: selectDate!, page: 1);
    } else {
      selectDate = _model.getPreviousMonth();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      body: ScopedModel(
        model: _model,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerWidget(),
              const Divider(),
              Container(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tìm kiếm thông tin hoá đơn ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _statisticInvoice(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              _buildListInvoice(),
              const SizedBox(height: 10),
              _pagingWidget(),
              const SizedBox(height: 10),
            ],
          ),
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
        if (model.status == ViewStatus.Error) {
          return const SizedBox.shrink();
        }
        List<InvoiceItem>? list = model.invoiceDTO?.items;
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
        return list != null
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 220,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          controller: controller1,
                          child: ScrollConfiguration(
                            behavior: MyCustomScrollBehavior(),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: 2100,
                                child: Column(
                                  children: [
                                    const TitleItemInvoiceWidget(),
                                    ...buildItemList(list, metadata),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          // width: 1890,
                          width: 2100,
                          child: Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              SingleChildScrollView(
                                controller: controller2,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
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
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColor
                                                              .GREY_TEXT
                                                              .withOpacity(
                                                                  0.3))),
                                                  child: const Text(
                                                    'Trạng thái',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColor.BLACK,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              Container(
                                                  height: 50,
                                                  width: 210,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColor
                                                              .GREY_TEXT
                                                              .withOpacity(
                                                                  0.3))),
                                                  child: const Text(
                                                    'Thao tác',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColor.BLACK,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        ...list.map(
                                          (e) {
                                            return Container(
                                              alignment: Alignment.center,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            left: BorderSide(
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
                                                                        0.3)))),
                                                    height: 50,
                                                    width: 130,
                                                    child: SelectionArea(
                                                      child: Text(
                                                        e.status == 0
                                                            ? 'Chờ thanh toán'
                                                            : 'Đã thanh toán',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: e.status == 0
                                                                ? AppColor
                                                                    .ORANGE_DARK
                                                                : AppColor
                                                                    .GREEN),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            left: BorderSide(
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
                                                                        0.3)))),
                                                    height: 50,
                                                    width: 210,
                                                    child: SelectionArea(
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColor
                                                                    .BLUE_TEXT
                                                                    .withOpacity(
                                                                        0.3),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: const Icon(
                                                                Icons.qr_code,
                                                                size: 12,
                                                                color: AppColor
                                                                    .BLUE_TEXT,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColor
                                                                    .BLUE_TEXT
                                                                    .withOpacity(
                                                                        0.3),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: const Icon(
                                                                Icons
                                                                    .info_outline,
                                                                size: 12,
                                                                color: AppColor
                                                                    .BLUE_TEXT,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColor
                                                                    .BLUE_TEXT
                                                                    .withOpacity(
                                                                        0.3),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: const Icon(
                                                                Icons.edit,
                                                                size: 12,
                                                                color: AppColor
                                                                    .BLUE_TEXT,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColor
                                                                    .BLUE_TEXT
                                                                    .withOpacity(
                                                                        0.3),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: const Icon(
                                                                Icons.list,
                                                                size: 12,
                                                                color: AppColor
                                                                    .BLUE_TEXT,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColor
                                                                    .RED_TEXT
                                                                    .withOpacity(
                                                                        0.3),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: const Icon(
                                                                Icons
                                                                    .delete_forever,
                                                                size: 12,
                                                                color: AppColor
                                                                    .RED_TEXT,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
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
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _statisticInvoice() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        return model.invoiceDTO != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        // color: AppColor.WHITE,
                        border: Border.all(
                            color: AppColor.GREY_DADADA, width: 0.5)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          color: AppColor.BLUE_TEXT.withOpacity(0.3),
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Center(
                            child: Text(
                              model.filterByDate == 0
                                  ? "Ngày ${DateFormat('dd-MM-yyyy').format(selectDate!)}"
                                  // : 'Tháng ${DateFormat('MM-yyyy').format(selectDate!)}',
                                  : 'Tháng',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: AppColor.GREY_DADADA,
                        ),
                        Container(
                          width: 120,
                          height: 50,
                          color: AppColor.WHITE,
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('MM/yyyy').format(selectDate!),
                                style: const TextStyle(
                                    fontSize: 15, color: AppColor.BLACK),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        border: Border.all(
                            color: AppColor.GREY_DADADA, width: 0.5)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          color: AppColor.BLUE_TEXT.withOpacity(0.3),
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          child: const Center(
                            child: Text(
                              'Chưa TT',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: AppColor.GREY_DADADA,
                        ),
                        Container(
                          height: 50,
                          color: AppColor.WHITE,
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${model.invoiceDTO!.extraData.pendingCount} HĐ - ${StringUtils.formatNumberWithOutVND(model.invoiceDTO!.extraData.pendingFee)}',
                                // StringUtils.formatNumberWithOutVND(
                                //     model.invoiceDTO!.extraData.pendingFee),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.ORANGE_DARK),
                              ),
                              const Text(
                                ' VND',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: AppColor.RED_TEXT,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        border: Border.all(
                            color: AppColor.GREY_DADADA, width: 0.5)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          color: AppColor.BLUE_TEXT.withOpacity(0.3),
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          child: const Center(
                            child: Text(
                              'Đã TT',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: AppColor.GREY_DADADA,
                        ),
                        Container(
                          height: 50,
                          color: AppColor.WHITE,
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${model.invoiceDTO!.extraData.completeCount} HĐ - ${StringUtils.formatNumberWithOutVND(model.invoiceDTO!.extraData.completeFee)}',

                                // StringUtils.formatNumberWithOutVND(
                                //     model.invoiceDTO!.extraData.completeFee),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.GREEN),
                              ),
                              const Text(
                                ' VND',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: AppColor.GREEN,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
      width: MediaQuery.of(context).size.width * 0.22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Quản lý hoá đơn",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "/",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Danh sách hoá đơn",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _filterWidget() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tìm kiếm theo",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  width: model.value == 9 ? 250 : 500,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.GREY_DADADA)),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
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
                                height: 50,
                                child: VerticalDivider(
                                  thickness: 1,
                                  color: AppColor.GREY_DADADA,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: SizedBox(
                                  width: 234,
                                  // padding: const EdgeInsets.symmetric(
                                  //     horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        'Chọn đại lý',
                                        style: TextStyle(
                                            color: AppColor.GREY_TEXT,
                                            fontSize: 15),
                                      ),
                                      Icon(
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
                            children: const [
                              SizedBox(width: 8),
                              SizedBox(
                                height: 50,
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
                                  decoration: InputDecoration(
                                    // contentPadding:
                                    //     EdgeInsets.only(bottom: 0),
                                    border: InputBorder.none,
                                    hintText: 'Nhập mã hoá đơn',
                                    hintStyle: TextStyle(
                                        fontSize: 15,
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
                            children: const [
                              SizedBox(width: 8),
                              SizedBox(
                                height: 50,
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
                                  decoration: InputDecoration(
                                    // contentPadding:
                                    //     EdgeInsets.only(bottom: 0),
                                    border: InputBorder.none,
                                    hintText: 'Nhập số TK ngân hàng',
                                    hintStyle: TextStyle(
                                        fontSize: 15,
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
                            children: const [
                              SizedBox(width: 8),
                              SizedBox(
                                height: 50,
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
                                  decoration: InputDecoration(
                                    // contentPadding:
                                    //     EdgeInsets.only(bottom: 0),
                                    border: InputBorder.none,
                                    hintText: 'Nhập TK VietQR',
                                    hintStyle: TextStyle(
                                        fontSize: 15,
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
                              SizedBox(width: 8),
                              SizedBox(
                                height: 50,
                                child: VerticalDivider(
                                  thickness: 1,
                                  color: AppColor.GREY_DADADA,
                                ),
                              ),
                              SizedBox(
                                width: 234,
                                height: 50,
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
                                          "Đã thanh toán",
                                        )),
                                    DropdownMenuItem<int>(
                                        value: 1,
                                        child: Text(
                                          "Chưa thanh toán",
                                        )),
                                  ],
                                  onChanged: (value) {
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
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
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
                        width: 50,
                        child: Center(
                          child: Text('Tháng'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const SizedBox(
                        height: 50,
                        child: VerticalDivider(
                          thickness: 1,
                          color: AppColor.GREY_DADADA,
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _onPickMonth(model.getPreviousMonth());
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (selectDate == null
                                      ? '${model.getPreviousMonth().month}/${model.getPreviousMonth().year}'
                                      : '${selectDate?.month}/${selectDate?.year}'),
                                  style: const TextStyle(fontSize: 15),
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
                  style: TextStyle(fontSize: 15, color: AppColor.WHITE),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    await model.filterListInvoice(time: selectDate!, page: 1);
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.BLUE_TEXT,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.search,
                          size: 15,
                          color: AppColor.WHITE,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Tìm kiếm",
                          style: TextStyle(color: AppColor.WHITE, fontSize: 15),
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
                onTap: () {},
                child: MButtonWidget(
                  title: 'Tạo mới hoá đơn',
                  isEnable: true,
                  margin: EdgeInsets.zero,
                  width: 150,
                  colorEnableBgr: AppColor.WHITE,
                  colorEnableText: AppColor.BLUE_TEXT,
                  border: Border.all(color: AppColor.BLUE_TEXT),
                  radius: 10,
                  height: 50,
                ),
              ),
            ),
          ],
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
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 30),
                    InkWell(
                      onTap: () async {
                        if (paging.page != 1) {
                          await model.filterListInvoice(
                            time: selectDate!,
                            page: paging.page! - 1,
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
}