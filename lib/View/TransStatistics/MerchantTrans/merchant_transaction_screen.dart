import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/TransStatistics/MerchantTrans/widgets/item_widget.dart';
import 'package:vietqr_admin/View/TransStatistics/MerchantTrans/widgets/title_column_item_widget.dart';
import 'package:vietqr_admin/View/TransStatistics/MerchantTrans/widgets/title_row_item_widget.dart';
import 'package:vietqr_admin/ViewModel/merchant_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/merchant_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';

import '../../../commons/constants/utils/custom_scroll.dart';
import '../../../commons/constants/utils/string_utils.dart';
import '../../../commons/widget/dialog_pick_month.dart';
import '../../../commons/widget/table_widget.dart';
import '../../../main.dart';

class MerchantTransactionScreen extends StatefulWidget {
  const MerchantTransactionScreen({super.key});

  @override
  State<MerchantTransactionScreen> createState() =>
      _MerchantTransactionScreenState();
}

class _MerchantTransactionScreenState extends State<MerchantTransactionScreen> {
  TextEditingController controller = TextEditingController(text: '');

  late ScrollController controller1;
  late ScrollController controller2;
  late ScrollController horizonController1;
  late ScrollController horizonController2;

  bool isScrollingDown1 = false;
  bool isScrollingDown2 = false;
  bool isScrollingHorizon = false;

  late MerchantViewModel _model;
  DateTime? selectDate;
  String? searchValue = '';

  @override
  void initState() {
    super.initState();
    _model = Get.find<MerchantViewModel>();
    _initData();
  }

