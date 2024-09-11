import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/View/TransManage/SysTrans/bloc/transaction_bloc.dart';
import 'package:vietqr_admin/View/TransManage/SysTrans/event/transaction_event.dart';
import 'package:vietqr_admin/View/TransManage/SysTrans/provider/transaction_provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/month_calculator.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';

class FilterTransactionWidget extends StatefulWidget {
  final TextEditingController controller;
  final int pageSize;

  const FilterTransactionWidget(
      {super.key, required this.controller, required this.pageSize});

  @override
  State<FilterTransactionWidget> createState() =>
      _FilterTransactionWidgetState();
}

class _FilterTransactionWidgetState extends State<FilterTransactionWidget> {
  bool isHover = false;

  int statusSelect = 0;

  MonthCalculator monthCalculator = MonthCalculator();

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tìm kiếm theo:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 30,
                      width: 340,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColor.GREY_DADADA)),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 30,
                            width: 100,
                            child: DropdownButton<FilterTransaction>(
                              isExpanded: true,
                              value: provider.valueFilter,
                              underline: const SizedBox.shrink(),
                              borderRadius: BorderRadius.circular(5),
                              dropdownColor: AppColor.WHITE,
                              elevation: 4,
                              icon: const RotatedBox(
                                quarterTurns: 5,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                ),
                              ),
                              items: provider.listFilter
                                  .map<DropdownMenuItem<FilterTransaction>>(
                                      (FilterTransaction value) {
                                return DropdownMenuItem<FilterTransaction>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Text(
                                      value.title,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColor.GREY_TEXT),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (FilterTransaction? value) {
                                provider.changeFilter(value!);
                                if (value.id.type == TypeFilter.ALL) {
                                  provider.changeTimeFilter(
                                      const FilterTimeTransaction(
                                          id: 2, title: '7 ngày gần nhất'));
                                  onSearch(provider);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          const SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              thickness: 1,
                              color: AppColor.GREY_DADADA,
                            ),
                          ),
                          if (provider.valueFilter.id != 9)
                            Expanded(
                              child: TextField(
                                style: const TextStyle(fontSize: 12),
                                onChanged: (value) {
                                  provider.updateKeyword(value);
                                },
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 18),
                                    border: InputBorder.none,
                                    hintText:
                                        'Tìm kiếm bằng ${provider.valueFilter.title.toLowerCase()}',
                                    hintStyle: const TextStyle(
                                        fontSize: 12,
                                        color: AppColor.GREY_TEXT)),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    if (provider.valueFilter.id == 9 ||
                        provider.valueFilter.id == 0)
                      ...[],
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColor.GREY_DADADA)),
                      child: Row(
                        children: [
                          const Text(
                            'Thời gian',
                            style: TextStyle(
                                fontSize: 12, color: AppColor.GREY_TEXT),
                          ),
                          const SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              thickness: 1,
                              color: AppColor.GREY_DADADA,
                            ),
                          ),
                          DropdownButton<FilterTimeTransaction>(
                            value: provider.valueTimeFilter,
                            icon: const RotatedBox(
                              quarterTurns: 5,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                              ),
                            ),
                            underline: const SizedBox.shrink(),
                            onChanged: provider.valueFilter.id == 9
                                ? null
                                : (FilterTimeTransaction? value) {
                                    provider.changeTimeFilter(value!);
                                    if (value.id != TypeTimeFilter.PERIOD.id &&
                                        provider.valueFilter.id.type !=
                                            TypeFilter.CODE_SALE) {
                                      onSearch(provider);
                                    }
                                  },
                            items: provider.valueFilter.id == 9
                                ? []
                                : provider.listTimeFilter.map<
                                        DropdownMenuItem<
                                            FilterTimeTransaction>>(
                                    (FilterTimeTransaction value) {
                                    return DropdownMenuItem<
                                        FilterTimeTransaction>(
                                      value: value,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Text(
                                          value.title,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                          ),
                        ],
                      ),
                    ),
                    if (provider.valueTimeFilter.id == 5) ...[
                      InkWell(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: provider.fromDate,
                            firstDate: DateTime(2022),
                            lastDate: DateTime.now(),
                          );
                          int numberOfMonths = monthCalculator.calculateMonths(
                              date ?? DateTime.now(), provider.toDate);

                          if (numberOfMonths > 3) {
                            DialogWidget.instance.openMsgDialog(
                                title: 'Cảnh báo',
                                msg:
                                    'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
                          } else {
                            provider.updateFromDate(date ?? DateTime.now());
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColor.GREY_DADADA)),
                          child: Row(
                            children: [
                              const Text(
                                'Từ ngày',
                                style: TextStyle(
                                    fontSize: 12, color: AppColor.GREY_TEXT),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                TimeUtils.instance
                                    .formatDateToString(provider.fromDate),
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(
                                Icons.calendar_month_outlined,
                                size: 12,
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: provider.toDate,
                            firstDate: DateTime(2022),
                            lastDate: DateTime.now(),
                          );
                          int numberOfMonths = monthCalculator.calculateMonths(
                              provider.fromDate, date ?? DateTime.now());

                          if (numberOfMonths > 3) {
                            DialogWidget.instance.openMsgDialog(
                                title: 'Cảnh báo',
                                msg:
                                    'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
                          } else {
                            provider.updateToDate(date ?? DateTime.now());
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColor.GREY_DADADA)),
                          child: Row(
                            children: [
                              const Text(
                                'Đến ngày',
                                style: TextStyle(
                                    fontSize: 12, color: AppColor.GREY_TEXT),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                TimeUtils.instance
                                    .formatDateToString(provider.toDate),
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(
                                Icons.calendar_month_outlined,
                                size: 12,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        onSearch(provider);
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        width: 120,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.BLUE_TEXT,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'Tìm kiếm',
                          style: TextStyle(fontSize: 12, color: AppColor.WHITE),
                        ),
                      ),
                    ),
                    // const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onSearch(TransactionProvider provider) {
    if (provider.fromDate.millisecondsSinceEpoch <=
        provider.toDate.millisecondsSinceEpoch) {
      final type = provider.valueFilter.id;
      String from = '';
      String to = '';
      String value = '';
      if (provider.valueTimeFilter.id == TypeTimeFilter.ALL.id ||
          (provider.valueFilter.id.type != TypeFilter.BANK_NUMBER &&
              provider.valueFilter.id.type != TypeFilter.ALL &&
              provider.valueFilter.id.type != TypeFilter.CODE_SALE)) {
        from = '0';
        to = '0';
      } else if (provider.valueTimeFilter.id == TypeTimeFilter.ALL.id) {
        from = '0';
        to = '0';
      } else {
        from = TimeUtils.instance.getCurrentDate(provider.fromDate);
        to = TimeUtils.instance.getCurrentDate(provider.toDate);
      }
      provider.changeTimeFilter(provider.valueTimeFilter);
      from = TimeUtils.instance.getCurrentDate(provider.fromDate);
      to = TimeUtils.instance.getCurrentDate(provider.toDate);
      value = provider.keywordSearch;

      // param['offset'] = 0;
      // param['merchantId'] = Session.instance.connectDTO.id;

      context.read<TransactionBloc>().add(
            TransactionFilterListEvent(
              size: widget.pageSize,
              from: from,
              to: to,
              type: type,
              page: 1,
              value: value,
            ),
          );
    } else {
      DialogWidget.instance.openMsgDialog(
          title: 'Không hợp lệ',
          msg: 'Ngày bắt đầu không được lớn hơn ngày kết thúc');
    }
  }
}

class ItemSearch {
  final int id;
  final String title;

  ItemSearch({required this.id, required this.title});
}
