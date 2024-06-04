import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/FeeManage/AnnualFeeAfter/widgets/item_widget.dart';
import 'package:vietqr_admin/View/FeeManage/AnnualFeeAfter/widgets/title_item_widget.dart';
import '../../../ViewModel/annualFee_viewModel.dart';
import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/constants/enum/view_status.dart';
import '../../../commons/constants/utils/custom_scroll.dart';
import '../../../commons/constants/utils/string_utils.dart';
import '../../../commons/widget/dialog_pick_month.dart';
import '../../../commons/widget/separator_widget.dart';
import '../../../main.dart';
import '../../../models/DTO/annual_fee_after_dto.dart';
import '../../../models/DTO/metadata_dto.dart';

class AnnualFeeAfterScreen extends StatefulWidget {
  const AnnualFeeAfterScreen({super.key});

  @override
  State<AnnualFeeAfterScreen> createState() => _AnnualFeeAfterScreenState();
}

class _AnnualFeeAfterScreenState extends State<AnnualFeeAfterScreen> {
  TextEditingController controller = TextEditingController(text: '');
  late ScrollController controller1;
  late ScrollController controller2;
  bool isScrollingDown1 = false;
  bool isScrollingDown2 = false;

  late AnnualFeeAfterViewModel _model;
  DateTime? selectDate;
  String? searchValue = '';

  @override
  void initState() {
    super.initState();
    _model = Get.find<AnnualFeeAfterViewModel>();
    selectDate = _model.getPreviousDay();
    _model.filterListAnnualFeeAfter(time: selectDate!, page: 1);

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
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  void _onPickDay(DateTime dateTime) async {
    DateTime? date = await showDateTimePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2021, 6),
      lastDate: dateTime,
    );
    if (date != null) {
      setState(() {
        selectDate = date;
      });
    } else {
      selectDate = _model.getPreviousDay();
    }
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    return selectedDate;
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
    setState(() {
      selectDate = result;
    });
    print(selectDate);
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
                      "Tìm kiếm thông tin ",
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
                    _statisticAnnualFee(),
                  ],
                ),
              ),
              _buildListAnnualFee(),
              const SizedBox(height: 10),
              _pagingWidget(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
      width: MediaQuery.of(context).size.width * 0.22,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Phí",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "/",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Phí thường niên",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _filterWidget() {
    return ScopedModelDescendant<AnnualFeeAfterViewModel>(
      builder: (context, child, model) {
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Chọn dịch vụ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 250,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.GREY_DADADA)),
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
                          value: 0,
                          child: Text(
                            "Tất cả (mặc định)",
                          )),
                      DropdownMenuItem<int>(
                          value: 1,
                          child: Text(
                            "Phần mềm VietQR",
                          )),
                      DropdownMenuItem<int>(
                          value: 2,
                          child: Text(
                            "Quản lý cửa hàng",
                          )),
                    ],
                    onChanged: (value) {
                      model.changeType(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tìm kiếm theo",
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
                                  model.filterByDate == 0
                                      ? (selectDate == null
                                          ? '${model.getPreviousMonth().month}/${model.getPreviousMonth().year}'
                                          : '${selectDate?.month}/${selectDate?.year}')
                                      : (selectDate == null
                                          ? '${model.getPreviousDay().day}/${model.getPreviousDay().month}/${model.getPreviousDay().year}'
                                          : '${selectDate?.day}/${selectDate?.month}/${selectDate?.year}'),
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
                    await model.filterListAnnualFeeAfter(
                        time: selectDate!, page: 1);
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(12),
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
                          style: TextStyle(color: AppColor.WHITE, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _statisticAnnualFee() {
    return ScopedModelDescendant<AnnualFeeAfterViewModel>(
      builder: (context, child, model) {
        return model.annualFeeAfterDTO != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Thống kê phí thường niên",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.filterByDate == 1
                            ? "Phí thường niên ngày ${DateFormat('dd-MM-yyyy').format(selectDate!)}"
                            : 'Phí thường niên tháng ${DateFormat('MM-yyyy').format(selectDate!)}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 60),
                      SizedBox(
                        height: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text("Phí giao dịch:     "),
                                Text(
                                  StringUtils.formatNumber(model
                                      .annualFeeAfterDTO?.extraData.transFee),
                                  style: const TextStyle(
                                      color: AppColor.BLUE_TEXT,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(" VND"),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Đã TT:                 "),
                                Text(
                                  StringUtils.formatNumber(model
                                      .annualFeeAfterDTO
                                      ?.extraData
                                      .completeFee),
                                  style: const TextStyle(
                                      color: AppColor.GREEN,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(" VND"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      SizedBox(
                        height: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Text("Chưa TT:            "),
                                Text(
                                  StringUtils.formatNumber(model
                                      .annualFeeAfterDTO?.extraData.pendingFee),
                                  style: const TextStyle(
                                      color: AppColor.RED_TEXT,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(" VND "),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildListAnnualFee() {
    return ScopedModelDescendant<AnnualFeeAfterViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading) {
          return const Expanded(child: Center(child: Text('Đang tải...')));
        }
        if (model.status == ViewStatus.Error) {
          return const SizedBox.shrink();
        }
        List<AnnualItems>? list = model.annualFeeAfterDTO?.items;
        List<Widget> buildItemList(
            List<AnnualItems>? list, MetaDataDTO metadata) {
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
                    ItemAnnualWidget(
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
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
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
                                width: 1400,
                                child: Column(
                                  children: [
                                    const TitleItemAnnualWidget(),
                                    ...buildItemList(list, metadata),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 1400,
                          child: Row(
                            children: [
                              Expanded(child: Container()),
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
                                          child: Container(
                                              height: 50,
                                              width: 130,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColor.GREY_TEXT
                                                          .withOpacity(0.3))),
                                              child: const Text(
                                                'Trạng thái',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColor.BLACK,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ),
                                        ...list.map(
                                          (e) {
                                            return Container(
                                              alignment: Alignment.center,
                                              child: Container(
                                                padding: const EdgeInsets.only(
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
                                                height: 60,
                                                width: 130,
                                                child: SelectionArea(
                                                  child: Text(
                                                    e.status == 0
                                                        ? 'Chưa TT'
                                                        : 'Đã TT',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: e.status == 0
                                                            ? AppColor
                                                                .ORANGE_DARK
                                                            : AppColor.GREEN),
                                                  ),
                                                ),
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

  Widget _pagingWidget() {
    return ScopedModelDescendant<AnnualFeeAfterViewModel>(
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
                          await model.filterListAnnualFeeAfter(
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
                          await model.filterListAnnualFeeAfter(
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
