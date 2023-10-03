import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/connect_service/active_fee/event/active_fee_event.dart';
import 'package:vietqr_admin/feature/connect_service/active_fee/responsitory/active_fee_repository.dart';
import 'package:vietqr_admin/feature/connect_service/active_fee/state/active_fee_state.dart';
import 'package:vietqr_admin/models/active_fee_dto.dart';
import 'package:vietqr_admin/models/active_fee_total_static.dart';

class ActiveFeeBloc extends Bloc<ActiveFeeEvent, ActiveFeeState> {
  ActiveFeeBloc() : super(ActiveFeeInitialState()) {
    on<ActiveFeeGetListEvent>(_getListActiveFee);
    on<ActiveFeeGetTotalEvent>(_getTotalActiveFee);
  }
}

const ActiveFeeRepository activeFeeRepository = ActiveFeeRepository();

void _getListActiveFee(ActiveFeeEvent event, Emitter emit) async {
  List<ActiveFeeDTO> result = [];
  ActiveFeeStaticDto activeFeeStaticDto = const ActiveFeeStaticDto();
  try {
    if (event is ActiveFeeGetListEvent) {
      if (event.initPage) {
        emit(ActiveFeeLoadingInitState());
      } else {
        emit(ActiveFeeLoadingState());
      }

      result = await activeFeeRepository.getListActiveFee(event.month);
      if (event.initPage) {
        activeFeeStaticDto =
            await activeFeeRepository.getTotalStatic(event.month);
      }
      emit(ActiveFeeGetListSuccessState(
          result: result,
          initPage: event.initPage,
          isLoadMore: event.isLoadMore,
          activeFeeStaticDto: activeFeeStaticDto));
    }
  } catch (e) {
    print('Error at get list active fee- _getListActiveFee: $e');
    emit(const ActiveFeeGetListSuccessState(
        result: [], activeFeeStaticDto: ActiveFeeStaticDto()));
  }
}

void _getTotalActiveFee(ActiveFeeEvent event, Emitter emit) async {
  ActiveFeeStaticDto activeFeeStaticDto = const ActiveFeeStaticDto();
  try {
    if (event is ActiveFeeGetTotalEvent) {
      activeFeeStaticDto =
          await activeFeeRepository.getTotalStatic(event.month);
      emit(ActiveFeeGetTotalSuccessState(
        activeFeeStaticDto: activeFeeStaticDto,
      ));
    }
  } catch (e) {
    print('Error at get list active fee- _getTotalActiveFee: $e');
    emit(const ActiveFeeGetTotalSuccessState(
        activeFeeStaticDto: ActiveFeeStaticDto()));
  }
}
