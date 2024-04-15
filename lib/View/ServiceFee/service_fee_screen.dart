import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/ServiceFee/widgets/item_widget.dart';
import 'package:vietqr_admin/View/ServiceFee/widgets/title_item_widget.dart';
import 'package:vietqr_admin/ViewModel/serviceFee_viewModel.dart';
import 'package:vietqr_admin/models/DTO/service_fee_dto.dart';

import '../../commons/constants/configurations/theme.dart';
import '../../commons/constants/enum/view_status.dart';
import '../../commons/constants/utils/custom_scroll.dart';
import '../../commons/constants/utils/string_utils.dart';
import '../../commons/widget/dialog_pick_month.dart';
import '../../commons/widget/separator_widget.dart';
import '../../main.dart';
import '../../models/DTO/metadata_dto.dart';

class ServiceFeeScreen extends StatefulWidget {
  const ServiceFeeScreen({super.key});

  @override
  State<ServiceFeeScreen> createState() => _ServiceFeeScreenState();
}

class _ServiceFeeScreenState extends State<ServiceFeeScreen> {
  TextEditingController controller = TextEditingController(text: '');
  ScrollController scrollControllerList = ScrollController();

  late ServiceFeeViewModel _model;
  DateTime? selectDate;
  String? searchValue = '';

  @override
  void initState() {
    super.initState();
    _model = Get.find<ServiceFeeViewModel>();
    selectDate = _model.getPreviousDay();
    _model.filterListServiceFee(time: selectDate!, page: 1);
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

    print(selectDate);
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
    } else {
      selectDate = _model.getPreviousMonth();
    }
    print(selectDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_TEXT.withOpacity(0.3),
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
                    _statisticServiceFee(),
                  ],
                ),
              ),
              _buildListMerchant(),
              const SizedBox(height: 10),
              // _pagingWidget(),
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
            "Phí",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "/",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Phí dịch vụ",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _filterWidget() {
    return ScopedModelDescendant<ServiceFeeViewModel>(
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
                  child: DropdownButton<String>(
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
                      DropdownMenuItem<String>(
                          value: 'Tất cả',
                          child: Text(
                            "Tất cả (mặc định)",
                          )),
                      DropdownMenuItem<String>(
                          value: 'Phần mềm VietQR',
                          child: Text(
                            "Phần mềm VietQR",
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
                    await model.filterListServiceFee(
                        time: selectDate!, page: 1);
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
          ],
        );
      },
    );
  }

  Widget _statisticServiceFee() {
    return ScopedModelDescendant<ServiceFeeViewModel>(
      builder: (context, child, model) {
        return model.serviceFeeDTO != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Thống kê phí dịch vụ",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.filterByDate == 0
                            ? "Phí dịch vụ ngày ${DateFormat('dd-MM-yyyy').format(selectDate!)}"
                            : 'Phí dịch vụ tháng ${DateFormat('MM-yyyy').format(selectDate!)}',
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
                                  StringUtils.formatNumber(
                                      model.serviceFeeDTO?.extraData.transFee),
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
                                      .serviceFeeDTO?.extraData.completeFee),
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
                                      .serviceFeeDTO?.extraData.pendingFee),
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

  Widget _buildListMerchant() {
    return ScopedModelDescendant<ServiceFeeViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading) {
          return const Expanded(child: Center(child: Text('Đang tải...')));
        }
        if (model.status == ViewStatus.Error) {
          return const SizedBox.shrink();
        }
        List<ServiceItems>? list = model.serviceFeeDTO?.items;
        List<Widget> buildItemList(
            List<ServiceItems>? list, MetaDataDTO metadata) {
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
                    ItemWidget(
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
                  child: SingleChildScrollView(
                    controller: scrollControllerList,
                    child: ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          // width: 1200,
                          child: Column(
                            children: [
                              const TitleItemWidget(),
                              ...buildItemList(list, metadata),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
