import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/new_connect/event/new_connect_event.dart';
import 'package:vietqr_admin/feature/new_connect/respository/new_connect_repository.dart';
import 'package:vietqr_admin/feature/new_connect/state/new_connect_state.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';

class NewConnectBloc extends Bloc<NewConnectEvent, NewConnectState> {
  NewConnectBloc() : super(NewConnectInitialState()) {
    on<GetTokenEvent>(_getToken);
    on<GetPassSystemEvent>(_getPassSystem);
    on<AddCustomerSyncEvent>(_addCustomerSync);
  }
}

const NewConnectRepository newConnectRepository = NewConnectRepository();

void _getToken(NewConnectEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO();
  try {
    if (event is GetTokenEvent) {
      emit(NewConnectLoadingState());
      result = await newConnectRepository.getToken(event.param);
      if (result.status == "SUCCESS") {
        emit(GetTokenSuccessfulState(dto: result));
      } else {
        emit(GetTokenFailedState(dto: result));
      }
    }
  } catch (e) {
    print('Error at new connect- _getToken: $e');
    emit(GetTokenFailedState(dto: result));
  }
}

void _getPassSystem(NewConnectEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO();
  try {
    if (event is GetPassSystemEvent) {
      result = await newConnectRepository.getPassSystem(event.userName);
      if (result.status == "SUCCESS") {
        emit(GetPassSystemSuccessfulState(dto: result));
      } else {
        emit(GetPassSystemFailedState(dto: result));
      }
    }
  } catch (e) {
    print('Error at new connect- _getPassSystem: $e');
    emit(GetPassSystemFailedState(dto: result));
  }
}

void _addCustomerSync(NewConnectEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO();
  try {
    if (event is AddCustomerSyncEvent) {
      emit(AddCustomerLoadingState());
      result = await newConnectRepository.addCustomerSync(event.param);
      if (result.status == "SUCCESS") {
        emit(AddCustomerSuccessfulState(dto: result));
      } else {
        emit(AddCustomerFailedState(dto: result));
      }
    }
  } catch (e) {
    print('Error at new connect- _getPassSystem: $e');
    emit(AddCustomerFailedState(dto: result));
  }
}
