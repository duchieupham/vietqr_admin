import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/error_utils.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/config/lark_web_hook/lark_web_hook/blocs/list_connect_bloc.dart';
import 'package:vietqr_admin/feature/config/lark_web_hook/lark_web_hook/events/lark_event.dart';
import 'package:vietqr_admin/feature/config/lark_web_hook/lark_web_hook/provider/list_connect_provider.dart';
import 'package:vietqr_admin/feature/config/lark_web_hook/lark_web_hook/states/lark_state.dart';
import 'package:vietqr_admin/feature/config/lark_web_hook/lark_web_hook/widget/update_web_hook_popup.dart';

import '../../../../models/DTO/web_hook_dto.dart';

class LarkHook extends StatefulWidget {
  const LarkHook({Key? key}) : super(key: key);

  @override
  State<LarkHook> createState() => _LarkHookScreenState();
}

class _LarkHookScreenState extends State<LarkHook> {
  List<WebHookDTO> listLark = [];

  StreamSubscription? _subscription;
  TextEditingController desEditingCtl = TextEditingController();
  TextEditingController webhookEditingCtl = TextEditingController();
  TextEditingController nameEditingCtl = TextEditingController();
  late LarkBloc _bloc;
  final PageController pageViewController = PageController();

  @override
  void initState() {
    super.initState();
    _bloc = LarkBloc()..add(const LarkGetListEvent());
    _subscription = eventBus.on<GetListLark>().listen((data) {
      _bloc.add(const LarkGetListEvent(isRefresh: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<LarkProvider>(
      create: (context) => LarkProvider(),
      child: BlocProvider<LarkBloc>(
        create: (context) => _bloc,
        child: SizedBox(
          width: width,
          child: Column(
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration:
                    BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.2)),
                child: Row(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Lark Webhook',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    Consumer<LarkProvider>(builder: (context, provider, child) {
                      return InkWell(
                        onTap: () {
                          provider.updateShowForm(true);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 4, bottom: 4, left: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          width: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColor.BLUE_TEXT,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Thêm mới',
                            style:
                                TextStyle(fontSize: 12, color: AppColor.WHITE),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Expanded(
                child: _buildListConnect(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListConnect() {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocConsumer<LarkBloc, LarkState>(listener: (context, state) {
            if (state is LarkGetListSuccessfulState) {
              if (state.isRefresh) {
                Navigator.pop(context);
              }
              listLark = state.list;
            }
            if (state is LarkLoadingState) {
              DialogWidget.instance.openLoadingDialog();
            }
            if (state is FailedState) {
              Navigator.pop(context);
              DialogWidget.instance.openMsgDialog(
                  title: 'Đã có lỗi xảy ra',
                  msg: ErrorUtils.instance.getErrorMessage(state.dto.message));
            }
            if (state is UpdateStatusSuccessfulState) {
              _bloc.add(const LarkGetListEvent(isRefresh: true));
            }
            if (state is UpdateDataSuccessfulState) {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              _bloc.add(const LarkGetListEvent(isRefresh: true));
            }
            if (state is InsertSuccessfulState) {
              _bloc.add(const LarkGetListEvent(isRefresh: true));
              context.read<LarkProvider>().updateShowForm(false);
            }
            if (state is RemoveSuccessfulState) {
              _bloc.add(const LarkGetListEvent(isRefresh: true));
            }
          }, builder: (context, state) {
            if (state is LarkLoadingListState) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(child: Text('Đang tải...')),
              );
            }
            if (listLark.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    return ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                            width: constraints.maxWidth > 850
                                ? constraints.maxWidth
                                : 850,
                            child: _buildFormCreate()),
                      ),
                    );
                  }),
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: Text('Danh sách trống'),
                    ),
                  ),
                ],
              );
            }
            return LayoutBuilder(builder: (context, constraints) {
              return ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: constraints.maxWidth > 1080
                        ? constraints.maxWidth
                        : 1080,
                    child: Column(
                      children: [
                        _buildTitleItem(),
                        _buildFormCreate(),
                        ...listLark.map((e) {
                          int index = listLark.indexOf(e) + 1;

                          return _buildItem(e, index);
                        }).toList(),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                ),
              );
            });
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFormCreate() {
    return Consumer<LarkProvider>(builder: (context, provider, child) {
      if (provider.showAddForm) {
        return _buildFormInsert(provider);
      }

      return const SizedBox.shrink();
    });
  }

  Widget _buildFormInsert(LarkProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.GREY_TEXT.withOpacity(0.1),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 50,
          ),
          SizedBox(
            width: 120,
            child: _buildTemplateInput(
              hintText: 'Nhập tên',
              controller: nameEditingCtl,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: _buildTemplateInput(
                hintText: 'Nhập webhook',
                controller: webhookEditingCtl,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: _buildTemplateInput(
                hintText: 'Nhập mô tả',
                controller: desEditingCtl,
              ),
            ),
          ),
          const SizedBox(
            width: 110,
          ),
          SizedBox(
            width: 240,
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ButtonWidget(
                    height: 36,
                    text: 'Lưu',
                    sizeTitle: 12,
                    borderRadius: 5,
                    textColor: AppColor.WHITE,
                    bgColor: AppColor.BLUE_TEXT,
                    function: () {
                      if (nameEditingCtl.text.isEmpty ||
                          desEditingCtl.text.isEmpty ||
                          webhookEditingCtl.text.isEmpty) {
                        DialogWidget.instance.openMsgDialog(
                            title: 'Thông tin không chính xác',
                            msg: 'Vui lòng nhập đầy đủ dữ liệu trên form');
                      } else {
                        Map<String, dynamic> param = {};
                        param['partnerName'] = nameEditingCtl.text;
                        param['webhook'] = webhookEditingCtl.text;
                        param['description'] = desEditingCtl.text;
                        _bloc.add(LarkInsertEvent(param: param));
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                ButtonWidget(
                  height: 36,
                  width: 70,
                  text: 'Đóng',
                  sizeTitle: 12,
                  borderRadius: 5,
                  textColor: AppColor.BLACK,
                  bgColor: AppColor.WHITE,
                  function: () {
                    provider.updateShowForm(false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(WebHookDTO dto, int index) {
    return Container(
      color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: Row(
        children: [
          Center(
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColor.GREY_BUTTON),
                      right: BorderSide(color: AppColor.GREY_BUTTON))),
              width: 50,
              height: 50,
              alignment: Alignment.center,
              child: SelectableText(
                '$index',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            height: 50,
            width: 130,
            child: SelectableText(
              dto.partnerName,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Container(
              height: 50,
              padding: const EdgeInsets.only(left: 12),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColor.GREY_BUTTON),
                      right: BorderSide(color: AppColor.GREY_BUTTON))),
              child: SelectableText(
                dto.webhook,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.BLUE_TEXT,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
          Expanded(
            child: SelectionArea(
              child: Container(
                height: 50,
                padding: const EdgeInsets.only(left: 12),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColor.GREY_BUTTON),
                        right: BorderSide(color: AppColor.GREY_BUTTON))),
                child: Text(
                  dto.description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          Container(
            width: 110,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: SelectableText(
              dto.active ? 'Hoạt động' : 'Không hoạt động',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: dto.active ? AppColor.BLUE_TEXT : AppColor.RED_TEXT),
            ),
          ),
          SizedBox(
            width: 240,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    DialogWidget.instance.openPopupCenter(
                      child: UpdateWebhookPopup(
                        dto: dto,
                        update: (param) {
                          _bloc.add(LarkUpdateDataEvent(param: param));
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColor.GREY_BUTTON),
                            right: BorderSide(color: AppColor.GREY_BUTTON))),
                    child: const Text(
                      'Chỉnh sửa',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Map<String, dynamic> param = {};
                      param['id'] = dto.id;
                      param['active'] = !dto.active;
                      _bloc.add(LarkUpdateStatusEvent(param: param));
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: AppColor.GREY_BUTTON),
                              right: BorderSide(color: AppColor.GREY_BUTTON))),
                      child: Text(
                        dto.active ? 'Tắt hoạt động' : 'Bật hoạt động',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColor.BLUE_TEXT,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    DialogWidget.instance.openMsgDialogQuestion(
                        title: 'Xoá Webhook',
                        msg: 'Bạn có chắc chắn muốn xoá Webhook này',
                        onConfirm: () {
                          Navigator.pop(context);
                          _bloc.add(RemoveEvent(id: dto.id));
                        });
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColor.GREY_BUTTON),
                            right: BorderSide(color: AppColor.GREY_BUTTON))),
                    child: const Text(
                      'Xóa',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColor.RED_TEXT,
                          decoration: TextDecoration.underline),
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

  Widget _buildTitleItem() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.BLUE_DARK),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildItemTitle('STT',
              height: 50, width: 50, alignment: Alignment.center),
          _buildItemTitle('Tên',
              height: 50,
              width: 130,
              padding: const EdgeInsets.only(left: 12),
              alignment: Alignment.center),
          Expanded(
            child: _buildItemTitle('Lark Webhook',
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center),
          ),
          Expanded(
            child: _buildItemTitle('Mô tả',
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center),
          ),
          _buildItemTitle('Trạng thái',
              height: 50,
              width: 110,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Action',
              height: 50,
              width: 240,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
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
        style: const TextStyle(fontSize: 12, color: AppColor.WHITE),
      ),
    );
  }

  Widget _buildTemplateInput({
    String hintText = '',
    TextEditingController? controller,
  }) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: AppColor.WHITE),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            contentPadding: const EdgeInsets.only(bottom: 8),
            hintStyle:
                const TextStyle(fontSize: 11, color: AppColor.GREY_TEXT)),
      ),
    );
  }
}
