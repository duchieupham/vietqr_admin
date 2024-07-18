import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/QrBoxManage/QrBox/widgets/title_item_qr_box_widget.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/qr_box_dto.dart';
import 'package:vietqr_admin/models/DTO/qr_box_msg_dto.dart';

import '../../../ViewModel/qr_box_viewModel.dart';
import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/constants/enum/view_status.dart';
import '../../../commons/widget/box_layout.dart';
import '../../../models/DTO/metadata_dto.dart';
import 'widgets/item_qr_box_widget.dart';
import 'widgets/popup_create_qr_box.dart';

class QrBoxListScreen extends StatefulWidget {
  const QrBoxListScreen({super.key});

  @override
  State<QrBoxListScreen> createState() => _QrBoxListScreenState();
}

class _QrBoxListScreenState extends State<QrBoxListScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _homePageTextController = TextEditingController();

  final TextEditingController _msg1Controller = TextEditingController();
  final TextEditingController _msg2Controller = TextEditingController();

  late ScrollController controller1;
  late ScrollController controller2;

  final ScrollController scrollHorizontal = ScrollController();
  bool isScrollingDown1 = false;
  bool isScrollingDown2 = false;

  late QrBoxViewModel _model;

  int type = 9;

  @override
  void initState() {
    super.initState();
    _model = Get.find<QrBoxViewModel>();
    _model.getListQrBox(type: type);
    _model.getQRBoxMsg();
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

  void onShowPopup(QrBoxDTO dto) async {
    return await showDialog(
      context: context,
      builder: (context) => PopupCreateQrBoxWidget(dto: dto),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      body: ScopedModel<QrBoxViewModel>(
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
              Expanded(child: _bodyWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterWidget(),
          const SizedBox(height: 30),
          const MySeparator(color: AppColor.GREY_DADADA),
          const SizedBox(height: 30),
          const Text(
            'Danh sách QR Box',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          _buildListQrBox(),
          const SizedBox(height: 20),
          _pagingWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildListQrBox() {
    return ScopedModelDescendant<QrBoxViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading) {
          return const Expanded(child: Center(child: Text('Đang tải...')));
        }
        if (model.status == ViewStatus.Error || model.qrBoxList!.isEmpty) {
          return const SizedBox.shrink();
        }
        List<QrBoxDTO>? list = model.qrBoxList;
        List<Widget> buildItemList(List<QrBoxDTO>? list, MetaDataDTO metadata) {
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
                    ItemQrBoxWidget(
                      dto: e,
                      index: calculatedIndex,
                    ));
              })
              .values
              .toList();
        }

        MetaDataDTO metadata = model.metadata!;

        return Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 220,
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: controller1,
                  child: Scrollbar(
                    controller: scrollHorizontal,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: scrollHorizontal,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 2060,
                        child: Column(
                          children: [
                            const TitleItemQrBoxWidget(),
                            ...buildItemList(list, metadata)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2060,
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      SingleChildScrollView(
                        controller: controller2,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
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
                                          width: 110,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    color: AppColor.GREY_TEXT
                                                        .withOpacity(0.3)),
                                                bottom: BorderSide(
                                                    color: AppColor.GREY_TEXT
                                                        .withOpacity(0.3))),
                                          ),
                                          child: const Text(
                                            'Hoạt động\ncuối cùng',
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
                                  (e) {
                                    String type = '';
                                    Color color = Colors.white;
                                    switch (e.status) {
                                      case 0:
                                        type = 'Offline';
                                        color = const Color(0xFFF5233C);
                                        break;
                                      case 1:
                                        type = 'Online';
                                        color = const Color(0xFF00CA28);
                                        break;
                                      case 2:
                                        type = 'Khởi tạo';
                                        color = const Color(0xFF0072FF);
                                        break;
                                      case 3:
                                        type = 'Chưa xác định';
                                        color = const Color(0xFF666A72);
                                        break;
                                      default:
                                        type = 'Chưa xác định';
                                        color = const Color(0xFF666A72);
                                        break;
                                    }
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(
                                                        color: AppColor
                                                            .GREY_TEXT
                                                            .withOpacity(0.3)),
                                                    bottom: BorderSide(
                                                        color: AppColor
                                                            .GREY_TEXT
                                                            .withOpacity(0.3)),
                                                    right: BorderSide(
                                                        color: AppColor
                                                            .GREY_TEXT
                                                            .withOpacity(
                                                                0.3)))),
                                            height: 50,
                                            width: 130,
                                            child: SelectionArea(
                                              child: Text(
                                                type,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: color,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border(
                                              bottom: BorderSide(
                                                  color: AppColor.GREY_TEXT
                                                      .withOpacity(0.3)),
                                            )),
                                            height: 50,
                                            width: 110,
                                            child: SelectionArea(
                                              child: Text(
                                                e.lastChecked == 0
                                                    ? '-'
                                                    : TimeUtils.instance
                                                        .formatTimeNotification(
                                                            e.lastChecked),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColor.GREY_TEXT,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(
                                                        color: AppColor
                                                            .GREY_TEXT
                                                            .withOpacity(0.3)),
                                                    bottom: BorderSide(
                                                        color: AppColor
                                                            .GREY_TEXT
                                                            .withOpacity(0.3)),
                                                    right: BorderSide(
                                                        color: AppColor
                                                            .GREY_TEXT
                                                            .withOpacity(
                                                                0.3)))),
                                            height: 50,
                                            width: 100,
                                            child: Row(
                                              children: [
                                                Visibility(
                                                  visible: true,
                                                  child: Tooltip(
                                                    message: 'Tạo mã QR',
                                                    child: InkWell(
                                                      onTap: () {
                                                        onShowPopup(e);
                                                      },
                                                      child: BoxLayout(
                                                        width: 30,
                                                        height: 30,
                                                        borderRadius: 100,
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        bgColor: AppColor
                                                            .BLUE_TEXT
                                                            .withOpacity(0.3),
                                                        child: const Icon(
                                                          Icons.qr_code,
                                                          size: 12,
                                                          color: AppColor
                                                              .BLUE_TEXT,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Visibility(
                                                  visible: true,
                                                  child: SizedBox(width: 10),
                                                ),
                                                const SizedBox(width: 10),
                                                Tooltip(
                                                  message: 'Xoá',
                                                  child: InkWell(
                                                    onTap: () {
                                                      DialogWidget.instance
                                                          .openMsgDialog(
                                                              title: 'Bảo trì',
                                                              msg:
                                                                  'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                                                    },
                                                    child: BoxLayout(
                                                      width: 30,
                                                      height: 30,
                                                      borderRadius: 100,
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      bgColor: AppColor.RED_TEXT
                                                          .withOpacity(0.3),
                                                      child: const Icon(
                                                        Icons.delete_forever,
                                                        size: 12,
                                                        color:
                                                            AppColor.RED_TEXT,
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
                                  },
                                )
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

  Widget _pagingWidget() {
    return ScopedModelDescendant<QrBoxViewModel>(
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

        return paging != null
            ? Row(
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
                        await model.getListQrBox(
                            page: paging.page! - 1,
                            type: type,
                            value: type != 9 ? _textController.text : '');
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
                        await model.getListQrBox(
                            page: paging.page! + 1,
                            type: type,
                            value: type != 9 ? _textController.text : '');
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
                          color:
                              isPaging ? AppColor.BLACK : AppColor.GREY_DADADA,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _filterWidget() {
    return ScopedModelDescendant<QrBoxViewModel>(
      builder: (context, child, model) {
        if (model.qrMsg == null) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (model.qrMsg != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Home Page:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 250,
                    height: 40,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColor.GREY_DADADA)),
                    child: TextField(
                      controller: _homePageTextController,
                      onChanged: (value) {
                        _homePageTextController.value = TextEditingValue(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length));
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(bottom: 8, top: 8),
                          border: InputBorder.none,
                          hintText: model.qrMsg!.homePage,
                          hintStyle: const TextStyle(
                              fontSize: 15, color: AppColor.BLUE_TEXT),
                          suffixIcon: IconButton(
                              onPressed: () {
                                _homePageTextController.clear();
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 15,
                                color: AppColor.GREY_TEXT,
                              ))),
                      maxLines: 1,
                    ),
                  ),
                ],
              )
            ],
            const SizedBox(height: 30),
            const Text(
              'Tìm kiếm thông tin ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            model.qrMsg != null
                ? Row(
                    children: [
                      const Text(
                        "Nội dung thanh toán thành công:",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 350,
                        height: 40,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: AppColor.WHITE,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: AppColor.GREY_DADADA)),
                        child: TextField(
                          controller: _msg1Controller,
                          onChanged: (value) {
                            _msg1Controller.value = TextEditingValue(
                                text: value,
                                selection: TextSelection.collapsed(
                                    offset: value.length));
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(bottom: 8, top: 8),
                              border: InputBorder.none,
                              hintText: model.qrMsg!.message1,
                              hintStyle: const TextStyle(
                                  fontSize: 15, color: AppColor.GREY_TEXT),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _msg1Controller.clear();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    size: 15,
                                    color: AppColor.GREY_TEXT,
                                  ))),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Số tiền",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 200,
                        height: 40,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: AppColor.WHITE,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: AppColor.GREY_DADADA)),
                        child: TextField(
                          controller: _msg2Controller,
                          onChanged: (value) {
                            _msg2Controller.value = TextEditingValue(
                                text: value,
                                selection: TextSelection.collapsed(
                                    offset: value.length));
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(bottom: 8, top: 8),
                              border: InputBorder.none,
                              hintText: model.qrMsg!.message2,
                              hintStyle: const TextStyle(
                                  fontSize: 15, color: AppColor.GREY_TEXT),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _msg2Controller.clear();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    size: 15,
                                    color: AppColor.GREY_TEXT,
                                  ))),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 30),
                      InkWell(
                        onTap: () async {
                          if (_msg1Controller.text.isNotEmpty ||
                              _msg2Controller.text.isNotEmpty ||
                              _homePageTextController.text.isNotEmpty) {
                            QRBoxMsgDTO msg = QRBoxMsgDTO(
                                homePage:
                                    _homePageTextController.text.isNotEmpty
                                        ? _homePageTextController.text
                                        : model.qrMsg!.homePage,
                                message1: _msg1Controller.text.isNotEmpty
                                    ? _msg1Controller.text
                                    : model.qrMsg!.message1,
                                message2: _msg2Controller.text.isNotEmpty
                                    ? _msg2Controller.text
                                    : model.qrMsg!.message2);
                            final result = await model.updateMsg(msg);
                            if (result!) {
                              DialogWidget.instance.openMsgSuccessDialog(
                                title: 'Cập nhật thành công',
                                function: () {
                                  _model.getQRBoxMsg();
                                  Navigator.of(context).pop();
                                },
                              );
                            }
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                            color: AppColor.BLUE_TEXT,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'Cập nhật',
                              style: TextStyle(
                                  fontSize: 15, color: AppColor.WHITE),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 30),
            const Text(
              "Tìm kiếm theo",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  height: 40,
                  width: type == 9 ? 250 : 500,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.GREY_DADADA)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: type == 9 ? 220 : 150,
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
                                value: 9,
                                child: Text(
                                  "Tất cả (mặc định)",
                                )),
                            DropdownMenuItem<int>(
                                value: 0,
                                child: Text(
                                  "TK ngân hàng",
                                )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              type = value!;
                            });
                          },
                        ),
                      ),
                      if (type != 9)
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
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
                                width: 300,
                                child: TextField(
                                  controller: _textController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (value) {
                                    model.getListQrBox(
                                        type: type, value: value);
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 8, top: 8),
                                    border: InputBorder.none,
                                    hintText: 'Tìm kiếm theo TK ngân hàng',
                                    hintStyle: const TextStyle(
                                        fontSize: 15,
                                        color: AppColor.GREY_TEXT),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      size: 15,
                                      color: AppColor.GREY_TEXT,
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          _textController.clear();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 15,
                                          color: AppColor.GREY_TEXT,
                                        )),
                                  ),
                                  maxLines: 1,
                                ),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    model.getListQrBox(type: type, value: _textController.text);
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
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
      width: MediaQuery.of(context).size.width * 0.22,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Quản lý QR Box",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "/",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Danh sách QR Box",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
