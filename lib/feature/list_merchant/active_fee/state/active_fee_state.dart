import 'package:equatable/equatable.dart';

import '../../../../models/DTO/active_fee_dto.dart';
import '../../../../models/DTO/active_fee_total_static.dart';

class ActiveFeeState extends Equatable {
  const ActiveFeeState();

  @override
  List<Object?> get props => [];
}

class ActiveFeeInitialState extends ActiveFeeState {}

class ActiveFeeLoadingInitState extends ActiveFeeState {}

class ActiveFeeLoadingState extends ActiveFeeState {}

class ActiveFeeGetListSuccessState extends ActiveFeeState {
  final ActiveFeeDTO result;
  final bool initPage;
  final bool isLoadMore;
  final ActiveFeeStaticDto activeFeeStaticDto;
  const ActiveFeeGetListSuccessState(
      {required this.result,
      this.initPage = false,
      this.isLoadMore = false,
      required this.activeFeeStaticDto});

  @override
  List<Object?> get props => [result];
}

class ActiveFeeGetTotalSuccessState extends ActiveFeeState {
  final ActiveFeeStaticDto activeFeeStaticDto;
  const ActiveFeeGetTotalSuccessState({required this.activeFeeStaticDto});

  @override
  List<Object?> get props => [activeFeeStaticDto];
}
