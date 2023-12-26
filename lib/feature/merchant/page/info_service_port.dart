import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/blocs/info_connect_bloc.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/events/info_connect_event.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/states/info_connect_state.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/widget/api_service_info.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/widget/ecomerce_info.dart';
import 'package:vietqr_admin/models/api_service_dto.dart';
import 'package:vietqr_admin/models/bank_account_dto.dart';
import 'package:vietqr_admin/models/statistic_dto.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

class InfoServicePort extends StatefulWidget {
  const InfoServicePort({Key? key}) : super(key: key);

  @override
  State<InfoServicePort> createState() => _InformationPopupState();
}

class _InformationPopupState extends State<InfoServicePort> {
  ApiServiceDTO apiServiceDTO = const ApiServiceDTO();
  late InfoConnectBloc infoConnectBloc;
  List<BankAccountDTO> result = [];
  StatisticDTO statisticDTO = const StatisticDTO();

  @override
  void initState() {
    infoConnectBloc = InfoConnectBloc()
      ..add(GetStatisticEvent(param: {
        'type': 9,
        'customerSyncId': Session.instance.connectDTO.id,
        'month': 0,
      }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: LayoutBuilder(builder: (context, constraints) {
        print(constraints.maxWidth);
        if (constraints.maxWidth < 1000) {
          return SizedBox(
              width: constraints.maxWidth * 0.8, child: _buildInfo());
        }
        return Center(
          child: SizedBox(width: 800, child: _buildInfo()),
        );
      }),
    );
  }

  Widget _buildInfo() {
    return BlocProvider<InfoConnectBloc>(
      create: (BuildContext context) => InfoConnectBloc()
        ..add(GetInfoConnectEvent(
            id: Session.instance.connectDTO.id,
            platform: Session.instance.connectDTO.platform)),
      child: BlocConsumer<InfoConnectBloc, InfoConnectState>(
          listener: (context, state) {
        if (state is InfoApiServiceConnectSuccessfulState) {
          apiServiceDTO = state.dto;
        }
      }, builder: (context, state) {
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
        if (state is InfoEcomerceDTOConnectSuccessfulState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thông tin kết nối của khách hàng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: EcomerceInfo(
                  dto: state.dto,
                ),
              ),
            ],
          );
        }

        return const Text('Không có thông tin');
      }),
    );
  }
}
