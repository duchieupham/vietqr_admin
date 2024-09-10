import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/View/SystemManage/BankSystem/bank_system_screen.dart';
import 'package:vietqr_admin/View/TransManage/SysTrans/widget/filter_transaction_widget.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/month_calculator.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/View/TransManage/SysTrans/bloc/transaction_bloc.dart';
import 'package:vietqr_admin/View/TransManage/SysTrans/event/transaction_event.dart';
import 'package:vietqr_admin/View/TransManage/SysTrans/state/transaction_state.dart';
import 'package:vietqr_admin/View/TransManage/SysTrans/widget/transaction_detail.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

import '../../../models/DTO/transaction_dto.dart';
import 'provider/transaction_provider.dart';

class SysTransactionScreen extends StatelessWidget {
  const SysTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransactionProvider>(
        create: (context) => TransactionProvider(),
        child: const _TransactionScreen());
  }
}

class _TransactionScreen extends StatefulWidget {
  const _TransactionScreen();

  @override
  State<_TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<_TransactionScreen> {
  StreamSubscription? _subscription;
  late TransactionBloc _bloc;
  final PageController pageViewController = PageController(initialPage: 0);
  List<TransactionItem> transactionList = [];
  int offset = 0;
  ScrollController scrollControllerList = ScrollController();
  bool isCalling = true;
  MonthCalculator monthCalculator = MonthCalculator();
  List<ChoiceChipItem> listChoiceChips = [
    ChoiceChipItem(title: 'Tất cả', value: 9),
    ChoiceChipItem(title: 'Số tài khoản', value: 0),
    ChoiceChipItem(title: 'Mã giao dịch', value: 1),
    ChoiceChipItem(title: 'Order Id', value: 2),
    ChoiceChipItem(title: 'Nội dung', value: 3),
    ChoiceChipItem(title: 'Cửa hàng', value: 4),
  ];
  final TextEditingController _textController = TextEditingController();
  int type = 9;
  int pageSize = 20;
  MetaDataDTO metadata = MetaDataDTO();
  @override
  void initState() {
    DateTime now = DateTime.now();
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    DateTime endDate = fromDate.subtract(const Duration(days: 7));

    fromDate = fromDate
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
    _bloc = TransactionBloc()
      ..add(TransactionFilterListEvent(
          page: 1,
          size: pageSize,
          from: TimeUtils.instance.getCurrentDate(endDate),
          to: TimeUtils.instance.getCurrentDate(fromDate),
          value: '',
          type: type));
    // _subscription = eventBus.on<RefreshTransaction>().listen((data) {
    //   _bloc.add(TransactionGetListEvent(param: param, isLoadingPage: true));
    // Provider.of<TransactionProvider>(context, listen: false).resetFilter();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      body: BlocProvider<TransactionBloc>(
        create: (context) => _bloc,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppColor.WHITE,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerWidget(),
              const Divider(
                color: AppColor.GREY_DADADA,
              ),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageViewController,
                  children: [_bodyWidget(), TransactionDetailScreen()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocProvider.value(
              value: _bloc,
              child: FilterTransactionWidget(
                pageSize: pageSize,
                controller: _textController,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
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
                    Expanded(
                      child: Container(
                        child: _buildListTransaction(),
                      ),
                    ),
                    _pagingWidget()
                    // ListBankSystemWidget(
                    //   pageSize: pageSize,
                    // ),
                    // const MySeparator(color: AppColor.GREY_DADADA),
                    // _pagingWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _headerWidget() {
    return Consumer<TransactionProvider>(builder: (context, provider, child) {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 20, 30, 10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                  child: Row(
                    children: [
                      if (Provider.of<TransactionProvider>(context,
                                  listen: false)
                              .currentPage ==
                          1)
                        InkWell(
                          onTap: () {
                            Provider.of<TransactionProvider>(context,
                                    listen: false)
                                .updateCurrentPage(0);
                            pageViewController.previousPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 16, right: 24),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.BLUE_TEXT.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColor.BLUE_TEXT,
                                  size: 12,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Trở về',
                                  style: TextStyle(
                                      fontSize: 11, color: AppColor.BLUE_TEXT),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const Text(
                        "Quản lý giao dịch",
                        style: TextStyle(fontSize: 13),
                      ),
                      const Text(
                        "   /   ",
                        style: TextStyle(fontSize: 13),
                      ),
                      const Text(
                        "Giao dịch hệ thống",
                        style: TextStyle(fontSize: 13),
                      ),
                      if (Provider.of<TransactionProvider>(context,
                                  listen: false)
                              .currentPage ==
                          1) ...[
                        const Text(
                          "   /   ",
                          style: TextStyle(fontSize: 13),
                        ),
                        const Text(
                          'Chi tiết giao dịch',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTitle() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.GREY_DADADA),
        ),
      ),
      child: Consumer<TransactionProvider>(builder: (context, provider, child) {
        return Row(
          children: [
            if (provider.currentPage == 1)
              InkWell(
                onTap: () {
                  provider.updateCurrentPage(0);
                  pageViewController.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 16, right: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: AppColor.BLUE_TEXT,
                        size: 12,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Trở về',
                        style:
                            TextStyle(fontSize: 11, color: AppColor.BLUE_TEXT),
                      ),
                    ],
                  ),
                ),
              ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Giao dịch',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            if (provider.currentPage == 1) ...[
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColor.BLUE_TEXT,
                size: 20,
              ),
              const SizedBox(
                width: 24,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chi tiết giao dịch',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
            ] else
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(
                        width: 24,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.GREY_BG,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Lọc theo',
                              style: TextStyle(
                                  fontSize: 11, color: AppColor.GREY_TEXT),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            DropdownButton<FilterTransaction>(
                              value: provider.valueFilter,
                              icon: const RotatedBox(
                                quarterTurns: 5,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                ),
                              ),
                              underline: const SizedBox.shrink(),
                              onChanged: (FilterTransaction? value) {
                                provider.changeFilter(value!);
                                if (value.id.type == TypeFilter.ALL) {
                                  onSearch(provider);
                                }
                              },
                              items: provider.listFilter
                                  .map<DropdownMenuItem<FilterTransaction>>(
                                      (FilterTransaction value) {
                                return DropdownMenuItem<FilterTransaction>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4),
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
                      if (provider.valueFilter.id == 9 ||
                          provider.valueFilter.id == 0)
                        ...[],
                      Container(
                        margin:
                            const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.GREY_BG,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Thời gian',
                              style: TextStyle(
                                  fontSize: 11, color: AppColor.GREY_TEXT),
                            ),
                            const SizedBox(
                              width: 20,
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
                              onChanged: (FilterTimeTransaction? value) {
                                provider.changeTimeFilter(value!);
                                if (value.id != TypeTimeFilter.PERIOD.id &&
                                    provider.valueFilter.id.type !=
                                        TypeFilter.CODE_SALE) {
                                  onSearch(provider);
                                }
                              },
                              items: provider.listTimeFilter
                                  .map<DropdownMenuItem<FilterTimeTransaction>>(
                                      (FilterTimeTransaction value) {
                                return DropdownMenuItem<FilterTimeTransaction>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4),
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
                            int numberOfMonths =
                                monthCalculator.calculateMonths(
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
                            margin: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.GREY_BG,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Từ ngày',
                                  style: TextStyle(
                                      fontSize: 11, color: AppColor.GREY_TEXT),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  TimeUtils.instance
                                      .formatDateToString(provider.fromDate),
                                  style: const TextStyle(fontSize: 11),
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
                            int numberOfMonths =
                                monthCalculator.calculateMonths(
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
                            margin: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.GREY_BG,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Đến ngày',
                                  style: TextStyle(
                                      fontSize: 11, color: AppColor.GREY_TEXT),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  TimeUtils.instance
                                      .formatDateToString(provider.toDate),
                                  style: const TextStyle(fontSize: 11),
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
                      if (provider.valueFilter.id != 9)
                        Container(
                          margin: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          width: 180,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColor.GREY_BG,
                            borderRadius: BorderRadius.circular(5),
                          ),
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
                                    fontSize: 12, color: AppColor.GREY_TEXT)),
                          ),
                        ),
                      InkWell(
                        onTap: () {
                          onSearch(provider);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          width: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColor.BLUE_TEXT,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Tìm kiếm',
                            style:
                                TextStyle(fontSize: 12, color: AppColor.WHITE),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildListTransaction() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocConsumer<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionFilterListSuccessState) {
              transactionList = state.result.items;
              metadata = state.meta;
            }
          },
          builder: (context, state) {
            if (state is TransactionGetListLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.BLUE_TEXT,
                ),
              );
            } else {
              if (transactionList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: Text('Không có dữ liệu')),
                );
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollControllerList,
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: constraints.maxWidth > 1350
                                  ? constraints.maxWidth
                                  : 1350,
                              child: Column(
                                children: [
                                  _buildTitleItem(),
                                  ...transactionList.map((e) {
                                    int index = transactionList.indexOf(e) + 1;
                                    int calculatedIndex = index +
                                        ((metadata.page! - 1) * pageSize);
                                    return _buildItem(e, calculatedIndex);
                                  }),
                                  const SizedBox(width: 12),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (state is TransactionGetListLoadingLoadMoreState)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.BLUE_TEXT,
                        ),
                      )
                  ],
                );
              }
            }
          },
        );
      },
    );
  }

  Widget _buildTitleItem() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.3)),
      child: Row(
        children: [
          _buildItemTitle('No.',
              height: 50,
              width: 50,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Số TK',
              height: 50,
              width: 130,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Số tiền',
              height: 50,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Order ID',
              height: 50,
              width: 110,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          Expanded(
            child: _buildItemTitle('Mã GD (FT Code)',
                height: 50,
                alignment: Alignment.center,
                textAlign: TextAlign.center),
          ),
          _buildItemTitle('Trạng thái',
              height: 50,
              width: 100,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          Expanded(
            flex: 2,
            child: _buildItemTitle('Nội dung',
                height: 50,
                width: 100,
                alignment: Alignment.center,
                textAlign: TextAlign.center),
          ),
          _buildItemTitle('TG tạo GD',
              height: 50,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('TG thanh toán',
              height: 50,
              width: 140,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Action',
              height: 50,
              width: 80,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItem(TransactionItem dto, int index) {
    return Container(
      color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                '$index',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 130,
            child: SelectionArea(
              child: Text(
                dto.bankAccount,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.transType == 'D'
                    ? '- ${StringUtils.formatNumber(dto.amount.toString())}'
                    : '+ ${StringUtils.formatNumber(dto.amount.toString())}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: dto.getAmountColor()),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 110,
            child: SelectionArea(
              child: Text(
                dto.orderId.isNotEmpty ? dto.orderId : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColor.GREY_BUTTON),
                      right: BorderSide(color: AppColor.GREY_BUTTON))),
              height: 50,
              child: SelectionArea(
                child: Text(
                  dto.referenceNumber.isNotEmpty ? dto.referenceNumber : '-',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 110,
            child: SelectionArea(
              child: Text(
                dto.getStatus(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: dto.getStatusColor()),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColor.GREY_BUTTON),
                      right: BorderSide(color: AppColor.GREY_BUTTON))),
              height: 50,
              child: SelectionArea(
                child: Text(
                  dto.content,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                dto.timeCreated == 0
                    ? '-'
                    : TimeUtils.instance.formatTimeDateFromInt(dto.timeCreated),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 140,
            child: SelectionArea(
              child: Text(
                dto.timePaid == 0
                    ? '-'
                    : TimeUtils.instance.formatTimeDateFromInt(dto.timePaid),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 80,
            child: InkWell(
              onTap: () {
                Session.instance.updateTransactionId(dto.id);

                Provider.of<TransactionProvider>(context, listen: false)
                    .updateCurrentPage(1);

                pageViewController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn);
              },
              child: const Text(
                'Chi tiết',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: AppColor.BLUE_TEXT,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTitle(String title,
      {TextAlign? textAlign,
      EdgeInsets? padding,
      double? width,
      double? height,
      Alignment? alignment}) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: AppColor.WHITE, width: 0.5))),
      child: Text(
        title,
        textAlign: textAlign,
        style: const TextStyle(
            fontSize: 12, color: AppColor.BLACK, fontWeight: FontWeight.bold),
      ),
    );
  }

  void onSearch(TransactionProvider provider) {
    if (provider.fromDate.millisecondsSinceEpoch <=
        provider.toDate.millisecondsSinceEpoch) {
      Map<String, dynamic> param = {};
      isCalling = true;
      param['type'] = provider.valueFilter.id;
      // if (provider.valueTimeFilter.id == TypeTimeFilter.ALL.id ||
      //     (provider.valueFilter.id.type != TypeFilter.BANK_NUMBER &&
      //         provider.valueFilter.id.type != TypeFilter.ALL &&
      //         provider.valueFilter.id.type != TypeFilter.CODE_SALE)) {
      //   param['from'] = '0';
      //   param['to'] = '0';
      // } else {
      //   param['from'] = TimeUtils.instance.getCurrentDate(provider.fromDate);
      //   param['to'] = TimeUtils.instance.getCurrentDate(provider.toDate);
      // }
      param['from'] = TimeUtils.instance.getCurrentDate(provider.fromDate);
      param['to'] = TimeUtils.instance.getCurrentDate(provider.toDate);
      param['value'] = provider.keywordSearch;

      param['offset'] = 0;
      param['merchantId'] = Session.instance.connectDTO.id;

      _bloc.add(TransactionGetListEvent(param: param));
    } else {
      DialogWidget.instance.openMsgDialog(
          title: 'Không hợp lệ',
          msg: 'Ngày bắt đầu không được lớn hơn ngày kết thúc');
    }
  }

  Widget _pagingWidget() {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        bool isPaging = false;
        if (state is TransactionFilterListSuccessState) {
          MetaDataDTO paging = state.meta;
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
                            onSearchV2(
                                Provider.of<TransactionProvider>(context,
                                    listen: false),
                                paging.page!,
                                value);
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
                      onSearchV2(
                          Provider.of<TransactionProvider>(context,
                              listen: false),
                          paging.page! - 1,
                          pageSize);
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
                      onSearchV2(
                          Provider.of<TransactionProvider>(context,
                              listen: false),
                          paging.page! + 1,
                          pageSize);
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
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void onSearchV2(TransactionProvider provider, int? page, int? size) {
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
      } else {
        from = TimeUtils.instance.getCurrentDate(provider.fromDate);
        to = TimeUtils.instance.getCurrentDate(provider.toDate);
      }
      from = TimeUtils.instance.getCurrentDate(provider.fromDate);
      to = TimeUtils.instance.getCurrentDate(provider.toDate);
      value = provider.keywordSearch;

      // param['offset'] = 0;
      // param['merchantId'] = Session.instance.connectDTO.id;

      _bloc.add(
        TransactionFilterListEvent(
          size: size ?? pageSize,
          from: from,
          to: to,
          type: type,
          page: page ?? 1,
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
