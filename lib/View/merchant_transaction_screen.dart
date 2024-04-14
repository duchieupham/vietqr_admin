import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/instance_manager.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/merchant_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

import '../commons/widget/dialog_pick_month.dart';
import '../main.dart';

class MerchantTransactionScreen extends StatefulWidget {
  const MerchantTransactionScreen({super.key});

  @override
  State<MerchantTransactionScreen> createState() =>
      _MerchantTransactionScreenState();
}

class _MerchantTransactionScreenState extends State<MerchantTransactionScreen> {
  TextEditingController controller = TextEditingController(text: '');
  late MerchantViewModel _model;
  DateTime? selectDate;
  String? searchValue = '';

  @override
  void initState() {
    super.initState();
    _model = Get.find<MerchantViewModel>();
    selectDate = _model.getPreviousDay();
  }

  void _onPickDay(DateTime dateTime) async {
    DateTime? date = await showDateTimePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2021, 6),
      lastDate: dateTime,
    );
    setState(() {
      selectDate = date;
    });
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
    setState(() {
      selectDate = result;
    });
    print(selectDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_TEXT.withOpacity(0.3),
      body: ScopedModel(
          model: _model,
          child: ScopedModelDescendant<MerchantViewModel>(
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
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 25, 30, 25),
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
                    ),
                    const Divider(),
                    Expanded(
                      child: Container(
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
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Tìm kiếm theo ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 480,
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColor.GREY_DADADA)),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            child: DropdownButton<int>(
                                              isExpanded: true,
                                              value: model.type,
                                              underline:
                                                  const SizedBox.shrink(),
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
                                            height: 50,
                                            child: VerticalDivider(
                                              thickness: 1,
                                              color: AppColor.GREY_DADADA,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType:
                                                  TextInputType.multiline,
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
                                                  hintText: 'Nhập mã ở đây',
                                                  hintStyle: TextStyle(
                                                      fontSize: 20,
                                                      color: AppColor.BLACK
                                                          .withOpacity(0.5)),
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  prefixIcon: const Icon(
                                                    Icons.search,
                                                    size: 15,
                                                  ),
                                                  prefixIconColor:
                                                      AppColor.GREY_TEXT,
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
                                const SizedBox(width: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Thời gian",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 300,
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColor.GREY_DADADA)),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            child: DropdownButton<int>(
                                              isExpanded: true,
                                              value: model.filterByDate,
                                              underline:
                                                  const SizedBox.shrink(),
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
                                                  _onPickMonth(
                                                      model.getPreviousMonth());
                                                } else {
                                                  _onPickDay(
                                                      model.getPreviousDay());
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      model.filterByDate == 1
                                                          ? (selectDate == null
                                                              ? '${model.getPreviousMonth().month}/${model.getPreviousMonth().year}'
                                                              : '${selectDate?.month}/${selectDate?.year}')
                                                          : (selectDate == null
                                                              ? '${model.getPreviousDay().day}/${model.getPreviousDay().month}/${model.getPreviousDay().year}'
                                                              : '${selectDate?.day}/${selectDate?.month}/${selectDate?.year}'),
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    const Icon(Icons
                                                        .calendar_month_outlined)
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
                                      style: TextStyle(
                                          fontSize: 15, color: AppColor.WHITE),
                                    ),
                                    const SizedBox(height: 10),
                                    InkWell(
                                      onTap: () async {
                                        await model.filterListMerchant(
                                            time: selectDate!,
                                            page: 1,
                                            value: searchValue ?? '');
                                      },
                                      child: Container(
                                        height: 50,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColor.BLUE_TEXT,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.search,
                                              size: 15,
                                              color: AppColor.WHITE,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "Tìm kiếm",
                                              style: TextStyle(
                                                  color: AppColor.WHITE,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
