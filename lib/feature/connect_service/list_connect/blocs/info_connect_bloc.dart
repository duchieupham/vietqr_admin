import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/connect_service/list_connect/events/info_connect_event.dart';
import 'package:vietqr_admin/feature/connect_service/list_connect/repositories/info_connect_repository.dart';
import 'package:vietqr_admin/feature/connect_service/list_connect/states/info_connect_state.dart';
import 'package:vietqr_admin/models/api_service_dto.dart';
import 'package:vietqr_admin/models/bank_account_dto.dart';
import 'package:vietqr_admin/models/ecomerce_dto.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';


class InfoConnectBloc extends Bloc<InfoConnectEvent, InfoConnectState> {
  InfoConnectBloc() : super(InfoConnectInitialState()) {
    on<GetInfoConnectEvent>(_getInfo);
    on<GetListBankEvent>(_getListBank);
    on<AddBankConnectEvent>(_addBankConnect);
    on<RemoveBankConnectEvent>(_removeBankConnect);
    on<UpdateMerchantEvent>(_updateMerchantConnect);
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
    emit(const InfoConnectFailedState(dto: ResponseMessageDTO()));
  }
}

void _getListBank(InfoConnectEvent event, Emitter emit) async {
  List<BankAccountDTO> result = [];
  try {
    if (event is GetListBankEvent) {
      emit(InfoConnectLoadingState());
      result = await infoConnectRepository.getListBank(event.id);
      emit(GetListBankSuccessfulState(list: result));
    }
  } catch (e) {
    debugPrint('Error at _getListBank- _getListBank ConnectBloc: $e');
    emit(GetListFailedState());
  }
}

void _addBankConnect(InfoConnectEvent event, Emitter emit) async {
  List<BankAccountDTO> result = [];
  try {
    if (event is AddBankConnectEvent) {
      await infoConnectRepository.addBankConnect(event.param);
      emit(AddBankConnectSuccessState());
      result = await infoConnectRepository
          .getListBank(event.param['customerSyncId']);
      emit(GetListBankSuccessfulState(list: result));
    }
  } catch (e) {
    debugPrint('Error at _getListBank- _getListBank ConnectBloc: $e');
    emit(GetListFailedState());
  }
}

void _removeBankConnect(InfoConnectEvent event, Emitter emit) async {
  List<BankAccountDTO> result = [];
  try {
    if (event is RemoveBankConnectEvent) {
      emit(RemoveBankConnectLoadingState());

      await infoConnectRepository.removeBankConnect(event.param);
      emit(RemoveBankConnectSuccessState());
      result = await infoConnectRepository
          .getListBank(event.param['customerSyncId']);
      emit(GetListBankSuccessfulState(list: result));
    }
  } catch (e) {
    debugPrint('Error at _getListBank- _getListBank ConnectBloc: $e');
    emit(GetListFailedState());
  }
}

void _updateMerchantConnect(InfoConnectEvent event, Emitter emit) async {
  ResponseMessageDTO dto = const ResponseMessageDTO();
  try {
    if (event is UpdateMerchantEvent) {
      emit(UpdateMerchantLoadingState());

      dto = await infoConnectRepository.updateMerchantConnect(event.param);
      if (dto.status == "SUCCESS") {
        emit(UpdateMerchantConnectSuccessState());
      } else {
        emit(UpdateFailedState(dto: dto));
      }
    }
  } catch (e) {
    debugPrint('Error at _getListBank- _getListBank ConnectBloc: $e');
    emit(UpdateFailedState(dto: dto));
  }
}