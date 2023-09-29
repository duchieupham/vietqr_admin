import 'package:equatable/equatable.dart';
import 'package:vietqr_admin/models/active_fee_dto.dart';

class ActiveFeeState extends Equatable {
  const ActiveFeeState();

  @override
  List<Object?> get props => [];
}

class ActiveFeeInitialState extends ActiveFeeState {}

class ActiveFeeLoadingInitState extends ActiveFeeState {}

class ActiveFeeLoadingState extends ActiveFeeState {}

class ActiveFeeGetListSuccessState extends ActiveFeeState {
  final List<ActiveFeeDTO> result;
  final bool initPage;
  final bool isLoadMore;
  const ActiveFeeGetListSuccessState(
      {required this.result, this.initPage = false, this.isLoadMore = false});

  @override
  List<Object?> get props => [result];
}
