import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/service_pack/event/service_pack_event.dart';
import 'package:vietqr_admin/feature/service_pack/responsitory/service_pack_repository.dart';
import 'package:vietqr_admin/feature/service_pack/state/service_pack_state.dart';

import '../../../models/DTO/response_message_dto.dart';
import '../../../models/DTO/merchant_fee_dto.dart';
import '../../../models/DTO/service_pack_dto.dart';

class ServicePackBloc extends Bloc<ServicePackEvent, ServicePackState> {
  ServicePackBloc() : super(ServicePackInitialState()) {
    on<ServicePackGetListEvent>(_getListServicePack);
    on<InsertServicePackEvent>(_insertServicePack);
    on<GetListMerchantBankAccountEvent>(_getListMerchantBankAccount);
    on<InsertBankAccountFeeEvent>(_insertBankAccountFee);
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
        emit(
            ServicePackInsertSuccessState(servicePackId: event.param['refId']));
      } else {
        emit(ServicePackInsertFailsState(dto: result));
      }
    }
  } catch (e) {
    print('Error at insert service pack- _insertServicePack: $e');
    emit(ServicePackInsertFailsState(dto: result));
  }
}

void _getListMerchantBankAccount(ServicePackEvent event, Emitter emit) async {
  List<MerchantFee> result = [];
  try {
    if (event is GetListMerchantBankAccountEvent) {
      emit(GetListMerchantBankAccountLoadingState());

      result = await servicePackRepository.getListMerChantBankAccount();
      emit(GetListMerchantBankAccountSuccessState(result: result));
    }
  } catch (e) {
    print('Error at get list service pack- _getListServicePack: $e');
    emit(const ServicePackGetListSuccessState(result: []));
  }
}

void _insertBankAccountFee(ServicePackEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO();
  try {
    if (event is InsertBankAccountFeeEvent) {
      emit(ServicePackLoadingState());

      result = await servicePackRepository.insertBankAccountFee(event.param);

      if (result.status == 'SUCCESS') {
        emit(InsertBankAccountSuccessState());
      } else {
        emit(InsertBankAccountFailsState(dto: result));
      }
    }
  } catch (e) {
    print('Error at insert service pack- _insertServicePack: $e');
    emit(InsertBankAccountFailsState(dto: result));
  }
}
