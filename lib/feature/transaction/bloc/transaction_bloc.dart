import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/transaction/event/transaction_event.dart';
import 'package:vietqr_admin/feature/transaction/respository/transaction_repository.dart';
import 'package:vietqr_admin/feature/transaction/state/transaction_state.dart';

import '../../../models/DTO/transaction_detail_dto.dart';
import '../../../models/DTO/transaction_dto.dart';
import '../../../models/DTO/transaction_log_dto.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitialState()) {
    on<TransactionGetListEvent>(_getListTransaction);
    on<TransactionGetDetailEvent>(_getDetailTransaction);
  }
}

const TransactionRepository transactionRepository = TransactionRepository();

void _getListTransaction(TransactionEvent event, Emitter emit) async {
  List<TransactionDTO> result = [];
  try {
    if (event is TransactionGetListEvent) {
      if (event.isLoadMore) {
        emit(TransactionGetListLoadingLoadMoreState());
      } else {
        if (event.isLoadingPage) {
          emit(TransactionLoadingState());
        } else {
          emit(TransactionGetListLoadingState());
        }
      }

      result = await transactionRepository.getListTransaction(event.param);
      emit(TransactionGetListSuccessState(
          result: result,
          isPopLoading: !event.isLoadingPage,
          isLoadMore: event.isLoadMore));
    }
  } catch (e) {
    print('Error at get list transaction- _getListTransaction: $e');
    emit(const TransactionGetListSuccessState(result: []));
  }
}

void _getDetailTransaction(TransactionEvent event, Emitter emit) async {
  TransactionDetailDTO result = const TransactionDetailDTO();
  List<TransactionLogDTO> listLog = [];
  try {
    if (event is TransactionGetDetailEvent) {
      result = await transactionRepository.getDetailTransaction(event.id);
      listLog = await transactionRepository.getListLogTransaction(event.id);
      emit(TransactionGetDetailSuccessState(result: result, listLog: listLog));
    }
  } catch (e) {
    print('Error at get detail transaction- _getDetailTransaction: $e');
    emit(TransactionGetDetailSuccessState(result: result, listLog: listLog));
  }
}
