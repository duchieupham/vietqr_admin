import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/service_pack/event/service_pack_event.dart';
import 'package:vietqr_admin/feature/service_pack/responsitory/service_pack_repository.dart';
import 'package:vietqr_admin/feature/service_pack/state/service_pack_state.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';
import 'package:vietqr_admin/models/service_pack_dto.dart';

class ServicePackBloc extends Bloc<ServicePackEvent, ServicePackState> {
  ServicePackBloc() : super(ServicePackInitialState()) {
    on<ServicePackGetListEvent>(_getListServicePack);
    on<InsertServicePackEvent>(_insertServicePack);
  }
}

const ServicePackRepository servicePackRepository = ServicePackRepository();

void _getListServicePack(ServicePackEvent event, Emitter emit) async {
  List<ServicePackDTO> result = [];
  try {
    if (event is ServicePackGetListEvent) {
      emit(ServicePackLoadingLoadMoreState());

      result = await servicePackRepository.getServicePackList();
      emit(ServicePackGetListSuccessState(
          result: result,
          initPage: event.initPage,
          isLoadMore: event.isLoadMore));
    }
  } catch (e) {
    print('Error at get list service pack- _getListServicePack: $e');
    emit(const ServicePackGetListSuccessState(result: []));
  }
}

void _insertServicePack(ServicePackEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO();
  try {
    if (event is InsertServicePackEvent) {
      emit(ServicePackLoadingState());

      result = await servicePackRepository.insertServicePack(event.param);

      if (result.status == 'SUCCESS') {
        emit(ServicePackInsertSuccessState());
      } else {
        emit(ServicePackInsertFailsState(dto: result));
      }
    }
  } catch (e) {
    print('Error at insert service pack- _insertServicePack: $e');
    emit(ServicePackInsertFailsState(dto: result));
  }
}
