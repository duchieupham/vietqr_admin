import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/DTO/generate_username_pass_dto.dart';
import '../../../../models/DTO/response_message_dto.dart';
import '../event/new_connect_event.dart';
import '../respository/new_connect_repository.dart';
import '../state/new_connect_state.dart';

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
  GenerateUserNamePassDto result = const GenerateUserNamePassDto();
  try {
    if (event is GetPassSystemEvent) {
      result = await newConnectRepository.getPassSystem(event.param);
      emit(GetPassSystemSuccessfulState(dto: result));
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
