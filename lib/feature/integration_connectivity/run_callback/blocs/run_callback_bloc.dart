import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/commons/constants/configurations/stringify.dart';
import 'package:vietqr_admin/commons/constants/enum/check_type.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/service/shared_references/account_helper.dart';

import '../../../../models/DTO/api_service_dto.dart';
import '../../../../models/DTO/bank_account_dto.dart';
import '../../../../models/DTO/callback_dto.dart';
import '../events/run_callback_event.dart';
import '../respositories/callback_repository.dart';
import '../states/run_callback_state.dart';

class RunCallbackBloc extends Bloc<CallbackEvent, RunCallbackState> {
  RunCallbackBloc()
      : super(const RunCallbackState(
            listTrans: [], listCustomers: [], listBankAccount: [])) {
    on<GetTransEvent>(_getTrans);
    on<GetTransLoadMoreEvent>(_getTransLoadMore);
    on<GetListCustomerEvent>(_getListCustomer);
    on<GetListBankEvent>(_getListBank);
    on<GetInfoConnectEvent>(_getInfo);
    on<GetTokenEvent>(_loadFreeToken);
    on<RunCallbackEvent>(_runCallBack);
  }

  final repository = CallBackRepository();

  void _getTrans(CallbackEvent event, Emitter emit) async {
    try {
      if (event is GetTransEvent) {
        if (event.bankId?.isEmpty ?? true) {
          emit(
            state.copyWith(
              listTrans: [],
              status: BlocStatus.UNLOADING,
              request: CallBackType.TRANS,
              isLoadMore: false,
              offset: 0,
            ),
          );
        } else {
          emit(
            state.copyWith(
                status: event.isLoading ? BlocStatus.LOADING : BlocStatus.NONE,
                request: CallBackType.NONE,
                msg: null),
          );

          bool isLoadMore = false;

          final result = await repository.getTrans(
              event.bankId ?? '', event.customerId ?? '', 0);

          if (result.isEmpty || result.length < 20) {
            isLoadMore = true;
          }
          emit(
            state.copyWith(
              listTrans: result,
              status: BlocStatus.UNLOADING,
              request: CallBackType.TRANS,
              isLoadMore: isLoadMore,
              offset: 0,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        status: BlocStatus.NONE,
        request: CallBackType.ERROR,
      ));
    }
  }

  void _getTransLoadMore(CallbackEvent event, Emitter emit) async {
    try {
      if (event is GetTransLoadMoreEvent) {
        emit(
          state.copyWith(
              status: event.isLoading ? BlocStatus.LOADING : BlocStatus.NONE,
              request: CallBackType.NONE,
              msg: null),
        );

        bool isLoadMore = false;
        int offset = state.offset;
        offset += 1;

        List<CallBackDTO> data = state.listTrans;

        final result = await repository.getTrans(
            event.bankId ?? '', event.customerId ?? '', offset * 20);

        if (result.isEmpty || result.length < 20) {
          isLoadMore = true;
        }
        data.addAll(result);

        emit(
          state.copyWith(
            listTrans: data,
            status: event.isLoading ? BlocStatus.UNLOADING : BlocStatus.NONE,
            request: CallBackType.TRANS,
            isLoadMore: isLoadMore,
            offset: 0,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        status: BlocStatus.NONE,
        request: CallBackType.ERROR,
      ));
    }
  }

  void _getListCustomer(CallbackEvent event, Emitter emit) async {
    try {
      if (event is GetListCustomerEvent) {
        emit(
          state.copyWith(status: BlocStatus.NONE, request: CallBackType.NONE),
        );
        final result = await repository.getListCustomer();
        emit(
          state.copyWith(
              listCustomers: result,
              status: BlocStatus.NONE,
              request: CallBackType.CUSTOMERS),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        status: BlocStatus.NONE,
        request: CallBackType.ERROR,
      ));
    }
  }

  void _getListBank(CallbackEvent event, Emitter emit) async {
    List<BankAccountDTO> result = [];
    try {
      if (event is GetListBankEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: CallBackType.NONE));
        result = await repository.getListBank(event.customerId);
        emit(
          state.copyWith(
              listBankAccount: result,
              status: BlocStatus.NONE,
              request: CallBackType.BANKS),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        status: BlocStatus.NONE,
        request: CallBackType.ERROR,
      ));
    }
  }

  void _getInfo(CallbackEvent event, Emitter emit) async {
    ApiServiceDTO apiServiceDTO = const ApiServiceDTO();
    await AccountHelper.instance.setTokenFree('');
    try {
      if (event is GetInfoConnectEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: CallBackType.NONE));
        if (event.platform == 'API service') {
          apiServiceDTO = await repository.getInfoApiService(event.id);
          emit(
            state.copyWith(
              apiServiceDTO: apiServiceDTO,
              status: BlocStatus.NONE,
              request: CallBackType.INFO_CONNECT,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error at get _getInfo- _getInfo ConnectBloc: $e');
      emit(state.copyWith(
        status: BlocStatus.NONE,
        request: CallBackType.ERROR,
      ));
    }
  }

  void _loadFreeToken(CallbackEvent event, Emitter emit) async {
    if (event is GetTokenEvent) {
      emit(state.copyWith(status: BlocStatus.NONE, request: CallBackType.NONE));
      final result =
          await repository.getToken(event.systemUsername, event.systemPassword);

      if (result) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: CallBackType.FREE_TOKEN));
      } else {
        emit(state.copyWith(
            status: BlocStatus.UNLOADING, request: CallBackType.ERROR));
      }
    }
  }

  void _runCallBack(CallbackEvent event, Emitter emit) async {
    if (event is RunCallbackEvent) {
      emit(state.copyWith(status: BlocStatus.NONE, request: CallBackType.NONE));
      final result = await repository.runCallback(event.body);

      await AccountHelper.instance.setTokenFree('');

      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(state.copyWith(
            status: BlocStatus.UNLOADING,
            request: CallBackType.RUN_CALLBACK,
            runCallBackSuccess: 1,
            msgRunCallBack: result.status));
      } else {
        emit(
          state.copyWith(
              status: BlocStatus.UNLOADING,
              request: CallBackType.RUN_ERROR,
              runCallBackSuccess: 0,
              msg: result.message),
        );
      }
    }
  }
}
