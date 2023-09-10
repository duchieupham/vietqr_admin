import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/feature/list_connect/blocs/info_connect_bloc.dart';
import 'package:vietqr_admin/feature/list_connect/states/info_connect_state.dart';
import 'package:vietqr_admin/feature/list_connect/widget/api_service_info.dart';
import 'package:vietqr_admin/models/connect.dto.dart';

import '../events/info_connect_event.dart';

class InformationPopup extends StatelessWidget {
  final ConnectDTO dto;
  const InformationPopup({Key? key, required this.dto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InfoConnectBloc>(
      create: (BuildContext context) => InfoConnectBloc()
        ..add(GetInfoConnectEvent(id: dto.id, platform: dto.platform)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _buildTitle(context),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(child: _buildInfo()),
                  Expanded(child: _buildListCard()),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return BlocConsumer<InfoConnectBloc, InfoConnectState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is InfoApiServiceConnectSuccessfulState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin kết nối của khách hàng',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ApiServiceInfo(
                    dto: state.dto,
                  ),
                ),
              ],
            );
          }

          return Text('body');
        });
  }

  Widget _buildListCard() {
    return Text('list card');
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Thông tin khách hàng',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: DefaultTheme.BANK_CARD_COLOR_3.withOpacity(0.15),
          ),
          child: Text(
            dto.platform,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: dto.active == 1
                ? DefaultTheme.BLUE_TEXT
                : DefaultTheme.RED_TEXT,
          ),
          child: Text(
            dto.active == 1 ? 'Hoạt động' : 'Không hoạt đông',
            style: const TextStyle(color: DefaultTheme.WHITE, fontSize: 12),
          ),
        ),
        const Spacer(),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              size: 24,
            ))
      ],
    );
  }
}
