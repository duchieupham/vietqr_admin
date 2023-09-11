import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/commons/constants/configurations/stringify.dart';
import 'package:vietqr_admin/commons/constants/enum/check_type.dart';
import 'package:vietqr_admin/commons/constants/utils/error_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/feature/run_callback/events/run_callback_event.dart';
import 'package:vietqr_admin/feature/run_callback/respositories/callback_repository.dart';
import 'package:vietqr_admin/feature/run_callback/states/run_callback_state.dart';
import 'package:vietqr_admin/models/api_service_dto.dart';
import 'package:vietqr_admin/models/bank_account_dto.dart';
import 'package:vietqr_admin/models/ecomerce_dto.dart';
import 'package:vietqr_admin/service/shared_references/account_helper.dart';

class RunCallbackBloc extends Bloc<CallbackEvent, RunCallbackState> {
  RunCallbackBloc()
      : super(const RunCallbackState(
            listTrans: [], listCustomers: [], listBankAccount: [])) {
    on<GetTransEvent>(_getTrans);
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
        emit(
          state.copyWith(
              status: BlocStatus.LOADING, request: CallBackType.NONE),
        );
        final result = await repository.getTrans(
            event.bankId ?? '', event.customerId ?? '', 0);
        emit(
          state.copyWith(
              listTrans: result,
              status: BlocStatus.UNLOADING,
              request: CallBackType.TRANS),
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
    EcomerceDTO ecomerceDTO = const EcomerceDTO();
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
              ecomerceDTO: null,
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
            status: BlocStatus.UNLOADING, request: CallBackType.RUN_CALLBACK));
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.UNLOADING,
            request: CallBackType.RUN_ERROR,
            msg: ErrorUtils.instance.getErrorMessage(result.message),
          ),
        );
      }
    }
  }
}
