// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:vietqr_admin/View/SystemManage/BankSystem/widgets/item_bank_widget.dart';
import 'package:vietqr_admin/View/SystemManage/BankSystem/widgets/popup_bank_detail_widget.dart';
import 'package:vietqr_admin/View/SystemManage/BankSystem/widgets/popup_check_log.dart';
import 'package:vietqr_admin/View/SystemManage/BankSystem/widgets/title_item_bank_widget.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/share_utils.dart';
import 'package:vietqr_admin/commons/utils/format_date.dart';
import 'package:vietqr_admin/commons/widget/box_layout.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/bank_system_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';

enum Actions {
  copy,
  detail,
  // check,
}

// ignore: must_be_immutable
class ListBankSystemWidget extends StatefulWidget {
  int pageSize;
  ListBankSystemWidget({
    super.key,
    required this.pageSize,
  });

  @override
  State<ListBankSystemWidget> createState() => _ListBankSystemWidgetState();
}

class _ListBankSystemWidgetState extends State<ListBankSystemWidget> {
  late LinkedScrollControllerGroup _linkedScrollControllerGroup;
  late ScrollController _horizontal;
  late ScrollController _vertical;
  late ScrollController _vertical2;
  // ignore: unused_field
  late SystemViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<SystemViewModel>();
    _linkedScrollControllerGroup = LinkedScrollControllerGroup();

    _vertical = _linkedScrollControllerGroup.addAndGet();
    _vertical2 = _linkedScrollControllerGroup.addAndGet();

    _horizontal = ScrollController();
  }

  @override
  void dispose() {
    _vertical.dispose();
    _vertical2.dispose();
    _horizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SystemViewModel>(
      builder: (context, child, model) {
        // if (model.status == ViewStatus.Loading) {
        //   return const Expanded(child: Center(child: Text('Đang tải...')));
        // }
        if (model.status == ViewStatus.Error
            // && model.request != InvoiceType.REQUEST_PAYMENT) {
            ) {
          return const SizedBox.shrink();
        }
        // List<InvoiceItem>? list = model.invoiceDTO?.items;
        // InvoiceDTO? invoiceDTO = model.invoiceDTO;
        // MetaDataDTO metadata = model.metadata!;
        List<Widget> buildItemList(
            List<BankSystemItem>? list, MetaDataDTO metadata) {
          if (list == null || list.isEmpty) {
            return [];
          }

          return list
              .asMap()
              .map((index, e) {
                int calculatedIndex =
                    index + ((metadata.page! - 1) * widget.pageSize);
                return MapEntry(
                    index,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItemBankWidget(
                          dto: e,
                          index: calculatedIndex,
                          colorText: (e.validFeeTo != 0 &&
                                  inclusiveDays(e.validFeeTo) <= 0)
                              ? AppColor.RED_TEXT
                              : (e.authenticated)
                                  ? AppColor.GREEN
                                  : (e.validFeeTo != 0 &&
                                          inclusiveDays(e.validFeeTo) <= 7)
                                      ? AppColor.ORANGE
                                      : AppColor.BLACK,
                        ),
                        if (index + 1 != list.length)
                          const SizedBox(
                              width: 1520,
                              child: MySeparator(color: AppColor.GREY_DADADA)),
                      ],
                    ));
              })
              .values
              .toList();
        }

        return Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned.fill(
                    right: 220,
                    child: SizedBox(
                      width: 1350,
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
                                // TitleItemBankWidget(
                                //     width: constraints.maxWidth),
                                const TitleItemBankWidget(),
                                if (model.status == ViewStatus.Loading)
                                  Expanded(
                                    child: Container(
                                      width: constraints.maxWidth,
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(),
                                    ),
                                  )
                                else if (model.bankSystemDTO != null)
                                  Expanded(
                                      child: ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(context)
                                        .copyWith(scrollbars: false),
                                    child: SingleChildScrollView(
                                      controller: _vertical,
                                      physics: const ClampingScrollPhysics(),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...buildItemList(
                                              model.bankSystemDTO!.items,
                                              model.metadata!)
                                        ],
                                      ),
                                    ),
                                  ))
                                else
                                  const SizedBox.shrink()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 1550,
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
                                  color: AppColor.BLUE_TEXT.withOpacity(0.3),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 40,
                                        width: 120,
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
                                        height: 40,
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
                              else if (model.bankSystemDTO != null)
                                Expanded(
                                    child: SingleChildScrollView(
                                  controller: _vertical2,
                                  physics: const ClampingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      ...model.bankSystemDTO!.items.map(
                                        (e) {
                                          return Column(
                                            children: [
                                              _rightItem(e),
                                              // if (index + 1 != list.length)
                                              const SizedBox(
                                                  width: 220,
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
          ),
        );
      },
    );
  }

  Widget _rightItem(BankSystemItem e) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            height: 40,
            width: 120,
            child: SelectionArea(
                child: Text(
              !e.authenticated ? 'Chưa liên kết' : 'Đã liên kết',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: !e.authenticated ? AppColor.ORANGE_DARK : AppColor.GREEN_STATUS,
              ),
            )),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            // decoration: BoxDecoration(
            //   // border: Border(
            //   //   // left: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
            //   //   bottom: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
            //   //   right: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
            //   // ),
            // ),
            height: 40,
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
                      case Actions.detail:
                        onDetail(dto: e);
                        break;
                      // case Actions.check:
                      //   onCheckActiveKey(dto: e);
                      //   break;
                    }
                  },
                  itemBuilder: (BuildContext context) => _buildMenuItems(e),
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

  void onCopy({required BankSystemItem dto}) async {
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

  void onDetail({required BankSystemItem dto}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupBankDetailWidget(
          dto: dto,
        );
      },
    );
  }

  // void onCheckActiveKey({required BankSystemItem dto}) async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return PopupCheckKeyWidget(
  //         dto: dto,
  //       );
  //     },
  //   );
  // }

  List<PopupMenuEntry<Actions>> _buildMenuItems(BankSystemItem e) {
    List<PopupMenuEntry<Actions>> items = [
      const PopupMenuItem<Actions>(
        value: Actions.copy,
        child: Text('Copy'),
      ),
      PopupMenuItem<Actions>(
        value: Actions.detail,
        child: e.validService
            ? const Text('Gia hạn Key')
            : const Text('Kích hoạt Key'),
      ),
      // const PopupMenuItem<Actions>(
      //   value: Actions.check,
      //   child: Text('Kiểm tra Key'),
      // ),
    ];
    return items;
  }
}
