import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/SystemManage/BankSystem/widgets/popup_check_log.dart';
import 'package:vietqr_admin/View/SystemManage/BankSystem/widgets/item_bank_widget.dart';
import 'package:vietqr_admin/View/SystemManage/BankSystem/widgets/title_item_bank_widget.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/share_utils.dart';
import 'package:vietqr_admin/commons/widget/box_layout.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/bank_system_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';

enum Actions {
  copy,
}

class BankSystemScreen extends StatefulWidget {
  const BankSystemScreen({super.key});

  @override
  State<BankSystemScreen> createState() => _BankSystemScreenState();
}

class _BankSystemScreenState extends State<BankSystemScreen> {
  final TextEditingController _textController = TextEditingController(text: '');
  late SystemViewModel _model;
  int type = 1;
  late ScrollController controllerHorizontal;
  late ScrollController controller1;
  late ScrollController controller2;
  bool isScrollingDown1 = false;
  bool isScrollingDown2 = false;

  @override
  void initState() {
    super.initState();
    _model = Get.find<SystemViewModel>();
    initController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  void initData() {
    _model.getListBank(type: 1);
  }

  void initController() {
    controller1 = ScrollController();
    controller2 = ScrollController();
    controllerHorizontal = ScrollController();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      body: ScopedModel<SystemViewModel>(
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
              Expanded(
                child: _bodyWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tìm kiếm tài khoản ngân hàng",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _filterWidget(),
          const SizedBox(height: 20),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          const SizedBox(height: 20),
          const Text(
            "Danh sách tài khoản ngân hàng",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          _buildList(),
          const SizedBox(height: 10),
          _pagingWidget(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ScopedModelDescendant<SystemViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading) {
          return const Expanded(child: Center(child: Text('Đang tải...')));
        }

        if (model.listBank!.isEmpty ||
            model.metadata == null ||
            model.status == ViewStatus.Error) {
          return const Expanded(child: Center(child: Text('Trống...')));
        }
        List<Widget> buildItemList(
            List<BankSystemDTO>? list, MetaDataDTO metadata) {
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
                    ItemBankWidget(
                      dto: e,
                      index: calculatedIndex,
                    ));
              })
              .values
              .toList();
        }

        List<BankSystemDTO>? list = model.listBank;
        MetaDataDTO metadata = model.metadata!;
        return Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Scrollbar(
                  thumbVisibility: true,
                  controller: controllerHorizontal,
                  child: SingleChildScrollView(
                    controller: controllerHorizontal,
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      controller: controller1,
                      child: SizedBox(
                        width: 1580,
                        child: Column(
                          children: [
                            const TitleItemBankWidget(),
                            if (list != null && list.isNotEmpty)
                              ...buildItemList(list, metadata)
                            // ...buildItemList(
                            //     invoiceDTO.items, metadata)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 1580,
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Scrollbar(
                        controller: controller2,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: controller2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        AppColor.GREY_BORDER.withOpacity(0.8),
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
                                      color:
                                          AppColor.BLUE_TEXT.withOpacity(0.3)),
                                  child: Row(
                                    children: [
                                      Container(
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
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Container(
                                          height: 50,
                                          width: 100,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color: AppColor.GREY_TEXT
                                                          .withOpacity(0.3)),
                                                  bottom: BorderSide(
                                                      color: AppColor.GREY_TEXT
                                                          .withOpacity(0.3)),
                                                  right: BorderSide(
                                                      color: AppColor.GREY_TEXT
                                                          .withOpacity(0.3)))),
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
                                if (list != null && list.isNotEmpty)
                                  ...list.map(
                                    (e) => _rightItem(e),
                                  ),
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
        );
      },
    );
  }

  Widget _rightItem(BankSystemDTO e) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(
                    left:
                        BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                    bottom:
                        BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                    right: BorderSide(
                        color: AppColor.GREY_TEXT.withOpacity(0.3)))),
            height: 50,
            width: 130,
            child: SelectionArea(
                child: Text(
              !e.status ? 'Chưa liên kết' : 'Đã liên kết',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: !e.status ? AppColor.ORANGE_DARK : AppColor.GREEN_STATUS,
              ),
            )),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                // left: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                bottom: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                right: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
              ),
            ),
            height: 50,
            width: 100,
            child: Row(
              children: [
                const SizedBox(width: 4),
                PopupMenuButton<Actions>(
                  padding: const EdgeInsets.all(0),
                  onSelected: (Actions result) {
                    switch (result) {
                      case Actions.copy:
                        onCopy(dto: e);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => _buildMenuItems(),
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
                const Spacer(),
                if (e.bankCode == 'MB' || e.bankCode == 'BIDV')
                  Tooltip(
                    message: 'Check LOG',
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PopupCheckLogWidget(
                              dto: e,
                              bankAccount: e.phoneNo,
                            );
                          },
                        );
                      },
                      child: BoxLayout(
                        width: 30,
                        height: 30,
                        borderRadius: 100,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0),
                        bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                        child: const Icon(
                          Icons.lightbulb_outline,
                          size: 12,
                          color: AppColor.BLUE_TEXT,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tìm kiếm theo",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            Container(
              height: 40,
              width: 450,
              padding: const EdgeInsets.only(
                left: 10,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.GREY_DADADA)),
              child: Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: type,
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
                              "Số tài khoản",
                            )),
                        DropdownMenuItem<int>(
                            value: 2,
                            child: Text(
                              "Chủ tài khoản",
                            )),
                        DropdownMenuItem<int>(
                            value: 3,
                            child: Text(
                              "SĐT xác thực",
                            )),
                        DropdownMenuItem<int>(
                            value: 4,
                            child: Text(
                              "CCCD/MST",
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          type = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        const SizedBox(
                          height: 40,
                          child: VerticalDivider(
                            thickness: 1,
                            color: AppColor.GREY_DADADA,
                          ),
                        ),
                        SizedBox(
                          width: 260,
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            keyboardType: type != 2
                                ? TextInputType.number
                                : TextInputType.name,
                            inputFormatters: [
                              type != 2
                                  ? FilteringTextInputFormatter.digitsOnly
                                  : FilteringTextInputFormatter.allow(
                                      RegExp(r'^[a-zA-ZÀ-ỹẠ-ỵ0-9 ]+$'))
                            ],
                            onSubmitted: (value) {
                              _model.getListBank(type: type, value: value);
                            },
                            onChanged: (value) {
                              _textController.value = TextEditingValue(
                                text: value,
                                selection: TextSelection.collapsed(
                                    offset: value.length),
                              );
                              setState(() {});
                            },
                            controller: _textController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 6),
                              border: InputBorder.none,
                              hintText:
                                  'Tìm kiếm theo ${type == 1 ? 'số tài khoản' : type == 2 ? 'chủ tài khoản' : type == 3 ? 'SĐT xác thực' : 'CCCD/MST'}',
                              hintStyle: const TextStyle(
                                  fontSize: 13, color: AppColor.GREY_TEXT),
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 15,
                                color: AppColor.GREY_TEXT,
                              ),
                              suffixIcon: InkWell(
                                  onTap: () {
                                    _textController.clear();
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 15,
                                    color: AppColor.GREY_TEXT,
                                  )),
                            ),
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
        const SizedBox(width: 20),
        InkWell(
          onTap: () {
            _model.getListBank(type: type, value: _textController.text);
          },
          child: Container(
            height: 40,
            width: 150,
            decoration: BoxDecoration(
              color: AppColor.BLUE_TEXT,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 20,
                  color: AppColor.WHITE,
                ),
                SizedBox(width: 8),
                Text(
                  'Tìm kiếm',
                  style: TextStyle(fontSize: 15, color: AppColor.WHITE),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _pagingWidget() {
    return ScopedModelDescendant<SystemViewModel>(
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

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              child: Text(
                "Trang ${paging.page}/${paging.totalPage}",
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(width: 30),
            InkWell(
              onTap: () async {
                if (paging.page != 1) {
                  await _model.getListBank(
                      page: paging.page! - 1,
                      type: type,
                      value: _textController.text);
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
                  await _model.getListBank(
                      page: paging.page! + 1,
                      type: type,
                      value: _textController.text);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color:
                            isPaging ? AppColor.BLACK : AppColor.GREY_DADADA)),
                child: Center(
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: isPaging ? AppColor.BLACK : AppColor.GREY_DADADA,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
      child: const Row(
        children: [
          Text(
            "Quản lý hệ thống",
            style: TextStyle(fontSize: 13),
          ),
          Text(
            "   /   ",
            style: TextStyle(fontSize: 13),
          ),
          Text(
            "Quản lý tài khoản ngân hàng",
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  void onCopy({required BankSystemDTO dto}) async {
    await FlutterClipboard.copy(ShareUtils.instance.getBankSharing(dto)).then(
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

  List<PopupMenuEntry<Actions>> _buildMenuItems() {
    List<PopupMenuEntry<Actions>> items = [
      const PopupMenuItem<Actions>(
        value: Actions.copy,
        child: Text('Copy'),
      ),
    ];
    return items;
  }
}
