import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/list_connect/provider/list_connect_provider.dart';
import 'package:vietqr_admin/feature/list_connect/states/list_connect_state.dart';
import 'package:vietqr_admin/feature/list_connect/widget/infomation_popup.dart';
import 'package:vietqr_admin/feature/list_connect/widget/update_merchant_info_popup.dart';
import 'package:vietqr_admin/models/connect.dto.dart';

import 'blocs/list_connect_bloc.dart';
import 'events/list_connect_event.dart';

class ListConnectScreen extends StatelessWidget {
  ListConnectScreen({Key? key}) : super(key: key);
  List<ConnectDTO> result = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<ListConnectBloc>(
      create: (BuildContext context) =>
          ListConnectBloc()..add(ListConnectGetListEvent()),
      child: SizedBox(
        height: height - 60,
        width: width,
        child: Column(
          children: [
            ChangeNotifierProvider(
              create: (context) => ListConnectProvider(),
              child: Consumer<ListConnectProvider>(
                  builder: (context, provider, child) {
                return Container(
                  color: DefaultTheme.BLUE_TEXT.withOpacity(0.2),
                  height: 68,
                  width: width,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      const Text('Môi trường'),
                      const SizedBox(
                        width: 24,
                      ),
                      InkWell(
                        onTap: () {
                          EnvConfig.instance.updateEnv(EnvType.DEV);
                          BlocProvider.of<ListConnectBloc>(context)
                              .add(ListConnectGetListEvent());
                          provider.updateENV(0);
                        },
                        child: Container(
                          height: 35,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: provider.environment == 0
                                ? DefaultTheme.BLUE_TEXT.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Test',
                            style: TextStyle(
                                fontSize: 12,
                                color: provider.environment == 0
                                    ? DefaultTheme.BLUE_TEXT
                                    : DefaultTheme.BLACK),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          EnvConfig.instance.updateEnv(EnvType.GOLIVE);
                          BlocProvider.of<ListConnectBloc>(context)
                              .add(ListConnectGetListEvent());
                          provider.updateENV(1);
                        },
                        child: Container(
                          height: 35,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: provider.environment == 1
                                ? DefaultTheme.BLUE_TEXT.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'GoLive',
                            style: TextStyle(
                                fontSize: 12,
                                color: provider.environment == 1
                                    ? DefaultTheme.BLUE_TEXT
                                    : DefaultTheme.BLACK),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            Expanded(
              child: BlocConsumer<ListConnectBloc, ListConnectState>(
                  listener: (context, state) {
                if (state is ListConnectSuccessfulState) {
                  result = state.dto;
                }
              }, builder: (context, state) {
                if (state is ListConnectLoadingState) {
                  return const Center(child: Text('Đang tải...'));
                }
                if (result.isEmpty) {
                  return const Center(child: Text('Danh sách trống'));
                }
                return LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth < 900) {
                    return ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildStt(result),
                        SizedBox(width: 280, child: _buildURL(result)),
                        _buildIp(result),
                        _buildPort(result),
                        _buildStatus(result),
                        _buildPlatform(result),
                        _buildAction(result, context),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      _buildStt(result),
                      Expanded(child: _buildURL(result)),
                      _buildIp(result),
                      _buildPort(result),
                      _buildStatus(result),
                      _buildPlatform(result),
                      _buildAction(result, context),
                    ],
                  );
                });
              }),
            ),
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
                  e.url,
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
                    e.ip,
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
                  e.port,
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
                      color: e.active == 1
                          ? DefaultTheme.BLUE_TEXT
                          : DefaultTheme.BLACK),
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
                    e.platform,
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
                      InkWell(
                          onTap: () {
                            DialogWidget.instance.openPopup(
                                child: InformationPopup(
                              dto: e,
                            ));
                          },
                          child: const Text(
                            'Thông tin thêm',
                            style: TextStyle(
                                fontSize: 11,
                                color: DefaultTheme.BLUE_TEXT,
                                decoration: TextDecoration.underline),
                          )),
                      const SizedBox(
                        width: 16,
                      ),
                      InkWell(
                          onTap: () {
                            DialogWidget.instance.openPopupCenter(
                                child: UpdateMerchantPopup(
                              dto: e,
                              uploadSuccess: () {
                                BlocProvider.of<ListConnectBloc>(context)
                                    .add(ListConnectGetListEvent());
                              },
                            ));
                          },
                          child: const Text(
                            'Chỉnh sửa',
                            style: TextStyle(
                                fontSize: 11,
                                color: DefaultTheme.BLUE_TEXT,
                                decoration: TextDecoration.underline),
                          )),
                      const SizedBox(
                        width: 16,
                      ),
                      InkWell(
                          onTap: () {
                            Map<String, dynamic> param = {};
                            param['customerSyncId'] = e.id;
                            param['status'] = e.active == 1 ? 0 : 1;
                            BlocProvider.of<ListConnectBloc>(context).add(
                                ListConnectUpdateStatusEvent(param: param));
                          },
                          child: Text(
                            e.active == 1 ? 'Tắt kết nối' : 'Bật kết nối',
                            style: TextStyle(
                                fontSize: 11,
                                color: e.active == 1
                                    ? DefaultTheme.RED_TEXT
                                    : DefaultTheme.BLUE_TEXT,
                                decoration: TextDecoration.underline),
                          ))
                    ],
                  ));
            }).toList(),
          ],
        ),
      ),
    );
  }
}
