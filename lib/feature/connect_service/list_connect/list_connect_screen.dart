import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/models/connect.dto.dart';

import 'blocs/list_connect_bloc.dart';
import 'events/list_connect_event.dart';
import 'states/list_connect_state.dart';
import 'widget/infomation_popup.dart';
import 'widget/update_merchant_info_popup.dart';

class ListConnectScreen extends StatelessWidget {
  const ListConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListConnectBloc>(
        create: (_) => ListConnectBloc()..add(ListConnectGetListEvent()),
        child: const _ListConnectScreen());
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
      child: SingleChildScrollView(
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
                  return ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
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
                        DialogWidget.instance
                            .openPopup(child: InformationPopup(dto: e));
                      },
                      child: const Text(
                        'Thông tin thêm',
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
