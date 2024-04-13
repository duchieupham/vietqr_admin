import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/list_merchant/annual_fee/event/annual_fee_event.dart';
import 'package:vietqr_admin/feature/list_merchant/annual_fee/responsitory/annual_fee_repository.dart';
import 'package:vietqr_admin/feature/list_merchant/annual_fee/state/annual_fee_state.dart';

import '../../../../models/DTO/annual_fee_dto.dart';

class AnnualFeeBloc extends Bloc<AnnualFeeEvent, AnnualFeeState> {
  AnnualFeeBloc() : super(AnnualFeeInitialState()) {
    on<AnnualFeeGetListEvent>(_getListAnnualFee);
  }
}

const AnnualFeeRepository annualFeeRepository = AnnualFeeRepository();

void _getListAnnualFee(AnnualFeeEvent event, Emitter emit) async {
  List<AnnualFeeDTO> result = [];
  try {
    if (event is AnnualFeeGetListEvent) {
      emit(AnnualFeeLoadingState());

      result = await annualFeeRepository.getAnnualFeeList();
      emit(AnnualFeeGetListSuccessState(
          result: result,
          initPage: event.initPage,
          isLoadMore: event.isLoadMore));
    }
  } catch (e) {
    print('Error at get list annual fee- _getListAnnualFee: $e');
    emit(const AnnualFeeGetListSuccessState(result: []));
  }
}
