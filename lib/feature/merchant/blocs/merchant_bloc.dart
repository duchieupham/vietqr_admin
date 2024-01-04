import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/commons/constants/configurations/stringify.dart';
import 'package:vietqr_admin/commons/constants/utils/error_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/feature/merchant/events/merchant_event.dart';
import 'package:vietqr_admin/feature/merchant/repositories/merchant_repository.dart';
import 'package:vietqr_admin/feature/merchant/states/merchant_state.dart';
import 'package:vietqr_admin/models/bank_account_sync_dto.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';
import 'package:vietqr_admin/models/service_charge_dto.dart';
import 'package:vietqr_admin/models/synthesis_report_dto.dart';
import 'package:vietqr_admin/models/transaction_merchant_dto.dart';

class MerchantBloc extends Bloc<MerchantEvent, MerchantState> {
  MerchantBloc() : super(MerchantInitialState()) {
    on<GetMerchantFeeEvent>(_getMerchantFee);
    on<GetListTransactionByUserEvent>(_getListTransactionByUser);
    on<GetListTransactionByMerchantEvent>(_getListTransactionByMerchant);
    on<GetSynthesisReportEvent>(_getListSynthesisReport);
    on<GetListBankSyncEvent>(_getListBankSync);
    on<UpdateNoteMerchantEvent>(_updateNote);
  }
}

const MerchantRepository merchantRepository = MerchantRepository();

void _updateNote(MerchantEvent event, Emitter emit) async {
  ResponseMessageDTO result;
  try {
    if (event is UpdateNoteMerchantEvent) {
      result = await merchantRepository.updateNote(event.param);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(UpdateNoteState());
      } else {
        String msg = ErrorUtils.instance.getErrorMessage(result.message);
        emit(UpdateNoteMerchantFailedState(msg));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO responseMessageDTO =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    String msg =
        ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
    emit(UpdateNoteMerchantFailedState(msg));
  }
}

void _getMerchantFee(MerchantEvent event, Emitter emit) async {
  List<ServiceChargeDTO> list = [];
  try {
    if (event is GetMerchantFeeEvent) {
      if (event.isLoadingPage) {
        emit(MerchantLoadingActiveFeeState());
      } else {
        emit(MerchantLoadingState());
      }
      list = await merchantRepository.getMerchantFee(
          event.customerSyncId, event.year, event.status);
      emit(MerchantGetMerchantFeeSuccessfulState(
          list: list, isLoadingPage: event.isLoadingPage));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(MerchantGetMerchantFeeSuccessfulState(list: list));
  }
}

void _getListTransactionByUser(MerchantEvent event, Emitter emit) async {
  List<TransactionMerchantDTO> list = [];
  try {
    if (event is GetListTransactionByUserEvent) {
      if (event.isLoadingPage) {
        emit(MerchantLoadingInitState());
      } else {
        emit(MerchantLoadingListState());
      }

      list = await merchantRepository.getListTransactionByUser(event.param);
      emit(MerchantGetListByUserSuccessfulState(
          list: list, isLoadingPage: event.isLoadingPage));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(MerchantGetListByUserSuccessfulState(list: list));
  }
}

void _getListTransactionByMerchant(MerchantEvent event, Emitter emit) async {
  List<TransactionMerchantDTO> list = [];
  try {
    if (event is GetListTransactionByMerchantEvent) {
      if (event.isLoadingPage) {
        emit(MerchantLoadingInitState());
      } else if (event.isLoadMore) {
        emit(MerchantLoadMoreListState());
      } else {
        emit(MerchantLoadingListState());
      }
      list = await merchantRepository.getListTransactionByMerchant(event.param);
      emit(MerchantGetListByMerchantSuccessfulState(
          list: list,
          isLoadingPage: event.isLoadingPage,
          isLoadMore: event.isLoadMore));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(MerchantGetListByMerchantSuccessfulState(list: list));
  }
}

void _getListSynthesisReport(MerchantEvent event, Emitter emit) async {
  List<SynthesisReportDTO> list = [];
  String id = '';
  try {
    if (event is GetSynthesisReportEvent) {
      if (event.isLoadingPage) {
        emit(MerchantLoadingInitState());
      } else {
        emit(MerchantLoadingListState());
      }

      if (event.type == 0 || event.type == 1) {
        id = event.customerSyncId;
      } else {
        id = event.bankId;
      }
      list = await merchantRepository.getListSynthesisReport(
          event.type, event.time, id);
      emit(MerchantGetSynthesisReportSuccessfulState(
          list: list, isLoadingPage: event.isLoadingPage));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(MerchantGetSynthesisReportSuccessfulState(list: list));
  }
}

void _getListBankSync(MerchantEvent event, Emitter emit) async {
  List<BankAccountSync> list = [];
  try {
    if (event is GetListBankSyncEvent) {
      emit(MerchantGetSyncBankLoadingState());
      list = await merchantRepository.getListBankSync(event.customerSyncId);
      emit(MerchantGetSyncBankSuccessfulState(list: list));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(MerchantGetSyncBankFailedState());
  }
}
