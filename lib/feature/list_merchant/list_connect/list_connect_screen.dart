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
import 'package:vietqr_admin/models/connect.dto.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

import '../../../commons/constants/utils/custom_scroll.dart';
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
          create: (_) =>
              ListConnectBloc()..add(const ListConnectGetListEvent(type: 9)),
          child: const _ListConnectScreen()),
    );
  }
}

class _ListConnectScreen extends StatefulWidget {
  const _ListConnectScreen({Key? key}) : super(key: key);

  @override
  State<_ListConnectScreen> createState() => _ListConnectScreenState();
}

class _ListConnectScreenState extends State<_ListConnectScreen> {
  List<ConnectDTO> result = [];

  StreamSubscription? _subscription;

  late ListConnectBloc _bloc;
  final PageController pageViewController = PageController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _subscription = eventBus.on<GetListConnect>().listen((data) {
      _bloc.add(const ListConnectGetListEvent(type: 9));
      context
          .read<ListConnectProvider>()
          .changeFilter(const FilterTransaction(id: 9, title: 'Tất cả'));
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
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
                        child: Row(
                          children: const [
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
                          // Container(
                          //   margin: const EdgeInsets.symmetric(
                          //       vertical: 8, horizontal: 12),
                          //   padding: const EdgeInsets.symmetric(horizontal: 12),
                          //   alignment: Alignment.center,
                          //   decoration: BoxDecoration(
                          //     color: AppColor.GREY_BG,
                          //     borderRadius: BorderRadius.circular(5),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       const Text(
                          //         'Lọc theo',
                          //         style: TextStyle(
                          //             fontSize: 11, color: AppColor.GREY_TEXT),
                          //       ),
                          //       const SizedBox(
                          //         width: 20,
                          //       ),
                          //       DropdownButton<FilterTransaction>(
                          //         value: provider.valueFilter,
                          //         icon: const RotatedBox(
                          //           quarterTurns: 5,
                          //           child: Icon(
                          //             Icons.arrow_forward_ios,
                          //             size: 12,
                          //           ),
                          //         ),
                          //         underline: const SizedBox.shrink(),
                          //         onChanged: (FilterTransaction? value) {
                          //           provider.changeFilter(value!);
                          //           _bloc.add(ListConnectGetListEvent(
                          //               type: value.id));
                          //         },
                          //         items: provider.listFilter
                          //             .map<DropdownMenuItem<FilterTransaction>>(
                          //                 (FilterTransaction value) {
                          //           return DropdownMenuItem<FilterTransaction>(
                          //             value: value,
                          //             child: Padding(
                          //               padding:
                          //                   const EdgeInsets.only(right: 4),
                          //               child: Text(
                          //                 value.title,
                          //                 style: const TextStyle(fontSize: 12),
                          //               ),
                          //             ),
                          //           );
                          //         }).toList(),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ItemMenuTop(
                                  title: 'Tất cả',
                                  isSelect: provider.valueFilter.id == 9,
                                  onTap: () {
                                    provider.changeFilter(
                                        const FilterTransaction(
                                            id: 9, title: 'Tất cả'));
                                    _bloc.add(
                                        const ListConnectGetListEvent(type: 9));
                                  },
                                ),
                                ItemMenuTop(
                                  title: 'API Service',
                                  isSelect: provider.valueFilter.id == 0,
                                  onTap: () {
                                    provider.changeFilter(
                                        const FilterTransaction(
                                            id: 0, title: 'API Service'));
                                    _bloc.add(
                                        const ListConnectGetListEvent(type: 0));
                                  },
                                ),
                                ItemMenuTop(
                                  title: 'Ecommerce',
                                  isSelect: provider.valueFilter.id == 1,
                                  onTap: () {
                                    provider.changeFilter(
                                        const FilterTransaction(
                                            id: 1, title: 'Ecommerce'));
                                    _bloc.add(
                                        const ListConnectGetListEvent(type: 1));
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
        ],
      ),
    );
  }

  Widget _buildListConnect() {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocConsumer<ListConnectBloc, ListConnectState>(
              listener: (context, state) {
            if (state is ListConnectSuccessfulState) {
              result = state.dto;
            }
          }, builder: (context, state) {
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
                        }).toList(),
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
