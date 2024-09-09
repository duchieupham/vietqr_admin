import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceManage/UserRecharge/widgets/item_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/UserRecharge/widgets/title_item_widget.dart';
import 'package:vietqr_admin/commons/constants/utils/share_utils.dart';

import '../../../ViewModel/userRecharge_viewModel.dart';
import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/constants/enum/view_status.dart';
import '../../../commons/constants/utils/custom_scroll.dart';
import '../../../commons/constants/utils/string_utils.dart';
import '../../../commons/widget/dialog_pick_month.dart';
import '../../../commons/widget/separator_widget.dart';
import '../../../main.dart';
import '../../../models/DTO/data_filter_dto.dart';
import '../../../models/DTO/metadata_dto.dart';
import '../../../models/DTO/user_recharge_dto.dart';

enum Actions {
  copy,
}

class UserRechargeScreen extends StatefulWidget {
  const UserRechargeScreen({super.key});

  @override
  State<UserRechargeScreen> createState() => _UserRechargeScreenState();
}

class _UserRechargeScreenState extends State<UserRechargeScreen> {
  TextEditingController controller = TextEditingController(text: '');
  late ScrollController controller1;
  late ScrollController controller2;

  bool isScrollingDown1 = false;
  bool isScrollingDown2 = false;

  late LinkedScrollControllerGroup _linkedScrollControllerGroup;
  late ScrollController _horizontal;
  late ScrollController _vertical;
  late ScrollController _vertical2;

  late UserRechargeViewModel _model;
  DateTime? selectDate;
  String? searchValue = '';

