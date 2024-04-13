import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/top_up_phone/event/top_up_phone_event.dart';
import 'package:vietqr_admin/feature/top_up_phone/responsitory/top_up_phone_provider.dart';
import 'package:vietqr_admin/feature/top_up_phone/state/top_up_phone_state.dart';

import '../../../models/DTO/qr_code_dto.dart';
import '../../../models/DTO/transaction_vnpt_dto.dart';
import '../../../models/DTO/vnpt_transaction_static.dart';

class TopUpPhoneBloc extends Bloc<TopUpPhoneEvent, TopUpPhoneState> {
  TopUpPhoneBloc() : super(TopUpPhoneInitialState()) {
    on<GetTransactionListEvent>(_getListTransactionPack);
    on<CreateQrEvent>(_createQrPack);
    on<GetTransactionStaticEvent>(_getTransactionStatic);
  }
}

const TopUpPhoneRepository topUpPhoneRepository = TopUpPhoneRepository();

void _getListTransactionPack(TopUpPhoneEvent event, Emitter emit) async {
  List<TransactionVNPTDTO> result = [];
  VNPTTransactionStaticDTO transactionStaticDTO =
      const VNPTTransactionStaticDTO();
  try {
    if (event is GetTransactionListEvent) {
      if (event.isLoadMore) {
        emit(TopUpPhoneLoadingLoadMoreState());
      } else {
        emit(TopUpPhoneLoadingGetListState());
      }
      result = await topUpPhoneRepository.getListTransactionVNPT(
          event.status, event.offset);
      if (event.initPage) {
        transactionStaticDTO =
            await topUpPhoneRepository.getTransactionStatic();
      }

      emit(TopUpPhoneGetListTransactionSuccessState(
          result: result,
          initPage: event.initPage,
          transactionStaticDTO: transactionStaticDTO,
          isLoadMore: event.isLoadMore));
    }
  } catch (e) {
    print('Error at  _getListTransactionPack: $e');
    emit(const TopUpPhoneGetListTransactionSuccessState(
        result: [], transactionStaticDTO: VNPTTransactionStaticDTO()));
  }
}

void _createQrPack(TopUpPhoneEvent event, Emitter emit) async {
  QRCodeTDTO result = const QRCodeTDTO();
  try {
    if (event is CreateQrEvent) {
      emit(TopUpPhoneLoadingState());
      result = await topUpPhoneRepository.createQr(event.amount);
      emit(TopUpPhoneCreateQRSuccessState(qrCodeTDTO: result));
    }
  } catch (e) {
    print('Error at _createQrPack: $e');
    emit(TopUpPhoneCreateQRSuccessState(qrCodeTDTO: result));
  }
}

void _getTransactionStatic(TopUpPhoneEvent event, Emitter emit) async {
  VNPTTransactionStaticDTO result = const VNPTTransactionStaticDTO();
  try {
    if (event is GetTransactionStaticEvent) {
      result = await topUpPhoneRepository.getTransactionStatic();
      emit(TopUpPhoneGetStaticSuccessState(transactionStaticDTO: result));
    }
  } catch (e) {
    print('Error at _getTransactionStatic: $e');
    emit(TopUpPhoneGetStaticSuccessState(transactionStaticDTO: result));
  }
}
