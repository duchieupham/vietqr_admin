import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/connect_service/list_connect/provider/list_connect_provider.dart';
import 'package:vietqr_admin/models/connect.dto.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

import '../../../commons/constants/utils/custom_scroll.dart';
import 'blocs/list_connect_bloc.dart';
import 'events/list_connect_event.dart';
import 'states/list_connect_state.dart';
import 'widget/infomation_popup.dart';
import 'widget/update_merchant_info_popup.dart';

class ListConnectScreen extends StatelessWidget {
  const ListConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListConnectProvider>(
      create: (context) => ListConnectProvider(),
      child: BlocProvider<ListConnectBloc>(
          create: (_) => ListConnectBloc()..add(ListConnectGetListEvent()),
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
      _bloc.add(ListConnectGetListEvent());
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
                  ]
                ],
              ),
            );
          }),
          Expanded(
            child: PageView(
              controller: pageViewController,
              children: [
                _buildListConnect(),
                InformationPopup(),
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
              if (constraints.maxWidth < 900) {
                return ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStt(result),
                        _buildMerchant(result),
                        SizedBox(width: 280, child: _buildURL(result)),
                        _buildIp(result),
                        _buildPort(result),
                        _buildStatus(result),
                        _buildPlatform(result),
                        _buildAction(result, context),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                );
              }
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStt(result),
                    _buildMerchant(result),
                    Expanded(child: _buildURL(result)),
                    _buildIp(result),
                    _buildPort(result),
                    _buildStatus(result),
                    _buildPlatform(result),
                    _buildAction(result, context),
                    const SizedBox(width: 12),
                  ],
                ),
              );
            });
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStt(List<ConnectDTO> list) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 20),
      child: Column(
        children: [
          const Text(
            'No.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...list.map((e) {
            int index = list.indexOf(e);
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                '${index + 1}',
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMerchant(List<ConnectDTO> list) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 20),
      child: Column(
        children: [
          const Text(
            'Merchant',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...list.map((e) {
            int index = list.indexOf(e);
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                e.merchant.isNotEmpty ? e.merchant : '-',
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildURL(List<ConnectDTO> list) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          const Text(
            'URL',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...list.map((e) {
            int index = list.indexOf(e);
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: SelectionArea(
                child: Text(
                  e.url.isNotEmpty ? e.url : '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildIp(List<ConnectDTO> list) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 16),
        child: Column(
          children: [
            const Text(
              'IP',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...list.map((e) {
              return Padding(
                padding: const EdgeInsets.only(top: 24),
                child: SelectionArea(
                  child: Text(
                    e.ip.isNotEmpty ? e.ip : '-',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPort(List<ConnectDTO> list) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 28),
      child: Column(
        children: [
          const Text(
            'Port',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...list.map((e) {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: SelectionArea(
                child: Text(
                  e.port.isNotEmpty ? e.port : '-',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStatus(List<ConnectDTO> list) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 28),
      child: Column(
        children: [
          const Text(
            'Trạng thái',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...list.map((e) {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: SelectionArea(
                child: Text(
                  e.active == 1 ? 'Hoạt động' : 'Không hoạt động',
                  style: TextStyle(
                      fontSize: 12,
                      color:
                          e.active == 1 ? AppColor.BLUE_TEXT : AppColor.BLACK),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPlatform(List<ConnectDTO> list) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 28),
      child: Column(
        children: [
          const Text(
            'Nền tảng kết nối',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...list.map((e) {
            return Padding(
                padding: const EdgeInsets.only(top: 24),
                child: SelectionArea(
                  child: Text(
                    e.platform.isNotEmpty ? e.platform : '-',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ));
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAction(List<ConnectDTO> list, BuildContext context) {
    return SizedBox(
      width: 220,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            const Text(
              'Action',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...list.map((e) {
              return Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Row(
                  children: [
                    const Text('', style: TextStyle(fontSize: 12)),
                    InkWell(
                      onTap: () {
                        Session.instance.updateConnectDTO(e);

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
                            dto: e,
                            uploadSuccess: () {
                              BlocProvider.of<ListConnectBloc>(context)
                                  .add(ListConnectGetListEvent());
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
                        param['customerSyncId'] = e.id;
                        param['status'] = e.active == 1 ? 0 : 1;
                        BlocProvider.of<ListConnectBloc>(context)
                            .add(ListConnectUpdateStatusEvent(param: param));
                      },
                      child: Text(
                        e.active == 1 ? 'Tắt kết nối' : 'Bật kết nối',
                        style: TextStyle(
                            fontSize: 11,
                            color: e.active == 1
                                ? AppColor.RED_TEXT
                                : AppColor.BLUE_TEXT,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