  @override
  void initState() {
    super.initState();
    _model = Get.find<UserRechargeViewModel>();

    _linkedScrollControllerGroup = LinkedScrollControllerGroup();
    _vertical = _linkedScrollControllerGroup.addAndGet();
    _vertical2 = _linkedScrollControllerGroup.addAndGet();
    _horizontal = ScrollController();

    _model.filterUserRecharge(
        page: 1, value: searchValue!.isEmpty ? searchValue! : '');

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
              year: 2,
              dateTime: dateTime,
            ),
          ),
        );
      },
    );
    _model.getSelectMoth(dateTime);
    setState(() {
      selectDate = result;
    });
    _model.filterUserRecharge(
        page: 1, value: searchValue!.isEmpty ? searchValue! : '');
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    _vertical.dispose();
    _vertical2.dispose();
    _horizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      body: ScopedModel<UserRechargeViewModel>(
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
              const Divider(
                color: AppColor.GREY_DADADA,
              ),
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
                    const SizedBox(height: 20),
                    _filterWidget(),
                    const SizedBox(height: 20),
                    const MySeparator(
                      color: AppColor.GREY_DADADA,
                    ),
                    // const SizedBox(height: 20),
                    // const Text(
                    //   "Thống kê phí dịch vụ",
                    //   style:
                    //       TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 10),
                    // _statisticUserRecharge(),
                    // const SizedBox(height: 10),
                  ],
                ),
              ),
              _buildListSUserRecharge(),
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
      padding: const EdgeInsets.fromLTRB(30, 15, 0, 10),
      width: MediaQuery.of(context).size.width * 0.22,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Quản lý thu phí",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "/",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Thu phí thường niên",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _filterWidget() {
    return ScopedModelDescendant<UserRechargeViewModel>(
      builder: (context, child, model) {
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Chọn dịch vụ nạp tiền",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 250,
                  height: 40,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.GREY_DADADA)),
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: model.filterBy,
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
                      // DropdownMenuItem<int>(
                      //     value: 1,
                      //     child: Text(
                      //       "Nạp tiền điện thoại",
                      //     )),
                      DropdownMenuItem<int>(
                          value: 2,
                          child: Text(
                            "Phần mềm VietQR",
                          )),
                    ],
                    onChanged: (value) {
                      model.changeFilterBy(selectFilterBy: value);
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
                                value: 9,
                                child: Text(
                                  "Tất cả",
                                )),
                            DropdownMenuItem<int>(
                                value: 0,
                                child: Text(
                                  "Số điện thoại",
                                )),
                            DropdownMenuItem<int>(
                                value: 1,
                                child: Text(
                                  "Mã hóa đơn",
                                )),
                          ],
                          onChanged: (value) {
                            model.changeType(selectType: value);
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
                              contentPadding: const EdgeInsets.only(top: 8),
                              hintText: 'Nhập mã ở đây',
                              hintStyle: TextStyle(
                                  fontSize: 15,
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
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thời gian",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 150,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColor.GREY_DADADA)),
                      child: DropdownButton<DataFilter>(
                        isExpanded: true,
                        value: model.filterByTime,
                        underline: const SizedBox.shrink(),
                        icon: const RotatedBox(
                          quarterTurns: 5,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        ),
                        items: model.listFilterByTime
                            .map<DropdownMenuItem<DataFilter>>(
                          (item) {
                            return DropdownMenuItem<DataFilter>(
                              value: item,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          model.changeFilterByTime(filter: value);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    model.filterByTime.id == 3
                        ? InkWell(
                            onTap: () {
                              _onPickMonth(model.getPreviousMonth());
                            },
                            child: Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColor.GREY_DADADA)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (selectDate == null
                                        ? '${model.getPreviousMonth().month}/${model.getPreviousMonth().year}'
                                        : '${selectDate?.month}/${selectDate?.year}'),
                                    style: const TextStyle(
                                        fontSize: 15, color: AppColor.BLACK),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    color: AppColor.BLACK,
                                  )
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ],
            ),
            const SizedBox(width: 15),
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
                    await model.filterUserRecharge(
                        page: 1, value: searchValue!);
                  },
                  child: Container(
                    height: 40,
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

  Widget _statisticUserRecharge() {
    return ScopedModelDescendant<UserRechargeViewModel>(
      builder: (context, child, model) {
        return model.dto != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              'Thời gian',
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
                          child: Text(
                            model.dto!.extraData.time ?? '-',
                            style: const TextStyle(
                                fontSize: 15, color: AppColor.BLACK),
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
                                StringUtils.formatNumberWithOutVND(
                                    model.dto?.extraData.total),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.GREEN),
                              ),
                              const Text(
                                ' VND',
                                style: TextStyle(
                                    fontSize: 15, color: AppColor.BLACK),
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

  Widget _buildListSUserRecharge() {
    return ScopedModelDescendant<UserRechargeViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading) {
          return const Expanded(child: Center(child: Text('Đang tải...')));
        }
        if (model.status == ViewStatus.Error) {
          return const SizedBox.shrink();
        }
        List<RechargeItem>? list = model.dto?.items;
        List<Widget> buildItemList(
            List<RechargeItem>? list, MetaDataDTO metadata) {
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
            ? Expanded(child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      
                      Positioned.fill(
                        right: 200,
                        child: SizedBox(
                          width: 1200,
                          child: RawScrollbar(
                            thumbVisibility: true,
                            controller: _horizontal,
                            child: ScrollConfiguration(
                              behavior: MyCustomScrollBehavior(),
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                controller: _horizontal,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TitleItemWidget(),
                                    Expanded(
                                      child: ScrollConfiguration(
                                        behavior:
                                            ScrollConfiguration.of(context)
                                                .copyWith(scrollbars: false),
                                        child: SingleChildScrollView(
                                          controller: _vertical,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          child: Column(
                                            children: [
                                              ...buildItemList(list, metadata),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 1400,
                        child: Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            // const Spacer(),
                            // SizedBox(width: constraints.maxWidth),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColor.WHITE,
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColor.BLACK.withOpacity(0.1),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: const Offset(-1, 0)),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColor.BLUE_TEXT.withOpacity(0.3),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: 50,
                                            width: 100,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Trạng thái',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColor.BLACK,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Container(
                                            height: 50,
                                            width: 100,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Thao tác',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColor.BLACK,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  ),
                                  if (model.status == ViewStatus.Loading)
                                    const SizedBox.shrink()
                                  else if (list != null)
                                    Expanded(
                                        child: SingleChildScrollView(
                                      controller: _vertical2,
                                      physics: const ClampingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          ...list.map(
                                            (e) {
                                              return Column(
                                                children: [
                                                  _rightItem(e),
                                                  // if (index + 1 != list.length)
                                                  const SizedBox(
                                                      width: 200,
                                                      child: MySeparator(
                                                          color: AppColor
                                                              .GREY_DADADA)),
                                                ],
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ))
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                },
              ))
            : const SizedBox.shrink();
      },
    );
  }

  Widget _rightItem(RechargeItem e) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            // padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.center,

            height: 50,
            width: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: e.status == 0
                    ? AppColor.ORANGE_DARK.withOpacity(0.3)
                    : e.status == 1
                        ? AppColor.GREEN.withOpacity(0.3)
                        : AppColor.GREEN_STATUS.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                e.status == 0
                    ? 'Chờ TT'
                    : e.status == 1
                        ? 'Đã TT'
                        : 'Chưa TT hết',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: e.status == 0
                      ? AppColor.ORANGE_DARK
                      : e.status == 1
                          ? AppColor.GREEN
                          : AppColor.GREEN_STATUS,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            height: 50,
            width: 100,
            child: PopupMenuButton<Actions>(
              padding: const EdgeInsets.all(0),
              onSelected: (Actions result) {
                switch (result) {
                  case Actions.copy:
                    onCopy(dto: e);
                    break;
                }
              },
              itemBuilder: (BuildContext context) =>
                  _buildMenuItems(e.status),
              icon: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColor.BLUE_TEXT.withOpacity(0.3),
                ),
                child: const Icon(
                  size: 18,
                  Icons.more_vert,
                  color: AppColor.BLUE_TEXT,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pagingWidget() {
    return ScopedModelDescendant<UserRechargeViewModel>(
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
                          await model.filterUserRecharge(
                              page: paging.page! - 1,
                              value: searchValue! ?? '');
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
                          await model.filterUserRecharge(
                              page: paging.page! + 1,
                              value: searchValue! ?? '');
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

  List<PopupMenuEntry<Actions>> _buildMenuItems(int status) {
    List<PopupMenuEntry<Actions>> items = [
      const PopupMenuItem<Actions>(
        value: Actions.copy,
        child: Text('Copy'),
      ),
    ];

    return items;
  }

  void onCopy({required RechargeItem dto}) async {
    await FlutterClipboard.copy(ShareUtils.instance.getTextRechargeItem(dto))
        .then(
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
