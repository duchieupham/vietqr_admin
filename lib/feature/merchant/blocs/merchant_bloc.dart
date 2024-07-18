import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/commons/constants/configurations/stringify.dart';
import 'package:vietqr_admin/commons/constants/utils/error_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/feature/merchant/events/merchant_event.dart';
import 'package:vietqr_admin/feature/merchant/repositories/merchant_repository.dart';
import 'package:vietqr_admin/feature/merchant/states/merchant_state.dart';

import '../../../models/DTO/bank_account_sync_dto.dart';
import '../../../models/DTO/response_message_dto.dart';
import '../../../models/DTO/service_charge_dto.dart';
import '../../../models/DTO/synthesis_report_dto.dart';
import '../../../models/DTO/transaction_merchant_dto.dart';

class MerchantBloc extends Bloc<MerchantEvent, MerchantState> {
  MerchantBloc() : super(MerchantInitialState()) {
    on<GetMerchantFeeEvent>(_getMerchantFee);
    on<GetListTransactionByUserEvent>(_getListTransactionByUser);
    on<GetListTransactionByMerchantEvent>(_getListTransactionByMerchant);
    on<GetSynthesisReportEvent>(_getListSynthesisReport);
    on<GetListBankSyncEvent>(_getListBankSync);
    on<UpdateNoteMerchantEvent>(_updateNote);
    on<ChangeFlow2Event>(_changeFlow2);
    on<ChangeFlow1Event>(_changeFlow1);
  }
}

const MerchantRepository merchantRepository = MerchantRepository();

void _changeFlow2(MerchantEvent event, Emitter emit) async {
  ResponseMessageDTO dto = const ResponseMessageDTO();
  try {
    if (event is ChangeFlow2Event) {
      emit(ChangeFlow2State());
      dto = await merchantRepository.changeFlow2(event.param);

      if (dto.status == "SUCCESS") {
        emit(ChangeFlow2SuccessfulState());
      } else {
        emit(ChangeFlow2FailedState(dto: dto));
      }
    }
  } catch (e) {
    // print('Error at get _updateData: $e');
    emit(ChangeFlow2FailedState(dto: dto));
  }
}

void _changeFlow1(MerchantEvent event, Emitter emit) async {
  ResponseMessageDTO dto = const ResponseMessageDTO();
  try {
    if (event is ChangeFlow1Event) {
      emit(ChangeFlow1State());
      dto = await merchantRepository.changeFlow1(event.param);

      if (dto.status == "SUCCESS") {
        emit(ChangeFlow1SuccessfulState());
      } else {
        emit(ChangeFlow1FailedState(dto: dto));
      }
    }
  } catch (e) {
    // print('Error at get _updateData: $e');
    emit(ChangeFlow1FailedState(dto: dto));
  }
}

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
      if (event.isLoadMore) {
        emit(MerchantGetSyncBankLoadMoreState());
      } else {
        emit(MerchantGetSyncBankLoadingState());
      }
      list = await merchantRepository.getListBankSync(
          event.customerSyncId, event.offset);
      emit(MerchantGetSyncBankSuccessfulState(
          list: list, isLoadMoreLoading: event.isLoadMore));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(MerchantGetSyncBankFailedState());
  }
}
