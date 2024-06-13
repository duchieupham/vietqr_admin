// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/SystemManage/UserSystem/views/user_detail_screen.dart';
import 'package:vietqr_admin/View/SystemManage/UserSystem/widgets/item_user_widget.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/input_utils.dart';
import 'package:vietqr_admin/commons/widget/box_layout.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
import 'package:vietqr_admin/models/DTO/user_system_dto.dart';

import 'views/add_user_screen.dart';
import 'widgets/title_item_widget.dart';

enum Actions {
  update_info,
  reset_pass,
  active,
}

enum PageUser { LIST, ADD_USER, USER_INFO }

class UserSystemScreen extends StatefulWidget {
  const UserSystemScreen({super.key});

  @override
  State<UserSystemScreen> createState() => _UserSystemScreenState();
}

class _UserSystemScreenState extends State<UserSystemScreen> {
  final TextEditingController _textController = TextEditingController(text: '');

  late SystemViewModel _model;

  late ScrollController controllerHorizontal;
  late ScrollController controller1;
  late ScrollController controller2;
  bool isScrollingDown1 = false;
  bool isScrollingDown2 = false;
  String selectedUserId = '';

  int? type = 0;
  PageUser page = PageUser.LIST;

  @override
  void initState() {
    super.initState();
    _model = Get.find<SystemViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  void initData() {
    _model.getListUser(type: 1);

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
          child: ScopedModelDescendant<SystemViewModel>(
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
                    Expanded(
                      child: _bodyWidget(),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget _bodyWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (page == PageUser.LIST) ...[
            const Text(
              "Tìm kiếm người dùng",
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
              "Danh sách người dùng",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildList(),
          ] else if (page == PageUser.ADD_USER)
            AddUserScreen()
          else if (page == PageUser.USER_INFO)
            UserDetailScreen(
              userId: selectedUserId,
            )
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

        if (model.status == ViewStatus.Error || model.listUser!.isEmpty) {
          return const Expanded(child: Center(child: Text('Trống...')));
        }
        List<Widget> buildItemList(
            List<UserSystemDTO>? list, MetaDataDTO metadata) {
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
                    ItemUserWidget(
                      dto: e,
                      index: calculatedIndex,
                    ));
              })
              .values
              .toList();
        }

        List<UserSystemDTO>? list = model.listUser;
        MetaDataDTO metadata = model.metaDataDTO!;
        return Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 220,
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
                        width: 1760,
                        child: Column(
                          children: [
                            const TitleItemWidget(),
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
                  width: 1760,
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
                                              border: Border.all(
                                                  color: AppColor.GREY_TEXT
                                                      .withOpacity(0.3))),
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
                                ...list!.map(
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

  Widget _rightItem(UserSystemDTO e) {
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
              e.status == 0
                  ? 'Chờ thanh toán'
                  : e.status == 1
                      ? 'Đã thanh toán'
                      : 'Chưa TT hết',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: e.status == 0
                    ? AppColor.ORANGE_DARK
                    : e.status == 1
                        ? AppColor.GREEN
                        : AppColor.GREEN_STATUS,
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
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 4),
                Tooltip(
                  message: 'Thông tin',
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        page = PageUser.USER_INFO;
                        selectedUserId = e.id;
                      });
                    },
                    child: BoxLayout(
                      width: 30,
                      height: 30,
                      borderRadius: 100,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(0),
                      bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                      child: const Icon(
                        Icons.info,
                        size: 12,
                        color: AppColor.BLUE_TEXT,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<Actions>(
                  padding: const EdgeInsets.all(0),
                  onSelected: (Actions result) {
                    switch (result) {
                      case Actions.update_info:
                        break;
                      case Actions.reset_pass:
                        break;
                      case Actions.active:
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry<Actions>> _buildMenuItems(int status) {
    List<PopupMenuEntry<Actions>> items = [
      const PopupMenuItem<Actions>(
        value: Actions.update_info,
        child: Text('Cập nhật thông tin'),
      ),
      const PopupMenuItem<Actions>(
        value: Actions.reset_pass,
        child: Text('Đặt lại mật khẩu'),
      ),
      PopupMenuItem<Actions>(
        value: Actions.active,
        child: Text(
          status == 0 ? 'Huỷ kích hoạt' : 'Kích hoạt',
          style: TextStyle(
              color: status == 0 ? AppColor.RED_TEXT : AppColor.BLUE_TEXT),
        ),
      ),
    ];

    return items;
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
                            value: 0,
                            child: Text(
                              "Số điện thoại",
                            )),
                        DropdownMenuItem<int>(
                            value: 1,
                            child: Text(
                              "Họ và tên",
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          type = value;
                        });
                        // model.changeTypeInvoice(value);
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
                            keyboardType: type == 0
                                ? TextInputType.number
                                : TextInputType.name,
                            inputFormatters: [
                              type == 0
                                  ? FilteringTextInputFormatter.digitsOnly
                                  : FilteringTextInputFormatter.allow(
                                      RegExp(r'^[a-zA-ZÀ-ỹẠ-ỵ0-9 ]+$'))
                            ],
                            onSubmitted: (value) {
                              _model.getListUser(type: type!, value: value);
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
                                  'Tìm kiếm theo ${type == 0 ? 'số điện thoại' : 'họ tên'}',
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
            _model.getListUser(type: type!, value: _textController.text);
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
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            // model.getListQrBox(type: type, value: _textController.text);
          },
          child: Container(
            height: 40,
            // width: 150,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColor.BLUE_TEXT)),
            child: const Center(
              child: Text(
                'Tạo mới người dùng',
                style: TextStyle(fontSize: 15, color: AppColor.BLUE_TEXT),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
      child: const Row(
        children: [
          Text(
            "Quản lý hoá đơn",
            style: TextStyle(fontSize: 13),
          ),
          Text(
            "   /   ",
            style: TextStyle(fontSize: 13),
          ),
          Text(
            "Tạo mới hoá đơn",
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
