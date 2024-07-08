import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/dashboard/widget/item_menu_top.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/provider/list_connect_provider.dart';
import 'package:vietqr_admin/feature/merchant/views/merchant.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

import '../../../commons/constants/utils/custom_scroll.dart';
import '../../../models/DTO/connect.dto.dart';
import 'blocs/list_connect_bloc.dart';
import 'events/list_connect_event.dart';
import 'states/list_connect_state.dart';
import 'widget/update_merchant_info_popup.dart';

class ListConnectScreen extends StatelessWidget {
  const ListConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListConnectProvider>(
      create: (context) => ListConnectProvider(),
      child: BlocProvider<ListConnectBloc>(
          create: (_) => ListConnectBloc()
            ..add(const ListConnectGetListEvent(
                type: 9, value: '', page: 1, size: 20)),
          child: const _ListConnectScreen()),
    );
  }
}

class _ListConnectScreen extends StatefulWidget {
  const _ListConnectScreen();

  @override
  State<_ListConnectScreen> createState() => _ListConnectScreenState();
}

class _ListConnectScreenState extends State<_ListConnectScreen> {
  @override
  void dispose() {
    super.dispose();
    _merchantController.clear();
  }

  final TextEditingController _merchantController = TextEditingController();
  List<ConnectDTO> result = [];
  StreamSubscription? _subscription;
  late ListConnectBloc _bloc;
  final PageController pageViewController = PageController();
  int typeScreen = 0;
  int? currentPage = 1;
  int? totalPages = 7;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _subscription = eventBus.on<GetListConnect>().listen((data) {
      _bloc.add(ListConnectGetListEvent(
          type: typeScreen,
          value: _merchantController.text,
          page: 1,
          size: 20));
      context
          .read<ListConnectProvider>()
          .changeFilter(const FilterTransaction(id: 9, title: 'Tất cả'));
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: AppColor.WHITE,
      width: width,
      child: Column(
        children: [
          Consumer<ListConnectProvider>(builder: (context, provider, child) {
            return Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration:
                  BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.2)),
              child: Row(
                children: [
                  if (provider.page == 1)
                    InkWell(
                      onTap: () {
                        provider.changePage(0);
                        pageViewController.previousPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 24),
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Danh sách kết nối',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  if (provider.page == 1) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor.BLUE_TEXT,
                        size: 20,
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Chi tiết Merchant',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ] else
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ItemMenuTop(
                                  title: 'Tất cả',
                                  isSelect: provider.valueFilter.id == 9,
                                  onTap: () {
                                    _merchantController.clear();
                                    setState(() {
                                      typeScreen = 9;
                                    });
                                    provider.changeFilter(
                                        const FilterTransaction(
                                            id: 9, title: 'Tất cả'));
                                    _bloc.add(ListConnectGetListEvent(
                                        type: typeScreen,
                                        value: _merchantController.text,
                                        page: 1,
                                        size: 20));
                                  },
                                ),
                                ItemMenuTop(
                                  title: 'API Service',
                                  isSelect: provider.valueFilter.id == 0,
                                  onTap: () {
                                    _merchantController.clear();
                                    setState(() {
                                      typeScreen = 0;
                                    });
                                    provider.changeFilter(
                                        const FilterTransaction(
                                            id: 0, title: 'API Service'));
                                    _bloc.add(ListConnectGetListEvent(
                                        type: typeScreen,
                                        value: _merchantController.text,
                                        page: 1,
                                        size: 20));
                                  },
                                ),
                                ItemMenuTop(
                                  title: 'Ecommerce',
                                  isSelect: provider.valueFilter.id == 1,
                                  onTap: () {
                                    _merchantController.clear();
                                    setState(() {
                                      typeScreen = 1;
                                    });
                                    provider.changeFilter(
                                        const FilterTransaction(
                                            id: 1, title: 'Ecommerce'));
                                    _bloc.add(ListConnectGetListEvent(
                                        type: typeScreen,
                                        value: _merchantController.text,
                                        page: 1,
                                        size: 20));
                                  },
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 20),
              Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: AppColor.WHITE,
                ),
                child: TextField(
                  controller: _merchantController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 16),
                    border: InputBorder.none,
                    hintText: 'Nhập tên đại lý',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColor.GREY_TEXT,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () {
                  _bloc.add(ListConnectGetListEvent(
                      type: typeScreen,
                      value: _merchantController.text,
                      page: 1,
                      size: 20));
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 20, right: 20),
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
                        style: TextStyle(color: AppColor.WHITE, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: PageView(
              controller: pageViewController,
              children: [
                _buildListConnect(),
                const MerchantView(),
                // const InformationPopup(),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // _pagingWidget(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Widget _pagingWidget() {
  //   return BlocBuilder<ListConnectBloc, ListConnectState>(
  //     builder: (context, state) {
  //       bool isPaging = false;
  //       if (state is ListConnectFailedState) {
  //         return const SizedBox.shrink();
  //       }
  //       if (state is ListConnectLoadingState) {
  //         return const SizedBox.shrink();
  //       }
  //       if (state is ListConnectSuccessfulState) {
  //         if (state.metaData!.page != state.metaData!.totalPage) {
  //           isPaging = true;
  //         }
  //         return state.metaData != null
  //             ? Padding(
  //                 padding: const EdgeInsets.only(left: 30),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Container(
  //                       padding: const EdgeInsets.all(4),
  //                       child: Text(
  //                         "Trang ${state.metaData!.page}/${state.metaData!.totalPage}",
  //                         style: const TextStyle(fontSize: 13),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 30),
  //                     InkWell(
  //                       onTap: () {
  //                         if (state.metaData!.page != 1) {
  //                           // await model.filterListInvoice(
  //                           //   time: selectDate!,
  //                           //   page: paging.page! - 1,
  //                           //   filter: textInput()!,
  //                           // );
  //                           _bloc.add(ListConnectGetListEvent(
  //                               type: typeScreen,
  //                               value: _merchantController.text,
  //                               page: state.metaData!.page - 1,
  //                               size: 20));
  //                         }
  //                       },
  //                       child: Container(
  //                         padding: const EdgeInsets.all(4),
  //                         decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(100),
  //                             border: Border.all(
  //                                 color: state.metaData!.page != 1
  //                                     ? AppColor.BLACK
  //                                     : AppColor.GREY_DADADA)),
  //                         child: Center(
  //                           child: Icon(
  //                             Icons.chevron_left_rounded,
  //                             color: state.metaData!.page != 1
  //                                 ? AppColor.BLACK
  //                                 : AppColor.GREY_DADADA,
  //                             size: 20,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 15),
  //                     InkWell(
  //                       onTap: () {
  //                         if (isPaging) {
  //                           // await model.filterListInvoice(
  //                           //   time: selectDate!,
  //                           //   page: paging.page! + 1,
  //                           //   filter: textInput()!,
  //                           // );
  //                           _bloc.add(ListConnectGetListEvent(
  //                               type: typeScreen,
  //                               value: _merchantController.text,
  //                               page: state.metaData!.page + 1,
  //                               size: 20));
  //                         }
  //                       },
  //                       child: Container(
  //                         padding: const EdgeInsets.all(4),
  //                         decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(100),
  //                             border: Border.all(
  //                                 color: isPaging
  //                                     ? AppColor.BLACK
  //                                     : AppColor.GREY_DADADA)),
  //                         child: Center(
  //                           child: Icon(
  //                             Icons.chevron_right_rounded,
  //                             color: isPaging
  //                                 ? AppColor.BLACK
  //                                 : AppColor.GREY_DADADA,
  //                             size: 20,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             : const SizedBox.shrink();
  //       } else {
  //         return const SizedBox.shrink();
  //       }
  //     },
  //   );
  // }

  Widget _buildListConnect() {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocConsumer<ListConnectBloc, ListConnectState>(
            listener: (context, state) {
              if (state is ListConnectSuccessfulState) {
                result = state.dto;
              }
            },
            builder: (context, state) {
              if (state is ListConnectLoadingState) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(child: Text('Đang tải...')),
                );
              }
              if (result.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 300),
                  child: Center(child: Text('Danh sách trống')),
                );
              }
              return LayoutBuilder(builder: (context, constraints) {
                return ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: constraints.maxWidth > 1040
                          ? constraints.maxWidth
                          : 1040,
                      child: Column(
                        children: [
                          _buildTitleItem(),
                          ...result.map((e) {
                            int index = result.indexOf(e) + 1;

                            return _buildItem(e, index);
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildItem(ConnectDTO dto, int index) {
    return Container(
      color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              '$index ',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
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
            width: 120,
            child: SelectableText(
              dto.merchant.isNotEmpty ? dto.merchant : '-',
              textAlign: TextAlign.center,
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
                dto.url.isNotEmpty ? dto.url : '-',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            width: 120,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: SelectionArea(
              child: Text(
                dto.ip.isNotEmpty ? dto.ip : '-',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            width: 120,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: SelectableText(
              dto.port.isNotEmpty ? dto.port : '-',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 130,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: SelectableText(
              dto.active == 1 ? 'Hoạt động' : 'Không hoạt động',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 150,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: SelectableText(
              dto.platform.isNotEmpty ? dto.platform : '-',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 200,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Row(
              children: [
                const Text('', style: TextStyle(fontSize: 12)),
                InkWell(
                  onTap: () {
                    Session.instance.updateConnectDTO(dto);

                    Provider.of<ListConnectProvider>(context, listen: false)
                        .changePage(1);

                    pageViewController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn);
                  },
                  child: const Text(
                    'Chi tiết',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColor.BLUE_TEXT,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    DialogWidget.instance.openPopupCenter(
                      child: UpdateMerchantPopup(
                        dto: dto,
                        uploadSuccess: () {
                          BlocProvider.of<ListConnectBloc>(context).add(
                              ListConnectGetListEvent(
                                  page: 1,
                                  size: 20,
                                  value: _merchantController.text,
                                  type: context
                                      .read<ListConnectProvider>()
                                      .valueFilter
                                      .id));
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Chỉnh sửa',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColor.BLUE_TEXT,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    Map<String, dynamic> param = {};
                    param['customerSyncId'] = dto.id;
                    param['status'] = dto.active == 1 ? 0 : 1;
                    BlocProvider.of<ListConnectBloc>(context).add(
                        ListConnectUpdateStatusEvent(
                            page: 1,
                            size: 20,
                            value: _merchantController.text,
                            param: param,
                            type: context
                                .read<ListConnectProvider>()
                                .valueFilter
                                .id));
                  },
                  child: Text(
                    dto.active == 1 ? 'Tắt kết nối' : 'Bật kết nối',
                    style: TextStyle(
                        fontSize: 11,
                        color: dto.active == 1
                            ? AppColor.RED_TEXT
                            : AppColor.BLUE_TEXT,
                        decoration: TextDecoration.underline),
                  ),
                )
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
          _buildItemTitle('No.',
              height: 50,
              width: 50,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Tên đại lý',
              height: 50,
              width: 120,
              padding: const EdgeInsets.only(left: 12),
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          Expanded(
            child: _buildItemTitle('URL',
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                textAlign: TextAlign.center),
          ),
          _buildItemTitle('IP',
              height: 50,
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Port',
              height: 50,
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Trạng thái',
              height: 50,
              width: 130,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Nền tảng kết nối',
              height: 50,
              width: 150,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Action',
              height: 50,
              width: 200,
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
}
