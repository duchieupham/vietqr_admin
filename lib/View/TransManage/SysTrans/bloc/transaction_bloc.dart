import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/View/TransManage/SysTrans/event/transaction_event.dart';
import 'package:vietqr_admin/View/TransManage/SysTrans/respository/transaction_repository.dart';
import 'package:vietqr_admin/View/TransManage/SysTrans/state/transaction_state.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';

import '../../../../models/DTO/transaction_detail_dto.dart';
import '../../../../models/DTO/transaction_dto.dart';
import '../../../../models/DTO/transaction_log_dto.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitialState()) {
    on<TransactionGetListEvent>(_getListTransaction);
    on<TransactionGetDetailEvent>(_getDetailTransaction);
    on<TransactionFilterListEvent>(_filterListTransaction);
  }
}

final TransactionRepository transactionRepository = TransactionRepository();

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
    // ignore: avoid_print
    print('Error at get list transaction- _getListTransaction: $e');
    emit(const TransactionGetListSuccessState(result: []));
  }
}

void _filterListTransaction(TransactionEvent event, Emitter emit) async {
  try {
    emit(TransactionGetListLoadingState());
    if (event is TransactionFilterListEvent) {
      final result = await transactionRepository.filterListTransaction(
          page: event.page,
          size: event.size,
          type: event.type,
          value: event.value,
          from: event.from,
          to: event.to);
      if (result == null) {
        emit(
          TransactionFilterListSuccessState(
            result: TransactionDTO(items: []),
            meta: MetaDataDTO(page: 1, size: 20, total: 0, totalPage: 0),
          ),
        );
      } else {
        if (result is TransactionDTO) {
          emit(
            TransactionFilterListSuccessState(
              result: result,
              meta: transactionRepository.metaDataDTO,
            ),
          );
        } else {
          emit(
            TransactionFilterListSuccessState(
              result: TransactionDTO(items: []),
              meta: MetaDataDTO(page: 1, size: 20, total: 0, totalPage: 0),
            ),
          );
        }
      }
    }
  } catch (e) {
    // ignore: avoid_print
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
    // ignore: avoid_print
    print('Error at get detail transaction- _getDetailTransaction: $e');
    emit(TransactionGetDetailSuccessState(result: result, listLog: listLog));
  }
}
