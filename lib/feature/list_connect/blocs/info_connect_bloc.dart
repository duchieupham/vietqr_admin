import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/list_connect/events/info_connect_event.dart';
import 'package:vietqr_admin/feature/list_connect/repositories/info_connect_repository.dart';
import 'package:vietqr_admin/feature/list_connect/states/info_connect_state.dart';
import 'package:vietqr_admin/models/api_service_dto.dart';
import 'package:vietqr_admin/models/ecomerce_dto.dart';

import '../states/list_connect_state.dart';

class InfoConnectBloc extends Bloc<InfoConnectEvent, InfoConnectState> {
  InfoConnectBloc() : super(InfoConnectInitialState()) {
    on<GetInfoConnectEvent>(_getInfo);
  }
}

const InfoConnectRepository infoConnectRepository = InfoConnectRepository();

void _getInfo(InfoConnectEvent event, Emitter emit) async {
  ApiServiceDTO apiServiceDTO = const ApiServiceDTO();
  EcomerceDTO ecomerceDTO = const EcomerceDTO();
  try {
    if (event is GetInfoConnectEvent) {
      emit(InfoConnectLoadingState());
      if (event.platform == 'API service') {
        apiServiceDTO = await infoConnectRepository.getInfoApiService(event.id);
        emit(InfoApiServiceConnectSuccessfulState(dto: apiServiceDTO));
      } else {
        ecomerceDTO = await infoConnectRepository.getInfoEcomerce(event.id);
        emit(InfoEcomerceDTOConnectSuccessfulState(dto: ecomerceDTO));
      }
    }
  } catch (e) {
    debugPrint('Error at get _getInfo- _getInfo ConnectBloc: $e');
    emit(ListConnectFailedState());
  }
}
