import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/connect_service/active_fee/event/active_fee_event.dart';
import 'package:vietqr_admin/feature/connect_service/active_fee/responsitory/active_fee_repository.dart';
import 'package:vietqr_admin/feature/connect_service/active_fee/state/active_fee_state.dart';
import 'package:vietqr_admin/models/active_fee_dto.dart';

class ActiveFeeBloc extends Bloc<ActiveFeeEvent, ActiveFeeState> {
  ActiveFeeBloc() : super(ActiveFeeInitialState()) {
    on<ActiveFeeGetListEvent>(_getListActiveFee);
  }
}

const ActiveFeeRepository activeFeeRepository = ActiveFeeRepository();

void _getListActiveFee(ActiveFeeEvent event, Emitter emit) async {
  List<ActiveFeeDTO> result = [];
  try {
    if (event is ActiveFeeGetListEvent) {
      if (event.initPage) {
        emit(ActiveFeeLoadingInitState());
      } else {
        emit(ActiveFeeLoadingState());
      }

      result = await activeFeeRepository.getListActiveFee(event.month);
      emit(ActiveFeeGetListSuccessState(
          result: result,
          initPage: event.initPage,
          isLoadMore: event.isLoadMore));
    }
  } catch (e) {
    print('Error at get list active fee- _getListActiveFee: $e');
    emit(const ActiveFeeGetListSuccessState(result: []));
  }
}
