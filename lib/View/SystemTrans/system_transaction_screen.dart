import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/SystemTrans/widgets/item_right_widget.dart';
import 'package:vietqr_admin/View/SystemTrans/widgets/item_system_transaction_widget.dart';
import 'package:vietqr_admin/ViewModel/system_transaction_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/widget/table_widget.dart';
import 'package:vietqr_admin/models/DTO/system_transaction_dto.dart';

import '../../commons/constants/enum/view_status.dart';
import '../../commons/constants/utils/custom_scroll.dart';
import '../../commons/constants/utils/string_utils.dart';
import '../../commons/widget/dialog_pick_month.dart';
import '../../commons/widget/dialog_pick_year.dart';
import '../../commons/widget/separator_widget.dart';
import '../../main.dart';
import '../../models/DTO/metadata_dto.dart';
import 'widgets/title_item_system_widget.dart';

class SystemTransactionScreen extends StatefulWidget {
  const SystemTransactionScreen({super.key});

  @override
  State<SystemTransactionScreen> createState() =>
      _SystemTransactionScreenState();
}

class _SystemTransactionScreenState extends State<SystemTransactionScreen> {
  TextEditingController controller = TextEditingController(text: '');
  ScrollController scrollControllerList = ScrollController();
  late SystemTransactionViewModel _model;

  late ScrollController controller1;
  late ScrollController controller2;
  late ScrollController horizonController1;
  late ScrollController horizonController2;

  bool isScrollingDown1 = false;
  bool isScrollingDown2 = false;
  bool isScrollingHorizon = false;
  DateTime? selectDate;
  String? searchValue = '';

  @override
  void initState() {
    super.initState();
    _model = Get.find<SystemTransactionViewModel>();
    _initData();
  }

  void _initData() {
    if (_model.filterByDate == 2) {
      selectDate = _model.getPreviousYear();
    } else {
      selectDate = _model.getPreviousMonth();
    }

    _model.filterListSystemTransaction(time: selectDate!, page: 1);

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
      _model.filterListSystemTransaction(time: selectDate!, page: 1);
    } else {
      selectDate = _model.getPreviousYear();
    }
  }

  void _onPickYear(DateTime dateTime) async {
    // Hiển thị dialog chỉ để chọn năm.
    DateTime result = await showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
            child: DialogPickYear(
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
      _model.filterListSystemTransaction(time: selectDate!, page: 1);
    } else {
      selectDate = _model.getPreviousYear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_TEXT.withOpacity(0.3),
      body: ScopedModel(
          model: _model,
          child: ScopedModelDescendant<SystemTransactionViewModel>(
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
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 25, 30, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tìm kiếm thông tin ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          _filterWidget(),
                          const SizedBox(height: 20),
                          const MySeparator(
                            color: AppColor.GREY_DADADA,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Thống kê giao dịch hệ thống",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),

                          // _showTotalSystemTransaction(),
                        ],
                      ),
                    ),
                    // _buildListSystemTransaction(),
                    _buildList(),
                    const SizedBox(height: 10),
                    _pagingWidget(),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 25, 30, 10),
      width: MediaQuery.of(context).size.width * 0.22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Thống kê",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "/",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Thống kê giao dịch",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _filterWidget() {
    return ScopedModelDescendant<SystemTransactionViewModel>(
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
                  width: 350,
                  height: 40,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.GREY_DADADA)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
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
                                value: 1,
                                child: Text(
                                  "Tháng",
                                )),
                            DropdownMenuItem<int>(
                                value: 2,
                                child: Text(
                                  "Năm",
                                )),
                          ],
                          onChanged: (value) {
                            model.changeTime(value);
                            if (value == 1)
                              selectDate = model.getPreviousMonth();
                            else
                              selectDate = model.getPreviousYear();
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
                              _onPickYear(model.getPreviousYear());
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  model.filterByDate == 2
                                      ? (selectDate == null
                                          ? '${model.getPreviousYear().year}'
                                          : '${selectDate?.year}')
                                      : (selectDate == null
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
                    await model.filterListSystemTransaction(
                      time: selectDate!,
                      page: 1,
                    );
                  },
                  child: Container(
                    height: 40,
                    width: 150,
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

  Widget _showTotalSystemTransaction() {
    return ScopedModelDescendant<SystemTransactionViewModel>(
      builder: (context, child, model) {
        return model.systemTransactionDTO != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.filterByDate == 1
                        ? "GD hệ thống tháng ${DateFormat('MM-yyyy').format(selectDate!)}"
                        : "GD hệ thống năm ${DateFormat('yyyy').format(selectDate!)}",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 60),
                  SizedBox(
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("Tổng GD:      "),
                            Text(
                              "${model.systemTransactionDTO?.extraData.totalCount} ",
                              style: const TextStyle(
                                  color: AppColor.BLUE_TEXT,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text("GD - "),
                            Text(
                              StringUtils.formatNumber(model
                                  .systemTransactionDTO?.extraData.totalTrans),
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
                              "${model.systemTransactionDTO?.extraData.recCountTotal} ",
                              style: const TextStyle(
                                  color: AppColor.GREEN,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text("GD - "),
                            Text(
                              StringUtils.formatNumber(model
                                  .systemTransactionDTO?.extraData.recTotal),
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
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("Đến: "),
                            Text(
                              "${model.systemTransactionDTO?.extraData.creCountTotal} ",
                              style: const TextStyle(
                                  color: AppColor.BLUE_TEXT,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text("GD - "),
                            Text(
                              StringUtils.formatNumber(model
                                  .systemTransactionDTO?.extraData.creditTotal),
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
                              "${model.systemTransactionDTO?.extraData.deCountTotal} ",
                              style: const TextStyle(
                                  color: AppColor.RED_TEXT,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text("GD - "),
                            Text(
                              StringUtils.formatNumber(model
                                  .systemTransactionDTO?.extraData.debitTotal),
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
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildList() {
    return ScopedModelDescendant<SystemTransactionViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading) {
          return const Expanded(child: Center(child: Text('Đang tải...')));
        }
        if (model.status == ViewStatus.Error) {
          return const SizedBox.shrink();
        }
        List<SystemTransactionData>? list;
        SysTransExtraData? extra;
        if (model.systemTransactionDTO != null) {
          list = model.systemTransactionDTO?.data;
          extra = model.systemTransactionDTO!.extraData;
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
                    ItemSysWidget(
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
              width: 1100,
              header: TitleItemSystemTransactionWidget(
                  controller: horizonController1,
                  extra: extra!,
                  time: selectDate!),
              columnWidget: Container(
                height: 450,
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
              hasData: hasData,
              expandedTable: Container(
                height: 450,
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
    return ScopedModelDescendant<SystemTransactionViewModel>(
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
                          await model.filterListSystemTransaction(
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
                          await model.filterListSystemTransaction(
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
