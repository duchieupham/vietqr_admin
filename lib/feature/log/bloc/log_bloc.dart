import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/log/event/log_event.dart';
import 'package:vietqr_admin/feature/log/respository/log_repository.dart';
import 'package:vietqr_admin/feature/log/state/log_state.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  LogBloc() : super(LogInitialState()) {
    on<LogGetListEvent>(_getListLogToken);
  }
}

const LogRepository logRepository = LogRepository();

void _getListLogToken(LogEvent event, Emitter emit) async {
  List<String> result = [];
  try {
    if (event is LogGetListEvent) {
      emit(LogLoadingState());
      result = await logRepository.getLog(event.date);
      emit(GetLogSuccessState(result: result));
    }
  } catch (e) {
    print('Error at get list log- _getListLogToken: $e');
    emit(const GetLogSuccessState(result: []));
  }
}