  void _initData() {
    if (_model.filterByDate == 0) {
      selectDate = _model.getPreviousDay();
    } else {
      selectDate = _model.getPreviousMonth();
    }

    _model.filterListMerchant(
        time: selectDate!, page: 1, value: searchValue ?? '');

    controller1 = ScrollController();
    controller2 = ScrollController();
    horizonController2 = ScrollController();
    horizonController1 = ScrollController();

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

    horizonController2.addListener(() {
      if (!isScrollingHorizon) {
        isScrollingHorizon = true;
        horizonController1.jumpTo(horizonController2.offset);
      }
      isScrollingHorizon = false;
    });
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
      _model.filterListMerchant(
          time: selectDate!, page: 1, value: searchValue ?? '');
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
    if (result != null) {
      setState(() {
        selectDate = result;
      });
      _model.filterListMerchant(
          time: selectDate!, page: 1, value: searchValue ?? '');
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
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Thống kê giao dịch đại lý",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // _statisticMerchant(),
                  ],
                ),
              ),
              // _buildListMerchant(),
              _buildList(),
              // FixedColumnTable(),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Thống kê GD",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "/",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Thống kê GD đại lý",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _filterWidget() {
    return ScopedModelDescendant<MerchantViewModel>(
      builder: (context, child, model) {
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tìm kiếm theo ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 40,
                  width: 480,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.GREY_DADADA)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: model.type,
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
                                  "Tên đại lý",
                                )),
                            DropdownMenuItem<int>(
                                value: 1,
                                child: Text(
                                  "Mã VSO",
                                )),
                            DropdownMenuItem<int>(
                                value: 2,
                                child: Text(
                                  "CCCD / MST",
                                )),
                          ],
                          onChanged: (value) {
                            model.changeType(value);
                          },
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
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          controller: controller,
                          onChanged: (value) {
                            setState(() {
                              searchValue = value;
                            });
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              searchValue = value;
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(top: 5, bottom: 5),
                              hintText: 'Nhập mã ở đây',
                              hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: AppColor.BLACK.withOpacity(0.5)),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 15,
                              ),
                              prefixIconColor: AppColor.GREY_TEXT,
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  size: 16,
                                  color: AppColor.GREY_TEXT,
                                ),
                                onPressed: () {
                                  controller.clear();
                                },
                              )),
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
                  height: 40,
                  width: 300,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.GREY_DADADA)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: model.filterByDate,
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
                                  "Ngày",
                                )),
                            DropdownMenuItem<int>(
                                value: 1,
                                child: Text(
                                  "Tháng",
                                )),
                          ],
                          onChanged: (value) {
                            model.changeTime(value);
                            if (value == 1)
                              selectDate = model.getPreviousMonth();
                            else
                              selectDate = model.getPreviousDay();
                          },
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
                            if (model.filterByDate == 1) {
                              _onPickMonth(model.getPreviousMonth());
                            } else {
                              _onPickDay(model.getPreviousDay());
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  model.filterByDate == 1
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
                    await model.filterListMerchant(
                        time: selectDate!, page: 1, value: searchValue ?? '');
                  },
                  child: Container(
                    height: 40,
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
          ],
        );
      },
    );
  }

  Widget _statisticMerchant() {
    return ScopedModelDescendant<MerchantViewModel>(
      builder: (context, child, model) {
        return model.merchantDTO != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Thống kê giao dịch đại lý",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.filterByDate == 0
                            ? "GD đại lý ngày ${DateFormat('dd-MM-yyyy').format(selectDate!)}"
                            : 'GD đại lý tháng ${DateFormat('MM-yyyy').format(selectDate!)}',
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
                                const Text("Tổng GD:      "),
                                Text(
                                  "${model.merchantDTO?.extraData.totalCount} ",
                                  style: const TextStyle(
                                      color: AppColor.BLUE_TEXT,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text("GD - "),
                                Text(
                                  StringUtils.formatNumber(
                                      model.merchantDTO?.extraData.totalTrans),
                                  style: const TextStyle(
                                      color: AppColor.BLUE_TEXT,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(" VND "),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Có đối soát: "),
                                Text(
                                  "${model.merchantDTO?.extraData.recCountTotal} ",
                                  style: const TextStyle(
                                      color: AppColor.GREEN,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text("GD - "),
                                Text(
                                  StringUtils.formatNumber(
                                      model.merchantDTO?.extraData.recTotal),
                                  style: const TextStyle(
                                      color: AppColor.GREEN,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(" VND "),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text("Đến: "),
                                Text(
                                  "${model.merchantDTO?.extraData.creCountTotal} ",
                                  style: const TextStyle(
                                      color: AppColor.BLUE_TEXT,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text("GD - "),
                                Text(
                                  StringUtils.formatNumber(
                                      model.merchantDTO?.extraData.creditTotal),
                                  style: const TextStyle(
                                      color: AppColor.BLUE_TEXT,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(" VND "),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Đi:    "),
                                Text(
                                  "${model.merchantDTO?.extraData.deCountTotal} ",
                                  style: const TextStyle(
                                      color: AppColor.RED_TEXT,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text("GD - "),
                                Text(
                                  StringUtils.formatNumber(
                                      model.merchantDTO?.extraData.debitTotal),
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

  Widget _buildList() {
    return ScopedModelDescendant<MerchantViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading) {
          return const Expanded(child: Center(child: Text('Đang tải...')));
        }
        if (model.status == ViewStatus.Error) {
          return const SizedBox.shrink();
        }

        List<MerchantData>? list;
        MerchantExtra? extra;
        if (model.merchantDTO != null) {
          list = model.merchantDTO?.data;
          extra = model.merchantDTO!.extraData;
        }

        bool hasData = true;
        if (list == null || list.isEmpty) {
          hasData = false;
        }
        List<Widget> buildItemRight() {
          if (list == null || list.isEmpty) {
            return [];
          }
          return list
              .asMap()
              .map((index, e) {
                return MapEntry(
                    index,
                    ItemWidget(
                      dto: e,
                    ));
              })
              .values
              .toList();
        }

        List<Widget> buildItemLeft(MetaDataDTO metadata) {
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
                    TitleColumnItemWidget(
                      dto: e,
                      index: calculatedIndex,
                    ));
              })
              .values
              .toList();
        }

        MetaDataDTO metadata = model.metadata!;

        return Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: TableWidget(
              width: 1400,
              hasData: hasData ? true : false,
              header: TitleRowItemWidget(
                  extra: extra, controller: horizonController1),
              columnWidget: Container(
                height: 500,
                decoration: BoxDecoration(
                  color:
                      Colors.white, // Set the background color of the container
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                          0.3), // Shadow color with some transparency
                      spreadRadius: 0, // No spread radius
                      blurRadius: 2, // Blur radius to create the blur effect
                      offset: const Offset(
                          2, 0), // Horizontal offset for right side shadow
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(
                          0.3), // Shadow color with some transparency
                      spreadRadius: 0, // No spread radius
                      blurRadius: 2, // Blur radius to create the blur effect
                      offset: const Offset(
                          -2, 0), // Horizontal offset for right side shadow
                    ),
                  ],
                ),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    controller: controller1,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [...buildItemLeft(metadata)],
                    ),
                  ),
                ),
              ),
              expandedTable: Container(
                height: 500,
                width: double.infinity,
                decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(color: AppColor.GREY_BUTTON),
                        bottom: BorderSide(color: AppColor.GREY_BUTTON))),
                child: SingleChildScrollView(
                  controller: controller2,
                  scrollDirection: Axis.vertical,
                  child: ScrollConfiguration(
                    behavior: MyCustomScrollBehavior(),
                    child: SingleChildScrollView(
                      controller: horizonController2,
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [...buildItemRight()],
                      ),
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }

  Widget _pagingWidget() {
    return ScopedModelDescendant<MerchantViewModel>(
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
                          await model.filterListMerchant(
                              time: selectDate!,
                              page: paging.page! - 1,
                              value: searchValue ?? '');
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
                          await model.filterListMerchant(
                              time: selectDate!,
                              page: paging.page! + 1,
                              value: searchValue ?? '');
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