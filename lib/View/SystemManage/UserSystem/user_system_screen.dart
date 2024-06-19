// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toastification/toastification.dart';
import 'package:vietqr_admin/View/SystemManage/UserSystem/views/user_detail_screen.dart';
import 'package:vietqr_admin/View/SystemManage/UserSystem/widgets/item_user_widget.dart';
import 'package:vietqr_admin/View/SystemManage/UserSystem/widgets/popup_reset_pass_widget.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/input_utils.dart';
import 'package:vietqr_admin/commons/widget/box_layout.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/create_user_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';
import 'package:vietqr_admin/models/DTO/user_system_dto.dart';

import 'views/add_user_screen.dart';
import 'views/update_user_screen.dart';
import 'widgets/title_item_widget.dart';

enum Actions {
  update_info,
  reset_pass,
  active,
}

enum PageUser { LIST, ADD_USER, USER_INFO, UPDATE_USER }

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

  int type = 1;
  PageUser page = PageUser.LIST;

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
    _model.getListUser(type: 1);
    _model.getTotalUsers();
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
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
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
            _buildTotalUser(),
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
            const SizedBox(height: 10),
            _pagingWidget(),
          ] else if (page == PageUser.ADD_USER)
            AddUserScreen(onCreate: (dto) {
              onCreateUser(dto);
            }, callback: () {
              page = PageUser.LIST;
              _model.getListUser(type: type, value: _textController.text);
              setState(() {});
            })
          else if (page == PageUser.USER_INFO)
            UserDetailScreen(
              userId: selectedUserId,
              callback: () {
                page = PageUser.LIST;

                _model.getListUser(type: type, value: _textController.text);
                setState(() {});
              },
            )
          else if (page == PageUser.UPDATE_USER)
            UpdateUserScreen(
              userId: selectedUserId,
              callback: () {
                setState(() {
                  page = PageUser.LIST;
                });
              },
              onUpdate: () {},
            ),
        ],
      ),
    );
  }

  Widget _buildTotalUser() {
    return ScopedModelDescendant<SystemViewModel>(
        builder: (context, child, model) {
      if (model.status == ViewStatus.Loading) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tổng số người dùng trong hệ thống: Đang tải .....",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            Text(
              "Tổng số người dùng đăng ký hôm nay: Đang tải .....",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tổng số người dùng trong hệ thống: ${_model.totalUserDTO?.totalUsers?.toString() ?? '0'}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          Text(
            "Tổng số người dùng đăng ký hôm nay: ${_model.totalUserDTO?.totalUserRegisterToday?.toString() ?? '0'}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      );
    });
  }

  Widget _buildList() {
    return ScopedModelDescendant<SystemViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading) {
          return const Expanded(child: Center(child: Text('Đang tải...')));
        }

        if (model.listUser!.isEmpty ||
            model.metadata == null ||
            model.status == ViewStatus.Error) {
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
                        width: 1760,
                        child: Column(
                          children: [
                            const TitleItemWidget(),
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
              !e.status ? 'Không hoạt động' : 'Hoạt động',
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
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 4),
                Tooltip(
                  message: 'Thông tin',
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        page = PageUser.USER_INFO;
                        selectedUserId = e.userIdDetail;
                        debugPrint(selectedUserId);
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
                        setState(() {
                          page = PageUser.UPDATE_USER;
                          selectedUserId = e.userIdDetail;
                          print(selectedUserId);
                        });
                        break;
                      case Actions.reset_pass:
                        showDialog(
                          context: context,
                          builder: (context) => PopupResetPassWidget(dto: e),
                        );
                        break;
                      case Actions.active:
                        changeLinked(e);

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

  List<PopupMenuEntry<Actions>> _buildMenuItems(bool status) {
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
          status ? 'Huỷ kích hoạt' : 'Kích hoạt',
          style:
              TextStyle(color: status ? AppColor.RED_TEXT : AppColor.BLUE_TEXT),
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
                            value: 1,
                            child: Text(
                              "Họ và tên",
                            )),
                        DropdownMenuItem<int>(
                            value: 2,
                            child: Text(
                              "Số điện thoại",
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
                            keyboardType: type == 2
                                ? TextInputType.number
                                : TextInputType.name,
                            inputFormatters: [
                              type == 2
                                  ? FilteringTextInputFormatter.digitsOnly
                                  : FilteringTextInputFormatter.allow(
                                      RegExp(r'^[a-zA-ZÀ-ỹẠ-ỵ0-9 ]+$'))
                            ],
                            onSubmitted: (value) {
                              _model.getListUser(type: type, value: value);
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
                                  'Tìm kiếm theo ${type == 2 ? 'số điện thoại' : 'họ tên'}',
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
            _model.getListUser(type: type, value: _textController.text);
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
            page = PageUser.ADD_USER;
            setState(() {});
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
      child: Row(
        children: [
          const Text(
            "Quản lý hoá đơn",
            style: TextStyle(fontSize: 13),
          ),
          const Text(
            "   /   ",
            style: TextStyle(fontSize: 13),
          ),
          InkWell(
            onTap: page != PageUser.LIST
                ? () {
                    page = PageUser.LIST;
                    _model.getListUser(
                        page: 1, type: type, value: _textController.text);

                    setState(() {});
                  }
                : null,
            child: Text(
              "Quản lý người dùng",
              style: TextStyle(
                fontSize: 13,
                color: page != PageUser.LIST
                    ? AppColor.BLUE_TEXT
                    : AppColor.BLACK_TEXT,
                decoration: page != PageUser.LIST
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor:
                    page != PageUser.LIST ? AppColor.BLUE_TEXT : null,
              ),
            ),
          ),
          if (page == PageUser.ADD_USER) ...[
            const Text(
              "   /   ",
              style: TextStyle(fontSize: 13),
            ),
            const Text(
              "Quản lý người dùng",
              style: TextStyle(fontSize: 13),
            ),
          ],
          if (page == PageUser.USER_INFO) ...[
            const Text(
              "   /   ",
              style: TextStyle(fontSize: 13),
            ),
            const Text(
              "Chi tiết người dùng",
              style: TextStyle(fontSize: 13),
            ),
          ],
          if (page == PageUser.UPDATE_USER) ...[
            const Text(
              "   /   ",
              style: TextStyle(fontSize: 13),
            ),
            const Text(
              "Cập nhật thông tin người dùng",
              style: TextStyle(fontSize: 13),
            ),
          ]
        ],
      ),
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
                  await _model.getListUser(
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
                  await _model.getListUser(
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

  void changeLinked(UserSystemDTO e) {
    DialogWidget.instance.openMsgDialogQuestion(
      title: 'Xác nhận ${!e.status ? 'kích hoạt' : 'hủy kích hoạt'}',
      msg: '',
      onConfirm: () {
        _model.changeLinked(e.userIdDetail, !e.status ? 1 : 0).then(
          (value) {
            if (value == true) {
              if (e.status) {
                toastification.show(
                  context: context,
                  type: ToastificationType.success,
                  style: ToastificationStyle.flat,
                  title: const Text(
                    'Hủy kích hoạt thành công',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  showProgressBar: false,
                  alignment: Alignment.topRight,
                  autoCloseDuration: const Duration(seconds: 5),
                  boxShadow: highModeShadow,
                  dragToClose: true,
                  pauseOnHover: true,
                );
              } else {
                toastification.show(
                  context: context,
                  type: ToastificationType.success,
                  style: ToastificationStyle.flat,
                  title: const Text(
                    'Kích hoạt thành công',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  showProgressBar: false,
                  alignment: Alignment.topRight,
                  autoCloseDuration: const Duration(seconds: 5),
                  boxShadow: highModeShadow,
                  dragToClose: true,
                  pauseOnHover: true,
                );
              }
              _model.getListUser(type: type, value: _textController.text);

              Navigator.of(context).pop();
            } else {
              if (!e.status) {
                toastification.show(
                  context: context,
                  type: ToastificationType.error,
                  style: ToastificationStyle.flat,
                  title: const Text(
                    'Hủy kích hoạt thất bại',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  showProgressBar: false,
                  alignment: Alignment.topRight,
                  autoCloseDuration: const Duration(seconds: 5),
                  boxShadow: highModeShadow,
                  dragToClose: true,
                  pauseOnHover: true,
                );
              } else {
                toastification.show(
                  context: context,
                  type: ToastificationType.error,
                  style: ToastificationStyle.flat,
                  title: const Text(
                    'Kích hoạt thất bại',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  showProgressBar: false,
                  alignment: Alignment.topRight,
                  autoCloseDuration: const Duration(seconds: 5),
                  boxShadow: highModeShadow,
                  dragToClose: true,
                  pauseOnHover: true,
                );
              }
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  void onCreateUser(CreateUserDTO dto) async {
    await _model.createUser(dto).then(
      (value) {
        if (value == true) {
          toastification.show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flat,
            title: const Text(
              'Tạo người dùng thành công',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            showProgressBar: false,
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 5),
            boxShadow: highModeShadow,
            dragToClose: true,
            pauseOnHover: true,
          );
          page = PageUser.LIST;
          _model.getListUser(type: type, value: _textController.text);
          setState(() {});
        } else {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: const Text(
              'Tạo người dùng thất bại',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            showProgressBar: false,
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 5),
            boxShadow: highModeShadow,
            dragToClose: true,
            pauseOnHover: true,
          );
        }
      },
    );
  }
}
