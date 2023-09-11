import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/models/connect.dto.dart';

import '../events/list_connect_event.dart';
import '../repositories/list_connect_repository.dart';
import '../states/list_connect_state.dart';

class ListConnectBloc extends Bloc<ListConnectEvent, ListConnectState> {
  ListConnectBloc() : super(ListConnectInitialState()) {
    on<ListConnectGetListEvent>(_getList);
    on<ListConnectUpdateStatusEvent>(_updateStatus);
  }
}

const ListConnectRepository listConnectRepository = ListConnectRepository();

void _getList(ListConnectEvent event, Emitter emit) async {
  List<ConnectDTO> result = [];
  try {
    if (event is ListConnectGetListEvent) {
      emit(ListConnectLoadingState());
      result = await listConnectRepository.getListConnect();
      emit(ListConnectSuccessfulState(dto: result));
    }
  } catch (e) {
    print('Error at get list connect- ListConnectBloc: $e');
    emit(ListConnectFailedState());
  }
}

void _updateStatus(ListConnectEvent event, Emitter emit) async {
  List<ConnectDTO> result = [];
  try {
    if (event is ListConnectUpdateStatusEvent) {
      await listConnectRepository.updateStatus(event.param);
      result = await listConnectRepository.getListConnect();
      emit(ListConnectSuccessfulState(dto: result));
    }
  } catch (e) {
    print('Error at get list connect- ListConnectBloc: $e');
    emit(ListConnectFailedState());
  }
}
