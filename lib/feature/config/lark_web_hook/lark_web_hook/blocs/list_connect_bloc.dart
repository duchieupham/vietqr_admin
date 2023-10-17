import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/config/lark_web_hook/lark_web_hook/events/lark_event.dart';
import 'package:vietqr_admin/feature/config/lark_web_hook/lark_web_hook/repositories/lark_repository.dart';
import 'package:vietqr_admin/feature/config/lark_web_hook/lark_web_hook/states/lark_state.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';
import 'package:vietqr_admin/models/web_hook_dto.dart';

class LarkBloc extends Bloc<LarkEvent, LarkState> {
  LarkBloc() : super(LarkInitialState()) {
    on<LarkGetListEvent>(_getList);
    on<LarkUpdateStatusEvent>(_getUpdateStatus);
    on<LarkUpdateDataEvent>(_updateData);
    on<LarkInsertEvent>(_insertData);
    on<RemoveEvent>(_remove);
  }
}

const LarkRepository larkRepository = LarkRepository();

void _getList(LarkEvent event, Emitter emit) async {
  List<WebHookDTO> result = [];
  try {
    if (event is LarkGetListEvent) {
      if (event.isRefresh) {
        emit(LarkLoadingState());
      } else {
        emit(LarkLoadingListState());
      }

      result = await larkRepository.getListWebhook();
      emit(
          LarkGetListSuccessfulState(list: result, isRefresh: event.isRefresh));
    }
  } catch (e) {
    print('Error at get _getList webhook: $e');
    emit(const LarkGetListSuccessfulState(list: []));
  }
}

void _getUpdateStatus(LarkEvent event, Emitter emit) async {
  ResponseMessageDTO dto = const ResponseMessageDTO();
  try {
    if (event is LarkUpdateStatusEvent) {
      emit(LarkLoadingState());
      dto = await larkRepository.updateStatus(event.param);

      if (dto.status == "SUCCESS") {
        emit(UpdateStatusSuccessfulState());
      } else {
        emit(FailedState(dto: dto));
      }
    }
  } catch (e) {
    print('Error at get _getList webhook: $e');
    emit(FailedState(dto: dto));
  }
}

void _updateData(LarkEvent event, Emitter emit) async {
  ResponseMessageDTO dto = const ResponseMessageDTO();
  try {
    if (event is LarkUpdateDataEvent) {
      emit(LarkLoadingState());
      dto = await larkRepository.updateData(event.param);

      if (dto.status == "SUCCESS") {
        emit(UpdateDataSuccessfulState());
      } else {
        emit(FailedState(dto: dto));
      }
    }
  } catch (e) {
    print('Error at get _updateData: $e');
    emit(FailedState(dto: dto));
  }
}

void _insertData(LarkEvent event, Emitter emit) async {
  ResponseMessageDTO dto = const ResponseMessageDTO();
  try {
    if (event is LarkInsertEvent) {
      emit(LarkLoadingState());
      dto = await larkRepository.insertWebhook(event.param);

      if (dto.status == "SUCCESS") {
        emit(InsertSuccessfulState());
      } else {
        emit(FailedState(dto: dto));
      }
    }
  } catch (e) {
    print('Error at get _updateData: $e');
    emit(FailedState(dto: dto));
  }
}

void _remove(LarkEvent event, Emitter emit) async {
  ResponseMessageDTO dto = const ResponseMessageDTO();
  try {
    if (event is RemoveEvent) {
      emit(LarkLoadingState());
      dto = await larkRepository.removeWebhook(event.id);

      if (dto.status == "SUCCESS") {
        emit(RemoveSuccessfulState());
      } else {
        emit(FailedState(dto: dto));
      }
    }
  } catch (e) {
    print('Error at get _updateData: $e');
    emit(FailedState(dto: dto));
  }
}
