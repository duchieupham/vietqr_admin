import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/commons/constants/configurations/stringify.dart';
import 'package:vietqr_admin/feature/bank_account/request_register_bank_account/event/service_pack_event.dart';
import 'package:vietqr_admin/feature/bank_account/request_register_bank_account/repository/rq_bank_account_repository.dart';
import 'package:vietqr_admin/feature/bank_account/request_register_bank_account/state/rq_bank_account_state.dart';
import 'package:vietqr_admin/feature/service_pack/state/service_pack_state.dart';
import 'package:vietqr_admin/models/account_bank_rq_dto.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';

class RQBankAccountBloc extends Bloc<RQBankAccountEvent, RQBankAccountState> {
  RQBankAccountBloc() : super(RQBankAccountInitialState()) {
    on<RQBankAccountListEvent>(_getListRqBankAccount);
    on<RemoveRQBankAccountEvent>(_removeRqBankAccount);
  }
}

const RQBankAccountRepository rqBankAccountRepository =
    RQBankAccountRepository();

void _getListRqBankAccount(RQBankAccountEvent event, Emitter emit) async {
  List<AccountBankRQDTO> result = [];
  try {
    if (event is RQBankAccountListEvent) {
      if (event.initPage) {
        emit(RQBankAccountLoadingInitState());
      } else if (event.isLoadMore) {
        emit(RQBankAccountLoadingLoadMoreState());
      }
      result = await rqBankAccountRepository.getListRqBankAccount(event.offset);
      emit(RQBankAccountGetListSuccessState(
          result: result,
          initPage: event.initPage,
          isLoadMore: event.isLoadMore));
    }
  } catch (e) {
    print('Error at - _getListRqBankAccount: $e');
    emit(const ServicePackGetListSuccessState(result: []));
  }
}

void _removeRqBankAccount(RQBankAccountEvent event, Emitter emit) async {
  ResponseMessageDTO dto = const ResponseMessageDTO();
  try {
    if (event is RemoveRQBankAccountEvent) {
      emit(RQBankAccountLoadingState());

      dto = await rqBankAccountRepository.removeRqBankAccount(event.id);
      if (dto.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(RemoveBankAccountSuccessState(
          dto: dto,
        ));
      } else {
        emit(RemoveBankAccountFailsState(
          dto: dto,
        ));
      }
    }
  } catch (e) {
    print('Error at - _removeRqBankAccount: $e');
    dto = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    emit(RemoveBankAccountFailsState(
      dto: dto,
    ));
  }
}
